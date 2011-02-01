Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab1BANv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 08:51:57 -0500
Received: from www.tglx.de ([62.245.132.106]:47202 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095Ab1BANvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 08:51:55 -0500
Message-Id: <20110201134418.232288779@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 01 Feb 2011 13:51:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 08/28] posix-timers: Cleanup restart_block usage
References: <20110201134320.688829863@linutronix.de>
Content-Disposition: inline; filename=posix-timers-cleanup-restart-block.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

posix timers still use the legacy arg0-arg3 members of
restart_block. Use restart_block.nanosleep instead

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>
---
 kernel/posix-cpu-timers.c |   38 +++++++++++++++-----------------------
 kernel/posix-timers.c     |    2 +-
 2 files changed, 16 insertions(+), 24 deletions(-)

Index: linux-2.6-tip/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-cpu-timers.c
+++ linux-2.6-tip/kernel/posix-cpu-timers.c
@@ -1485,7 +1485,7 @@ int posix_cpu_nsleep(const clockid_t whi
 		     struct timespec *rqtp, struct timespec __user *rmtp)
 {
 	struct restart_block *restart_block =
-	    &current_thread_info()->restart_block;
+		&current_thread_info()->restart_block;
 	struct itimerspec it;
 	int error;
 
@@ -1501,50 +1501,42 @@ int posix_cpu_nsleep(const clockid_t whi
 
 	if (error == -ERESTART_RESTARTBLOCK) {
 
-	       	if (flags & TIMER_ABSTIME)
+		if (flags & TIMER_ABSTIME)
 			return -ERESTARTNOHAND;
 		/*
-	 	 * Report back to the user the time still remaining.
-	 	 */
-		if (rmtp != NULL && copy_to_user(rmtp, &it.it_value, sizeof *rmtp))
+		 * Report back to the user the time still remaining.
+		 */
+		if (rmtp && copy_to_user(rmtp, &it.it_value, sizeof *rmtp))
 			return -EFAULT;
 
 		restart_block->fn = posix_cpu_nsleep_restart;
-		restart_block->arg0 = which_clock;
-		restart_block->arg1 = (unsigned long) rmtp;
-		restart_block->arg2 = rqtp->tv_sec;
-		restart_block->arg3 = rqtp->tv_nsec;
+		restart_block->nanosleep.index = which_clock;
+		restart_block->nanosleep.rmtp = rmtp;
+		restart_block->nanosleep.expires = timespec_to_ns(rqtp);
 	}
 	return error;
 }
 
 long posix_cpu_nsleep_restart(struct restart_block *restart_block)
 {
-	clockid_t which_clock = restart_block->arg0;
-	struct timespec __user *rmtp;
+	clockid_t which_clock = restart_block->nanosleep.index;
 	struct timespec t;
 	struct itimerspec it;
 	int error;
 
-	rmtp = (struct timespec __user *) restart_block->arg1;
-	t.tv_sec = restart_block->arg2;
-	t.tv_nsec = restart_block->arg3;
+	t = ns_to_timespec(restart_block->nanosleep.expires);
 
-	restart_block->fn = do_no_restart_syscall;
 	error = do_cpu_nanosleep(which_clock, TIMER_ABSTIME, &t, &it);
 
 	if (error == -ERESTART_RESTARTBLOCK) {
+		struct timespec __user *rmtp = restart_block->nanosleep.rmtp;
 		/*
-	 	 * Report back to the user the time still remaining.
-	 	 */
-		if (rmtp != NULL && copy_to_user(rmtp, &it.it_value, sizeof *rmtp))
+		 * Report back to the user the time still remaining.
+		 */
+		if (rmtp && copy_to_user(rmtp, &it.it_value, sizeof *rmtp))
 			return -EFAULT;
 
-		restart_block->fn = posix_cpu_nsleep_restart;
-		restart_block->arg0 = which_clock;
-		restart_block->arg1 = (unsigned long) rmtp;
-		restart_block->arg2 = t.tv_sec;
-		restart_block->arg3 = t.tv_nsec;
+		restart_block->nanosleep.expires = timespec_to_ns(&t);
 	}
 	return error;
 
Index: linux-2.6-tip/kernel/posix-timers.c
===================================================================
--- linux-2.6-tip.orig/kernel/posix-timers.c
+++ linux-2.6-tip/kernel/posix-timers.c
@@ -1034,7 +1034,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const c
  */
 long clock_nanosleep_restart(struct restart_block *restart_block)
 {
-	clockid_t which_clock = restart_block->arg0;
+	clockid_t which_clock = restart_block->nanosleep.index;
 	struct k_clock *kc = clockid_to_kclock(which_clock);
 
 	return kc->nsleep_restart(restart_block);


