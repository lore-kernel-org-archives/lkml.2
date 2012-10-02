Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab2JBTk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 15:40:59 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33191 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab2JBTky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 15:40:54 -0400
Date: Tue, 2 Oct 2012 15:40:53 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes for 3.7
Message-ID: <20121002194053.GA11100@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull 13b74085d92feda78bad1045516d332a1e9a3407 from
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tags/upstream-linus


to receive the following updates:


Minor libata updates, nothing notable.

1) Apply -- and then revert -- the FUA feature.  Caused
   disk corruption in linux-next, proving it cannot be turned on by
   default.

   Net effect to upstream tree:  zero

2) New AHCI platform driver sata_highbank

3) Improve SCSI MODE SENSE handling; support MODE SELECT

4) AHCI: support aggressive device sleep (power mgmt)

5) sata_fsl: minor fix

6) pata_arasan: clk support


 Documentation/devicetree/bindings/arm/calxeda/combophy.txt |   17 
 Documentation/devicetree/bindings/ata/ahci-platform.txt    |    8 
 Documentation/devicetree/bindings/ata/pata-arasan.txt      |   17 
 arch/arm/boot/dts/highbank.dts                             |   17 
 drivers/ata/Kconfig                                        |    8 
 drivers/ata/Makefile                                       |    1 
 drivers/ata/ahci.h                                         |   16 
 drivers/ata/ahci_platform.c                                |   58 +
 drivers/ata/libahci.c                                      |   97 ++
 drivers/ata/libata-core.c                                  |   32 
 drivers/ata/libata-eh.c                                    |   12 
 drivers/ata/libata-scsi.c                                  |  255 ++++++-
 drivers/ata/libata.h                                       |    2 
 drivers/ata/pata_arasan_cf.c                               |   14 
 drivers/ata/sata_fsl.c                                     |   39 +
 drivers/ata/sata_highbank.c                                |  450 +++++++++++++
 drivers/ata/sata_mv.c                                      |    8 
 include/linux/ata.h                                        |   30 
 include/linux/libata.h                                     |    4 
 19 files changed, 1025 insertions(+), 60 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/calxeda/combophy.txt b/Documentation/devicetree/bindings/arm/calxeda/combophy.txt
new file mode 100644
index 0000000..6622bdb
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/calxeda/combophy.txt
@@ -0,0 +1,17 @@
+Calxeda Highbank Combination Phys for SATA
+
+Properties:
+- compatible : Should be "calxeda,hb-combophy"
+- #phy-cells: Should be 1.
+- reg : Address and size for Combination Phy registers.
+- phydev: device ID for programming the combophy.
+
+Example:
+
+	combophy5: combo-phy@fff5d000 {
+		compatible = "calxeda,hb-combophy";
+		#phy-cells = <1>;
+		reg = <0xfff5d000 0x1000>;
+		phydev = <31>;
+	};
+
diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
index 8bb8a76..147c1f6 100644
--- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
+++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
@@ -8,9 +8,17 @@ Required properties:
 - interrupts        : <interrupt mapping for SATA IRQ>
 - reg               : <registers mapping>
 
+Optional properties:
+- calxeda,port-phys: phandle-combophy and lane assignment, which maps each
+			SATA port to a combophy and a lane within that
+			combophy
+
 Example:
         sata@ffe08000 {
 		compatible = "calxeda,hb-ahci";
                 reg = <0xffe08000 0x1000>;
                 interrupts = <115>;
+		calxeda,port-phys = <&combophy5 0 &combophy0 0 &combophy0 1
+					&combophy0 2 &combophy0 3>;
+
         };
diff --git a/Documentation/devicetree/bindings/ata/pata-arasan.txt b/Documentation/devicetree/bindings/ata/pata-arasan.txt
new file mode 100644
index 0000000..95ec7f8
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/pata-arasan.txt
@@ -0,0 +1,17 @@
+* ARASAN PATA COMPACT FLASH CONTROLLER
+
+Required properties:
+- compatible: "arasan,cf-spear1340"
+- reg: Address range of the CF registers
+- interrupt-parent: Should be the phandle for the interrupt controller
+  that services interrupts for this device
+- interrupt: Should contain the CF interrupt number
+
+Example:
+
+	cf@fc000000 {
+		compatible = "arasan,cf-spear1340";
+		reg = <0xfc000000 0x1000>;
+		interrupt-parent = <&vic1>;
+		interrupts = <12>;
+	};
diff --git a/arch/arm/boot/dts/highbank.dts b/arch/arm/boot/dts/highbank.dts
index 9fecf1a..5204cf7 100644
--- a/arch/arm/boot/dts/highbank.dts
+++ b/arch/arm/boot/dts/highbank.dts
@@ -121,6 +121,9 @@
 			compatible = "calxeda,hb-ahci";
 			reg = <0xffe08000 0x10000>;
 			interrupts = <0 83 4>;
+			calxeda,port-phys = <&combophy5 0 &combophy0 0
+					     &combophy0 1 &combophy0 2
+					     &combophy0 3>;
 		};
 
 		sdhci@ffe0e000 {
@@ -306,5 +309,19 @@
 			reg = <0xfff51000 0x1000>;
 			interrupts = <0 80 4  0 81 4  0 82 4>;
 		};
+
+		combophy0: combo-phy@fff58000 {
+			compatible = "calxeda,hb-combophy";
+			#phy-cells = <1>;
+			reg = <0xfff58000 0x1000>;
+			phydev = <5>;
+		};
+
+		combophy5: combo-phy@fff5d000 {
+			compatible = "calxeda,hb-combophy";
+			#phy-cells = <1>;
+			reg = <0xfff5d000 0x1000>;
+			phydev = <31>;
+		};
 	};
 };
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 27cecd3..e08d322 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -214,6 +214,14 @@ config SATA_DWC_VDEBUG
 	help
 	  This option enables the taskfile dumping and NCQ debugging.
 
+config SATA_HIGHBANK
+	tristate "Calxeda Highbank SATA support"
+	help
+	  This option enables support for the Calxeda Highbank SoC's
+	  onboard SATA.
+
+	  If unsure, say N.
+
 config SATA_MV
 	tristate "Marvell SATA support"
 	help
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index a454a13..9329daf 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_SATA_FSL)		+= sata_fsl.o
 obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
 obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
 obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
+obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
 
 # SFF w/ custom DMA
 obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 57eb1c2..9be4712 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -35,6 +35,7 @@
 #ifndef _AHCI_H
 #define _AHCI_H
 
+#include <linux/clk.h>
 #include <linux/libata.h>
 
 /* Enclosure Management Control */
@@ -115,6 +116,9 @@ enum {
 	HOST_CAP2_BOH		= (1 << 0),  /* BIOS/OS handoff supported */
 	HOST_CAP2_NVMHCI	= (1 << 1),  /* NVMHCI supported */
 	HOST_CAP2_APST		= (1 << 2),  /* Automatic partial to slumber */
+	HOST_CAP2_SDS		= (1 << 3),  /* Support device sleep */
+	HOST_CAP2_SADM		= (1 << 4),  /* Support aggressive DevSlp */
+	HOST_CAP2_DESO		= (1 << 5),  /* DevSlp from slumber only */
 
 	/* registers for each SATA port */
 	PORT_LST_ADDR		= 0x00, /* command list DMA addr */
@@ -133,6 +137,7 @@ enum {
 	PORT_SCR_ACT		= 0x34, /* SATA phy register: SActive */
 	PORT_SCR_NTF		= 0x3c, /* SATA phy register: SNotification */
 	PORT_FBS		= 0x40, /* FIS-based Switching */
+	PORT_DEVSLP		= 0x44, /* device sleep */
 
 	/* PORT_IRQ_{STAT,MASK} bits */
 	PORT_IRQ_COLD_PRES	= (1 << 31), /* cold presence detect */
@@ -186,6 +191,7 @@ enum {
 	PORT_CMD_ICC_PARTIAL	= (0x2 << 28), /* Put i/f in partial state */
 	PORT_CMD_ICC_SLUMBER	= (0x6 << 28), /* Put i/f in slumber state */
 
+	/* PORT_FBS bits */
 	PORT_FBS_DWE_OFFSET	= 16, /* FBS device with error offset */
 	PORT_FBS_ADO_OFFSET	= 12, /* FBS active dev optimization offset */
 	PORT_FBS_DEV_OFFSET	= 8,  /* FBS device to issue offset */
@@ -194,6 +200,15 @@ enum {
 	PORT_FBS_DEC		= (1 << 1), /* FBS device error clear */
 	PORT_FBS_EN		= (1 << 0), /* Enable FBS */
 
+	/* PORT_DEVSLP bits */
+	PORT_DEVSLP_DM_OFFSET	= 25,             /* DITO multiplier offset */
+	PORT_DEVSLP_DM_MASK	= (0xf << 25),    /* DITO multiplier mask */
+	PORT_DEVSLP_DITO_OFFSET	= 15,             /* DITO offset */
+	PORT_DEVSLP_MDAT_OFFSET	= 10,             /* Minimum assertion time */
+	PORT_DEVSLP_DETO_OFFSET	= 2,              /* DevSlp exit timeout */
+	PORT_DEVSLP_DSP		= (1 << 1),       /* DevSlp present */
+	PORT_DEVSLP_ADSE	= (1 << 0),       /* Aggressive DevSlp enable */
+
 	/* hpriv->flags bits */
 
 #define AHCI_HFLAGS(flags)		.private_data	= (void *)(flags)
@@ -302,6 +317,7 @@ struct ahci_host_priv {
 	u32 			em_loc; /* enclosure management location */
 	u32			em_buf_sz;	/* EM buffer size in byte */
 	u32			em_msg_type;	/* EM message type */
+	struct clk		*clk;		/* Only for platforms supporting clk */
 };
 
 extern int ahci_ignore_sss;
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 09728e0..b1ae480 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -12,6 +12,7 @@
  * any later version.
  */
 
+#include <linux/clk.h>
 #include <linux/kernel.h>
 #include <linux/gfp.h>
 #include <linux/module.h>
@@ -118,6 +119,17 @@ static int __init ahci_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	hpriv->clk = clk_get(dev, NULL);
+	if (IS_ERR(hpriv->clk)) {
+		dev_err(dev, "can't get clock\n");
+	} else {
+		rc = clk_prepare_enable(hpriv->clk);
+		if (rc) {
+			dev_err(dev, "clock prepare enable failed");
+			goto free_clk;
+		}
+	}
+
 	/*
 	 * Some platforms might need to prepare for mmio region access,
 	 * which could be done in the following init call. So, the mmio
@@ -127,7 +139,7 @@ static int __init ahci_probe(struct platform_device *pdev)
 	if (pdata && pdata->init) {
 		rc = pdata->init(dev, hpriv->mmio);
 		if (rc)
-			return rc;
+			goto disable_unprepare_clk;
 	}
 
 	ahci_save_initial_config(dev, hpriv,
@@ -153,7 +165,7 @@ static int __init ahci_probe(struct platform_device *pdev)
 	host = ata_host_alloc_pinfo(dev, ppi, n_ports);
 	if (!host) {
 		rc = -ENOMEM;
-		goto err0;
+		goto pdata_exit;
 	}
 
 	host->private_data = hpriv;
@@ -183,7 +195,7 @@ static int __init ahci_probe(struct platform_device *pdev)
 
 	rc = ahci_reset_controller(host);
 	if (rc)
-		goto err0;
+		goto pdata_exit;
 
 	ahci_init_controller(host);
 	ahci_print_info(host, "platform");
@@ -191,12 +203,18 @@ static int __init ahci_probe(struct platform_device *pdev)
 	rc = ata_host_activate(host, irq, ahci_interrupt, IRQF_SHARED,
 			       &ahci_platform_sht);
 	if (rc)
-		goto err0;
+		goto pdata_exit;
 
 	return 0;
-err0:
+pdata_exit:
 	if (pdata && pdata->exit)
 		pdata->exit(dev);
+disable_unprepare_clk:
+	if (!IS_ERR(hpriv->clk))
+		clk_disable_unprepare(hpriv->clk);
+free_clk:
+	if (!IS_ERR(hpriv->clk))
+		clk_put(hpriv->clk);
 	return rc;
 }
 
@@ -205,12 +223,18 @@ static int __devexit ahci_remove(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct ahci_platform_data *pdata = dev_get_platdata(dev);
 	struct ata_host *host = dev_get_drvdata(dev);
+	struct ahci_host_priv *hpriv = host->private_data;
 
 	ata_host_detach(host);
 
 	if (pdata && pdata->exit)
 		pdata->exit(dev);
 
+	if (!IS_ERR(hpriv->clk)) {
+		clk_disable_unprepare(hpriv->clk);
+		clk_put(hpriv->clk);
+	}
+
 	return 0;
 }
 
@@ -245,6 +269,10 @@ static int ahci_suspend(struct device *dev)
 
 	if (pdata && pdata->suspend)
 		return pdata->suspend(dev);
+
+	if (!IS_ERR(hpriv->clk))
+		clk_disable_unprepare(hpriv->clk);
+
 	return 0;
 }
 
@@ -252,18 +280,27 @@ static int ahci_resume(struct device *dev)
 {
 	struct ahci_platform_data *pdata = dev_get_platdata(dev);
 	struct ata_host *host = dev_get_drvdata(dev);
+	struct ahci_host_priv *hpriv = host->private_data;
 	int rc;
 
+	if (!IS_ERR(hpriv->clk)) {
+		rc = clk_prepare_enable(hpriv->clk);
+		if (rc) {
+			dev_err(dev, "clock prepare enable failed");
+			return rc;
+		}
+	}
+
 	if (pdata && pdata->resume) {
 		rc = pdata->resume(dev);
 		if (rc)
-			return rc;
+			goto disable_unprepare_clk;
 	}
 
 	if (dev->power.power_state.event == PM_EVENT_SUSPEND) {
 		rc = ahci_reset_controller(host);
 		if (rc)
-			return rc;
+			goto disable_unprepare_clk;
 
 		ahci_init_controller(host);
 	}
@@ -271,13 +308,18 @@ static int ahci_resume(struct device *dev)
 	ata_host_resume(host);
 
 	return 0;
+
+disable_unprepare_clk:
+	if (!IS_ERR(hpriv->clk))
+		clk_disable_unprepare(hpriv->clk);
+
+	return rc;
 }
 #endif
 
 SIMPLE_DEV_PM_OPS(ahci_pm_ops, ahci_suspend, ahci_resume);
 
 static const struct of_device_id ahci_of_match[] = {
-	{ .compatible = "calxeda,hb-ahci", },
 	{ .compatible = "snps,spear-ahci", },
 	{},
 };
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 555c07a..4201e53 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -45,6 +45,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <linux/libata.h>
 #include "ahci.h"
+#include "libata.h"
 
 static int ahci_skip_host_reset;
 int ahci_ignore_sss;
@@ -76,6 +77,7 @@ static void ahci_qc_prep(struct ata_queued_cmd *qc);
 static int ahci_pmp_qc_defer(struct ata_queued_cmd *qc);
 static void ahci_freeze(struct ata_port *ap);
 static void ahci_thaw(struct ata_port *ap);
+static void ahci_set_aggressive_devslp(struct ata_port *ap, bool sleep);
 static void ahci_enable_fbs(struct ata_port *ap);
 static void ahci_disable_fbs(struct ata_port *ap);
 static void ahci_pmp_attach(struct ata_port *ap);
@@ -193,6 +195,10 @@ module_param(ahci_em_messages, int, 0444);
 MODULE_PARM_DESC(ahci_em_messages,
 	"AHCI Enclosure Management Message control (0 = off, 1 = on)");
 
+int devslp_idle_timeout = 1000;	/* device sleep idle timeout in ms */
+module_param(devslp_idle_timeout, int, 0644);
+MODULE_PARM_DESC(devslp_idle_timeout, "device sleep idle timeout");
+
 static void ahci_enable_ahci(void __iomem *mmio)
 {
 	int i;
@@ -702,6 +708,16 @@ static int ahci_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 		}
 	}
 
+	/* set aggressive device sleep */
+	if ((hpriv->cap2 & HOST_CAP2_SDS) &&
+	    (hpriv->cap2 & HOST_CAP2_SADM) &&
+	    (link->device->flags & ATA_DFLAG_DEVSLP)) {
+		if (policy == ATA_LPM_MIN_POWER)
+			ahci_set_aggressive_devslp(ap, true);
+		else
+			ahci_set_aggressive_devslp(ap, false);
+	}
+
 	if (policy == ATA_LPM_MAX_POWER) {
 		sata_link_scr_lpm(link, policy, false);
 
@@ -1890,6 +1906,81 @@ static void ahci_post_internal_cmd(struct ata_queued_cmd *qc)
 		ahci_kick_engine(ap);
 }
 
+static void ahci_set_aggressive_devslp(struct ata_port *ap, bool sleep)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ata_device *dev = ap->link.device;
+	u32 devslp, dm, dito, mdat, deto;
+	int rc;
+	unsigned int err_mask;
+
+	devslp = readl(port_mmio + PORT_DEVSLP);
+	if (!(devslp & PORT_DEVSLP_DSP)) {
+		dev_err(ap->host->dev, "port does not support device sleep\n");
+		return;
+	}
+
+	/* disable device sleep */
+	if (!sleep) {
+		if (devslp & PORT_DEVSLP_ADSE) {
+			writel(devslp & ~PORT_DEVSLP_ADSE,
+			       port_mmio + PORT_DEVSLP);
+			err_mask = ata_dev_set_feature(dev,
+						       SETFEATURES_SATA_DISABLE,
+						       SATA_DEVSLP);
+			if (err_mask && err_mask != AC_ERR_DEV)
+				ata_dev_warn(dev, "failed to disable DEVSLP\n");
+		}
+		return;
+	}
+
+	/* device sleep was already enabled */
+	if (devslp & PORT_DEVSLP_ADSE)
+		return;
+
+	/* set DITO, MDAT, DETO and enable DevSlp, need to stop engine first */
+	rc = ahci_stop_engine(ap);
+	if (rc)
+		return;
+
+	dm = (devslp & PORT_DEVSLP_DM_MASK) >> PORT_DEVSLP_DM_OFFSET;
+	dito = devslp_idle_timeout / (dm + 1);
+	if (dito > 0x3ff)
+		dito = 0x3ff;
+
+	/* Use the nominal value 10 ms if the read MDAT is zero,
+	 * the nominal value of DETO is 20 ms.
+	 */
+	if (dev->sata_settings[ATA_LOG_DEVSLP_VALID] &
+	    ATA_LOG_DEVSLP_VALID_MASK) {
+		mdat = dev->sata_settings[ATA_LOG_DEVSLP_MDAT] &
+		       ATA_LOG_DEVSLP_MDAT_MASK;
+		if (!mdat)
+			mdat = 10;
+		deto = dev->sata_settings[ATA_LOG_DEVSLP_DETO];
+		if (!deto)
+			deto = 20;
+	} else {
+		mdat = 10;
+		deto = 20;
+	}
+
+	devslp |= ((dito << PORT_DEVSLP_DITO_OFFSET) |
+		   (mdat << PORT_DEVSLP_MDAT_OFFSET) |
+		   (deto << PORT_DEVSLP_DETO_OFFSET) |
+		   PORT_DEVSLP_ADSE);
+	writel(devslp, port_mmio + PORT_DEVSLP);
+
+	ahci_start_engine(ap);
+
+	/* enable device sleep feature for the drive */
+	err_mask = ata_dev_set_feature(dev,
+				       SETFEATURES_SATA_ENABLE,
+				       SATA_DEVSLP);
+	if (err_mask && err_mask != AC_ERR_DEV)
+		ata_dev_warn(dev, "failed to enable DEVSLP\n");
+}
+
 static void ahci_enable_fbs(struct ata_port *ap)
 {
 	struct ahci_port_priv *pp = ap->private_data;
@@ -2164,7 +2255,8 @@ void ahci_print_info(struct ata_host *host, const char *scc_s)
 		"flags: "
 		"%s%s%s%s%s%s%s"
 		"%s%s%s%s%s%s%s"
-		"%s%s%s%s%s%s\n"
+		"%s%s%s%s%s%s%s"
+		"%s%s\n"
 		,
 
 		cap & HOST_CAP_64 ? "64bit " : "",
@@ -2184,6 +2276,9 @@ void ahci_print_info(struct ata_host *host, const char *scc_s)
 		cap & HOST_CAP_CCC ? "ccc " : "",
 		cap & HOST_CAP_EMS ? "ems " : "",
 		cap & HOST_CAP_SXS ? "sxs " : "",
+		cap2 & HOST_CAP2_DESO ? "deso " : "",
+		cap2 & HOST_CAP2_SADM ? "sadm " : "",
+		cap2 & HOST_CAP2_SDS ? "sds " : "",
 		cap2 & HOST_CAP2_APST ? "apst " : "",
 		cap2 & HOST_CAP2_NVMHCI ? "nvmp " : "",
 		cap2 & HOST_CAP2_BOH ? "boh " : ""
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5eee1c1..611050d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -774,7 +774,7 @@ int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 		tf->lbam = (block >> 8) & 0xff;
 		tf->lbal = block & 0xff;
 
-		tf->device = 1 << 6;
+		tf->device = ATA_LBA;
 		if (tf->flags & ATA_TFLAG_FUA)
 			tf->device |= 1 << 7;
 	} else if (dev->flags & ATA_DFLAG_LBA) {
@@ -2155,6 +2155,7 @@ int ata_dev_configure(struct ata_device *dev)
 	int print_info = ehc->i.flags & ATA_EHI_PRINTINFO;
 	const u16 *id = dev->id;
 	unsigned long xfer_mask;
+	unsigned int err_mask;
 	char revbuf[7];		/* XYZ-99\0 */
 	char fwrevbuf[ATA_ID_FW_REV_LEN+1];
 	char modelbuf[ATA_ID_PROD_LEN+1];
@@ -2323,6 +2324,26 @@ int ata_dev_configure(struct ata_device *dev)
 			}
 		}
 
+		/* check and mark DevSlp capability */
+		if (ata_id_has_devslp(dev->id))
+			dev->flags |= ATA_DFLAG_DEVSLP;
+
+		/* Obtain SATA Settings page from Identify Device Data Log,
+		 * which contains DevSlp timing variables etc.
+		 * Exclude old devices with ata_id_has_ncq()
+		 */
+		if (ata_id_has_ncq(dev->id)) {
+			err_mask = ata_read_log_page(dev,
+						     ATA_LOG_SATA_ID_DEV_DATA,
+						     ATA_LOG_SATA_SETTINGS,
+						     dev->sata_settings,
+						     1);
+			if (err_mask)
+				ata_dev_dbg(dev,
+					    "failed to get Identify Device Data, Emask 0x%x\n",
+					    err_mask);
+		}
+
 		dev->cdb_len = 16;
 	}
 
@@ -2351,8 +2372,6 @@ int ata_dev_configure(struct ata_device *dev)
 		    (ap->flags & ATA_FLAG_AN) && ata_id_has_atapi_AN(id) &&
 		    (!sata_pmp_attached(ap) ||
 		     sata_scr_read(&ap->link, SCR_NOTIFICATION, &sntf) == 0)) {
-			unsigned int err_mask;
-
 			/* issue SET feature command to turn this on */
 			err_mask = ata_dev_set_feature(dev,
 					SETFEATURES_SATA_ENABLE, SATA_AN);
@@ -3598,7 +3617,7 @@ int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 	switch (policy) {
 	case ATA_LPM_MAX_POWER:
 		/* disable all LPM transitions */
-		scontrol |= (0x3 << 8);
+		scontrol |= (0x7 << 8);
 		/* initiate transition to active state */
 		if (spm_wakeup) {
 			scontrol |= (0x4 << 12);
@@ -3608,12 +3627,12 @@ int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 	case ATA_LPM_MED_POWER:
 		/* allow LPM to PARTIAL */
 		scontrol &= ~(0x1 << 8);
-		scontrol |= (0x2 << 8);
+		scontrol |= (0x6 << 8);
 		break;
 	case ATA_LPM_MIN_POWER:
 		if (ata_link_nr_enabled(link) > 0)
 			/* no restrictions on LPM transitions */
-			scontrol &= ~(0x3 << 8);
+			scontrol &= ~(0x7 << 8);
 		else {
 			/* empty port, power off */
 			scontrol &= ~0xf;
@@ -4472,6 +4491,7 @@ unsigned int ata_dev_set_feature(struct ata_device *dev, u8 enable, u8 feature)
 	DPRINTK("EXIT, err_mask=%x\n", err_mask);
 	return err_mask;
 }
+EXPORT_SYMBOL_GPL(ata_dev_set_feature);
 
 /**
  *	ata_dev_init_params - Issue INIT DEV PARAMS command
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 7d4535e..2659894 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1487,6 +1487,7 @@ static const char *ata_err_string(unsigned int err_mask)
 /**
  *	ata_read_log_page - read a specific log page
  *	@dev: target device
+ *	@log: log to read
  *	@page: page to read
  *	@buf: buffer to store read page
  *	@sectors: number of sectors to read
@@ -1499,17 +1500,18 @@ static const char *ata_err_string(unsigned int err_mask)
  *	RETURNS:
  *	0 on success, AC_ERR_* mask otherwise.
  */
-static unsigned int ata_read_log_page(struct ata_device *dev,
-				      u8 page, void *buf, unsigned int sectors)
+unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
+			       u8 page, void *buf, unsigned int sectors)
 {
 	struct ata_taskfile tf;
 	unsigned int err_mask;
 
-	DPRINTK("read log page - page %d\n", page);
+	DPRINTK("read log page - log 0x%x, page 0x%x\n", log, page);
 
 	ata_tf_init(dev, &tf);
 	tf.command = ATA_CMD_READ_LOG_EXT;
-	tf.lbal = page;
+	tf.lbal = log;
+	tf.lbam = page;
 	tf.nsect = sectors;
 	tf.hob_nsect = sectors >> 8;
 	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_LBA48 | ATA_TFLAG_DEVICE;
@@ -1545,7 +1547,7 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
 	u8 csum;
 	int i;
 
-	err_mask = ata_read_log_page(dev, ATA_LOG_SATA_NCQ, buf, 1);
+	err_mask = ata_read_log_page(dev, ATA_LOG_SATA_NCQ, 0, buf, 1);
 	if (err_mask)
 		return -EIO;
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 8ec81ca..e3bda07 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1655,7 +1655,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 		if (unlikely(scmd->cmd_len < 10))
 			goto invalid_fld;
 		scsi_10_lba_len(cdb, &block, &n_block);
-		if (unlikely(cdb[1] & (1 << 3)))
+		if (cdb[1] & (1 << 3))
 			tf_flags |= ATA_TFLAG_FUA;
 		break;
 	case READ_6:
@@ -1675,7 +1675,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 		if (unlikely(scmd->cmd_len < 16))
 			goto invalid_fld;
 		scsi_16_lba_len(cdb, &block, &n_block);
-		if (unlikely(cdb[1] & (1 << 3)))
+		if (cdb[1] & (1 << 3))
 			tf_flags |= ATA_TFLAG_FUA;
 		break;
 	default:
@@ -2205,9 +2205,33 @@ static unsigned int ata_scsiop_noop(struct ata_scsi_args *args, u8 *rbuf)
 }
 
 /**
+ *	modecpy - Prepare response for MODE SENSE
+ *	@dest: output buffer
+ *	@src: data being copied
+ *	@n: length of mode page
+ *	@changeable: whether changeable parameters are requested
+ *
+ *	Generate a generic MODE SENSE page for either current or changeable
+ *	parameters.
+ *
+ *	LOCKING:
+ *	None.
+ */
+static void modecpy(u8 *dest, const u8 *src, int n, bool changeable)
+{
+	if (changeable) {
+		memcpy(dest, src, 2);
+		memset(dest + 2, 0, n - 2);
+	} else {
+		memcpy(dest, src, n);
+	}
+}
+
+/**
  *	ata_msense_caching - Simulate MODE SENSE caching info page
  *	@id: device IDENTIFY data
  *	@buf: output buffer
+ *	@changeable: whether changeable parameters are requested
  *
  *	Generate a caching info page, which conditionally indicates
  *	write caching to the SCSI layer, depending on device
@@ -2216,12 +2240,12 @@ static unsigned int ata_scsiop_noop(struct ata_scsi_args *args, u8 *rbuf)
  *	LOCKING:
  *	None.
  */
-static unsigned int ata_msense_caching(u16 *id, u8 *buf)
+static unsigned int ata_msense_caching(u16 *id, u8 *buf, bool changeable)
 {
-	memcpy(buf, def_cache_mpage, sizeof(def_cache_mpage));
-	if (ata_id_wcache_enabled(id))
+	modecpy(buf, def_cache_mpage, sizeof(def_cache_mpage), changeable);
+	if (changeable || ata_id_wcache_enabled(id))
 		buf[2] |= (1 << 2);	/* write cache enable */
-	if (!ata_id_rahead_enabled(id))
+	if (!changeable && !ata_id_rahead_enabled(id))
 		buf[12] |= (1 << 5);	/* disable read ahead */
 	return sizeof(def_cache_mpage);
 }
@@ -2229,30 +2253,33 @@ static unsigned int ata_msense_caching(u16 *id, u8 *buf)
 /**
  *	ata_msense_ctl_mode - Simulate MODE SENSE control mode page
  *	@buf: output buffer
+ *	@changeable: whether changeable parameters are requested
  *
  *	Generate a generic MODE SENSE control mode page.
  *
  *	LOCKING:
  *	None.
  */
-static unsigned int ata_msense_ctl_mode(u8 *buf)
+static unsigned int ata_msense_ctl_mode(u8 *buf, bool changeable)
 {
-	memcpy(buf, def_control_mpage, sizeof(def_control_mpage));
+	modecpy(buf, def_control_mpage, sizeof(def_control_mpage), changeable);
 	return sizeof(def_control_mpage);
 }
 
 /**
  *	ata_msense_rw_recovery - Simulate MODE SENSE r/w error recovery page
  *	@buf: output buffer
+ *	@changeable: whether changeable parameters are requested
  *
  *	Generate a generic MODE SENSE r/w error recovery page.
  *
  *	LOCKING:
  *	None.
  */
-static unsigned int ata_msense_rw_recovery(u8 *buf)
+static unsigned int ata_msense_rw_recovery(u8 *buf, bool changeable)
 {
-	memcpy(buf, def_rw_recovery_mpage, sizeof(def_rw_recovery_mpage));
+	modecpy(buf, def_rw_recovery_mpage, sizeof(def_rw_recovery_mpage),
+		changeable);
 	return sizeof(def_rw_recovery_mpage);
 }
 
@@ -2316,11 +2343,11 @@ static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
 	page_control = scsicmd[2] >> 6;
 	switch (page_control) {
 	case 0: /* current */
+	case 1: /* changeable */
+	case 2: /* defaults */
 		break;  /* supported */
 	case 3: /* saved */
 		goto saving_not_supp;
-	case 1: /* changeable */
-	case 2: /* defaults */
 	default:
 		goto invalid_fld;
 	}
@@ -2341,21 +2368,21 @@ static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
 
 	switch(pg) {
 	case RW_RECOVERY_MPAGE:
-		p += ata_msense_rw_recovery(p);
+		p += ata_msense_rw_recovery(p, page_control == 1);
 		break;
 
 	case CACHE_MPAGE:
-		p += ata_msense_caching(args->id, p);
+		p += ata_msense_caching(args->id, p, page_control == 1);
 		break;
 
 	case CONTROL_MPAGE:
-		p += ata_msense_ctl_mode(p);
+		p += ata_msense_ctl_mode(p, page_control == 1);
 		break;
 
 	case ALL_MPAGES:
-		p += ata_msense_rw_recovery(p);
-		p += ata_msense_caching(args->id, p);
-		p += ata_msense_ctl_mode(p);
+		p += ata_msense_rw_recovery(p, page_control == 1);
+		p += ata_msense_caching(args->id, p, page_control == 1);
+		p += ata_msense_ctl_mode(p, page_control == 1);
 		break;
 
 	default:		/* invalid page code */
@@ -3080,6 +3107,188 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 }
 
 /**
+ *	ata_mselect_caching - Simulate MODE SELECT for caching info page
+ *	@qc: Storage for translated ATA taskfile
+ *	@buf: input buffer
+ *	@len: number of valid bytes in the input buffer
+ *
+ *	Prepare a taskfile to modify caching information for the device.
+ *
+ *	LOCKING:
+ *	None.
+ */
+static int ata_mselect_caching(struct ata_queued_cmd *qc,
+			       const u8 *buf, int len)
+{
+	struct ata_taskfile *tf = &qc->tf;
+	struct ata_device *dev = qc->dev;
+	char mpage[CACHE_MPAGE_LEN];
+	u8 wce;
+
+	/*
+	 * The first two bytes of def_cache_mpage are a header, so offsets
+	 * in mpage are off by 2 compared to buf.  Same for len.
+	 */
+
+	if (len != CACHE_MPAGE_LEN - 2)
+		return -EINVAL;
+
+	wce = buf[0] & (1 << 2);
+
+	/*
+	 * Check that read-only bits are not modified.
+	 */
+	ata_msense_caching(dev->id, mpage, false);
+	mpage[2] &= ~(1 << 2);
+	mpage[2] |= wce;
+	if (memcmp(mpage + 2, buf, CACHE_MPAGE_LEN - 2) != 0)
+		return -EINVAL;
+
+	tf->flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+	tf->protocol = ATA_PROT_NODATA;
+	tf->nsect = 0;
+	tf->command = ATA_CMD_SET_FEATURES;
+	tf->feature = wce ? SETFEATURES_WC_ON : SETFEATURES_WC_OFF;
+	return 0;
+}
+
+/**
+ *	ata_scsiop_mode_select - Simulate MODE SELECT 6, 10 commands
+ *	@qc: Storage for translated ATA taskfile
+ *
+ *	Converts a MODE SELECT command to an ATA SET FEATURES taskfile.
+ *	Assume this is invoked for direct access devices (e.g. disks) only.
+ *	There should be no block descriptor for other device types.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
+{
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	const u8 *cdb = scmd->cmnd;
+	const u8 *p;
+	u8 pg, spg;
+	unsigned six_byte, pg_len, hdr_len, bd_len;
+	int len;
+
+	VPRINTK("ENTER\n");
+
+	six_byte = (cdb[0] == MODE_SELECT);
+	if (six_byte) {
+		if (scmd->cmd_len < 5)
+			goto invalid_fld;
+
+		len = cdb[4];
+		hdr_len = 4;
+	} else {
+		if (scmd->cmd_len < 9)
+			goto invalid_fld;
+
+		len = (cdb[7] << 8) + cdb[8];
+		hdr_len = 8;
+	}
+
+	/* We only support PF=1, SP=0.  */
+	if ((cdb[1] & 0x11) != 0x10)
+		goto invalid_fld;
+
+	/* Test early for possible overrun.  */
+	if (!scsi_sg_count(scmd) || scsi_sglist(scmd)->length < len)
+		goto invalid_param_len;
+
+	p = page_address(sg_page(scsi_sglist(scmd)));
+
+	/* Move past header and block descriptors.  */
+	if (len < hdr_len)
+		goto invalid_param_len;
+
+	if (six_byte)
+		bd_len = p[3];
+	else
+		bd_len = (p[6] << 8) + p[7];
+
+	len -= hdr_len;
+	p += hdr_len;
+	if (len < bd_len)
+		goto invalid_param_len;
+	if (bd_len != 0 && bd_len != 8)
+		goto invalid_param;
+
+	len -= bd_len;
+	p += bd_len;
+	if (len == 0)
+		goto skip;
+
+	/* Parse both possible formats for the mode page headers.  */
+	pg = p[0] & 0x3f;
+	if (p[0] & 0x40) {
+		if (len < 4)
+			goto invalid_param_len;
+
+		spg = p[1];
+		pg_len = (p[2] << 8) | p[3];
+		p += 4;
+		len -= 4;
+	} else {
+		if (len < 2)
+			goto invalid_param_len;
+
+		spg = 0;
+		pg_len = p[1];
+		p += 2;
+		len -= 2;
+	}
+
+	/*
+	 * No mode subpages supported (yet) but asking for _all_
+	 * subpages may be valid
+	 */
+	if (spg && (spg != ALL_SUB_MPAGES))
+		goto invalid_param;
+	if (pg_len > len)
+		goto invalid_param_len;
+
+	switch (pg) {
+	case CACHE_MPAGE:
+		if (ata_mselect_caching(qc, p, pg_len) < 0)
+			goto invalid_param;
+		break;
+
+	default:		/* invalid page code */
+		goto invalid_param;
+	}
+
+	/*
+	 * Only one page has changeable data, so we only support setting one
+	 * page at a time.
+	 */
+	if (len > pg_len)
+		goto invalid_param;
+
+	return 0;
+
+ invalid_fld:
+	/* "Invalid field in CDB" */
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x24, 0x0);
+	return 1;
+
+ invalid_param:
+	/* "Invalid field in parameter list" */
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x26, 0x0);
+	return 1;
+
+ invalid_param_len:
+	/* "Parameter list length error" */
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
+	return 1;
+
+ skip:
+	scmd->result = SAM_STAT_GOOD;
+	return 1;
+}
+
+/**
  *	ata_get_xlat_func - check if SCSI to ATA translation is possible
  *	@dev: ATA device
  *	@cmd: SCSI command opcode to consider
@@ -3119,6 +3328,11 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 	case ATA_16:
 		return ata_scsi_pass_thru;
 
+	case MODE_SELECT:
+	case MODE_SELECT_10:
+		return ata_scsi_mode_select_xlat;
+		break;
+
 	case START_STOP:
 		return ata_scsi_start_stop_xlat;
 	}
@@ -3311,11 +3525,6 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 		ata_scsi_rbuf_fill(&args, ata_scsiop_mode_sense);
 		break;
 
-	case MODE_SELECT:	/* unconditionally return */
-	case MODE_SELECT_10:	/* bad-field-in-cdb */
-		ata_scsi_invalid_field(cmd);
-		break;
-
 	case READ_CAPACITY:
 		ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
 		break;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 50e4dff..7148a58 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -165,6 +165,8 @@ extern void ata_eh_about_to_do(struct ata_link *link, struct ata_device *dev,
 			       unsigned int action);
 extern void ata_eh_done(struct ata_link *link, struct ata_device *dev,
 			unsigned int action);
+extern unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
+				      u8 page, void *buf, unsigned int sectors);
 extern void ata_eh_autopsy(struct ata_port *ap);
 const char *ata_get_cmd_descript(u8 command);
 extern void ata_eh_report(struct ata_port *ap);
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index bfaa5cb..26201eb 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -31,6 +31,7 @@
 #include <linux/kernel.h>
 #include <linux/libata.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/pata_arasan_cf_data.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
@@ -310,7 +311,7 @@ static int cf_init(struct arasan_cf_dev *acdev)
 	unsigned long flags;
 	int ret = 0;
 
-	ret = clk_enable(acdev->clk);
+	ret = clk_prepare_enable(acdev->clk);
 	if (ret) {
 		dev_dbg(acdev->host->dev, "clock enable failed");
 		return ret;
@@ -340,7 +341,7 @@ static void cf_exit(struct arasan_cf_dev *acdev)
 	writel(readl(acdev->vbase + OP_MODE) & ~CFHOST_ENB,
 			acdev->vbase + OP_MODE);
 	spin_unlock_irqrestore(&acdev->host->lock, flags);
-	clk_disable(acdev->clk);
+	clk_disable_unprepare(acdev->clk);
 }
 
 static void dma_callback(void *dev)
@@ -935,6 +936,14 @@ static int arasan_cf_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(arasan_cf_pm_ops, arasan_cf_suspend, arasan_cf_resume);
 
+#ifdef CONFIG_OF
+static const struct of_device_id arasan_cf_id_table[] = {
+	{ .compatible = "arasan,cf-spear1340" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, arasan_cf_id_table);
+#endif
+
 static struct platform_driver arasan_cf_driver = {
 	.probe		= arasan_cf_probe,
 	.remove		= __devexit_p(arasan_cf_remove),
@@ -942,6 +951,7 @@ static struct platform_driver arasan_cf_driver = {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
 		.pm	= &arasan_cf_pm_ops,
+		.of_match_table = of_match_ptr(arasan_cf_id_table),
 	},
 };
 
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index d6577b9..124b2c1 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -123,6 +123,7 @@ enum {
 	ONLINE = (1 << 31),
 	GOING_OFFLINE = (1 << 30),
 	BIST_ERR = (1 << 29),
+	CLEAR_ERROR = (1 << 27),
 
 	FATAL_ERR_HC_MASTER_ERR = (1 << 18),
 	FATAL_ERR_PARITY_ERR_TX = (1 << 17),
@@ -143,6 +144,7 @@ enum {
 	    FATAL_ERR_CRC_ERR_RX |
 	    FATAL_ERR_FIFO_OVRFL_TX | FATAL_ERR_FIFO_OVRFL_RX,
 
+	INT_ON_DATA_LENGTH_MISMATCH = (1 << 12),
 	INT_ON_FATAL_ERR = (1 << 5),
 	INT_ON_PHYRDY_CHG = (1 << 4),
 
@@ -1181,25 +1183,54 @@ static void sata_fsl_host_intr(struct ata_port *ap)
 	u32 hstatus, done_mask = 0;
 	struct ata_queued_cmd *qc;
 	u32 SError;
+	u32 tag;
+	u32 status_mask = INT_ON_ERROR;
 
 	hstatus = ioread32(hcr_base + HSTATUS);
 
 	sata_fsl_scr_read(&ap->link, SCR_ERROR, &SError);
 
+	/* Read command completed register */
+	done_mask = ioread32(hcr_base + CC);
+
+	/* Workaround for data length mismatch errata */
+	if (unlikely(hstatus & INT_ON_DATA_LENGTH_MISMATCH)) {
+		for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
+			qc = ata_qc_from_tag(ap, tag);
+			if (qc && ata_is_atapi(qc->tf.protocol)) {
+				u32 hcontrol;
+				/* Set HControl[27] to clear error registers */
+				hcontrol = ioread32(hcr_base + HCONTROL);
+				iowrite32(hcontrol | CLEAR_ERROR,
+						hcr_base + HCONTROL);
+
+				/* Clear HControl[27] */
+				iowrite32(hcontrol & ~CLEAR_ERROR,
+						hcr_base + HCONTROL);
+
+				/* Clear SError[E] bit */
+				sata_fsl_scr_write(&ap->link, SCR_ERROR,
+						SError);
+
+				/* Ignore fatal error and device error */
+				status_mask &= ~(INT_ON_SINGL_DEVICE_ERR
+						| INT_ON_FATAL_ERR);
+				break;
+			}
+		}
+	}
+
 	if (unlikely(SError & 0xFFFF0000)) {
 		DPRINTK("serror @host_intr : 0x%x\n", SError);
 		sata_fsl_error_intr(ap);
 	}
 
-	if (unlikely(hstatus & INT_ON_ERROR)) {
+	if (unlikely(hstatus & status_mask)) {
 		DPRINTK("error interrupt!!\n");
 		sata_fsl_error_intr(ap);
 		return;
 	}
 
-	/* Read command completed register */
-	done_mask = ioread32(hcr_base + CC);
-
 	VPRINTK("Status of all queues :\n");
 	VPRINTK("done_mask/CC = 0x%x, CA = 0x%x, CE=0x%x,CQ=0x%x,apqa=0x%x\n",
 		done_mask,
diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
new file mode 100644
index 0000000..0d7c4c2
--- /dev/null
+++ b/drivers/ata/sata_highbank.c
@@ -0,0 +1,450 @@
+/*
+ * Calxeda Highbank AHCI SATA platform driver
+ * Copyright 2012 Calxeda, Inc.
+ *
+ * based on the AHCI SATA platform driver by Jeff Garzik and Anton Vorontsov
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/kernel.h>
+#include <linux/gfp.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/spinlock.h>
+#include <linux/device.h>
+#include <linux/of_device.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/libata.h>
+#include <linux/ahci_platform.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/export.h>
+#include "ahci.h"
+
+#define CPHY_MAP(dev, addr) ((((dev) & 0x1f) << 7) | (((addr) >> 9) & 0x7f))
+#define CPHY_ADDR(addr) (((addr) & 0x1ff) << 2)
+#define SERDES_CR_CTL			0x80a0
+#define SERDES_CR_ADDR			0x80a1
+#define SERDES_CR_DATA			0x80a2
+#define CR_BUSY				0x0001
+#define CR_START			0x0001
+#define CR_WR_RDN			0x0002
+#define CPHY_RX_INPUT_STS		0x2002
+#define CPHY_SATA_OVERRIDE	 	0x4000
+#define CPHY_OVERRIDE			0x2005
+#define SPHY_LANE			0x100
+#define SPHY_HALF_RATE			0x0001
+#define CPHY_SATA_DPLL_MODE		0x0700
+#define CPHY_SATA_DPLL_SHIFT		8
+#define CPHY_SATA_DPLL_RESET		(1 << 11)
+#define CPHY_PHY_COUNT			6
+#define CPHY_LANE_COUNT			4
+#define CPHY_PORT_COUNT			(CPHY_PHY_COUNT * CPHY_LANE_COUNT)
+
+static DEFINE_SPINLOCK(cphy_lock);
+/* Each of the 6 phys can have up to 4 sata ports attached to i. Map 0-based
+ * sata ports to their phys and then to their lanes within the phys
+ */
+struct phy_lane_info {
+	void __iomem *phy_base;
+	u8 lane_mapping;
+	u8 phy_devs;
+};
+static struct phy_lane_info port_data[CPHY_PORT_COUNT];
+
+static u32 __combo_phy_reg_read(u8 sata_port, u32 addr)
+{
+	u32 data;
+	u8 dev = port_data[sata_port].phy_devs;
+	spin_lock(&cphy_lock);
+	writel(CPHY_MAP(dev, addr), port_data[sata_port].phy_base + 0x800);
+	data = readl(port_data[sata_port].phy_base + CPHY_ADDR(addr));
+	spin_unlock(&cphy_lock);
+	return data;
+}
+
+static void __combo_phy_reg_write(u8 sata_port, u32 addr, u32 data)
+{
+	u8 dev = port_data[sata_port].phy_devs;
+	spin_lock(&cphy_lock);
+	writel(CPHY_MAP(dev, addr), port_data[sata_port].phy_base + 0x800);
+	writel(data, port_data[sata_port].phy_base + CPHY_ADDR(addr));
+	spin_unlock(&cphy_lock);
+}
+
+static void combo_phy_wait_for_ready(u8 sata_port)
+{
+	while (__combo_phy_reg_read(sata_port, SERDES_CR_CTL) & CR_BUSY)
+		udelay(5);
+}
+
+static u32 combo_phy_read(u8 sata_port, u32 addr)
+{
+	combo_phy_wait_for_ready(sata_port);
+	__combo_phy_reg_write(sata_port, SERDES_CR_ADDR, addr);
+	__combo_phy_reg_write(sata_port, SERDES_CR_CTL, CR_START);
+	combo_phy_wait_for_ready(sata_port);
+	return __combo_phy_reg_read(sata_port, SERDES_CR_DATA);
+}
+
+static void combo_phy_write(u8 sata_port, u32 addr, u32 data)
+{
+	combo_phy_wait_for_ready(sata_port);
+	__combo_phy_reg_write(sata_port, SERDES_CR_ADDR, addr);
+	__combo_phy_reg_write(sata_port, SERDES_CR_DATA, data);
+	__combo_phy_reg_write(sata_port, SERDES_CR_CTL, CR_WR_RDN | CR_START);
+}
+
+static void highbank_cphy_disable_overrides(u8 sata_port)
+{
+	u8 lane = port_data[sata_port].lane_mapping;
+	u32 tmp;
+	if (unlikely(port_data[sata_port].phy_base == NULL))
+		return;
+	tmp = combo_phy_read(sata_port, CPHY_RX_INPUT_STS + lane * SPHY_LANE);
+	tmp &= ~CPHY_SATA_OVERRIDE;
+	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
+}
+
+static void cphy_override_rx_mode(u8 sata_port, u32 val)
+{
+	u8 lane = port_data[sata_port].lane_mapping;
+	u32 tmp;
+	tmp = combo_phy_read(sata_port, CPHY_RX_INPUT_STS + lane * SPHY_LANE);
+	tmp &= ~CPHY_SATA_OVERRIDE;
+	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
+
+	tmp |= CPHY_SATA_OVERRIDE;
+	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
+
+	tmp &= ~CPHY_SATA_DPLL_MODE;
+	tmp |= val << CPHY_SATA_DPLL_SHIFT;
+	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
+
+	tmp |= CPHY_SATA_DPLL_RESET;
+	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
+
+	tmp &= ~CPHY_SATA_DPLL_RESET;
+	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
+
+	msleep(15);
+}
+
+static void highbank_cphy_override_lane(u8 sata_port)
+{
+	u8 lane = port_data[sata_port].lane_mapping;
+	u32 tmp, k = 0;
+
+	if (unlikely(port_data[sata_port].phy_base == NULL))
+		return;
+	do {
+		tmp = combo_phy_read(sata_port, CPHY_RX_INPUT_STS +
+						lane * SPHY_LANE);
+	} while ((tmp & SPHY_HALF_RATE) && (k++ < 1000));
+	cphy_override_rx_mode(sata_port, 3);
+}
+
+static int highbank_initialize_phys(struct device *dev, void __iomem *addr)
+{
+	struct device_node *sata_node = dev->of_node;
+	int phy_count = 0, phy, port = 0;
+	void __iomem *cphy_base[CPHY_PHY_COUNT];
+	struct device_node *phy_nodes[CPHY_PHY_COUNT];
+	memset(port_data, 0, sizeof(struct phy_lane_info) * CPHY_PORT_COUNT);
+	memset(phy_nodes, 0, sizeof(struct device_node*) * CPHY_PHY_COUNT);
+
+	do {
+		u32 tmp;
+		struct of_phandle_args phy_data;
+		if (of_parse_phandle_with_args(sata_node,
+				"calxeda,port-phys", "#phy-cells",
+				port, &phy_data))
+			break;
+		for (phy = 0; phy < phy_count; phy++) {
+			if (phy_nodes[phy] == phy_data.np)
+				break;
+		}
+		if (phy_nodes[phy] == NULL) {
+			phy_nodes[phy] = phy_data.np;
+			cphy_base[phy] = of_iomap(phy_nodes[phy], 0);
+			if (cphy_base[phy] == NULL) {
+				return 0;
+			}
+			phy_count += 1;
+		}
+		port_data[port].lane_mapping = phy_data.args[0];
+		of_property_read_u32(phy_nodes[phy], "phydev", &tmp);
+		port_data[port].phy_devs = tmp;
+		port_data[port].phy_base = cphy_base[phy];
+		of_node_put(phy_data.np);
+		port += 1;
+	} while (port < CPHY_PORT_COUNT);
+	return 0;
+}
+
+static int ahci_highbank_hardreset(struct ata_link *link, unsigned int *class,
+				unsigned long deadline)
+{
+	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
+	struct ata_port *ap = link->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
+	struct ata_taskfile tf;
+	bool online;
+	u32 sstatus;
+	int rc;
+	int retry = 10;
+
+	ahci_stop_engine(ap);
+
+	/* clear D2H reception area to properly wait for D2H FIS */
+	ata_tf_init(link->device, &tf);
+	tf.command = 0x80;
+	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
+
+	do {
+		highbank_cphy_disable_overrides(link->ap->port_no);
+		rc = sata_link_hardreset(link, timing, deadline, &online, NULL);
+		highbank_cphy_override_lane(link->ap->port_no);
+
+		/* If the status is 1, we are connected, but the link did not
+		 * come up. So retry resetting the link again.
+		 */
+		if (sata_scr_read(link, SCR_STATUS, &sstatus))
+			break;
+		if (!(sstatus & 0x3))
+			break;
+	} while (!online && retry--);
+
+	ahci_start_engine(ap);
+
+	if (online)
+		*class = ahci_dev_classify(ap);
+
+	return rc;
+}
+
+static struct ata_port_operations ahci_highbank_ops = {
+	.inherits		= &ahci_ops,
+	.hardreset		= ahci_highbank_hardreset,
+};
+
+static const struct ata_port_info ahci_highbank_port_info = {
+	.flags          = AHCI_FLAG_COMMON,
+	.pio_mask       = ATA_PIO4,
+	.udma_mask      = ATA_UDMA6,
+	.port_ops       = &ahci_highbank_ops,
+};
+
+static struct scsi_host_template ahci_highbank_platform_sht = {
+	AHCI_SHT("highbank-ahci"),
+};
+
+static const struct of_device_id ahci_of_match[] = {
+	{ .compatible = "calxeda,hb-ahci" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, ahci_of_match);
+
+static int __init ahci_highbank_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ahci_host_priv *hpriv;
+	struct ata_host *host;
+	struct resource *mem;
+	int irq;
+	int n_ports;
+	int i;
+	int rc;
+	struct ata_port_info pi = ahci_highbank_port_info;
+	const struct ata_port_info *ppi[] = { &pi, NULL };
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(dev, "no mmio space\n");
+		return -EINVAL;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0) {
+		dev_err(dev, "no irq\n");
+		return -EINVAL;
+	}
+
+	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
+	if (!hpriv) {
+		dev_err(dev, "can't alloc ahci_host_priv\n");
+		return -ENOMEM;
+	}
+
+	hpriv->flags |= (unsigned long)pi.private_data;
+
+	hpriv->mmio = devm_ioremap(dev, mem->start, resource_size(mem));
+	if (!hpriv->mmio) {
+		dev_err(dev, "can't map %pR\n", mem);
+		return -ENOMEM;
+	}
+
+	rc = highbank_initialize_phys(dev, hpriv->mmio);
+	if (rc)
+		return rc;
+
+
+	ahci_save_initial_config(dev, hpriv, 0, 0);
+
+	/* prepare host */
+	if (hpriv->cap & HOST_CAP_NCQ)
+		pi.flags |= ATA_FLAG_NCQ;
+
+	if (hpriv->cap & HOST_CAP_PMP)
+		pi.flags |= ATA_FLAG_PMP;
+
+	ahci_set_em_messages(hpriv, &pi);
+
+	/* CAP.NP sometimes indicate the index of the last enabled
+	 * port, at other times, that of the last possible port, so
+	 * determining the maximum port number requires looking at
+	 * both CAP.NP and port_map.
+	 */
+	n_ports = max(ahci_nr_ports(hpriv->cap), fls(hpriv->port_map));
+
+	host = ata_host_alloc_pinfo(dev, ppi, n_ports);
+	if (!host) {
+		rc = -ENOMEM;
+		goto err0;
+	}
+
+	host->private_data = hpriv;
+
+	if (!(hpriv->cap & HOST_CAP_SSS) || ahci_ignore_sss)
+		host->flags |= ATA_HOST_PARALLEL_SCAN;
+
+	if (pi.flags & ATA_FLAG_EM)
+		ahci_reset_em(host);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		ata_port_desc(ap, "mmio %pR", mem);
+		ata_port_desc(ap, "port 0x%x", 0x100 + ap->port_no * 0x80);
+
+		/* set enclosure management message type */
+		if (ap->flags & ATA_FLAG_EM)
+			ap->em_message_type = hpriv->em_msg_type;
+
+		/* disabled/not-implemented port */
+		if (!(hpriv->port_map & (1 << i)))
+			ap->ops = &ata_dummy_port_ops;
+	}
+
+	rc = ahci_reset_controller(host);
+	if (rc)
+		goto err0;
+
+	ahci_init_controller(host);
+	ahci_print_info(host, "platform");
+
+	rc = ata_host_activate(host, irq, ahci_interrupt, 0,
+					&ahci_highbank_platform_sht);
+	if (rc)
+		goto err0;
+
+	return 0;
+err0:
+	return rc;
+}
+
+static int __devexit ahci_highbank_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ata_host *host = dev_get_drvdata(dev);
+
+	ata_host_detach(host);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int ahci_highbank_suspend(struct device *dev)
+{
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct ahci_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->mmio;
+	u32 ctl;
+	int rc;
+
+	if (hpriv->flags & AHCI_HFLAG_NO_SUSPEND) {
+		dev_err(dev, "firmware update required for suspend/resume\n");
+		return -EIO;
+	}
+
+	/*
+	 * AHCI spec rev1.1 section 8.3.3:
+	 * Software must disable interrupts prior to requesting a
+	 * transition of the HBA to D3 state.
+	 */
+	ctl = readl(mmio + HOST_CTL);
+	ctl &= ~HOST_IRQ_EN;
+	writel(ctl, mmio + HOST_CTL);
+	readl(mmio + HOST_CTL); /* flush */
+
+	rc = ata_host_suspend(host, PMSG_SUSPEND);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+static int ahci_highbank_resume(struct device *dev)
+{
+	struct ata_host *host = dev_get_drvdata(dev);
+	int rc;
+
+	if (dev->power.power_state.event == PM_EVENT_SUSPEND) {
+		rc = ahci_reset_controller(host);
+		if (rc)
+			return rc;
+
+		ahci_init_controller(host);
+	}
+
+	ata_host_resume(host);
+
+	return 0;
+}
+#endif
+
+SIMPLE_DEV_PM_OPS(ahci_highbank_pm_ops,
+		  ahci_highbank_suspend, ahci_highbank_resume);
+
+static struct platform_driver ahci_highbank_driver = {
+        .remove = __devexit_p(ahci_highbank_remove),
+        .driver = {
+                .name = "highbank-ahci",
+                .owner = THIS_MODULE,
+                .of_match_table = ahci_of_match,
+                .pm = &ahci_highbank_pm_ops,
+        },
+	.probe = ahci_highbank_probe,
+};
+
+module_platform_driver(ahci_highbank_driver);
+
+MODULE_DESCRIPTION("Calxeda Highbank AHCI SATA platform driver");
+MODULE_AUTHOR("Mark Langsdorf <mark.langsdorf@calxeda.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("sata:highbank");
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 311be18..68f4fb5 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -79,8 +79,8 @@
  * module options
  */
 
-static int msi;
 #ifdef CONFIG_PCI
+static int msi;
 module_param(msi, int, S_IRUGO);
 MODULE_PARM_DESC(msi, "Enable use of PCI MSI (0=off, 1=on)");
 #endif
@@ -652,12 +652,13 @@ static u8 mv_sff_check_status(struct ata_port *ap);
  * because we have to allow room for worst case splitting of
  * PRDs for 64K boundaries in mv_fill_sg().
  */
+#ifdef CONFIG_PCI
 static struct scsi_host_template mv5_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize		= MV_MAX_SG_CT / 2,
 	.dma_boundary		= MV_DMA_BOUNDARY,
 };
-
+#endif
 static struct scsi_host_template mv6_sht = {
 	ATA_NCQ_SHT(DRV_NAME),
 	.can_queue		= MV_MAX_Q_DEPTH - 1,
@@ -1252,7 +1253,7 @@ static void mv_dump_mem(void __iomem *start, unsigned bytes)
 	}
 }
 #endif
-
+#if defined(ATA_DEBUG) || defined(CONFIG_PCI)
 static void mv_dump_pci_cfg(struct pci_dev *pdev, unsigned bytes)
 {
 #ifdef ATA_DEBUG
@@ -1269,6 +1270,7 @@ static void mv_dump_pci_cfg(struct pci_dev *pdev, unsigned bytes)
 	}
 #endif
 }
+#endif
 static void mv_dump_all_regs(void __iomem *mmio_base, int port,
 			     struct pci_dev *pdev)
 {
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 5713d3a..408da95 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -77,6 +77,9 @@ enum {
 	ATA_ID_EIDE_PIO_IORDY	= 68,
 	ATA_ID_ADDITIONAL_SUPP	= 69,
 	ATA_ID_QUEUE_DEPTH	= 75,
+	ATA_ID_SATA_CAPABILITY	= 76,
+	ATA_ID_SATA_CAPABILITY_2	= 77,
+	ATA_ID_FEATURE_SUPP	= 78,
 	ATA_ID_MAJOR_VER	= 80,
 	ATA_ID_COMMAND_SET_1	= 82,
 	ATA_ID_COMMAND_SET_2	= 83,
@@ -292,6 +295,13 @@ enum {
 
 	/* READ_LOG_EXT pages */
 	ATA_LOG_SATA_NCQ	= 0x10,
+	ATA_LOG_SATA_ID_DEV_DATA  = 0x30,
+	ATA_LOG_SATA_SETTINGS	  = 0x08,
+	ATA_LOG_DEVSLP_MDAT	  = 0x30,
+	ATA_LOG_DEVSLP_MDAT_MASK  = 0x1F,
+	ATA_LOG_DEVSLP_DETO	  = 0x31,
+	ATA_LOG_DEVSLP_VALID	  = 0x37,
+	ATA_LOG_DEVSLP_VALID_MASK = 0x80,
 
 	/* READ/WRITE LONG (obsolete) */
 	ATA_CMD_READ_LONG	= 0x22,
@@ -345,6 +355,7 @@ enum {
 	SATA_FPDMA_IN_ORDER	= 0x04,	/* FPDMA in-order data delivery */
 	SATA_AN			= 0x05,	/* Asynchronous Notification */
 	SATA_SSP		= 0x06,	/* Software Settings Preservation */
+	SATA_DEVSLP		= 0x09,	/* Device Sleep */
 
 	/* feature values for SET_MAX */
 	ATA_SET_MAX_ADDR	= 0x00,
@@ -558,15 +569,17 @@ static inline int ata_is_data(u8 prot)
 #define ata_id_is_ata(id)	(((id)[ATA_ID_CONFIG] & (1 << 15)) == 0)
 #define ata_id_has_lba(id)	((id)[ATA_ID_CAPABILITY] & (1 << 9))
 #define ata_id_has_dma(id)	((id)[ATA_ID_CAPABILITY] & (1 << 8))
-#define ata_id_has_ncq(id)	((id)[76] & (1 << 8))
+#define ata_id_has_ncq(id)	((id)[ATA_ID_SATA_CAPABILITY] & (1 << 8))
 #define ata_id_queue_depth(id)	(((id)[ATA_ID_QUEUE_DEPTH] & 0x1f) + 1)
 #define ata_id_removeable(id)	((id)[ATA_ID_CONFIG] & (1 << 7))
 #define ata_id_has_atapi_AN(id)	\
-	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
-	  ((id)[78] & (1 << 5)) )
+	((((id)[ATA_ID_SATA_CAPABILITY] != 0x0000) && \
+	  ((id)[ATA_ID_SATA_CAPABILITY] != 0xffff)) && \
+	 ((id)[ATA_ID_FEATURE_SUPP] & (1 << 5)))
 #define ata_id_has_fpdma_aa(id)	\
-	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
-	  ((id)[78] & (1 << 2)) )
+	((((id)[ATA_ID_SATA_CAPABILITY] != 0x0000) && \
+	  ((id)[ATA_ID_SATA_CAPABILITY] != 0xffff)) && \
+	 ((id)[ATA_ID_FEATURE_SUPP] & (1 << 2)))
 #define ata_id_iordy_disable(id) ((id)[ATA_ID_CAPABILITY] & (1 << 10))
 #define ata_id_has_iordy(id) ((id)[ATA_ID_CAPABILITY] & (1 << 11))
 #define ata_id_u32(id,n)	\
@@ -578,11 +591,12 @@ static inline int ata_is_data(u8 prot)
 	  ((u64) (id)[(n) + 0]) )
 
 #define ata_id_cdb_intr(id)	(((id)[ATA_ID_CONFIG] & 0x60) == 0x20)
-#define ata_id_has_da(id)	((id)[77] & (1 << 4))
+#define ata_id_has_da(id)	((id)[ATA_ID_SATA_CAPABILITY_2] & (1 << 4))
+#define ata_id_has_devslp(id)	((id)[ATA_ID_FEATURE_SUPP] & (1 << 8))
 
 static inline bool ata_id_has_hipm(const u16 *id)
 {
-	u16 val = id[76];
+	u16 val = id[ATA_ID_SATA_CAPABILITY];
 
 	if (val == 0 || val == 0xffff)
 		return false;
@@ -592,7 +606,7 @@ static inline bool ata_id_has_hipm(const u16 *id)
 
 static inline bool ata_id_has_dipm(const u16 *id)
 {
-	u16 val = id[78];
+	u16 val = id[ATA_ID_FEATURE_SUPP];
 
 	if (val == 0 || val == 0xffff)
 		return false;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 64f90e1..464e67c 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -162,6 +162,7 @@ enum {
 	ATA_DFLAG_DETACHED	= (1 << 25),
 
 	ATA_DFLAG_DA		= (1 << 26), /* device supports Device Attention */
+	ATA_DFLAG_DEVSLP	= (1 << 27), /* device supports Device Sleep */
 
 	ATA_DEV_UNKNOWN		= 0,	/* unknown device */
 	ATA_DEV_ATA		= 1,	/* ATA device */
@@ -649,6 +650,9 @@ struct ata_device {
 		u32		gscr[SATA_PMP_GSCR_DWORDS]; /* PMP GSCR block */
 	};
 
+	/* Identify Device Data Log (30h), SATA Settings (page 08h) */
+	u8			sata_settings[ATA_SECT_SIZE];
+
 	/* error history */
 	int			spdn_cnt;
 	/* ering is CLEAR_END, read comment above CLEAR_END */
