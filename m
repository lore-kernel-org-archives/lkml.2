Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939Ab0FJXME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 19:12:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759880Ab0FJXL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 19:11:58 -0400
Date: Fri, 11 Jun 2010 01:10:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] run_posix_cpu_timers: don't check ->exit_state, use
	lock_task_sighand()
Message-ID: <20100610231018.GA25942@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

run_posix_cpu_timers() doesn't work if current has already passed
exit_notify(). This was needed to prevent the races with do_wait().

Since ea6d290c ->signal is always valid and can't go away. We can
remove the "tsk->exit_state == 0" in fastpath_timer_check() and
convert run_posix_cpu_timers() to use lock_task_sighand().

Note: it makes sense to take group_leader's sighand instead, the
sub-thread still uses CPU after release_task(). But we need more
changes to do this.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/posix-cpu-timers.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- 35-rc2/kernel/posix-cpu-timers.c~5_RUN_PCT_DONT_CK_EXIT_STATE	2010-06-11 01:07:48.000000000 +0200
+++ 35-rc2/kernel/posix-cpu-timers.c	2010-06-11 01:08:03.000000000 +0200
@@ -1272,10 +1272,6 @@ static inline int fastpath_timer_check(s
 {
 	struct signal_struct *sig;
 
-	/* tsk == current, ensure it is safe to use ->signal/sighand */
-	if (unlikely(tsk->exit_state))
-		return 0;
-
 	if (!task_cputime_zero(&tsk->cputime_expires)) {
 		struct task_cputime task_sample = {
 			.utime = tsk->utime,
@@ -1308,6 +1304,7 @@ void run_posix_cpu_timers(struct task_st
 {
 	LIST_HEAD(firing);
 	struct k_itimer *timer, *next;
+	unsigned long flags;
 
 	BUG_ON(!irqs_disabled());
 
@@ -1318,7 +1315,8 @@ void run_posix_cpu_timers(struct task_st
 	if (!fastpath_timer_check(tsk))
 		return;
 
-	spin_lock(&tsk->sighand->siglock);
+	if (!lock_task_sighand(tsk, &flags))
+		return;
 	/*
 	 * Here we take off tsk->signal->cpu_timers[N] and
 	 * tsk->cpu_timers[N] all the timers that are firing, and
@@ -1340,7 +1338,7 @@ void run_posix_cpu_timers(struct task_st
 	 * that gets the timer lock before we do will give it up and
 	 * spin until we've taken care of that timer below.
 	 */
-	spin_unlock(&tsk->sighand->siglock);
+	unlock_task_sighand(tsk, &flags);
 
 	/*
 	 * Now that all the timers on our list have the firing flag,

