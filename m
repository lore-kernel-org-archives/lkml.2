Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab0LLQtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 11:49:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:45387 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab0LLQtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 11:49:03 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/6] media/video: don't use flush_scheduled_work()
Date: Sun, 12 Dec 2010 17:48:17 +0100
Message-Id: <1292172499-21633-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292172499-21633-1-git-send-email-tj@kernel.org>
References: <1292172499-21633-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 12 Dec 2010 16:48:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the remaining users of flush_scheduled_work() in
media/video.

* bttv-input.c and cx23885-input.c don't use workqueue at all.  No
  need to flush.

* Make omap24xxcam.c and saa7134-empress.c flush the used work
  directly.

* In fd_defio.c, replace cancel_delayed_work() +
  flush_scheduled_work() with cancel_delayed_work_sync().  While at
  it, replace the deprecated cancel_rearming_delayed_work() with
  cancel_delayed_work_sync().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
This is part of a series to remove flush_scheduled_work() usage to
prepare for deprecation of flush_scheduled_work().  Patches in this
series are self contained and mostly straight-forward.

Please feel free to take it into the appropriate tree, or just ack it.
In the latter case, I'll merge the patch through the workqueue tree
during the next merge window.

Thank you.

 drivers/media/video/bt8xx/bttv-input.c        |    5 +----
 drivers/media/video/cx23885/cx23885-input.c   |    2 --
 drivers/media/video/omap24xxcam.c             |    6 +++---
 drivers/media/video/saa7134/saa7134-empress.c |    2 +-
 drivers/video/fb_defio.c                      |    5 ++---
 5 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-input.c b/drivers/media/video/bt8xx/bttv-input.c
index 6bf05a7..1989f00 100644
--- a/drivers/media/video/bt8xx/bttv-input.c
+++ b/drivers/media/video/bt8xx/bttv-input.c
@@ -229,16 +229,13 @@ static void bttv_ir_start(struct bttv *btv, struct card_ir *ir)
 
 static void bttv_ir_stop(struct bttv *btv)
 {
-	if (btv->remote->polling) {
+	if (btv->remote->polling)
 		del_timer_sync(&btv->remote->timer);
-		flush_scheduled_work();
-	}
 
 	if (btv->remote->rc5_gpio) {
 		u32 gpio;
 
 		del_timer_sync(&btv->remote->timer_end);
-		flush_scheduled_work();
 
 		gpio = bttv_gpio_read(&btv->c);
 		bttv_gpio_write(&btv->c, gpio & ~(1 << 4));
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index bb61870..4a326fe 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -230,8 +230,6 @@ static void cx23885_input_ir_stop(struct cx23885_dev *dev)
 		v4l2_subdev_call(dev->sd_ir, ir, rx_s_parameters, &params);
 		v4l2_subdev_call(dev->sd_ir, ir, rx_g_parameters, &params);
 	}
-
-	flush_scheduled_work();
 }
 
 static void cx23885_input_ir_close(void *priv)
diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
index 378b094..0175527 100644
--- a/drivers/media/video/omap24xxcam.c
+++ b/drivers/media/video/omap24xxcam.c
@@ -1198,7 +1198,7 @@ static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
 
 	atomic_inc(&cam->reset_disable);
 
-	flush_scheduled_work();
+	flush_work_sync(&cam->sensor_reset_work);
 
 	rval = videobuf_streamoff(q);
 	if (!rval) {
@@ -1512,7 +1512,7 @@ static int omap24xxcam_release(struct file *file)
 
 	atomic_inc(&cam->reset_disable);
 
-	flush_scheduled_work();
+	flush_work_sync(&cam->sensor_reset_work);
 
 	/* stop streaming capture */
 	videobuf_streamoff(&fh->vbq);
@@ -1536,7 +1536,7 @@ static int omap24xxcam_release(struct file *file)
 	 * not be scheduled anymore since streaming is already
 	 * disabled.)
 	 */
-	flush_scheduled_work();
+	flush_work_sync(&cam->sensor_reset_work);
 
 	mutex_lock(&cam->mutex);
 	if (atomic_dec_return(&cam->users) == 0) {
diff --git a/drivers/media/video/saa7134/saa7134-empress.c b/drivers/media/video/saa7134/saa7134-empress.c
index b890aaf..6b8459c 100644
--- a/drivers/media/video/saa7134/saa7134-empress.c
+++ b/drivers/media/video/saa7134/saa7134-empress.c
@@ -553,7 +553,7 @@ static int empress_fini(struct saa7134_dev *dev)
 
 	if (NULL == dev->empress_dev)
 		return 0;
-	flush_scheduled_work();
+	flush_work_sync(&dev->empress_workqueue);
 	video_unregister_device(dev->empress_dev);
 	dev->empress_dev = NULL;
 	return 0;
diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
index 6b93ef9..a79c0de 100644
--- a/drivers/video/fb_defio.c
+++ b/drivers/video/fb_defio.c
@@ -75,7 +75,7 @@ int fb_deferred_io_fsync(struct file *file, int datasync)
 		return 0;
 
 	/* Kill off the delayed work */
-	cancel_rearming_delayed_work(&info->deferred_work);
+	cancel_delayed_work_sync(&info->deferred_work);
 
 	/* Run it immediately */
 	return schedule_delayed_work(&info->deferred_work, 0);
@@ -216,8 +216,7 @@ void fb_deferred_io_cleanup(struct fb_info *info)
 	int i;
 
 	BUG_ON(!fbdefio);
-	cancel_delayed_work(&info->deferred_work);
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&info->deferred_work);
 
 	/* clear out the mapping that we setup */
 	for (i = 0 ; i < info->fix.smem_len; i += PAGE_SIZE) {
-- 
1.7.1

