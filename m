Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165Ab0FRKVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 06:21:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:55175 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758003Ab0FRKVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 06:21:12 -0400
Date: Fri, 18 Jun 2010 10:20:45 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20100610231018.GA25942@redhat.com>
References: <20100610231018.GA25942@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: run_posix_cpu_timers: Don't check ->exit_state, use lock_task_sighand()
Message-ID: <tip-0bdd2ed4138ec04e09b4f8165981efc99e439f55@git.kernel.org>
Git-Commit-ID: 0bdd2ed4138ec04e09b4f8165981efc99e439f55
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 10:20:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0bdd2ed4138ec04e09b4f8165981efc99e439f55
Gitweb:     http://git.kernel.org/tip/0bdd2ed4138ec04e09b4f8165981efc99e439f55
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 11 Jun 2010 01:10:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Jun 2010 10:46:57 +0200

sched: run_posix_cpu_timers: Don't check ->exit_state, use lock_task_sighand()

run_posix_cpu_timers() doesn't work if current has already passed
exit_notify(). This was needed to prevent the races with do_wait().

Since ea6d290c ->signal is always valid and can't go away. We can
remove the "tsk->exit_state == 0" in fastpath_timer_check() and
convert run_posix_cpu_timers() to use lock_task_sighand().

Note: it makes sense to take group_leader's sighand instead, the
sub-thread still uses CPU after release_task(). But we need more
changes to do this.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100610231018.GA25942@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/posix-cpu-timers.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index bf2a650..d5dbef5 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1272,10 +1272,6 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 {
 	struct signal_struct *sig;
 
-	/* tsk == current, ensure it is safe to use ->signal/sighand */
-	if (unlikely(tsk->exit_state))
-		return 0;
-
 	if (!task_cputime_zero(&tsk->cputime_expires)) {
 		struct task_cputime task_sample = {
 			.utime = tsk->utime,
@@ -1308,6 +1304,7 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 {
 	LIST_HEAD(firing);
 	struct k_itimer *timer, *next;
+	unsigned long flags;
 
 	BUG_ON(!irqs_disabled());
 
@@ -1318,7 +1315,8 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 	if (!fastpath_timer_check(tsk))
 		return;
 
-	spin_lock(&tsk->sighand->siglock);
+	if (!lock_task_sighand(tsk, &flags))
+		return;
 	/*
 	 * Here we take off tsk->signal->cpu_timers[N] and
 	 * tsk->cpu_timers[N] all the timers that are firing, and
@@ -1340,7 +1338,7 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 	 * that gets the timer lock before we do will give it up and
 	 * spin until we've taken care of that timer below.
 	 */
-	spin_unlock(&tsk->sighand->siglock);
+	unlock_task_sighand(tsk, &flags);
 
 	/*
 	 * Now that all the timers on our list have the firing flag,
