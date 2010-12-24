Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab0LXShz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 13:37:55 -0500
Received: from havoc.gtf.org ([69.61.125.42]:42611 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab0LXShx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 13:37:53 -0500
Date: Fri, 24 Dec 2010 13:37:52 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20101224183752.GA11201@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nothing overly notable or major; the libata-sff IRQ fix is probably the
most notable, but even that bug few have noticed.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig       |   22 +++++++++++-----------
 drivers/ata/Makefile      |    2 +-
 drivers/ata/libata-core.c |   24 +++++++++++++++---------
 drivers/ata/libata-eh.c   |   17 ++++++++++++++---
 drivers/ata/libata-sff.c  |    7 +++----
 drivers/ata/pata_cs5536.c |   18 ++++++++++++------
 6 files changed, 56 insertions(+), 34 deletions(-)

Tejun Heo (3):
      libata-sff: fix HSM_ST_ERR handling in __ata_sff_port_intr()
      libata: no special completion processing for EH commands
      libata: issue DIPM enable commands with LPM state updated

Wolfram Sang (1):
      pata_mpc52xx: driver needs BMDMA

Wu Zhangjin (1):
      pata_cs5536: Add support for non-X86_32 platforms

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 11ec911..36e2319 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -128,16 +128,6 @@ config PDC_ADMA
 
 	  If unsure, say N.
 
-config PATA_MPC52xx
-	tristate "Freescale MPC52xx SoC internal IDE"
-	depends on PPC_MPC52xx && PPC_BESTCOMM
-	select PPC_BESTCOMM_ATA
-	help
-	  This option enables support for integrated IDE controller
-	  of the Freescale MPC52xx SoC.
-
-	  If unsure, say N.
-
 config PATA_OCTEON_CF
 	tristate "OCTEON Boot Bus Compact Flash support"
 	depends on CPU_CAVIUM_OCTEON
@@ -366,7 +356,7 @@ config PATA_CS5535
 
 config PATA_CS5536
 	tristate "CS5536 PATA support"
-	depends on PCI && X86 && !X86_64
+	depends on PCI
 	help
 	  This option enables support for the AMD CS5536
 	  companion chip used with the Geode LX processor family.
@@ -491,6 +481,16 @@ config PATA_MARVELL
 
 	  If unsure, say N.
 
+config PATA_MPC52xx
+	tristate "Freescale MPC52xx SoC internal IDE"
+	depends on PPC_MPC52xx && PPC_BESTCOMM
+	select PPC_BESTCOMM_ATA
+	help
+	  This option enables support for integrated IDE controller
+	  of the Freescale MPC52xx SoC.
+
+	  If unsure, say N.
+
 config PATA_NETCELL
 	tristate "NETCELL Revolution RAID support"
 	depends on PCI
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index c501af5..2b67c90 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -11,7 +11,6 @@ obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
 
 # SFF w/ custom DMA
 obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
-obj-$(CONFIG_PATA_MPC52xx)	+= pata_mpc52xx.o
 obj-$(CONFIG_PATA_OCTEON_CF)	+= pata_octeon_cf.o
 obj-$(CONFIG_SATA_QSTOR)	+= sata_qstor.o
 obj-$(CONFIG_SATA_SX4)		+= sata_sx4.o
@@ -52,6 +51,7 @@ obj-$(CONFIG_PATA_IT821X)	+= pata_it821x.o
 obj-$(CONFIG_PATA_JMICRON)	+= pata_jmicron.o
 obj-$(CONFIG_PATA_MACIO)	+= pata_macio.o
 obj-$(CONFIG_PATA_MARVELL)	+= pata_marvell.o
+obj-$(CONFIG_PATA_MPC52xx)	+= pata_mpc52xx.o
 obj-$(CONFIG_PATA_NETCELL)	+= pata_netcell.o
 obj-$(CONFIG_PATA_NINJA32)	+= pata_ninja32.o
 obj-$(CONFIG_PATA_NS87415)	+= pata_ns87415.o
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 7f77c67..f23d6d4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4807,9 +4807,6 @@ static void ata_verify_xfer(struct ata_queued_cmd *qc)
 {
 	struct ata_device *dev = qc->dev;
 
-	if (ata_tag_internal(qc->tag))
-		return;
-
 	if (ata_is_nodata(qc->tf.protocol))
 		return;
 
@@ -4858,14 +4855,23 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 		if (unlikely(qc->err_mask))
 			qc->flags |= ATA_QCFLAG_FAILED;
 
-		if (unlikely(qc->flags & ATA_QCFLAG_FAILED)) {
-			/* always fill result TF for failed qc */
+		/*
+		 * Finish internal commands without any further processing
+		 * and always with the result TF filled.
+		 */
+		if (unlikely(ata_tag_internal(qc->tag))) {
 			fill_result_tf(qc);
+			__ata_qc_complete(qc);
+			return;
+		}
 
-			if (!ata_tag_internal(qc->tag))
-				ata_qc_schedule_eh(qc);
-			else
-				__ata_qc_complete(qc);
+		/*
+		 * Non-internal qc has failed.  Fill the result TF and
+		 * summon EH.
+		 */
+		if (unlikely(qc->flags & ATA_QCFLAG_FAILED)) {
+			fill_result_tf(qc);
+			ata_qc_schedule_eh(qc);
 			return;
 		}
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 5e59050..17a6378 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3275,6 +3275,7 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 	struct ata_port *ap = ata_is_host_link(link) ? link->ap : NULL;
 	struct ata_eh_context *ehc = &link->eh_context;
 	struct ata_device *dev, *link_dev = NULL, *lpm_dev = NULL;
+	enum ata_lpm_policy old_policy = link->lpm_policy;
 	unsigned int hints = ATA_LPM_EMPTY | ATA_LPM_HIPM;
 	unsigned int err_mask;
 	int rc;
@@ -3338,6 +3339,14 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 		goto fail;
 	}
 
+	/*
+	 * Low level driver acked the transition.  Issue DIPM command
+	 * with the new policy set.
+	 */
+	link->lpm_policy = policy;
+	if (ap && ap->slave_link)
+		ap->slave_link->lpm_policy = policy;
+
 	/* host config updated, enable DIPM if transitioning to MIN_POWER */
 	ata_for_each_dev(dev, link, ENABLED) {
 		if (policy == ATA_LPM_MIN_POWER && ata_id_has_dipm(dev->id)) {
@@ -3353,12 +3362,14 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 		}
 	}
 
-	link->lpm_policy = policy;
-	if (ap && ap->slave_link)
-		ap->slave_link->lpm_policy = policy;
 	return 0;
 
 fail:
+	/* restore the old policy */
+	link->lpm_policy = old_policy;
+	if (ap && ap->slave_link)
+		ap->slave_link->lpm_policy = old_policy;
+
 	/* if no device or only one more chance is left, disable LPM */
 	if (!dev || ehc->tries[dev->devno] <= 2) {
 		ata_link_printk(link, KERN_WARNING,
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index d05387d..484697f 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1532,11 +1532,10 @@ static unsigned int __ata_sff_port_intr(struct ata_port *ap,
 		if (!(qc->dev->flags & ATA_DFLAG_CDB_INTR))
 			return ata_sff_idle_irq(ap);
 		break;
-	case HSM_ST:
-	case HSM_ST_LAST:
-		break;
-	default:
+	case HSM_ST_IDLE:
 		return ata_sff_idle_irq(ap);
+	default:
+		break;
 	}
 
 	/* check main status, clearing INTRQ if needed */
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index 21ee23f..a6e6c96 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -37,10 +37,20 @@
 #include <linux/delay.h>
 #include <linux/libata.h>
 #include <scsi/scsi_host.h>
+
+#ifdef CONFIG_X86_32
 #include <asm/msr.h>
+static int use_msr;
+module_param_named(msr, use_msr, int, 0644);
+MODULE_PARM_DESC(msr, "Force using MSR to configure IDE function (Default: 0)");
+#else
+#define rdmsr(x, y, z) do { } while (0)
+#define wrmsr(x, y, z) do { } while (0)
+#define use_msr 0
+#endif
 
 #define DRV_NAME	"pata_cs5536"
-#define DRV_VERSION	"0.0.7"
+#define DRV_VERSION	"0.0.8"
 
 enum {
 	CFG			= 0,
@@ -75,8 +85,6 @@ enum {
 	IDE_ETC_NODMA		= 0x03,
 };
 
-static int use_msr;
-
 static const u32 msr_reg[4] = {
 	MSR_IDE_CFG, MSR_IDE_DTC, MSR_IDE_CAST, MSR_IDE_ETC,
 };
@@ -88,7 +96,7 @@ static const u8 pci_reg[4] = {
 static inline int cs5536_read(struct pci_dev *pdev, int reg, u32 *val)
 {
 	if (unlikely(use_msr)) {
-		u32 dummy;
+		u32 dummy __maybe_unused;
 
 		rdmsr(msr_reg[reg], *val, dummy);
 		return 0;
@@ -294,8 +302,6 @@ MODULE_DESCRIPTION("low-level driver for the CS5536 IDE controller");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, cs5536);
 MODULE_VERSION(DRV_VERSION);
-module_param_named(msr, use_msr, int, 0644);
-MODULE_PARM_DESC(msr, "Force using MSR to configure IDE function (Default: 0)");
 
 module_init(cs5536_init);
 module_exit(cs5536_exit);
