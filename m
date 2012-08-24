Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951Ab2HXSyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:54:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859Ab2HXSxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:53:54 -0400
Date: Fri, 24 Aug 2012 20:56:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: lockdep trace from posix timers
Message-ID: <20120824185619.GA16719@redhat.com>
References: <1345463081.23018.34.camel@twins> <20120820150507.GC18499@redhat.com> <1345475530.23018.50.camel@twins> <20120820154154.GB20258@redhat.com> <1345478211.23018.69.camel@twins> <20120820161012.GC21400@redhat.com> <1345479590.23018.75.camel@twins> <20120820162302.GA22354@redhat.com> <20120821182751.GA11243@redhat.com> <20120821183408.GA11721@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821183408.GA11721@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Oleg Nesterov wrote:
>
> > task_work_add(struct task_struct *task, struct callback_head *twork, bool notify)
> > {
> > 	do {
> > 		twork->next = ACCESS_ONCE(task->task_works);
> > 		if (unlikely(twork->next == TWORK_EXITED))
> > 			return -ESRCH;
> > 	} while (cmp_xchg(&task->task_works, twork->next, twork));
>           ^^^^^^^^^^^^^^^
>
> while (!cmp_xchg(...))

and _cancel can be simplified a bit.

OK, I actually tested the code below, seems to work.

Peter, if you think it can work for you and if you agree with
the implementation I will be happy to send the patch.

The only change outside of task_work.c is that exit_task_work()
should call task_work_run() unconditionally.

As for cmp_xchg below... Of course it is not strictly needed.
But otoh, personally I'd like to have this helper (probably
renamed) somewhere in include/linux. Perhaps this is just me,
but cmpxchg() always confuses me, and most users only need
success_or_not from cmpxchg.

Oleg.


#define cmp_xchg(ptr, _old, new)	\
({					\
	__typeof__(_old) old = (_old);	\
	cmpxchg(ptr, old, new) == old;	\
})

#define TWORK_EXITED	((struct callback_head*)1)

int
task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
{
	do {
		work->next = ACCESS_ONCE(task->task_works);
		if (unlikely(work->next == TWORK_EXITED))
			return -ESRCH;
	} while (!cmp_xchg(&task->task_works, work->next, work));

	/* test_and_set_bit() implies mb(), see tracehook_notify_resume(). */
	if (notify)
		set_notify_resume(task);
	return 0;
}

struct callback_head *
task_work_cancel(struct task_struct *task, task_work_func_t func)
{
	struct callback_head **pprev = &task->task_works;
	struct callback_head *work = NULL;
	unsigned long flags;

	raw_spin_lock_irqsave(&task->pi_lock, flags);
	if (likely(*pprev != TWORK_EXITED)) {
		while ((work = *pprev)) {
			read_barrier_depends();
			if (work->func != func)
				pprev = &work->next;
			else if (cmp_xchg(pprev, work, work->next))
				break;
		}
	}
	raw_spin_unlock_irqrestore(&task->pi_lock, flags);

	return work;
}

void task_work_run(void)
{
	struct task_struct *task = current;
	struct callback_head *work, *head, *next;

	for (;;) {
		raw_spin_lock_irq(&task->pi_lock);
		do {
			work = ACCESS_ONCE(task->task_works);
			head = !work && (task->flags & PF_EXITING) ?
				TWORK_EXITED : NULL;
		} while (!cmp_xchg(&task->task_works, work, head));
		raw_spin_unlock_irq(&task->pi_lock);

		if (!work)
			break;

#if PETERZ_WONT_ARGUE_AGAINST_FIFO_TOO_MUCH
		head = NULL;
		do {
			next = work->next;
			work->next = head;
			head = work;
			work = next;
		} while (work);

		work = head;
#endif
		do {
			next = work->next;
			work->func(work);
			work = next;
			cond_resched();
		} while (work);
	}
}

