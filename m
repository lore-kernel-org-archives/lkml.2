Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab0ESM76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:59:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab0ESM7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:59:55 -0400
Date: Wed, 19 May 2010 14:57:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Yong Zhang <yong.zhang0@gmail.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] schedule: simplify the reacquire_kernel_lock() logic
Message-ID: <20100519125711.GA30199@redhat.com>
References: <20100518164537.6194.73366.stgit@warthog.procyon.org.uk> <20100518164547.6194.94193.stgit@warthog.procyon.org.uk> <20100518212220.GA5092@redhat.com> <1274250079.5605.9967.camel@twins> <20100519102743.GA10040@redhat.com> <1274265465.5605.10564.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274265465.5605.10564.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

 kernel/sched.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- 34-rc1/kernel/sched.c~SCHEDULE_PREV_EQ_TO_CURRENT	2010-05-18 23:32:50.000000000 +0200
+++ 34-rc1/kernel/sched.c	2010-05-19 14:32:57.000000000 +0200
@@ -3679,7 +3679,6 @@ need_resched:
 	rq = cpu_rq(cpu);
 	rcu_sched_qs(cpu);
 	prev = rq->curr;
-	switch_count = &prev->nivcsw;
 
 	release_kernel_lock(prev);
 need_resched_nonpreemptible:
@@ -3693,6 +3692,7 @@ need_resched_nonpreemptible:
 	update_rq_clock(rq);
 	clear_tsk_need_resched(prev);
 
+	switch_count = &prev->nivcsw;
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely(signal_pending_state(prev->state, prev)))
 			prev->state = TASK_RUNNING;
@@ -3719,8 +3719,10 @@ need_resched_nonpreemptible:
 
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
@@ -3729,11 +3731,8 @@ need_resched_nonpreemptible:
 
 	post_schedule(rq);
 
-	if (unlikely(reacquire_kernel_lock(current) < 0)) {
-		prev = rq->curr;
-		switch_count = &prev->nivcsw;
+	if (unlikely(reacquire_kernel_lock(prev)))
 		goto need_resched_nonpreemptible;
-	}
 
 	preempt_enable_no_resched();
 	if (need_resched())

