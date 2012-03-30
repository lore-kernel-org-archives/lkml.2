Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760431Ab2C3N52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:57:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47152 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914Ab2C3N5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:57:23 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH V2] Feature removal: schedule removal of setitimer accepting user's NULL pointer and set timer with 0 value
Date: Fri, 30 Mar 2012 19:29:52 +0530
Message-Id: <1333115992-8923-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_setitimer accepts the user pointer NULL and sets the time with 0 secs and 0 micro secs  i.e.

setitimer (which, NULL, NULL)

is equal to

timer.it_value.tv_sec = 0;
timer.it_value.tv_usec = 0;
timer.it_interval.tv_sec = 0;
timer.it_interval.tv_usec = 0;

setitimer (which, &timer, NULL);

But setitimer man page says "The function setitimer() sets the specified timer to the value in new_value".

If user pass new_value as NULL, kernel should not set timer with tv_sec = 0 and tv_usec = 0, instead return -EFAULT.

To avoid breaking exisiting user space added WARN_ONCE() if user pointer is NULL and 
scheduled the removal of this "feature" for v3.6

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 Documentation/feature-removal-schedule.txt |    9 +++++++++
 kernel/itimer.c                            |    5 ++++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0cad480..bc552ce 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -529,3 +529,12 @@ When:	3.5
 Why:	The old kmap_atomic() with two arguments is deprecated, we only
 	keep it for backward compatibility for few cycles and then drop it.
 Who:	Cong Wang <amwang@redhat.com>
+
+-------------------------------
+
+What:  setitimer accepts user's NULL pointer - interval timer pointer 
+When:  3.6
+Why:   setitimer is not returning -EFAULT if user point is NULL. If user passes
+       "struct itimerval *value" as NULL instead of returning -EFAULT it 
+       sets value of an interval timer to 0 secs and 0 micro secs.
+Who:   Sasikantha Babu <sasikanth.v19@gmail.com> 
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

