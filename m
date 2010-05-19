Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737Ab0ESLiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:38:51 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:39302 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab0ESLio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:38:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=uOUVvyxXjKIK3Jk6KLroBZkHF8hlcsJY+IzrWsYyz7bvmEe5nQm6fZDrrrqN799rf5
         25I7bmNA+zbKxaqfYZEnw9lbZt7mCtxi8QyvvSH98NBISvyrgTCDjQcFT+uHxhEpBDb/
         pDNHk3wBrIfWkQ5Ue9qsZ6xSRbqlH7Igk2WcI=
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
Subject: [PATCH 1/4] v4l: Introduce video_ioctl2_bkl
Date: Wed, 19 May 2010 13:38:43 +0200
Message-Id: <1274269126-3274-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1274269126-3274-1-git-send-regression-fweisbec@gmail.com>
References: <1274269126-3274-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

video_ioctl2 is a generic ioctl helper used by a lot of drivers.
Most of them put it as their bkl'ed .ioctl callback, then provide
a bkl'ed version of this helper so that drivers can use it as an
unlocked_ioctl callback, making it easy to remove the .ioctl
field from the v4l fops.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-ioctl.c |   14 ++++++++++++++
 include/media/v4l2-ioctl.h       |    3 +++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 0eeceae..154258e 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/smp_lock.h>
 
 #define __OLD_VIDIOC_ /* To allow fixing old calls */
 #include <linux/videodev.h>
@@ -2156,3 +2157,16 @@ out:
 	return err;
 }
 EXPORT_SYMBOL(video_ioctl2);
+
+
+long video_ioctl2_bkl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	lock_kernel();
+	ret = video_ioctl2(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+EXPORT_SYMBOL(video_ioctl2_bkl);
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 06daa6e..a128ed4 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -324,4 +324,7 @@ extern long video_usercopy(struct file *file, unsigned int cmd,
 extern long video_ioctl2(struct file *file,
 			unsigned int cmd, unsigned long arg);
 
+extern long video_ioctl2_bkl(struct file *file,
+			     unsigned int cmd, unsigned long arg);
+
 #endif /* _V4L2_IOCTL_H */
-- 
1.6.2.3

