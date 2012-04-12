Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965215Ab2DLXQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 19:16:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757330Ab2DLXQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 19:16:24 -0400
Date: Fri, 13 Apr 2012 01:15:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] task_work_queue: add generic process-context
	callbacks
Message-ID: <20120412231520.GA1656@redhat.com>
References: <20120412211146.GA30448@redhat.com> <20120412211208.GA30456@redhat.com> <20120412152246.2eb4211b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412152246.2eb4211b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12, Andrew Morton wrote:
>
> <pays some attention this time>

Thanks!

> On Thu, 12 Apr 2012 23:12:08 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Provide a simple mechanism that allows running code in the
> > (nonatomic) context of the arbitrary task.
> >
> > The caller does task_work_queue(task, task_work) and this task
> > executes task_work->func() either from do_notify_resume() or
> > from do_exit(). The callback can rely on PF_EXITING to detect
> > the latter case.
> >
> > "struct task_work" can be embedded in another struct, still it
> > has "void *data" to handle the most common/simple case.
>
> So if the task-work was kmalloced, it is the callback function's
> responsibility to kfree it?

Yes,

> task_work_run() appears to handle that OK,
> without any use-after-free.

I hope ;)

> > This allows us to kill the ->replacement_session_keyring hack,
> > and potentially this can have more users.
>
> I'm not seeing anything in the changelogs which explains what was wrong
> with ->replacement_session_keyring, so the motivation for this patchset
> eludes me.

->replacement_session_keyring in fact implements the notifier too,
just it is very limited. task_work simply tries to generalize and
cleanup the logic we already have. And at the same cost.

Besides, the current code is racy. And it is not convenient to fix
all users in arch/.

> The immediate reaction is "what's wrong with include/linux/notifier.h".
> Presumably this has been discussed on some mailing list somewhere ;)

Ah, please no. Imho we do not want _notifier_head in task_struct,
plus I'd certainly like to avoid the new locks in
do_exit()->exit_task_work() path.

> I was wondering if taskstats_exit() could use this.

Unlikely, I think. taskstats is "global", every task should report
if there are listeners.

> But the call
> happens from the wrong place.  And therein lies a problem with the
> proposal: the callback site will be in the wrong place for many
> potential users.  I suspect this new code won't be as useful as we hope
> - perhaps we should stick with the current scheme of open-coded callouts
> to subsystem-specific sites from within do_exit().

May be we can add more task_work_run's later, but right now I do
not think this is needed. And I do not expect it will find a lot
of new users.

> > --- a/include/linux/tracehook.h
> > +++ b/include/linux/tracehook.h
> > @@ -46,7 +46,7 @@
> >  #ifndef _LINUX_TRACEHOOK_H
> >  #define _LINUX_TRACEHOOK_H	1
> >
> > -#include <linux/sched.h>
> > +#include <linux/task_work.h>
>
> ick.  So tracehook.h gains a secret dependency upon task_work.h
> including sched.h.

Hmm. I thought that it is alway fine to remove the unnecessary include.
I can put it back, but we are going to kill tracehook.h altogether.

> > --- /dev/null
> > +++ b/kernel/task_work.c
> > @@ -0,0 +1,81 @@
> > +#include <linux/tracehook.h>
>
> This file also doesn't come close to including the headers which it
> requires.  This practice is fragile and frequently results in sad
> little patches months later.  Often to fix the alpha build, for unknown
> reasons.

OK, I'll add "include linix/task_work.h".

> > +int
> > +task_work_queue(struct task_struct *task, struct task_work *twork, bool notify)
>
> hm, I see.  The "queue" in "task_work_queue" is "the action of
> queueing", not "a queue".  Noun-vs-verb.

Cough. Peter, do you read this? I stole the naming and the first
line of the changelog from kernel/irq_work.c!

> Perhaps task_work_add() would
> be clearer.

OK, I'll rename.

> > +	unsigned long flags;
> > +	int err = -ESRCH;
> > +
> > +#ifndef TIF_NOTIFY_RESUME
> > +	if (notify)
> > +		return -ENOTSUPP;
> > +#endif
> > +	/*
> > +	 * We must not insert the new work if the task has already passed
> > +	 * exit_task_work(). We rely on do_exit()->raw_spin_unlock_wait()
> > +	 * and check PF_EXITING under pi_lock.
> > +	 */
> > +	raw_spin_lock_irqsave(&task->pi_lock, flags);
>
> It's unobvious (to this little reader) why the code uses raw_ locking.
> The raw_spin_unlock_wait() thing prevents us from using
> spin_lock_irqsave()?  Add a nice comment?

Well, but ->pi_lock is raw_spinlock_t ?

> > +struct task_work *
> > +task_work_cancel(struct task_struct *task, task_work_func_t func)
> > +{
> > +	unsigned long flags;
> > +	struct task_work *twork;
> > +	struct hlist_node *pos;
> > +
> > +	raw_spin_lock_irqsave(&task->pi_lock, flags);
> > +	hlist_for_each_entry(twork, pos, &task->task_works, hlist) {
> > +		if (twork->func == func) {
> > +			hlist_del(&twork->hlist);
> > +			goto found;
> > +		}
> > +	}
>
> I trust we won't be giving userspace a way of controlling the queue
> length!

Exactly. From 2/3:

	Note that we do task_work_cancel() before task_work_queue() to
	ensure that only one work can be pending at any time. This is
	important, we must not allow user-space to abuse the parent's
	->task_works list.


> > +void task_work_run(struct task_struct *task)
> > +{
> > +	struct hlist_head task_works;
> > +	struct hlist_node *pos;
> > +
> > +	raw_spin_lock_irq(&task->pi_lock);
> > +	hlist_move_list(&task->task_works, &task_works);
> > +	raw_spin_unlock_irq(&task->pi_lock);
> > +
> > +	if (unlikely(hlist_empty(&task_works)))
> > +		return;
> > +	/*
> > +	 * We use hlist to save the space in task_struct, but we want fifo.
>
> hm.  How does the reader of this code work out why the author wanted fifo?
> Perhaps because keyctl_session_to_parent() or exit_irq_thread() needed this.

Argh.

No, keyctl_session_to_parent() and exit_irq_thread() do not care,
they can't add more than one work.

Just I think that fifo makes more sense in general. Just for example,
suppose that keyctl_session_to_parent() didn't cancel the pending
request(s). In this case fifo would be needed for correctness.

Oleg.

