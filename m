Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab0ERVZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:25:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242Ab0ERVZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:25:31 -0400
Date: Tue, 18 May 2010 23:22:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: schedule() && prev/current (Was: [PATCH 3/3] Make get_current()
	__attribute__((const)))
Message-ID: <20100518212220.GA5092@redhat.com>
References: <20100518164537.6194.73366.stgit@warthog.procyon.org.uk> <20100518164547.6194.94193.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518164547.6194.94193.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18, David Howells wrote:
>
> This doesn't break cached copies of current, whether they're cached by gcc in
> registers or on the stack.  switch_to() will save all registers on the stack
> before actually switching, then when it switches current, it will also switch
> the stack and then pop back what was stored in the 'unclobbered' registers for
> the now active task and stack.  Thus the copies of current that were cached
> just work.
>
> [...snip...]
>
> --- a/include/asm-generic/current.h
> +++ b/include/asm-generic/current.h
> @@ -3,7 +3,14 @@
>
>  #include <linux/thread_info.h>
>
> -#define get_current() (current_thread_info()->task)
> +struct task_struct;
> +
> +static inline __attribute_const__
> +struct task_struct *get_current(void)
> +{
> +	return current_thread_info()->task;
> +}

Can't ack this patch, but it looks correct to me.


And, looking at this patch I think that schedule() can be simplified
a little bit.

"sched: Reassign prev and switch_count when reacquire_kernel_lock() fail"
commit 6d558c3ac9b6508d26fd5cadccce51fc9d726b1c says:

	Assume A->B schedule is processing,
	...
	Then on B's context,
	...
	prev and switch_count are related to A

How so? switch_count - yes, we should change it. But prev must be
equal to B, and it must be equal to current. When we return from
switch_to() registers/stack should be restored correctly, so we
can do

	--- x/kernel/sched.c
	+++ x/kernel/sched.c
	@@ -3729,8 +3729,7 @@ need_resched_nonpreemptible:
	 
		post_schedule(rq);
	 
	-	if (unlikely(reacquire_kernel_lock(current) < 0)) {
	-		prev = rq->curr;
	+	if (unlikely(reacquire_kernel_lock(prev) < 0)) {
			switch_count = &prev->nivcsw;
			goto need_resched_nonpreemptible;
		}

and in fact we can simplify this even more, no need to reassign
switch_count, we can just move the initial assignment down, under
"need_resched_nonpreemptible" label.

switch_to(prev, next, prev) changes "prev" inside context_switch()
but it should be stable inside of schedule().

Oleg.

--- x/kernel/sched.c
+++ x/kernel/sched.c
@@ -3708,7 +3708,6 @@ need_resched:
 	rq = cpu_rq(cpu);
 	rcu_sched_qs(cpu);
 	prev = rq->curr;
-	switch_count = &prev->nivcsw;
 
 	release_kernel_lock(prev);
 need_resched_nonpreemptible:
@@ -3722,6 +3721,7 @@ need_resched_nonpreemptible:
 	update_rq_clock(rq);
 	clear_tsk_need_resched(prev);
 
+	switch_count = &prev->nivcsw;
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely(signal_pending_state(prev->state, prev)))
 			prev->state = TASK_RUNNING;
@@ -3758,11 +3758,8 @@ need_resched_nonpreemptible:
 
 	post_schedule(rq);
 
-	if (unlikely(reacquire_kernel_lock(current) < 0)) {
-		prev = rq->curr;
-		switch_count = &prev->nivcsw;
+	if (unlikely(reacquire_kernel_lock(prev))
 		goto need_resched_nonpreemptible;
-	}
 
 	preempt_enable_no_resched();
 	if (need_resched())

