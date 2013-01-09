Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab3AINsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 08:48:45 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:40506 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab3AINsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 08:48:43 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, Bernie Thompson <bernie@plugable.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Dave Airlie <airlied@redhat.com>,
        Alexander Holler <holler@ahsoftware.de>, <stable@vger.kernel.org>
Subject: [PATCH v2] fb: udlfb: fix scheduling while atomic.
Date: Wed,  9 Jan 2013 14:47:53 +0100
Message-Id: <1357739273-25913-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <50E9722D.2090602@ahsoftware.de>
References: <50E9722D.2090602@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The console functions are using spinlocks while calling fb-driver ops
but udlfb waits for a semaphore in many ops. This results in the BUG
"scheduling while atomic". One of those call flows is e.g.

vt_console_print() (spinlock printing_lock)
	(...)
	dlfb_ops_imageblit()
                        dlfb_handle_damage()
                                dlfb_get_urb()
					down_timeout(semaphore)
BUG: scheduling while atomic
(...)
vt_console_print() (release spinlock printing_lock)

Fix this through a workqueue for dlfb_handle_damage().

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/video/udlfb.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 include/video/udlfb.h |  1 +
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
index 86d449e..4a90784 100644
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -569,7 +569,7 @@ static int dlfb_render_hline(struct dlfb_data *dev, struct urb **urb_ptr,
 	return 0;
 }
 
-int dlfb_handle_damage(struct dlfb_data *dev, int x, int y,
+int dlfb_handle_damage_queued(struct dlfb_data *dev, int x, int y,
 	       int width, int height, char *data)
 {
 	int i, ret;
@@ -630,6 +630,44 @@ error:
 	return 0;
 }
 
+struct dlfb_handle_damage_work {
+	struct work_struct my_work;
+	struct dlfb_data *dev;
+	char *data;
+	int x, y, width, height;
+};
+
+static void dlfb_handle_damage_work(struct work_struct *work)
+{
+	struct dlfb_handle_damage_work *my_work =
+		(struct dlfb_handle_damage_work *)work;
+
+	dlfb_handle_damage_queued(my_work->dev, my_work->x, my_work->y,
+			my_work->width, my_work->height, my_work->data);
+	kfree(work);
+	return;
+}
+
+void dlfb_handle_damage(struct dlfb_data *dev, int x, int y,
+	       int width, int height, char *data)
+{
+	struct dlfb_handle_damage_work *work =
+		kmalloc(sizeof(struct dlfb_handle_damage_work), GFP_KERNEL);
+
+	if (!work) {
+		pr_err("unable to allocate work\n");
+		return;
+	}
+	INIT_WORK((struct work_struct *)work, dlfb_handle_damage_work);
+	work->dev = dev;
+	work->x = x;
+	work->y = y;
+	work->width = width;
+	work->height = height;
+	work->data = data;
+	queue_work(dev->handle_damage_wq, (struct work_struct *)work);
+}
+
 /*
  * Path triggered by usermode clients who write to filesystem
  * e.g. cat filename > /dev/fb1
@@ -945,6 +983,9 @@ static void dlfb_free_framebuffer(struct dlfb_data *dev)
 
 		unregister_framebuffer(info);
 
+		if (dev->handle_damage_wq)
+			destroy_workqueue(dev->handle_damage_wq);
+
 		if (info->cmap.len != 0)
 			fb_dealloc_cmap(&info->cmap);
 		if (info->monspecs.modedb)
@@ -1694,6 +1735,13 @@ static void dlfb_init_framebuffer_work(struct work_struct *work)
 		goto error;
 	}
 
+	dev->handle_damage_wq = alloc_workqueue("udlfb_damage",
+						WQ_MEM_RECLAIM, 0);
+	if (dev->handle_damage_wq == NULL) {
+		pr_err("unable to allocate workqueue\n");
+		goto error;
+	}
+
 	/* ready to begin using device */
 
 	atomic_set(&dev->usb_active, 1);
diff --git a/include/video/udlfb.h b/include/video/udlfb.h
index f9466fa..1e765f9 100644
--- a/include/video/udlfb.h
+++ b/include/video/udlfb.h
@@ -43,6 +43,7 @@ struct dlfb_data {
 	bool virtualized; /* true when physical usb device not present */
 	struct delayed_work init_framebuffer_work;
 	struct delayed_work free_framebuffer_work;
+	struct workqueue_struct *handle_damage_wq;
 	atomic_t usb_active; /* 0 = update virtual buffer, but no usb traffic */
 	atomic_t lost_pixels; /* 1 = a render op failed. Need screen refresh */
 	char *edid; /* null until we read edid from hw or get from sysfs */
-- 
1.7.11.7

