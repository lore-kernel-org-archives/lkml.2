Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467Ab2E0BKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:10:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965058Ab2E0BJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:09:56 -0400
Message-Id: <20120527010430.965598949@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:14 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kay Sievers <kay.sievers@vrfy.org>,
        Bernie Thompson <bernie@plugable.com>
Subject: [ 51/94] udlfb: fix hcd_buffer_free panic on unplug/replug
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernie Thompson <bernie@plugable.com>

commit 8d21547d3c9c3bc653261f26d554cfabc4a083de upstream.

Fix race conditions with unplug/replug behavior, in particular
take care not to hold up USB probe/disconnect for long-running
framebuffer operations and rely on usb to handle teardown.

Fix for kernel panic reported with new F17 multiseat support.

Reported-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Bernie Thompson <bernie@plugable.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/udlfb.c |  146 +++++++++++++++++++++++++++-----------------------
 include/video/udlfb.h |    1 
 2 files changed, 81 insertions(+), 66 deletions(-)

--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -918,10 +918,6 @@ static void dlfb_free(struct kref *kref)
 {
 	struct dlfb_data *dev = container_of(kref, struct dlfb_data, kref);
 
-	/* this function will wait for all in-flight urbs to complete */
-	if (dev->urbs.count > 0)
-		dlfb_free_urb_list(dev);
-
 	if (dev->backing_buffer)
 		vfree(dev->backing_buffer);
 
@@ -940,35 +936,42 @@ static void dlfb_release_urb_work(struct
 	up(&unode->dev->urbs.limit_sem);
 }
 
-static void dlfb_free_framebuffer_work(struct work_struct *work)
+static void dlfb_free_framebuffer(struct dlfb_data *dev)
 {
-	struct dlfb_data *dev = container_of(work, struct dlfb_data,
-					     free_framebuffer_work.work);
 	struct fb_info *info = dev->info;
-	int node = info->node;
 
-	unregister_framebuffer(info);
+	if (info) {
+		int node = info->node;
 
-	if (info->cmap.len != 0)
-		fb_dealloc_cmap(&info->cmap);
-	if (info->monspecs.modedb)
-		fb_destroy_modedb(info->monspecs.modedb);
-	if (info->screen_base)
-		vfree(info->screen_base);
+		unregister_framebuffer(info);
 
-	fb_destroy_modelist(&info->modelist);
+		if (info->cmap.len != 0)
+			fb_dealloc_cmap(&info->cmap);
+		if (info->monspecs.modedb)
+			fb_destroy_modedb(info->monspecs.modedb);
+		if (info->screen_base)
+			vfree(info->screen_base);
+
+		fb_destroy_modelist(&info->modelist);
 
-	dev->info = 0;
+		dev->info = NULL;
 
-	/* Assume info structure is freed after this point */
-	framebuffer_release(info);
+		/* Assume info structure is freed after this point */
+		framebuffer_release(info);
 
-	pr_warn("fb_info for /dev/fb%d has been freed\n", node);
+		pr_warn("fb_info for /dev/fb%d has been freed\n", node);
+	}
 
 	/* ref taken in probe() as part of registering framebfufer */
 	kref_put(&dev->kref, dlfb_free);
 }
 
+static void dlfb_free_framebuffer_work(struct work_struct *work)
+{
+	struct dlfb_data *dev = container_of(work, struct dlfb_data,
+					     free_framebuffer_work.work);
+	dlfb_free_framebuffer(dev);
+}
 /*
  * Assumes caller is holding info->lock mutex (for open and release at least)
  */
@@ -1570,14 +1573,15 @@ success:
 	kfree(buf);
 	return true;
 }
+
+static void dlfb_init_framebuffer_work(struct work_struct *work);
+
 static int dlfb_usb_probe(struct usb_interface *interface,
 			const struct usb_device_id *id)
 {
 	struct usb_device *usbdev;
 	struct dlfb_data *dev = 0;
-	struct fb_info *info = 0;
 	int retval = -ENOMEM;
-	int i;
 
 	/* usb initialization */
 
@@ -1589,9 +1593,7 @@ static int dlfb_usb_probe(struct usb_int
 		goto error;
 	}
 
-	/* we need to wait for both usb and fbdev to spin down on disconnect */
 	kref_init(&dev->kref); /* matching kref_put in usb .disconnect fn */
-	kref_get(&dev->kref); /* matching kref_put in free_framebuffer_work */
 
 	dev->udev = usbdev;
 	dev->gdev = &usbdev->dev; /* our generic struct device * */
@@ -1619,10 +1621,39 @@ static int dlfb_usb_probe(struct usb_int
 		goto error;
 	}
 
+	kref_get(&dev->kref); /* matching kref_put in free_framebuffer_work */
+
 	/* We don't register a new USB class. Our client interface is fbdev */
 
+	/* Workitem keep things fast & simple during USB enumeration */
+	INIT_DELAYED_WORK(&dev->init_framebuffer_work,
+			  dlfb_init_framebuffer_work);
+	schedule_delayed_work(&dev->init_framebuffer_work, 0);
+
+	return 0;
+
+error:
+	if (dev) {
+
+		kref_put(&dev->kref, dlfb_free); /* ref for framebuffer */
+		kref_put(&dev->kref, dlfb_free); /* last ref from kref_init */
+
+		/* dev has been deallocated. Do not dereference */
+	}
+
+	return retval;
+}
+
+static void dlfb_init_framebuffer_work(struct work_struct *work)
+{
+	struct dlfb_data *dev = container_of(work, struct dlfb_data,
+					     init_framebuffer_work.work);
+	struct fb_info *info;
+	int retval;
+	int i;
+
 	/* allocates framebuffer driver structure, not framebuffer memory */
-	info = framebuffer_alloc(0, &interface->dev);
+	info = framebuffer_alloc(0, dev->gdev);
 	if (!info) {
 		retval = -ENOMEM;
 		pr_err("framebuffer_alloc failed\n");
@@ -1668,15 +1699,13 @@ static int dlfb_usb_probe(struct usb_int
 	for (i = 0; i < ARRAY_SIZE(fb_device_attrs); i++) {
 		retval = device_create_file(info->dev, &fb_device_attrs[i]);
 		if (retval) {
-			pr_err("device_create_file failed %d\n", retval);
-			goto err_del_attrs;
+			pr_warn("device_create_file failed %d\n", retval);
 		}
 	}
 
 	retval = device_create_bin_file(info->dev, &edid_attr);
 	if (retval) {
-		pr_err("device_create_bin_file failed %d\n", retval);
-		goto err_del_attrs;
+		pr_warn("device_create_bin_file failed %d\n", retval);
 	}
 
 	pr_info("DisplayLink USB device /dev/fb%d attached. %dx%d resolution."
@@ -1684,38 +1713,10 @@ static int dlfb_usb_probe(struct usb_int
 			info->var.xres, info->var.yres,
 			((dev->backing_buffer) ?
 			info->fix.smem_len * 2 : info->fix.smem_len) >> 10);
-	return 0;
-
-err_del_attrs:
-	for (i -= 1; i >= 0; i--)
-		device_remove_file(info->dev, &fb_device_attrs[i]);
+	return;
 
 error:
-	if (dev) {
-
-		if (info) {
-			if (info->cmap.len != 0)
-				fb_dealloc_cmap(&info->cmap);
-			if (info->monspecs.modedb)
-				fb_destroy_modedb(info->monspecs.modedb);
-			if (info->screen_base)
-				vfree(info->screen_base);
-
-			fb_destroy_modelist(&info->modelist);
-
-			framebuffer_release(info);
-		}
-
-		if (dev->backing_buffer)
-			vfree(dev->backing_buffer);
-
-		kref_put(&dev->kref, dlfb_free); /* ref for framebuffer */
-		kref_put(&dev->kref, dlfb_free); /* last ref from kref_init */
-
-		/* dev has been deallocated. Do not dereference */
-	}
-
-	return retval;
+	dlfb_free_framebuffer(dev);
 }
 
 static void dlfb_usb_disconnect(struct usb_interface *interface)
@@ -1735,12 +1736,24 @@ static void dlfb_usb_disconnect(struct u
 	/* When non-active we'll update virtual framebuffer, but no new urbs */
 	atomic_set(&dev->usb_active, 0);
 
-	/* remove udlfb's sysfs interfaces */
-	for (i = 0; i < ARRAY_SIZE(fb_device_attrs); i++)
-		device_remove_file(info->dev, &fb_device_attrs[i]);
-	device_remove_bin_file(info->dev, &edid_attr);
-	unlink_framebuffer(info);
+	/* this function will wait for all in-flight urbs to complete */
+	dlfb_free_urb_list(dev);
+
+	if (info) {
+
+		/* remove udlfb's sysfs interfaces */
+		for (i = 0; i < ARRAY_SIZE(fb_device_attrs); i++)
+			device_remove_file(info->dev, &fb_device_attrs[i]);
+		device_remove_bin_file(info->dev, &edid_attr);
+
+		/* it's safe to uncomment next line if your kernel
+		   doesn't yet have this function exported */
+		unlink_framebuffer(info);
+	}
+
 	usb_set_intfdata(interface, NULL);
+	dev->udev = NULL;
+	dev->gdev = NULL;
 
 	/* if clients still have us open, will be freed on last close */
 	if (dev->fb_count == 0)
@@ -1806,12 +1819,12 @@ static void dlfb_free_urb_list(struct dl
 	int ret;
 	unsigned long flags;
 
-	pr_notice("Waiting for completes and freeing all render urbs\n");
+	pr_notice("Freeing all render urbs\n");
 
 	/* keep waiting and freeing, until we've got 'em all */
 	while (count--) {
 
-		/* Getting interrupted means a leak, but ok at shutdown*/
+		/* Getting interrupted means a leak, but ok at disconnect */
 		ret = down_interruptible(&dev->urbs.limit_sem);
 		if (ret)
 			break;
@@ -1833,6 +1846,7 @@ static void dlfb_free_urb_list(struct dl
 		kfree(node);
 	}
 
+	dev->urbs.count = 0;
 }
 
 static int dlfb_alloc_urb_list(struct dlfb_data *dev, int count, size_t size)
--- a/include/video/udlfb.h
+++ b/include/video/udlfb.h
@@ -41,6 +41,7 @@ struct dlfb_data {
 	char *backing_buffer;
 	int fb_count;
 	bool virtualized; /* true when physical usb device not present */
+	struct delayed_work init_framebuffer_work;
 	struct delayed_work free_framebuffer_work;
 	atomic_t usb_active; /* 0 = update virtual buffer, but no usb traffic */
 	atomic_t lost_pixels; /* 1 = a render op failed. Need screen refresh */


