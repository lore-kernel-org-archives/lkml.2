Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab2KJQI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 11:08:59 -0500
Received: from mail-ye0-f174.google.com ([209.85.213.174]:59804 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab2KJQI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 11:08:58 -0500
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-mtd@lists.infradead.org>
Cc: <linux-kernel@vger.kernel.org>, Ezequiel Garcia <elezegarcia@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: [RFC/PATCH] mtd_blkdevs: Replace request handler kthread with a workqueue
Date: Sat, 10 Nov 2012 13:08:20 -0300
Message-Id: <1352563700-5268-1-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By replacing a kthread with a workqueue, the code is now a bit clearer.
There's also a slight reduction of code size (numbers apply for x86):
Before:
   text	   data	    bss	    dec	    hex	filename
   3248	     36	      0	   3284	    cd4	drivers/mtd/mtd_blkdevs.o

After:
   text	   data	    bss	    dec	    hex	filename
   3150	     36	      0	   3186	    c72	drivers/mtd/mtd_blkdevs.o

Due to lack of real hardware, tests have been performed on an emulated
environment with mtdswap and mtdblock over nandsim devices.
Some real testing should be done, before merging this patch.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/mtd/mtd_blkdevs.c    |   47 +++++++++++++----------------------------
 include/linux/mtd/blktrans.h |    4 ++-
 2 files changed, 18 insertions(+), 33 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index f1f0671..ba375ba 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -32,7 +32,6 @@
 #include <linux/hdreg.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
-#include <linux/kthread.h>
 #include <asm/uaccess.h>
 
 #include "mtdcore.h"
@@ -121,16 +120,14 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 
 int mtd_blktrans_cease_background(struct mtd_blktrans_dev *dev)
 {
-	if (kthread_should_stop())
-		return 1;
-
 	return dev->bg_stop;
 }
 EXPORT_SYMBOL_GPL(mtd_blktrans_cease_background);
 
-static int mtd_blktrans_thread(void *arg)
+static void mtd_blktrans_work(struct work_struct *work)
 {
-	struct mtd_blktrans_dev *dev = arg;
+	struct mtd_blktrans_dev *dev =
+		container_of(work, struct mtd_blktrans_dev, work);
 	struct mtd_blktrans_ops *tr = dev->tr;
 	struct request_queue *rq = dev->rq;
 	struct request *req = NULL;
@@ -138,7 +135,7 @@ static int mtd_blktrans_thread(void *arg)
 
 	spin_lock_irq(rq->queue_lock);
 
-	while (!kthread_should_stop()) {
+	while (1) {
 		int res;
 
 		dev->bg_stop = false;
@@ -156,15 +153,7 @@ static int mtd_blktrans_thread(void *arg)
 				background_done = !dev->bg_stop;
 				continue;
 			}
-			set_current_state(TASK_INTERRUPTIBLE);
-
-			if (kthread_should_stop())
-				set_current_state(TASK_RUNNING);
-
-			spin_unlock_irq(rq->queue_lock);
-			schedule();
-			spin_lock_irq(rq->queue_lock);
-			continue;
+			break;
 		}
 
 		spin_unlock_irq(rq->queue_lock);
@@ -185,8 +174,6 @@ static int mtd_blktrans_thread(void *arg)
 		__blk_end_request_all(req, -EIO);
 
 	spin_unlock_irq(rq->queue_lock);
-
-	return 0;
 }
 
 static void mtd_blktrans_request(struct request_queue *rq)
@@ -199,10 +186,8 @@ static void mtd_blktrans_request(struct request_queue *rq)
 	if (!dev)
 		while ((req = blk_fetch_request(rq)) != NULL)
 			__blk_end_request_all(req, -ENODEV);
-	else {
-		dev->bg_stop = true;
-		wake_up_process(dev->thread);
-	}
+	else
+		queue_work(dev->wq, &dev->work);
 }
 
 static int blktrans_open(struct block_device *bdev, fmode_t mode)
@@ -437,14 +422,13 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 
 	gd->queue = new->rq;
 
-	/* Create processing thread */
-	/* TODO: workqueue ? */
-	new->thread = kthread_run(mtd_blktrans_thread, new,
-			"%s%d", tr->name, new->mtd->index);
-	if (IS_ERR(new->thread)) {
-		ret = PTR_ERR(new->thread);
+	/* Create processing workqueue */
+	new->wq = alloc_workqueue("%s%d", 0, 0,
+				  tr->name, new->mtd->index);
+	if (!new->wq)
 		goto error4;
-	}
+	INIT_WORK(&new->work, mtd_blktrans_work);
+
 	gd->driverfs_dev = &new->mtd->dev;
 
 	if (new->readonly)
@@ -484,9 +468,8 @@ int del_mtd_blktrans_dev(struct mtd_blktrans_dev *old)
 	/* Stop new requests to arrive */
 	del_gendisk(old->disk);
 
-
-	/* Stop the thread */
-	kthread_stop(old->thread);
+	/* Stop workqueue. This will perform any pending request. */
+	destroy_workqueue(old->wq);
 
 	/* Kill current requests */
 	spin_lock_irqsave(&old->queue_lock, flags);
diff --git a/include/linux/mtd/blktrans.h b/include/linux/mtd/blktrans.h
index ed270bd..4eb0a50 100644
--- a/include/linux/mtd/blktrans.h
+++ b/include/linux/mtd/blktrans.h
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/kref.h>
 #include <linux/sysfs.h>
+#include <linux/workqueue.h>
 
 struct hd_geometry;
 struct mtd_info;
@@ -43,7 +44,8 @@ struct mtd_blktrans_dev {
 	struct kref ref;
 	struct gendisk *disk;
 	struct attribute_group *disk_attributes;
-	struct task_struct *thread;
+	struct workqueue_struct *wq;
+	struct work_struct work;
 	struct request_queue *rq;
 	spinlock_t queue_lock;
 	void *priv;
-- 
1.7.8.6

