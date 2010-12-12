Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab0LLQtE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 11:49:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:45380 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab0LLQtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 11:49:02 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/6] media/video: explicitly flush request_module work
Date: Sun, 12 Dec 2010 17:48:16 +0100
Message-Id: <1292172499-21633-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292172499-21633-1-git-send-email-tj@kernel.org>
References: <1292172499-21633-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 12 Dec 2010 16:48:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Video drivers request submodules using a work during probe and calls
flush_scheduled_work() on exit to make sure the work is complete
before being unloaded.  This patch makes these drivers flush the work
directly instead of using flush_scheduled_work().

While at it, relocate request_submodules() call in saa7134_initdev()
right right before successful return as in other drivers to avoid
failing after the work is scheduled and returning failure without the
work still active.

This is in preparation for the deprecation of flush_scheduled_work().

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

 drivers/media/video/bt8xx/bttv-driver.c     |    9 +++++++++
 drivers/media/video/cx18/cx18-driver.c      |    8 ++++++++
 drivers/media/video/cx231xx/cx231xx-cards.c |    8 ++++++++
 drivers/media/video/cx88/cx88-mpeg.c        |    8 ++++++++
 drivers/media/video/em28xx/em28xx-cards.c   |    8 ++++++++
 drivers/media/video/saa7134/saa7134-core.c  |   11 +++++++++--
 6 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index a529619..53285aa 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -189,8 +189,14 @@ static void request_modules(struct bttv *dev)
 	INIT_WORK(&dev->request_module_wk, request_module_async);
 	schedule_work(&dev->request_module_wk);
 }
+
+static void flush_request_modules(struct bttv *dev)
+{
+	flush_work_sync(&dev->request_module_wk);
+}
 #else
 #define request_modules(dev)
+#define flush_request_modules(dev)
 #endif /* CONFIG_MODULES */
 
 
@@ -4573,6 +4579,9 @@ static void __devexit bttv_remove(struct pci_dev *pci_dev)
 	if (bttv_verbose)
 		printk("bttv%d: unloading\n",btv->c.nr);
 
+	if (bttv_tvcards[btv->c.type].has_dvb)
+		flush_request_modules(btv);
+
 	/* shutdown everything (DMA+IRQs) */
 	btand(~15, BT848_GPIO_DMA_CTL);
 	btwrite(0, BT848_INT_MASK);
diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
index df60f27..f6fdcfb 100644
--- a/drivers/media/video/cx18/cx18-driver.c
+++ b/drivers/media/video/cx18/cx18-driver.c
@@ -266,8 +266,14 @@ static void request_modules(struct cx18 *dev)
 	INIT_WORK(&dev->request_module_wk, request_module_async);
 	schedule_work(&dev->request_module_wk);
 }
+
+static void flush_request_modules(struct cx18 *dev)
+{
+	flush_work_sync(&dev->request_module_wk);
+}
 #else
 #define request_modules(dev)
+#define flush_request_modules(dev)
 #endif /* CONFIG_MODULES */
 
 /* Generic utility functions */
@@ -1226,6 +1232,8 @@ static void cx18_remove(struct pci_dev *pci_dev)
 
 	CX18_DEBUG_INFO("Removing Card\n");
 
+	flush_request_modules(cx);
+
 	/* Stop all captures */
 	CX18_DEBUG_INFO("Stopping all streams\n");
 	if (atomic_read(&cx->tot_capturing) > 0)
diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index 2c78d18..d342ab2 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -762,8 +762,14 @@ static void request_modules(struct cx231xx *dev)
 	INIT_WORK(&dev->request_module_wk, request_module_async);
 	schedule_work(&dev->request_module_wk);
 }
+
+static void flush_request_modules(struct cx231xx *dev)
+{
+	flush_work_sync(&dev->request_module_wk);
+}
 #else
 #define request_modules(dev)
+#define flush_request_modules(dev)
 #endif /* CONFIG_MODULES */
 
 /*
@@ -1096,6 +1102,8 @@ static void cx231xx_usb_disconnect(struct usb_interface *interface)
 	if (!dev->udev)
 		return;
 
+	flush_request_modules(dev);
+
 	/* delete v4l2 device */
 	v4l2_device_unregister(&dev->v4l2_dev);
 
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index f7d71ac..addf954 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -66,8 +66,14 @@ static void request_modules(struct cx8802_dev *dev)
 	INIT_WORK(&dev->request_module_wk, request_module_async);
 	schedule_work(&dev->request_module_wk);
 }
+
+static void flush_request_modules(struct cx8802_dev *dev)
+{
+	flush_work_sync(&dev->request_module_wk);
+}
 #else
 #define request_modules(dev)
+#define flush_request_modules(dev)
 #endif /* CONFIG_MODULES */
 
 
@@ -819,6 +825,8 @@ static void __devexit cx8802_remove(struct pci_dev *pci_dev)
 
 	dprintk( 1, "%s\n", __func__);
 
+	flush_request_modules(dev);
+
 	if (!list_empty(&dev->drvlist)) {
 		struct cx8802_driver *drv, *tmp;
 		int err;
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index f7e9168..f55cd0b 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2632,8 +2632,14 @@ static void request_modules(struct em28xx *dev)
 	INIT_WORK(&dev->request_module_wk, request_module_async);
 	schedule_work(&dev->request_module_wk);
 }
+
+static void flush_request_modules(struct em28xx *dev)
+{
+	flush_work_sync(&dev->request_module_wk);
+}
 #else
 #define request_modules(dev)
+#define flush_request_modules(dev)
 #endif /* CONFIG_MODULES */
 
 /*
@@ -3060,6 +3066,8 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 
 	em28xx_info("disconnecting %s\n", dev->vdev->name);
 
+	flush_request_modules(dev);
+
 	/* wait until all current v4l2 io is finished then deallocate
 	   resources */
 	mutex_lock(&dev->lock);
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 756a278..6abeecf 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -166,8 +166,14 @@ static void request_submodules(struct saa7134_dev *dev)
 	schedule_work(&dev->request_module_wk);
 }
 
+static void flush_request_submodules(struct saa7134_dev *dev)
+{
+	flush_work_sync(&dev->request_module_wk);
+}
+
 #else
 #define request_submodules(dev)
+#define flush_request_submodules(dev)
 #endif /* CONFIG_MODULES */
 
 /* ------------------------------------------------------------------ */
@@ -1010,8 +1016,6 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 		}
 	}
 
-	request_submodules(dev);
-
 	v4l2_prio_init(&dev->prio);
 
 	mutex_lock(&saa7134_devlist_lock);
@@ -1066,6 +1070,7 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 	if (saa7134_dmasound_init && !dev->dmasound.priv_data)
 		saa7134_dmasound_init(dev);
 
+	request_submodules(dev);
 	return 0;
 
  fail4:
@@ -1091,6 +1096,8 @@ static void __devexit saa7134_finidev(struct pci_dev *pci_dev)
 	struct saa7134_dev *dev = container_of(v4l2_dev, struct saa7134_dev, v4l2_dev);
 	struct saa7134_mpeg_ops *mops;
 
+	flush_request_submodules(dev);
+
 	/* Release DMA sound modules if present */
 	if (saa7134_dmasound_exit && dev->dmasound.priv_data) {
 		saa7134_dmasound_exit(dev);
-- 
1.7.1

