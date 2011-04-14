Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab1DNIht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:37:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:49737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758374Ab1DNIhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:37:46 -0400
Date: Thu, 14 Apr 2011 08:37:18 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-ab2515c4b98f7bc4fa11cad9fa0f811d63a72a26@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152729.273362517@chello.nl>
References: <20110405152729.273362517@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Drop rq->lock from first part of wake_up_new_task()
Git-Commit-ID: ab2515c4b98f7bc4fa11cad9fa0f811d63a72a26
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:37:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab2515c4b98f7bc4fa11cad9fa0f811d63a72a26
Gitweb:     http://git.kernel.org/tip/ab2515c4b98f7bc4fa11cad9fa0f811d63a72a26
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:52 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:38 +0200

sched: Drop rq->lock from first part of wake_up_new_task()

Since p->pi_lock now protects all things needed to call
select_task_rq() avoid the double remote rq->lock acquisition and rely
on p->pi_lock.

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110405152729.273362517@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f155127..7c5494d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2736,28 +2736,18 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 {
 	unsigned long flags;
 	struct rq *rq;
-	int cpu __maybe_unused = get_cpu();
 
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
 #ifdef CONFIG_SMP
-	rq = task_rq_lock(p, &flags);
-	p->state = TASK_WAKING;
-
 	/*
 	 * Fork balancing, do it here and not earlier because:
 	 *  - cpus_allowed can change in the fork path
 	 *  - any previously selected cpu might disappear through hotplug
-	 *
-	 * We set TASK_WAKING so that select_task_rq() can drop rq->lock
-	 * without people poking at ->cpus_allowed.
 	 */
-	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
-	set_task_cpu(p, cpu);
-
-	p->state = TASK_RUNNING;
-	task_rq_unlock(rq, p, &flags);
+	set_task_cpu(p, select_task_rq(p, SD_BALANCE_FORK, 0));
 #endif
 
-	rq = task_rq_lock(p, &flags);
+	rq = __task_rq_lock(p);
 	activate_task(rq, p, 0);
 	p->on_rq = 1;
 	trace_sched_wakeup_new(p, true);
@@ -2767,7 +2757,6 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 		p->sched_class->task_woken(rq, p);
 #endif
 	task_rq_unlock(rq, p, &flags);
-	put_cpu();
 }
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
