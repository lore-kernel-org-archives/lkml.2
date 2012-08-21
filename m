Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab2HUSbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:31:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274Ab2HUSbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:31:32 -0400
Date: Tue, 21 Aug 2012 20:27:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: lockdep trace from posix timers
Message-ID: <20120821182751.GA11243@redhat.com>
References: <20120817151447.GA7918@redhat.com> <1345446957.23018.14.camel@twins> <1345463081.23018.34.camel@twins> <20120820150507.GC18499@redhat.com> <1345475530.23018.50.camel@twins> <20120820154154.GB20258@redhat.com> <1345478211.23018.69.camel@twins> <20120820161012.GC21400@redhat.com> <1345479590.23018.75.camel@twins> <20120820162302.GA22354@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820162302.GA22354@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Oleg Nesterov wrote:
>
> On 08/20, Peter Zijlstra wrote:
> >
> > Anyway, would taking ->pi_lock over _cancel and _run suffice?
>
> I thinks yes... But I can't think properly today.

OK, how about the code below?

Oleg.


#define TWORK_EXITED	((struct callback_head*)1)

static inline bool cmp_xchg(struct callback_head **ptr, void *old, void *new)
{
	return cmpxchg(ptr, old, new) == old;
}

int
task_work_add(struct task_struct *task, struct callback_head *twork, bool notify)
{
	do {
		twork->next = ACCESS_ONCE(task->task_works);
		if (unlikely(twork->next == TWORK_EXITED))
			return -ESRCH;
	} while (cmp_xchg(&task->task_works, twork->next, twork));

	/* test_and_set_bit() implies mb(), see tracehook_notify_resume(). */
	if (notify)
		set_notify_resume(task);
	return 0;
}

struct callback_head *
task_work_cancel(struct task_struct *task, task_work_func_t func)
{
	struct callback_head *twork = NULL, **pprev = &task->task_works;
	unsigned long flags;

	raw_spin_lock_irqsave(&task->pi_lock, flags);
	if (likely(*pprev != TWORK_EXITED)) {
		for (; (twork = *pprev); pprev = &twork) {
			read_barrier_depends();
			if (twork->func != func)
				continue;

			while (!cmp_xchg(pprev, twork, twork->next))
				// COMMENT ABOUT THE RACE WITH _add()
				pprev = &(*pprev)->next;
			break;
		}
	}
	raw_spin_unlock_irqrestore(&task->pi_lock, flags);

	return twork;
}

void task_work_run(void)
{
	struct task_struct *task = current;
	struct callback_head *twork, *marker;

	for (;;) {
		raw_spin_lock_irq(&task->pi_lock);
		do {
			twork = ACCESS_ONCE(task->task_works);
			marker = (!twork && (task->flags & PF_EXITING)) ?
				TWORK_EXITED : NULL;
		} while (cmp_xchg(&task->task_works, twork, marker));
		raw_spin_unlock_irq(&task->pi_lock);

		if (!twork)
			break;

		...run works...
	}
}

