Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab1JAOFv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 10:05:51 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35861 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab1JAOFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 10:05:44 -0400
Subject: Re: [PATCHv9] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: David Wagner <david.wagner@free-electrons.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Ricard Wanderlof <ricard.wanderlof@axis.com>,
        Arnd Bergmann <arnd@arndb.de>
Date: Sat, 01 Oct 2011 17:08:44 +0300
In-Reply-To: <1317048049-19391-1-git-send-email-david.wagner@free-electrons.com>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
	 <1317048049-19391-1-git-send-email-david.wagner@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317478130.19426.151.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 16:40 +0200, David Wagner wrote:
> ubiblk is a read-only block layer on top of UBI.  It presents UBI volumes as
> read-only block devices (named ubiblkX_Y, where X is the UBI device number
> and Y the Volume ID).
> 
> It is used by putting a block filesystem image on a UBI volume, creating the
> corresponding ubiblk device and then mounting it.
> 
> It uses the UBI API to register to UBI notifications and to read from the
> volumes.  It also creates a ubiblk_ctrl device node that simply receives ioctl
> from a userspace tool for creating/removing ubiblk devices.
> 
> Some code is taken from mtd_blkdevs and gluebi.  Some code for the ioctl part is
> also inspired from ubi's core.
> 
> Advantages of ubiblk over gluebi+mtdblock_ro:

I do not have enough time to nicely answer with comments, so here is
just some patch with my cosmetic changes plus I added "TODO:" items here
and there. Please, apply it and resolve the TODO items, if you can, ok?

diff --git a/drivers/mtd/ubi/ubiblk.c b/drivers/mtd/ubi/ubiblk.c
index ccb22de..2da46fe 100644
--- a/drivers/mtd/ubi/ubiblk.c
+++ b/drivers/mtd/ubi/ubiblk.c
@@ -40,7 +40,7 @@
 #define BLK_SIZE 512
 
 /**
- * struct ubiblk_dev - represents a ubiblk device, proxying a UBI volume
+ * struct ubiblk_dev - represents a ubiblk device, proxying a UBI volume.
  * @desc: open UBI volume descriptor
  * @vi: UBI volume information
  * @ubi_num: UBI device number
@@ -49,25 +49,25 @@
  * @gd: the disk (block device) created by ubiblk
  * @rq: the request queue to @gd
  * @req_task: the thread processing @rq requests
+TODO: vol_lock is bad name, not clean what it protects, the below comment is
+also vague
  * @vol_lock: protects write access to the elements of this structure
- * @queue_lock: avoids concurrent accesses to the request queue
- * @list: linked list structure
+ * @queue_lock: protects the request queue
+ * @list: links &struct ubiblk_dev objects
  */
 struct ubiblk_dev {
+/* TODO: let's name this structure ubiblk_info, to be consistent with UBI's
+ * naming conventions. */
 	struct ubi_volume_desc *desc;
 	struct ubi_volume_info *vi;
 	int ubi_num;
 	int vol_id;
 	int refcnt;
-
 	struct gendisk *gd;
 	struct request_queue *rq;
 	struct task_struct *req_task;
-
 	struct mutex vol_lock;
-
 	spinlock_t queue_lock;
-
 	struct list_head list;
 };
 
@@ -105,24 +105,23 @@ static struct ubiblk_dev *find_dev(struct ubi_volume_info *vi)
 }
 
 /**
- * do_ubiblk_request - Read a LEB and fill the request buffer with the
- * requested sector.
+ * do_request - fill the request buffer by reading the UBI volume.
  * @req: the request data structure
  * @dev: the ubiblk device on which the request is issued
+ *
+ * Returns zero in case of success and a negative error code in case of
+ * failure.
  */
-static int do_ubiblk_request(struct request *req, struct ubiblk_dev *dev)
+static int do_request(struct request *req, struct ubiblk_dev *dev)
+/* TODO: if struct ubiblk_dev becomes struct ubiblk_info, how about to
+ * name all variables of this type "inf"? */
 {
 	unsigned long start, len, read_bytes;
-	int offset;
-	int leb;
-	int ret;
+	int offset, leb, ret;
 
 	start = blk_rq_pos(req) << 9;
 	len = blk_rq_cur_bytes(req);
 	read_bytes = 0;
-
-	/* We are always reading. No need to handle writing for now */
-
 	leb = start / dev->vi->usable_leb_size;
 	offset = start % dev->vi->usable_leb_size;
 
@@ -130,31 +129,34 @@ static int do_ubiblk_request(struct request *req, struct ubiblk_dev *dev)
 		if (offset + len > dev->vi->usable_leb_size)
 			len = dev->vi->usable_leb_size - offset;
 
-		if (unlikely(blk_rq_pos(req) + blk_rq_cur_sectors(req) >
-		    get_capacity(req->rq_disk))) {
+		if (blk_rq_pos(req) + blk_rq_cur_sectors(req) >
+		    get_capacity(req->rq_disk)) {
+			/*
+			 * TODO: snitize the error message, e.g.,
+			 * "cannot read sector %llu beyond device size %llu"
+			 */
 			dev_err(disk_to_dev(dev->gd),
 				"attempting to read too far\n");
+			/*
+			 * TODO: hmm, is -EIO the right error? What other block
+			 * devices return in this case? Any specific pointer
+			 * please?
+			 */
 			return -EIO;
 		}
 
-		/* Read (len) bytes of LEB (leb) from (offset) and put the
-		 * result in the buffer given by the request.
-		 * If the request is overlapping on several lebs, (read_bytes)
-		 * will be > 0 and the data will be put in the buffer at
-		 * offset (read_bytes)
-		 */
-		ret = ubi_read(dev->desc, leb, req->buffer + read_bytes,
-			       offset, len);
-
+		ret = ubi_read(dev->desc, leb, req->buffer + read_bytes, offset,
+			       len);
 		if (ret) {
-			dev_err(disk_to_dev(dev->gd), "ubi_read error\n");
+			dev_err(disk_to_dev(dev->gd),
+				"can't read %d bytes from LEB %d:%d, error %d\n",
+				len, leb, offset, ret);
 			return ret;
 		}
 
 		read_bytes += len;
-
 		len = blk_rq_cur_bytes(req) - read_bytes;
-		leb++;
+		leb += 1;
 		offset = 0;
 	} while (read_bytes < blk_rq_cur_bytes(req));
 
@@ -162,38 +164,34 @@ static int do_ubiblk_request(struct request *req, struct ubiblk_dev *dev)
 }
 
 /**
- * ubiblk_request - wakes the processing thread
- * @rq: the request queue which device is to be awaken
+ * ubiblk_request - wakes the processing thread.
+ * @rq: the request queue which requires processing
  */
+/* TODO: bad name, may be wakeup_req_thread() would be better? */
 static void ubiblk_request(struct request_queue *rq)
 {
 	struct ubiblk_dev *dev;
 	struct request *req;
 
 	dev = rq->queuedata;
-
-	if (!dev)
+	if (dev)
+		wake_up_process(dev->req_task);
+	else {
+		/* TODO: an error message or WARN here ? */
 		while ((req = blk_fetch_request(rq)) != NULL)
 			__blk_end_request_all(req, -ENODEV);
-	else
-		wake_up_process(dev->req_task);
+	}
 }
 
-/**
- * ubiblk_open - open a UBI volume (get the volume descriptor).
- * @bdev: the corresponding block device
- * @mode: opening mode (don't care as long as ubiblk is read-only)
- */
 static int ubiblk_open(struct block_device *bdev, fmode_t mode)
 {
 	struct ubiblk_dev *dev = bdev->bd_disk->private_data;
 	int err;
 
 	mutex_lock(&dev->vol_lock);
-	dev_dbg(disk_to_dev(dev->gd), "open(); refcnt = %d\n", dev->refcnt);
 	if (dev->refcnt > 0) {
 		/*
-		 * The volume is already opened ; just increase the reference
+		 * The volume is already opened, just increase the reference
 		 * counter.
 		 */
 		dev->refcnt++;
@@ -201,11 +199,12 @@ static int ubiblk_open(struct block_device *bdev, fmode_t mode)
 		return 0;
 	}
 
-	dev->desc = ubi_open_volume(dev->ubi_num, dev->vol_id,
-					UBI_READONLY);
+	dev->desc = ubi_open_volume(dev->ubi_num, dev->vol_id, UBI_READONLY);
 	if (IS_ERR(dev->desc)) {
+		/* TODO: Failed to open what? which volume? Why not to print
+		 * full information? Could you please go through _all_ error
+		 * message and assess them WRT niceness to the user? */
 		dev_err(disk_to_dev(dev->gd), "failed to open");
-
 		err = PTR_ERR(dev->desc);
 		dev->desc = NULL;
 		goto out_unlock;
@@ -219,7 +218,6 @@ static int ubiblk_open(struct block_device *bdev, fmode_t mode)
 	ubi_get_volume_info(dev->desc, dev->vi);
 
 	dev->refcnt++;
-	dev_dbg(disk_to_dev(dev->gd), "opened mode=%d\n", mode);
 	mutex_unlock(&dev->vol_lock);
 	return 0;
 
@@ -231,38 +229,30 @@ out_unlock:
 	return err;
 }
 
-/**
- * ubiblk_release - close a UBI volume (close the volume descriptor).
- * @gd: the disk that was previously opened
- * @mode: don't care
- */
 static int ubiblk_release(struct gendisk *gd, fmode_t mode)
 {
 	struct ubiblk_dev *dev = gd->private_data;
 
 	mutex_lock(&dev->vol_lock);
-	dev_dbg(disk_to_dev(dev->gd), "release(); refcnt = %d\n", dev->refcnt);
-
 	dev->refcnt--;
 	if (dev->refcnt == 0) {
 		kfree(dev->vi);
 		dev->vi = NULL;
-
 		ubi_close_volume(dev->desc);
 		dev->desc = NULL;
-
-		dev_dbg(disk_to_dev(dev->gd), "released, mode=%d\n", mode);
 	}
-
 	mutex_unlock(&dev->vol_lock);
+
 	return 0;
 }
 
 /**
- * ubiblk_thread - loop on the block request queue and wait for new
- * requests ; run them with do_ubiblk_request(). Mostly copied from
- * mtd_blkdevs.c.
+ * ubiblk_thread - dispatch UBI requests.
  * @arg: the ubiblk device which request queue to process
+ *
+ * This function loops on the block request queue and waits for new requests.
+ * Returns zero in case of success and a negative error code in case of
+ * failure.
  */
 static int ubiblk_thread(void *arg)
 {
@@ -270,8 +260,9 @@ static int ubiblk_thread(void *arg)
 	struct request_queue *rq = dev->rq;
 	struct request *req = NULL;
 
+	/* TODO: I doubt you need to disable IRQs because you do not have any
+	 * of them! Please, investigate this. */
 	spin_lock_irq(rq->queue_lock);
-
 	while (!kthread_should_stop()) {
 		int res;
 
@@ -282,40 +273,37 @@ static int ubiblk_thread(void *arg)
 
 			if (kthread_should_stop())
 				set_current_state(TASK_RUNNING);
-
 			spin_unlock_irq(rq->queue_lock);
+
 			schedule();
+
 			spin_lock_irq(rq->queue_lock);
 			continue;
 		}
-
 		spin_unlock_irq(rq->queue_lock);
 
 		mutex_lock(&dev->vol_lock);
-		res = do_ubiblk_request(req, dev);
+		res = do_request(req, dev);
 		mutex_unlock(&dev->vol_lock);
 
 		spin_lock_irq(rq->queue_lock);
-
 		if (!__blk_end_request_cur(req, res))
-			req = NULL;
+		req = NULL;
 	}
 
 	if (req)
 		__blk_end_request_all(req, -EIO);
-
 	spin_unlock_irq(rq->queue_lock);
 
 	return 0;
 }
 
 /**
- * ubiblk_create - create a ubiblk device proxying a UBI volume.
+ * ubiblk_create - create a ubiblk device.
  * @vi: the UBI volume information data structure
  *
- * An UBI volume has been created ; create a corresponding ubiblk device:
- * Initialize the locks, the structure, the block layer infos and start a
- * req_task.
+ * Creates a ubiblk device for UBI volume described by @vi. Returns zero in
+ * case of success and a negative error code in case of failure.
  */
 static int ubiblk_create(struct ubi_volume_info *vi)
 {
@@ -371,16 +359,14 @@ static int ubiblk_create(struct ubi_volume_info *vi)
 	blk_queue_logical_block_size(dev->rq, BLK_SIZE);
 	dev->gd->queue = dev->rq;
 
-	/* Borrowed from mtd_blkdevs.c */
-	/* Create processing req_task
-	 *
+	/*
 	 * The processing of the request has to be done in process context (it
-	 * might sleep) but blk_run_queue can't block ; so we need to separate
+	 * might sleep) but blk_run_queue can't block; so we need to separate
 	 * the event of a request being added to the queue (which triggers the
 	 * callback ubiblk_request - that is set with blk_init_queue())
 	 * and the processing of that request.
 	 *
-	 * Thus, the sole purpose of ubi_ubiblk_reuqest is to wake the kthread
+	 * Thus, the sole purpose of ubiblk_request is to wake the kthread
 	 * up so that it will process the request queue
 	 */
 	dev->req_task = kthread_run(ubiblk_thread, dev, "%s%d_%d",
@@ -396,7 +382,6 @@ static int ubiblk_create(struct ubi_volume_info *vi)
 	dev_info(disk_to_dev(dev->gd),
 		 "created from ubi%d:%d(%s)\n", dev->ubi_num, dev->vol_id,
 		 vi->name);
-
 	mutex_unlock(&devlist_lock);
 
 	return 0;
@@ -417,15 +402,14 @@ out_unlock:
  * ubiblk_remove - destroy a ubiblk device.
  * @vi: the UBI volume information data structure
  *
- * A UBI volume has been removed or we are requested to unproxify a volume ;
- * destroy the corresponding ubiblk device.
+ * Destroys the ubiblk device for UBI volume described by @vi. Returns zero in
+ * case of success and a negative error code in case of failure.
  */
 static int ubiblk_remove(struct ubi_volume_info *vi)
 {
 	struct ubiblk_dev *dev;
 
 	mutex_lock(&devlist_lock);
-
 	dev = find_dev(vi);
 	if (!dev) {
 		mutex_unlock(&devlist_lock);
@@ -445,7 +429,6 @@ static int ubiblk_remove(struct ubi_volume_info *vi)
 	blk_cleanup_queue(dev->rq);
 	kthread_stop(dev->req_task);
 	put_disk(dev->gd);
-
 	list_del(&dev->list);
 	mutex_unlock(&dev->vol_lock);
 	mutex_unlock(&devlist_lock);
@@ -459,17 +442,15 @@ static int ubiblk_remove(struct ubi_volume_info *vi)
  * ubiblk_resize - resize a ubiblk device.
  * @vi: the UBI volume information data structure
  *
- * A UBI volume has been resized, change the ubiblk device geometry accordingly.
+ * A UBI volume has been resized, change the ubiblk device geometry
+ * accordingly. Returns zero in case of success and a negative error code in
+ * case of failure.
  */
 static int ubiblk_resize(struct ubi_volume_info *vi)
 {
 	struct ubiblk_dev *dev;
 	int disk_capacity;
 
-	/* We don't touch the list, but we better lock it: it could be that the
-	 * device gets removed between the time the device has been found and
-	 * the time we access dev->gd
-	 */
 	mutex_lock(&devlist_lock);
 	dev = find_dev(vi);
 	if (!dev) {
@@ -482,10 +463,9 @@ static int ubiblk_resize(struct ubi_volume_info *vi)
 	mutex_lock(&dev->vol_lock);
 	disk_capacity = (vi->size * vi->usable_leb_size) >> 9;
 	set_capacity(dev->gd, disk_capacity);
-	dev_dbg(disk_to_dev(dev->gd), "resized to %d LEBs\n", vi->size);
 	mutex_unlock(&dev->vol_lock);
-
 	mutex_unlock(&devlist_lock);
+
 	return 0;
 }
 
-- 
Best Regards,
Artem Bityutskiy

