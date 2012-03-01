Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab2CAMVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:21:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37553 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664Ab2CAMVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:21:24 -0500
Date: Thu, 1 Mar 2012 04:20:42 -0800
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-755rvsosz7sdzot12a3gbha6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Prevent idle task boosting
Git-Commit-ID: 1c4dd99bed5f6f70932bf8dacdd54d04a2619778
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 01 Mar 2012 04:21:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c4dd99bed5f6f70932bf8dacdd54d04a2619778
Gitweb:     http://git.kernel.org/tip/1c4dd99bed5f6f70932bf8dacdd54d04a2619778
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 6 Jun 2011 20:07:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 1 Mar 2012 10:28:05 +0100

sched/rt: Prevent idle task boosting

Idle task boosting is a nono in general. There is one
exception, when PREEMPT_RT and NOHZ is active:

The idle task calls get_next_timer_interrupt() and holds
the timer wheel base->lock on the CPU and another CPU wants
to access the timer (probably to cancel it). We can safely
ignore the boosting request, as the idle CPU runs this code
with interrupts disabled and will complete the lock
protected section without being interrupted. So there is no
real need to boost.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-755rvsosz7sdzot12a3gbha6@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 820f745..c2bbdec 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3779,6 +3779,24 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 
 	rq = __task_rq_lock(p);
 
+	/*
+	 * Idle task boosting is a nono in general. There is one
+	 * exception, when PREEMPT_RT and NOHZ is active:
+	 *
+	 * The idle task calls get_next_timer_interrupt() and holds
+	 * the timer wheel base->lock on the CPU and another CPU wants
+	 * to access the timer (probably to cancel it). We can safely
+	 * ignore the boosting request, as the idle CPU runs this code
+	 * with interrupts disabled and will complete the lock
+	 * protected section without being interrupted. So there is no
+	 * real need to boost.
+	 */
+	if (unlikely(p == rq->idle)) {
+		WARN_ON(p != rq->curr);
+		WARN_ON(p->pi_blocked_on);
+		goto out_unlock;
+	}
+
 	trace_sched_pi_setprio(p, prio);
 	oldprio = p->prio;
 	prev_class = p->sched_class;
@@ -3802,11 +3820,10 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
 
 	check_class_changed(rq, p, prev_class, oldprio);
+out_unlock:
 	__task_rq_unlock(rq);
 }
-
 #endif
-
 void set_user_nice(struct task_struct *p, long nice)
 {
 	int old_prio, delta, on_rq;
