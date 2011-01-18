Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab1ARXIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 18:08:23 -0500
Received: from perninha.conectiva.com.br ([187.115.55.249]:41695 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab1ARXIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 18:08:20 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH 1/2] fb: avoid oops when fb is removed by remove_conflicting_framebuffers
Date: Tue, 18 Jan 2011 21:09:58 -0200
Message-Id: <1295392199-31264-1-git-send-email-herton@mandriva.com.br>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firmware framebuffers (which have the flag FBINFO_MISC_FIRMWARE) can be
removed and replaced by another native framebuffer, like what happens
when you boot with a vesa framebuffer and later loads a drm module with
modesetting enabled on x86.

When framebuffer which is going to replace the firmware framebuffer is
registered, unregister_framebuffer is called for the old firmware
framebuffer automatically inside remove_conflicting_framebuffers
function. The problem is that while this happens, the old framebuffer
can still be in use.

The first issue in this is that unregister_framebuffer can free/destroy
struct fb_info when calling fb_info->fbops->fb_destroy. The same struct
fb_info is given to file->private_data inside fb_open function, so if
there is an application that have old framebuffer open, and it closes it
after the framebuffer was replaced, fb_release will still get the old
struct fb_info from file->private_data. As it was freed, the kernel will
most likely oops accessing an already freed location inside fb_release.
To fix this, add a reference count to struct fb_info and use it, so the
struct will be only destroyed after the last user closes the framebuffer.

The second issue is that the file_operations framebuffer functions
reference registered_fb array without locking. This can cause a race and
oops if application using the old firmware framebuffer calls a
read/write/mmap/ioctl function while unregister_framebuffer is running,
in the window inside it where registered_fb for the old framebuffer is
set to NULL. To avoid this situation, do not get the framebuffer from
registered_fb array, instead get it from file->private_data which is set
on fb_open. While at it, also add a new fb_info state which is set when
the framebuffer is being unregistered, so that file_operations functions
can check and prevent access to framebuffer when possible, returning an
error if the framebuffer is being or already unregistered.

This addresses kernel.org bug #26232. A testcase is provided in the
ticket which triggers the problem on current kernels.

References: https://bugzilla.kernel.org/show_bug.cgi?id=26232
Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/video/fbmem.c   |  170 ++++++++++++++++++++++++++++++++++-------------
 drivers/video/fbsysfs.c |    2 +
 include/linux/fb.h      |    2 +
 3 files changed, 127 insertions(+), 47 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 4ac1201..05d09ac 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -48,7 +48,7 @@ int num_registered_fb __read_mostly;
 int lock_fb_info(struct fb_info *info)
 {
 	mutex_lock(&info->lock);
-	if (!info->fbops) {
+	if (unlikely(!info->fbops || info->state == FBINFO_STATE_EXITING)) {
 		mutex_unlock(&info->lock);
 		return 0;
 	}
@@ -56,6 +56,72 @@ int lock_fb_info(struct fb_info *info)
 }
 EXPORT_SYMBOL(lock_fb_info);
 
+static int fbops_lock_fb_info(struct fb_info *info)
+{
+	int err;
+
+	if (!info->screen_base)
+		return -ENODEV;
+
+	if (info->flags == FBINFO_MISC_FIRMWARE) {
+		err = lock_fb_info(info);
+		if (err) {
+			if (info->state == FBINFO_STATE_SUSPENDED)
+				err = -EPERM;
+			if (err < 1)
+				unlock_fb_info(info);
+			else
+				err = 0;
+		} else
+			err = -ENODEV;
+		return err;
+	}
+
+	if (info->state != FBINFO_STATE_RUNNING)
+		return -EPERM;
+
+	return 0;
+}
+
+static void fbops_unlock_fb_info(struct fb_info *info)
+{
+	if (info->flags == FBINFO_MISC_FIRMWARE)
+		unlock_fb_info(info);
+}
+
+static void fb_kref_init(struct fb_info *info)
+{
+	if (info->flags == FBINFO_MISC_FIRMWARE)
+		kref_init(&info->fwfb_rfcnt);
+}
+
+static void fb_kref_get(struct fb_info *info)
+{
+	if (info->flags == FBINFO_MISC_FIRMWARE)
+		kref_get(&info->fwfb_rfcnt);
+}
+
+static void fb_kref_release(struct kref *ref)
+{
+	struct fb_info *info = container_of(ref, struct fb_info, fwfb_rfcnt);
+
+	if (info->fbops->fb_destroy)
+		info->fbops->fb_destroy(info);
+}
+
+static int fb_kref_put(struct fb_info *info, bool in_unregister)
+{
+	if (info->flags == FBINFO_MISC_FIRMWARE)
+		return kref_put(&info->fwfb_rfcnt, fb_kref_release);
+
+	if (in_unregister && info->fbops->fb_destroy) {
+		info->fbops->fb_destroy(info);
+		return 1;
+	}
+
+	return 0;
+}
+
 /*
  * Helpers
  */
@@ -694,30 +760,30 @@ static ssize_t
 fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int fbidx = iminor(inode);
-	struct fb_info *info = registered_fb[fbidx];
+	struct fb_info *info = file->private_data;
 	u8 *buffer, *dst;
 	u8 __iomem *src;
-	int c, cnt = 0, err = 0;
+	int c, cnt = 0, err;
 	unsigned long total_size;
 
-	if (!info || ! info->screen_base)
-		return -ENODEV;
+	err = fbops_lock_fb_info(info);
+	if (err)
+		return err;
 
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
+	if (info->fbops->fb_read) {
+		err = info->fbops->fb_read(info, buf, count, ppos);
+		goto fb_read_exit;
+	}
 
-	if (info->fbops->fb_read)
-		return info->fbops->fb_read(info, buf, count, ppos);
-	
 	total_size = info->screen_size;
 
 	if (total_size == 0)
 		total_size = info->fix.smem_len;
 
-	if (p >= total_size)
-		return 0;
+	if (p >= total_size) {
+		err = 0;
+		goto fb_read_exit;
+	}
 
 	if (count >= total_size)
 		count = total_size;
@@ -727,8 +793,10 @@ fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 	buffer = kmalloc((count > PAGE_SIZE) ? PAGE_SIZE : count,
 			 GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
+	if (!buffer) {
+		err = -ENOMEM;
+		goto fb_read_exit;
+	}
 
 	src = (u8 __iomem *) (info->screen_base + p);
 
@@ -754,37 +822,42 @@ fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 	kfree(buffer);
 
-	return (err) ? err : cnt;
+	if (!err)
+		err = cnt;
+
+fb_read_exit:
+	fbops_unlock_fb_info(info);
+	return err;
 }
 
 static ssize_t
 fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int fbidx = iminor(inode);
-	struct fb_info *info = registered_fb[fbidx];
+	struct fb_info *info = file->private_data;
 	u8 *buffer, *src;
 	u8 __iomem *dst;
-	int c, cnt = 0, err = 0;
+	int c, cnt = 0, err;
 	unsigned long total_size;
 
-	if (!info || !info->screen_base)
-		return -ENODEV;
+	err = fbops_lock_fb_info(info);
+	if (err)
+		return err;
 
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
+	if (info->fbops->fb_write) {
+		err = info->fbops->fb_write(info, buf, count, ppos);
+		goto fb_write_exit;
+	}
 
-	if (info->fbops->fb_write)
-		return info->fbops->fb_write(info, buf, count, ppos);
-	
 	total_size = info->screen_size;
 
 	if (total_size == 0)
 		total_size = info->fix.smem_len;
 
-	if (p > total_size)
-		return -EFBIG;
+	if (p > total_size) {
+		err = -EFBIG;
+		goto fb_write_exit;
+	}
 
 	if (count > total_size) {
 		err = -EFBIG;
@@ -800,8 +873,10 @@ fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 
 	buffer = kmalloc((count > PAGE_SIZE) ? PAGE_SIZE : count,
 			 GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
+	if (!buffer) {
+		err = -ENOMEM;
+		goto fb_write_exit;
+	}
 
 	dst = (u8 __iomem *) (info->screen_base + p);
 
@@ -828,7 +903,12 @@ fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 
 	kfree(buffer);
 
-	return (cnt) ? cnt : err;
+	if (cnt)
+		err = cnt;
+
+fb_write_exit:
+	fbops_unlock_fb_info(info);
+	return err;
 }
 
 int
@@ -1141,9 +1221,7 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
 
 static long fb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int fbidx = iminor(inode);
-	struct fb_info *info = registered_fb[fbidx];
+	struct fb_info *info = file->private_data;
 
 	return do_fb_ioctl(info, cmd, arg);
 }
@@ -1265,9 +1343,7 @@ static int fb_get_fscreeninfo(struct fb_info *info, unsigned int cmd,
 static long fb_compat_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int fbidx = iminor(inode);
-	struct fb_info *info = registered_fb[fbidx];
+	struct fb_info *info = file->private_data;
 	struct fb_ops *fb = info->fbops;
 	long ret = -ENOIOCTLCMD;
 
@@ -1303,8 +1379,7 @@ static long fb_compat_ioctl(struct file *file, unsigned int cmd,
 static int
 fb_mmap(struct file *file, struct vm_area_struct * vma)
 {
-	int fbidx = iminor(file->f_path.dentry->d_inode);
-	struct fb_info *info = registered_fb[fbidx];
+	struct fb_info *info = file->private_data;
 	struct fb_ops *fb = info->fbops;
 	unsigned long off;
 	unsigned long start;
@@ -1380,6 +1455,8 @@ __releases(&info->lock)
 		if (res)
 			module_put(info->fbops->owner);
 	}
+	if (!res)
+		fb_kref_get(info);
 #ifdef CONFIG_FB_DEFERRED_IO
 	if (info->fbdefio)
 		fb_deferred_io_open(info, inode, file);
@@ -1401,6 +1478,7 @@ __releases(&info->lock)
 		info->fbops->fb_release(info,1);
 	module_put(info->fbops->owner);
 	mutex_unlock(&info->lock);
+	fb_kref_put(info, false);
 	return 0;
 }
 
@@ -1549,6 +1627,7 @@ register_framebuffer(struct fb_info *fb_info)
 	fb_info->node = i;
 	mutex_init(&fb_info->lock);
 	mutex_init(&fb_info->mm_lock);
+	fb_kref_init(fb_info);
 
 	fb_info->dev = device_create(fb_class, fb_info->device,
 				     MKDEV(FB_MAJOR, i), NULL, "fb%d", i);
@@ -1622,9 +1701,9 @@ unregister_framebuffer(struct fb_info *fb_info)
 		goto done;
 	}
 
-
 	if (!lock_fb_info(fb_info))
 		return -ENODEV;
+	fb_info->state = FBINFO_STATE_EXITING;
 	event.info = fb_info;
 	ret = fb_notifier_call_chain(FB_EVENT_FB_UNBIND, &event);
 	unlock_fb_info(fb_info);
@@ -1644,10 +1723,7 @@ unregister_framebuffer(struct fb_info *fb_info)
 	device_destroy(fb_class, MKDEV(FB_MAJOR, i));
 	event.info = fb_info;
 	fb_notifier_call_chain(FB_EVENT_FB_UNREGISTERED, &event);
-
-	/* this may free fb info */
-	if (fb_info->fbops->fb_destroy)
-		fb_info->fbops->fb_destroy(fb_info);
+	fb_kref_put(fb_info, true);
 done:
 	return ret;
 }
@@ -1655,7 +1731,7 @@ done:
 /**
  *	fb_set_suspend - low level driver signals suspend
  *	@info: framebuffer affected
- *	@state: 0 = resuming, !=0 = suspending
+ *	@state: 0 = resuming, 1 = suspending
  *
  *	This is meant to be used by low level drivers to
  * 	signal suspend/resume to the core & clients.
diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
index 0a08f13..be361b5 100644
--- a/drivers/video/fbsysfs.c
+++ b/drivers/video/fbsysfs.c
@@ -398,6 +398,8 @@ static ssize_t store_fbstate(struct device *device,
 	char *last = NULL;
 
 	state = simple_strtoul(buf, &last, 0);
+	if (state && state > 1)
+		return -EINVAL;
 
 	acquire_console_sem();
 	fb_set_suspend(fb_info, (int)state);
diff --git a/include/linux/fb.h b/include/linux/fb.h
index d1631d3..836f605 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -871,6 +871,7 @@ struct fb_info {
 	void *pseudo_palette;		/* Fake palette of 16 colors */ 
 #define FBINFO_STATE_RUNNING	0
 #define FBINFO_STATE_SUSPENDED	1
+#define FBINFO_STATE_EXITING	2
 	u32 state;			/* Hardware state i.e suspend */
 	void *fbcon_par;                /* fbcon use-only private area */
 	/* From here on everything is device dependent */
@@ -885,6 +886,7 @@ struct fb_info {
 			resource_size_t size;
 		} ranges[0];
 	} *apertures;
+	struct kref fwfb_rfcnt;
 };
 
 static inline struct apertures_struct *alloc_apertures(unsigned int max_num) {
-- 
1.7.3.4

