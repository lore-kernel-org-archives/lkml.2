Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966051Ab2DLWWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:22:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2DLWWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:22:49 -0400
Date: Thu, 12 Apr 2012 15:22:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
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
Message-Id: <20120412152246.2eb4211b.akpm@linux-foundation.org>
In-Reply-To: <20120412211208.GA30456@redhat.com>
References: <20120412211146.GA30448@redhat.com>
	<20120412211208.GA30456@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<pays some attention this time>

On Thu, 12 Apr 2012 23:12:08 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Provide a simple mechanism that allows running code in the
> (nonatomic) context of the arbitrary task.
> 
> The caller does task_work_queue(task, task_work) and this task
> executes task_work->func() either from do_notify_resume() or
> from do_exit(). The callback can rely on PF_EXITING to detect
> the latter case.
> 
> "struct task_work" can be embedded in another struct, still it
> has "void *data" to handle the most common/simple case.

So if the task-work was kmalloced, it is the callback function's
responsibility to kfree it?  task_work_run() appears to handle that OK,
without any use-after-free.

> This allows us to kill the ->replacement_session_keyring hack,
> and potentially this can have more users.

I'm not seeing anything in the changelogs which explains what was wrong
with ->replacement_session_keyring, so the motivation for this patchset
eludes me.

The immediate reaction is "what's wrong with include/linux/notifier.h".
Presumably this has been discussed on some mailing list somewhere ;)


I was wondering if taskstats_exit() could use this.  But the call
happens from the wrong place.  And therein lies a problem with the
proposal: the callback site will be in the wrong place for many
potential users.  I suspect this new code won't be as useful as we hope
- perhaps we should stick with the current scheme of open-coded callouts
to subsystem-specific sites from within do_exit().

>
> ...
>
> --- /dev/null
> +++ b/include/linux/task_work.h
> @@ -0,0 +1,32 @@
> +#ifndef _LINUX_TASK_WORK_H
> +#define _LINUX_TASK_WORK_H	1
> +
> +#include <linux/sched.h>

Could just forward-declare struct task_struct, afaict.

This header doesn't include sufficient prerequisite headers, so
everything will deservedly explode if you make that change.

>
> ...
>
> --- a/include/linux/tracehook.h
> +++ b/include/linux/tracehook.h
> @@ -46,7 +46,7 @@
>  #ifndef _LINUX_TRACEHOOK_H
>  #define _LINUX_TRACEHOOK_H	1
>  
> -#include <linux/sched.h>
> +#include <linux/task_work.h>

ick.  So tracehook.h gains a secret dependency upon task_work.h
including sched.h.

>
> ...
>
> --- /dev/null
> +++ b/kernel/task_work.c
> @@ -0,0 +1,81 @@
> +#include <linux/tracehook.h>

This file also doesn't come close to including the headers which it
requires.  This practice is fragile and frequently results in sad
little patches months later.  Often to fix the alpha build, for unknown
reasons.


Having to spell out all the includes is rather a pain.  Inevitably some
are missed and some remain after they are no longer needed.  otoh if we
don't do this, things tend to break when unexpected configs are used. 
There's no nice solution, alas.

> +int
> +task_work_queue(struct task_struct *task, struct task_work *twork, bool notify)

hm, I see.  The "queue" in "task_work_queue" is "the action of
queueing", not "a queue".  Noun-vs-verb.  Perhaps task_work_add() would
be clearer.

> +{
> +	unsigned long flags;
> +	int err = -ESRCH;
> +
> +#ifndef TIF_NOTIFY_RESUME
> +	if (notify)
> +		return -ENOTSUPP;
> +#endif
> +	/*
> +	 * We must not insert the new work if the task has already passed
> +	 * exit_task_work(). We rely on do_exit()->raw_spin_unlock_wait()
> +	 * and check PF_EXITING under pi_lock.
> +	 */
> +	raw_spin_lock_irqsave(&task->pi_lock, flags);

It's unobvious (to this little reader) why the code uses raw_ locking. 
The raw_spin_unlock_wait() thing prevents us from using
spin_lock_irqsave()?  Add a nice comment?

> +	if (likely(!(task->flags & PF_EXITING))) {
> +		hlist_add_head(&twork->hlist, &task->task_works);
> +		err = 0;
> +	}
> +	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +
> +	/* test_and_set_bit() implies mb(), see tracehook_notify_resume(). */
> +	if (likely(!err) && notify)
> +		set_notify_resume(task);
> +	return err;
> +}
> +
> +struct task_work *
> +task_work_cancel(struct task_struct *task, task_work_func_t func)
> +{
> +	unsigned long flags;
> +	struct task_work *twork;
> +	struct hlist_node *pos;
> +
> +	raw_spin_lock_irqsave(&task->pi_lock, flags);
> +	hlist_for_each_entry(twork, pos, &task->task_works, hlist) {
> +		if (twork->func == func) {
> +			hlist_del(&twork->hlist);
> +			goto found;
> +		}
> +	}

I trust we won't be giving userspace a way of controlling the queue
length!

> +	twork = NULL;
> + found:
> +	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +
> +	return twork;
> +}
> +
> +void task_work_run(struct task_struct *task)
> +{
> +	struct hlist_head task_works;
> +	struct hlist_node *pos;
> +
> +	raw_spin_lock_irq(&task->pi_lock);
> +	hlist_move_list(&task->task_works, &task_works);
> +	raw_spin_unlock_irq(&task->pi_lock);
> +
> +	if (unlikely(hlist_empty(&task_works)))
> +		return;
> +	/*
> +	 * We use hlist to save the space in task_struct, but we want fifo.

hm.  How does the reader of this code work out why the author wanted fifo?
Perhaps because keyctl_session_to_parent() or exit_irq_thread() needed this.

> +	 * Find the last entry, the list should be short, then process them
> +	 * in reverse order.
> +	 */
> +	for (pos = task_works.first; pos->next; pos = pos->next)
> +		;
> +
> +	for (;;) {
> +		struct hlist_node **pprev = pos->pprev;
> +		struct task_work *twork = container_of(pos, struct task_work,
> +							hlist);
> +		twork->func(twork);
> +
> +		if (pprev == &task_works.first)
> +			break;
> +		pos = container_of(pprev, struct hlist_node, next);
> +	}
> +}
