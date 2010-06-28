Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab0F1T6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 15:58:05 -0400
Received: from mail.perches.com ([173.55.12.10]:1342 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab0F1T6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 15:58:01 -0400
Subject: [PATCH] drivers/cdrom: Use pr_<level>
From: Joe Perches <joe@perches.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Jun 2010 12:57:59 -0700
Message-ID: <1277755079.29157.151.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt
Convert printks to pr_<level>
Add if (0) and printf argument checking to cdinfo
Coalesced consecutive printks to single pr_
Fixed a typo "back ground" to "background"
Converted printks without level to pr_info
Removed VIOCD_ prefixes and use pr_fmt/pr_<level>
Added a missing newline to an OS/400 message

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cdrom/cdrom.c |   46 +++++++++++++++------------
 drivers/cdrom/gdrom.c |   27 ++++++++--------
 drivers/cdrom/viocd.c |   83 ++++++++++++++++++++-----------------------------
 3 files changed, 73 insertions(+), 83 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index e3749d0..0fcd12d 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -242,6 +242,8 @@
 
 -------------------------------------------------------------------------*/
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define REVISION "Revision: 3.20"
 #define VERSION "Id: cdrom.c 3.20 2003/12/17"
 
@@ -314,11 +316,17 @@ static const char *mrw_format_status[] = {
 static const char *mrw_address_space[] = { "DMA", "GAA" };
 
 #if (ERRLOGMASK!=CD_NOTHING)
-#define cdinfo(type, fmt, args...) \
-        if ((ERRLOGMASK & type) || debug==1 ) \
-            printk(KERN_INFO "cdrom: " fmt, ## args)
+#define cdinfo(type, fmt, args...)			\
+do {							\
+        if ((ERRLOGMASK & type) || debug==1)		\
+		pr_info(fmt, ##args);			\
+} while (0)
 #else
-#define cdinfo(type, fmt, args...) 
+#define cdinfo(type, fmt, args...)			\
+do {							\
+        if (0 && (ERRLOGMASK & type) || debug==1 )	\
+		pr_info(fmt, ##args);			\
+} while (0)
 #endif
 
 /* These are used to simplify getting data in from and back to user land */
@@ -395,7 +403,7 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	if (cdo->open == NULL || cdo->release == NULL)
 		return -EINVAL;
 	if (!banner_printed) {
-		printk(KERN_INFO "Uniform CD-ROM driver " REVISION "\n");
+		pr_info("Uniform CD-ROM driver " REVISION "\n");
 		banner_printed = 1;
 		cdrom_sysctl_register();
 	}
@@ -546,7 +554,7 @@ static int cdrom_mrw_bgformat(struct cdrom_device_info *cdi, int cont)
 	unsigned char buffer[12];
 	int ret;
 
-	printk(KERN_INFO "cdrom: %sstarting format\n", cont ? "Re" : "");
+	pr_info("%sstarting format\n", cont ? "Re" : "");
 
 	/*
 	 * FmtData bit set (bit 4), format type is 1
@@ -576,7 +584,7 @@ static int cdrom_mrw_bgformat(struct cdrom_device_info *cdi, int cont)
 
 	ret = cdi->ops->generic_packet(cdi, &cgc);
 	if (ret)
-		printk(KERN_INFO "cdrom: bgformat failed\n");
+		pr_info("bgformat failed\n");
 
 	return ret;
 }
@@ -622,8 +630,7 @@ static int cdrom_mrw_exit(struct cdrom_device_info *cdi)
 
 	ret = 0;
 	if (di.mrw_status == CDM_MRW_BGFORMAT_ACTIVE) {
-		printk(KERN_INFO "cdrom: issuing MRW back ground "
-				"format suspend\n");
+		pr_info("issuing MRW background format suspend\n");
 		ret = cdrom_mrw_bgformat_susp(cdi, 0);
 	}
 
@@ -658,7 +665,8 @@ static int cdrom_mrw_set_lba_space(struct cdrom_device_info *cdi, int space)
 	if ((ret = cdrom_mode_select(cdi, &cgc)))
 		return ret;
 
-	printk(KERN_INFO "cdrom: %s: mrw address space %s selected\n", cdi->name, mrw_address_space[space]);
+	pr_info("%s: mrw address space %s selected\n",
+		cdi->name, mrw_address_space[space]);
 	return 0;
 }
 
@@ -762,7 +770,7 @@ static int cdrom_mrw_open_write(struct cdrom_device_info *cdi)
 	 * always reset to DMA lba space on open
 	 */
 	if (cdrom_mrw_set_lba_space(cdi, MRW_LBA_DMA)) {
-		printk(KERN_ERR "cdrom: failed setting lba address space\n");
+		pr_err("failed setting lba address space\n");
 		return 1;
 	}
 
@@ -781,8 +789,7 @@ static int cdrom_mrw_open_write(struct cdrom_device_info *cdi)
 	 * 3	-	MRW formatting complete
 	 */
 	ret = 0;
-	printk(KERN_INFO "cdrom open: mrw_status '%s'\n",
-			mrw_format_status[di.mrw_status]);
+	pr_info("open: mrw_status '%s'\n", mrw_format_status[di.mrw_status]);
 	if (!di.mrw_status)
 		ret = 1;
 	else if (di.mrw_status == CDM_MRW_BGFORMAT_INACTIVE &&
@@ -932,8 +939,7 @@ static void cdrom_dvd_rw_close_write(struct cdrom_device_info *cdi)
 		return;
 	}
 
-	printk(KERN_INFO "cdrom: %s: dirty DVD+RW media, \"finalizing\"\n",
-	       cdi->name);
+	pr_info("%s: dirty DVD+RW media, \"finalizing\"\n", cdi->name);
 
 	init_cdrom_command(&cgc, NULL, 0, CGC_DATA_NONE);
 	cgc.cmd[0] = GPCMD_FLUSH_CACHE;
@@ -2176,7 +2182,7 @@ retry:
 	 * frame dma, so drop to single frame dma if we need to
 	 */
 	if (cdi->cdda_method == CDDA_BPC_FULL && nframes > 1) {
-		printk("cdrom: dropping to single frame dma\n");
+		pr_info("dropping to single frame dma\n");
 		cdi->cdda_method = CDDA_BPC_SINGLE;
 		goto retry;
 	}
@@ -2189,7 +2195,7 @@ retry:
 	if (cdi->last_sense != 0x04 && cdi->last_sense != 0x0b)
 		return ret;
 
-	printk("cdrom: dropping to old style cdda (sense=%x)\n", cdi->last_sense);
+	pr_info("dropping to old style cdda (sense=%x)\n", cdi->last_sense);
 	cdi->cdda_method = CDDA_OLD;
 	return cdrom_read_cdda_old(cdi, ubuf, lba, nframes);	
 }
@@ -3401,7 +3407,7 @@ static int cdrom_print_info(const char *header, int val, char *info,
 					"\t%d", CDROM_CAN(val) != 0);
 			break;
 		default:
-			printk(KERN_INFO "cdrom: invalid option%d\n", option);
+			pr_info("invalid option%d\n", option);
 			return 1;
 		}
 		if (!ret)
@@ -3491,7 +3497,7 @@ doit:
 	mutex_unlock(&cdrom_mutex);
 	return proc_dostring(ctl, write, buffer, lenp, ppos);
 done:
-	printk(KERN_INFO "cdrom: info buffer too small\n");
+	pr_info("info buffer too small\n");
 	goto doit;
 }
 
@@ -3665,7 +3671,7 @@ static int __init cdrom_init(void)
 
 static void __exit cdrom_exit(void)
 {
-	printk(KERN_INFO "Uniform CD-ROM driver unloaded\n");
+	pr_info("Uniform CD-ROM driver unloaded\n");
 	cdrom_sysctl_unregister();
 }
 
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 03c71f7..e2fd150 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -19,6 +19,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/fs.h>
@@ -339,8 +341,7 @@ static int gdrom_get_last_session(struct cdrom_device_info *cd_info,
 		tocuse = 0;
 		err = gdrom_readtoc_cmd(gd.toc, 0);
 		if (err) {
-			printk(KERN_INFO "GDROM: Could not get CD "
-				"table of contents\n");
+			pr_info("Could not get CD table of contents\n");
 			return -ENXIO;
 		}
 	}
@@ -357,8 +358,7 @@ static int gdrom_get_last_session(struct cdrom_device_info *cd_info,
 	} while (track >= fentry);
 
 	if ((track > 100) || (track < get_entry_track(gd.toc->first))) {
-		printk(KERN_INFO "GDROM: No data on the last "
-			"session of the CD\n");
+		pr_info("No data on the last session of the CD\n");
 		gdrom_getsense(NULL);
 		return -ENXIO;
 	}
@@ -451,14 +451,14 @@ static int gdrom_getsense(short *bufstring)
 		goto cleanup_sense;
 	insw(GDROM_DATA_REG, &sense, sense_command->buflen/2);
 	if (sense[1] & 40) {
-		printk(KERN_INFO "GDROM: Drive not ready - command aborted\n");
+		pr_info("Drive not ready - command aborted\n");
 		goto cleanup_sense;
 	}
 	sense_key = sense[1] & 0x0F;
 	if (sense_key < ARRAY_SIZE(sense_texts))
-		printk(KERN_INFO "GDROM: %s\n", sense_texts[sense_key].text);
+		pr_info("%s\n", sense_texts[sense_key].text);
 	else
-		printk(KERN_ERR "GDROM: Unknown sense key: %d\n", sense_key);
+		pr_err("Unknown sense key: %d\n", sense_key);
 	if (bufstring) /* return addional sense data */
 		memcpy(bufstring, &sense[4], 2);
 	if (sense_key < 2)
@@ -644,13 +644,12 @@ static void gdrom_request(struct request_queue *rq)
 
 	while ((req = blk_fetch_request(rq)) != NULL) {
 		if (!blk_fs_request(req)) {
-			printk(KERN_DEBUG "GDROM: Non-fs request ignored\n");
+			printk(KERN_DEBUG "gdrom: Non-fs request ignored\n");
 			__blk_end_request_all(req, -EIO);
 			continue;
 		}
 		if (rq_data_dir(req) != READ) {
-			printk(KERN_NOTICE "GDROM: Read only device -");
-			printk(" write request ignored\n");
+			pr_notice("Read only device - write request ignored\n");
 			__blk_end_request_all(req, -EIO);
 			continue;
 		}
@@ -685,7 +684,7 @@ static int __devinit gdrom_outputversion(void)
 	firmw_ver = kstrndup(id->firmver, 16, GFP_KERNEL);
 	if (!firmw_ver)
 		goto free_manuf_name;
-	printk(KERN_INFO "GDROM: %s from %s with firmware %s\n",
+	pr_info("%s from %s with firmware %s\n",
 		model_name, manuf_name, firmw_ver);
 	err = 0;
 	kfree(firmw_ver);
@@ -757,7 +756,7 @@ static int __devinit probe_gdrom(struct platform_device *devptr)
 	int err;
 	/* Start the device */
 	if (gdrom_execute_diagnostic() != 1) {
-		printk(KERN_WARNING "GDROM: ATA Probe for GDROM failed.\n");
+		pr_warning("ATA Probe for GDROM failed\n");
 		return -ENODEV;
 	}
 	/* Print out firmware ID */
@@ -767,7 +766,7 @@ static int __devinit probe_gdrom(struct platform_device *devptr)
 	gdrom_major = register_blkdev(0, GDROM_DEV_NAME);
 	if (gdrom_major <= 0)
 		return gdrom_major;
-	printk(KERN_INFO "GDROM: Registered with major number %d\n",
+	pr_info("Registered with major number %d\n",
 		gdrom_major);
 	/* Specify basic properties of drive */
 	gd.cd_info = kzalloc(sizeof(struct cdrom_device_info), GFP_KERNEL);
@@ -818,7 +817,7 @@ probe_fail_no_disk:
 	unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
 	gdrom_major = 0;
 probe_fail_no_mem:
-	printk(KERN_WARNING "GDROM: Probe failed - error is 0x%X\n", err);
+	pr_warning("Probe failed - error is 0x%X\n", err);
 	return err;
 }
 
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index 451cd70..1b14fa5 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -31,6 +31,8 @@
  * the OS/400 partition.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/major.h>
 #include <linux/blkdev.h>
 #include <linux/cdrom.h>
@@ -53,9 +55,6 @@
 
 #define VIOCD_VERS "1.06"
 
-#define VIOCD_KERN_WARNING		KERN_WARNING "viocd: "
-#define VIOCD_KERN_INFO			KERN_INFO "viocd: "
-
 /*
  * Should probably make this a module parameter....sigh
  */
@@ -202,9 +201,8 @@ static int viocd_open(struct cdrom_device_info *cdi, int purpose)
 			(u64)&we, VIOVERSION << 16, ((u64)device_no << 48),
 			0, 0, 0);
 	if (hvrc != 0) {
-		printk(VIOCD_KERN_WARNING
-				"bad rc on HvCallEvent_signalLpEventFast %d\n",
-				(int)hvrc);
+		pr_warning("bad rc on HvCallEvent_signalLpEventFast %d\n",
+			   (int)hvrc);
 		return -EIO;
 	}
 
@@ -213,8 +211,8 @@ static int viocd_open(struct cdrom_device_info *cdi, int purpose)
 	if (we.rc) {
 		const struct vio_error_entry *err =
 			vio_lookup_rc(viocd_err_table, we.sub_result);
-		printk(VIOCD_KERN_WARNING "bad rc %d:0x%04X on open: %s\n",
-				we.rc, we.sub_result, err->msg);
+		pr_warning("bad rc %d:0x%04X on open: %s\n",
+			   we.rc, we.sub_result, err->msg);
 		return -err->errno;
 	}
 
@@ -234,9 +232,8 @@ static void viocd_release(struct cdrom_device_info *cdi)
 			viopath_targetinst(viopath_hostLp), 0,
 			VIOVERSION << 16, ((u64)device_no << 48), 0, 0, 0);
 	if (hvrc != 0)
-		printk(VIOCD_KERN_WARNING
-				"bad rc on HvCallEvent_signalLpEventFast %d\n",
-				(int)hvrc);
+		pr_warning("bad rc on HvCallEvent_signalLpEventFast %d\n",
+			   (int)hvrc);
 }
 
 /* Send a read or write request to OS/400 */
@@ -262,13 +259,12 @@ static int send_request(struct request *req)
 
 	sg_init_table(&sg, 1);
         if (blk_rq_map_sg(req->q, req, &sg) == 0) {
-		printk(VIOCD_KERN_WARNING
-				"error setting up scatter/gather list\n");
+		pr_warning("error setting up scatter/gather list\n");
 		return -1;
 	}
 
 	if (dma_map_sg(diskinfo->dev, &sg, 1, direction) == 0) {
-		printk(VIOCD_KERN_WARNING "error allocating sg tce\n");
+		pr_warning("error allocating sg tce\n");
 		return -1;
 	}
 	dmaaddr = sg_dma_address(&sg);
@@ -284,7 +280,7 @@ static int send_request(struct request *req)
 			((u64)DEVICE_NR(diskinfo) << 48) | dmaaddr,
 			(u64)blk_rq_pos(req) * 512, len, 0);
 	if (hvrc != HvLpEvent_Rc_Good) {
-		printk(VIOCD_KERN_WARNING "hv error on op %d\n", (int)hvrc);
+		pr_warning("hv error on op %d\n", (int)hvrc);
 		return -1;
 	}
 
@@ -301,8 +297,7 @@ static void do_viocd_request(struct request_queue *q)
 		if (!blk_fs_request(req))
 			__blk_end_request_all(req, -EIO);
 		else if (send_request(req) < 0) {
-			printk(VIOCD_KERN_WARNING
-					"unable to send message to OS/400!");
+			pr_warning("unable to send message to OS/400!\n");
 			__blk_end_request_all(req, -EIO);
 		} else
 			rwreq++;
@@ -327,8 +322,8 @@ static int viocd_media_changed(struct cdrom_device_info *cdi, int disc_nr)
 			(u64)&we, VIOVERSION << 16, ((u64)device_no << 48),
 			0, 0, 0);
 	if (hvrc != 0) {
-		printk(VIOCD_KERN_WARNING "bad rc on HvCallEvent_signalLpEventFast %d\n",
-				(int)hvrc);
+		pr_warning("bad rc on HvCallEvent_signalLpEventFast %d\n",
+			   (int)hvrc);
 		return -EIO;
 	}
 
@@ -338,9 +333,8 @@ static int viocd_media_changed(struct cdrom_device_info *cdi, int disc_nr)
 	if (we.rc) {
 		const struct vio_error_entry *err =
 			vio_lookup_rc(viocd_err_table, we.sub_result);
-		printk(VIOCD_KERN_WARNING
-				"bad rc %d:0x%04X on check_change: %s; Assuming no change\n",
-				we.rc, we.sub_result, err->msg);
+		pr_warning("bad rc %d:0x%04X on check_change: %s; Assuming no change\n",
+			   we.rc, we.sub_result, err->msg);
 		return 0;
 	}
 
@@ -367,8 +361,8 @@ static int viocd_lock_door(struct cdrom_device_info *cdi, int locking)
 			(u64)&we, VIOVERSION << 16,
 			(device_no << 48) | (flags << 32), 0, 0, 0);
 	if (hvrc != 0) {
-		printk(VIOCD_KERN_WARNING "bad rc on HvCallEvent_signalLpEventFast %d\n",
-				(int)hvrc);
+		pr_warning("bad rc on HvCallEvent_signalLpEventFast %d\n",
+			   (int)hvrc);
 		return -EIO;
 	}
 
@@ -455,8 +449,7 @@ static void vio_handle_cd_event(struct HvLpEvent *event)
 		return;
 	/* First, we should NEVER get an int here...only acks */
 	if (hvlpevent_is_int(event)) {
-		printk(VIOCD_KERN_WARNING
-				"Yikes! got an int in viocd event handler!\n");
+		pr_warning("Yikes! got an int in viocd event handler!\n");
 		if (hvlpevent_need_ack(event)) {
 			event->xRc = HvLpEvent_Rc_InvalidSubtype;
 			HvCallEvent_ackLpEvent(event);
@@ -510,10 +503,9 @@ return_complete:
 			const struct vio_error_entry *err =
 				vio_lookup_rc(viocd_err_table,
 						bevent->sub_result);
-			printk(VIOCD_KERN_WARNING "request %p failed "
-					"with rc %d:0x%04X: %s\n",
-					req, event->xRc,
-					bevent->sub_result, err->msg);
+			pr_warning("request %p failed with rc %d:0x%04X: %s\n",
+				   req, event->xRc,
+				   bevent->sub_result, err->msg);
 			__blk_end_request_all(req, -EIO);
 		} else
 			__blk_end_request_all(req, 0);
@@ -524,9 +516,8 @@ return_complete:
 		break;
 
 	default:
-		printk(VIOCD_KERN_WARNING
-				"message with invalid subtype %0x04X!\n",
-				event->xSubtype & VIOMINOR_SUBTYPE_MASK);
+		pr_warning("message with invalid subtype %0x04X!\n",
+			   event->xSubtype & VIOMINOR_SUBTYPE_MASK);
 		if (hvlpevent_need_ack(event)) {
 			event->xRc = HvLpEvent_Rc_InvalidSubtype;
 			HvCallEvent_ackLpEvent(event);
@@ -593,23 +584,19 @@ static int viocd_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	sprintf(c->name, VIOCD_DEVICE "%c", 'a' + deviceno);
 
 	if (register_cdrom(c) != 0) {
-		printk(VIOCD_KERN_WARNING "Cannot register viocd CD-ROM %s!\n",
-				c->name);
+		pr_warning("Cannot register viocd CD-ROM %s!\n", c->name);
 		goto out;
 	}
-	printk(VIOCD_KERN_INFO "cd %s is iSeries resource %10.10s "
-			"type %4.4s, model %3.3s\n",
-			c->name, d->rsrcname, d->type, d->model);
+	pr_info("cd %s is iSeries resource %10.10s type %4.4s, model %3.3s\n",
+		c->name, d->rsrcname, d->type, d->model);
 	q = blk_init_queue(do_viocd_request, &viocd_reqlock);
 	if (q == NULL) {
-		printk(VIOCD_KERN_WARNING "Cannot allocate queue for %s!\n",
-				c->name);
+		pr_warning("Cannot allocate queue for %s!\n", c->name);
 		goto out_unregister_cdrom;
 	}
 	gendisk = alloc_disk(1);
 	if (gendisk == NULL) {
-		printk(VIOCD_KERN_WARNING "Cannot create gendisk for %s!\n",
-				c->name);
+		pr_warning("Cannot create gendisk for %s!\n", c->name);
 		goto out_cleanup_queue;
 	}
 	gendisk->major = VIOCD_MAJOR;
@@ -682,21 +669,19 @@ static int __init viocd_init(void)
 			return -ENODEV;
 	}
 
-	printk(VIOCD_KERN_INFO "vers " VIOCD_VERS ", hosting partition %d\n",
-			viopath_hostLp);
+	pr_info("vers " VIOCD_VERS ", hosting partition %d\n", viopath_hostLp);
 
 	if (register_blkdev(VIOCD_MAJOR, VIOCD_DEVICE) != 0) {
-		printk(VIOCD_KERN_WARNING "Unable to get major %d for %s\n",
-				VIOCD_MAJOR, VIOCD_DEVICE);
+		pr_warning("Unable to get major %d for %s\n",
+			   VIOCD_MAJOR, VIOCD_DEVICE);
 		return -EIO;
 	}
 
 	ret = viopath_open(viopath_hostLp, viomajorsubtype_cdio,
 			MAX_CD_REQ + 2);
 	if (ret) {
-		printk(VIOCD_KERN_WARNING
-				"error opening path to host partition %d\n",
-				viopath_hostLp);
+		pr_warning("error opening path to host partition %d\n",
+			   viopath_hostLp);
 		goto out_unregister;
 	}
 


