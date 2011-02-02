Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1BBV6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:58:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:50494 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440Ab1BBV6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:58:09 -0500
Date: Wed, 2 Feb 2011 21:57:52 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134418.232288779@linutronix.de>
References: <20110201134418.232288779@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Cleanup restart_block usage
Message-ID: <tip-3751f9f29bcbc19bd10e92254a273486f150c245@git.kernel.org>
Git-Commit-ID: 3751f9f29bcbc19bd10e92254a273486f150c245
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 21:57:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3751f9f29bcbc19bd10e92254a273486f150c245
Gitweb:     http://git.kernel.org/tip/3751f9f29bcbc19bd10e92254a273486f150c245
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:51:20 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:13 +0100

posix-timers: Cleanup restart_block usage

posix timers still use the legacy arg0-arg3 members of
restart_block. Use restart_block.nanosleep instead

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134418.232288779@linutronix.de>
---
 kernel/posix-cpu-timers.c |   38 +++++++++++++++-----------------------
 kernel/posix-timers.c     |    2 +-
 2 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 816cd49..9e617b0 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1485,7 +1485,7 @@ int posix_cpu_nsleep(const clockid_t which_clock, int flags,
 		     struct timespec *rqtp, struct timespec __user *rmtp)
 {
 	struct restart_block *restart_block =
-	    &current_thread_info()->restart_block;
+		&current_thread_info()->restart_block;
 	struct itimerspec it;
 	int error;
 
@@ -1501,50 +1501,42 @@ int posix_cpu_nsleep(const clockid_t which_clock, int flags,
 
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
 
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 4dd86d1..4762986 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -1034,7 +1034,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
  */
 long clock_nanosleep_restart(struct restart_block *restart_block)
 {
-	clockid_t which_clock = restart_block->arg0;
+	clockid_t which_clock = restart_block->nanosleep.index;
 	struct k_clock *kc = clockid_to_kclock(which_clock);
 
 	if (WARN_ON_ONCE(!kc || !kc->nsleep_restart))
