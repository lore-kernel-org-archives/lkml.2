Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1DOWxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 18:53:15 -0400
Received: from mail.perches.com ([173.55.12.10]:4726 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab1DOWxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 18:53:07 -0400
From: Joe Perches <joe@perches.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] ata: Convert ata_<foo>_printk(KERN_<LEVEL> to ata_<foo>_<level>(
Date: Fri, 15 Apr 2011 15:51:59 -0700
Message-Id: <985204573545248ef2c62f0e7ad0846b8db6c2b8.1302907497.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1302907496.git.joe@perches.com>
References: <cover.1302907496.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saves text by removing nearly duplicated text format strings by
creating ata_<foo>_printk functions and printf extension %pV.

ata defconfig size shrinks ~5% (~8KB), allyesconfig ~2.5% (~13KB)

Format string duplication comes from:

 #define ata_link_printk(link, lv, fmt, args...) do { \
       if (sata_pmp_attached((link)->ap) || (link)->ap->slave_link)    \
               printk("%sata%u.%02u: "fmt, lv, (link)->ap->print_id,   \
                      (link)->pmp , ##args); \
       else \
               printk("%sata%u: "fmt, lv, (link)->ap->print_id , ##args); \
       } while(0)

Coalesce long formats.

$ size drivers/ata/built-in.*
   text	   data	    bss	    dec	    hex	filename
 544969	  73893	 116584	 735446	  b38d6	drivers/ata/built-in.allyesconfig.ata.o
 558429	  73893	 117864	 750186	  b726a	drivers/ata/built-in.allyesconfig.dev_level.o
 141328	  14689	   4220	 160237	  271ed	drivers/ata/built-in.defconfig.ata.o
 149567	  14689	   4220	 168476	  2921c	drivers/ata/built-in.defconfig.dev_level.o

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ata/ahci.c            |    5 +-
 drivers/ata/ata_generic.c     |    5 +-
 drivers/ata/libahci.c         |   24 ++--
 drivers/ata/libata-acpi.c     |   66 +++----
 drivers/ata/libata-core.c     |  381 +++++++++++++++++++++++------------------
 drivers/ata/libata-eh.c       |  143 ++++++++--------
 drivers/ata/libata-pmp.c      |  123 +++++++-------
 drivers/ata/libata-scsi.c     |   22 +--
 drivers/ata/libata-sff.c      |   32 ++--
 drivers/ata/pata_ali.c        |    8 +-
 drivers/ata/pata_amd.c        |    2 +-
 drivers/ata/pata_bf54x.c      |    4 +-
 drivers/ata/pata_icside.c     |    4 +-
 drivers/ata/pata_it821x.c     |   14 +-
 drivers/ata/pata_ixp4xx_cf.c  |    2 +-
 drivers/ata/pata_legacy.c     |    2 +-
 drivers/ata/pata_macio.c      |    5 +-
 drivers/ata/pata_octeon_cf.c  |    2 +-
 drivers/ata/pata_pcmcia.c     |    5 +-
 drivers/ata/pata_platform.c   |    2 +-
 drivers/ata/pata_rz1000.c     |    2 +-
 drivers/ata/pata_samsung_cf.c |    2 +-
 drivers/ata/pata_scc.c        |    3 +-
 drivers/ata/pata_via.c        |    4 +-
 drivers/ata/sata_fsl.c        |   29 ++--
 drivers/ata/sata_inic162x.c   |   15 +-
 drivers/ata/sata_mv.c         |   41 ++---
 drivers/ata/sata_nv.c         |   69 ++++----
 drivers/ata/sata_sil.c        |    8 +-
 drivers/ata/sata_sil24.c      |   17 +-
 drivers/ata/sata_via.c        |    6 +-
 include/linux/libata.h        |   56 +++++--
 32 files changed, 568 insertions(+), 535 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 70eda40..5296792 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -534,9 +534,8 @@ static int ahci_sb600_softreset(struct ata_link *link, unsigned int *class,
 	if (rc == -EIO) {
 		irq_sts = readl(port_mmio + PORT_IRQ_STAT);
 		if (irq_sts & PORT_IRQ_BAD_PMP) {
-			ata_link_printk(link, KERN_WARNING,
-					"applying SB600 PMP SRST workaround "
-					"and retrying\n");
+			ata_link_warn(link,
+				      "applying SB600 PMP SRST workaround and retrying\n");
 			rc = ahci_do_softreset(link, class, 0, deadline,
 					       ahci_check_ready);
 		}
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 721d38b..7df56ec 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -81,14 +81,13 @@ static int generic_set_mode(struct ata_link *link, struct ata_device **unused)
 				xfer_mask |= ata_xfer_mode2mask(XFER_MW_DMA_0);
 			}
 
-			ata_dev_printk(dev, KERN_INFO, "configured for %s\n",
-				       name);
+			ata_dev_info(dev, "configured for %s\n", name);
 
 			dev->xfer_mode = ata_xfer_mask2mode(xfer_mask);
 			dev->xfer_shift = ata_xfer_mode2shift(dev->xfer_mode);
 			dev->flags &= ~ATA_DFLAG_PIO;
 		} else {
-			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+			ata_dev_info(dev, "configured for PIO\n");
 			dev->xfer_mode = XFER_PIO_0;
 			dev->xfer_shift = ATA_SHIFT_PIO;
 			dev->flags |= ATA_DFLAG_PIO;
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 18a4d53..6f545bf 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -282,10 +282,10 @@ static ssize_t ahci_read_em_buffer(struct device *dev,
 	/* the count should not be larger than PAGE_SIZE */
 	if (count > PAGE_SIZE) {
 		if (printk_ratelimit())
-			ata_port_printk(ap, KERN_WARNING,
-					"EM read buffer size too large: "
-					"buffer size %u, page size %lu\n",
-					hpriv->em_buf_sz, PAGE_SIZE);
+			ata_port_warn(ap,
+				      "EM read buffer size too large: "
+				      "buffer size %u, page size %lu\n",
+				      hpriv->em_buf_sz, PAGE_SIZE);
 		count = PAGE_SIZE;
 	}
 
@@ -1102,8 +1102,8 @@ static void ahci_dev_config(struct ata_device *dev)
 
 	if (hpriv->flags & AHCI_HFLAG_SECT255) {
 		dev->max_sectors = 255;
-		ata_dev_printk(dev, KERN_INFO,
-			       "SB600 AHCI: limiting to 255 sectors per cmd\n");
+		ata_dev_info(dev,
+			     "SB600 AHCI: limiting to 255 sectors per cmd\n");
 	}
 }
 
@@ -1227,8 +1227,7 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 	/* prepare for SRST (AHCI-1.1 10.4.1) */
 	rc = ahci_kick_engine(ap);
 	if (rc && rc != -EOPNOTSUPP)
-		ata_link_printk(link, KERN_WARNING,
-				"failed to reset engine (errno=%d)\n", rc);
+		ata_link_warn(link, "failed to reset engine (errno=%d)\n", rc);
 
 	ata_tf_init(link->device, &tf);
 
@@ -1261,8 +1260,7 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 		 * be trusted.  Treat device readiness timeout as link
 		 * offline.
 		 */
-		ata_link_printk(link, KERN_INFO,
-				"device not ready, treating as offline\n");
+		ata_link_info(link, "device not ready, treating as offline\n");
 		*class = ATA_DEV_NONE;
 	} else if (rc) {
 		/* link occupied, -ENODEV too is an error */
@@ -1275,7 +1273,7 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 	return 0;
 
  fail:
-	ata_link_printk(link, KERN_ERR, "softreset failed (%s)\n", reason);
+	ata_link_err(link, "softreset failed (%s)\n", reason);
 	return rc;
 }
 
@@ -1931,7 +1929,7 @@ static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
 	if (rc == 0)
 		ahci_power_down(ap);
 	else {
-		ata_port_printk(ap, KERN_ERR, "%s (%d)\n", emsg, rc);
+		ata_port_err(ap, "%s (%d)\n", emsg, rc);
 		ahci_start_port(ap);
 	}
 
@@ -2026,7 +2024,7 @@ static void ahci_port_stop(struct ata_port *ap)
 	/* de-initialize port */
 	rc = ahci_deinit_port(ap, &emsg);
 	if (rc)
-		ata_port_printk(ap, KERN_WARNING, "%s (%d)\n", emsg, rc);
+		ata_port_warn(ap, "%s (%d)\n", emsg, rc);
 }
 
 void ahci_print_info(struct ata_host *host, const char *scc_s)
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index a791b8ce..e0a5b55 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -332,25 +332,22 @@ int ata_acpi_gtm(struct ata_port *ap, struct ata_acpi_gtm *gtm)
 
 	rc = -EINVAL;
 	if (ACPI_FAILURE(status)) {
-		ata_port_printk(ap, KERN_ERR,
-				"ACPI get timing mode failed (AE 0x%x)\n",
-				status);
+		ata_port_err(ap, "ACPI get timing mode failed (AE 0x%x)\n",
+			     status);
 		goto out_free;
 	}
 
 	out_obj = output.pointer;
 	if (out_obj->type != ACPI_TYPE_BUFFER) {
-		ata_port_printk(ap, KERN_WARNING,
-				"_GTM returned unexpected object type 0x%x\n",
-				out_obj->type);
+		ata_port_warn(ap, "_GTM returned unexpected object type 0x%x\n",
+			      out_obj->type);
 
 		goto out_free;
 	}
 
 	if (out_obj->buffer.length != sizeof(struct ata_acpi_gtm)) {
-		ata_port_printk(ap, KERN_ERR,
-				"_GTM returned invalid length %d\n",
-				out_obj->buffer.length);
+		ata_port_err(ap, "_GTM returned invalid length %d\n",
+			     out_obj->buffer.length);
 		goto out_free;
 	}
 
@@ -402,8 +399,8 @@ int ata_acpi_stm(struct ata_port *ap, const struct ata_acpi_gtm *stm)
 	if (status == AE_NOT_FOUND)
 		return -ENOENT;
 	if (ACPI_FAILURE(status)) {
-		ata_port_printk(ap, KERN_ERR,
-			"ACPI set timing mode failed (status=0x%x)\n", status);
+		ata_port_err(ap, "ACPI set timing mode failed (status=0x%x)\n",
+			     status);
 		return -EINVAL;
 	}
 	return 0;
@@ -450,8 +447,8 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf)
 	output.pointer = NULL;	/* ACPI-CA sets this; save/free it later */
 
 	if (ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER: port#: %d\n",
-			       __func__, ap->port_no);
+		ata_dev_dbg(dev, "%s: ENTER: port#: %d\n",
+			    __func__, ap->port_no);
 
 	/* _GTF has no input parameters */
 	status = acpi_evaluate_object(dev->acpi_handle, "_GTF", NULL, &output);
@@ -459,9 +456,8 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf)
 
 	if (ACPI_FAILURE(status)) {
 		if (status != AE_NOT_FOUND) {
-			ata_dev_printk(dev, KERN_WARNING,
-				       "_GTF evaluation failed (AE 0x%x)\n",
-				       status);
+			ata_dev_warn(dev, "_GTF evaluation failed (AE 0x%x)\n",
+				     status);
 			rc = -EINVAL;
 		}
 		goto out_free;
@@ -469,27 +465,24 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf)
 
 	if (!output.length || !output.pointer) {
 		if (ata_msg_probe(ap))
-			ata_dev_printk(dev, KERN_DEBUG, "%s: Run _GTF: "
-				"length or ptr is NULL (0x%llx, 0x%p)\n",
-				__func__,
-				(unsigned long long)output.length,
-				output.pointer);
+			ata_dev_dbg(dev, "%s: Run _GTF: length or ptr is NULL (0x%llx, 0x%p)\n",
+				    __func__,
+				    (unsigned long long)output.length,
+				    output.pointer);
 		rc = -EINVAL;
 		goto out_free;
 	}
 
 	if (out_obj->type != ACPI_TYPE_BUFFER) {
-		ata_dev_printk(dev, KERN_WARNING,
-			       "_GTF unexpected object type 0x%x\n",
-			       out_obj->type);
+		ata_dev_warn(dev, "_GTF unexpected object type 0x%x\n",
+			     out_obj->type);
 		rc = -EINVAL;
 		goto out_free;
 	}
 
 	if (out_obj->buffer.length % REGS_PER_GTF) {
-		ata_dev_printk(dev, KERN_WARNING,
-			       "unexpected _GTF length (%d)\n",
-			       out_obj->buffer.length);
+		ata_dev_warn(dev, "unexpected _GTF length (%d)\n",
+			     out_obj->buffer.length);
 		rc = -EINVAL;
 		goto out_free;
 	}
@@ -499,9 +492,8 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf)
 	if (gtf) {
 		*gtf = (void *)out_obj->buffer.pointer;
 		if (ata_msg_probe(ap))
-			ata_dev_printk(dev, KERN_DEBUG,
-				       "%s: returning gtf=%p, gtf_count=%d\n",
-				       __func__, *gtf, rc);
+			ata_dev_dbg(dev, "%s: returning gtf=%p, gtf_count=%d\n",
+				    __func__, *gtf, rc);
 	}
 	return rc;
 
@@ -811,8 +803,8 @@ static int ata_acpi_push_id(struct ata_device *dev)
 	union acpi_object in_params[1];
 
 	if (ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_DEBUG, "%s: ix = %d, port#: %d\n",
-			       __func__, dev->devno, ap->port_no);
+		ata_dev_dbg(dev, "%s: ix = %d, port#: %d\n",
+			    __func__, dev->devno, ap->port_no);
 
 	/* Give the drive Identify data to the drive via the _SDD method */
 	/* _SDD: set up input parameters */
@@ -832,8 +824,7 @@ static int ata_acpi_push_id(struct ata_device *dev)
 		return -ENOENT;
 
 	if (ACPI_FAILURE(status)) {
-		ata_dev_printk(dev, KERN_WARNING,
-			       "ACPI _SDD failed (AE 0x%x)\n", status);
+		ata_dev_warn(dev, "ACPI _SDD failed (AE 0x%x)\n", status);
 		return -EIO;
 	}
 
@@ -983,8 +974,8 @@ int ata_acpi_on_devcfg(struct ata_device *dev)
 	if (nr_executed) {
 		rc = ata_dev_reread_id(dev, 0);
 		if (rc < 0) {
-			ata_dev_printk(dev, KERN_ERR, "failed to IDENTIFY "
-				       "after ACPI commands\n");
+			ata_dev_err(dev,
+				    "failed to IDENTIFY after ACPI commands\n");
 			return rc;
 		}
 	}
@@ -1002,8 +993,7 @@ int ata_acpi_on_devcfg(struct ata_device *dev)
 		return rc;
 	}
 
-	ata_dev_printk(dev, KERN_WARNING,
-		       "ACPI: failed the second time, disabled\n");
+	ata_dev_warn(dev, "ACPI: failed the second time, disabled\n");
 	dev->acpi_handle = NULL;
 
 	/* We can safely continue if no _GTF command has been executed
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4e4801e..03b05b0 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -335,8 +335,7 @@ void ata_force_cbl(struct ata_port *ap)
 			continue;
 
 		ap->cbl = fe->param.cbl;
-		ata_port_printk(ap, KERN_NOTICE,
-				"FORCE: cable set to %s\n", fe->param.name);
+		ata_port_notice(ap, "FORCE: cable set to %s\n", fe->param.name);
 		return;
 	}
 }
@@ -378,8 +377,7 @@ static void ata_force_link_limits(struct ata_link *link)
 		/* only honor the first spd limit */
 		if (!did_spd && fe->param.spd_limit) {
 			link->hw_sata_spd_limit = (1 << fe->param.spd_limit) - 1;
-			ata_link_printk(link, KERN_NOTICE,
-					"FORCE: PHY spd limit set to %s\n",
+			ata_link_notice(link, "FORCE: PHY spd limit set to %s\n",
 					fe->param.name);
 			did_spd = true;
 		}
@@ -387,7 +385,7 @@ static void ata_force_link_limits(struct ata_link *link)
 		/* let lflags stack */
 		if (fe->param.lflags) {
 			link->flags |= fe->param.lflags;
-			ata_link_printk(link, KERN_NOTICE,
+			ata_link_notice(link,
 					"FORCE: link flag 0x%x forced -> 0x%x\n",
 					fe->param.lflags, link->flags);
 		}
@@ -442,8 +440,8 @@ static void ata_force_xfermask(struct ata_device *dev)
 			dev->pio_mask = pio_mask;
 		}
 
-		ata_dev_printk(dev, KERN_NOTICE,
-			"FORCE: xfer_mask set to %s\n", fe->param.name);
+		ata_dev_notice(dev, "FORCE: xfer_mask set to %s\n",
+			       fe->param.name);
 		return;
 	}
 }
@@ -486,8 +484,8 @@ static void ata_force_horkage(struct ata_device *dev)
 		dev->horkage |= fe->param.horkage_on;
 		dev->horkage &= ~fe->param.horkage_off;
 
-		ata_dev_printk(dev, KERN_NOTICE,
-			"FORCE: horkage modified (%s)\n", fe->param.name);
+		ata_dev_notice(dev, "FORCE: horkage modified (%s)\n",
+			       fe->param.name);
 	}
 }
 
@@ -711,8 +709,8 @@ u64 ata_tf_read_block(struct ata_taskfile *tf, struct ata_device *dev)
 		sect = tf->lbal;
 
 		if (!sect) {
-			ata_dev_printk(dev, KERN_WARNING, "device reported "
-				       "invalid CHS sector 0\n");
+			ata_dev_warn(dev,
+				     "device reported invalid CHS sector 0\n");
 			sect = 1; /* oh well */
 		}
 
@@ -1230,8 +1228,9 @@ static int ata_read_native_max_address(struct ata_device *dev, u64 *max_sectors)
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
 	if (err_mask) {
-		ata_dev_printk(dev, KERN_WARNING, "failed to read native "
-			       "max address (err_mask=0x%x)\n", err_mask);
+		ata_dev_warn(dev,
+			     "failed to read native max address (err_mask=0x%x)\n",
+			     err_mask);
 		if (err_mask == AC_ERR_DEV && (tf.feature & ATA_ABORTED))
 			return -EACCES;
 		return -EIO;
@@ -1292,8 +1291,9 @@ static int ata_set_max_sectors(struct ata_device *dev, u64 new_sectors)
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
 	if (err_mask) {
-		ata_dev_printk(dev, KERN_WARNING, "failed to set "
-			       "max address (err_mask=0x%x)\n", err_mask);
+		ata_dev_warn(dev,
+			     "failed to set max address (err_mask=0x%x)\n",
+			     err_mask);
 		if (err_mask == AC_ERR_DEV &&
 		    (tf.feature & (ATA_ABORTED | ATA_IDNF)))
 			return -EACCES;
@@ -1336,8 +1336,8 @@ static int ata_hpa_resize(struct ata_device *dev)
 		 * be unlocked, skip HPA resizing.
 		 */
 		if (rc == -EACCES || !unlock_hpa) {
-			ata_dev_printk(dev, KERN_WARNING, "HPA support seems "
-				       "broken, skipping HPA handling\n");
+			ata_dev_warn(dev,
+				     "HPA support seems broken, skipping HPA handling\n");
 			dev->horkage |= ATA_HORKAGE_BROKEN_HPA;
 
 			/* we can continue if device aborted the command */
@@ -1355,14 +1355,13 @@ static int ata_hpa_resize(struct ata_device *dev)
 			return 0;
 
 		if (native_sectors > sectors)
-			ata_dev_printk(dev, KERN_INFO,
+			ata_dev_info(dev,
 				"HPA detected: current %llu, native %llu\n",
 				(unsigned long long)sectors,
 				(unsigned long long)native_sectors);
 		else if (native_sectors < sectors)
-			ata_dev_printk(dev, KERN_WARNING,
-				"native sectors (%llu) is smaller than "
-				"sectors (%llu)\n",
+			ata_dev_warn(dev,
+				"native sectors (%llu) is smaller than sectors (%llu)\n",
 				(unsigned long long)native_sectors,
 				(unsigned long long)sectors);
 		return 0;
@@ -1372,10 +1371,10 @@ static int ata_hpa_resize(struct ata_device *dev)
 	rc = ata_set_max_sectors(dev, native_sectors);
 	if (rc == -EACCES) {
 		/* if device aborted the command, skip HPA resizing */
-		ata_dev_printk(dev, KERN_WARNING, "device aborted resize "
-			       "(%llu -> %llu), skipping HPA handling\n",
-			       (unsigned long long)sectors,
-			       (unsigned long long)native_sectors);
+		ata_dev_warn(dev,
+			     "device aborted resize (%llu -> %llu), skipping HPA handling\n",
+			     (unsigned long long)sectors,
+			     (unsigned long long)native_sectors);
 		dev->horkage |= ATA_HORKAGE_BROKEN_HPA;
 		return 0;
 	} else if (rc)
@@ -1384,14 +1383,14 @@ static int ata_hpa_resize(struct ata_device *dev)
 	/* re-read IDENTIFY data */
 	rc = ata_dev_reread_id(dev, 0);
 	if (rc) {
-		ata_dev_printk(dev, KERN_ERR, "failed to re-read IDENTIFY "
-			       "data after HPA resizing\n");
+		ata_dev_err(dev,
+			    "failed to re-read IDENTIFY data after HPA resizing\n");
 		return rc;
 	}
 
 	if (print_info) {
 		u64 new_sectors = ata_id_n_sectors(dev->id);
-		ata_dev_printk(dev, KERN_INFO,
+		ata_dev_info(dev,
 			"HPA unlocked: %llu -> %llu, native %llu\n",
 			(unsigned long long)sectors,
 			(unsigned long long)new_sectors,
@@ -1655,8 +1654,8 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 				ata_qc_complete(qc);
 
 			if (ata_msg_warn(ap))
-				ata_dev_printk(dev, KERN_WARNING,
-					"qc timeout (cmd 0x%x)\n", command);
+				ata_dev_warn(dev, "qc timeout (cmd 0x%x)\n",
+					     command);
 		}
 
 		spin_unlock_irqrestore(ap->lock, flags);
@@ -1870,7 +1869,7 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 	int rc;
 
 	if (ata_msg_ctl(ap))
-		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER\n", __func__);
+		ata_dev_dbg(dev, "%s: ENTER\n", __func__);
 
 retry:
 	ata_tf_init(dev, &tf);
@@ -1909,14 +1908,13 @@ retry:
 
 	if (err_mask) {
 		if (err_mask & AC_ERR_NODEV_HINT) {
-			ata_dev_printk(dev, KERN_DEBUG,
-				       "NODEV after polling detection\n");
+			ata_dev_dbg(dev, "NODEV after polling detection\n");
 			return -ENOENT;
 		}
 
 		if (is_semb) {
-			ata_dev_printk(dev, KERN_INFO, "IDENTIFY failed on "
-				       "device w/ SEMB sig, disabled\n");
+			ata_dev_info(dev,
+		     "IDENTIFY failed on device w/ SEMB sig, disabled\n");
 			/* SEMB is not supported yet */
 			*p_class = ATA_DEV_SEMB_UNSUP;
 			return 0;
@@ -1942,8 +1940,8 @@ retry:
 			 * both flavors of IDENTIFYs which happens
 			 * sometimes with phantom devices.
 			 */
-			ata_dev_printk(dev, KERN_DEBUG,
-				       "both IDENTIFYs aborted, assuming NODEV\n");
+			ata_dev_dbg(dev,
+				    "both IDENTIFYs aborted, assuming NODEV\n");
 			return -ENOENT;
 		}
 
@@ -1953,9 +1951,9 @@ retry:
 	}
 
 	if (dev->horkage & ATA_HORKAGE_DUMP_ID) {
-		ata_dev_printk(dev, KERN_DEBUG, "dumping IDENTIFY data, "
-			       "class=%d may_fallback=%d tried_spinup=%d\n",
-			       class, may_fallback, tried_spinup);
+		ata_dev_dbg(dev, "dumping IDENTIFY data, "
+			    "class=%d may_fallback=%d tried_spinup=%d\n",
+			    class, may_fallback, tried_spinup);
 		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET,
 			       16, 2, id, ATA_ID_WORDS * sizeof(*id), true);
 	}
@@ -2034,8 +2032,8 @@ retry:
 
  err_out:
 	if (ata_msg_warn(ap))
-		ata_dev_printk(dev, KERN_WARNING, "failed to IDENTIFY "
-			       "(%s, err_mask=0x%x)\n", reason, err_mask);
+		ata_dev_warn(dev, "failed to IDENTIFY (%s, err_mask=0x%x)\n",
+			     reason, err_mask);
 	return rc;
 }
 
@@ -2065,9 +2063,8 @@ static int ata_do_link_spd_horkage(struct ata_device *dev)
 	 * guaranteed by setting sata_spd_limit to target_limit above.
 	 */
 	if (plink->sata_spd > target) {
-		ata_dev_printk(dev, KERN_INFO,
-			       "applying link speed limit horkage to %s\n",
-			       sata_spd_string(target));
+		ata_dev_info(dev, "applying link speed limit horkage to %s\n",
+			     sata_spd_string(target));
 		return -EAGAIN;
 	}
 	return 0;
@@ -2110,8 +2107,9 @@ static int ata_dev_config_ncq(struct ata_device *dev,
 		err_mask = ata_dev_set_feature(dev, SETFEATURES_SATA_ENABLE,
 			SATA_FPDMA_AA);
 		if (err_mask) {
-			ata_dev_printk(dev, KERN_ERR, "failed to enable AA"
-				"(error_mask=0x%x)\n", err_mask);
+			ata_dev_err(dev,
+				    "failed to enable AA (error_mask=0x%x)\n",
+				    err_mask);
 			if (err_mask != AC_ERR_DEV) {
 				dev->horkage |= ATA_HORKAGE_BROKEN_FPDMA_AA;
 				return -EIO;
@@ -2154,31 +2152,28 @@ int ata_dev_configure(struct ata_device *dev)
 	int rc;
 
 	if (!ata_dev_enabled(dev) && ata_msg_info(ap)) {
-		ata_dev_printk(dev, KERN_INFO, "%s: ENTER/EXIT -- nodev\n",
-			       __func__);
+		ata_dev_info(dev, "%s: ENTER/EXIT -- nodev\n", __func__);
 		return 0;
 	}
 
 	if (ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER\n", __func__);
+		ata_dev_dbg(dev, "%s: ENTER\n", __func__);
 
 	/* set horkage */
 	dev->horkage |= ata_dev_blacklisted(dev);
 	ata_force_horkage(dev);
 
 	if (dev->horkage & ATA_HORKAGE_DISABLE) {
-		ata_dev_printk(dev, KERN_INFO,
-			       "unsupported device, disabling\n");
+		ata_dev_info(dev, "unsupported device, disabling\n");
 		ata_dev_disable(dev);
 		return 0;
 	}
 
 	if ((!atapi_enabled || (ap->flags & ATA_FLAG_NO_ATAPI)) &&
 	    dev->class == ATA_DEV_ATAPI) {
-		ata_dev_printk(dev, KERN_WARNING,
-			"WARNING: ATAPI is %s, device ignored.\n",
-			atapi_enabled ? "not supported with this driver"
-				      : "disabled");
+		ata_dev_warn(dev, "WARNING: ATAPI is %s, device ignored\n",
+			     atapi_enabled ? "not supported with this driver"
+			     : "disabled");
 		ata_dev_disable(dev);
 		return 0;
 	}
@@ -2199,12 +2194,12 @@ int ata_dev_configure(struct ata_device *dev)
 
 	/* print device capabilities */
 	if (ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_DEBUG,
-			       "%s: cfg 49:%04x 82:%04x 83:%04x 84:%04x "
-			       "85:%04x 86:%04x 87:%04x 88:%04x\n",
-			       __func__,
-			       id[49], id[82], id[83], id[84],
-			       id[85], id[86], id[87], id[88]);
+		ata_dev_dbg(dev,
+			    "%s: cfg 49:%04x 82:%04x 83:%04x 84:%04x "
+			    "85:%04x 86:%04x 87:%04x 88:%04x\n",
+			    __func__,
+			    id[49], id[82], id[83], id[84],
+			    id[85], id[86], id[87], id[88]);
 
 	/* initialize to-be-configured parameters */
 	dev->flags &= ~ATA_DFLAG_CFG_MASK;
@@ -2238,17 +2233,15 @@ int ata_dev_configure(struct ata_device *dev)
 		if (ata_id_is_cfa(id)) {
 			/* CPRM may make this media unusable */
 			if (id[ATA_ID_CFA_KEY_MGMT] & 1)
-				ata_dev_printk(dev, KERN_WARNING,
-					       "supports DRM functions and may "
-					       "not be fully accessible.\n");
+				ata_dev_warn(dev,
+	"supports DRM functions and may not be fully accessible\n");
 			snprintf(revbuf, 7, "CFA");
 		} else {
 			snprintf(revbuf, 7, "ATA-%d", ata_id_major_version(id));
 			/* Warn the user if the device has TPM extensions */
 			if (ata_id_has_tpm(id))
-				ata_dev_printk(dev, KERN_WARNING,
-					       "supports DRM functions and may "
-					       "not be fully accessible.\n");
+				ata_dev_warn(dev,
+	"supports DRM functions and may not be fully accessible\n");
 		}
 
 		dev->n_sectors = ata_id_n_sectors(id);
@@ -2285,12 +2278,11 @@ int ata_dev_configure(struct ata_device *dev)
 
 			/* print device info to dmesg */
 			if (ata_msg_drv(ap) && print_info) {
-				ata_dev_printk(dev, KERN_INFO,
-					"%s: %s, %s, max %s\n",
-					revbuf, modelbuf, fwrevbuf,
-					ata_mode_string(xfer_mask));
-				ata_dev_printk(dev, KERN_INFO,
-					"%Lu sectors, multi %u: %s %s\n",
+				ata_dev_info(dev, "%s: %s, %s, max %s\n",
+					     revbuf, modelbuf, fwrevbuf,
+					     ata_mode_string(xfer_mask));
+				ata_dev_info(dev,
+					     "%llu sectors, multi %u: %s %s\n",
 					(unsigned long long)dev->n_sectors,
 					dev->multi_count, lba_desc, ncq_desc);
 			}
@@ -2311,15 +2303,14 @@ int ata_dev_configure(struct ata_device *dev)
 
 			/* print device info to dmesg */
 			if (ata_msg_drv(ap) && print_info) {
-				ata_dev_printk(dev, KERN_INFO,
-					"%s: %s, %s, max %s\n",
-					revbuf,	modelbuf, fwrevbuf,
-					ata_mode_string(xfer_mask));
-				ata_dev_printk(dev, KERN_INFO,
-					"%Lu sectors, multi %u, CHS %u/%u/%u\n",
-					(unsigned long long)dev->n_sectors,
-					dev->multi_count, dev->cylinders,
-					dev->heads, dev->sectors);
+				ata_dev_info(dev, "%s: %s, %s, max %s\n",
+					     revbuf,	modelbuf, fwrevbuf,
+					     ata_mode_string(xfer_mask));
+				ata_dev_info(dev,
+					     "%llu sectors, multi %u, CHS %u/%u/%u\n",
+					     (unsigned long long)dev->n_sectors,
+					     dev->multi_count, dev->cylinders,
+					     dev->heads, dev->sectors);
 			}
 		}
 
@@ -2336,8 +2327,7 @@ int ata_dev_configure(struct ata_device *dev)
 		rc = atapi_cdb_len(id);
 		if ((rc < 12) || (rc > ATAPI_CDB_LEN)) {
 			if (ata_msg_warn(ap))
-				ata_dev_printk(dev, KERN_WARNING,
-					       "unsupported CDB len\n");
+				ata_dev_warn(dev, "unsupported CDB len\n");
 			rc = -EINVAL;
 			goto err_out_nosup;
 		}
@@ -2358,9 +2348,9 @@ int ata_dev_configure(struct ata_device *dev)
 			err_mask = ata_dev_set_feature(dev,
 					SETFEATURES_SATA_ENABLE, SATA_AN);
 			if (err_mask)
-				ata_dev_printk(dev, KERN_ERR,
-					"failed to enable ATAPI AN "
-					"(err_mask=0x%x)\n", err_mask);
+				ata_dev_err(dev,
+					    "failed to enable ATAPI AN (err_mask=0x%x)\n",
+					    err_mask);
 			else {
 				dev->flags |= ATA_DFLAG_AN;
 				atapi_an_string = ", ATAPI AN";
@@ -2379,12 +2369,12 @@ int ata_dev_configure(struct ata_device *dev)
 
 		/* print device info to dmesg */
 		if (ata_msg_drv(ap) && print_info)
-			ata_dev_printk(dev, KERN_INFO,
-				       "ATAPI: %s, %s, max %s%s%s%s\n",
-				       modelbuf, fwrevbuf,
-				       ata_mode_string(xfer_mask),
-				       cdb_intr_string, atapi_an_string,
-				       dma_dir_string);
+			ata_dev_info(dev,
+				     "ATAPI: %s, %s, max %s%s%s%s\n",
+				     modelbuf, fwrevbuf,
+				     ata_mode_string(xfer_mask),
+				     cdb_intr_string, atapi_an_string,
+				     dma_dir_string);
 	}
 
 	/* determine max_sectors */
@@ -2396,8 +2386,7 @@ int ata_dev_configure(struct ata_device *dev)
 	   200 sectors */
 	if (ata_dev_knobble(dev)) {
 		if (ata_msg_drv(ap) && print_info)
-			ata_dev_printk(dev, KERN_INFO,
-				       "applying bridge limits\n");
+			ata_dev_info(dev, "applying bridge limits\n");
 		dev->udma_mask &= ATA_UDMA5;
 		dev->max_sectors = ATA_MAX_SECTORS;
 	}
@@ -2423,26 +2412,23 @@ int ata_dev_configure(struct ata_device *dev)
 		   bugs */
 
 		if (print_info) {
-			ata_dev_printk(dev, KERN_WARNING,
+			ata_dev_warn(dev,
 "Drive reports diagnostics failure. This may indicate a drive\n");
-			ata_dev_printk(dev, KERN_WARNING,
+			ata_dev_warn(dev,
 "fault or invalid emulation. Contact drive vendor for information.\n");
 		}
 	}
 
 	if ((dev->horkage & ATA_HORKAGE_FIRMWARE_WARN) && print_info) {
-		ata_dev_printk(dev, KERN_WARNING, "WARNING: device requires "
-			       "firmware update to be fully functional.\n");
-		ata_dev_printk(dev, KERN_WARNING, "         contact the vendor "
-			       "or visit http://ata.wiki.kernel.org.\n");
+		ata_dev_warn(dev, "WARNING: device requires firmware update to be fully functional\n");
+		ata_dev_warn(dev, "         contact the vendor or visit http://ata.wiki.kernel.org\n");
 	}
 
 	return 0;
 
 err_out_nosup:
 	if (ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_DEBUG,
-			       "%s: EXIT, err\n", __func__);
+		ata_dev_dbg(dev, "%s: EXIT, err\n", __func__);
 	return rc;
 }
 
@@ -2663,13 +2649,11 @@ static void sata_print_link_status(struct ata_link *link)
 
 	if (ata_phys_link_online(link)) {
 		tmp = (sstatus >> 4) & 0xf;
-		ata_link_printk(link, KERN_INFO,
-				"SATA link up %s (SStatus %X SControl %X)\n",
-				sata_spd_string(tmp), sstatus, scontrol);
+		ata_link_info(link, "SATA link up %s (SStatus %X SControl %X)\n",
+			      sata_spd_string(tmp), sstatus, scontrol);
 	} else {
-		ata_link_printk(link, KERN_INFO,
-				"SATA link down (SStatus %X SControl %X)\n",
-				sstatus, scontrol);
+		ata_link_info(link, "SATA link down (SStatus %X SControl %X)\n",
+			      sstatus, scontrol);
 	}
 }
 
@@ -2758,8 +2742,8 @@ int sata_down_spd_limit(struct ata_link *link, u32 spd_limit)
 
 	link->sata_spd_limit = mask;
 
-	ata_link_printk(link, KERN_WARNING, "limiting SATA link speed to %s\n",
-			sata_spd_string(fls(mask)));
+	ata_link_warn(link, "limiting SATA link speed to %s\n",
+		      sata_spd_string(fls(mask)));
 
 	return 0;
 }
@@ -3136,8 +3120,7 @@ int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel)
 			snprintf(buf, sizeof(buf), "%s",
 				 ata_mode_string(xfer_mask));
 
-		ata_dev_printk(dev, KERN_WARNING,
-			       "limiting speed to %s\n", buf);
+		ata_dev_warn(dev, "limiting speed to %s\n", buf);
 	}
 
 	ata_unpack_xfermask(xfer_mask, &dev->pio_mask, &dev->mwdma_mask,
@@ -3164,9 +3147,9 @@ static int ata_dev_set_mode(struct ata_device *dev)
 		dev_err_whine = " (SET_XFERMODE skipped)";
 	else {
 		if (nosetxfer)
-			ata_dev_printk(dev, KERN_WARNING,
-				       "NOSETXFER but PATA detected - can't "
-				       "skip SETXFER, might malfunction\n");
+			ata_dev_warn(dev,
+				     "NOSETXFER but PATA detected - can't "
+				     "skip SETXFER, might malfunction\n");
 		err_mask = ata_dev_set_xfermode(dev);
 	}
 
@@ -3216,15 +3199,14 @@ static int ata_dev_set_mode(struct ata_device *dev)
 	DPRINTK("xfer_shift=%u, xfer_mode=0x%x\n",
 		dev->xfer_shift, (int)dev->xfer_mode);
 
-	ata_dev_printk(dev, KERN_INFO, "configured for %s%s\n",
-		       ata_mode_string(ata_xfer_mode2mask(dev->xfer_mode)),
-		       dev_err_whine);
+	ata_dev_info(dev, "configured for %s%s\n",
+		     ata_mode_string(ata_xfer_mode2mask(dev->xfer_mode)),
+		     dev_err_whine);
 
 	return 0;
 
  fail:
-	ata_dev_printk(dev, KERN_ERR, "failed to set xfermode "
-		       "(err_mask=0x%x)\n", err_mask);
+	ata_dev_err(dev, "failed to set xfermode (err_mask=0x%x)\n", err_mask);
 	return -EIO;
 }
 
@@ -3286,7 +3268,7 @@ int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 	/* step 2: always set host PIO timings */
 	ata_for_each_dev(dev, link, ENABLED) {
 		if (dev->pio_mode == 0xff) {
-			ata_dev_printk(dev, KERN_WARNING, "no PIO support\n");
+			ata_dev_warn(dev, "no PIO support\n");
 			rc = -EINVAL;
 			goto out;
 		}
@@ -3404,7 +3386,7 @@ int ata_wait_ready(struct ata_link *link, unsigned long deadline,
 
 		if (!warned && time_after(now, start + 5 * HZ) &&
 		    (deadline - now > 3 * HZ)) {
-			ata_link_printk(link, KERN_WARNING,
+			ata_link_warn(link,
 				"link is slow to respond, please be patient "
 				"(ready=%d)\n", tmp);
 			warned = 1;
@@ -3552,16 +3534,14 @@ int sata_link_resume(struct ata_link *link, const unsigned long *params,
 	} while ((scontrol & 0xf0f) != 0x300 && --tries);
 
 	if ((scontrol & 0xf0f) != 0x300) {
-		ata_link_printk(link, KERN_ERR,
-				"failed to resume link (SControl %X)\n",
-				scontrol);
+		ata_link_err(link, "failed to resume link (SControl %X)\n",
+			     scontrol);
 		return 0;
 	}
 
 	if (tries < ATA_LINK_RESUME_TRIES)
-		ata_link_printk(link, KERN_WARNING,
-				"link resume succeeded after %d retries\n",
-				ATA_LINK_RESUME_TRIES - tries);
+		ata_link_warn(link, "link resume succeeded after %d retries\n",
+			      ATA_LINK_RESUME_TRIES - tries);
 
 	if ((rc = sata_link_debounce(link, params, deadline)))
 		return rc;
@@ -3672,8 +3652,9 @@ int ata_std_prereset(struct ata_link *link, unsigned long deadline)
 		rc = sata_link_resume(link, timing, deadline);
 		/* whine about phy resume failure but proceed */
 		if (rc && rc != -EOPNOTSUPP)
-			ata_link_printk(link, KERN_WARNING, "failed to resume "
-					"link for reset (errno=%d)\n", rc);
+			ata_link_warn(link,
+				      "failed to resume link for reset (errno=%d)\n",
+				      rc);
 	}
 
 	/* no point in trying softreset on offline link */
@@ -3789,8 +3770,7 @@ int sata_link_hardreset(struct ata_link *link, const unsigned long *timing,
 		/* online is set iff link is online && reset succeeded */
 		if (online)
 			*online = false;
-		ata_link_printk(link, KERN_ERR,
-				"COMRESET failed (errno=%d)\n", rc);
+		ata_link_err(link, "COMRESET failed (errno=%d)\n", rc);
 	}
 	DPRINTK("EXIT, rc=%d\n", rc);
 	return rc;
@@ -3874,8 +3854,8 @@ static int ata_dev_same_device(struct ata_device *dev, unsigned int new_class,
 	unsigned char serial[2][ATA_ID_SERNO_LEN + 1];
 
 	if (dev->class != new_class) {
-		ata_dev_printk(dev, KERN_INFO, "class mismatch %d != %d\n",
-			       dev->class, new_class);
+		ata_dev_info(dev, "class mismatch %d != %d\n",
+			     dev->class, new_class);
 		return 0;
 	}
 
@@ -3885,14 +3865,14 @@ static int ata_dev_same_device(struct ata_device *dev, unsigned int new_class,
 	ata_id_c_string(new_id, serial[1], ATA_ID_SERNO, sizeof(serial[1]));
 
 	if (strcmp(model[0], model[1])) {
-		ata_dev_printk(dev, KERN_INFO, "model number mismatch "
-			       "'%s' != '%s'\n", model[0], model[1]);
+		ata_dev_info(dev, "model number mismatch '%s' != '%s'\n",
+			     model[0], model[1]);
 		return 0;
 	}
 
 	if (strcmp(serial[0], serial[1])) {
-		ata_dev_printk(dev, KERN_INFO, "serial number mismatch "
-			       "'%s' != '%s'\n", serial[0], serial[1]);
+		ata_dev_info(dev, "serial number mismatch '%s' != '%s'\n",
+			     serial[0], serial[1]);
 		return 0;
 	}
 
@@ -3962,8 +3942,8 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 	    new_class != ATA_DEV_ATA &&
 	    new_class != ATA_DEV_ATAPI &&
 	    new_class != ATA_DEV_SEMB) {
-		ata_dev_printk(dev, KERN_INFO, "class mismatch %u != %u\n",
-			       dev->class, new_class);
+		ata_dev_info(dev, "class mismatch %u != %u\n",
+			     dev->class, new_class);
 		rc = -ENODEV;
 		goto fail;
 	}
@@ -3984,9 +3964,9 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 		return 0;
 
 	/* n_sectors has changed */
-	ata_dev_printk(dev, KERN_WARNING, "n_sectors mismatch %llu != %llu\n",
-		       (unsigned long long)n_sectors,
-		       (unsigned long long)dev->n_sectors);
+	ata_dev_warn(dev, "n_sectors mismatch %llu != %llu\n",
+		     (unsigned long long)n_sectors,
+		     (unsigned long long)dev->n_sectors);
 
 	/*
 	 * Something could have caused HPA to be unlocked
@@ -3995,9 +3975,9 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 	 */
 	if (dev->n_native_sectors == n_native_sectors &&
 	    dev->n_sectors > n_sectors && dev->n_sectors == n_native_sectors) {
-		ata_dev_printk(dev, KERN_WARNING,
-			       "new n_sectors matches native, probably "
-			       "late HPA unlock, n_sectors updated\n");
+		ata_dev_warn(dev,
+			     "new n_sectors matches native, probably "
+			     "late HPA unlock, n_sectors updated\n");
 		/* use the larger n_sectors */
 		return 0;
 	}
@@ -4011,9 +3991,9 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 	if (dev->n_native_sectors == n_native_sectors &&
 	    dev->n_sectors < n_sectors && n_sectors == n_native_sectors &&
 	    !(dev->horkage & ATA_HORKAGE_BROKEN_HPA)) {
-		ata_dev_printk(dev, KERN_WARNING,
-			       "old n_sectors matches native, probably "
-			       "late HPA lock, will try to unlock HPA\n");
+		ata_dev_warn(dev,
+			     "old n_sectors matches native, probably "
+			     "late HPA lock, will try to unlock HPA\n");
 		/* try unlocking HPA */
 		dev->flags |= ATA_DFLAG_UNLOCK_HPA;
 		rc = -EIO;
@@ -4024,7 +4004,7 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 	dev->n_native_sectors = n_native_sectors;
 	dev->n_sectors = n_sectors;
  fail:
-	ata_dev_printk(dev, KERN_ERR, "revalidation failed (errno=%d)\n", rc);
+	ata_dev_err(dev, "revalidation failed (errno=%d)\n", rc);
 	return rc;
 }
 
@@ -4351,15 +4331,15 @@ static void ata_dev_xfermask(struct ata_device *dev)
 
 	if (ata_dma_blacklisted(dev)) {
 		xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
-		ata_dev_printk(dev, KERN_WARNING,
-			       "device is on DMA blacklist, disabling DMA\n");
+		ata_dev_warn(dev,
+			     "device is on DMA blacklist, disabling DMA\n");
 	}
 
 	if ((host->flags & ATA_HOST_SIMPLEX) &&
 	    host->simplex_claimed && host->simplex_claimed != ap) {
 		xfer_mask &= ~(ATA_MASK_MWDMA | ATA_MASK_UDMA);
-		ata_dev_printk(dev, KERN_WARNING, "simplex DMA is claimed by "
-			       "other device, disabling DMA\n");
+		ata_dev_warn(dev,
+			     "simplex DMA is claimed by other device, disabling DMA\n");
 	}
 
 	if (ap->flags & ATA_FLAG_NO_IORDY)
@@ -4379,8 +4359,8 @@ static void ata_dev_xfermask(struct ata_device *dev)
 	if (xfer_mask & (0xF8 << ATA_SHIFT_UDMA))
 		/* UDMA/44 or higher would be available */
 		if (cable_is_40wire(ap)) {
-			ata_dev_printk(dev, KERN_WARNING,
-				 "limited to UDMA/33 due to 40-wire cable\n");
+			ata_dev_warn(dev,
+				     "limited to UDMA/33 due to 40-wire cable\n");
 			xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);
 		}
 
@@ -4947,8 +4927,8 @@ int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active)
 	done_mask = ap->qc_active ^ qc_active;
 
 	if (unlikely(done_mask & qc_active)) {
-		ata_port_printk(ap, KERN_ERR, "illegal qc_active transition "
-				"(%08x->%08x)\n", ap->qc_active, qc_active);
+		ata_port_err(ap, "illegal qc_active transition (%08x->%08x)\n",
+			     ap->qc_active, qc_active);
 		return -EINVAL;
 	}
 
@@ -6015,14 +5995,13 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 					      ap->udma_mask);
 
 		if (!ata_port_is_dummy(ap)) {
-			ata_port_printk(ap, KERN_INFO,
-					"%cATA max %s %s\n",
-					(ap->flags & ATA_FLAG_SATA) ? 'S' : 'P',
-					ata_mode_string(xfer_mask),
-					ap->link.eh_info.desc);
+			ata_port_info(ap, "%cATA max %s %s\n",
+				      (ap->flags & ATA_FLAG_SATA) ? 'S' : 'P',
+				      ata_mode_string(xfer_mask),
+				      ap->link.eh_info.desc);
 			ata_ehi_clear_desc(&ap->link.eh_info);
 		} else
-			ata_port_printk(ap, KERN_INFO, "DUMMY\n");
+			ata_port_info(ap, "DUMMY\n");
 	}
 
 	/* perform each probe asynchronously */
@@ -6592,6 +6571,76 @@ const struct ata_port_info ata_dummy_port_info = {
 };
 
 /*
+ * Utility print functions
+ */
+int ata_port_printk(const struct ata_port *ap, const char *level,
+		    const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	r = printk("%sata%u: %pV", level, ap->print_id, &vaf);
+
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(ata_port_printk);
+
+int ata_link_printk(const struct ata_link *link, const char *level,
+		    const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	if (sata_pmp_attached(link->ap) || link->ap->slave_link)
+		r = printk("%sata%u.%02u: %pV",
+			   level, link->ap->print_id, link->pmp, &vaf);
+	else
+		r = printk("%sata%u: %pV",
+			   level, link->ap->print_id, &vaf);
+
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(ata_link_printk);
+
+int ata_dev_printk(const struct ata_device *dev, const char *level,
+		    const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	r = printk("%sata%u.%02u: %pV",
+		   level, dev->link->ap->print_id, dev->link->pmp + dev->devno,
+		   &vaf);
+
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(ata_dev_printk);
+
+/*
  * libata is essentially a library of internal helper functions for
  * low-level ATA host controller drivers.  As such, the API/ABI is
  * likely to change as new drivers are added and updated.
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 88cd22f..bff6bb0 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -782,8 +782,9 @@ void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap)
 				spin_unlock_irqrestore(ap->lock, flags);
 				goto repeat;
 			}
-			ata_port_printk(ap, KERN_ERR, "EH pending after %d "
-					"tries, giving up\n", ATA_EH_MAX_TRIES);
+			ata_port_err(ap,
+				     "EH pending after %d tries, giving up\n",
+				     ATA_EH_MAX_TRIES);
 			ap->pflags &= ~ATA_PFLAG_EH_PENDING;
 		}
 
@@ -816,7 +817,7 @@ void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap)
 		schedule_delayed_work(&ap->hotplug_task, 0);
 
 	if (ap->pflags & ATA_PFLAG_RECOVERED)
-		ata_port_printk(ap, KERN_INFO, "EH complete\n");
+		ata_port_info(ap, "EH complete\n");
 
 	ap->pflags &= ~(ATA_PFLAG_SCSI_HOTPLUG | ATA_PFLAG_RECOVERED);
 
@@ -1310,7 +1311,7 @@ void ata_dev_disable(struct ata_device *dev)
 		return;
 
 	if (ata_msg_drv(dev->link->ap))
-		ata_dev_printk(dev, KERN_WARNING, "disabled\n");
+		ata_dev_warn(dev, "disabled\n");
 	ata_acpi_on_disable(dev);
 	ata_down_xfermask_limit(dev, ATA_DNXFER_FORCE_PIO0 | ATA_DNXFER_QUIET);
 	dev->class++;
@@ -1515,8 +1516,8 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
 	for (i = 0; i < ATA_SECT_SIZE; i++)
 		csum += buf[i];
 	if (csum)
-		ata_dev_printk(dev, KERN_WARNING,
-			       "invalid checksum 0x%x on log page 10h\n", csum);
+		ata_dev_warn(dev, "invalid checksum 0x%x on log page 10h\n",
+			     csum);
 
 	if (buf[0] & 0x80)
 		return -ENOENT;
@@ -1716,14 +1717,14 @@ void ata_eh_analyze_ncq_error(struct ata_link *link)
 	memset(&tf, 0, sizeof(tf));
 	rc = ata_eh_read_log_10h(dev, &tag, &tf);
 	if (rc) {
-		ata_link_printk(link, KERN_ERR, "failed to read log page 10h "
-				"(errno=%d)\n", rc);
+		ata_link_err(link, "failed to read log page 10h (errno=%d)\n",
+			     rc);
 		return;
 	}
 
 	if (!(link->sactive & (1 << tag))) {
-		ata_link_printk(link, KERN_ERR, "log page 10h reported "
-				"inactive tag %d\n", tag);
+		ata_link_err(link, "log page 10h reported inactive tag %d\n",
+			     tag);
 		return;
 	}
 
@@ -1988,8 +1989,7 @@ static unsigned int ata_eh_speed_down(struct ata_device *dev,
 	    (dev->flags & (ATA_DFLAG_PIO | ATA_DFLAG_NCQ |
 			   ATA_DFLAG_NCQ_OFF)) == ATA_DFLAG_NCQ) {
 		dev->flags |= ATA_DFLAG_NCQ_OFF;
-		ata_dev_printk(dev, KERN_WARNING,
-			       "NCQ disabled due to excessive errors\n");
+		ata_dev_warn(dev, "NCQ disabled due to excessive errors\n");
 		goto done;
 	}
 
@@ -2374,24 +2374,24 @@ static void ata_eh_link_report(struct ata_link *link)
 			 ap->eh_tries);
 
 	if (ehc->i.dev) {
-		ata_dev_printk(ehc->i.dev, KERN_ERR, "exception Emask 0x%x "
-			       "SAct 0x%x SErr 0x%x action 0x%x%s%s\n",
-			       ehc->i.err_mask, link->sactive, ehc->i.serror,
-			       ehc->i.action, frozen, tries_buf);
+		ata_dev_err(ehc->i.dev, "exception Emask 0x%x "
+			    "SAct 0x%x SErr 0x%x action 0x%x%s%s\n",
+			    ehc->i.err_mask, link->sactive, ehc->i.serror,
+			    ehc->i.action, frozen, tries_buf);
 		if (desc)
-			ata_dev_printk(ehc->i.dev, KERN_ERR, "%s\n", desc);
+			ata_dev_err(ehc->i.dev, "%s\n", desc);
 	} else {
-		ata_link_printk(link, KERN_ERR, "exception Emask 0x%x "
-				"SAct 0x%x SErr 0x%x action 0x%x%s%s\n",
-				ehc->i.err_mask, link->sactive, ehc->i.serror,
-				ehc->i.action, frozen, tries_buf);
+		ata_link_err(link, "exception Emask 0x%x "
+			     "SAct 0x%x SErr 0x%x action 0x%x%s%s\n",
+			     ehc->i.err_mask, link->sactive, ehc->i.serror,
+			     ehc->i.action, frozen, tries_buf);
 		if (desc)
-			ata_link_printk(link, KERN_ERR, "%s\n", desc);
+			ata_link_err(link, "%s\n", desc);
 	}
 
 #ifdef CONFIG_ATA_VERBOSE_ERROR
 	if (ehc->i.serror)
-		ata_link_printk(link, KERN_ERR,
+		ata_link_err(link,
 		  "SError: { %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s}\n",
 		  ehc->i.serror & SERR_DATA_RECOVERED ? "RecovData " : "",
 		  ehc->i.serror & SERR_COMM_RECOVERED ? "RecovComm " : "",
@@ -2456,11 +2456,11 @@ static void ata_eh_link_report(struct ata_link *link)
 		} else {
 			const char *descr = ata_get_cmd_descript(cmd->command);
 			if (descr)
-				ata_dev_printk(qc->dev, KERN_ERR,
-					"failed command: %s\n", descr);
+				ata_dev_err(qc->dev, "failed command: %s\n",
+					    descr);
 		}
 
-		ata_dev_printk(qc->dev, KERN_ERR,
+		ata_dev_err(qc->dev,
 			"cmd %02x/%02x:%02x:%02x:%02x:%02x/%02x:%02x:%02x:%02x:%02x/%02x "
 			"tag %d%s\n         %s"
 			"res %02x/%02x:%02x:%02x:%02x:%02x/%02x:%02x:%02x:%02x:%02x/%02x "
@@ -2481,11 +2481,9 @@ static void ata_eh_link_report(struct ata_link *link)
 		if (res->command & (ATA_BUSY | ATA_DRDY | ATA_DF | ATA_DRQ |
 				    ATA_ERR)) {
 			if (res->command & ATA_BUSY)
-				ata_dev_printk(qc->dev, KERN_ERR,
-				  "status: { Busy }\n");
+				ata_dev_err(qc->dev, "status: { Busy }\n");
 			else
-				ata_dev_printk(qc->dev, KERN_ERR,
-				  "status: { %s%s%s%s}\n",
+				ata_dev_err(qc->dev, "status: { %s%s%s%s}\n",
 				  res->command & ATA_DRDY ? "DRDY " : "",
 				  res->command & ATA_DF ? "DF " : "",
 				  res->command & ATA_DRQ ? "DRQ " : "",
@@ -2495,8 +2493,7 @@ static void ata_eh_link_report(struct ata_link *link)
 		if (cmd->command != ATA_CMD_PACKET &&
 		    (res->feature & (ATA_ICRC | ATA_UNC | ATA_IDNF |
 				     ATA_ABORTED)))
-			ata_dev_printk(qc->dev, KERN_ERR,
-			  "error: { %s%s%s%s}\n",
+			ata_dev_err(qc->dev, "error: { %s%s%s%s}\n",
 			  res->feature & ATA_ICRC ? "ICRC " : "",
 			  res->feature & ATA_UNC ? "UNC " : "",
 			  res->feature & ATA_IDNF ? "IDNF " : "",
@@ -2650,8 +2647,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 
 		if (rc) {
 			if (rc == -ENOENT) {
-				ata_link_printk(link, KERN_DEBUG,
-						"port disabled. ignoring.\n");
+				ata_link_dbg(link, "port disabled--ignoring\n");
 				ehc->i.action &= ~ATA_EH_RESET;
 
 				ata_for_each_dev(dev, link, ALL)
@@ -2659,8 +2655,9 @@ int ata_eh_reset(struct ata_link *link, int classify,
 
 				rc = 0;
 			} else
-				ata_link_printk(link, KERN_ERR,
-					"prereset failed (errno=%d)\n", rc);
+				ata_link_err(link,
+					     "prereset failed (errno=%d)\n",
+					     rc);
 			goto out;
 		}
 
@@ -2689,8 +2686,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
 
 	if (reset) {
 		if (verbose)
-			ata_link_printk(link, KERN_INFO, "%s resetting link\n",
-					reset == softreset ? "soft" : "hard");
+			ata_link_info(link, "%s resetting link\n",
+				      reset == softreset ? "soft" : "hard");
 
 		/* mark that this EH session started with reset */
 		ehc->last_reset = jiffies;
@@ -2710,8 +2707,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 			int tmp;
 
 			if (verbose)
-				ata_link_printk(slave, KERN_INFO,
-						"hard resetting link\n");
+				ata_link_info(slave, "hard resetting link\n");
 
 			ata_eh_about_to_do(slave, NULL, ATA_EH_RESET);
 			tmp = ata_do_reset(slave, reset, classes, deadline,
@@ -2734,9 +2730,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
 			reset = softreset;
 
 			if (!reset) {
-				ata_link_printk(link, KERN_ERR,
-						"follow-up softreset required "
-						"but no softreset available\n");
+				ata_link_err(link,
+	     "follow-up softreset required but no softreset available\n");
 				failed_link = link;
 				rc = -EINVAL;
 				goto fail;
@@ -2751,8 +2746,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		}
 	} else {
 		if (verbose)
-			ata_link_printk(link, KERN_INFO, "no reset method "
-					"available, skipping reset\n");
+			ata_link_info(link,
+	"no reset method available, skipping reset\n");
 		if (!(lflags & ATA_LFLAG_ASSUME_CLASS))
 			lflags |= ATA_LFLAG_ASSUME_ATA;
 	}
@@ -2826,36 +2821,35 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	ata_for_each_dev(dev, link, ALL) {
 		if (ata_phys_link_online(ata_dev_phys_link(dev))) {
 			if (classes[dev->devno] == ATA_DEV_UNKNOWN) {
-				ata_dev_printk(dev, KERN_DEBUG, "link online "
-					       "but device misclassifed\n");
+				ata_dev_dbg(dev, "link online but device misclassified\n");
 				classes[dev->devno] = ATA_DEV_NONE;
 				nr_unknown++;
 			}
 		} else if (ata_phys_link_offline(ata_dev_phys_link(dev))) {
 			if (ata_class_enabled(classes[dev->devno]))
-				ata_dev_printk(dev, KERN_DEBUG, "link offline, "
-					       "clearing class %d to NONE\n",
-					       classes[dev->devno]);
+				ata_dev_dbg(dev,
+					    "link offline, clearing class %d to NONE\n",
+					    classes[dev->devno]);
 			classes[dev->devno] = ATA_DEV_NONE;
 		} else if (classes[dev->devno] == ATA_DEV_UNKNOWN) {
-			ata_dev_printk(dev, KERN_DEBUG, "link status unknown, "
-				       "clearing UNKNOWN to NONE\n");
+			ata_dev_dbg(dev,
+				    "link status unknown, clearing UNKNOWN to NONE\n");
 			classes[dev->devno] = ATA_DEV_NONE;
 		}
 	}
 
 	if (classify && nr_unknown) {
 		if (try < max_tries) {
-			ata_link_printk(link, KERN_WARNING, "link online but "
-					"%d devices misclassified, retrying\n",
-					nr_unknown);
+			ata_link_warn(link,
+				      "link online but %d devices misclassified, retrying\n",
+				      nr_unknown);
 			failed_link = link;
 			rc = -EAGAIN;
 			goto fail;
 		}
-		ata_link_printk(link, KERN_WARNING,
-				"link online but %d devices misclassified, "
-				"device detection might fail\n", nr_unknown);
+		ata_link_warn(link,
+			      "link online but %d devices misclassified, "
+			      "device detection might fail\n", nr_unknown);
 	}
 
 	/* reset successful, schedule revalidation */
@@ -2892,7 +2886,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 	if (time_before(now, deadline)) {
 		unsigned long delta = deadline - now;
 
-		ata_link_printk(failed_link, KERN_WARNING,
+		ata_link_warn(failed_link,
 			"reset failed (errno=%d), retrying in %u secs\n",
 			rc, DIV_ROUND_UP(jiffies_to_msecs(delta), 1000));
 
@@ -2983,7 +2977,7 @@ static void ata_eh_park_issue_cmd(struct ata_device *dev, int park)
 	tf.protocol |= ATA_PROT_NODATA;
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
 	if (park && (err_mask || tf.lbal != 0xc4)) {
-		ata_dev_printk(dev, KERN_ERR, "head unload failed!\n");
+		ata_dev_err(dev, "head unload failed!\n");
 		ehc->unloaded_mask &= ~(1 << dev->devno);
 	}
 }
@@ -3194,8 +3188,9 @@ static int atapi_eh_clear_ua(struct ata_device *dev)
 
 		err_mask = atapi_eh_tur(dev, &sense_key);
 		if (err_mask != 0 && err_mask != AC_ERR_DEV) {
-			ata_dev_printk(dev, KERN_WARNING, "TEST_UNIT_READY "
-				"failed (err_mask=0x%x)\n", err_mask);
+			ata_dev_warn(dev,
+				     "TEST_UNIT_READY failed (err_mask=0x%x)\n",
+				     err_mask);
 			return -EIO;
 		}
 
@@ -3204,14 +3199,14 @@ static int atapi_eh_clear_ua(struct ata_device *dev)
 
 		err_mask = atapi_eh_request_sense(dev, sense_buffer, sense_key);
 		if (err_mask) {
-			ata_dev_printk(dev, KERN_WARNING, "failed to clear "
+			ata_dev_warn(dev, "failed to clear "
 				"UNIT ATTENTION (err_mask=0x%x)\n", err_mask);
 			return -EIO;
 		}
 	}
 
-	ata_dev_printk(dev, KERN_WARNING,
-		"UNIT ATTENTION persists after %d tries\n", ATA_EH_UA_TRIES);
+	ata_dev_warn(dev, "UNIT ATTENTION persists after %d tries\n",
+		     ATA_EH_UA_TRIES);
 
 	return 0;
 }
@@ -3262,7 +3257,7 @@ static int ata_eh_maybe_retry_flush(struct ata_device *dev)
 	tf.flags |= ATA_TFLAG_DEVICE;
 	tf.protocol = ATA_PROT_NODATA;
 
-	ata_dev_printk(dev, KERN_WARNING, "retrying FLUSH 0x%x Emask 0x%x\n",
+	ata_dev_warn(dev, "retrying FLUSH 0x%x Emask 0x%x\n",
 		       tf.command, qc->err_mask);
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
@@ -3277,7 +3272,7 @@ static int ata_eh_maybe_retry_flush(struct ata_device *dev)
 		 */
 		qc->scsicmd->allowed = max(qc->scsicmd->allowed, 1);
 	} else {
-		ata_dev_printk(dev, KERN_WARNING, "FLUSH failed Emask 0x%x\n",
+		ata_dev_warn(dev, "FLUSH failed Emask 0x%x\n",
 			       err_mask);
 		rc = -EIO;
 
@@ -3350,9 +3345,9 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 			err_mask = ata_dev_set_feature(dev,
 					SETFEATURES_SATA_DISABLE, SATA_DIPM);
 			if (err_mask && err_mask != AC_ERR_DEV) {
-				ata_dev_printk(dev, KERN_WARNING,
-					"failed to disable DIPM, Emask 0x%x\n",
-					err_mask);
+				ata_dev_warn(dev,
+					     "failed to disable DIPM, Emask 0x%x\n",
+					     err_mask);
 				rc = -EIO;
 				goto fail;
 			}
@@ -3393,7 +3388,7 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 			err_mask = ata_dev_set_feature(dev,
 					SETFEATURES_SATA_ENABLE, SATA_DIPM);
 			if (err_mask && err_mask != AC_ERR_DEV) {
-				ata_dev_printk(dev, KERN_WARNING,
+				ata_dev_warn(dev,
 					"failed to enable DIPM, Emask 0x%x\n",
 					err_mask);
 				rc = -EIO;
@@ -3412,8 +3407,7 @@ fail:
 
 	/* if no device or only one more chance is left, disable LPM */
 	if (!dev || ehc->tries[dev->devno] <= 2) {
-		ata_link_printk(link, KERN_WARNING,
-				"disabling LPM on the link\n");
+		ata_link_warn(link, "disabling LPM on the link\n");
 		link->flags |= ATA_LFLAG_NO_LPM;
 	}
 	if (r_failed_dev)
@@ -3684,8 +3678,7 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		rc = ata_eh_reset(link, ata_link_nr_vacant(link),
 				  prereset, softreset, hardreset, postreset);
 		if (rc) {
-			ata_link_printk(link, KERN_ERR,
-					"reset failed, giving up\n");
+			ata_link_err(link, "reset failed, giving up\n");
 			goto out;
 		}
 	}
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index 3120596..9032a06 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -147,8 +147,8 @@ int sata_pmp_scr_read(struct ata_link *link, int reg, u32 *r_val)
 
 	err_mask = sata_pmp_read(link, reg, r_val);
 	if (err_mask) {
-		ata_link_printk(link, KERN_WARNING, "failed to read SCR %d "
-				"(Emask=0x%x)\n", reg, err_mask);
+		ata_link_warn(link, "failed to read SCR %d (Emask=0x%x)\n",
+			      reg, err_mask);
 		return -EIO;
 	}
 	return 0;
@@ -178,8 +178,8 @@ int sata_pmp_scr_write(struct ata_link *link, int reg, u32 val)
 
 	err_mask = sata_pmp_write(link, reg, val);
 	if (err_mask) {
-		ata_link_printk(link, KERN_WARNING, "failed to write SCR %d "
-				"(Emask=0x%x)\n", reg, err_mask);
+		ata_link_warn(link, "failed to write SCR %d (Emask=0x%x)\n",
+			      reg, err_mask);
 		return -EIO;
 	}
 	return 0;
@@ -231,8 +231,8 @@ static int sata_pmp_read_gscr(struct ata_device *dev, u32 *gscr)
 
 		err_mask = sata_pmp_read(dev->link, reg, &gscr[reg]);
 		if (err_mask) {
-			ata_dev_printk(dev, KERN_ERR, "failed to read PMP "
-				"GSCR[%d] (Emask=0x%x)\n", reg, err_mask);
+			ata_dev_err(dev, "failed to read PMP GSCR[%d] (Emask=0x%x)\n",
+				    reg, err_mask);
 			return -EIO;
 		}
 	}
@@ -311,26 +311,25 @@ static int sata_pmp_configure(struct ata_device *dev, int print_info)
 	}
 
 	if (print_info) {
-		ata_dev_printk(dev, KERN_INFO, "Port Multiplier %s, "
-			       "0x%04x:0x%04x r%d, %d ports, feat 0x%x/0x%x\n",
-			       sata_pmp_spec_rev_str(gscr), vendor, devid,
-			       sata_pmp_gscr_rev(gscr),
-			       nr_ports, gscr[SATA_PMP_GSCR_FEAT_EN],
-			       gscr[SATA_PMP_GSCR_FEAT]);
+		ata_dev_info(dev, "Port Multiplier %s, "
+			     "0x%04x:0x%04x r%d, %d ports, feat 0x%x/0x%x\n",
+			     sata_pmp_spec_rev_str(gscr), vendor, devid,
+			     sata_pmp_gscr_rev(gscr),
+			     nr_ports, gscr[SATA_PMP_GSCR_FEAT_EN],
+			     gscr[SATA_PMP_GSCR_FEAT]);
 
 		if (!(dev->flags & ATA_DFLAG_AN))
-			ata_dev_printk(dev, KERN_INFO,
+			ata_dev_info(dev,
 				"Asynchronous notification not supported, "
-				"hotplug won't\n         work on fan-out "
-				"ports. Use warm-plug instead.\n");
+				"hotplug won't work on fan-out ports. Use warm-plug instead.\n");
 	}
 
 	return 0;
 
  fail:
-	ata_dev_printk(dev, KERN_ERR,
-		       "failed to configure Port Multiplier (%s, Emask=0x%x)\n",
-		       reason, err_mask);
+	ata_dev_err(dev,
+		    "failed to configure Port Multiplier (%s, Emask=0x%x)\n",
+		    reason, err_mask);
 	return rc;
 }
 
@@ -475,20 +474,17 @@ int sata_pmp_attach(struct ata_device *dev)
 
 	/* is it hanging off the right place? */
 	if (!sata_pmp_supported(ap)) {
-		ata_dev_printk(dev, KERN_ERR,
-			       "host does not support Port Multiplier\n");
+		ata_dev_err(dev, "host does not support Port Multiplier\n");
 		return -EINVAL;
 	}
 
 	if (!ata_is_host_link(link)) {
-		ata_dev_printk(dev, KERN_ERR,
-			       "Port Multipliers cannot be nested\n");
+		ata_dev_err(dev, "Port Multipliers cannot be nested\n");
 		return -EINVAL;
 	}
 
 	if (dev->devno) {
-		ata_dev_printk(dev, KERN_ERR,
-			       "Port Multiplier must be the first device\n");
+		ata_dev_err(dev, "Port Multiplier must be the first device\n");
 		return -EINVAL;
 	}
 
@@ -507,8 +503,7 @@ int sata_pmp_attach(struct ata_device *dev)
 
 	rc = sata_pmp_init_links(ap, sata_pmp_gscr_ports(dev->gscr));
 	if (rc) {
-		ata_dev_printk(dev, KERN_INFO,
-			       "failed to initialize PMP links\n");
+		ata_dev_info(dev, "failed to initialize PMP links\n");
 		goto fail;
 	}
 
@@ -552,7 +547,7 @@ static void sata_pmp_detach(struct ata_device *dev)
 	struct ata_link *tlink;
 	unsigned long flags;
 
-	ata_dev_printk(dev, KERN_INFO, "Port Multiplier detaching\n");
+	ata_dev_info(dev, "Port Multiplier detaching\n");
 
 	WARN_ON(!ata_is_host_link(link) || dev->devno ||
 		link->pmp != SATA_PMP_CTRL_PORT);
@@ -599,23 +594,23 @@ static int sata_pmp_same_pmp(struct ata_device *dev, const u32 *new_gscr)
 	new_nr_ports = sata_pmp_gscr_ports(new_gscr);
 
 	if (old_vendor != new_vendor) {
-		ata_dev_printk(dev, KERN_INFO, "Port Multiplier "
-			       "vendor mismatch '0x%x' != '0x%x'\n",
-			       old_vendor, new_vendor);
+		ata_dev_info(dev,
+			     "Port Multiplier vendor mismatch '0x%x' != '0x%x'\n",
+			     old_vendor, new_vendor);
 		return 0;
 	}
 
 	if (old_devid != new_devid) {
-		ata_dev_printk(dev, KERN_INFO, "Port Multiplier "
-			       "device ID mismatch '0x%x' != '0x%x'\n",
-			       old_devid, new_devid);
+		ata_dev_info(dev,
+			     "Port Multiplier device ID mismatch '0x%x' != '0x%x'\n",
+			     old_devid, new_devid);
 		return 0;
 	}
 
 	if (old_nr_ports != new_nr_ports) {
-		ata_dev_printk(dev, KERN_INFO, "Port Multiplier "
-			       "nr_ports mismatch '0x%x' != '0x%x'\n",
-			       old_nr_ports, new_nr_ports);
+		ata_dev_info(dev,
+			     "Port Multiplier nr_ports mismatch '0x%x' != '0x%x'\n",
+			     old_nr_ports, new_nr_ports);
 		return 0;
 	}
 
@@ -681,8 +676,7 @@ static int sata_pmp_revalidate(struct ata_device *dev, unsigned int new_class)
 	return 0;
 
  fail:
-	ata_dev_printk(dev, KERN_ERR,
-		       "PMP revalidation failed (errno=%d)\n", rc);
+	ata_dev_err(dev, "PMP revalidation failed (errno=%d)\n", rc);
 	DPRINTK("EXIT, rc=%d\n", rc);
 	return rc;
 }
@@ -706,13 +700,14 @@ static int sata_pmp_revalidate_quick(struct ata_device *dev)
 
 	err_mask = sata_pmp_read(dev->link, SATA_PMP_GSCR_PROD_ID, &prod_id);
 	if (err_mask) {
-		ata_dev_printk(dev, KERN_ERR, "failed to read PMP product ID "
-			       "(Emask=0x%x)\n", err_mask);
+		ata_dev_err(dev,
+			    "failed to read PMP product ID (Emask=0x%x)\n",
+			    err_mask);
 		return -EIO;
 	}
 
 	if (prod_id != dev->gscr[SATA_PMP_GSCR_PROD_ID]) {
-		ata_dev_printk(dev, KERN_ERR, "PMP product ID mismatch\n");
+		ata_dev_err(dev, "PMP product ID mismatch\n");
 		/* something weird is going on, request full PMP recovery */
 		return -EIO;
 	}
@@ -767,8 +762,7 @@ static int sata_pmp_eh_recover_pmp(struct ata_port *ap,
 		rc = ata_eh_reset(link, 0, prereset, softreset, hardreset,
 				  postreset);
 		if (rc) {
-			ata_link_printk(link, KERN_ERR,
-					"failed to reset PMP, giving up\n");
+			ata_link_err(link, "failed to reset PMP, giving up\n");
 			goto fail;
 		}
 
@@ -809,9 +803,9 @@ static int sata_pmp_eh_recover_pmp(struct ata_port *ap,
 			ehc->i.action |= ATA_EH_RESET;
 			goto retry;
 		} else {
-			ata_dev_printk(dev, KERN_ERR, "failed to recover PMP "
-				       "after %d tries, giving up\n",
-				       ATA_EH_PMP_TRIES);
+			ata_dev_err(dev,
+				    "failed to recover PMP after %d tries, giving up\n",
+				    ATA_EH_PMP_TRIES);
 			goto fail;
 		}
 	}
@@ -857,8 +851,9 @@ static int sata_pmp_eh_handle_disabled_links(struct ata_port *ap)
 		/* unconditionally clear SError.N */
 		rc = sata_scr_write(link, SCR_ERROR, SERR_PHYRDY_CHG);
 		if (rc) {
-			ata_link_printk(link, KERN_ERR, "failed to clear "
-					"SError.N (errno=%d)\n", rc);
+			ata_link_err(link,
+				     "failed to clear SError.N (errno=%d)\n",
+				     rc);
 			return rc;
 		}
 
@@ -880,7 +875,7 @@ static int sata_pmp_handle_link_fail(struct ata_link *link, int *link_tries)
 
 	/* disable this link */
 	if (!(link->flags & ATA_LFLAG_DISABLED)) {
-		ata_link_printk(link, KERN_WARNING,
+		ata_link_warn(link,
 			"failed to recover link after %d tries, disabling\n",
 			ATA_EH_PMP_LINK_TRIES);
 
@@ -964,7 +959,7 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 		err_mask = sata_pmp_write(pmp_link, SATA_PMP_GSCR_FEAT_EN,
 					  gscr[SATA_PMP_GSCR_FEAT_EN]);
 		if (err_mask) {
-			ata_link_printk(pmp_link, KERN_WARNING,
+			ata_link_warn(pmp_link,
 				"failed to disable NOTIFY (err_mask=0x%x)\n",
 				err_mask);
 			goto pmp_fail;
@@ -1008,8 +1003,9 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 		err_mask = sata_pmp_write(pmp_link, SATA_PMP_GSCR_FEAT_EN,
 					  gscr[SATA_PMP_GSCR_FEAT_EN]);
 		if (err_mask) {
-			ata_dev_printk(pmp_dev, KERN_ERR, "failed to write "
-				       "PMP_FEAT_EN (Emask=0x%x)\n", err_mask);
+			ata_dev_err(pmp_dev,
+				    "failed to write PMP_FEAT_EN (Emask=0x%x)\n",
+				    err_mask);
 			rc = -EIO;
 			goto pmp_fail;
 		}
@@ -1018,8 +1014,9 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 	/* check GSCR_ERROR */
 	err_mask = sata_pmp_read(pmp_link, SATA_PMP_GSCR_ERROR, &gscr_error);
 	if (err_mask) {
-		ata_dev_printk(pmp_dev, KERN_ERR, "failed to read "
-			       "PMP_GSCR_ERROR (Emask=0x%x)\n", err_mask);
+		ata_dev_err(pmp_dev,
+			    "failed to read PMP_GSCR_ERROR (Emask=0x%x)\n",
+			    err_mask);
 		rc = -EIO;
 		goto pmp_fail;
 	}
@@ -1033,17 +1030,16 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 			ata_ehi_hotplugged(&link->eh_context.i);
 			cnt++;
 		} else {
-			ata_link_printk(link, KERN_WARNING,
-				"PHY status changed but maxed out on retries, "
-				"giving up\n");
-			ata_link_printk(link, KERN_WARNING,
-				"Manully issue scan to resume this link\n");
+			ata_link_warn(link,
+				"PHY status changed but maxed out on retries, giving up\n");
+			ata_link_warn(link,
+				"Manually issue scan to resume this link\n");
 		}
 	}
 
 	if (cnt) {
-		ata_port_printk(ap, KERN_INFO, "PMP SError.N set for some "
-				"ports, repeating recovery\n");
+		ata_port_info(ap,
+			"PMP SError.N set for some ports, repeating recovery\n");
 		goto retry;
 	}
 
@@ -1071,9 +1067,8 @@ static int sata_pmp_eh_recover(struct ata_port *ap)
 		goto retry;
 	}
 
-	ata_port_printk(ap, KERN_ERR,
-			"failed to recover PMP after %d tries, giving up\n",
-			ATA_EH_PMP_TRIES);
+	ata_port_err(ap, "failed to recover PMP after %d tries, giving up\n",
+		     ATA_EH_PMP_TRIES);
 	sata_pmp_detach(pmp_dev);
 	ata_dev_disable(pmp_dev);
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e2f57e9e..0a4f46e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1108,8 +1108,7 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 		/* configure draining */
 		buf = kmalloc(ATAPI_MAX_DRAIN, q->bounce_gfp | GFP_KERNEL);
 		if (!buf) {
-			ata_dev_printk(dev, KERN_ERR,
-				       "drain buffer allocation failed\n");
+			ata_dev_err(dev, "drain buffer allocation failed\n");
 			return -ENOMEM;
 		}
 
@@ -1127,7 +1126,7 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 	 * IDENTIFY_PACKET is executed as ATA_PROT_PIO.
 	 */
 	if (sdev->sector_size > PAGE_SIZE)
-		ata_dev_printk(dev, KERN_WARNING,
+		ata_dev_warn(dev,
 			"sector_size=%u > PAGE_SIZE, PIO may malfunction\n",
 			sdev->sector_size);
 
@@ -1783,8 +1782,7 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE ||
 	    cmd->sc_data_direction == DMA_TO_DEVICE) {
 		if (unlikely(scsi_bufflen(cmd) < 1)) {
-			ata_dev_printk(dev, KERN_WARNING,
-				       "WARNING: zero len r/w req\n");
+			ata_dev_warn(dev, "WARNING: zero len r/w req\n");
 			goto err_did;
 		}
 
@@ -2968,9 +2966,8 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 		 * with the cached multi_count of libata
 		 */
 		if (multi_count != dev->multi_count)
-			ata_dev_printk(dev, KERN_WARNING,
-				       "invalid multi_count %u ignored\n",
-				       multi_count);
+			ata_dev_warn(dev, "invalid multi_count %u ignored\n",
+				     multi_count);
 	}
 
 	/*
@@ -3465,9 +3462,8 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			goto repeat;
 		}
 
-		ata_port_printk(ap, KERN_ERR, "WARNING: synchronous SCSI scan "
-				"failed without making any progress,\n"
-				"                  switching to async\n");
+		ata_port_err(ap,
+			     "WARNING: synchronous SCSI scan failed without making any progress, switching to async\n");
 	}
 
 	queue_delayed_work(system_long_wq, &ap->hotplug_task,
@@ -3549,8 +3545,8 @@ static void ata_scsi_remove_dev(struct ata_device *dev)
 	mutex_unlock(&ap->scsi_host->scan_mutex);
 
 	if (sdev) {
-		ata_dev_printk(dev, KERN_INFO, "detaching (SCSI %s)\n",
-			       dev_name(&sdev->sdev_gendev));
+		ata_dev_info(dev, "detaching (SCSI %s)\n",
+			     dev_name(&sdev->sdev_gendev));
 
 		scsi_remove_device(sdev);
 		scsi_device_put(sdev);
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index a49f315..a2b0e3c 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -227,9 +227,9 @@ int ata_sff_busy_sleep(struct ata_port *ap,
 	}
 
 	if (status != 0xff && (status & ATA_BUSY))
-		ata_port_printk(ap, KERN_WARNING,
-				"port is slow to respond, please be patient "
-				"(Status 0x%x)\n", status);
+		ata_port_warn(ap,
+			      "port is slow to respond, please be patient (Status 0x%x)\n",
+			      status);
 
 	timeout = ata_deadline(timer_start, tmout);
 	while (status != 0xff && (status & ATA_BUSY) &&
@@ -242,9 +242,9 @@ int ata_sff_busy_sleep(struct ata_port *ap,
 		return -ENODEV;
 
 	if (status & ATA_BUSY) {
-		ata_port_printk(ap, KERN_ERR, "port failed to respond "
-				"(%lu secs, Status 0x%x)\n",
-				DIV_ROUND_UP(tmout, 1000), status);
+		ata_port_err(ap,
+			     "port failed to respond (%lu secs, Status 0x%x)\n",
+			     DIV_ROUND_UP(tmout, 1000), status);
 		return -EBUSY;
 	}
 
@@ -350,8 +350,8 @@ static void ata_dev_select(struct ata_port *ap, unsigned int device,
 			   unsigned int wait, unsigned int can_sleep)
 {
 	if (ata_msg_probe(ap))
-		ata_port_printk(ap, KERN_INFO, "ata_dev_select: ENTER, "
-				"device %u, wait %u\n", device, wait);
+		ata_port_info(ap, "ata_dev_select: ENTER, device %u, wait %u\n",
+			      device, wait);
 
 	if (wait)
 		ata_wait_idle(ap);
@@ -1335,7 +1335,7 @@ void ata_sff_flush_pio_task(struct ata_port *ap)
 	ap->hsm_task_state = HSM_ST_IDLE;
 
 	if (ata_msg_ctl(ap))
-		ata_port_printk(ap, KERN_DEBUG, "%s: EXIT\n", __func__);
+		ata_port_dbg(ap, "%s: EXIT\n", __func__);
 }
 
 static void ata_sff_pio_task(struct work_struct *work)
@@ -1513,7 +1513,7 @@ static unsigned int ata_sff_idle_irq(struct ata_port *ap)
 		ap->ops->sff_check_status(ap);
 		if (ap->ops->sff_irq_clear)
 			ap->ops->sff_irq_clear(ap);
-		ata_port_printk(ap, KERN_WARNING, "irq trap\n");
+		ata_port_warn(ap, "irq trap\n");
 		return 1;
 	}
 #endif
@@ -1711,7 +1711,7 @@ void ata_sff_lost_interrupt(struct ata_port *ap)
 
 	/* There was a command running, we are no longer busy and we have
 	   no interrupt. */
-	ata_port_printk(ap, KERN_WARNING, "lost interrupt (Status 0x%x)\n",
+	ata_port_warn(ap, "lost interrupt (Status 0x%x)\n",
 								status);
 	/* Run the host interrupt logic as if the interrupt had not been
 	   lost */
@@ -1798,8 +1798,9 @@ int ata_sff_prereset(struct ata_link *link, unsigned long deadline)
 	if (!ata_link_offline(link)) {
 		rc = ata_sff_wait_ready(link, deadline);
 		if (rc && rc != -ENODEV) {
-			ata_link_printk(link, KERN_WARNING, "device not ready "
-					"(errno=%d), forcing hardreset\n", rc);
+			ata_link_warn(link,
+				      "device not ready (errno=%d), forcing hardreset\n",
+				      rc);
 			ehc->i.action |= ATA_EH_HARDRESET;
 		}
 	}
@@ -2056,7 +2057,7 @@ int ata_sff_softreset(struct ata_link *link, unsigned int *classes,
 	rc = ata_bus_softreset(ap, devmask, deadline);
 	/* if link is occupied, -ENODEV too is an error */
 	if (rc && (rc != -ENODEV || sata_scr_valid(link))) {
-		ata_link_printk(link, KERN_ERR, "SRST failed (errno=%d)\n", rc);
+		ata_link_err(link, "SRST failed (errno=%d)\n", rc);
 		return rc;
 	}
 
@@ -2170,8 +2171,7 @@ void ata_sff_drain_fifo(struct ata_queued_cmd *qc)
 
 	/* Can become DEBUG later */
 	if (count)
-		ata_port_printk(ap, KERN_DEBUG,
-			"drained %d bytes to clear DRQ.\n", count);
+		ata_port_dbg(ap, "drained %d bytes to clear DRQ\n", count);
 
 }
 EXPORT_SYMBOL_GPL(ata_sff_drain_fifo);
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 794ec6e..cadd679 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -287,10 +287,10 @@ static void ali_warn_atapi_dma(struct ata_device *adev)
 	int print_info = ehc->i.flags & ATA_EHI_PRINTINFO;
 
 	if (print_info && adev->class == ATA_DEV_ATAPI && !ali_atapi_dma) {
-		ata_dev_printk(adev, KERN_WARNING,
-			       "WARNING: ATAPI DMA disabled for reliability issues.  It can be enabled\n");
-		ata_dev_printk(adev, KERN_WARNING,
-			       "WARNING: via pata_ali.atapi_dma modparam or corresponding sysfs node.\n");
+		ata_dev_warn(adev,
+			     "WARNING: ATAPI DMA disabled for reliability issues.  It can be enabled\n");
+		ata_dev_warn(adev,
+			     "WARNING: via pata_ali.atapi_dma modparam or corresponding sysfs node.\n");
 	}
 }
 
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index b741e0f..801554d 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -311,7 +311,7 @@ static unsigned long nv_mode_filter(struct ata_device *dev,
 	   cable detection result */
 	limit |= ata_pack_xfermask(ATA_PIO4, ATA_MWDMA2, ATA_UDMA2);
 
-	ata_port_printk(ap, KERN_DEBUG, "nv_mode_filter: 0x%lx&0x%lx->0x%lx, "
+	ata_port_dbg(ap, "nv_mode_filter: 0x%lx&0x%lx->0x%lx, "
 			"BIOS=0x%lx (0x%x) ACPI=0x%lx%s\n",
 			xfer_mask, limit, xfer_mask & limit, bios_limit,
 			saved_udma, acpi_limit, acpi_str);
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index ea64967..bd987bb 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1129,7 +1129,7 @@ static int bfin_softreset(struct ata_link *link, unsigned int *classes,
 	/* issue bus reset */
 	err_mask = bfin_bus_softreset(ap, devmask);
 	if (err_mask) {
-		ata_port_printk(ap, KERN_ERR, "SRST failed (err_mask=0x%x)\n",
+		ata_port_err(ap, "SRST failed (err_mask=0x%x)\n",
 				err_mask);
 		return -EIO;
 	}
@@ -1382,7 +1382,7 @@ idle_irq:
 #ifdef ATA_IRQ_TRAP
 	if ((ap->stats.idle_irq % 1000) == 0) {
 		ap->ops->irq_ack(ap, 0); /* debug trap */
-		ata_port_printk(ap, KERN_WARNING, "irq trap\n");
+		ata_port_warn(ap, "irq trap\n");
 		return 1;
 	}
 #endif
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index 9f2889f..52e7e7b 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -210,8 +210,8 @@ static void pata_icside_set_dmamode(struct ata_port *ap, struct ata_device *adev
 	else
 		iomd_type = 'A', cycle = 562;
 
-	ata_dev_printk(adev, KERN_INFO, "timings: act %dns rec %dns cyc %dns (%c)\n",
-		t.active, t.recover, t.cycle, iomd_type);
+	ata_dev_info(adev, "timings: act %dns rec %dns cyc %dns (%c)\n",
+		     t.active, t.recover, t.cycle, iomd_type);
 
 	state->port[ap->port_no].speed[adev->devno] = cycle;
 }
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 2d15f25..56a1a77 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -473,12 +473,12 @@ static int it821x_smart_set_mode(struct ata_link *link, struct ata_device **unus
 		/* We do need the right mode information for DMA or PIO
 		   and this comes from the current configuration flags */
 		if (ata_id_has_dma(dev->id)) {
-			ata_dev_printk(dev, KERN_INFO, "configured for DMA\n");
+			ata_dev_info(dev, "configured for DMA\n");
 			dev->xfer_mode = XFER_MW_DMA_0;
 			dev->xfer_shift = ATA_SHIFT_MWDMA;
 			dev->flags &= ~ATA_DFLAG_PIO;
 		} else {
-			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+			ata_dev_info(dev, "configured for PIO\n");
 			dev->xfer_mode = XFER_PIO_0;
 			dev->xfer_shift = ATA_SHIFT_PIO;
 			dev->flags |= ATA_DFLAG_PIO;
@@ -508,12 +508,12 @@ static void it821x_dev_config(struct ata_device *adev)
 
 	if (strstr(model_num, "Integrated Technology Express")) {
 		/* RAID mode */
-		ata_dev_printk(adev, KERN_INFO, "%sRAID%d volume",
-			adev->id[147]?"Bootable ":"",
-			adev->id[129]);
+		ata_dev_info(adev, "%sRAID%d volume",
+			     adev->id[147] ? "Bootable " : "",
+			     adev->id[129]);
 		if (adev->id[129] != 1)
-			printk("(%dK stripe)", adev->id[146]);
-		printk(".\n");
+			pr_cont("(%dK stripe)", adev->id[146]);
+		pr_cont("\n");
 	}
 	/* This is a controller firmware triggered funny, don't
 	   report the drive faulty! */
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index ee26835..fc424924 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -31,7 +31,7 @@ static int ixp4xx_set_mode(struct ata_link *link, struct ata_device **error)
 	struct ata_device *dev;
 
 	ata_for_each_dev(dev, link, ENABLED) {
-		ata_dev_printk(dev, KERN_INFO, "configured for PIO0\n");
+		ata_dev_info(dev, "configured for PIO0\n");
 		dev->pio_mode = XFER_PIO_0;
 		dev->xfer_mode = XFER_PIO_0;
 		dev->xfer_shift = ATA_SHIFT_PIO;
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 6bd9425..d960f8e 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -213,7 +213,7 @@ static int legacy_set_mode(struct ata_link *link, struct ata_device **unused)
 	struct ata_device *dev;
 
 	ata_for_each_dev(dev, link, ENABLED) {
-		ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+		ata_dev_info(dev, "configured for PIO\n");
 		dev->pio_mode = XFER_PIO_0;
 		dev->xfer_mode = XFER_PIO_0;
 		dev->xfer_shift = ATA_SHIFT_PIO;
diff --git a/drivers/ata/pata_macio.c b/drivers/ata/pata_macio.c
index d39c10b..b057e3f 100644
--- a/drivers/ata/pata_macio.c
+++ b/drivers/ata/pata_macio.c
@@ -813,7 +813,7 @@ static int pata_macio_slave_config(struct scsi_device *sdev)
 		blk_queue_update_dma_pad(sdev->request_queue, 31);
 
 		/* Tell the world about it */
-		ata_dev_printk(dev, KERN_INFO, "OHare alignment limits applied\n");
+		ata_dev_info(dev, "OHare alignment limits applied\n");
 		return 0;
 	}
 
@@ -839,8 +839,7 @@ static int pata_macio_slave_config(struct scsi_device *sdev)
 				      cmd | PCI_COMMAND_INVALIDATE);
 
 		/* Tell the world about it */
-		ata_dev_printk(dev, KERN_INFO,
-			       "K2/Shasta alignment limits applied\n");
+		ata_dev_info(dev, "K2/Shasta alignment limits applied\n");
 	}
 
 	return 0;
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index 220ddc9..c8707f0 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -405,7 +405,7 @@ static int octeon_cf_softreset16(struct ata_link *link, unsigned int *classes,
 
 	rc = ata_sff_wait_after_reset(link, 1, deadline);
 	if (rc) {
-		ata_link_printk(link, KERN_ERR, "SRST failed (errno=%d)\n", rc);
+		ata_link_err(link, "SRST failed (errno=%d)\n", rc);
 		return rc;
 	}
 
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 29af660..392a562 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -68,7 +68,7 @@ static int pcmcia_set_mode(struct ata_link *link, struct ata_device **r_failed_d
 		   the same vendor - check serial */
 		if (memcmp(master->id + ATA_ID_SERNO, slave->id + ATA_ID_SERNO,
 			   ATA_ID_SERNO_LEN) == 0 && master->id[ATA_ID_SERNO] >> 8) {
-			ata_dev_printk(slave, KERN_WARNING, "is a ghost device, ignoring.\n");
+			ata_dev_warn(slave, "is a ghost device, ignoring\n");
 			ata_dev_disable(slave);
 		}
 	}
@@ -142,8 +142,7 @@ static void pcmcia_8bit_drain_fifo(struct ata_queued_cmd *qc)
 		ioread8(ap->ioaddr.data_addr);
 
 	if (count)
-		ata_port_printk(ap, KERN_WARNING, "drained %d bytes to clear DRQ.\n",
-								count);
+		ata_port_warn(ap, "drained %d bytes to clear DRQ\n", count);
 
 }
 
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 50400fa..2067308 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -39,7 +39,7 @@ static int pata_platform_set_mode(struct ata_link *link, struct ata_device **unu
 		dev->pio_mode = dev->xfer_mode = XFER_PIO_0;
 		dev->xfer_shift = ATA_SHIFT_PIO;
 		dev->flags |= ATA_DFLAG_PIO;
-		ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+		ata_dev_info(dev, "configured for PIO\n");
 	}
 	return 0;
 }
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index 4d04471..ed8c905 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -44,7 +44,7 @@ static int rz1000_set_mode(struct ata_link *link, struct ata_device **unused)
 		dev->xfer_mode = XFER_PIO_0;
 		dev->xfer_shift = ATA_SHIFT_PIO;
 		dev->flags |= ATA_DFLAG_PIO;
-		ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+		ata_dev_info(dev, "configured for PIO\n");
 	}
 	return 0;
 }
diff --git a/drivers/ata/pata_samsung_cf.c b/drivers/ata/pata_samsung_cf.c
index c446ae6..1b372c2 100644
--- a/drivers/ata/pata_samsung_cf.c
+++ b/drivers/ata/pata_samsung_cf.c
@@ -376,7 +376,7 @@ static int pata_s3c_softreset(struct ata_link *link, unsigned int *classes,
 	rc = pata_s3c_bus_softreset(ap, deadline);
 	/* if link is occupied, -ENODEV too is an error */
 	if (rc && rc != -ENODEV) {
-		ata_link_printk(link, KERN_ERR, "SRST failed (errno=%d)\n", rc);
+		ata_link_err(link, "SRST failed (errno=%d)\n", rc);
 		return rc;
 	}
 
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 88ea9b6..a72e366 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -637,8 +637,7 @@ static int scc_softreset(struct ata_link *link, unsigned int *classes,
 	DPRINTK("about to softreset, devmask=%x\n", devmask);
 	err_mask = scc_bus_softreset(ap, devmask, deadline);
 	if (err_mask) {
-		ata_port_printk(ap, KERN_ERR, "SRST failed (err_mask=0x%x)\n",
-				err_mask);
+		ata_port_err(ap, "SRST failed (err_mask=0x%x)\n", err_mask);
 		return -EIO;
 	}
 
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index ac8d7d9..74763c3 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -350,8 +350,8 @@ static unsigned long via_mode_filter(struct ata_device *dev, unsigned long mask)
 	if (config->id == PCI_DEVICE_ID_VIA_82C586_0) {
 		ata_id_c_string(dev->id, model_num, ATA_ID_PROD, sizeof(model_num));
 		if (strcmp(model_num, "TS64GSSD25-M") == 0) {
-			ata_dev_printk(dev, KERN_WARNING,
-	"disabling UDMA mode due to reported lockups with this device.\n");
+			ata_dev_warn(dev,
+	"disabling UDMA mode due to reported lockups with this device\n");
 			mask &= ~ ATA_MASK_UDMA;
 		}
 	}
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 1cc70e3..78ae7b6 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -346,12 +346,11 @@ static unsigned int sata_fsl_fill_sg(struct ata_queued_cmd *qc, void *cmd_desc,
 
 		/* warn if each s/g element is not dword aligned */
 		if (sg_addr & 0x03)
-			ata_port_printk(qc->ap, KERN_ERR,
-					"s/g addr unaligned : 0x%llx\n",
-					(unsigned long long)sg_addr);
+			ata_port_err(qc->ap, "s/g addr unaligned : 0x%llx\n",
+				     (unsigned long long)sg_addr);
 		if (sg_len & 0x03)
-			ata_port_printk(qc->ap, KERN_ERR,
-					"s/g len unaligned : 0x%x\n", sg_len);
+			ata_port_err(qc->ap, "s/g len unaligned : 0x%x\n",
+				     sg_len);
 
 		if (num_prde == (SATA_FSL_MAX_PRD_DIRECT - 1) &&
 		    sg_next(sg) != NULL) {
@@ -739,8 +738,7 @@ try_offline_again:
 				 1, 500);
 
 	if (temp & ONLINE) {
-		ata_port_printk(ap, KERN_ERR,
-				"Hardreset failed, not off-lined %d\n", i);
+		ata_port_err(ap, "Hardreset failed, not off-lined %d\n", i);
 
 		/*
 		 * Try to offline controller atleast twice
@@ -776,8 +774,7 @@ try_offline_again:
 	temp = ata_wait_register(ap, hcr_base + HSTATUS, ONLINE, 0, 1, 500);
 
 	if (!(temp & ONLINE)) {
-		ata_port_printk(ap, KERN_ERR,
-				"Hardreset failed, not on-lined\n");
+		ata_port_err(ap, "Hardreset failed, not on-lined\n");
 		goto err;
 	}
 
@@ -793,9 +790,8 @@ try_offline_again:
 
 	temp = ata_wait_register(ap, hcr_base + HSTATUS, 0xFF, 0, 1, 500);
 	if ((!(temp & 0x10)) || ata_link_offline(link)) {
-		ata_port_printk(ap, KERN_WARNING,
-				"No Device OR PHYRDY change,Hstatus = 0x%x\n",
-				ioread32(hcr_base + HSTATUS));
+		ata_port_warn(ap, "No Device OR PHYRDY change,Hstatus = 0x%x\n",
+			      ioread32(hcr_base + HSTATUS));
 		*class = ATA_DEV_NONE;
 		return 0;
 	}
@@ -808,13 +804,12 @@ try_offline_again:
 			500, jiffies_to_msecs(deadline - start_jiffies));
 
 	if ((temp & 0xFF) != 0x18) {
-		ata_port_printk(ap, KERN_WARNING, "No Signature Update\n");
+		ata_port_warn(ap, "No Signature Update\n");
 		*class = ATA_DEV_NONE;
 		goto do_followup_srst;
 	} else {
-		ata_port_printk(ap, KERN_INFO,
-				"Signature Update detected @ %d msecs\n",
-				jiffies_to_msecs(jiffies - start_jiffies));
+		ata_port_info(ap, "Signature Update detected @ %d msecs\n",
+			      jiffies_to_msecs(jiffies - start_jiffies));
 		*class = sata_fsl_dev_classify(ap);
 		return 0;
 	}
@@ -889,7 +884,7 @@ static int sata_fsl_softreset(struct ata_link *link, unsigned int *class,
 
 	temp = ata_wait_register(ap, CQ + hcr_base, 0x1, 0x1, 1, 5000);
 	if (temp & 0x1) {
-		ata_port_printk(ap, KERN_WARNING, "ATA_SRST issue failed\n");
+		ata_port_warn(ap, "ATA_SRST issue failed\n");
 
 		DPRINTK("Softreset@5000,CQ=0x%x,CA=0x%x,CC=0x%x\n",
 			ioread32(CQ + hcr_base),
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 83019e6..7a5667d 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -396,9 +396,8 @@ static void inic_host_intr(struct ata_port *ap)
 	}
 
  spurious:
-	ata_port_printk(ap, KERN_WARNING, "unhandled interrupt: "
-			"cmd=0x%x irq_stat=0x%x idma_stat=0x%x\n",
-			qc ? qc->tf.command : 0xff, irq_stat, idma_stat);
+	ata_port_warn(ap, "unhandled interrupt: cmd=0x%x irq_stat=0x%x idma_stat=0x%x\n",
+		      qc ? qc->tf.command : 0xff, irq_stat, idma_stat);
 }
 
 static irqreturn_t inic_interrupt(int irq, void *dev_instance)
@@ -619,8 +618,9 @@ static int inic_hardreset(struct ata_link *link, unsigned int *class,
 
 	rc = sata_link_resume(link, timing, deadline);
 	if (rc) {
-		ata_link_printk(link, KERN_WARNING, "failed to resume "
-				"link after reset (errno=%d)\n", rc);
+		ata_link_warn(link,
+			      "failed to resume link after reset (errno=%d)\n",
+			      rc);
 		return rc;
 	}
 
@@ -632,8 +632,9 @@ static int inic_hardreset(struct ata_link *link, unsigned int *class,
 		rc = ata_wait_after_reset(link, deadline, inic_check_ready);
 		/* link occupied, -ENODEV too is an error */
 		if (rc) {
-			ata_link_printk(link, KERN_WARNING, "device not ready "
-					"after hardreset (errno=%d)\n", rc);
+			ata_link_warn(link,
+				      "device not ready after hardreset (errno=%d)\n",
+				      rc);
 			return rc;
 		}
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index bea717a..b0e45d2 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1190,7 +1190,7 @@ static void mv_wait_for_edma_empty_idle(struct ata_port *ap)
 			break;
 		udelay(per_loop);
 	}
-	/* ata_port_printk(ap, KERN_INFO, "%s: %u+ usecs\n", __func__, i); */
+	/* ata_port_info(ap, "%s: %u+ usecs\n", __func__, i); */
 }
 
 /**
@@ -1228,7 +1228,7 @@ static int mv_stop_edma(struct ata_port *ap)
 	pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
 	mv_wait_for_edma_empty_idle(ap);
 	if (mv_stop_edma_engine(port_mmio)) {
-		ata_port_printk(ap, KERN_ERR, "Unable to stop eDMA\n");
+		ata_port_err(ap, "Unable to stop eDMA\n");
 		err = -EIO;
 	}
 	mv_edma_cfg(ap, 0, 0);
@@ -1382,7 +1382,7 @@ static void mv6_dev_config(struct ata_device *adev)
 	if (adev->flags & ATA_DFLAG_NCQ) {
 		if (sata_pmp_attached(adev->link->ap)) {
 			adev->flags &= ~ATA_DFLAG_NCQ;
-			ata_dev_printk(adev, KERN_INFO,
+			ata_dev_info(adev,
 				"NCQ disabled for command-based switching\n");
 		}
 	}
@@ -2225,9 +2225,8 @@ static unsigned int mv_send_fis(struct ata_port *ap, u32 *fis, int nwords)
 
 	/* See if it worked */
 	if ((ifstat & 0x3000) != 0x1000) {
-		ata_port_printk(ap, KERN_WARNING,
-				"%s transmission error, ifstat=%08x\n",
-				__func__, ifstat);
+		ata_port_warn(ap, "%s transmission error, ifstat=%08x\n",
+			      __func__, ifstat);
 		return AC_ERR_OTHER;
 	}
 	return 0;
@@ -2342,9 +2341,9 @@ static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 		 */
 		if (limit_warnings > 0 && (qc->nbytes / qc->sect_size) > 1) {
 			--limit_warnings;
-			ata_link_printk(qc->dev->link, KERN_WARNING, DRV_NAME
-					": attempting PIO w/multiple DRQ: "
-					"this may fail due to h/w errata\n");
+			ata_link_warn(qc->dev->link, DRV_NAME
+				      ": attempting PIO w/multiple DRQ: "
+				      "this may fail due to h/w errata\n");
 		}
 		/* drop through */
 	case ATA_PROT_NODATA:
@@ -2499,20 +2498,20 @@ static int mv_handle_fbs_ncq_dev_err(struct ata_port *ap)
 	}
 	failed_links = hweight16(new_map);
 
-	ata_port_printk(ap, KERN_INFO, "%s: pmp_map=%04x qc_map=%04x "
-			"failed_links=%d nr_active_links=%d\n",
-			__func__, pp->delayed_eh_pmp_map,
-			ap->qc_active, failed_links,
-			ap->nr_active_links);
+	ata_port_info(ap,
+		      "%s: pmp_map=%04x qc_map=%04x failed_links=%d nr_active_links=%d\n",
+		      __func__, pp->delayed_eh_pmp_map,
+		      ap->qc_active, failed_links,
+		      ap->nr_active_links);
 
 	if (ap->nr_active_links <= failed_links && mv_req_q_empty(ap)) {
 		mv_process_crpb_entries(ap, pp);
 		mv_stop_edma(ap);
 		mv_eh_freeze(ap);
-		ata_port_printk(ap, KERN_INFO, "%s: done\n", __func__);
+		ata_port_info(ap, "%s: done\n", __func__);
 		return 1;	/* handled */
 	}
-	ata_port_printk(ap, KERN_INFO, "%s: waiting\n", __func__);
+	ata_port_info(ap, "%s: waiting\n", __func__);
 	return 1;	/* handled */
 }
 
@@ -2554,9 +2553,8 @@ static int mv_handle_dev_err(struct ata_port *ap, u32 edma_err_cause)
 		 * and we cannot handle it here.
 		 */
 		if (edma_err_cause & EDMA_ERR_SELF_DIS) {
-			ata_port_printk(ap, KERN_WARNING,
-				"%s: err_cause=0x%x pp_flags=0x%x\n",
-				__func__, edma_err_cause, pp->pp_flags);
+			ata_port_warn(ap, "%s: err_cause=0x%x pp_flags=0x%x\n",
+				      __func__, edma_err_cause, pp->pp_flags);
 			return 0; /* not handled */
 		}
 		return mv_handle_fbs_ncq_dev_err(ap);
@@ -2567,9 +2565,8 @@ static int mv_handle_dev_err(struct ata_port *ap, u32 edma_err_cause)
 		 * and we cannot handle it here.
 		 */
 		if (!(edma_err_cause & EDMA_ERR_SELF_DIS)) {
-			ata_port_printk(ap, KERN_WARNING,
-				"%s: err_cause=0x%x pp_flags=0x%x\n",
-				__func__, edma_err_cause, pp->pp_flags);
+			ata_port_warn(ap, "%s: err_cause=0x%x pp_flags=0x%x\n",
+				      __func__, edma_err_cause, pp->pp_flags);
 			return 0; /* not handled */
 		}
 		return mv_handle_fbs_non_ncq_dev_err(ap);
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index f215e10..b33f525 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -620,9 +620,8 @@ static void nv_adma_register_mode(struct ata_port *ap)
 		count++;
 	}
 	if (count == 20)
-		ata_port_printk(ap, KERN_WARNING,
-			"timeout waiting for ADMA IDLE, stat=0x%hx\n",
-			status);
+		ata_port_warn(ap, "timeout waiting for ADMA IDLE, stat=0x%hx\n",
+			      status);
 
 	tmp = readw(mmio + NV_ADMA_CTL);
 	writew(tmp & ~NV_ADMA_CTL_GO, mmio + NV_ADMA_CTL);
@@ -635,9 +634,9 @@ static void nv_adma_register_mode(struct ata_port *ap)
 		count++;
 	}
 	if (count == 20)
-		ata_port_printk(ap, KERN_WARNING,
-			 "timeout waiting for ADMA LEGACY, stat=0x%hx\n",
-			 status);
+		ata_port_warn(ap,
+			      "timeout waiting for ADMA LEGACY, stat=0x%hx\n",
+			      status);
 
 	pp->flags |= NV_ADMA_PORT_REGISTER_MODE;
 }
@@ -665,7 +664,7 @@ static void nv_adma_mode(struct ata_port *ap)
 		count++;
 	}
 	if (count == 20)
-		ata_port_printk(ap, KERN_WARNING,
+		ata_port_warn(ap,
 			"timeout waiting for ADMA LEGACY clear and IDLE, stat=0x%hx\n",
 			status);
 
@@ -772,10 +771,10 @@ static int nv_adma_slave_config(struct scsi_device *sdev)
 
 	blk_queue_segment_boundary(sdev->request_queue, segment_boundary);
 	blk_queue_max_segments(sdev->request_queue, sg_tablesize);
-	ata_port_printk(ap, KERN_INFO,
-		"DMA mask 0x%llX, segment boundary 0x%lX, hw segs %hu\n",
-		(unsigned long long)*ap->host->dev->dma_mask,
-		segment_boundary, sg_tablesize);
+	ata_port_info(ap,
+		      "DMA mask 0x%llX, segment boundary 0x%lX, hw segs %hu\n",
+		      (unsigned long long)*ap->host->dev->dma_mask,
+		      segment_boundary, sg_tablesize);
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
@@ -1443,8 +1442,7 @@ static unsigned int nv_adma_qc_issue(struct ata_queued_cmd *qc)
 	   existing commands. */
 	if (unlikely(qc->tf.protocol == ATA_PROT_NCQ &&
 		     (qc->flags & ATA_QCFLAG_RESULT_TF))) {
-		ata_dev_printk(qc->dev, KERN_ERR,
-			"NCQ w/ RESULT_TF not allowed\n");
+		ata_dev_err(qc->dev, "NCQ w/ RESULT_TF not allowed\n");
 		return AC_ERR_SYSTEM;
 	}
 
@@ -1581,15 +1579,15 @@ static int nv_hardreset(struct ata_link *link, unsigned int *class,
 		int rc;
 
 		if (!(ehc->i.flags & ATA_EHI_QUIET))
-			ata_link_printk(link, KERN_INFO, "nv: skipping "
-					"hardreset on occupied port\n");
+			ata_link_info(link,
+				      "nv: skipping hardreset on occupied port\n");
 
 		/* make sure the link is online */
 		rc = sata_link_resume(link, timing, deadline);
 		/* whine about phy resume failure but proceed */
 		if (rc && rc != -EOPNOTSUPP)
-			ata_link_printk(link, KERN_WARNING, "failed to resume "
-					"link (errno=%d)\n", rc);
+			ata_link_warn(link, "failed to resume link (errno=%d)\n",
+				      rc);
 	}
 
 	/* device signature acquisition is unreliable */
@@ -1686,7 +1684,7 @@ static void nv_adma_error_handler(struct ata_port *ap)
 			u8 cpb_count = readb(mmio + NV_ADMA_CPB_COUNT);
 			u8 next_cpb_idx = readb(mmio + NV_ADMA_NEXT_CPB_IDX);
 
-			ata_port_printk(ap, KERN_ERR,
+			ata_port_err(ap,
 				"EH in ADMA mode, notifier 0x%X "
 				"notifier_error 0x%X gen_ctl 0x%X status 0x%X "
 				"next cpb count 0x%X next cpb idx 0x%x\n",
@@ -1697,7 +1695,7 @@ static void nv_adma_error_handler(struct ata_port *ap)
 				struct nv_adma_cpb *cpb = &pp->cpb[i];
 				if ((ata_tag_valid(ap->link.active_tag) && i == ap->link.active_tag) ||
 				    ap->link.sactive & (1 << i))
-					ata_port_printk(ap, KERN_ERR,
+					ata_port_err(ap,
 						"CPB %d: ctl_flags 0x%x, resp_flags 0x%x\n",
 						i, cpb->ctl_flags, cpb->resp_flags);
 			}
@@ -1799,23 +1797,22 @@ static void nv_swncq_ncq_stop(struct ata_port *ap)
 	u32 sactive;
 	u32 done_mask;
 
-	ata_port_printk(ap, KERN_ERR,
-			"EH in SWNCQ mode,QC:qc_active 0x%X sactive 0x%X\n",
-			ap->qc_active, ap->link.sactive);
-	ata_port_printk(ap, KERN_ERR,
+	ata_port_err(ap, "EH in SWNCQ mode,QC:qc_active 0x%X sactive 0x%X\n",
+		     ap->qc_active, ap->link.sactive);
+	ata_port_err(ap,
 		"SWNCQ:qc_active 0x%X defer_bits 0x%X last_issue_tag 0x%x\n  "
 		"dhfis 0x%X dmafis 0x%X sdbfis 0x%X\n",
 		pp->qc_active, pp->defer_queue.defer_bits, pp->last_issue_tag,
 		pp->dhfis_bits, pp->dmafis_bits, pp->sdbfis_bits);
 
-	ata_port_printk(ap, KERN_ERR, "ATA_REG 0x%X ERR_REG 0x%X\n",
-			ap->ops->sff_check_status(ap),
-			ioread8(ap->ioaddr.error_addr));
+	ata_port_err(ap, "ATA_REG 0x%X ERR_REG 0x%X\n",
+		     ap->ops->sff_check_status(ap),
+		     ioread8(ap->ioaddr.error_addr));
 
 	sactive = readl(pp->sactive_block);
 	done_mask = pp->qc_active ^ sactive;
 
-	ata_port_printk(ap, KERN_ERR, "tag : dhfis dmafis sdbfis sacitve\n");
+	ata_port_err(ap, "tag : dhfis dmafis sdbfis sactive\n");
 	for (i = 0; i < ATA_MAX_QUEUE; i++) {
 		u8 err = 0;
 		if (pp->qc_active & (1 << i))
@@ -1825,13 +1822,13 @@ static void nv_swncq_ncq_stop(struct ata_port *ap)
 		else
 			continue;
 
-		ata_port_printk(ap, KERN_ERR,
-				"tag 0x%x: %01x %01x %01x %01x %s\n", i,
-				(pp->dhfis_bits >> i) & 0x1,
-				(pp->dmafis_bits >> i) & 0x1,
-				(pp->sdbfis_bits >> i) & 0x1,
-				(sactive >> i) & 0x1,
-				(err ? "error! tag doesn't exit" : " "));
+		ata_port_err(ap,
+			     "tag 0x%x: %01x %01x %01x %01x %s\n", i,
+			     (pp->dhfis_bits >> i) & 0x1,
+			     (pp->dmafis_bits >> i) & 0x1,
+			     (pp->sdbfis_bits >> i) & 0x1,
+			     (sactive >> i) & 0x1,
+			     (err ? "error! tag doesn't exit" : " "));
 	}
 
 	nv_swncq_pp_reinit(ap);
@@ -1956,8 +1953,8 @@ static int nv_swncq_slave_config(struct scsi_device *sdev)
 
 	if (strncmp(model_num, "Maxtor", 6) == 0) {
 		ata_scsi_change_queue_depth(sdev, 1, SCSI_QDEPTH_DEFAULT);
-		ata_dev_printk(dev, KERN_NOTICE,
-			"Disabling SWNCQ mode (depth %x)\n", sdev->queue_depth);
+		ata_dev_notice(dev, "Disabling SWNCQ mode (depth %x)\n",
+			       sdev->queue_depth);
 	}
 
 	return rc;
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index fe16ee8..280ba8a 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -643,8 +643,8 @@ static void sil_dev_config(struct ata_device *dev)
 	    ((ap->flags & SIL_FLAG_MOD15WRITE) &&
 	     (quirks & SIL_QUIRK_MOD15WRITE))) {
 		if (print_info)
-			ata_dev_printk(dev, KERN_INFO, "applying Seagate "
-				       "errata fix (mod15write workaround)\n");
+			ata_dev_info(dev,
+		"applying Seagate errata fix (mod15write workaround)\n");
 		dev->max_sectors = 15;
 		return;
 	}
@@ -652,8 +652,8 @@ static void sil_dev_config(struct ata_device *dev)
 	/* limit to udma5 */
 	if (quirks & SIL_QUIRK_UDMA5MAX) {
 		if (print_info)
-			ata_dev_printk(dev, KERN_INFO, "applying Maxtor "
-				       "errata fix %s\n", model_num);
+			ata_dev_info(dev, "applying Maxtor errata fix %s\n",
+				     model_num);
 		dev->udma_mask &= ATA_UDMA5;
 		return;
 	}
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 164d52e..792e936 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -694,7 +694,7 @@ static int sil24_softreset(struct ata_link *link, unsigned int *class,
 	return 0;
 
  err:
-	ata_link_printk(link, KERN_ERR, "softreset failed (%s)\n", reason);
+	ata_link_err(link, "softreset failed (%s)\n", reason);
 	return -EIO;
 }
 
@@ -714,8 +714,8 @@ static int sil24_hardreset(struct ata_link *link, unsigned int *class,
 	 * This happens often after PM DMA CS errata.
 	 */
 	if (pp->do_port_rst) {
-		ata_port_printk(ap, KERN_WARNING, "controller in dubious "
-				"state, performing PORT_RST\n");
+		ata_port_warn(ap,
+			      "controller in dubious state, performing PORT_RST\n");
 
 		writel(PORT_CS_PORT_RST, port + PORT_CTRL_STAT);
 		ata_msleep(ap, 10);
@@ -773,7 +773,7 @@ static int sil24_hardreset(struct ata_link *link, unsigned int *class,
 		goto retry;
 	}
 
-	ata_link_printk(link, KERN_ERR, "hardreset failed (%s)\n", reason);
+	ata_link_err(link, "hardreset failed (%s)\n", reason);
 	return -EIO;
 }
 
@@ -925,7 +925,7 @@ static void sil24_pmp_attach(struct ata_port *ap)
 
 	if (sata_pmp_gscr_vendor(gscr) == 0x11ab &&
 	    sata_pmp_gscr_devid(gscr) == 0x4140) {
-		ata_port_printk(ap, KERN_INFO,
+		ata_port_info(ap,
 			"disabling NCQ support due to sil24-mv4140 quirk\n");
 		ap->flags &= ~ATA_FLAG_NCQ;
 	}
@@ -946,8 +946,7 @@ static int sil24_pmp_hardreset(struct ata_link *link, unsigned int *class,
 
 	rc = sil24_init_port(link->ap);
 	if (rc) {
-		ata_link_printk(link, KERN_ERR,
-				"hardreset failed (port not ready)\n");
+		ata_link_err(link, "hardreset failed (port not ready)\n");
 		return rc;
 	}
 
@@ -1141,8 +1140,8 @@ static inline void sil24_host_intr(struct ata_port *ap)
 
 	/* spurious interrupts are expected if PCIX_IRQ_WOC */
 	if (!(ap->flags & SIL24_FLAG_PCIX_IRQ_WOC) && ata_ratelimit())
-		ata_port_printk(ap, KERN_INFO, "spurious interrupt "
-			"(slot_stat 0x%x active_tag %d sactive 0x%x)\n",
+		ata_port_info(ap,
+			"spurious interrupt (slot_stat 0x%x active_tag %d sactive 0x%x)\n",
 			slot_stat, ap->link.active_tag, ap->link.sactive);
 }
 
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 9b43ccb..0fc1582 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -360,9 +360,9 @@ static int vt6420_prereset(struct ata_link *link, unsigned long deadline)
 
 	online = (sstatus & 0xf) == 0x3;
 
-	ata_port_printk(ap, KERN_INFO,
-			"SATA link %s 1.5 Gbps (SStatus %X SControl %X)\n",
-			online ? "up" : "down", sstatus, scontrol);
+	ata_port_info(ap,
+		      "SATA link %s 1.5 Gbps (SStatus %X SControl %X)\n",
+		      online ? "up" : "down", sstatus, scontrol);
 
 	/* SStatus is read one more time */
 	svia_scr_read(link, SCR_STATUS, &sstatus);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 7f675aa..2beeebb 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1244,20 +1244,48 @@ static inline int sata_srst_pmp(struct ata_link *link)
 /*
  * printk helpers
  */
-#define ata_port_printk(ap, lv, fmt, args...) \
-	printk("%sata%u: "fmt, lv, (ap)->print_id , ##args)
-
-#define ata_link_printk(link, lv, fmt, args...) do { \
-	if (sata_pmp_attached((link)->ap) || (link)->ap->slave_link)	\
-		printk("%sata%u.%02u: "fmt, lv, (link)->ap->print_id,	\
-		       (link)->pmp , ##args); \
-	else \
-		printk("%sata%u: "fmt, lv, (link)->ap->print_id , ##args); \
-	} while(0)
-
-#define ata_dev_printk(dev, lv, fmt, args...) \
-	printk("%sata%u.%02u: "fmt, lv, (dev)->link->ap->print_id,	\
-	       (dev)->link->pmp + (dev)->devno , ##args)
+__attribute__((format (printf, 3, 4)))
+int ata_port_printk(const struct ata_port *ap, const char *level,
+		    const char *fmt, ...);
+__attribute__((format (printf, 3, 4)))
+int ata_link_printk(const struct ata_link *link, const char *level,
+		    const char *fmt, ...);
+__attribute__((format (printf, 3, 4)))
+int ata_dev_printk(const struct ata_device *dev, const char *level,
+		   const char *fmt, ...);
+
+#define ata_port_err(ap, fmt, ...)				\
+	ata_port_printk(ap, KERN_ERR, fmt, ##__VA_ARGS__)
+#define ata_port_warn(ap, fmt, ...)				\
+	ata_port_printk(ap, KERN_WARNING, fmt, ##__VA_ARGS__)
+#define ata_port_notice(ap, fmt, ...)				\
+	ata_port_printk(ap, KERN_NOTICE, fmt, ##__VA_ARGS__)
+#define ata_port_info(ap, fmt, ...)				\
+	ata_port_printk(ap, KERN_INFO, fmt, ##__VA_ARGS__)
+#define ata_port_dbg(ap, fmt, ...)				\
+	ata_port_printk(ap, KERN_DEBUG, fmt, ##__VA_ARGS__)
+
+#define ata_link_err(link, fmt, ...)				\
+	ata_link_printk(link, KERN_ERR, fmt, ##__VA_ARGS__)
+#define ata_link_warn(link, fmt, ...)				\
+	ata_link_printk(link, KERN_WARNING, fmt, ##__VA_ARGS__)
+#define ata_link_notice(link, fmt, ...)				\
+	ata_link_printk(link, KERN_NOTICE, fmt, ##__VA_ARGS__)
+#define ata_link_info(link, fmt, ...)				\
+	ata_link_printk(link, KERN_INFO, fmt, ##__VA_ARGS__)
+#define ata_link_dbg(link, fmt, ...)				\
+	ata_link_printk(link, KERN_DEBUG, fmt, ##__VA_ARGS__)
+
+#define ata_dev_err(dev, fmt, ...)				\
+	ata_dev_printk(dev, KERN_ERR, fmt, ##__VA_ARGS__)
+#define ata_dev_warn(dev, fmt, ...)				\
+	ata_dev_printk(dev, KERN_WARNING, fmt, ##__VA_ARGS__)
+#define ata_dev_notice(dev, fmt, ...)				\
+	ata_dev_printk(dev, KERN_NOTICE, fmt, ##__VA_ARGS__)
+#define ata_dev_info(dev, fmt, ...)				\
+	ata_dev_printk(dev, KERN_INFO, fmt, ##__VA_ARGS__)
+#define ata_dev_dbg(dev, fmt, ...)				\
+	ata_dev_printk(dev, KERN_DEBUG, fmt, ##__VA_ARGS__)
 
 /*
  * ata_eh_info helpers
-- 
1.7.4.2.g597a6.dirty

