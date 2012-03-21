Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab2CUOjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:39:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64622 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757738Ab2CUOjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:39:03 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH 1/1] setitimer : Return -EFAULT if the user pointer "value" is NULL
Date: Wed, 21 Mar 2012 20:10:54 +0530
Message-Id: <1332340854-26053-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added WARN_ONCE() in the else path and schedule the removal of this "feature" for v3.6

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 Documentation/feature-removal-schedule.txt |    9 +++++++++
 kernel/itimer.c                            |    5 ++++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index d5dc80f..d943987 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -535,3 +535,12 @@ Why:	This driver provides support for USB storage devices like "USB
         (CONFIG_USB_STORAGE) which only drawback is the additional SCSI
         stack.
 Who:	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
+
+----------------------------
+
+What:	setitimer accepts user's NULL pointer - interval timer pointer 
+When:	3.6
+Why:	setitimer is not returning -EFAULT if user point is NULL. If user passes
+	"struct itimerval *value" as NULL instead of returning -EFAULT it 
+	sets value of an interval timer to 0 secs and 0 micro secs.
+Who:	Sasikantha Babu <sasikanth.v19@gmail.com>
diff --git a/kernel/itimer.c b/kernel/itimer.c
index 22000c3..10f3cfb 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -284,8 +284,11 @@ SYSCALL_DEFINE3(setitimer, int, which, struct itimerval __user *, value,
 	if (value) {
 		if(copy_from_user(&set_buffer, value, sizeof(set_buffer)))
 			return -EFAULT;
-	} else
+	} else {
 		memset((char *) &set_buffer, 0, sizeof(set_buffer));
+		WARN_ONCE (!value, "setitimer: Support for handling NULL user pointer "
+				    " will be removed");
+	}
 
 	error = do_setitimer(which, &set_buffer, ovalue ? &get_buffer : NULL);
 	if (error || !ovalue)
-- 
1.7.3.4

