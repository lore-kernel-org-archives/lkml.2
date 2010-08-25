Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab0HYXcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:32:17 -0400
Received: from havoc.gtf.org ([69.61.125.42]:46199 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab0HYXcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:32:16 -0400
Date: Wed, 25 Aug 2010 19:32:12 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20100825233212.GA28367@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Note that the pata_winbond change really is a fix.  See
http://marc.info/?t=128084945700004&r=1&w=2 for details and original bug
report from Dan Carpenter.  The change updates pata_legacy to support
winbond.

The rest are mostly tiny patches as befitting -rc.  sata_mv apparently
needs special handling for the DSM (aka TRIM) command, in addition to
needing an its-broken fix in libata-core.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig          |    1 +
 drivers/ata/Makefile         |    1 -
 drivers/ata/ahci.c           |   11 ++
 drivers/ata/ahci.h           |    1 +
 drivers/ata/libahci.c        |   16 ++-
 drivers/ata/libata-core.c    |   11 +-
 drivers/ata/libata-sff.c     |    4 -
 drivers/ata/pata_cmd64x.c    |    6 -
 drivers/ata/pata_legacy.c    |   15 ++-
 drivers/ata/pata_winbond.c   |  282 ------------------------------------------
 drivers/ata/sata_dwc_460ex.c |    2 +-
 drivers/ata/sata_mv.c        |   44 ++++++-
 12 files changed, 85 insertions(+), 309 deletions(-)
 delete mode 100644 drivers/ata/pata_winbond.c

Bartlomiej Zolnierkiewicz (1):
      libata: remove no longer needed pata_winbond driver

Dan Carpenter (1):
      [libata] sata_dwc_460ex: signdness bug

Mark Lord (2):
      sata_mv: fix broken DSM/TRIM support (v2)
      libata-sff: remove harmful BUG_ON from ata_bmdma_qc_issue

Tejun Heo (3):
      pata_cmd64x: revert commit d62f5576
      ahci: add HFLAG_YES_FBS and apply it to 88SE9128
      libata: be less of a drama queen on empty data commands

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 65e3e27..11ec911 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -828,6 +828,7 @@ config PATA_SAMSUNG_CF
 config PATA_WINBOND_VLB
 	tristate "Winbond W83759A VLB PATA support (Experimental)"
 	depends on ISA && EXPERIMENTAL
+	select PATA_LEGACY
 	help
 	  Support for the Winbond W83759A controller on Vesa Local Bus
 	  systems.
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 158eaa9..d5df04a 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -89,7 +89,6 @@ obj-$(CONFIG_PATA_QDI)		+= pata_qdi.o
 obj-$(CONFIG_PATA_RB532)	+= pata_rb532_cf.o
 obj-$(CONFIG_PATA_RZ1000)	+= pata_rz1000.o
 obj-$(CONFIG_PATA_SAMSUNG_CF)	+= pata_samsung_cf.o
-obj-$(CONFIG_PATA_WINBOND_VLB)	+= pata_winbond.o
 
 obj-$(CONFIG_PATA_PXA)		+= pata_pxa.o
 
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index fe75d8b..013727b 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -60,6 +60,7 @@ enum board_ids {
 	board_ahci,
 	board_ahci_ign_iferr,
 	board_ahci_nosntf,
+	board_ahci_yes_fbs,
 
 	/* board IDs for specific chipsets in alphabetical order */
 	board_ahci_mcp65,
@@ -132,6 +133,14 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
+	[board_ahci_yes_fbs] =
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_YES_FBS),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 	/* by chipsets */
 	[board_ahci_mcp65] =
 	{
@@ -362,6 +371,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	/* Marvell */
 	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
 	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
+	{ PCI_DEVICE(0x1b4b, 0x9123),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9128 */
 
 	/* Promise */
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 7113c57..474427b 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -209,6 +209,7 @@ enum {
 							link offline */
 	AHCI_HFLAG_NO_SNTF		= (1 << 12), /* no sntf */
 	AHCI_HFLAG_NO_FPDMA_AA		= (1 << 13), /* no FPDMA AA */
+	AHCI_HFLAG_YES_FBS		= (1 << 14), /* force FBS cap on */
 
 	/* ap->flags bits */
 
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 81e772a..666850d 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -430,6 +430,12 @@ void ahci_save_initial_config(struct device *dev,
 		cap &= ~HOST_CAP_SNTF;
 	}
 
+	if (!(cap & HOST_CAP_FBS) && (hpriv->flags & AHCI_HFLAG_YES_FBS)) {
+		dev_printk(KERN_INFO, dev,
+			   "controller can do FBS, turning on CAP_FBS\n");
+		cap |= HOST_CAP_FBS;
+	}
+
 	if (force_port_map && port_map != force_port_map) {
 		dev_printk(KERN_INFO, dev, "forcing port_map 0x%x -> 0x%x\n",
 			   port_map, force_port_map);
@@ -2036,9 +2042,15 @@ static int ahci_port_start(struct ata_port *ap)
 		u32 cmd = readl(port_mmio + PORT_CMD);
 		if (cmd & PORT_CMD_FBSCP)
 			pp->fbs_supported = true;
-		else
+		else if (hpriv->flags & AHCI_HFLAG_YES_FBS) {
+			dev_printk(KERN_INFO, dev,
+				   "port %d can do FBS, forcing FBSCP\n",
+				   ap->port_no);
+			pp->fbs_supported = true;
+		} else
 			dev_printk(KERN_WARNING, dev,
-				   "The port is not capable of FBS\n");
+				   "port %d is not capable of FBS\n",
+				   ap->port_no);
 	}
 
 	if (pp->fbs_supported) {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 7ef7c4f..c035b3d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5111,15 +5111,18 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 	qc->flags |= ATA_QCFLAG_ACTIVE;
 	ap->qc_active |= 1 << qc->tag;
 
-	/* We guarantee to LLDs that they will have at least one
+	/*
+	 * We guarantee to LLDs that they will have at least one
 	 * non-zero sg if the command is a data command.
 	 */
-	BUG_ON(ata_is_data(prot) && (!qc->sg || !qc->n_elem || !qc->nbytes));
+	if (WARN_ON_ONCE(ata_is_data(prot) &&
+			 (!qc->sg || !qc->n_elem || !qc->nbytes)))
+		goto sys_err;
 
 	if (ata_is_dma(prot) || (ata_is_pio(prot) &&
 				 (ap->flags & ATA_FLAG_PIO_DMA)))
 		if (ata_sg_setup(qc))
-			goto sg_err;
+			goto sys_err;
 
 	/* if device is sleeping, schedule reset and abort the link */
 	if (unlikely(qc->dev->flags & ATA_DFLAG_SLEEPING)) {
@@ -5136,7 +5139,7 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 		goto err;
 	return;
 
-sg_err:
+sys_err:
 	qc->err_mask |= AC_ERR_SYSTEM;
 err:
 	ata_qc_complete(qc);
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 674c143..3b82d8e 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2735,10 +2735,6 @@ unsigned int ata_bmdma_qc_issue(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 
-	/* see ata_dma_blacklisted() */
-	BUG_ON((ap->flags & ATA_FLAG_PIO_POLLING) &&
-	       qc->tf.protocol == ATAPI_PROT_DMA);
-
 	/* defer PIO handling to sff_qc_issue */
 	if (!ata_is_dma(qc->tf.protocol))
 		return ata_sff_qc_issue(qc);
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 9f5da1c..905ff76 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -121,14 +121,8 @@ static void cmd64x_set_timing(struct ata_port *ap, struct ata_device *adev, u8 m
 
 		if (pair) {
 			struct ata_timing tp;
-
 			ata_timing_compute(pair, pair->pio_mode, &tp, T, 0);
 			ata_timing_merge(&t, &tp, &t, ATA_TIMING_SETUP);
-			if (pair->dma_mode) {
-				ata_timing_compute(pair, pair->dma_mode,
-						&tp, T, 0);
-				ata_timing_merge(&tp, &t, &t, ATA_TIMING_SETUP);
-			}
 		}
 	}
 
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 9df1ff7..eaf1941 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -44,6 +44,9 @@
  *  Specific support is included for the ht6560a/ht6560b/opti82c611a/
  *  opti82c465mv/promise 20230c/20630/qdi65x0/winbond83759A
  *
+ *  Support for the Winbond 83759A when operating in advanced mode.
+ *  Multichip mode is not currently supported.
+ *
  *  Use the autospeed and pio_mask options with:
  *	Appian ADI/2 aka CLPD7220 or AIC25VL01.
  *  Use the jumpers, autospeed and set pio_mask to the mode on the jumpers with
@@ -135,12 +138,18 @@ static int ht6560b;		/* HT 6560A on primary 1, second 2, both 3 */
 static int opti82c611a;		/* Opti82c611A on primary 1, sec 2, both 3 */
 static int opti82c46x;		/* Opti 82c465MV present(pri/sec autodetect) */
 static int qdi;			/* Set to probe QDI controllers */
-static int winbond;		/* Set to probe Winbond controllers,
-					give I/O port if non standard */
 static int autospeed;		/* Chip present which snoops speed changes */
 static int pio_mask = ATA_PIO4;	/* PIO range for autospeed devices */
 static int iordy_mask = 0xFFFFFFFF;	/* Use iordy if available */
 
+#ifdef PATA_WINBOND_VLB_MODULE
+static int winbond = 1;		/* Set to probe Winbond controllers,
+					give I/O port if non standard */
+#else
+static int winbond;		/* Set to probe Winbond controllers,
+					give I/O port if non standard */
+#endif
+
 /**
  *	legacy_probe_add	-	Add interface to probe list
  *	@port: Controller port
@@ -1297,6 +1306,7 @@ MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("low-level driver for legacy ATA");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("pata_winbond");
 
 module_param(probe_all, int, 0);
 module_param(autospeed, int, 0);
@@ -1305,6 +1315,7 @@ module_param(ht6560b, int, 0);
 module_param(opti82c611a, int, 0);
 module_param(opti82c46x, int, 0);
 module_param(qdi, int, 0);
+module_param(winbond, int, 0);
 module_param(pio_mask, int, 0);
 module_param(iordy_mask, int, 0);
 
diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
deleted file mode 100644
index 6d8619b..0000000
--- a/drivers/ata/pata_winbond.c
+++ /dev/null
@@ -1,282 +0,0 @@
-/*
- *    pata_winbond.c - Winbond VLB ATA controllers
- *	(C) 2006 Red Hat
- *
- *    Support for the Winbond 83759A when operating in advanced mode.
- *    Multichip mode is not currently supported.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/blkdev.h>
-#include <linux/delay.h>
-#include <scsi/scsi_host.h>
-#include <linux/libata.h>
-#include <linux/platform_device.h>
-
-#define DRV_NAME "pata_winbond"
-#define DRV_VERSION "0.0.3"
-
-#define NR_HOST 4	/* Two winbond controllers, two channels each */
-
-struct winbond_data {
-	unsigned long config;
-	struct platform_device *platform_dev;
-};
-
-static struct ata_host *winbond_host[NR_HOST];
-static struct winbond_data winbond_data[NR_HOST];
-static int nr_winbond_host;
-
-#ifdef MODULE
-static int probe_winbond = 1;
-#else
-static int probe_winbond;
-#endif
-
-static DEFINE_SPINLOCK(winbond_lock);
-
-static void winbond_writecfg(unsigned long port, u8 reg, u8 val)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&winbond_lock, flags);
-	outb(reg, port + 0x01);
-	outb(val, port + 0x02);
-	spin_unlock_irqrestore(&winbond_lock, flags);
-}
-
-static u8 winbond_readcfg(unsigned long port, u8 reg)
-{
-	u8 val;
-
-	unsigned long flags;
-	spin_lock_irqsave(&winbond_lock, flags);
-	outb(reg, port + 0x01);
-	val = inb(port + 0x02);
-	spin_unlock_irqrestore(&winbond_lock, flags);
-
-	return val;
-}
-
-static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	struct ata_timing t;
-	struct winbond_data *winbond = ap->host->private_data;
-	int active, recovery;
-	u8 reg;
-	int timing = 0x88 + (ap->port_no * 4) + (adev->devno * 2);
-
-	reg = winbond_readcfg(winbond->config, 0x81);
-
-	/* Get the timing data in cycles */
-	if (reg & 0x40)		/* Fast VLB bus, assume 50MHz */
-		ata_timing_compute(adev, adev->pio_mode, &t, 20000, 1000);
-	else
-		ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
-
-	active = (clamp_val(t.active, 3, 17) - 1) & 0x0F;
-	recovery = (clamp_val(t.recover, 1, 15) + 1) & 0x0F;
-	timing = (active << 4) | recovery;
-	winbond_writecfg(winbond->config, timing, reg);
-
-	/* Load the setup timing */
-
-	reg = 0x35;
-	if (adev->class != ATA_DEV_ATA)
-		reg |= 0x08;	/* FIFO off */
-	if (!ata_pio_need_iordy(adev))
-		reg |= 0x02;	/* IORDY off */
-	reg |= (clamp_val(t.setup, 0, 3) << 6);
-	winbond_writecfg(winbond->config, timing + 1, reg);
-}
-
-
-static unsigned int winbond_data_xfer(struct ata_device *dev,
-			unsigned char *buf, unsigned int buflen, int rw)
-{
-	struct ata_port *ap = dev->link->ap;
-	int slop = buflen & 3;
-
-	if (ata_id_has_dword_io(dev->id)) {
-		if (rw == READ)
-			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
-		else
-			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
-
-		if (unlikely(slop)) {
-			__le32 pad;
-			if (rw == READ) {
-				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
-				memcpy(buf + buflen - slop, &pad, slop);
-			} else {
-				memcpy(&pad, buf + buflen - slop, slop);
-				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
-			}
-			buflen += 4 - slop;
-		}
-	} else
-		buflen = ata_sff_data_xfer(dev, buf, buflen, rw);
-
-	return buflen;
-}
-
-static struct scsi_host_template winbond_sht = {
-	ATA_PIO_SHT(DRV_NAME),
-};
-
-static struct ata_port_operations winbond_port_ops = {
-	.inherits	= &ata_sff_port_ops,
-	.sff_data_xfer	= winbond_data_xfer,
-	.cable_detect	= ata_cable_40wire,
-	.set_piomode	= winbond_set_piomode,
-};
-
-/**
- *	winbond_init_one		-	attach a winbond interface
- *	@type: Type to display
- *	@io: I/O port start
- *	@irq: interrupt line
- *	@fast: True if on a > 33Mhz VLB
- *
- *	Register a VLB bus IDE interface. Such interfaces are PIO and we
- *	assume do not support IRQ sharing.
- */
-
-static __init int winbond_init_one(unsigned long port)
-{
-	struct platform_device *pdev;
-	u8 reg;
-	int i, rc;
-
-	reg = winbond_readcfg(port, 0x81);
-	reg |= 0x80;	/* jumpered mode off */
-	winbond_writecfg(port, 0x81, reg);
-	reg = winbond_readcfg(port, 0x83);
-	reg |= 0xF0;	/* local control */
-	winbond_writecfg(port, 0x83, reg);
-	reg = winbond_readcfg(port, 0x85);
-	reg |= 0xF0;	/* programmable timing */
-	winbond_writecfg(port, 0x85, reg);
-
-	reg = winbond_readcfg(port, 0x81);
-
-	if (!(reg & 0x03))		/* Disabled */
-		return -ENODEV;
-
-	for (i = 0; i < 2 ; i ++) {
-		unsigned long cmd_port = 0x1F0 - (0x80 * i);
-		unsigned long ctl_port = cmd_port + 0x206;
-		struct ata_host *host;
-		struct ata_port *ap;
-		void __iomem *cmd_addr, *ctl_addr;
-
-		if (!(reg & (1 << i)))
-			continue;
-
-		pdev = platform_device_register_simple(DRV_NAME, nr_winbond_host, NULL, 0);
-		if (IS_ERR(pdev))
-			return PTR_ERR(pdev);
-
-		rc = -ENOMEM;
-		host = ata_host_alloc(&pdev->dev, 1);
-		if (!host)
-			goto err_unregister;
-		ap = host->ports[0];
-
-		rc = -ENOMEM;
-		cmd_addr = devm_ioport_map(&pdev->dev, cmd_port, 8);
-		ctl_addr = devm_ioport_map(&pdev->dev, ctl_port, 1);
-		if (!cmd_addr || !ctl_addr)
-			goto err_unregister;
-
-		ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx", cmd_port, ctl_port);
-
-		ap->ops = &winbond_port_ops;
-		ap->pio_mask = ATA_PIO4;
-		ap->flags |= ATA_FLAG_SLAVE_POSS;
-		ap->ioaddr.cmd_addr = cmd_addr;
-		ap->ioaddr.altstatus_addr = ctl_addr;
-		ap->ioaddr.ctl_addr = ctl_addr;
-		ata_sff_std_ports(&ap->ioaddr);
-
-		/* hook in a private data structure per channel */
-		host->private_data = &winbond_data[nr_winbond_host];
-		winbond_data[nr_winbond_host].config = port;
-		winbond_data[nr_winbond_host].platform_dev = pdev;
-
-		/* activate */
-		rc = ata_host_activate(host, 14 + i, ata_sff_interrupt, 0,
-				       &winbond_sht);
-		if (rc)
-			goto err_unregister;
-
-		winbond_host[nr_winbond_host++] = dev_get_drvdata(&pdev->dev);
-	}
-
-	return 0;
-
- err_unregister:
-	platform_device_unregister(pdev);
-	return rc;
-}
-
-/**
- *	winbond_init		-	attach winbond interfaces
- *
- *	Attach winbond IDE interfaces by scanning the ports it may occupy.
- */
-
-static __init int winbond_init(void)
-{
-	static const unsigned long config[2] = { 0x130, 0x1B0 };
-
-	int ct = 0;
-	int i;
-
-	if (probe_winbond == 0)
-		return -ENODEV;
-
-	/*
- 	 *	Check both base addresses
-	 */
-
-	for (i = 0; i < 2; i++) {
-		if (probe_winbond & (1<<i)) {
-			int ret = 0;
-			unsigned long port = config[i];
-
-			if (request_region(port, 2, "pata_winbond")) {
-				ret = winbond_init_one(port);
-				if (ret <= 0)
-					release_region(port, 2);
-				else ct+= ret;
-			}
-		}
-	}
-	if (ct != 0)
-		return 0;
-	return -ENODEV;
-}
-
-static __exit void winbond_exit(void)
-{
-	int i;
-
-	for (i = 0; i < nr_winbond_host; i++) {
-		ata_host_detach(winbond_host[i]);
-		release_region(winbond_data[i].config, 2);
-		platform_device_unregister(winbond_data[i].platform_dev);
-	}
-}
-
-MODULE_AUTHOR("Alan Cox");
-MODULE_DESCRIPTION("low-level driver for Winbond VL ATA");
-MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
-
-module_init(winbond_init);
-module_exit(winbond_exit);
-
-module_param(probe_winbond, int, 0);
-
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 2673a3d..6cf57c5 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1459,7 +1459,7 @@ static void sata_dwc_qc_prep_by_tag(struct ata_queued_cmd *qc, u8 tag)
 {
 	struct scatterlist *sg = qc->sg;
 	struct ata_port *ap = qc->ap;
-	u32 dma_chan;
+	int dma_chan;
 	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
 	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
 	int err;
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 9463c71..8198259 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1898,19 +1898,25 @@ static void mv_bmdma_start(struct ata_queued_cmd *qc)
  *	LOCKING:
  *	Inherited from caller.
  */
-static void mv_bmdma_stop(struct ata_queued_cmd *qc)
+static void mv_bmdma_stop_ap(struct ata_port *ap)
 {
-	struct ata_port *ap = qc->ap;
 	void __iomem *port_mmio = mv_ap_base(ap);
 	u32 cmd;
 
 	/* clear start/stop bit */
 	cmd = readl(port_mmio + BMDMA_CMD);
-	cmd &= ~ATA_DMA_START;
-	writelfl(cmd, port_mmio + BMDMA_CMD);
+	if (cmd & ATA_DMA_START) {
+		cmd &= ~ATA_DMA_START;
+		writelfl(cmd, port_mmio + BMDMA_CMD);
+
+		/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
+		ata_sff_dma_pause(ap);
+	}
+}
 
-	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
-	ata_sff_dma_pause(ap);
+static void mv_bmdma_stop(struct ata_queued_cmd *qc)
+{
+	mv_bmdma_stop_ap(qc->ap);
 }
 
 /**
@@ -1934,8 +1940,21 @@ static u8 mv_bmdma_status(struct ata_port *ap)
 	reg = readl(port_mmio + BMDMA_STATUS);
 	if (reg & ATA_DMA_ACTIVE)
 		status = ATA_DMA_ACTIVE;
-	else
+	else if (reg & ATA_DMA_ERR)
 		status = (reg & ATA_DMA_ERR) | ATA_DMA_INTR;
+	else {
+		/*
+		 * Just because DMA_ACTIVE is 0 (DMA completed),
+		 * this does _not_ mean the device is "done".
+		 * So we should not yet be signalling ATA_DMA_INTR
+		 * in some cases.  Eg. DSM/TRIM, and perhaps others.
+		 */
+		mv_bmdma_stop_ap(ap);
+		if (ioread8(ap->ioaddr.altstatus_addr) & ATA_BUSY)
+			status = 0;
+		else
+			status = ATA_DMA_INTR;
+	}
 	return status;
 }
 
@@ -1995,6 +2014,9 @@ static void mv_qc_prep(struct ata_queued_cmd *qc)
 
 	switch (tf->protocol) {
 	case ATA_PROT_DMA:
+		if (tf->command == ATA_CMD_DSM)
+			return;
+		/* fall-thru */
 	case ATA_PROT_NCQ:
 		break;	/* continue below */
 	case ATA_PROT_PIO:
@@ -2094,6 +2116,8 @@ static void mv_qc_prep_iie(struct ata_queued_cmd *qc)
 	if ((tf->protocol != ATA_PROT_DMA) &&
 	    (tf->protocol != ATA_PROT_NCQ))
 		return;
+	if (tf->command == ATA_CMD_DSM)
+		return;  /* use bmdma for this */
 
 	/* Fill in Gen IIE command request block */
 	if (!(tf->flags & ATA_TFLAG_WRITE))
@@ -2289,6 +2313,12 @@ static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 
 	switch (qc->tf.protocol) {
 	case ATA_PROT_DMA:
+		if (qc->tf.command == ATA_CMD_DSM) {
+			if (!ap->ops->bmdma_setup)  /* no bmdma on GEN_I */
+				return AC_ERR_OTHER;
+			break;  /* use bmdma for this */
+		}
+		/* fall thru */
 	case ATA_PROT_NCQ:
 		mv_start_edma(ap, port_mmio, pp, qc->tf.protocol);
 		pp->req_idx = (pp->req_idx + 1) & MV_MAX_Q_DEPTH_MASK;
