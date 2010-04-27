Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab0D0JTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:19:05 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:52542 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab0D0JS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:18:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Fj/TNH/HDJCDOBbgjv2d5sPTl33RgO7WJM9whalT5g/k7e/lFIhecpNd9Qw7bKJlyU
         aV1ouwDyj4v3fOGiJzv9vMLkuF2DNGiryg6bBiQLBUKajV56YU9/DKwsJnmDTb4twUC0
         XW3QSq8C2hzpa9YtPL9fzH/E7AXcoQ1sMwR5k=
From: John Kacur <jkacur@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 08/10] v4l: always use unlocked_ioctl
Date: Tue, 27 Apr 2010 11:18:16 +0200
Message-Id: <1272359898-32020-9-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

v4l drivers may still use a locked ioctl method,
but we now always export an unlocked_ioctl and
lock ourselves, so that the ->ioctl file operation
can get removed.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Fixed merge conflicts that result from having applied
Linus's Preparation for BKL'ed ioctl removal patch first.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/media/video/v4l2-dev.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index c48143a..3606694 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/errno.h>
+#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/kmod.h>
 #include <linux/slab.h>
@@ -215,16 +216,21 @@ static unsigned int v4l2_poll(struct file *filp, struct poll_table_struct *poll)
 	return vdev->fops->poll(filp, poll);
 }
 
-static int v4l2_ioctl(struct inode *inode, struct file *filp,
+static long v4l2_ioctl(struct file *filp,
 		unsigned int cmd, unsigned long arg)
 {
 	struct video_device *vdev = video_devdata(filp);
+	int ret;
 
 	if (!vdev->fops->ioctl)
 		return -ENOTTY;
 	/* Allow ioctl to continue even if the device was unregistered.
 	   Things like dequeueing buffers might still be useful. */
-	return vdev->fops->ioctl(filp, cmd, arg);
+	lock_kernel();
+	ret = vdev->fops->ioctl(filp->f_path.dentry->d_inode, filp, cmd, arg);
+	unlock_kernel();
+
+	return ret;
 }
 
 static long v4l2_unlocked_ioctl(struct file *filp,
@@ -323,6 +329,11 @@ static const struct file_operations v4l2_unlocked_fops = {
 	.llseek = no_llseek,
 };
 
+/*
+ * Note: this should not be needed, just check
+ *       both pointers in v4l2_ioctl, or kill
+ *       fops->ioctl. -arnd
+ */
 static const struct file_operations v4l2_fops = {
 	.owner = THIS_MODULE,
 	.read = v4l2_read,
@@ -330,7 +341,7 @@ static const struct file_operations v4l2_fops = {
 	.open = v4l2_open,
 	.get_unmapped_area = v4l2_get_unmapped_area,
 	.mmap = v4l2_mmap,
-	.bkl_ioctl = v4l2_ioctl,
+	.unlocked_ioctl = v4l2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l2_compat_ioctl32,
 #endif
-- 
1.6.6.1

