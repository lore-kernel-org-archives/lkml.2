Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab1HSEpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 00:45:46 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49613 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab1HSEpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 00:45:40 -0400
Date: Fri, 19 Aug 2011 00:45:39 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20110819044539.GA1657@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) avoid a vendor ATAPI device, where memory corruption is seen on
   that device + pata_via

2) new freescale PATA driver pata_imx

3) two fixes for minor bugs

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig          |    9 ++
 drivers/ata/Makefile         |    1 +
 drivers/ata/pata_imx.c       |  253 ++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/pata_via.c       |   18 +++
 drivers/ata/sata_dwc_460ex.c |   14 +--
 drivers/ata/sata_sil.c       |    2 +-
 6 files changed, 288 insertions(+), 9 deletions(-)
 create mode 100644 drivers/ata/pata_imx.c

Arnaud Patard (1):
      ata: Add iMX pata support

Jeff Garzik (1):
      [libata] sata_sil: fix used-uninit warning

Julia Lawall (1):
      drivers/ata/sata_dwc_460ex.c: add missing kfree

Tejun Heo (1):
      pata_via: disable ATAPI DMA on AVERATEC 3200

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index ca3e6be..5987e0b 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -468,6 +468,15 @@ config PATA_ICSIDE
 	  interface card.  This is not required for ICS partition support.
 	  If you are unsure, say N to this.
 
+config PATA_IMX
+	tristate "PATA support for Freescale iMX"
+	depends on ARCH_MXC
+	help
+	  This option enables support for the PATA host available on Freescale
+          iMX SoCs.
+
+	  If unsure, say N.
+
 config PATA_IT8213
 	tristate "IT8213 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 8ac64e1..9550d69 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_PATA_HPT37X)	+= pata_hpt37x.o
 obj-$(CONFIG_PATA_HPT3X2N)	+= pata_hpt3x2n.o
 obj-$(CONFIG_PATA_HPT3X3)	+= pata_hpt3x3.o
 obj-$(CONFIG_PATA_ICSIDE)	+= pata_icside.o
+obj-$(CONFIG_PATA_IMX)		+= pata_imx.o
 obj-$(CONFIG_PATA_IT8213)	+= pata_it8213.o
 obj-$(CONFIG_PATA_IT821X)	+= pata_it821x.o
 obj-$(CONFIG_PATA_JMICRON)	+= pata_jmicron.o
diff --git a/drivers/ata/pata_imx.c b/drivers/ata/pata_imx.c
new file mode 100644
index 0000000..ca9d9ca
--- /dev/null
+++ b/drivers/ata/pata_imx.c
@@ -0,0 +1,253 @@
+/*
+ * Freescale iMX PATA driver
+ *
+ * Copyright (C) 2011 Arnaud Patard <arnaud.patard@rtp-net.org>
+ *
+ * Based on pata_platform - Copyright (C) 2006 - 2007  Paul Mundt
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * TODO:
+ * - dmaengine support
+ * - check if timing stuff needed
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <scsi/scsi_host.h>
+#include <linux/ata.h>
+#include <linux/libata.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+
+#define DRV_NAME "pata_imx"
+
+#define PATA_IMX_ATA_CONTROL		0x24
+#define PATA_IMX_ATA_CTRL_FIFO_RST_B	(1<<7)
+#define PATA_IMX_ATA_CTRL_ATA_RST_B	(1<<6)
+#define PATA_IMX_ATA_CTRL_IORDY_EN	(1<<0)
+#define PATA_IMX_ATA_INT_EN		0x2C
+#define PATA_IMX_ATA_INTR_ATA_INTRQ2	(1<<3)
+#define PATA_IMX_DRIVE_DATA		0xA0
+#define PATA_IMX_DRIVE_CONTROL		0xD8
+
+struct pata_imx_priv {
+	struct clk *clk;
+	/* timings/interrupt/control regs */
+	u8 *host_regs;
+	u32 ata_ctl;
+};
+
+static int pata_imx_set_mode(struct ata_link *link, struct ata_device **unused)
+{
+	struct ata_device *dev;
+	struct ata_port *ap = link->ap;
+	struct pata_imx_priv *priv = ap->host->private_data;
+	u32 val;
+
+	ata_for_each_dev(dev, link, ENABLED) {
+		dev->pio_mode = dev->xfer_mode = XFER_PIO_0;
+		dev->xfer_shift = ATA_SHIFT_PIO;
+		dev->flags |= ATA_DFLAG_PIO;
+
+		val = __raw_readl(priv->host_regs + PATA_IMX_ATA_CONTROL);
+		if (ata_pio_need_iordy(dev))
+			val |= PATA_IMX_ATA_CTRL_IORDY_EN;
+		else
+			val &= ~PATA_IMX_ATA_CTRL_IORDY_EN;
+		__raw_writel(val, priv->host_regs + PATA_IMX_ATA_CONTROL);
+
+		ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+	}
+	return 0;
+}
+
+static struct scsi_host_template pata_imx_sht = {
+	ATA_PIO_SHT(DRV_NAME),
+};
+
+static struct ata_port_operations pata_imx_port_ops = {
+	.inherits		= &ata_sff_port_ops,
+	.sff_data_xfer		= ata_sff_data_xfer_noirq,
+	.cable_detect		= ata_cable_unknown,
+	.set_mode		= pata_imx_set_mode,
+};
+
+static void pata_imx_setup_port(struct ata_ioports *ioaddr)
+{
+	/* Fixup the port shift for platforms that need it */
+	ioaddr->data_addr	= ioaddr->cmd_addr + (ATA_REG_DATA    << 2);
+	ioaddr->error_addr	= ioaddr->cmd_addr + (ATA_REG_ERR     << 2);
+	ioaddr->feature_addr	= ioaddr->cmd_addr + (ATA_REG_FEATURE << 2);
+	ioaddr->nsect_addr	= ioaddr->cmd_addr + (ATA_REG_NSECT   << 2);
+	ioaddr->lbal_addr	= ioaddr->cmd_addr + (ATA_REG_LBAL    << 2);
+	ioaddr->lbam_addr	= ioaddr->cmd_addr + (ATA_REG_LBAM    << 2);
+	ioaddr->lbah_addr	= ioaddr->cmd_addr + (ATA_REG_LBAH    << 2);
+	ioaddr->device_addr	= ioaddr->cmd_addr + (ATA_REG_DEVICE  << 2);
+	ioaddr->status_addr	= ioaddr->cmd_addr + (ATA_REG_STATUS  << 2);
+	ioaddr->command_addr	= ioaddr->cmd_addr + (ATA_REG_CMD     << 2);
+}
+
+static int __devinit pata_imx_probe(struct platform_device *pdev)
+{
+	struct ata_host *host;
+	struct ata_port *ap;
+	struct pata_imx_priv *priv;
+	int irq = 0;
+	struct resource *io_res;
+
+	io_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (io_res == NULL)
+		return -EINVAL;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0)
+		return -EINVAL;
+
+	priv = devm_kzalloc(&pdev->dev,
+				sizeof(struct pata_imx_priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(priv->clk)) {
+		dev_err(&pdev->dev, "Failed to get clock\n");
+		return PTR_ERR(priv->clk);
+	}
+
+	clk_enable(priv->clk);
+
+	host = ata_host_alloc(&pdev->dev, 1);
+	if (!host)
+		goto free_priv;
+
+	host->private_data = priv;
+	ap = host->ports[0];
+
+	ap->ops = &pata_imx_port_ops;
+	ap->pio_mask = ATA_PIO0;
+	ap->flags |= ATA_FLAG_SLAVE_POSS;
+
+	priv->host_regs = devm_ioremap(&pdev->dev, io_res->start,
+		resource_size(io_res));
+	if (!priv->host_regs) {
+		dev_err(&pdev->dev, "failed to map IO/CTL base\n");
+		goto free_priv;
+	}
+
+	ap->ioaddr.cmd_addr = priv->host_regs + PATA_IMX_DRIVE_DATA;
+	ap->ioaddr.ctl_addr = priv->host_regs + PATA_IMX_DRIVE_CONTROL;
+
+	ap->ioaddr.altstatus_addr = ap->ioaddr.ctl_addr;
+
+	pata_imx_setup_port(&ap->ioaddr);
+
+	ata_port_desc(ap, "cmd 0x%llx ctl 0x%llx",
+		(unsigned long long)io_res->start + PATA_IMX_DRIVE_DATA,
+		(unsigned long long)io_res->start + PATA_IMX_DRIVE_CONTROL);
+
+	/* deassert resets */
+	__raw_writel(PATA_IMX_ATA_CTRL_FIFO_RST_B |
+			PATA_IMX_ATA_CTRL_ATA_RST_B,
+			priv->host_regs + PATA_IMX_ATA_CONTROL);
+	/* enable interrupts */
+	__raw_writel(PATA_IMX_ATA_INTR_ATA_INTRQ2,
+			priv->host_regs + PATA_IMX_ATA_INT_EN);
+
+	/* activate */
+	return ata_host_activate(host, irq, ata_sff_interrupt, 0,
+				&pata_imx_sht);
+
+free_priv:
+	clk_disable(priv->clk);
+	clk_put(priv->clk);
+	return -ENOMEM;
+}
+
+static int __devexit pata_imx_remove(struct platform_device *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct pata_imx_priv *priv = host->private_data;
+
+	ata_host_detach(host);
+
+	__raw_writel(0, priv->host_regs + PATA_IMX_ATA_INT_EN);
+
+	clk_disable(priv->clk);
+	clk_put(priv->clk);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int pata_imx_suspend(struct device *dev)
+{
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct pata_imx_priv *priv = host->private_data;
+	int ret;
+
+	ret = ata_host_suspend(host, PMSG_SUSPEND);
+	if (!ret) {
+		__raw_writel(0, priv->host_regs + PATA_IMX_ATA_INT_EN);
+		priv->ata_ctl =
+			__raw_readl(priv->host_regs + PATA_IMX_ATA_CONTROL);
+		clk_disable(priv->clk);
+	}
+
+	return ret;
+}
+
+static int pata_imx_resume(struct device *dev)
+{
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct pata_imx_priv *priv = host->private_data;
+
+	clk_enable(priv->clk);
+
+	__raw_writel(priv->ata_ctl, priv->host_regs + PATA_IMX_ATA_CONTROL);
+
+	__raw_writel(PATA_IMX_ATA_INTR_ATA_INTRQ2,
+			priv->host_regs + PATA_IMX_ATA_INT_EN);
+
+	ata_host_resume(host);
+
+	return 0;
+}
+
+static const struct dev_pm_ops pata_imx_pm_ops = {
+	.suspend	= pata_imx_suspend,
+	.resume		= pata_imx_resume,
+};
+#endif
+
+static struct platform_driver pata_imx_driver = {
+	.probe		= pata_imx_probe,
+	.remove		= __devexit_p(pata_imx_remove),
+	.driver = {
+		.name		= DRV_NAME,
+		.owner		= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm		= &pata_imx_pm_ops,
+#endif
+	},
+};
+
+static int __init pata_imx_init(void)
+{
+	return platform_driver_register(&pata_imx_driver);
+}
+
+static void __exit pata_imx_exit(void)
+{
+	platform_driver_unregister(&pata_imx_driver);
+}
+module_init(pata_imx_init);
+module_exit(pata_imx_exit);
+
+MODULE_AUTHOR("Arnaud Patard <arnaud.patard@rtp-net.org>");
+MODULE_DESCRIPTION("low-level driver for iMX PATA");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRV_NAME);
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 65e4be6..8e9f504 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -124,6 +124,17 @@ static const struct via_isa_bridge {
 	{ NULL }
 };
 
+static const struct dmi_system_id no_atapi_dma_dmi_table[] = {
+	{
+		.ident = "AVERATEC 3200",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AVERATEC"),
+			DMI_MATCH(DMI_BOARD_NAME, "3200"),
+		},
+	},
+	{ }
+};
+
 struct via_port {
 	u8 cached_device;
 };
@@ -355,6 +366,13 @@ static unsigned long via_mode_filter(struct ata_device *dev, unsigned long mask)
 			mask &= ~ ATA_MASK_UDMA;
 		}
 	}
+
+	if (dev->class == ATA_DEV_ATAPI &&
+	    dmi_check_system(no_atapi_dma_dmi_table)) {
+		ata_dev_warn(dev, "controller locks up on ATAPI DMA, forcing PIO\n");
+		mask &= ATA_MASK_PIO;
+	}
+
 	return mask;
 }
 
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 0a9a774..5c42374 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1329,7 +1329,7 @@ static int sata_dwc_port_start(struct ata_port *ap)
 			dev_err(ap->dev, "%s: dma_alloc_coherent failed\n",
 				 __func__);
 			err = -ENOMEM;
-			goto CLEANUP;
+			goto CLEANUP_ALLOC;
 		}
 	}
 
@@ -1349,15 +1349,13 @@ static int sata_dwc_port_start(struct ata_port *ap)
 	/* Clear any error bits before libata starts issuing commands */
 	clear_serror();
 	ap->private_data = hsdevp;
+	dev_dbg(ap->dev, "%s: done\n", __func__);
+	return 0;
 
+CLEANUP_ALLOC:
+	kfree(hsdevp);
 CLEANUP:
-	if (err) {
-		sata_dwc_port_stop(ap);
-		dev_dbg(ap->dev, "%s: fail\n", __func__);
-	} else {
-		dev_dbg(ap->dev, "%s: done\n", __func__);
-	}
-
+	dev_dbg(ap->dev, "%s: fail. ap->id = %d\n", __func__, ap->print_id);
 	return err;
 }
 
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 98c1d78..9dfb40b 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -438,7 +438,7 @@ static void sil_host_intr(struct ata_port *ap, u32 bmdma2)
 	u8 status;
 
 	if (unlikely(bmdma2 & SIL_DMA_SATA_IRQ)) {
-		u32 serror;
+		u32 serror = 0xffffffff;
 
 		/* SIEN doesn't mask SATA IRQs on some 3112s.  Those
 		 * controllers continue to assert IRQ as long as
