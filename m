Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1BIOSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 09:18:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51660 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab1BIOR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 09:17:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:message-id
         :content-type:content-transfer-encoding;
        b=fDSZ9yJ13wfwl85JPiqIr934gGQGVQxJQ0lTQ4iS5GOa14vcxiCws3f4vFpI+57gcl
         jMRo2WzCtmYdxjl3dPFIpGqI7DGU5ZJUXHK2kIy5612emCBZkAfm5gME4xQvr+2p5QiR
         dPrysF8nFJ0T1nabA6BmG8/+z9n3TVIChux7Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ata: add CONFIG_SATA_HOST config option
Date: Wed, 9 Feb 2011 15:14:30 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201102091514.31355.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_SATA_HOST config option (for selecting SATA Host
support) to make setup easier on PATA-only systems.

Additionally this allows us to save ~9.5k of the output code
size (x86-64) on such systems:

   text    data     bss     dec     hex filename
  49909    6576      57   56542    dcde drivers/ata/libata-core.o.before
  31862      16       2   31880    7c88 drivers/ata/libata-eh.o.before
  20256       0      19   20275    4f33 drivers/ata/libata-sff.o.before
  44495    6576      57   51128    c7b8 drivers/ata/libata-core.o.after
  27831      16       2   27849    6cc9 drivers/ata/libata-eh.o.after
  20144       0      19   20163    4ec3 drivers/ata/libata-sff.o.after

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
I also wonder if  SATA code should be moved to libata-sata.c (to avoid ifdefs)?

 drivers/ata/Kconfig       |   25 ++++++++--
 drivers/ata/libata-core.c |  107 +++++++++++++++++++++++++++++++++++++++-------
 drivers/ata/libata-eh.c   |   21 ++++++++-
 drivers/ata/libata-sff.c  |    8 +++
 4 files changed, 141 insertions(+), 20 deletions(-)

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
@@ -122,7 +133,7 @@ comment "SFF controllers with custom DMA
 
 config PDC_ADMA
 	tristate "Pacific Digital ADMA support"
-	depends on PCI
+	depends on PCI && SATA_HOST
 	help
 	  This option enables support for Pacific Digital ADMA controllers
 
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
+comment "SATA/PATA SFF controllers with BMDMA"
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
Index: b/drivers/ata/libata-core.c
===================================================================
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -70,10 +70,15 @@
 #include "libata.h"
 #include "libata-transport.h"
 
+#ifdef CONFIG_SATA_HOST
 /* debounce timing parameters in msecs { interval, duration, timeout } */
 const unsigned long sata_deb_timing_normal[]		= {   5,  100, 2000 };
+EXPORT_SYMBOL_GPL(sata_deb_timing_normal);
 const unsigned long sata_deb_timing_hotplug[]		= {  25,  500, 2000 };
+EXPORT_SYMBOL_GPL(sata_deb_timing_hotplug);
 const unsigned long sata_deb_timing_long[]		= { 100, 2000, 5000 };
+EXPORT_SYMBOL_GPL(sata_deb_timing_long);
+#endif
 
 const struct ata_port_operations ata_base_port_ops = {
 	.prereset		= ata_std_prereset,
@@ -341,6 +346,7 @@ void ata_force_cbl(struct ata_port *ap)
 	}
 }
 
+#ifdef CONFIG_SATA_HOST
 /**
  *	ata_force_link_limits - force link limits according to libata.force
  *	@link: ATA link of interest
@@ -393,6 +399,7 @@ static void ata_force_link_limits(struct
 		}
 	}
 }
+#endif
 
 /**
  *	ata_force_xfermask - force xfermask according to libata.force
@@ -573,6 +580,7 @@ void ata_tf_to_fis(const struct ata_task
 	fis[19] = 0;
 }
 
+#ifdef CONFIG_SATA_HOST
 /**
  *	ata_tf_from_fis - Convert SATA FIS to ATA taskfile
  *	@fis: Buffer from which data will be input
@@ -601,6 +609,9 @@ void ata_tf_from_fis(const u8 *fis, stru
 	tf->nsect	= fis[12];
 	tf->hob_nsect	= fis[13];
 }
+#else
+void ata_tf_from_fis(const u8 *fis, struct ata_taskfile *tf) { }
+#endif
 
 static const u8 ata_rw_cmds[] = {
 	/* pio multi */
@@ -2039,6 +2050,7 @@ retry:
 	return rc;
 }
 
+#ifdef CONFIG_SATA_HOST
 static int ata_do_link_spd_horkage(struct ata_device *dev)
 {
 	struct ata_link *plink = ata_dev_phys_link(dev);
@@ -2072,6 +2084,9 @@ static int ata_do_link_spd_horkage(struc
 	}
 	return 0;
 }
+#else
+static int ata_do_link_spd_horkage(struct ata_device *dev) { return 0; }
+#endif
 
 static inline u8 ata_dev_knobble(struct ata_device *dev)
 {
@@ -2083,6 +2098,7 @@ static inline u8 ata_dev_knobble(struct
 	return ((ap->cbl == ATA_CBL_SATA) && (!ata_id_is_sata(dev->id)));
 }
 
+#ifdef CONFIG_SATA_HOST
 static int ata_dev_config_ncq(struct ata_device *dev,
 			       char *desc, size_t desc_sz)
 {
@@ -2127,6 +2143,14 @@ static int ata_dev_config_ncq(struct ata
 			ddepth, aa_desc);
 	return 0;
 }
+#else
+static int ata_dev_config_ncq(struct ata_device *dev,
+			       char *desc, size_t desc_sz)
+{
+	desc[0] = '\0';
+	return 0;
+}
+#endif
 
 /**
  *	ata_dev_configure - Configure the specified ATA/ATAPI device
@@ -2644,6 +2668,7 @@ int ata_bus_probe(struct ata_port *ap)
 	goto retry;
 }
 
+#ifdef CONFIG_SATA_HOST
 /**
  *	sata_print_link_status - Print SATA link status
  *	@link: SATA link to printk link status about
@@ -2672,6 +2697,9 @@ static void sata_print_link_status(struc
 				sstatus, scontrol);
 	}
 }
+#else
+static void sata_print_link_status(struct ata_link *link) { }
+#endif
 
 /**
  *	ata_dev_pair		-	return other device on cable
@@ -2690,6 +2718,7 @@ struct ata_device *ata_dev_pair(struct a
 	return pair;
 }
 
+#ifdef CONFIG_SATA_HOST
 /**
  *	sata_down_spd_limit - adjust SATA spd limit downward
  *	@link: Link to adjust SATA spd limit for
@@ -2843,6 +2872,18 @@ int sata_set_spd(struct ata_link *link)
 
 	return 1;
 }
+#else
+int sata_down_spd_limit(struct ata_link *link, u32 spd_limit)
+{
+	return 0;
+}
+
+int sata_set_spd(struct ata_link *link)
+{
+	return 0;
+}
+#endif
+EXPORT_SYMBOL_GPL(sata_set_spd);
 
 /*
  * This mode timing computation functionality is ported over from
@@ -3436,6 +3477,7 @@ int ata_wait_after_reset(struct ata_link
 	return ata_wait_ready(link, deadline, check_ready);
 }
 
+#ifdef CONFIG_SATA_HOST
 /**
  *	sata_link_debounce - debounce SATA phy status
  *	@link: ATA link to debounce SATA phy status for
@@ -3638,6 +3680,26 @@ int sata_link_scr_lpm(struct ata_link *l
 	ehc->i.serror &= ~SERR_PHYRDY_CHG;
 	return sata_scr_write(link, SCR_ERROR, SERR_PHYRDY_CHG);
 }
+#else
+int sata_link_debounce(struct ata_link *link, const unsigned long *params,
+		       unsigned long deadline)
+{
+	return -EOPNOTSUPP;
+}
+int sata_link_resume(struct ata_link *link, const unsigned long *params,
+		     unsigned long deadline)
+{
+	return -EOPNOTSUPP;
+}
+int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
+		      bool spm_wakeup)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+EXPORT_SYMBOL_GPL(sata_link_debounce);
+EXPORT_SYMBOL_GPL(sata_link_resume);
+EXPORT_SYMBOL_GPL(sata_link_scr_lpm);
 
 /**
  *	ata_std_prereset - prepare for reset
@@ -3658,23 +3720,26 @@ int sata_link_scr_lpm(struct ata_link *l
  */
 int ata_std_prereset(struct ata_link *link, unsigned long deadline)
 {
-	struct ata_port *ap = link->ap;
 	struct ata_eh_context *ehc = &link->eh_context;
-	const unsigned long *timing = sata_ehc_deb_timing(ehc);
-	int rc;
 
 	/* if we're about to do hardreset, nothing more to do */
 	if (ehc->i.action & ATA_EH_HARDRESET)
 		return 0;
 
+#ifdef CONFIG_SATA_HOST
 	/* if SATA, resume link */
 	if (ap->flags & ATA_FLAG_SATA) {
+		struct ata_port *ap = link->ap;
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
@@ -3683,6 +3748,7 @@ int ata_std_prereset(struct ata_link *li
 	return 0;
 }
 
+#ifdef CONFIG_SATA_HOST
 /**
  *	sata_link_hardreset - reset link via SATA phy reset
  *	@link: link to reset
@@ -3821,6 +3887,23 @@ int sata_std_hardreset(struct ata_link *
 	rc = sata_link_hardreset(link, timing, deadline, &online, NULL);
 	return online ? -EAGAIN : rc;
 }
+#else
+int sata_link_hardreset(struct ata_link *link, const unsigned long *timing,
+			unsigned long deadline,
+			bool *online, int (*check_ready)(struct ata_link *))
+{
+	*online = false;
+	return -EOPNOTSUPP;
+}
+
+int sata_std_hardreset(struct ata_link *link, unsigned int *class,
+		       unsigned long deadline)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+EXPORT_SYMBOL_GPL(sata_link_hardreset);
+EXPORT_SYMBOL_GPL(sata_std_hardreset);
 
 /**
  *	ata_std_postreset - standard postreset callback
@@ -5424,6 +5507,7 @@ void ata_link_init(struct ata_port *ap,
 	}
 }
 
+#ifdef CONFIG_SATA_HOST
 /**
  *	sata_link_init_spd - Initialize link->sata_spd_limit
  *	@link: Link to configure sata_spd_limit for
@@ -5456,6 +5540,12 @@ int sata_link_init_spd(struct ata_link *
 
 	return 0;
 }
+#else
+int sata_link_init_spd(struct ata_link *link)
+{
+	return 0;
+}
+#endif
 
 /**
  *	ata_port_alloc - allocate and initialize basic ATA port resources
@@ -6599,9 +6689,6 @@ const struct ata_port_info ata_dummy_por
  * likely to change as new drivers are added and updated.
  * Do not depend on ABI/API stability.
  */
-EXPORT_SYMBOL_GPL(sata_deb_timing_normal);
-EXPORT_SYMBOL_GPL(sata_deb_timing_hotplug);
-EXPORT_SYMBOL_GPL(sata_deb_timing_long);
 EXPORT_SYMBOL_GPL(ata_base_port_ops);
 EXPORT_SYMBOL_GPL(sata_port_ops);
 EXPORT_SYMBOL_GPL(ata_dummy_port_ops);
@@ -6635,14 +6722,8 @@ EXPORT_SYMBOL_GPL(ata_do_set_mode);
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
 EXPORT_SYMBOL_GPL(ata_std_postreset);
 EXPORT_SYMBOL_GPL(ata_dev_classify);
 EXPORT_SYMBOL_GPL(ata_dev_pair);
@@ -6696,12 +6777,10 @@ EXPORT_SYMBOL_GPL(ata_port_schedule_eh);
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
@@ -1080,6 +1080,7 @@ int ata_port_freeze(struct ata_port *ap)
 	return nr_aborted;
 }
 
+#ifdef CONFIG_SATA_HOST
 /**
  *	sata_async_notification - SATA async notification handler
  *	@ap: ATA port where async notification is received
@@ -1152,6 +1153,8 @@ int sata_async_notification(struct ata_p
 		return 0;
 	}
 }
+EXPORT_SYMBOL_GPL(sata_async_notification);
+#endif
 
 /**
  *	ata_eh_freeze_port - EH helper to freeze port
@@ -1406,6 +1409,7 @@ static const char *ata_err_string(unsign
 	return "unknown error";
 }
 
+#ifdef CONFIG_SATA_HOST
 /**
  *	ata_read_log_page - read a specific log page
  *	@dev: target device
@@ -1497,6 +1501,7 @@ static int ata_eh_read_log_10h(struct at
 
 	return 0;
 }
+#endif
 
 /**
  *	atapi_eh_tur - perform ATAPI TEST_UNIT_READY
@@ -1583,6 +1588,7 @@ static unsigned int atapi_eh_request_sen
 				 sense_buf, SCSI_SENSE_BUFFERSIZE, 0);
 }
 
+#ifdef CONFIG_SATA_HOST
 /**
  *	ata_eh_analyze_serror - analyze SError for a failed port
  *	@link: ATA link to analyze SError for
@@ -1694,6 +1700,11 @@ void ata_eh_analyze_ncq_error(struct ata
 	qc->err_mask |= AC_ERR_DEV | AC_ERR_NCQ;
 	ehc->i.err_mask &= ~AC_ERR_DEV;
 }
+#else
+static void ata_eh_analyze_serror(struct ata_link *link) { }
+void ata_eh_analyze_ncq_error(struct ata_link *link) { }
+#endif
+EXPORT_SYMBOL_GPL(ata_eh_analyze_ncq_error);
 
 /**
  *	ata_eh_analyze_tf - analyze taskfile of a failed qc
@@ -2349,7 +2360,7 @@ static void ata_eh_link_report(struct at
 			ata_link_printk(link, KERN_ERR, "%s\n", desc);
 	}
 
-#ifdef CONFIG_ATA_VERBOSE_ERROR
+#if defined(CONFIG_SATA_HOST) && defined(CONFIG_ATA_VERBOSE_ERROR)
 	if (ehc->i.serror)
 		ata_link_printk(link, KERN_ERR,
 		  "SError: { %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s}\n",
@@ -3252,6 +3263,7 @@ static int ata_eh_maybe_retry_flush(stru
 	return rc;
 }
 
+#ifdef CONFIG_SATA_HOST
 /**
  *	ata_eh_set_lpm - configure SATA interface power management
  *	@link: link to configure power management
@@ -3380,6 +3392,13 @@ fail:
 		*r_failed_dev = dev;
 	return rc;
 }
+#else
+static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
+			  struct ata_device **r_failed_dev)
+{
+	return 0;
+}
+#endif
 
 static int ata_link_nr_enabled(struct ata_link *link)
 {
Index: b/drivers/ata/libata-sff.c
===================================================================
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2061,6 +2061,7 @@ int ata_sff_softreset(struct ata_link *l
 }
 EXPORT_SYMBOL_GPL(ata_sff_softreset);
 
+#ifdef CONFIG_SATA_HOST
 /**
  *	sata_sff_hardreset - reset host port via SATA phy reset
  *	@link: link to reset
@@ -2092,6 +2093,13 @@ int sata_sff_hardreset(struct ata_link *
 	DPRINTK("EXIT, class=%u\n", *class);
 	return rc;
 }
+#else
+int sata_sff_hardreset(struct ata_link *link, unsigned int *class,
+		       unsigned long deadline)
+{
+	return -EOPNOTSUPP;
+}
+#endif
 EXPORT_SYMBOL_GPL(sata_sff_hardreset);
 
 /**
