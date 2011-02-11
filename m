Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab1BKNfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 08:35:51 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43074 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab1BKNfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 08:35:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=KtabpsAzETHOw2/+9nS23icpQf36l264ij00c3XcsAqVVO3lVfdV25sKwzCMygjgtC
         Iwl9zmGeILCvDWJCkJJtEQnO+36sOvV/Zl/L+XAbywEqf5SwIxsZszeDeeGL1k9j5u+f
         6/7fuREztSGuAb5B79zwJfIr4+jKTpI3oAP/c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH v2] ata: add CONFIG_SATA_HOST config option
Date: Fri, 11 Feb 2011 14:33:40 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@mvista.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102111433.41507.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_SATA_HOST config option (for selecting SATA Host
support) to make setup easier on PATA-only systems.

Additionally move SATA-specific code to libata-sata.c which
allows us to save ~11.5k of the output code size (x86-64) on
PATA-only systems for CONFIG_SATA_HOST=n:

CONFIG_SATA_HOST=y:
   text    data     bss     dec     hex filename
  44283    6576      57   50916    c6e4 drivers/ata/libata-core.o
  29054      16       2   29072    7190 drivers/ata/libata-eh.o
  20085       0      19   20104    4e88 drivers/ata/libata-sff.o
   8699       0       0    8699    21fb drivers/ata/libata-sata.o

CONFIG_SATA_HOST=n:
   text    data     bss     dec     hex filename
  43754    6576      57   50387    c4d3 drivers/ata/libata-core.o
  26775      16       2   26793    68a9 drivers/ata/libata-eh.o
  20144       0      19   20163    4ec3 drivers/ata/libata-sff.o

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
v2:
- Kconfig fixups per Sergei's comments
- add non-SATA version of ata_std_postreset()
- drop non-SATA versions of sata_link_[debounce,hardreset,resume](),
  sata_set_spd(), sata_print_link_status() and ata_tf_from_fis()
- move SATA-specific code to libata-sata.c

 drivers/ata/Kconfig       |   23 
 drivers/ata/Makefile      |    1 
 drivers/ata/libata-core.c |  814 ------------------------------
 drivers/ata/libata-eh.c   |  411 ---------------
 drivers/ata/libata-sata.c | 1242 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-sff.c  |   32 -
 drivers/ata/libata.h      |   52 +
 include/linux/libata.h    |   32 -
 8 files changed, 1366 insertions(+), 1241 deletions(-)

Index: b/drivers/ata/Kconfig
===================================================================
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -50,13 +50,22 @@ config ATA_ACPI
 	  You can disable this at kernel boot time by using the
 	  option libata.noacpi=1
 
+config SATA_HOST
+	bool "SATA Host support"
+	default y
+	help
+	  This option adds support for SATA Hosts.
+
 config SATA_PMP
 	bool "SATA Port Multiplier support"
+	depends on SATA_HOST
 	default y
 	help
 	  This option adds support for SATA Port Multipliers
 	  (the SATA version of an ethernet hub, or SAS expander).
 
+if SATA_HOST
+
 comment "Controllers with non-SFF native interface"
 
 config SATA_AHCI
@@ -98,6 +107,8 @@ config SATA_SIL24
 
 	  If unsure, say N.
 
+endif # SATA_HOST
+
 config ATA_SFF
 	bool "ATA SFF support"
 	default y
@@ -139,7 +150,7 @@ config PATA_OCTEON_CF
 
 config SATA_QSTOR
 	tristate "Pacific Digital SATA QStor support"
-	depends on PCI
+	depends on PCI && SATA_HOST
 	help
 	  This option enables support for Pacific Digital Serial ATA QStor.
 
@@ -147,7 +158,7 @@ config SATA_QSTOR
 
 config SATA_SX4
 	tristate "Promise SATA SX4 support (Experimental)"
-	depends on PCI && EXPERIMENTAL
+	depends on PCI && SATA_HOST && EXPERIMENTAL
 	help
 	  This option enables support for Promise Serial ATA SX4.
 
@@ -165,8 +176,6 @@ config ATA_BMDMA
 
 if ATA_BMDMA
 
-comment "SATA SFF controllers with BMDMA"
-
 config ATA_PIIX
 	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
 	depends on PCI
@@ -177,6 +186,10 @@ config ATA_PIIX
 
 	  If unsure, say N.
 
+if SATA_HOST
+
+comment "SATA SFF controllers with BMDMA"
+
 config SATA_DWC
 	tristate "DesignWare Cores SATA support"
 	depends on 460EX
@@ -263,6 +276,8 @@ config SATA_VITESSE
 
 	  If unsure, say N.
 
+endif # SATA_HOST
+
 comment "PATA SFF controllers with BMDMA"
 
 config PATA_ALI
Index: b/drivers/ata/Makefile
===================================================================
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -95,6 +95,7 @@ obj-$(CONFIG_ATA_GENERIC)	+= ata_generic
 obj-$(CONFIG_PATA_LEGACY)	+= pata_legacy.o
 
 libata-y	:= libata-core.o libata-scsi.o libata-eh.o libata-transport.o
+libata-$(CONFIG_SATA_HOST)	+= libata-sata.o
 libata-$(CONFIG_ATA_SFF)	+= libata-sff.o
 libata-$(CONFIG_SATA_PMP)	+= libata-pmp.o
 libata-$(CONFIG_ATA_ACPI)	+= libata-acpi.o
Index: b/drivers/ata/libata-core.c
===================================================================
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -70,11 +70,6 @@
 #include "libata.h"
 #include "libata-transport.h"
 
-/* debounce timing parameters in msecs { interval, duration, timeout } */
-const unsigned long sata_deb_timing_normal[]		= {   5,  100, 2000 };
-const unsigned long sata_deb_timing_hotplug[]		= {  25,  500, 2000 };
-const unsigned long sata_deb_timing_long[]		= { 100, 2000, 5000 };
-
 const struct ata_port_operations ata_base_port_ops = {
 	.prereset		= ata_std_prereset,
 	.postreset		= ata_std_postreset,
@@ -96,24 +91,8 @@ static unsigned long ata_dev_blacklisted
 
 unsigned int ata_print_id = 1;
 
-struct ata_force_param {
-	const char	*name;
-	unsigned int	cbl;
-	int		spd_limit;
-	unsigned long	xfer_mask;
-	unsigned int	horkage_on;
-	unsigned int	horkage_off;
-	unsigned int	lflags;
-};
-
-struct ata_force_ent {
-	int			port;
-	int			device;
-	struct ata_force_param	param;
-};
-
-static struct ata_force_ent *ata_force_tbl;
-static int ata_force_tbl_size;
+struct ata_force_ent *ata_force_tbl;
+int ata_force_tbl_size;
 
 static char ata_force_param_buf[PAGE_SIZE] __initdata;
 /* param_buf is thrown away after initialization, disallow read */
@@ -166,11 +145,6 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
 
-static bool ata_sstatus_online(u32 sstatus)
-{
-	return (sstatus & 0xf) == 0x3;
-}
-
 /**
  *	ata_link_next - link iteration helper
  *	@link: the previous link, NULL to start
@@ -342,59 +316,6 @@ void ata_force_cbl(struct ata_port *ap)
 }
 
 /**
- *	ata_force_link_limits - force link limits according to libata.force
- *	@link: ATA link of interest
- *
- *	Force link flags and SATA spd limit according to libata.force
- *	and whine about it.  When only the port part is specified
- *	(e.g. 1:), the limit applies to all links connected to both
- *	the host link and all fan-out ports connected via PMP.  If the
- *	device part is specified as 0 (e.g. 1.00:), it specifies the
- *	first fan-out link not the host link.  Device number 15 always
- *	points to the host link whether PMP is attached or not.  If the
- *	controller has slave link, device number 16 points to it.
- *
- *	LOCKING:
- *	EH context.
- */
-static void ata_force_link_limits(struct ata_link *link)
-{
-	bool did_spd = false;
-	int linkno = link->pmp;
-	int i;
-
-	if (ata_is_host_link(link))
-		linkno += 15;
-
-	for (i = ata_force_tbl_size - 1; i >= 0; i--) {
-		const struct ata_force_ent *fe = &ata_force_tbl[i];
-
-		if (fe->port != -1 && fe->port != link->ap->print_id)
-			continue;
-
-		if (fe->device != -1 && fe->device != linkno)
-			continue;
-
-		/* only honor the first spd limit */
-		if (!did_spd && fe->param.spd_limit) {
-			link->hw_sata_spd_limit = (1 << fe->param.spd_limit) - 1;
-			ata_link_printk(link, KERN_NOTICE,
-					"FORCE: PHY spd limit set to %s\n",
-					fe->param.name);
-			did_spd = true;
-		}
-
-		/* let lflags stack */
-		if (fe->param.lflags) {
-			link->flags |= fe->param.lflags;
-			ata_link_printk(link, KERN_NOTICE,
-					"FORCE: link flag 0x%x forced -> 0x%x\n",
-					fe->param.lflags, link->flags);
-		}
-	}
-}
-
-/**
  *	ata_force_xfermask - force xfermask according to libata.force
  *	@dev: ATA device of interest
  *
@@ -573,34 +494,26 @@ void ata_tf_to_fis(const struct ata_task
 	fis[19] = 0;
 }
 
-/**
- *	ata_tf_from_fis - Convert SATA FIS to ATA taskfile
- *	@fis: Buffer from which data will be input
- *	@tf: Taskfile to output
- *
- *	Converts a serial ATA FIS structure to a standard ATA taskfile.
- *
- *	LOCKING:
- *	Inherited from caller.
- */
-
-void ata_tf_from_fis(const u8 *fis, struct ata_taskfile *tf)
+#ifndef CONFIG_SATA_HOST
+int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
+		      bool spm_wakeup)
 {
-	tf->command	= fis[2];	/* status */
-	tf->feature	= fis[3];	/* error */
-
-	tf->lbal	= fis[4];
-	tf->lbam	= fis[5];
-	tf->lbah	= fis[6];
-	tf->device	= fis[7];
-
-	tf->hob_lbal	= fis[8];
-	tf->hob_lbam	= fis[9];
-	tf->hob_lbah	= fis[10];
-
-	tf->nsect	= fis[12];
-	tf->hob_nsect	= fis[13];
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL_GPL(sata_link_scr_lpm);
+int sata_std_hardreset(struct ata_link *link, unsigned int *class,
+		       unsigned long deadline)
+{
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL_GPL(sata_std_hardreset);
+void ata_std_postreset(struct ata_link *link, unsigned int *classes)
+{
+	DPRINTK("ENTER\n");
+	DPRINTK("EXIT\n");
 }
+EXPORT_SYMBOL_GPL(ata_std_postreset);
+#endif
 
 static const u8 ata_rw_cmds[] = {
 	/* pio multi */
@@ -2039,40 +1952,6 @@ retry:
 	return rc;
 }
 
-static int ata_do_link_spd_horkage(struct ata_device *dev)
-{
-	struct ata_link *plink = ata_dev_phys_link(dev);
-	u32 target, target_limit;
-
-	if (!sata_scr_valid(plink))
-		return 0;
-
-	if (dev->horkage & ATA_HORKAGE_1_5_GBPS)
-		target = 1;
-	else
-		return 0;
-
-	target_limit = (1 << target) - 1;
-
-	/* if already on stricter limit, no need to push further */
-	if (plink->sata_spd_limit <= target_limit)
-		return 0;
-
-	plink->sata_spd_limit = target_limit;
-
-	/* Request another EH round by returning -EAGAIN if link is
-	 * going faster than the target speed.  Forward progress is
-	 * guaranteed by setting sata_spd_limit to target_limit above.
-	 */
-	if (plink->sata_spd > target) {
-		ata_dev_printk(dev, KERN_INFO,
-			       "applying link speed limit horkage to %s\n",
-			       sata_spd_string(target));
-		return -EAGAIN;
-	}
-	return 0;
-}
-
 static inline u8 ata_dev_knobble(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->link->ap;
@@ -2083,51 +1962,6 @@ static inline u8 ata_dev_knobble(struct
 	return ((ap->cbl == ATA_CBL_SATA) && (!ata_id_is_sata(dev->id)));
 }
 
-static int ata_dev_config_ncq(struct ata_device *dev,
-			       char *desc, size_t desc_sz)
-{
-	struct ata_port *ap = dev->link->ap;
-	int hdepth = 0, ddepth = ata_id_queue_depth(dev->id);
-	unsigned int err_mask;
-	char *aa_desc = "";
-
-	if (!ata_id_has_ncq(dev->id)) {
-		desc[0] = '\0';
-		return 0;
-	}
-	if (dev->horkage & ATA_HORKAGE_NONCQ) {
-		snprintf(desc, desc_sz, "NCQ (not used)");
-		return 0;
-	}
-	if (ap->flags & ATA_FLAG_NCQ) {
-		hdepth = min(ap->scsi_host->can_queue, ATA_MAX_QUEUE - 1);
-		dev->flags |= ATA_DFLAG_NCQ;
-	}
-
-	if (!(dev->horkage & ATA_HORKAGE_BROKEN_FPDMA_AA) &&
-		(ap->flags & ATA_FLAG_FPDMA_AA) &&
-		ata_id_has_fpdma_aa(dev->id)) {
-		err_mask = ata_dev_set_feature(dev, SETFEATURES_SATA_ENABLE,
-			SATA_FPDMA_AA);
-		if (err_mask) {
-			ata_dev_printk(dev, KERN_ERR, "failed to enable AA"
-				"(error_mask=0x%x)\n", err_mask);
-			if (err_mask != AC_ERR_DEV) {
-				dev->horkage |= ATA_HORKAGE_BROKEN_FPDMA_AA;
-				return -EIO;
-			}
-		} else
-			aa_desc = ", AA";
-	}
-
-	if (hdepth >= ddepth)
-		snprintf(desc, desc_sz, "NCQ (depth %d)%s", ddepth, aa_desc);
-	else
-		snprintf(desc, desc_sz, "NCQ (depth %d/%d)%s", hdepth,
-			ddepth, aa_desc);
-	return 0;
-}
-
 /**
  *	ata_dev_configure - Configure the specified ATA/ATAPI device
  *	@dev: Target device to configure
@@ -2645,35 +2479,6 @@ int ata_bus_probe(struct ata_port *ap)
 }
 
 /**
- *	sata_print_link_status - Print SATA link status
- *	@link: SATA link to printk link status about
- *
- *	This function prints link speed and status of a SATA link.
- *
- *	LOCKING:
- *	None.
- */
-static void sata_print_link_status(struct ata_link *link)
-{
-	u32 sstatus, scontrol, tmp;
-
-	if (sata_scr_read(link, SCR_STATUS, &sstatus))
-		return;
-	sata_scr_read(link, SCR_CONTROL, &scontrol);
-
-	if (ata_phys_link_online(link)) {
-		tmp = (sstatus >> 4) & 0xf;
-		ata_link_printk(link, KERN_INFO,
-				"SATA link up %s (SStatus %X SControl %X)\n",
-				sata_spd_string(tmp), sstatus, scontrol);
-	} else {
-		ata_link_printk(link, KERN_INFO,
-				"SATA link down (SStatus %X SControl %X)\n",
-				sstatus, scontrol);
-	}
-}
-
-/**
  *	ata_dev_pair		-	return other device on cable
  *	@adev: device
  *
@@ -2690,160 +2495,6 @@ struct ata_device *ata_dev_pair(struct a
 	return pair;
 }
 
-/**
- *	sata_down_spd_limit - adjust SATA spd limit downward
- *	@link: Link to adjust SATA spd limit for
- *	@spd_limit: Additional limit
- *
- *	Adjust SATA spd limit of @link downward.  Note that this
- *	function only adjusts the limit.  The change must be applied
- *	using sata_set_spd().
- *
- *	If @spd_limit is non-zero, the speed is limited to equal to or
- *	lower than @spd_limit if such speed is supported.  If
- *	@spd_limit is slower than any supported speed, only the lowest
- *	supported speed is allowed.
- *
- *	LOCKING:
- *	Inherited from caller.
- *
- *	RETURNS:
- *	0 on success, negative errno on failure
- */
-int sata_down_spd_limit(struct ata_link *link, u32 spd_limit)
-{
-	u32 sstatus, spd, mask;
-	int rc, bit;
-
-	if (!sata_scr_valid(link))
-		return -EOPNOTSUPP;
-
-	/* If SCR can be read, use it to determine the current SPD.
-	 * If not, use cached value in link->sata_spd.
-	 */
-	rc = sata_scr_read(link, SCR_STATUS, &sstatus);
-	if (rc == 0 && ata_sstatus_online(sstatus))
-		spd = (sstatus >> 4) & 0xf;
-	else
-		spd = link->sata_spd;
-
-	mask = link->sata_spd_limit;
-	if (mask <= 1)
-		return -EINVAL;
-
-	/* unconditionally mask off the highest bit */
-	bit = fls(mask) - 1;
-	mask &= ~(1 << bit);
-
-	/* Mask off all speeds higher than or equal to the current
-	 * one.  Force 1.5Gbps if current SPD is not available.
-	 */
-	if (spd > 1)
-		mask &= (1 << (spd - 1)) - 1;
-	else
-		mask &= 1;
-
-	/* were we already at the bottom? */
-	if (!mask)
-		return -EINVAL;
-
-	if (spd_limit) {
-		if (mask & ((1 << spd_limit) - 1))
-			mask &= (1 << spd_limit) - 1;
-		else {
-			bit = ffs(mask) - 1;
-			mask = 1 << bit;
-		}
-	}
-
-	link->sata_spd_limit = mask;
-
-	ata_link_printk(link, KERN_WARNING, "limiting SATA link speed to %s\n",
-			sata_spd_string(fls(mask)));
-
-	return 0;
-}
-
-static int __sata_set_spd_needed(struct ata_link *link, u32 *scontrol)
-{
-	struct ata_link *host_link = &link->ap->link;
-	u32 limit, target, spd;
-
-	limit = link->sata_spd_limit;
-
-	/* Don't configure downstream link faster than upstream link.
-	 * It doesn't speed up anything and some PMPs choke on such
-	 * configuration.
-	 */
-	if (!ata_is_host_link(link) && host_link->sata_spd)
-		limit &= (1 << host_link->sata_spd) - 1;
-
-	if (limit == UINT_MAX)
-		target = 0;
-	else
-		target = fls(limit);
-
-	spd = (*scontrol >> 4) & 0xf;
-	*scontrol = (*scontrol & ~0xf0) | ((target & 0xf) << 4);
-
-	return spd != target;
-}
-
-/**
- *	sata_set_spd_needed - is SATA spd configuration needed
- *	@link: Link in question
- *
- *	Test whether the spd limit in SControl matches
- *	@link->sata_spd_limit.  This function is used to determine
- *	whether hardreset is necessary to apply SATA spd
- *	configuration.
- *
- *	LOCKING:
- *	Inherited from caller.
- *
- *	RETURNS:
- *	1 if SATA spd configuration is needed, 0 otherwise.
- */
-static int sata_set_spd_needed(struct ata_link *link)
-{
-	u32 scontrol;
-
-	if (sata_scr_read(link, SCR_CONTROL, &scontrol))
-		return 1;
-
-	return __sata_set_spd_needed(link, &scontrol);
-}
-
-/**
- *	sata_set_spd - set SATA spd according to spd limit
- *	@link: Link to set SATA spd for
- *
- *	Set SATA spd of @link according to sata_spd_limit.
- *
- *	LOCKING:
- *	Inherited from caller.
- *
- *	RETURNS:
- *	0 if spd doesn't need to be changed, 1 if spd has been
- *	changed.  Negative errno if SCR registers are inaccessible.
- */
-int sata_set_spd(struct ata_link *link)
-{
-	u32 scontrol;
-	int rc;
-
-	if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
-		return rc;
-
-	if (!__sata_set_spd_needed(link, &scontrol))
-		return 0;
-
-	if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
-		return rc;
-
-	return 1;
-}
-
 /*
  * This mode timing computation functionality is ported over from
  * drivers/ide/ide-timing.h and was originally written by Vojtech Pavlik
@@ -3437,209 +3088,6 @@ int ata_wait_after_reset(struct ata_link
 }
 
 /**
- *	sata_link_debounce - debounce SATA phy status
- *	@link: ATA link to debounce SATA phy status for
- *	@params: timing parameters { interval, duratinon, timeout } in msec
- *	@deadline: deadline jiffies for the operation
- *
- *	Make sure SStatus of @link reaches stable state, determined by
- *	holding the same value where DET is not 1 for @duration polled
- *	every @interval, before @timeout.  Timeout constraints the
- *	beginning of the stable state.  Because DET gets stuck at 1 on
- *	some controllers after hot unplugging, this functions waits
- *	until timeout then returns 0 if DET is stable at 1.
- *
- *	@timeout is further limited by @deadline.  The sooner of the
- *	two is used.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep)
- *
- *	RETURNS:
- *	0 on success, -errno on failure.
- */
-int sata_link_debounce(struct ata_link *link, const unsigned long *params,
-		       unsigned long deadline)
-{
-	unsigned long interval = params[0];
-	unsigned long duration = params[1];
-	unsigned long last_jiffies, t;
-	u32 last, cur;
-	int rc;
-
-	t = ata_deadline(jiffies, params[2]);
-	if (time_before(t, deadline))
-		deadline = t;
-
-	if ((rc = sata_scr_read(link, SCR_STATUS, &cur)))
-		return rc;
-	cur &= 0xf;
-
-	last = cur;
-	last_jiffies = jiffies;
-
-	while (1) {
-		ata_msleep(link->ap, interval);
-		if ((rc = sata_scr_read(link, SCR_STATUS, &cur)))
-			return rc;
-		cur &= 0xf;
-
-		/* DET stable? */
-		if (cur == last) {
-			if (cur == 1 && time_before(jiffies, deadline))
-				continue;
-			if (time_after(jiffies,
-				       ata_deadline(last_jiffies, duration)))
-				return 0;
-			continue;
-		}
-
-		/* unstable, start over */
-		last = cur;
-		last_jiffies = jiffies;
-
-		/* Check deadline.  If debouncing failed, return
-		 * -EPIPE to tell upper layer to lower link speed.
-		 */
-		if (time_after(jiffies, deadline))
-			return -EPIPE;
-	}
-}
-
-/**
- *	sata_link_resume - resume SATA link
- *	@link: ATA link to resume SATA
- *	@params: timing parameters { interval, duratinon, timeout } in msec
- *	@deadline: deadline jiffies for the operation
- *
- *	Resume SATA phy @link and debounce it.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep)
- *
- *	RETURNS:
- *	0 on success, -errno on failure.
- */
-int sata_link_resume(struct ata_link *link, const unsigned long *params,
-		     unsigned long deadline)
-{
-	int tries = ATA_LINK_RESUME_TRIES;
-	u32 scontrol, serror;
-	int rc;
-
-	if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
-		return rc;
-
-	/*
-	 * Writes to SControl sometimes get ignored under certain
-	 * controllers (ata_piix SIDPR).  Make sure DET actually is
-	 * cleared.
-	 */
-	do {
-		scontrol = (scontrol & 0x0f0) | 0x300;
-		if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
-			return rc;
-		/*
-		 * Some PHYs react badly if SStatus is pounded
-		 * immediately after resuming.  Delay 200ms before
-		 * debouncing.
-		 */
-		ata_msleep(link->ap, 200);
-
-		/* is SControl restored correctly? */
-		if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
-			return rc;
-	} while ((scontrol & 0xf0f) != 0x300 && --tries);
-
-	if ((scontrol & 0xf0f) != 0x300) {
-		ata_link_printk(link, KERN_ERR,
-				"failed to resume link (SControl %X)\n",
-				scontrol);
-		return 0;
-	}
-
-	if (tries < ATA_LINK_RESUME_TRIES)
-		ata_link_printk(link, KERN_WARNING,
-				"link resume succeeded after %d retries\n",
-				ATA_LINK_RESUME_TRIES - tries);
-
-	if ((rc = sata_link_debounce(link, params, deadline)))
-		return rc;
-
-	/* clear SError, some PHYs require this even for SRST to work */
-	if (!(rc = sata_scr_read(link, SCR_ERROR, &serror)))
-		rc = sata_scr_write(link, SCR_ERROR, serror);
-
-	return rc != -EINVAL ? rc : 0;
-}
-
-/**
- *	sata_link_scr_lpm - manipulate SControl IPM and SPM fields
- *	@link: ATA link to manipulate SControl for
- *	@policy: LPM policy to configure
- *	@spm_wakeup: initiate LPM transition to active state
- *
- *	Manipulate the IPM field of the SControl register of @link
- *	according to @policy.  If @policy is ATA_LPM_MAX_POWER and
- *	@spm_wakeup is %true, the SPM field is manipulated to wake up
- *	the link.  This function also clears PHYRDY_CHG before
- *	returning.
- *
- *	LOCKING:
- *	EH context.
- *
- *	RETURNS:
- *	0 on succes, -errno otherwise.
- */
-int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
-		      bool spm_wakeup)
-{
-	struct ata_eh_context *ehc = &link->eh_context;
-	bool woken_up = false;
-	u32 scontrol;
-	int rc;
-
-	rc = sata_scr_read(link, SCR_CONTROL, &scontrol);
-	if (rc)
-		return rc;
-
-	switch (policy) {
-	case ATA_LPM_MAX_POWER:
-		/* disable all LPM transitions */
-		scontrol |= (0x3 << 8);
-		/* initiate transition to active state */
-		if (spm_wakeup) {
-			scontrol |= (0x4 << 12);
-			woken_up = true;
-		}
-		break;
-	case ATA_LPM_MED_POWER:
-		/* allow LPM to PARTIAL */
-		scontrol &= ~(0x1 << 8);
-		scontrol |= (0x2 << 8);
-		break;
-	case ATA_LPM_MIN_POWER:
-		/* no restrictions on LPM transitions */
-		scontrol &= ~(0x3 << 8);
-		break;
-	default:
-		WARN_ON(1);
-	}
-
-	rc = sata_scr_write(link, SCR_CONTROL, scontrol);
-	if (rc)
-		return rc;
-
-	/* give the link time to transit out of LPM state */
-	if (woken_up)
-		msleep(10);
-
-	/* clear PHYRDY_CHG from SError */
-	ehc->i.serror &= ~SERR_PHYRDY_CHG;
-	return sata_scr_write(link, SCR_ERROR, SERR_PHYRDY_CHG);
-}
-
-/**
  *	ata_std_prereset - prepare for reset
  *	@link: ATA link to be reset
  *	@deadline: deadline jiffies for the operation
@@ -3658,23 +3106,26 @@ int sata_link_scr_lpm(struct ata_link *l
  */
 int ata_std_prereset(struct ata_link *link, unsigned long deadline)
 {
-	struct ata_port *ap = link->ap;
 	struct ata_eh_context *ehc = &link->eh_context;
-	const unsigned long *timing = sata_ehc_deb_timing(ehc);
-	int rc;
+	struct ata_port *ap __maybe_unused = link->ap;
 
 	/* if we're about to do hardreset, nothing more to do */
 	if (ehc->i.action & ATA_EH_HARDRESET)
 		return 0;
 
+#ifdef CONFIG_SATA_HOST
 	/* if SATA, resume link */
 	if (ap->flags & ATA_FLAG_SATA) {
+		const unsigned long *timing = sata_ehc_deb_timing(ehc);
+		int rc;
+
 		rc = sata_link_resume(link, timing, deadline);
 		/* whine about phy resume failure but proceed */
 		if (rc && rc != -EOPNOTSUPP)
 			ata_link_printk(link, KERN_WARNING, "failed to resume "
 					"link for reset (errno=%d)\n", rc);
 	}
+#endif
 
 	/* no point in trying softreset on offline link */
 	if (ata_phys_link_offline(link))
@@ -3684,173 +3135,6 @@ int ata_std_prereset(struct ata_link *li
 }
 
 /**
- *	sata_link_hardreset - reset link via SATA phy reset
- *	@link: link to reset
- *	@timing: timing parameters { interval, duratinon, timeout } in msec
- *	@deadline: deadline jiffies for the operation
- *	@online: optional out parameter indicating link onlineness
- *	@check_ready: optional callback to check link readiness
- *
- *	SATA phy-reset @link using DET bits of SControl register.
- *	After hardreset, link readiness is waited upon using
- *	ata_wait_ready() if @check_ready is specified.  LLDs are
- *	allowed to not specify @check_ready and wait itself after this
- *	function returns.  Device classification is LLD's
- *	responsibility.
- *
- *	*@online is set to one iff reset succeeded and @link is online
- *	after reset.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep)
- *
- *	RETURNS:
- *	0 on success, -errno otherwise.
- */
-int sata_link_hardreset(struct ata_link *link, const unsigned long *timing,
-			unsigned long deadline,
-			bool *online, int (*check_ready)(struct ata_link *))
-{
-	u32 scontrol;
-	int rc;
-
-	DPRINTK("ENTER\n");
-
-	if (online)
-		*online = false;
-
-	if (sata_set_spd_needed(link)) {
-		/* SATA spec says nothing about how to reconfigure
-		 * spd.  To be on the safe side, turn off phy during
-		 * reconfiguration.  This works for at least ICH7 AHCI
-		 * and Sil3124.
-		 */
-		if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
-			goto out;
-
-		scontrol = (scontrol & 0x0f0) | 0x304;
-
-		if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
-			goto out;
-
-		sata_set_spd(link);
-	}
-
-	/* issue phy wake/reset */
-	if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
-		goto out;
-
-	scontrol = (scontrol & 0x0f0) | 0x301;
-
-	if ((rc = sata_scr_write_flush(link, SCR_CONTROL, scontrol)))
-		goto out;
-
-	/* Couldn't find anything in SATA I/II specs, but AHCI-1.1
-	 * 10.4.2 says at least 1 ms.
-	 */
-	ata_msleep(link->ap, 1);
-
-	/* bring link back */
-	rc = sata_link_resume(link, timing, deadline);
-	if (rc)
-		goto out;
-	/* if link is offline nothing more to do */
-	if (ata_phys_link_offline(link))
-		goto out;
-
-	/* Link is online.  From this point, -ENODEV too is an error. */
-	if (online)
-		*online = true;
-
-	if (sata_pmp_supported(link->ap) && ata_is_host_link(link)) {
-		/* If PMP is supported, we have to do follow-up SRST.
-		 * Some PMPs don't send D2H Reg FIS after hardreset if
-		 * the first port is empty.  Wait only for
-		 * ATA_TMOUT_PMP_SRST_WAIT.
-		 */
-		if (check_ready) {
-			unsigned long pmp_deadline;
-
-			pmp_deadline = ata_deadline(jiffies,
-						    ATA_TMOUT_PMP_SRST_WAIT);
-			if (time_after(pmp_deadline, deadline))
-				pmp_deadline = deadline;
-			ata_wait_ready(link, pmp_deadline, check_ready);
-		}
-		rc = -EAGAIN;
-		goto out;
-	}
-
-	rc = 0;
-	if (check_ready)
-		rc = ata_wait_ready(link, deadline, check_ready);
- out:
-	if (rc && rc != -EAGAIN) {
-		/* online is set iff link is online && reset succeeded */
-		if (online)
-			*online = false;
-		ata_link_printk(link, KERN_ERR,
-				"COMRESET failed (errno=%d)\n", rc);
-	}
-	DPRINTK("EXIT, rc=%d\n", rc);
-	return rc;
-}
-
-/**
- *	sata_std_hardreset - COMRESET w/o waiting or classification
- *	@link: link to reset
- *	@class: resulting class of attached device
- *	@deadline: deadline jiffies for the operation
- *
- *	Standard SATA COMRESET w/o waiting or classification.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep)
- *
- *	RETURNS:
- *	0 if link offline, -EAGAIN if link online, -errno on errors.
- */
-int sata_std_hardreset(struct ata_link *link, unsigned int *class,
-		       unsigned long deadline)
-{
-	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
-	bool online;
-	int rc;
-
-	/* do hardreset */
-	rc = sata_link_hardreset(link, timing, deadline, &online, NULL);
-	return online ? -EAGAIN : rc;
-}
-
-/**
- *	ata_std_postreset - standard postreset callback
- *	@link: the target ata_link
- *	@classes: classes of attached devices
- *
- *	This function is invoked after a successful reset.  Note that
- *	the device might have been reset more than once using
- *	different reset methods before postreset is invoked.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep)
- */
-void ata_std_postreset(struct ata_link *link, unsigned int *classes)
-{
-	u32 serror;
-
-	DPRINTK("ENTER\n");
-
-	/* reset complete, clear SError */
-	if (!sata_scr_read(link, SCR_ERROR, &serror))
-		sata_scr_write(link, SCR_ERROR, serror);
-
-	/* print link status */
-	sata_print_link_status(link);
-
-	DPRINTK("EXIT\n");
-}
-
-/**
  *	ata_dev_same_device - Determine whether new ID matches configured device
  *	@dev: device to compare against
  *	@new_class: class of the new device
@@ -5425,39 +4709,6 @@ void ata_link_init(struct ata_port *ap,
 }
 
 /**
- *	sata_link_init_spd - Initialize link->sata_spd_limit
- *	@link: Link to configure sata_spd_limit for
- *
- *	Initialize @link->[hw_]sata_spd_limit to the currently
- *	configured value.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).
- *
- *	RETURNS:
- *	0 on success, -errno on failure.
- */
-int sata_link_init_spd(struct ata_link *link)
-{
-	u8 spd;
-	int rc;
-
-	rc = sata_scr_read(link, SCR_CONTROL, &link->saved_scontrol);
-	if (rc)
-		return rc;
-
-	spd = (link->saved_scontrol >> 4) & 0xf;
-	if (spd)
-		link->hw_sata_spd_limit &= (1 << spd) - 1;
-
-	ata_force_link_limits(link);
-
-	link->sata_spd_limit = link->hw_sata_spd_limit;
-
-	return 0;
-}
-
-/**
  *	ata_port_alloc - allocate and initialize basic ATA port resources
  *	@host: ATA host this allocated port belongs to
  *
@@ -6599,9 +5850,6 @@ const struct ata_port_info ata_dummy_por
  * likely to change as new drivers are added and updated.
  * Do not depend on ABI/API stability.
  */
-EXPORT_SYMBOL_GPL(sata_deb_timing_normal);
-EXPORT_SYMBOL_GPL(sata_deb_timing_hotplug);
-EXPORT_SYMBOL_GPL(sata_deb_timing_long);
 EXPORT_SYMBOL_GPL(ata_base_port_ops);
 EXPORT_SYMBOL_GPL(sata_port_ops);
 EXPORT_SYMBOL_GPL(ata_dummy_port_ops);
@@ -6623,7 +5871,6 @@ EXPORT_SYMBOL_GPL(ata_qc_complete);
 EXPORT_SYMBOL_GPL(ata_qc_complete_multiple);
 EXPORT_SYMBOL_GPL(atapi_cmd_type);
 EXPORT_SYMBOL_GPL(ata_tf_to_fis);
-EXPORT_SYMBOL_GPL(ata_tf_from_fis);
 EXPORT_SYMBOL_GPL(ata_pack_xfermask);
 EXPORT_SYMBOL_GPL(ata_unpack_xfermask);
 EXPORT_SYMBOL_GPL(ata_xfer_mask2mode);
@@ -6635,15 +5882,8 @@ EXPORT_SYMBOL_GPL(ata_do_set_mode);
 EXPORT_SYMBOL_GPL(ata_std_qc_defer);
 EXPORT_SYMBOL_GPL(ata_noop_qc_prep);
 EXPORT_SYMBOL_GPL(ata_dev_disable);
-EXPORT_SYMBOL_GPL(sata_set_spd);
 EXPORT_SYMBOL_GPL(ata_wait_after_reset);
-EXPORT_SYMBOL_GPL(sata_link_debounce);
-EXPORT_SYMBOL_GPL(sata_link_resume);
-EXPORT_SYMBOL_GPL(sata_link_scr_lpm);
 EXPORT_SYMBOL_GPL(ata_std_prereset);
-EXPORT_SYMBOL_GPL(sata_link_hardreset);
-EXPORT_SYMBOL_GPL(sata_std_hardreset);
-EXPORT_SYMBOL_GPL(ata_std_postreset);
 EXPORT_SYMBOL_GPL(ata_dev_classify);
 EXPORT_SYMBOL_GPL(ata_dev_pair);
 EXPORT_SYMBOL_GPL(ata_ratelimit);
@@ -6696,12 +5936,10 @@ EXPORT_SYMBOL_GPL(ata_port_schedule_eh);
 EXPORT_SYMBOL_GPL(ata_link_abort);
 EXPORT_SYMBOL_GPL(ata_port_abort);
 EXPORT_SYMBOL_GPL(ata_port_freeze);
-EXPORT_SYMBOL_GPL(sata_async_notification);
 EXPORT_SYMBOL_GPL(ata_eh_freeze_port);
 EXPORT_SYMBOL_GPL(ata_eh_thaw_port);
 EXPORT_SYMBOL_GPL(ata_eh_qc_complete);
 EXPORT_SYMBOL_GPL(ata_eh_qc_retry);
-EXPORT_SYMBOL_GPL(ata_eh_analyze_ncq_error);
 EXPORT_SYMBOL_GPL(ata_do_eh);
 EXPORT_SYMBOL_GPL(ata_std_error_handler);
 
Index: b/drivers/ata/libata-eh.c
===================================================================
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1081,79 +1081,6 @@ int ata_port_freeze(struct ata_port *ap)
 }
 
 /**
- *	sata_async_notification - SATA async notification handler
- *	@ap: ATA port where async notification is received
- *
- *	Handler to be called when async notification via SDB FIS is
- *	received.  This function schedules EH if necessary.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- *
- *	RETURNS:
- *	1 if EH is scheduled, 0 otherwise.
- */
-int sata_async_notification(struct ata_port *ap)
-{
-	u32 sntf;
-	int rc;
-
-	if (!(ap->flags & ATA_FLAG_AN))
-		return 0;
-
-	rc = sata_scr_read(&ap->link, SCR_NOTIFICATION, &sntf);
-	if (rc == 0)
-		sata_scr_write(&ap->link, SCR_NOTIFICATION, sntf);
-
-	if (!sata_pmp_attached(ap) || rc) {
-		/* PMP is not attached or SNTF is not available */
-		if (!sata_pmp_attached(ap)) {
-			/* PMP is not attached.  Check whether ATAPI
-			 * AN is configured.  If so, notify media
-			 * change.
-			 */
-			struct ata_device *dev = ap->link.device;
-
-			if ((dev->class == ATA_DEV_ATAPI) &&
-			    (dev->flags & ATA_DFLAG_AN))
-				ata_scsi_media_change_notify(dev);
-			return 0;
-		} else {
-			/* PMP is attached but SNTF is not available.
-			 * ATAPI async media change notification is
-			 * not used.  The PMP must be reporting PHY
-			 * status change, schedule EH.
-			 */
-			ata_port_schedule_eh(ap);
-			return 1;
-		}
-	} else {
-		/* PMP is attached and SNTF is available */
-		struct ata_link *link;
-
-		/* check and notify ATAPI AN */
-		ata_for_each_link(link, ap, EDGE) {
-			if (!(sntf & (1 << link->pmp)))
-				continue;
-
-			if ((link->device->class == ATA_DEV_ATAPI) &&
-			    (link->device->flags & ATA_DFLAG_AN))
-				ata_scsi_media_change_notify(link->device);
-		}
-
-		/* If PMP is reporting that PHY status of some
-		 * downstream ports has changed, schedule EH.
-		 */
-		if (sntf & (1 << SATA_PMP_CTRL_PORT)) {
-			ata_port_schedule_eh(ap);
-			return 1;
-		}
-
-		return 0;
-	}
-}
-
-/**
  *	ata_eh_freeze_port - EH helper to freeze port
  *	@ap: ATA port to freeze
  *
@@ -1407,98 +1334,6 @@ static const char *ata_err_string(unsign
 }
 
 /**
- *	ata_read_log_page - read a specific log page
- *	@dev: target device
- *	@page: page to read
- *	@buf: buffer to store read page
- *	@sectors: number of sectors to read
- *
- *	Read log page using READ_LOG_EXT command.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).
- *
- *	RETURNS:
- *	0 on success, AC_ERR_* mask otherwise.
- */
-static unsigned int ata_read_log_page(struct ata_device *dev,
-				      u8 page, void *buf, unsigned int sectors)
-{
-	struct ata_taskfile tf;
-	unsigned int err_mask;
-
-	DPRINTK("read log page - page %d\n", page);
-
-	ata_tf_init(dev, &tf);
-	tf.command = ATA_CMD_READ_LOG_EXT;
-	tf.lbal = page;
-	tf.nsect = sectors;
-	tf.hob_nsect = sectors >> 8;
-	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_LBA48 | ATA_TFLAG_DEVICE;
-	tf.protocol = ATA_PROT_PIO;
-
-	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_FROM_DEVICE,
-				     buf, sectors * ATA_SECT_SIZE, 0);
-
-	DPRINTK("EXIT, err_mask=%x\n", err_mask);
-	return err_mask;
-}
-
-/**
- *	ata_eh_read_log_10h - Read log page 10h for NCQ error details
- *	@dev: Device to read log page 10h from
- *	@tag: Resulting tag of the failed command
- *	@tf: Resulting taskfile registers of the failed command
- *
- *	Read log page 10h to obtain NCQ error details and clear error
- *	condition.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).
- *
- *	RETURNS:
- *	0 on success, -errno otherwise.
- */
-static int ata_eh_read_log_10h(struct ata_device *dev,
-			       int *tag, struct ata_taskfile *tf)
-{
-	u8 *buf = dev->link->ap->sector_buf;
-	unsigned int err_mask;
-	u8 csum;
-	int i;
-
-	err_mask = ata_read_log_page(dev, ATA_LOG_SATA_NCQ, buf, 1);
-	if (err_mask)
-		return -EIO;
-
-	csum = 0;
-	for (i = 0; i < ATA_SECT_SIZE; i++)
-		csum += buf[i];
-	if (csum)
-		ata_dev_printk(dev, KERN_WARNING,
-			       "invalid checksum 0x%x on log page 10h\n", csum);
-
-	if (buf[0] & 0x80)
-		return -ENOENT;
-
-	*tag = buf[0] & 0x1f;
-
-	tf->command = buf[2];
-	tf->feature = buf[3];
-	tf->lbal = buf[4];
-	tf->lbam = buf[5];
-	tf->lbah = buf[6];
-	tf->device = buf[7];
-	tf->hob_lbal = buf[8];
-	tf->hob_lbam = buf[9];
-	tf->hob_lbah = buf[10];
-	tf->nsect = buf[12];
-	tf->hob_nsect = buf[13];
-
-	return 0;
-}
-
-/**
  *	atapi_eh_tur - perform ATAPI TEST_UNIT_READY
  *	@dev: target ATAPI device
  *	@r_sense_key: out parameter for sense_key
@@ -1583,117 +1418,10 @@ static unsigned int atapi_eh_request_sen
 				 sense_buf, SCSI_SENSE_BUFFERSIZE, 0);
 }
 
-/**
- *	ata_eh_analyze_serror - analyze SError for a failed port
- *	@link: ATA link to analyze SError for
- *
- *	Analyze SError if available and further determine cause of
- *	failure.
- *
- *	LOCKING:
- *	None.
- */
-static void ata_eh_analyze_serror(struct ata_link *link)
-{
-	struct ata_eh_context *ehc = &link->eh_context;
-	u32 serror = ehc->i.serror;
-	unsigned int err_mask = 0, action = 0;
-	u32 hotplug_mask;
-
-	if (serror & (SERR_PERSISTENT | SERR_DATA)) {
-		err_mask |= AC_ERR_ATA_BUS;
-		action |= ATA_EH_RESET;
-	}
-	if (serror & SERR_PROTOCOL) {
-		err_mask |= AC_ERR_HSM;
-		action |= ATA_EH_RESET;
-	}
-	if (serror & SERR_INTERNAL) {
-		err_mask |= AC_ERR_SYSTEM;
-		action |= ATA_EH_RESET;
-	}
-
-	/* Determine whether a hotplug event has occurred.  Both
-	 * SError.N/X are considered hotplug events for enabled or
-	 * host links.  For disabled PMP links, only N bit is
-	 * considered as X bit is left at 1 for link plugging.
-	 */
-	if (link->lpm_policy != ATA_LPM_MAX_POWER)
-		hotplug_mask = 0;	/* hotplug doesn't work w/ LPM */
-	else if (!(link->flags & ATA_LFLAG_DISABLED) || ata_is_host_link(link))
-		hotplug_mask = SERR_PHYRDY_CHG | SERR_DEV_XCHG;
-	else
-		hotplug_mask = SERR_PHYRDY_CHG;
-
-	if (serror & hotplug_mask)
-		ata_ehi_hotplugged(&ehc->i);
-
-	ehc->i.err_mask |= err_mask;
-	ehc->i.action |= action;
-}
-
-/**
- *	ata_eh_analyze_ncq_error - analyze NCQ error
- *	@link: ATA link to analyze NCQ error for
- *
- *	Read log page 10h, determine the offending qc and acquire
- *	error status TF.  For NCQ device errors, all LLDDs have to do
- *	is setting AC_ERR_DEV in ehi->err_mask.  This function takes
- *	care of the rest.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).
- */
-void ata_eh_analyze_ncq_error(struct ata_link *link)
-{
-	struct ata_port *ap = link->ap;
-	struct ata_eh_context *ehc = &link->eh_context;
-	struct ata_device *dev = link->device;
-	struct ata_queued_cmd *qc;
-	struct ata_taskfile tf;
-	int tag, rc;
-
-	/* if frozen, we can't do much */
-	if (ap->pflags & ATA_PFLAG_FROZEN)
-		return;
-
-	/* is it NCQ device error? */
-	if (!link->sactive || !(ehc->i.err_mask & AC_ERR_DEV))
-		return;
-
-	/* has LLDD analyzed already? */
-	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
-		qc = __ata_qc_from_tag(ap, tag);
-
-		if (!(qc->flags & ATA_QCFLAG_FAILED))
-			continue;
-
-		if (qc->err_mask)
-			return;
-	}
-
-	/* okay, this error is ours */
-	memset(&tf, 0, sizeof(tf));
-	rc = ata_eh_read_log_10h(dev, &tag, &tf);
-	if (rc) {
-		ata_link_printk(link, KERN_ERR, "failed to read log page 10h "
-				"(errno=%d)\n", rc);
-		return;
-	}
-
-	if (!(link->sactive & (1 << tag))) {
-		ata_link_printk(link, KERN_ERR, "log page 10h reported "
-				"inactive tag %d\n", tag);
-		return;
-	}
-
-	/* we've got the perpetrator, condemn it */
-	qc = __ata_qc_from_tag(ap, tag);
-	memcpy(&qc->result_tf, &tf, sizeof(tf));
-	qc->result_tf.flags = ATA_TFLAG_ISADDR | ATA_TFLAG_LBA | ATA_TFLAG_LBA48;
-	qc->err_mask |= AC_ERR_DEV | AC_ERR_NCQ;
-	ehc->i.err_mask &= ~AC_ERR_DEV;
-}
+#ifndef CONFIG_SATA_HOST
+void ata_eh_analyze_ncq_error(struct ata_link *link) { }
+EXPORT_SYMBOL_GPL(ata_eh_analyze_ncq_error);
+#endif
 
 /**
  *	ata_eh_analyze_tf - analyze taskfile of a failed qc
@@ -2349,7 +2077,7 @@ static void ata_eh_link_report(struct at
 			ata_link_printk(link, KERN_ERR, "%s\n", desc);
 	}
 
-#ifdef CONFIG_ATA_VERBOSE_ERROR
+#if defined(CONFIG_SATA_HOST) && defined(CONFIG_ATA_VERBOSE_ERROR)
 	if (ehc->i.serror)
 		ata_link_printk(link, KERN_ERR,
 		  "SError: { %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s}\n",
@@ -3252,135 +2980,6 @@ static int ata_eh_maybe_retry_flush(stru
 	return rc;
 }
 
-/**
- *	ata_eh_set_lpm - configure SATA interface power management
- *	@link: link to configure power management
- *	@policy: the link power management policy
- *	@r_failed_dev: out parameter for failed device
- *
- *	Enable SATA Interface power management.  This will enable
- *	Device Interface Power Management (DIPM) for min_power
- * 	policy, and then call driver specific callbacks for
- *	enabling Host Initiated Power management.
- *
- *	LOCKING:
- *	EH context.
- *
- *	RETURNS:
- *	0 on success, -errno on failure.
- */
-static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
-			  struct ata_device **r_failed_dev)
-{
-	struct ata_port *ap = ata_is_host_link(link) ? link->ap : NULL;
-	struct ata_eh_context *ehc = &link->eh_context;
-	struct ata_device *dev, *link_dev = NULL, *lpm_dev = NULL;
-	enum ata_lpm_policy old_policy = link->lpm_policy;
-	unsigned int hints = ATA_LPM_EMPTY | ATA_LPM_HIPM;
-	unsigned int err_mask;
-	int rc;
-
-	/* if the link or host doesn't do LPM, noop */
-	if ((link->flags & ATA_LFLAG_NO_LPM) || (ap && !ap->ops->set_lpm))
-		return 0;
-
-	/*
-	 * DIPM is enabled only for MIN_POWER as some devices
-	 * misbehave when the host NACKs transition to SLUMBER.  Order
-	 * device and link configurations such that the host always
-	 * allows DIPM requests.
-	 */
-	ata_for_each_dev(dev, link, ENABLED) {
-		bool hipm = ata_id_has_hipm(dev->id);
-		bool dipm = ata_id_has_dipm(dev->id);
-
-		/* find the first enabled and LPM enabled devices */
-		if (!link_dev)
-			link_dev = dev;
-
-		if (!lpm_dev && (hipm || dipm))
-			lpm_dev = dev;
-
-		hints &= ~ATA_LPM_EMPTY;
-		if (!hipm)
-			hints &= ~ATA_LPM_HIPM;
-
-		/* disable DIPM before changing link config */
-		if (policy != ATA_LPM_MIN_POWER && dipm) {
-			err_mask = ata_dev_set_feature(dev,
-					SETFEATURES_SATA_DISABLE, SATA_DIPM);
-			if (err_mask && err_mask != AC_ERR_DEV) {
-				ata_dev_printk(dev, KERN_WARNING,
-					"failed to disable DIPM, Emask 0x%x\n",
-					err_mask);
-				rc = -EIO;
-				goto fail;
-			}
-		}
-	}
-
-	if (ap) {
-		rc = ap->ops->set_lpm(link, policy, hints);
-		if (!rc && ap->slave_link)
-			rc = ap->ops->set_lpm(ap->slave_link, policy, hints);
-	} else
-		rc = sata_pmp_set_lpm(link, policy, hints);
-
-	/*
-	 * Attribute link config failure to the first (LPM) enabled
-	 * device on the link.
-	 */
-	if (rc) {
-		if (rc == -EOPNOTSUPP) {
-			link->flags |= ATA_LFLAG_NO_LPM;
-			return 0;
-		}
-		dev = lpm_dev ? lpm_dev : link_dev;
-		goto fail;
-	}
-
-	/*
-	 * Low level driver acked the transition.  Issue DIPM command
-	 * with the new policy set.
-	 */
-	link->lpm_policy = policy;
-	if (ap && ap->slave_link)
-		ap->slave_link->lpm_policy = policy;
-
-	/* host config updated, enable DIPM if transitioning to MIN_POWER */
-	ata_for_each_dev(dev, link, ENABLED) {
-		if (policy == ATA_LPM_MIN_POWER && ata_id_has_dipm(dev->id)) {
-			err_mask = ata_dev_set_feature(dev,
-					SETFEATURES_SATA_ENABLE, SATA_DIPM);
-			if (err_mask && err_mask != AC_ERR_DEV) {
-				ata_dev_printk(dev, KERN_WARNING,
-					"failed to enable DIPM, Emask 0x%x\n",
-					err_mask);
-				rc = -EIO;
-				goto fail;
-			}
-		}
-	}
-
-	return 0;
-
-fail:
-	/* restore the old policy */
-	link->lpm_policy = old_policy;
-	if (ap && ap->slave_link)
-		ap->slave_link->lpm_policy = old_policy;
-
-	/* if no device or only one more chance is left, disable LPM */
-	if (!dev || ehc->tries[dev->devno] <= 2) {
-		ata_link_printk(link, KERN_WARNING,
-				"disabling LPM on the link\n");
-		link->flags |= ATA_LFLAG_NO_LPM;
-	}
-	if (r_failed_dev)
-		*r_failed_dev = dev;
-	return rc;
-}
-
 static int ata_link_nr_enabled(struct ata_link *link)
 {
 	struct ata_device *dev;
Index: b/drivers/ata/libata-sata.c
===================================================================
--- /dev/null
+++ b/drivers/ata/libata-sata.c
@@ -0,0 +1,1242 @@
+/*
+ *  libata-sff.c - libata SATA host support
+ *
+ *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *    		    Please ALWAYS copy linux-ide@vger.kernel.org
+ *		    on emails.
+ *
+ *  Copyright 2003-2006 Red Hat, Inc.  All rights reserved.
+ *  Copyright 2003-2006 Jeff Garzik
+ *
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *
+ *  libata documentation is available via 'make {ps|pdf}docs',
+ *  as Documentation/DocBook/libata.*
+ *
+ *  Hardware documentation available from http://www.t13.org/ and
+ *  http://www.sata-io.org/
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/libata.h>
+#include "libata.h"
+
+/* debounce timing parameters in msecs { interval, duration, timeout } */
+const unsigned long sata_deb_timing_normal[]		= {   5,  100, 2000 };
+EXPORT_SYMBOL_GPL(sata_deb_timing_normal);
+const unsigned long sata_deb_timing_hotplug[]		= {  25,  500, 2000 };
+EXPORT_SYMBOL_GPL(sata_deb_timing_hotplug);
+const unsigned long sata_deb_timing_long[]		= { 100, 2000, 5000 };
+EXPORT_SYMBOL_GPL(sata_deb_timing_long);
+
+/**
+ *	ata_force_link_limits - force link limits according to libata.force
+ *	@link: ATA link of interest
+ *
+ *	Force link flags and SATA spd limit according to libata.force
+ *	and whine about it.  When only the port part is specified
+ *	(e.g. 1:), the limit applies to all links connected to both
+ *	the host link and all fan-out ports connected via PMP.  If the
+ *	device part is specified as 0 (e.g. 1.00:), it specifies the
+ *	first fan-out link not the host link.  Device number 15 always
+ *	points to the host link whether PMP is attached or not.  If the
+ *	controller has slave link, device number 16 points to it.
+ *
+ *	LOCKING:
+ *	EH context.
+ */
+static void ata_force_link_limits(struct ata_link *link)
+{
+	bool did_spd = false;
+	int linkno = link->pmp;
+	int i;
+
+	if (ata_is_host_link(link))
+		linkno += 15;
+
+	for (i = ata_force_tbl_size - 1; i >= 0; i--) {
+		const struct ata_force_ent *fe = &ata_force_tbl[i];
+
+		if (fe->port != -1 && fe->port != link->ap->print_id)
+			continue;
+
+		if (fe->device != -1 && fe->device != linkno)
+			continue;
+
+		/* only honor the first spd limit */
+		if (!did_spd && fe->param.spd_limit) {
+			link->hw_sata_spd_limit = (1 << fe->param.spd_limit) - 1;
+			ata_link_printk(link, KERN_NOTICE,
+					"FORCE: PHY spd limit set to %s\n",
+					fe->param.name);
+			did_spd = true;
+		}
+
+		/* let lflags stack */
+		if (fe->param.lflags) {
+			link->flags |= fe->param.lflags;
+			ata_link_printk(link, KERN_NOTICE,
+					"FORCE: link flag 0x%x forced -> 0x%x\n",
+					fe->param.lflags, link->flags);
+		}
+	}
+}
+
+/**
+ *	ata_tf_from_fis - Convert SATA FIS to ATA taskfile
+ *	@fis: Buffer from which data will be input
+ *	@tf: Taskfile to output
+ *
+ *	Converts a serial ATA FIS structure to a standard ATA taskfile.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+
+void ata_tf_from_fis(const u8 *fis, struct ata_taskfile *tf)
+{
+	tf->command	= fis[2];	/* status */
+	tf->feature	= fis[3];	/* error */
+
+	tf->lbal	= fis[4];
+	tf->lbam	= fis[5];
+	tf->lbah	= fis[6];
+	tf->device	= fis[7];
+
+	tf->hob_lbal	= fis[8];
+	tf->hob_lbam	= fis[9];
+	tf->hob_lbah	= fis[10];
+
+	tf->nsect	= fis[12];
+	tf->hob_nsect	= fis[13];
+}
+EXPORT_SYMBOL_GPL(ata_tf_from_fis);
+
+int ata_do_link_spd_horkage(struct ata_device *dev)
+{
+	struct ata_link *plink = ata_dev_phys_link(dev);
+	u32 target, target_limit;
+
+	if (!sata_scr_valid(plink))
+		return 0;
+
+	if (dev->horkage & ATA_HORKAGE_1_5_GBPS)
+		target = 1;
+	else
+		return 0;
+
+	target_limit = (1 << target) - 1;
+
+	/* if already on stricter limit, no need to push further */
+	if (plink->sata_spd_limit <= target_limit)
+		return 0;
+
+	plink->sata_spd_limit = target_limit;
+
+	/* Request another EH round by returning -EAGAIN if link is
+	 * going faster than the target speed.  Forward progress is
+	 * guaranteed by setting sata_spd_limit to target_limit above.
+	 */
+	if (plink->sata_spd > target) {
+		ata_dev_printk(dev, KERN_INFO,
+			       "applying link speed limit horkage to %s\n",
+			       sata_spd_string(target));
+		return -EAGAIN;
+	}
+	return 0;
+}
+
+int ata_dev_config_ncq(struct ata_device *dev, char *desc, size_t desc_sz)
+{
+	struct ata_port *ap = dev->link->ap;
+	int hdepth = 0, ddepth = ata_id_queue_depth(dev->id);
+	unsigned int err_mask;
+	char *aa_desc = "";
+
+	if (!ata_id_has_ncq(dev->id)) {
+		desc[0] = '\0';
+		return 0;
+	}
+	if (dev->horkage & ATA_HORKAGE_NONCQ) {
+		snprintf(desc, desc_sz, "NCQ (not used)");
+		return 0;
+	}
+	if (ap->flags & ATA_FLAG_NCQ) {
+		hdepth = min(ap->scsi_host->can_queue, ATA_MAX_QUEUE - 1);
+		dev->flags |= ATA_DFLAG_NCQ;
+	}
+
+	if (!(dev->horkage & ATA_HORKAGE_BROKEN_FPDMA_AA) &&
+		(ap->flags & ATA_FLAG_FPDMA_AA) &&
+		ata_id_has_fpdma_aa(dev->id)) {
+		err_mask = ata_dev_set_feature(dev, SETFEATURES_SATA_ENABLE,
+			SATA_FPDMA_AA);
+		if (err_mask) {
+			ata_dev_printk(dev, KERN_ERR, "failed to enable AA"
+				"(error_mask=0x%x)\n", err_mask);
+			if (err_mask != AC_ERR_DEV) {
+				dev->horkage |= ATA_HORKAGE_BROKEN_FPDMA_AA;
+				return -EIO;
+			}
+		} else
+			aa_desc = ", AA";
+	}
+
+	if (hdepth >= ddepth)
+		snprintf(desc, desc_sz, "NCQ (depth %d)%s", ddepth, aa_desc);
+	else
+		snprintf(desc, desc_sz, "NCQ (depth %d/%d)%s", hdepth,
+			ddepth, aa_desc);
+	return 0;
+}
+
+/**
+ *	sata_print_link_status - Print SATA link status
+ *	@link: SATA link to printk link status about
+ *
+ *	This function prints link speed and status of a SATA link.
+ *
+ *	LOCKING:
+ *	None.
+ */
+static void sata_print_link_status(struct ata_link *link)
+{
+	u32 sstatus, scontrol, tmp;
+
+	if (sata_scr_read(link, SCR_STATUS, &sstatus))
+		return;
+	sata_scr_read(link, SCR_CONTROL, &scontrol);
+
+	if (ata_phys_link_online(link)) {
+		tmp = (sstatus >> 4) & 0xf;
+		ata_link_printk(link, KERN_INFO,
+				"SATA link up %s (SStatus %X SControl %X)\n",
+				sata_spd_string(tmp), sstatus, scontrol);
+	} else {
+		ata_link_printk(link, KERN_INFO,
+				"SATA link down (SStatus %X SControl %X)\n",
+				sstatus, scontrol);
+	}
+}
+
+/**
+ *	sata_down_spd_limit - adjust SATA spd limit downward
+ *	@link: Link to adjust SATA spd limit for
+ *	@spd_limit: Additional limit
+ *
+ *	Adjust SATA spd limit of @link downward.  Note that this
+ *	function only adjusts the limit.  The change must be applied
+ *	using sata_set_spd().
+ *
+ *	If @spd_limit is non-zero, the speed is limited to equal to or
+ *	lower than @spd_limit if such speed is supported.  If
+ *	@spd_limit is slower than any supported speed, only the lowest
+ *	supported speed is allowed.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ *
+ *	RETURNS:
+ *	0 on success, negative errno on failure
+ */
+int sata_down_spd_limit(struct ata_link *link, u32 spd_limit)
+{
+	u32 sstatus, spd, mask;
+	int rc, bit;
+
+	if (!sata_scr_valid(link))
+		return -EOPNOTSUPP;
+
+	/* If SCR can be read, use it to determine the current SPD.
+	 * If not, use cached value in link->sata_spd.
+	 */
+	rc = sata_scr_read(link, SCR_STATUS, &sstatus);
+	if (rc == 0 && ata_sstatus_online(sstatus))
+		spd = (sstatus >> 4) & 0xf;
+	else
+		spd = link->sata_spd;
+
+	mask = link->sata_spd_limit;
+	if (mask <= 1)
+		return -EINVAL;
+
+	/* unconditionally mask off the highest bit */
+	bit = fls(mask) - 1;
+	mask &= ~(1 << bit);
+
+	/* Mask off all speeds higher than or equal to the current
+	 * one.  Force 1.5Gbps if current SPD is not available.
+	 */
+	if (spd > 1)
+		mask &= (1 << (spd - 1)) - 1;
+	else
+		mask &= 1;
+
+	/* were we already at the bottom? */
+	if (!mask)
+		return -EINVAL;
+
+	if (spd_limit) {
+		if (mask & ((1 << spd_limit) - 1))
+			mask &= (1 << spd_limit) - 1;
+		else {
+			bit = ffs(mask) - 1;
+			mask = 1 << bit;
+		}
+	}
+
+	link->sata_spd_limit = mask;
+
+	ata_link_printk(link, KERN_WARNING, "limiting SATA link speed to %s\n",
+			sata_spd_string(fls(mask)));
+
+	return 0;
+}
+
+static int __sata_set_spd_needed(struct ata_link *link, u32 *scontrol)
+{
+	struct ata_link *host_link = &link->ap->link;
+	u32 limit, target, spd;
+
+	limit = link->sata_spd_limit;
+
+	/* Don't configure downstream link faster than upstream link.
+	 * It doesn't speed up anything and some PMPs choke on such
+	 * configuration.
+	 */
+	if (!ata_is_host_link(link) && host_link->sata_spd)
+		limit &= (1 << host_link->sata_spd) - 1;
+
+	if (limit == UINT_MAX)
+		target = 0;
+	else
+		target = fls(limit);
+
+	spd = (*scontrol >> 4) & 0xf;
+	*scontrol = (*scontrol & ~0xf0) | ((target & 0xf) << 4);
+
+	return spd != target;
+}
+
+/**
+ *	sata_set_spd_needed - is SATA spd configuration needed
+ *	@link: Link in question
+ *
+ *	Test whether the spd limit in SControl matches
+ *	@link->sata_spd_limit.  This function is used to determine
+ *	whether hardreset is necessary to apply SATA spd
+ *	configuration.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ *
+ *	RETURNS:
+ *	1 if SATA spd configuration is needed, 0 otherwise.
+ */
+static int sata_set_spd_needed(struct ata_link *link)
+{
+	u32 scontrol;
+
+	if (sata_scr_read(link, SCR_CONTROL, &scontrol))
+		return 1;
+
+	return __sata_set_spd_needed(link, &scontrol);
+}
+
+/**
+ *	sata_set_spd - set SATA spd according to spd limit
+ *	@link: Link to set SATA spd for
+ *
+ *	Set SATA spd of @link according to sata_spd_limit.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ *
+ *	RETURNS:
+ *	0 if spd doesn't need to be changed, 1 if spd has been
+ *	changed.  Negative errno if SCR registers are inaccessible.
+ */
+int sata_set_spd(struct ata_link *link)
+{
+	u32 scontrol;
+	int rc;
+
+	if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
+		return rc;
+
+	if (!__sata_set_spd_needed(link, &scontrol))
+		return 0;
+
+	if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
+		return rc;
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(sata_set_spd);
+
+/**
+ *	sata_link_debounce - debounce SATA phy status
+ *	@link: ATA link to debounce SATA phy status for
+ *	@params: timing parameters { interval, duratinon, timeout } in msec
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	Make sure SStatus of @link reaches stable state, determined by
+ *	holding the same value where DET is not 1 for @duration polled
+ *	every @interval, before @timeout.  Timeout constraints the
+ *	beginning of the stable state.  Because DET gets stuck at 1 on
+ *	some controllers after hot unplugging, this functions waits
+ *	until timeout then returns 0 if DET is stable at 1.
+ *
+ *	@timeout is further limited by @deadline.  The sooner of the
+ *	two is used.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ *
+ *	RETURNS:
+ *	0 on success, -errno on failure.
+ */
+int sata_link_debounce(struct ata_link *link, const unsigned long *params,
+		       unsigned long deadline)
+{
+	unsigned long interval = params[0];
+	unsigned long duration = params[1];
+	unsigned long last_jiffies, t;
+	u32 last, cur;
+	int rc;
+
+	t = ata_deadline(jiffies, params[2]);
+	if (time_before(t, deadline))
+		deadline = t;
+
+	if ((rc = sata_scr_read(link, SCR_STATUS, &cur)))
+		return rc;
+	cur &= 0xf;
+
+	last = cur;
+	last_jiffies = jiffies;
+
+	while (1) {
+		ata_msleep(link->ap, interval);
+		if ((rc = sata_scr_read(link, SCR_STATUS, &cur)))
+			return rc;
+		cur &= 0xf;
+
+		/* DET stable? */
+		if (cur == last) {
+			if (cur == 1 && time_before(jiffies, deadline))
+				continue;
+			if (time_after(jiffies,
+				       ata_deadline(last_jiffies, duration)))
+				return 0;
+			continue;
+		}
+
+		/* unstable, start over */
+		last = cur;
+		last_jiffies = jiffies;
+
+		/* Check deadline.  If debouncing failed, return
+		 * -EPIPE to tell upper layer to lower link speed.
+		 */
+		if (time_after(jiffies, deadline))
+			return -EPIPE;
+	}
+}
+EXPORT_SYMBOL_GPL(sata_link_debounce);
+
+/**
+ *	sata_link_resume - resume SATA link
+ *	@link: ATA link to resume SATA
+ *	@params: timing parameters { interval, duratinon, timeout } in msec
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	Resume SATA phy @link and debounce it.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ *
+ *	RETURNS:
+ *	0 on success, -errno on failure.
+ */
+int sata_link_resume(struct ata_link *link, const unsigned long *params,
+		     unsigned long deadline)
+{
+	int tries = ATA_LINK_RESUME_TRIES;
+	u32 scontrol, serror;
+	int rc;
+
+	if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
+		return rc;
+
+	/*
+	 * Writes to SControl sometimes get ignored under certain
+	 * controllers (ata_piix SIDPR).  Make sure DET actually is
+	 * cleared.
+	 */
+	do {
+		scontrol = (scontrol & 0x0f0) | 0x300;
+		if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
+			return rc;
+		/*
+		 * Some PHYs react badly if SStatus is pounded
+		 * immediately after resuming.  Delay 200ms before
+		 * debouncing.
+		 */
+		ata_msleep(link->ap, 200);
+
+		/* is SControl restored correctly? */
+		if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
+			return rc;
+	} while ((scontrol & 0xf0f) != 0x300 && --tries);
+
+	if ((scontrol & 0xf0f) != 0x300) {
+		ata_link_printk(link, KERN_ERR,
+				"failed to resume link (SControl %X)\n",
+				scontrol);
+		return 0;
+	}
+
+	if (tries < ATA_LINK_RESUME_TRIES)
+		ata_link_printk(link, KERN_WARNING,
+				"link resume succeeded after %d retries\n",
+				ATA_LINK_RESUME_TRIES - tries);
+
+	if ((rc = sata_link_debounce(link, params, deadline)))
+		return rc;
+
+	/* clear SError, some PHYs require this even for SRST to work */
+	if (!(rc = sata_scr_read(link, SCR_ERROR, &serror)))
+		rc = sata_scr_write(link, SCR_ERROR, serror);
+
+	return rc != -EINVAL ? rc : 0;
+}
+EXPORT_SYMBOL_GPL(sata_link_resume);
+
+/**
+ *	sata_link_scr_lpm - manipulate SControl IPM and SPM fields
+ *	@link: ATA link to manipulate SControl for
+ *	@policy: LPM policy to configure
+ *	@spm_wakeup: initiate LPM transition to active state
+ *
+ *	Manipulate the IPM field of the SControl register of @link
+ *	according to @policy.  If @policy is ATA_LPM_MAX_POWER and
+ *	@spm_wakeup is %true, the SPM field is manipulated to wake up
+ *	the link.  This function also clears PHYRDY_CHG before
+ *	returning.
+ *
+ *	LOCKING:
+ *	EH context.
+ *
+ *	RETURNS:
+ *	0 on succes, -errno otherwise.
+ */
+int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
+		      bool spm_wakeup)
+{
+	struct ata_eh_context *ehc = &link->eh_context;
+	bool woken_up = false;
+	u32 scontrol;
+	int rc;
+
+	rc = sata_scr_read(link, SCR_CONTROL, &scontrol);
+	if (rc)
+		return rc;
+
+	switch (policy) {
+	case ATA_LPM_MAX_POWER:
+		/* disable all LPM transitions */
+		scontrol |= (0x3 << 8);
+		/* initiate transition to active state */
+		if (spm_wakeup) {
+			scontrol |= (0x4 << 12);
+			woken_up = true;
+		}
+		break;
+	case ATA_LPM_MED_POWER:
+		/* allow LPM to PARTIAL */
+		scontrol &= ~(0x1 << 8);
+		scontrol |= (0x2 << 8);
+		break;
+	case ATA_LPM_MIN_POWER:
+		/* no restrictions on LPM transitions */
+		scontrol &= ~(0x3 << 8);
+		break;
+	default:
+		WARN_ON(1);
+	}
+
+	rc = sata_scr_write(link, SCR_CONTROL, scontrol);
+	if (rc)
+		return rc;
+
+	/* give the link time to transit out of LPM state */
+	if (woken_up)
+		msleep(10);
+
+	/* clear PHYRDY_CHG from SError */
+	ehc->i.serror &= ~SERR_PHYRDY_CHG;
+	return sata_scr_write(link, SCR_ERROR, SERR_PHYRDY_CHG);
+}
+EXPORT_SYMBOL_GPL(sata_link_scr_lpm);
+
+/**
+ *	sata_link_hardreset - reset link via SATA phy reset
+ *	@link: link to reset
+ *	@timing: timing parameters { interval, duratinon, timeout } in msec
+ *	@deadline: deadline jiffies for the operation
+ *	@online: optional out parameter indicating link onlineness
+ *	@check_ready: optional callback to check link readiness
+ *
+ *	SATA phy-reset @link using DET bits of SControl register.
+ *	After hardreset, link readiness is waited upon using
+ *	ata_wait_ready() if @check_ready is specified.  LLDs are
+ *	allowed to not specify @check_ready and wait itself after this
+ *	function returns.  Device classification is LLD's
+ *	responsibility.
+ *
+ *	*@online is set to one iff reset succeeded and @link is online
+ *	after reset.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ *
+ *	RETURNS:
+ *	0 on success, -errno otherwise.
+ */
+int sata_link_hardreset(struct ata_link *link, const unsigned long *timing,
+			unsigned long deadline,
+			bool *online, int (*check_ready)(struct ata_link *))
+{
+	u32 scontrol;
+	int rc;
+
+	DPRINTK("ENTER\n");
+
+	if (online)
+		*online = false;
+
+	if (sata_set_spd_needed(link)) {
+		/* SATA spec says nothing about how to reconfigure
+		 * spd.  To be on the safe side, turn off phy during
+		 * reconfiguration.  This works for at least ICH7 AHCI
+		 * and Sil3124.
+		 */
+		if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
+			goto out;
+
+		scontrol = (scontrol & 0x0f0) | 0x304;
+
+		if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
+			goto out;
+
+		sata_set_spd(link);
+	}
+
+	/* issue phy wake/reset */
+	if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
+		goto out;
+
+	scontrol = (scontrol & 0x0f0) | 0x301;
+
+	if ((rc = sata_scr_write_flush(link, SCR_CONTROL, scontrol)))
+		goto out;
+
+	/* Couldn't find anything in SATA I/II specs, but AHCI-1.1
+	 * 10.4.2 says at least 1 ms.
+	 */
+	ata_msleep(link->ap, 1);
+
+	/* bring link back */
+	rc = sata_link_resume(link, timing, deadline);
+	if (rc)
+		goto out;
+	/* if link is offline nothing more to do */
+	if (ata_phys_link_offline(link))
+		goto out;
+
+	/* Link is online.  From this point, -ENODEV too is an error. */
+	if (online)
+		*online = true;
+
+	if (sata_pmp_supported(link->ap) && ata_is_host_link(link)) {
+		/* If PMP is supported, we have to do follow-up SRST.
+		 * Some PMPs don't send D2H Reg FIS after hardreset if
+		 * the first port is empty.  Wait only for
+		 * ATA_TMOUT_PMP_SRST_WAIT.
+		 */
+		if (check_ready) {
+			unsigned long pmp_deadline;
+
+			pmp_deadline = ata_deadline(jiffies,
+						    ATA_TMOUT_PMP_SRST_WAIT);
+			if (time_after(pmp_deadline, deadline))
+				pmp_deadline = deadline;
+			ata_wait_ready(link, pmp_deadline, check_ready);
+		}
+		rc = -EAGAIN;
+		goto out;
+	}
+
+	rc = 0;
+	if (check_ready)
+		rc = ata_wait_ready(link, deadline, check_ready);
+ out:
+	if (rc && rc != -EAGAIN) {
+		/* online is set iff link is online && reset succeeded */
+		if (online)
+			*online = false;
+		ata_link_printk(link, KERN_ERR,
+				"COMRESET failed (errno=%d)\n", rc);
+	}
+	DPRINTK("EXIT, rc=%d\n", rc);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(sata_link_hardreset);
+
+/**
+ *	sata_std_hardreset - COMRESET w/o waiting or classification
+ *	@link: link to reset
+ *	@class: resulting class of attached device
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	Standard SATA COMRESET w/o waiting or classification.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ *
+ *	RETURNS:
+ *	0 if link offline, -EAGAIN if link online, -errno on errors.
+ */
+int sata_std_hardreset(struct ata_link *link, unsigned int *class,
+		       unsigned long deadline)
+{
+	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
+	bool online;
+	int rc;
+
+	/* do hardreset */
+	rc = sata_link_hardreset(link, timing, deadline, &online, NULL);
+	return online ? -EAGAIN : rc;
+}
+EXPORT_SYMBOL_GPL(sata_std_hardreset);
+
+/**
+ *	ata_std_postreset - standard postreset callback
+ *	@link: the target ata_link
+ *	@classes: classes of attached devices
+ *
+ *	This function is invoked after a successful reset.  Note that
+ *	the device might have been reset more than once using
+ *	different reset methods before postreset is invoked.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ */
+void ata_std_postreset(struct ata_link *link, unsigned int *classes)
+{
+	u32 serror;
+
+	DPRINTK("ENTER\n");
+
+	/* reset complete, clear SError */
+	if (!sata_scr_read(link, SCR_ERROR, &serror))
+		sata_scr_write(link, SCR_ERROR, serror);
+
+	/* print link status */
+	sata_print_link_status(link);
+
+	DPRINTK("EXIT\n");
+}
+EXPORT_SYMBOL_GPL(ata_std_postreset);
+
+/**
+ *	sata_link_init_spd - Initialize link->sata_spd_limit
+ *	@link: Link to configure sata_spd_limit for
+ *
+ *	Initialize @link->[hw_]sata_spd_limit to the currently
+ *	configured value.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, -errno on failure.
+ */
+int sata_link_init_spd(struct ata_link *link)
+{
+	u8 spd;
+	int rc;
+
+	rc = sata_scr_read(link, SCR_CONTROL, &link->saved_scontrol);
+	if (rc)
+		return rc;
+
+	spd = (link->saved_scontrol >> 4) & 0xf;
+	if (spd)
+		link->hw_sata_spd_limit &= (1 << spd) - 1;
+
+	ata_force_link_limits(link);
+
+	link->sata_spd_limit = link->hw_sata_spd_limit;
+
+	return 0;
+}
+
+/**
+ *	sata_async_notification - SATA async notification handler
+ *	@ap: ATA port where async notification is received
+ *
+ *	Handler to be called when async notification via SDB FIS is
+ *	received.  This function schedules EH if necessary.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ *	RETURNS:
+ *	1 if EH is scheduled, 0 otherwise.
+ */
+int sata_async_notification(struct ata_port *ap)
+{
+	u32 sntf;
+	int rc;
+
+	if (!(ap->flags & ATA_FLAG_AN))
+		return 0;
+
+	rc = sata_scr_read(&ap->link, SCR_NOTIFICATION, &sntf);
+	if (rc == 0)
+		sata_scr_write(&ap->link, SCR_NOTIFICATION, sntf);
+
+	if (!sata_pmp_attached(ap) || rc) {
+		/* PMP is not attached or SNTF is not available */
+		if (!sata_pmp_attached(ap)) {
+			/* PMP is not attached.  Check whether ATAPI
+			 * AN is configured.  If so, notify media
+			 * change.
+			 */
+			struct ata_device *dev = ap->link.device;
+
+			if ((dev->class == ATA_DEV_ATAPI) &&
+			    (dev->flags & ATA_DFLAG_AN))
+				ata_scsi_media_change_notify(dev);
+			return 0;
+		} else {
+			/* PMP is attached but SNTF is not available.
+			 * ATAPI async media change notification is
+			 * not used.  The PMP must be reporting PHY
+			 * status change, schedule EH.
+			 */
+			ata_port_schedule_eh(ap);
+			return 1;
+		}
+	} else {
+		/* PMP is attached and SNTF is available */
+		struct ata_link *link;
+
+		/* check and notify ATAPI AN */
+		ata_for_each_link(link, ap, EDGE) {
+			if (!(sntf & (1 << link->pmp)))
+				continue;
+
+			if ((link->device->class == ATA_DEV_ATAPI) &&
+			    (link->device->flags & ATA_DFLAG_AN))
+				ata_scsi_media_change_notify(link->device);
+		}
+
+		/* If PMP is reporting that PHY status of some
+		 * downstream ports has changed, schedule EH.
+		 */
+		if (sntf & (1 << SATA_PMP_CTRL_PORT)) {
+			ata_port_schedule_eh(ap);
+			return 1;
+		}
+
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(sata_async_notification);
+
+/**
+ *	ata_read_log_page - read a specific log page
+ *	@dev: target device
+ *	@page: page to read
+ *	@buf: buffer to store read page
+ *	@sectors: number of sectors to read
+ *
+ *	Read log page using READ_LOG_EXT command.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, AC_ERR_* mask otherwise.
+ */
+static unsigned int ata_read_log_page(struct ata_device *dev,
+				      u8 page, void *buf, unsigned int sectors)
+{
+	struct ata_taskfile tf;
+	unsigned int err_mask;
+
+	DPRINTK("read log page - page %d\n", page);
+
+	ata_tf_init(dev, &tf);
+	tf.command = ATA_CMD_READ_LOG_EXT;
+	tf.lbal = page;
+	tf.nsect = sectors;
+	tf.hob_nsect = sectors >> 8;
+	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_LBA48 | ATA_TFLAG_DEVICE;
+	tf.protocol = ATA_PROT_PIO;
+
+	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_FROM_DEVICE,
+				     buf, sectors * ATA_SECT_SIZE, 0);
+
+	DPRINTK("EXIT, err_mask=%x\n", err_mask);
+	return err_mask;
+}
+
+/**
+ *	ata_eh_read_log_10h - Read log page 10h for NCQ error details
+ *	@dev: Device to read log page 10h from
+ *	@tag: Resulting tag of the failed command
+ *	@tf: Resulting taskfile registers of the failed command
+ *
+ *	Read log page 10h to obtain NCQ error details and clear error
+ *	condition.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, -errno otherwise.
+ */
+static int ata_eh_read_log_10h(struct ata_device *dev,
+			       int *tag, struct ata_taskfile *tf)
+{
+	u8 *buf = dev->link->ap->sector_buf;
+	unsigned int err_mask;
+	u8 csum;
+	int i;
+
+	err_mask = ata_read_log_page(dev, ATA_LOG_SATA_NCQ, buf, 1);
+	if (err_mask)
+		return -EIO;
+
+	csum = 0;
+	for (i = 0; i < ATA_SECT_SIZE; i++)
+		csum += buf[i];
+	if (csum)
+		ata_dev_printk(dev, KERN_WARNING,
+			       "invalid checksum 0x%x on log page 10h\n", csum);
+
+	if (buf[0] & 0x80)
+		return -ENOENT;
+
+	*tag = buf[0] & 0x1f;
+
+	tf->command = buf[2];
+	tf->feature = buf[3];
+	tf->lbal = buf[4];
+	tf->lbam = buf[5];
+	tf->lbah = buf[6];
+	tf->device = buf[7];
+	tf->hob_lbal = buf[8];
+	tf->hob_lbam = buf[9];
+	tf->hob_lbah = buf[10];
+	tf->nsect = buf[12];
+	tf->hob_nsect = buf[13];
+
+	return 0;
+}
+
+/**
+ *	ata_eh_analyze_serror - analyze SError for a failed port
+ *	@link: ATA link to analyze SError for
+ *
+ *	Analyze SError if available and further determine cause of
+ *	failure.
+ *
+ *	LOCKING:
+ *	None.
+ */
+void ata_eh_analyze_serror(struct ata_link *link)
+{
+	struct ata_eh_context *ehc = &link->eh_context;
+	u32 serror = ehc->i.serror;
+	unsigned int err_mask = 0, action = 0;
+	u32 hotplug_mask;
+
+	if (serror & (SERR_PERSISTENT | SERR_DATA)) {
+		err_mask |= AC_ERR_ATA_BUS;
+		action |= ATA_EH_RESET;
+	}
+	if (serror & SERR_PROTOCOL) {
+		err_mask |= AC_ERR_HSM;
+		action |= ATA_EH_RESET;
+	}
+	if (serror & SERR_INTERNAL) {
+		err_mask |= AC_ERR_SYSTEM;
+		action |= ATA_EH_RESET;
+	}
+
+	/* Determine whether a hotplug event has occurred.  Both
+	 * SError.N/X are considered hotplug events for enabled or
+	 * host links.  For disabled PMP links, only N bit is
+	 * considered as X bit is left at 1 for link plugging.
+	 */
+	if (link->lpm_policy != ATA_LPM_MAX_POWER)
+		hotplug_mask = 0;	/* hotplug doesn't work w/ LPM */
+	else if (!(link->flags & ATA_LFLAG_DISABLED) || ata_is_host_link(link))
+		hotplug_mask = SERR_PHYRDY_CHG | SERR_DEV_XCHG;
+	else
+		hotplug_mask = SERR_PHYRDY_CHG;
+
+	if (serror & hotplug_mask)
+		ata_ehi_hotplugged(&ehc->i);
+
+	ehc->i.err_mask |= err_mask;
+	ehc->i.action |= action;
+}
+
+/**
+ *	ata_eh_analyze_ncq_error - analyze NCQ error
+ *	@link: ATA link to analyze NCQ error for
+ *
+ *	Read log page 10h, determine the offending qc and acquire
+ *	error status TF.  For NCQ device errors, all LLDDs have to do
+ *	is setting AC_ERR_DEV in ehi->err_mask.  This function takes
+ *	care of the rest.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ */
+void ata_eh_analyze_ncq_error(struct ata_link *link)
+{
+	struct ata_port *ap = link->ap;
+	struct ata_eh_context *ehc = &link->eh_context;
+	struct ata_device *dev = link->device;
+	struct ata_queued_cmd *qc;
+	struct ata_taskfile tf;
+	int tag, rc;
+
+	/* if frozen, we can't do much */
+	if (ap->pflags & ATA_PFLAG_FROZEN)
+		return;
+
+	/* is it NCQ device error? */
+	if (!link->sactive || !(ehc->i.err_mask & AC_ERR_DEV))
+		return;
+
+	/* has LLDD analyzed already? */
+	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
+		qc = __ata_qc_from_tag(ap, tag);
+
+		if (!(qc->flags & ATA_QCFLAG_FAILED))
+			continue;
+
+		if (qc->err_mask)
+			return;
+	}
+
+	/* okay, this error is ours */
+	memset(&tf, 0, sizeof(tf));
+	rc = ata_eh_read_log_10h(dev, &tag, &tf);
+	if (rc) {
+		ata_link_printk(link, KERN_ERR, "failed to read log page 10h "
+				"(errno=%d)\n", rc);
+		return;
+	}
+
+	if (!(link->sactive & (1 << tag))) {
+		ata_link_printk(link, KERN_ERR, "log page 10h reported "
+				"inactive tag %d\n", tag);
+		return;
+	}
+
+	/* we've got the perpetrator, condemn it */
+	qc = __ata_qc_from_tag(ap, tag);
+	memcpy(&qc->result_tf, &tf, sizeof(tf));
+	qc->result_tf.flags = ATA_TFLAG_ISADDR | ATA_TFLAG_LBA | ATA_TFLAG_LBA48;
+	qc->err_mask |= AC_ERR_DEV | AC_ERR_NCQ;
+	ehc->i.err_mask &= ~AC_ERR_DEV;
+}
+EXPORT_SYMBOL_GPL(ata_eh_analyze_ncq_error);
+
+/**
+ *	ata_eh_set_lpm - configure SATA interface power management
+ *	@link: link to configure power management
+ *	@policy: the link power management policy
+ *	@r_failed_dev: out parameter for failed device
+ *
+ *	Enable SATA Interface power management.  This will enable
+ *	Device Interface Power Management (DIPM) for min_power
+ * 	policy, and then call driver specific callbacks for
+ *	enabling Host Initiated Power management.
+ *
+ *	LOCKING:
+ *	EH context.
+ *
+ *	RETURNS:
+ *	0 on success, -errno on failure.
+ */
+int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
+		   struct ata_device **r_failed_dev)
+{
+	struct ata_port *ap = ata_is_host_link(link) ? link->ap : NULL;
+	struct ata_eh_context *ehc = &link->eh_context;
+	struct ata_device *dev, *link_dev = NULL, *lpm_dev = NULL;
+	enum ata_lpm_policy old_policy = link->lpm_policy;
+	unsigned int hints = ATA_LPM_EMPTY | ATA_LPM_HIPM;
+	unsigned int err_mask;
+	int rc;
+
+	/* if the link or host doesn't do LPM, noop */
+	if ((link->flags & ATA_LFLAG_NO_LPM) || (ap && !ap->ops->set_lpm))
+		return 0;
+
+	/*
+	 * DIPM is enabled only for MIN_POWER as some devices
+	 * misbehave when the host NACKs transition to SLUMBER.  Order
+	 * device and link configurations such that the host always
+	 * allows DIPM requests.
+	 */
+	ata_for_each_dev(dev, link, ENABLED) {
+		bool hipm = ata_id_has_hipm(dev->id);
+		bool dipm = ata_id_has_dipm(dev->id);
+
+		/* find the first enabled and LPM enabled devices */
+		if (!link_dev)
+			link_dev = dev;
+
+		if (!lpm_dev && (hipm || dipm))
+			lpm_dev = dev;
+
+		hints &= ~ATA_LPM_EMPTY;
+		if (!hipm)
+			hints &= ~ATA_LPM_HIPM;
+
+		/* disable DIPM before changing link config */
+		if (policy != ATA_LPM_MIN_POWER && dipm) {
+			err_mask = ata_dev_set_feature(dev,
+					SETFEATURES_SATA_DISABLE, SATA_DIPM);
+			if (err_mask && err_mask != AC_ERR_DEV) {
+				ata_dev_printk(dev, KERN_WARNING,
+					"failed to disable DIPM, Emask 0x%x\n",
+					err_mask);
+				rc = -EIO;
+				goto fail;
+			}
+		}
+	}
+
+	if (ap) {
+		rc = ap->ops->set_lpm(link, policy, hints);
+		if (!rc && ap->slave_link)
+			rc = ap->ops->set_lpm(ap->slave_link, policy, hints);
+	} else
+		rc = sata_pmp_set_lpm(link, policy, hints);
+
+	/*
+	 * Attribute link config failure to the first (LPM) enabled
+	 * device on the link.
+	 */
+	if (rc) {
+		if (rc == -EOPNOTSUPP) {
+			link->flags |= ATA_LFLAG_NO_LPM;
+			return 0;
+		}
+		dev = lpm_dev ? lpm_dev : link_dev;
+		goto fail;
+	}
+
+	/*
+	 * Low level driver acked the transition.  Issue DIPM command
+	 * with the new policy set.
+	 */
+	link->lpm_policy = policy;
+	if (ap && ap->slave_link)
+		ap->slave_link->lpm_policy = policy;
+
+	/* host config updated, enable DIPM if transitioning to MIN_POWER */
+	ata_for_each_dev(dev, link, ENABLED) {
+		if (policy == ATA_LPM_MIN_POWER && ata_id_has_dipm(dev->id)) {
+			err_mask = ata_dev_set_feature(dev,
+					SETFEATURES_SATA_ENABLE, SATA_DIPM);
+			if (err_mask && err_mask != AC_ERR_DEV) {
+				ata_dev_printk(dev, KERN_WARNING,
+					"failed to enable DIPM, Emask 0x%x\n",
+					err_mask);
+				rc = -EIO;
+				goto fail;
+			}
+		}
+	}
+
+	return 0;
+
+fail:
+	/* restore the old policy */
+	link->lpm_policy = old_policy;
+	if (ap && ap->slave_link)
+		ap->slave_link->lpm_policy = old_policy;
+
+	/* if no device or only one more chance is left, disable LPM */
+	if (!dev || ehc->tries[dev->devno] <= 2) {
+		ata_link_printk(link, KERN_WARNING,
+				"disabling LPM on the link\n");
+		link->flags |= ATA_LFLAG_NO_LPM;
+	}
+	if (r_failed_dev)
+		*r_failed_dev = dev;
+	return rc;
+}
+
+#ifdef CONFIG_ATA_SFF
+/**
+ *	sata_sff_hardreset - reset host port via SATA phy reset
+ *	@link: link to reset
+ *	@class: resulting class of attached device
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	SATA phy-reset host port using DET bits of SControl register,
+ *	wait for !BSY and classify the attached device.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ *
+ *	RETURNS:
+ *	0 on success, -errno otherwise.
+ */
+int sata_sff_hardreset(struct ata_link *link, unsigned int *class,
+		       unsigned long deadline)
+{
+	struct ata_eh_context *ehc = &link->eh_context;
+	const unsigned long *timing = sata_ehc_deb_timing(ehc);
+	bool online;
+	int rc;
+
+	rc = sata_link_hardreset(link, timing, deadline, &online,
+				 ata_sff_check_ready);
+	if (online)
+		*class = ata_sff_dev_classify(link->device, 1, NULL);
+
+	DPRINTK("EXIT, class=%u\n", *class);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(sata_sff_hardreset);
+#endif
Index: b/drivers/ata/libata-sff.c
===================================================================
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -252,7 +252,7 @@ int ata_sff_busy_sleep(struct ata_port *
 }
 EXPORT_SYMBOL_GPL(ata_sff_busy_sleep);
 
-static int ata_sff_check_ready(struct ata_link *link)
+int ata_sff_check_ready(struct ata_link *link)
 {
 	u8 status = link->ap->ops->sff_check_status(link->ap);
 
@@ -2061,38 +2061,14 @@ int ata_sff_softreset(struct ata_link *l
 }
 EXPORT_SYMBOL_GPL(ata_sff_softreset);
 
-/**
- *	sata_sff_hardreset - reset host port via SATA phy reset
- *	@link: link to reset
- *	@class: resulting class of attached device
- *	@deadline: deadline jiffies for the operation
- *
- *	SATA phy-reset host port using DET bits of SControl register,
- *	wait for !BSY and classify the attached device.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep)
- *
- *	RETURNS:
- *	0 on success, -errno otherwise.
- */
+#ifndef CONFIG_SATA_HOST
 int sata_sff_hardreset(struct ata_link *link, unsigned int *class,
 		       unsigned long deadline)
 {
-	struct ata_eh_context *ehc = &link->eh_context;
-	const unsigned long *timing = sata_ehc_deb_timing(ehc);
-	bool online;
-	int rc;
-
-	rc = sata_link_hardreset(link, timing, deadline, &online,
-				 ata_sff_check_ready);
-	if (online)
-		*class = ata_sff_dev_classify(link->device, 1, NULL);
-
-	DPRINTK("EXIT, class=%u\n", *class);
-	return rc;
+	return -EOPNOTSUPP;
 }
 EXPORT_SYMBOL_GPL(sata_sff_hardreset);
+#endif
 
 /**
  *	ata_sff_postreset - SFF postreset callback
Index: b/drivers/ata/libata.h
===================================================================
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -53,6 +53,29 @@ enum {
 	ATA_DNXFER_QUIET	= (1 << 31),
 };
 
+static inline bool ata_sstatus_online(u32 sstatus)
+{
+	return (sstatus & 0xf) == 0x3;
+}
+
+struct ata_force_param {
+	const char	*name;
+	unsigned int	cbl;
+	int		spd_limit;
+	unsigned long	xfer_mask;
+	unsigned int	horkage_on;
+	unsigned int	horkage_off;
+	unsigned int	lflags;
+};
+
+struct ata_force_ent {
+	int			port;
+	int			device;
+	struct ata_force_param	param;
+};
+
+extern struct ata_force_ent *ata_force_tbl;
+extern int ata_force_tbl_size;
 extern unsigned int ata_print_id;
 extern int atapi_passthru16;
 extern int libata_fua;
@@ -84,7 +107,6 @@ extern int ata_dev_reread_id(struct ata_
 extern int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 			      unsigned int readid_flags);
 extern int ata_dev_configure(struct ata_device *dev);
-extern int sata_down_spd_limit(struct ata_link *link, u32 spd_limit);
 extern int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel);
 extern unsigned int ata_dev_set_feature(struct ata_device *dev,
 					u8 enable, u8 feature);
@@ -98,12 +120,37 @@ extern bool ata_phys_link_online(struct
 extern bool ata_phys_link_offline(struct ata_link *link);
 extern void ata_dev_init(struct ata_device *dev);
 extern void ata_link_init(struct ata_port *ap, struct ata_link *link, int pmp);
-extern int sata_link_init_spd(struct ata_link *link);
 extern int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern struct ata_port *ata_port_alloc(struct ata_host *host);
 extern const char *sata_spd_string(unsigned int spd);
 
+/* libata-sata.c */
+#ifdef CONFIG_SATA_HOST
+int ata_do_link_spd_horkage(struct ata_device *dev);
+int ata_dev_config_ncq(struct ata_device *dev, char *desc, size_t desc_sz);
+int sata_down_spd_limit(struct ata_link *link, u32 spd_limit);
+int sata_link_init_spd(struct ata_link *link);
+void ata_eh_analyze_serror(struct ata_link *link);
+int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
+		   struct ata_device **r_failed_dev);
+#else
+static inline int ata_do_link_spd_horkage(struct ata_device *dev) { return 0; }
+static inline int ata_dev_config_ncq(struct ata_device *dev,
+			       char *desc, size_t desc_sz)
+{
+	desc[0] = '\0';
+	return 0;
+}
+static inline int sata_down_spd_limit(struct ata_link *link,
+				      u32 spd_limit) { return 0; }
+static inline int sata_link_init_spd(struct ata_link *link) { return 0; }
+static inline void ata_eh_analyze_serror(struct ata_link *link) { }
+static inline int ata_eh_set_lpm(struct ata_link *link,
+				 enum ata_lpm_policy policy,
+				 struct ata_device **r_failed_dev) { return 0; }
+#endif
+
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
 extern unsigned int ata_acpi_gtf_filter;
@@ -206,6 +253,7 @@ static inline int sata_pmp_attach(struct
 
 /* libata-sff.c */
 #ifdef CONFIG_ATA_SFF
+extern int ata_sff_check_ready(struct ata_link *link);
 extern void ata_sff_flush_pio_task(struct ata_port *ap);
 extern void ata_sff_port_init(struct ata_port *ap);
 extern int ata_sff_init(void);
Index: b/include/linux/libata.h
===================================================================
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -931,15 +931,13 @@ struct ata_timing {
 };
 
 /*
- * Core layer - drivers/ata/libata-core.c
+ * SATA host - drivers/ata/libata-sata.c
  */
+#ifdef CONFIG_SATA_HOST
 extern const unsigned long sata_deb_timing_normal[];
 extern const unsigned long sata_deb_timing_hotplug[];
 extern const unsigned long sata_deb_timing_long[];
 
-extern struct ata_port_operations ata_dummy_port_ops;
-extern const struct ata_port_info ata_dummy_port_info;
-
 static inline const unsigned long *
 sata_ehc_deb_timing(struct ata_eh_context *ehc)
 {
@@ -949,24 +947,33 @@ sata_ehc_deb_timing(struct ata_eh_contex
 		return sata_deb_timing_normal;
 }
 
+void ata_tf_from_fis(const u8 *fis, struct ata_taskfile *tf);
+int sata_set_spd(struct ata_link *link);
+int sata_link_debounce(struct ata_link *link, const unsigned long *params,
+		       unsigned long deadline);
+int sata_link_resume(struct ata_link *link, const unsigned long *params,
+		     unsigned long deadline);
+int sata_link_hardreset(struct ata_link *link, const unsigned long *timing,
+			unsigned long deadline, bool *online,
+			int (*check_ready)(struct ata_link *));
+#endif
+
+/*
+ * Core layer - drivers/ata/libata-core.c
+ */
+extern struct ata_port_operations ata_dummy_port_ops;
+extern const struct ata_port_info ata_dummy_port_info;
+
 static inline int ata_port_is_dummy(struct ata_port *ap)
 {
 	return ap->ops == &ata_dummy_port_ops;
 }
 
-extern int sata_set_spd(struct ata_link *link);
 extern int ata_std_prereset(struct ata_link *link, unsigned long deadline);
 extern int ata_wait_after_reset(struct ata_link *link, unsigned long deadline,
 				int (*check_ready)(struct ata_link *link));
-extern int sata_link_debounce(struct ata_link *link,
-			const unsigned long *params, unsigned long deadline);
-extern int sata_link_resume(struct ata_link *link, const unsigned long *params,
-			    unsigned long deadline);
 extern int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 			     bool spm_wakeup);
-extern int sata_link_hardreset(struct ata_link *link,
-			const unsigned long *timing, unsigned long deadline,
-			bool *online, int (*check_ready)(struct ata_link *));
 extern int sata_std_hardreset(struct ata_link *link, unsigned int *class,
 			      unsigned long deadline);
 extern void ata_std_postreset(struct ata_link *link, unsigned int *classes);
@@ -1015,7 +1022,6 @@ extern u32 ata_wait_register(struct ata_
 extern int atapi_cmd_type(u8 opcode);
 extern void ata_tf_to_fis(const struct ata_taskfile *tf,
 			  u8 pmp, int is_cmd, u8 *fis);
-extern void ata_tf_from_fis(const u8 *fis, struct ata_taskfile *tf);
 extern unsigned long ata_pack_xfermask(unsigned long pio_mask,
 			unsigned long mwdma_mask, unsigned long udma_mask);
 extern void ata_unpack_xfermask(unsigned long xfer_mask,
