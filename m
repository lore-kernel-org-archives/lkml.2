Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab1EJNwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:52:31 -0400
Received: from mail.tpi.com ([70.99.223.143]:4637 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab1EJNw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:52:28 -0400
Message-ID: <4DC94314.8050701@canonical.com>
Date: Tue, 10 May 2011 15:52:20 +0200
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-fbdev@vger.kernel.org
CC: lethal@linux-sh.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3] fbcon -- fix race between open and removal of framebuffers
References: <1304617307-7389-1-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1304617307-7389-1-git-send-email-tim.gardner@canonical.com>
Content-Type: multipart/mixed;
 boundary="------------030101000702020907060009"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030101000702020907060009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

There was a second patch that I missed that fixed an original 
regression, so I've just squashed that one into this V3 patch along with 
the reference count issue that Jack Stone pointed out.

These patches can be found in their original form in 
git://kernel.ubuntu.git/ubuntu/ubuntu-oneiric.git

UBUNTU: SAUCE: fbcon -- fix race between open and removal of framebuffers
UBUNTU: SAUCE: fbcon -- fix OOPs triggered by race prevention fixes

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------030101000702020907060009
Content-Type: text/x-patch;
 name="0001-fbcon-fix-race-between-open-and-removal-of-framebuff.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-fbcon-fix-race-between-open-and-removal-of-framebuff.pa";
 filename*1="tch"

>From ca3ef33e2235c88856a6257c0be63192ab56c678 Mon Sep 17 00:00:00 2001
From: Andy Whitcroft <apw@canonical.com>
Date: Thu, 29 Jul 2010 16:48:20 +0100
Subject: [PATCH] fbcon -- fix race between open and removal of framebuffers

Currently there is no locking for updates to the registered_fb list.
This allows an open through /dev/fbN to pick up a registered framebuffer
pointer in parallel with it being released, as happens when a conflicting
framebuffer is ejected or on module unload.  There is also no reference
counting on the framebuffer descriptor which is referenced from all open
files, leading to references to released or reused memory to persist on
these open files.

This patch adds a reference count to the framebuffer descriptor to prevent
it from being released until after all pending opens are closed.  This
allows the pending opens to detect the closed status and unmap themselves.
It also adds locking to the framebuffer lookup path, locking it against
the removal path such that it is possible to atomically lookup and take a
reference to the descriptor.  It also adds locking to the read and write
paths which currently could access the framebuffer descriptor after it
has been freed.  Finally it moves the device to FBINFO_STATE_REMOVED to
indicate that all access should be errored for this device.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Acked-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/video/fbmem.c |  136 ++++++++++++++++++++++++++++++++++++++-----------
 include/linux/fb.h    |    2 +
 2 files changed, 108 insertions(+), 30 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index e0c2284..1afe435 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -42,6 +42,8 @@
 
 #define FBPIXMAPSIZE	(1024 * 8)
 
+/* Protects the registered framebuffer list and count. */
+static DEFINE_SPINLOCK(registered_lock);
 struct fb_info *registered_fb[FB_MAX] __read_mostly;
 int num_registered_fb __read_mostly;
 
@@ -694,9 +696,7 @@ static ssize_t
 fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int fbidx = iminor(inode);
-	struct fb_info *info = registered_fb[fbidx];
+	struct fb_info *info = file->private_data;
 	u8 *buffer, *dst;
 	u8 __iomem *src;
 	int c, cnt = 0, err = 0;
@@ -705,19 +705,28 @@ fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	if (!info || ! info->screen_base)
 		return -ENODEV;
 
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
+	if (!lock_fb_info(info))
+		return -ENODEV;
+
+	if (info->state != FBINFO_STATE_RUNNING) {
+		err = -EPERM;
+		goto out_fb_info;
+	}
 
-	if (info->fbops->fb_read)
-		return info->fbops->fb_read(info, buf, count, ppos);
+	if (info->fbops->fb_read) {
+		err = info->fbops->fb_read(info, buf, count, ppos);
+		goto out_fb_info;
+	}
 	
 	total_size = info->screen_size;
 
 	if (total_size == 0)
 		total_size = info->fix.smem_len;
 
-	if (p >= total_size)
-		return 0;
+	if (p >= total_size) {
+		err = 0;
+		goto out_fb_info;
+	}
 
 	if (count >= total_size)
 		count = total_size;
@@ -727,8 +736,10 @@ fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 	buffer = kmalloc((count > PAGE_SIZE) ? PAGE_SIZE : count,
 			 GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
+	if (!buffer) {
+		err = -ENOMEM;
+		goto out_fb_info;
+	}
 
 	src = (u8 __iomem *) (info->screen_base + p);
 
@@ -751,19 +762,21 @@ fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		cnt += c;
 		count -= c;
 	}
+	if (!err)
+		err = cnt;
 
 	kfree(buffer);
+out_fb_info:
+	unlock_fb_info(info);
 
-	return (err) ? err : cnt;
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
 	int c, cnt = 0, err = 0;
@@ -772,8 +785,13 @@ fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	if (!info || !info->screen_base)
 		return -ENODEV;
 
-	if (info->state != FBINFO_STATE_RUNNING)
-		return -EPERM;
+	if (!lock_fb_info(info))
+		return -ENODEV;
+
+	if (info->state != FBINFO_STATE_RUNNING) {
+		err = -EPERM;
+		goto out_fb_info;
+	}
 
 	if (info->fbops->fb_write)
 		return info->fbops->fb_write(info, buf, count, ppos);
@@ -783,8 +801,10 @@ fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	if (total_size == 0)
 		total_size = info->fix.smem_len;
 
-	if (p > total_size)
-		return -EFBIG;
+	if (p > total_size) {
+		err = -EFBIG;
+		goto out_fb_info;
+	}
 
 	if (count > total_size) {
 		err = -EFBIG;
@@ -800,8 +820,10 @@ fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 
 	buffer = kmalloc((count > PAGE_SIZE) ? PAGE_SIZE : count,
 			 GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
+	if (!buffer) {
+		err = -ENOMEM;
+		goto out_fb_info;
+	}
 
 	dst = (u8 __iomem *) (info->screen_base + p);
 
@@ -825,10 +847,14 @@ fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 		cnt += c;
 		count -= c;
 	}
+	if (cnt)
+		err = cnt;
 
 	kfree(buffer);
+out_fb_info:
+	unlock_fb_info(info);
 
-	return (cnt) ? cnt : err;
+	return err;
 }
 
 int
@@ -1303,8 +1329,7 @@ static long fb_compat_ioctl(struct file *file, unsigned int cmd,
 static int
 fb_mmap(struct file *file, struct vm_area_struct * vma)
 {
-	int fbidx = iminor(file->f_path.dentry->d_inode);
-	struct fb_info *info = registered_fb[fbidx];
+	struct fb_info * const info = file->private_data;
 	struct fb_ops *fb = info->fbops;
 	unsigned long off;
 	unsigned long start;
@@ -1316,6 +1341,11 @@ fb_mmap(struct file *file, struct vm_area_struct * vma)
 	if (!fb)
 		return -ENODEV;
 	mutex_lock(&info->mm_lock);
+	if (info->state == FBINFO_STATE_REMOVED) {
+		mutex_unlock(&info->mm_lock);
+		return -ENODEV;
+	}
+
 	if (fb->fb_mmap) {
 		int res;
 		res = fb->fb_mmap(info, vma);
@@ -1352,6 +1382,35 @@ fb_mmap(struct file *file, struct vm_area_struct * vma)
 	return 0;
 }
 
+static struct fb_info *get_framebuffer_info(int idx)
+__acquires(&registered_lock)
+__releases(&registered_lock)
+{
+	struct fb_info *fb_info;
+
+	spin_lock(&registered_lock);
+	fb_info = registered_fb[idx];
+	if (fb_info)
+		fb_info->ref_count++;
+	spin_unlock(&registered_lock);
+
+	return fb_info;
+}
+
+static void put_framebuffer_info(struct fb_info *fb_info)
+__acquires(&registered_lock)
+__releases(&registered_lock)
+{
+	int keep;
+
+	spin_lock(&registered_lock);
+	keep = --fb_info->ref_count;
+	spin_unlock(&registered_lock);
+
+	if (!keep && fb_info->fbops->fb_destroy)
+		fb_info->fbops->fb_destroy(fb_info);
+}
+
 static int
 fb_open(struct inode *inode, struct file *file)
 __acquires(&info->lock)
@@ -1363,13 +1422,18 @@ __releases(&info->lock)
 
 	if (fbidx >= FB_MAX)
 		return -ENODEV;
-	info = registered_fb[fbidx];
-	if (!info)
+	info = get_framebuffer_info(fbidx);
+	if (!info) {
 		request_module("fb%d", fbidx);
-	info = registered_fb[fbidx];
+		info = get_framebuffer_info(fbidx);
+	}
 	if (!info)
 		return -ENODEV;
 	mutex_lock(&info->lock);
+	if (info->state == FBINFO_STATE_REMOVED) {
+		res = -ENODEV;
+		goto out;
+	}
 	if (!try_module_get(info->fbops->owner)) {
 		res = -ENODEV;
 		goto out;
@@ -1386,6 +1450,8 @@ __releases(&info->lock)
 #endif
 out:
 	mutex_unlock(&info->lock);
+	if (res)
+		put_framebuffer_info(info);
 	return res;
 }
 
@@ -1401,6 +1467,7 @@ __releases(&info->lock)
 		info->fbops->fb_release(info,1);
 	module_put(info->fbops->owner);
 	mutex_unlock(&info->lock);
+	put_framebuffer_info(info);
 	return 0;
 }
 
@@ -1549,6 +1616,7 @@ register_framebuffer(struct fb_info *fb_info)
 	fb_info->node = i;
 	mutex_init(&fb_info->lock);
 	mutex_init(&fb_info->mm_lock);
+	fb_info->ref_count = 1;
 
 	fb_info->dev = device_create(fb_class, fb_info->device,
 				     MKDEV(FB_MAJOR, i), NULL, "fb%d", i);
@@ -1592,7 +1660,6 @@ register_framebuffer(struct fb_info *fb_info)
 	return 0;
 }
 
-
 /**
  *	unregister_framebuffer - releases a frame buffer device
  *	@fb_info: frame buffer info structure
@@ -1627,6 +1694,16 @@ unregister_framebuffer(struct fb_info *fb_info)
 		return -ENODEV;
 	event.info = fb_info;
 	ret = fb_notifier_call_chain(FB_EVENT_FB_UNBIND, &event);
+	if (!ret) {
+		mutex_lock(&fb_info->mm_lock);
+		/*
+		 * We must prevent any operations for this transition, we
+		 * already have info->lock so grab the info->mm_lock to hold
+		 * the remainder.
+		 */
+		fb_info->state = FBINFO_STATE_REMOVED;
+		mutex_unlock(&fb_info->mm_lock);
+	}
 	unlock_fb_info(fb_info);
 
 	if (ret) {
@@ -1646,8 +1723,7 @@ unregister_framebuffer(struct fb_info *fb_info)
 	fb_notifier_call_chain(FB_EVENT_FB_UNREGISTERED, &event);
 
 	/* this may free fb info */
-	if (fb_info->fbops->fb_destroy)
-		fb_info->fbops->fb_destroy(fb_info);
+	put_framebuffer_info(fb_info);
 done:
 	return ret;
 }
diff --git a/include/linux/fb.h b/include/linux/fb.h
index df728c1..60de3fa 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -834,6 +834,7 @@ struct fb_tile_ops {
 struct fb_info {
 	int node;
 	int flags;
+	int ref_count;
 	struct mutex lock;		/* Lock for open/release/ioctl funcs */
 	struct mutex mm_lock;		/* Lock for fb_mmap and smem_* fields */
 	struct fb_var_screeninfo var;	/* Current var */
@@ -873,6 +874,7 @@ struct fb_info {
 	void *pseudo_palette;		/* Fake palette of 16 colors */ 
 #define FBINFO_STATE_RUNNING	0
 #define FBINFO_STATE_SUSPENDED	1
+#define FBINFO_STATE_REMOVED	2
 	u32 state;			/* Hardware state i.e suspend */
 	void *fbcon_par;                /* fbcon use-only private area */
 	/* From here on everything is device dependent */
-- 
1.7.4.1


--------------030101000702020907060009--
