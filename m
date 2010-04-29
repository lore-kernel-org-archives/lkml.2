Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab0D2Dmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 23:42:50 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:40342 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab0D2Dmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 23:42:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=abjleDGlUhbgFO5WIkAEYkGsd/tyPrQuVPU3Lbr4bvCCQakwclanqR6dx/631+Ra/l
         4/BStfB5rp7VthY2ctrn8yGAGqFQVqQOLnla0Bf35Z7gfaxfX/cr2ThMAI62PlRZX41a
         8w6WFcjYIpr4540wrwBlHy8yFz1OtpsV6zyy4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
       John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/5] v4l: Pushdown bkl into video_ioctl2
Date: Thu, 29 Apr 2010 05:42:40 +0200
Message-Id: <1272512564-14683-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <alpine.LFD.2.00.1004280750330.3739@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004280750330.3739@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

video_ioctl2 is a generic ioctl helper used by a lot of drivers.
Most of them put it as their bkl'ed .ioctl callback, then let's
pushdown the bkl inside but also provide an unlocked version for
those that use it as an unlocked ioctl.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 drivers/media/video/v4l2-ioctl.c |   17 +++++++++++++++--
 include/media/v4l2-ioctl.h       |    2 ++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 3da8d8f..0ff2595 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/smp_lock.h>
 
 #define __OLD_VIDIOC_ /* To allow fixing old calls */
 #include <linux/videodev.h>
@@ -2007,8 +2008,8 @@ static unsigned long cmd_input_size(unsigned int cmd)
 	}
 }
 
-long video_ioctl2(struct file *file,
-	       unsigned int cmd, unsigned long arg)
+long video_ioctl2_unlocked(struct file *file,
+			   unsigned int cmd, unsigned long arg)
 {
 	char	sbuf[128];
 	void    *mbuf = NULL;
@@ -2102,4 +2103,16 @@ out:
 	kfree(mbuf);
 	return err;
 }
+EXPORT_SYMBOL(video_ioctl2_unlocked);
+
+long video_ioctl2(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	lock_kernel();
+	ret = video_ioctl2_unlocked(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
 EXPORT_SYMBOL(video_ioctl2);
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index e8ba0f2..08b3e42 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -316,5 +316,7 @@ extern long video_usercopy(struct file *file, unsigned int cmd,
 /* Standard handlers for V4L ioctl's */
 extern long video_ioctl2(struct file *file,
 			unsigned int cmd, unsigned long arg);
+extern long video_ioctl2_unlocked(struct file *file,
+				  unsigned int cmd, unsigned long arg);
 
 #endif /* _V4L2_IOCTL_H */
-- 
1.6.2.3

