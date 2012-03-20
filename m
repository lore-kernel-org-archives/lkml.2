Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760430Ab2CTOuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:50:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54589 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760247Ab2CTOuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:50:08 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH 1/1] setitimer : Return -EFAULT if the user pointer "value" is NULL
Date: Tue, 20 Mar 2012 20:21:55 +0530
Message-Id: <1332255115-13036-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -EFAULT if user  pointer "value" is  NULL.

In the current timer implementation  

setitimer (which, NULL, NULL)

is equal to

timer.it_value.tv_sec = 0;
timer.it_value.tv_usec = 0;
timer.it_interval.tv_sec = 0;
timer.it_interval.tv_usec = 0;

setitimer (which, &timer, NULL);

setitimer man page says "The function setitimer() sets the specified timer to the value in new_value".

If the new_value is NULL, kernel should not set timer with tv_sec = 0 and tv_usec = 0, instead return -EFAULT.

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 kernel/itimer.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/kernel/itimer.c b/kernel/itimer.c
index 22000c3..f356bdf 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -279,19 +279,18 @@ SYSCALL_DEFINE3(setitimer, int, which, struct itimerval __user *, value,
 		struct itimerval __user *, ovalue)
 {
 	struct itimerval set_buffer, get_buffer;
-	int error;
+	int error = -EFAULT;
 
 	if (value) {
 		if(copy_from_user(&set_buffer, value, sizeof(set_buffer)))
 			return -EFAULT;
-	} else
-		memset((char *) &set_buffer, 0, sizeof(set_buffer));
 
-	error = do_setitimer(which, &set_buffer, ovalue ? &get_buffer : NULL);
-	if (error || !ovalue)
-		return error;
+		error = do_setitimer(which, &set_buffer, ovalue ? &get_buffer : NULL);
+		if (error || !ovalue)
+			return error;
 
-	if (copy_to_user(ovalue, &get_buffer, sizeof(get_buffer)))
-		return -EFAULT;
-	return 0;
+		if (copy_to_user(ovalue, &get_buffer, sizeof(get_buffer)))
+			return -EFAULT;
+	}
+	return error;
 }
-- 
1.7.3.4

