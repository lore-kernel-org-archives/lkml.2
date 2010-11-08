Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0KHQzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:55:20 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24361 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab0KHQzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 11:55:19 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 08 Nov 2010 17:53:45 +0100
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: gadget: f_mass_storage: Fix empty device release callback
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <a3624b7b110810a682108669dfa6cf1d3b65b94f.1289229255.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit replaces an empty device releases callback with
one that uses reference counter to free underlying memory
only when the device is no longer used.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
---
 drivers/usb/gadget/f_mass_storage.c |   87 +++++++++++++++++++++++------------
 1 files changed, 57 insertions(+), 30 deletions(-)

This is put on top of the other 7 patches I sent earlier.

Noticed this after the put_device() fix, turns out 9-hour flight is
just perfect for fixing bugs (that, plus movies were boring).

Greg,

It seems it does not qualify for stable (too long); if you decide to pull
it into stable anyway (since a lot changes are just a simple
s/luns/luns->arr/) drop me a line so I'll rebase it.

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index b5dbb23..a3f7e71 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -349,9 +349,6 @@ struct fsg_common {
 	struct fsg_dev		*fsg, *new_fsg;
 	wait_queue_head_t	fsg_wait;
 
-	/* filesem protects: backing files in use */
-	struct rw_semaphore	filesem;
-
 	/* lock protects: state, all the req_busy's */
 	spinlock_t		lock;
 
@@ -368,7 +365,12 @@ struct fsg_common {
 
 	unsigned int		nluns;
 	unsigned int		lun;
-	struct fsg_lun		*luns;
+	struct fsg_luns {
+		/* filesem protects: backing files in use */
+		struct rw_semaphore	filesem;
+		struct kref		ref;
+		struct fsg_lun		arr[];
+	}			*luns;
 	struct fsg_lun		*curlun;
 
 	unsigned int		bulk_out_maxpacket;
@@ -1465,22 +1467,22 @@ static int do_start_stop(struct fsg_common *common)
 	/* Simulate an unload/eject */
 	if (common->ops && common->ops->pre_eject) {
 		int r = common->ops->pre_eject(common, curlun,
-					       curlun - common->luns);
+					       curlun - common->luns->arr);
 		if (unlikely(r < 0))
 			return r;
 		else if (r)
 			return 0;
 	}
 
-	up_read(&common->filesem);
-	down_write(&common->filesem);
+	up_read(&common->luns->filesem);
+	down_write(&common->luns->filesem);
 	fsg_lun_close(curlun);
-	up_write(&common->filesem);
-	down_read(&common->filesem);
+	up_write(&common->luns->filesem);
+	down_read(&common->luns->filesem);
 
 	return common->ops && common->ops->post_eject
 		? min(0, common->ops->post_eject(common, curlun,
-						 curlun - common->luns))
+						 curlun - common->luns->arr))
 		: 0;
 }
 
@@ -1910,7 +1912,7 @@ static int check_command(struct fsg_common *common, int cmnd_size,
 
 	/* Check the LUN */
 	if (common->lun >= 0 && common->lun < common->nluns) {
-		curlun = &common->luns[common->lun];
+		curlun = &common->luns->arr[common->lun];
 		common->curlun = curlun;
 		if (common->cmnd[0] != REQUEST_SENSE) {
 			curlun->sense_data = SS_NO_SENSE;
@@ -1986,7 +1988,8 @@ static int do_scsi_command(struct fsg_common *common)
 	common->phase_error = 0;
 	common->short_packet_received = 0;
 
-	down_read(&common->filesem);	/* We're using the backing file */
+	/* We're using the backing file */
+	down_read(&common->luns->filesem);
 	switch (common->cmnd[0]) {
 
 	case INQUIRY:
@@ -2219,7 +2222,7 @@ unknown_cmnd:
 		}
 		break;
 	}
-	up_read(&common->filesem);
+	up_read(&common->luns->filesem);
 
 	if (reply == -EINTR || signal_pending(current))
 		return -EINTR;
@@ -2455,7 +2458,7 @@ reset:
 
 	common->running = 1;
 	for (i = 0; i < common->nluns; ++i)
-		common->luns[i].unit_attention_data = SS_RESET_OCCURRED;
+		common->luns->arr[i].unit_attention_data = SS_RESET_OCCURRED;
 	return rc;
 }
 
@@ -2555,7 +2558,7 @@ static void handle_exception(struct fsg_common *common)
 		common->state = FSG_STATE_STATUS_PHASE;
 	else {
 		for (i = 0; i < common->nluns; ++i) {
-			curlun = &common->luns[i];
+			curlun = &common->luns->arr[i];
 			curlun->prevent_medium_removal = 0;
 			curlun->sense_data = SS_NO_SENSE;
 			curlun->unit_attention_data = SS_NO_SENSE;
@@ -2597,7 +2600,7 @@ static void handle_exception(struct fsg_common *common)
 		 * CONFIG_CHANGE cases.
 		 */
 		/* for (i = 0; i < common->nluns; ++i) */
-		/*	common->luns[i].unit_attention_data = */
+		/*	common->luns->arr[i].unit_attention_data = */
 		/*		SS_RESET_OCCURRED;  */
 		break;
 
@@ -2692,10 +2695,10 @@ static int fsg_main_thread(void *common_)
 
 	if (!common->ops || !common->ops->thread_exits
 	 || common->ops->thread_exits(common) < 0) {
-		struct fsg_lun *curlun = common->luns;
+		struct fsg_lun *curlun = common->luns->arr;
 		unsigned i = common->nluns;
 
-		down_write(&common->filesem);
+		down_write(&common->luns->filesem);
 		for (; i--; ++curlun) {
 			if (!fsg_lun_is_open(curlun))
 				continue;
@@ -2703,7 +2706,7 @@ static int fsg_main_thread(void *common_)
 			fsg_lun_close(curlun);
 			curlun->unit_attention_data = SS_MEDIUM_NOT_PRESENT;
 		}
-		up_write(&common->filesem);
+		up_write(&common->luns->filesem);
 	}
 
 	/* Let fsg_unbind() know the thread has exited */
@@ -2723,9 +2726,30 @@ static DEVICE_ATTR(file, 0644, fsg_show_file, fsg_store_file);
 
 static void fsg_common_release(struct kref *ref);
 
+static void fsg_luns_release(struct kref *ref)
+{
+	struct fsg_luns *luns = container_of(ref, struct fsg_luns, ref);
+	kfree(luns);
+}
+
 static void fsg_lun_release(struct device *dev)
 {
-	/* Nothing needs to be done */
+	struct rw_semaphore *filesem = dev_get_drvdata(dev);
+	struct fsg_luns *luns =
+		container_of(filesem, struct fsg_luns, filesem);
+
+	/*
+	 * This should be a no-op but something funky may have
+	 * happened and the file may have been opened.  Make sure and
+	 * coles it.
+	 */
+	fsg_lun_close(container_of(dev, struct fsg_lun, dev));
+
+	/*
+	 * When all devices are released, the under-laying memory with
+	 * accompanying filesem will be freed.
+	 */
+	kref_put(&luns->ref, fsg_luns_release);
 }
 
 static inline void fsg_common_get(struct fsg_common *common)
@@ -2787,14 +2811,16 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 	 * Create the LUNs, open their backing files, and register the
 	 * LUN devices in sysfs.
 	 */
-	curlun = kzalloc(nluns * sizeof *curlun, GFP_KERNEL);
-	if (unlikely(!curlun)) {
+	common->luns = kzalloc(sizeof *common->luns +
+			       nluns * sizeof *common->luns->arr, GFP_KERNEL);
+	if (unlikely(!common->luns)) {
 		rc = -ENOMEM;
 		goto error_release;
 	}
-	common->luns = curlun;
+	curlun = common->luns->arr;
 
-	init_rwsem(&common->filesem);
+	init_rwsem(&common->luns->filesem);
+	kref_init(&common->luns->ref);
 
 	for (i = 0, lcfg = cfg->luns; i < nluns; ++i, ++curlun, ++lcfg) {
 		curlun->cdrom = !!lcfg->cdrom;
@@ -2803,13 +2829,14 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 		curlun->dev.release = fsg_lun_release;
 		curlun->dev.parent = &gadget->dev;
 		/* curlun->dev.driver = &fsg_driver.driver; XXX */
-		dev_set_drvdata(&curlun->dev, &common->filesem);
+		dev_set_drvdata(&curlun->dev, &common->luns->filesem);
 		dev_set_name(&curlun->dev,
 			     cfg->lun_name_format
 			   ? cfg->lun_name_format
 			   : "lun%d",
 			     i);
 
+		kref_get(&common->luns->ref);
 		rc = device_register(&curlun->dev);
 		if (rc) {
 			INFO(common, "failed to register LUN%d: %d\n", i, rc);
@@ -2872,7 +2899,7 @@ buffhds_first_it:
 	snprintf(common->inquiry_string, sizeof common->inquiry_string,
 		 "%-8s%-16s%04x", cfg->vendor_name ?: "Linux",
 		 /* Assume product name dependent on the first LUN */
-		 cfg->product_name ?: (common->luns->cdrom
+		 cfg->product_name ?: (common->luns->arr->cdrom
 				     ? "File-Stor Gadget"
 				     : "File-CD Gadget"),
 		 i);
@@ -2904,7 +2931,7 @@ buffhds_first_it:
 	INFO(common, "Number of LUNs=%d\n", common->nluns);
 
 	pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
-	for (i = 0, nluns = common->nluns, curlun = common->luns;
+	for (i = 0, nluns = common->nluns, curlun = common->luns->arr;
 	     i < nluns;
 	     ++curlun, ++i) {
 		char *p = "(no medium)";
@@ -2950,8 +2977,8 @@ static void fsg_common_release(struct kref *ref)
 		wait_for_completion(&common->thread_notifier);
 	}
 
-	if (likely(common->luns)) {
-		struct fsg_lun *lun = common->luns;
+	if (likely(common->luns->arr)) {
+		struct fsg_lun *lun = common->luns->arr;
 		unsigned i = common->nluns;
 
 		/* In error recovery common->nluns may be zero. */
@@ -2963,7 +2990,7 @@ static void fsg_common_release(struct kref *ref)
 			device_unregister(&lun->dev);
 		}
 
-		kfree(common->luns);
+		kref_put(&common->luns->ref, fsg_luns_release);
 	}
 
 	{
-- 
1.7.2.3

