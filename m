Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab0GCWPi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:15:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57263 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab0GCWPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:15:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/6] v4l: convert v4l2-dev to unlocked_ioctl
Date: Sun,  4 Jul 2010 00:15:09 +0200
Message-Id: <1278195310-25590-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278195310-25590-1-git-send-email-arnd@arndb.de>
References: <1278195310-25590-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/JtYC0g0fvsAZKYXKFJvm+b6uEJVZx+mF0OHu
 XhIzWnwELrsissz2s+fF0LDuHa87mVA8UsDH8RuD/0jWbMcaXj
 PRONw33Cxtl5r5LySs4PQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v4l2 implements two separate file operations for drivers that use locked
and unlocked ioctl callbacks. Since we want to remove the ioctl file operation
in favor of the unlocked variant, this separation no longer seems helpful.

There is another series from Frederic Weisbecker that takes care
of converting all v4l drivers to use the unlocked_ioctl variant, which
brings the BKL pushdown one level further.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 drivers/media/video/v4l2-dev.c |   52 +++++++++++----------------------------
 1 files changed, 15 insertions(+), 37 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 0ca7ec9..a869418 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/kmod.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 
@@ -215,28 +216,24 @@ static unsigned int v4l2_poll(struct file *filp, struct poll_table_struct *poll)
 	return vdev->fops->poll(filp, poll);
 }
 
-static int v4l2_ioctl(struct inode *inode, struct file *filp,
-		unsigned int cmd, unsigned long arg)
+static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct video_device *vdev = video_devdata(filp);
+	int ret;
 
-	if (!vdev->fops->ioctl)
-		return -ENOTTY;
 	/* Allow ioctl to continue even if the device was unregistered.
 	   Things like dequeueing buffers might still be useful. */
-	return vdev->fops->ioctl(filp, cmd, arg);
-}
-
-static long v4l2_unlocked_ioctl(struct file *filp,
-		unsigned int cmd, unsigned long arg)
-{
-	struct video_device *vdev = video_devdata(filp);
+	if (vdev->fops->unlocked_ioctl) {
+		ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
+	} else if (vdev->fops->ioctl) {
+		/* TODO: convert all drivers to unlocked_ioctl */
+		lock_kernel();
+		ret = vdev->fops->ioctl(filp, cmd, arg);
+		unlock_kernel();
+	} else
+		ret = -ENOTTY;
 
-	if (!vdev->fops->unlocked_ioctl)
-		return -ENOTTY;
-	/* Allow ioctl to continue even if the device was unregistered.
-	   Things like dequeueing buffers might still be useful. */
-	return vdev->fops->unlocked_ioctl(filp, cmd, arg);
+	return ret;
 }
 
 #ifdef CONFIG_MMU
@@ -307,22 +304,6 @@ static int v4l2_release(struct inode *inode, struct file *filp)
 	return ret;
 }
 
-static const struct file_operations v4l2_unlocked_fops = {
-	.owner = THIS_MODULE,
-	.read = v4l2_read,
-	.write = v4l2_write,
-	.open = v4l2_open,
-	.get_unmapped_area = v4l2_get_unmapped_area,
-	.mmap = v4l2_mmap,
-	.unlocked_ioctl = v4l2_unlocked_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl = v4l2_compat_ioctl32,
-#endif
-	.release = v4l2_release,
-	.poll = v4l2_poll,
-	.llseek = no_llseek,
-};
-
 static const struct file_operations v4l2_fops = {
 	.owner = THIS_MODULE,
 	.read = v4l2_read,
@@ -330,7 +311,7 @@ static const struct file_operations v4l2_fops = {
 	.open = v4l2_open,
 	.get_unmapped_area = v4l2_get_unmapped_area,
 	.mmap = v4l2_mmap,
-	.ioctl = v4l2_ioctl,
+	.unlocked_ioctl = v4l2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l2_compat_ioctl32,
 #endif
@@ -521,10 +502,7 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 		ret = -ENOMEM;
 		goto cleanup;
 	}
-	if (vdev->fops->unlocked_ioctl)
-		vdev->cdev->ops = &v4l2_unlocked_fops;
-	else
-		vdev->cdev->ops = &v4l2_fops;
+	vdev->cdev->ops = &v4l2_fops;
 	vdev->cdev->owner = vdev->fops->owner;
 	ret = cdev_add(vdev->cdev, MKDEV(VIDEO_MAJOR, vdev->minor), 1);
 	if (ret < 0) {
-- 
1.7.1

