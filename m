Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1CXR2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:28:35 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51079 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1CXR2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:28:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=C4g3L8/lpoTSrh20XlXJpPWsmxySy3y1cZtdB8Ctl3cVWYarlnddzFJfIGib2qrL4j
         CUcBHyAaZXcaJ7Y72KvVMxivD50BgVYFtdjrjOjnOQQPw23FttIKhQULTkGqx0iSdcGl
         05UaIV6eAy90Np0+QbFSOVCdbTtM+OobVL73w=
From: Michael Rodriguez <dkingston02@gmail.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Michael Rodriguez <dkingston02@gmail.com>
Subject: [PATCH] kernel/itimer.c use ternary operators where appropriate and fix all style issues.
Date: Thu, 24 Mar 2011 13:26:03 -0400
Message-Id: <1300987563-27697-1-git-send-email-dkingston02@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Rodriguez <dkingston02@gmail.com>
---
 kernel/itimer.c |   32 +++++++++++---------------------
 1 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/kernel/itimer.c b/kernel/itimer.c
index d802883..d07ace5 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -12,10 +12,9 @@
 #include <linux/time.h>
 #include <linux/posix-timers.h>
 #include <linux/hrtimer.h>
+#include <linux/uaccess.h>
 #include <trace/events/timer.h>
 
-#include <asm/uaccess.h>
-
 /**
  * itimer_get_remtime - get remaining time for the timer
  *
@@ -33,12 +32,8 @@ static struct timeval itimer_get_remtime(struct hrtimer *timer)
 	 * hrtimer_get_remtime() call but before this condition
 	 * then we return 0 - which is correct.
 	 */
-	if (hrtimer_active(timer)) {
-		if (rem.tv64 <= 0)
-			rem.tv64 = NSEC_PER_USEC;
-	} else
-		rem.tv64 = 0;
-
+	rem.tv64 = ((hrtimer_active(timer) && rem.tv64 <= 0) ?
+			NSEC_PER_USEC : 0);
 	return ktime_to_timeval(rem);
 }
 
@@ -57,17 +52,12 @@ static void get_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
 		cputime_t t;
 
 		thread_group_cputimer(tsk, &cputime);
-		if (clock_id == CPUCLOCK_PROF)
-			t = cputime_add(cputime.utime, cputime.stime);
-		else
-			/* CPUCLOCK_VIRT */
-			t = cputime.utime;
-
-		if (cputime_le(cval, t))
-			/* about to fire */
-			cval = cputime_one_jiffy;
-		else
-			cval = cputime_sub(cval, t);
+
+		t = (clock_id == CPUCLOCK_PROF) ? cputime_add(cputime.utime,
+			cputime.stime) : cputime.utime;
+
+		cval = (cputime_le(cval, t) ? cputime_one_jiffy :
+			cputime_sub(cval, t));
 	}
 
 	spin_unlock_irq(&tsk->sighand->siglock);
@@ -95,7 +85,7 @@ int do_getitimer(int which, struct itimerval *value)
 		get_cpu_itimer(tsk, CPUCLOCK_PROF, value);
 		break;
 	default:
-		return(-EINVAL);
+		return -EINVAL;
 	}
 	return 0;
 }
@@ -283,7 +273,7 @@ SYSCALL_DEFINE3(setitimer, int, which, struct itimerval __user *, value,
 	int error;
 
 	if (value) {
-		if(copy_from_user(&set_buffer, value, sizeof(set_buffer)))
+		if (copy_from_user(&set_buffer, value, sizeof(set_buffer)))
 			return -EFAULT;
 	} else
 		memset((char *) &set_buffer, 0, sizeof(set_buffer));
-- 
1.7.4.1

