Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab2IFR6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 13:58:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609Ab2IFR6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 13:58:49 -0400
Date: Thu, 6 Sep 2012 20:01:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/4] (Was: lockdep trace from posix timers)
Message-ID: <20120906180100.GA9479@redhat.com>
References: <1345475530.23018.50.camel@twins> <20120820154154.GB20258@redhat.com> <1345478211.23018.69.camel@twins> <20120820161012.GC21400@redhat.com> <1345479590.23018.75.camel@twins> <20120820162302.GA22354@redhat.com> <20120821182751.GA11243@redhat.com> <20120821183408.GA11721@redhat.com> <20120824185619.GA16719@redhat.com> <20120826191132.GA3743@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120826191132.GA3743@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping...

Al, will you agree with these changes?

Peter, do you think you can do your make-it-lockless patch (hehe, I
think this is not possible ;) on top?

On 08/26, Oleg Nesterov wrote:
>
> On 08/24, Oleg Nesterov wrote:
> >
> > Peter, if you think it can work for you and if you agree with
> > the implementation I will be happy to send the patch.
>
> I think I should try anyway ;)
>
> To simplify the review, I attached the resulting code below.
>
> Changes:
>
> 	- Comments.
>
> 	- Not sure this is really better, but task_work_run()
> 	  does not need to actually take pi_lock, unlock_wait
> 	  is enough.
>
> 	  However, in this case the dummy entry is better than
> 	  the fake pointer.
>
> Oleg.
>
> #include <linux/spinlock.h>
> #include <linux/task_work.h>
> #include <linux/tracehook.h>
>
> static struct callback_head work_exited; /* all we need is ->next == NULL */
>
> int
> task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
> {
> 	struct callback_head *head;
>
> 	do {
> 		head = ACCESS_ONCE(task->task_works);
> 		if (unlikely(head == &work_exited))
> 			return -ESRCH;
> 		work->next = head;
> 	} while (cmpxchg(&task->task_works, head, work) != head);
>
> 	if (notify)
> 		set_notify_resume(task);
> 	return 0;
> }
>
> struct callback_head *
> task_work_cancel(struct task_struct *task, task_work_func_t func)
> {
> 	struct callback_head **pprev = &task->task_works;
> 	struct callback_head *work = NULL;
> 	unsigned long flags;
> 	/*
> 	 * If cmpxchg() fails we continue without updating pprev.
> 	 * Either we raced with task_work_add() which added the
> 	 * new entry before this work, we will find it again. Or
> 	 * we raced with task_work_run(), *pprev == NULL/exited.
> 	 */
> 	raw_spin_lock_irqsave(&task->pi_lock, flags);
> 	while ((work = ACCESS_ONCE(*pprev))) {
> 		read_barrier_depends();
> 		if (work->func != func)
> 			pprev = &work->next;
> 		else if (cmpxchg(pprev, work, work->next) == work)
> 			break;
> 	}
> 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
>
> 	return work;
> }
>
> void task_work_run(void)
> {
> 	struct task_struct *task = current;
> 	struct callback_head *work, *head, *next;
>
> 	for (;;) {
> 		/*
> 		 * work->func() can do task_work_add(), do not set
> 		 * work_exited unless the list is empty.
> 		 */
> 		do {
> 			work = ACCESS_ONCE(task->task_works);
> 			head = !work && (task->flags & PF_EXITING) ?
> 				&work_exited : NULL;
> 		} while (cmpxchg(&task->task_works, work, head) != work);
>
> 		if (!work)
> 			break;
> 		/*
> 		 * Synchronize with task_work_cancel(). It can't remove
> 		 * the first entry == work, cmpxchg(task_works) should
> 		 * fail, but it can play with *work and other entries.
> 		 */
> 		raw_spin_unlock_wait(&task->pi_lock);
> 		smp_mb();
>
> 		/* Reverse the list to run the works in fifo order */
> 		head = NULL;
> 		do {
> 			next = work->next;
> 			work->next = head;
> 			head = work;
> 			work = next;
> 		} while (work);
>
> 		work = head;
> 		do {
> 			next = work->next;
> 			work->func(work);
> 			work = next;
> 			cond_resched();
> 		} while (work);
> 	}
> }

