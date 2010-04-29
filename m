Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab0D2DnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 23:43:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43741 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab0D2Dmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 23:42:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=kVSAU3gL4vb8PoJhxAJRhaIIA4WaqZtcbGgifxaxvCpkyNRenOUZA1n28HWuIsyY1Z
         i5GFxog0amrr2zCf71PXL/UK+ykRQLrutB+7nJ3J+NaMmdBkD0Jv7gTqOROPkcS9aAKr
         ySWCDcGYl/rLsp5COifgDvn7Undg7DalagYWY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
       John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 5/5] v4l: Remove struct v4l2_file_operations::ioctl
Date: Thu, 29 Apr 2010 05:42:44 +0200
Message-Id: <1272512564-14683-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <alpine.LFD.2.00.1004280750330.3739@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004280750330.3739@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No more drivers use the bkl'ed callback, now drop it for good.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 drivers/media/video/v4l2-dev.c |   38 ++++----------------------------------
 include/media/v4l2-dev.h       |    1 -
 2 files changed, 4 insertions(+), 35 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 7090699..702a026 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -215,19 +215,7 @@ static unsigned int v4l2_poll(struct file *filp, struct poll_table_struct *poll)
 	return vdev->fops->poll(filp, poll);
 }
 
-static int v4l2_ioctl(struct inode *inode, struct file *filp,
-		unsigned int cmd, unsigned long arg)
-{
-	struct video_device *vdev = video_devdata(filp);
-
-	if (!vdev->fops->ioctl)
-		return -ENOTTY;
-	/* Allow ioctl to continue even if the device was unregistered.
-	   Things like dequeueing buffers might still be useful. */
-	return vdev->fops->ioctl(filp, cmd, arg);
-}
-
-static long v4l2_unlocked_ioctl(struct file *filp,
+static long v4l2_ioctl(struct file *filp,
 		unsigned int cmd, unsigned long arg)
 {
 	struct video_device *vdev = video_devdata(filp);
@@ -307,22 +295,6 @@ static int v4l2_release(struct inode *inode, struct file *filp)
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
@@ -330,7 +302,7 @@ static const struct file_operations v4l2_fops = {
 	.open = v4l2_open,
 	.get_unmapped_area = v4l2_get_unmapped_area,
 	.mmap = v4l2_mmap,
-	.ioctl = v4l2_ioctl,
+	.unlocked_ioctl = v4l2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l2_compat_ioctl32,
 #endif
@@ -517,10 +489,8 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 		ret = -ENOMEM;
 		goto cleanup;
 	}
-	if (vdev->fops->unlocked_ioctl)
-		vdev->cdev->ops = &v4l2_unlocked_fops;
-	else
-		vdev->cdev->ops = &v4l2_fops;
+
+	vdev->cdev->ops = &v4l2_fops;
 	vdev->cdev->owner = vdev->fops->owner;
 	ret = cdev_add(vdev->cdev, MKDEV(VIDEO_MAJOR, vdev->minor), 1);
 	if (ret < 0) {
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 2dee938..9a05e85 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -38,7 +38,6 @@ struct v4l2_file_operations {
 	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
 	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
-	long (*ioctl) (struct file *, unsigned int, unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	unsigned long (*get_unmapped_area) (struct file *, unsigned long,
 				unsigned long, unsigned long, unsigned long);
-- 
1.6.2.3

