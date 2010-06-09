Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab0FIKOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:14:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:41272 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab0FIKN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:13:59 -0400
Date: Wed, 9 Jun 2010 10:13:20 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20100519125711.GA30199@redhat.com>
References: <20100519125711.GA30199@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Simplify the reacquire_kernel_lock() logic
Message-ID: <tip-246d86b51845063e4b06b27579990492dc5fa317@git.kernel.org>
Git-Commit-ID: 246d86b51845063e4b06b27579990492dc5fa317
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:13:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  246d86b51845063e4b06b27579990492dc5fa317
Gitweb:     http://git.kernel.org/tip/246d86b51845063e4b06b27579990492dc5fa317
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Wed, 19 May 2010 14:57:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 10:34:50 +0200

sched: Simplify the reacquire_kernel_lock() logic

- Contrary to what 6d558c3a says, there is no need to reload
  prev = rq->curr after the context switch. You always schedule
  back to where you came from, prev must be equal to current
  even if cpu/rq was changed.

- This also means reacquire_kernel_lock() can use prev instead
  of current.

- No need to reassign switch_count if reacquire_kernel_lock()
  reports need_resched(), we can just move the initial assignment
  down, under the "need_resched_nonpreemptible:" label.

- Try to update the comment after context_switch().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100519125711.GA30199@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3abd8f7..f37a961 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3636,7 +3636,6 @@ need_resched:
 	rq = cpu_rq(cpu);
 	rcu_note_context_switch(cpu);
 	prev = rq->curr;
-	switch_count = &prev->nivcsw;
 
 	release_kernel_lock(prev);
 need_resched_nonpreemptible:
@@ -3649,6 +3648,7 @@ need_resched_nonpreemptible:
 	raw_spin_lock_irq(&rq->lock);
 	clear_tsk_need_resched(prev);
 
+	switch_count = &prev->nivcsw;
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely(signal_pending_state(prev->state, prev))) {
 			prev->state = TASK_RUNNING;
@@ -3689,8 +3689,10 @@ need_resched_nonpreemptible:
 
 		context_switch(rq, prev, next); /* unlocks the rq */
 		/*
-		 * the context switch might have flipped the stack from under
-		 * us, hence refresh the local variables.
+		 * The context switch have flipped the stack from under us
+		 * and restored the local variables which were saved when
+		 * this task called schedule() in the past. prev == current
+		 * is still correct, but it can be moved to another cpu/rq.
 		 */
 		cpu = smp_processor_id();
 		rq = cpu_rq(cpu);
@@ -3699,11 +3701,8 @@ need_resched_nonpreemptible:
 
 	post_schedule(rq);
 
-	if (unlikely(reacquire_kernel_lock(current) < 0)) {
-		prev = rq->curr;
-		switch_count = &prev->nivcsw;
+	if (unlikely(reacquire_kernel_lock(prev)))
 		goto need_resched_nonpreemptible;
-	}
 
 	preempt_enable_no_resched();
 	if (need_resched())
