Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab0DZWZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:25:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61642 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab0DZWZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:25:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/6] v4l: always use unlocked_ioctl
Date: Tue, 27 Apr 2010 00:24:04 +0200
Message-Id: <1272320645-8671-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <201004262112.39906.arnd@arndb.de>
References: <201004262112.39906.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19aDW0w892hCBnPW7hzONDzEMc2WjDUB4bi1NN
 WPkeEbOF72wHhGB6CzLLSaB8pXKV+yKhoEbnIyakA8kyEKVGo1
 SqOB0XLJULnSQ6O2AVHrA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v4l drivers may still use a locked ioctl method,
but we now always export an unlocked_ioctl and
lock ourselves, so that the ->ioctl file operation
can get removed.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/video/v4l2-dev.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 7090699..3606694 100644
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
-	.ioctl = v4l2_ioctl,
+	.unlocked_ioctl = v4l2_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = v4l2_compat_ioctl32,
 #endif
-- 
1.7.0.4

