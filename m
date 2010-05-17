Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab0EQGvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 02:51:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43872 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab0EQGu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 02:50:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=FwH4AfEzTxSBjX6JuEQ8J5MPwX8XAIYSdqWEZCAs1R8B1ZSEBRl/HdomlcNJeTjYaV
         Uk6/JgdwXpnklw+2uNaOL6svwEIAOfi6IXqBUHr4/i8i8LtP2rF2CYe/t8WqgjN3QeM3
         ZxtKiGumi7hN7hy5H2IzUVsH5eEKgvygE2Haw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
       John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 4/4] v4l: Remove struct v4l2_file_operations::ioctl
Date: Mon, 17 May 2010 08:50:52 +0200
Message-Id: <1274079052-23611-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1274079052-23611-1-git-send-regression-fweisbec@gmail.com>
References: <1274079052-23611-1-git-send-regression-fweisbec@gmail.com>
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
index 0ca7ec9..bbb9a75 100644
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
@@ -521,10 +493,8 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
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
index bebe44b..d167fbd 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -39,7 +39,6 @@ struct v4l2_file_operations {
 	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
 	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
-	long (*ioctl) (struct file *, unsigned int, unsigned long);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	unsigned long (*get_unmapped_area) (struct file *, unsigned long,
 				unsigned long, unsigned long, unsigned long);
-- 
1.6.2.3

