Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab2DNDGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 23:06:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989Ab2DNDGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 23:06:06 -0400
Date: Sat, 14 Apr 2012 05:05:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] task_work_add: generic process-context callbacks
Message-ID: <20120414030507.GA27579@redhat.com>
References: <20120414021201.GA23385@redhat.com> <20120414021220.GA23393@redhat.com> <CA+55aFyxV8v2mOjb1Ly=1ttPyLvUt6RZO8wgjD_9owtO=VM0hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyxV8v2mOjb1Ly=1ttPyLvUt6RZO8wgjD_9owtO=VM0hw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13, Linus Torvalds wrote:
>
> This is seriously buggy:

I am already sleep. But,

> On Fri, Apr 13, 2012 at 7:12 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > +void task_work_run(struct task_struct *task)
> > +{
> > +       struct hlist_head task_works;
> > +       struct hlist_node *pos;
> > +
> > +       raw_spin_lock_irq(&task->pi_lock);
> > +       hlist_move_list(&task->task_works, &task_works);
> > +       raw_spin_unlock_irq(&task->pi_lock);
> > +
> > +       if (unlikely(hlist_empty(&task_works)))
> > +               return;
> > +       /*
> > +        * We use hlist to save the space in task_struct, but we want fifo.
> > +        * Find the last entry, the list should be short, then process them
> > +        * in reverse order.
> > +        */
> > +       for (pos = task_works.first; pos->next; pos = pos->next)
> > +               ;
> > +
> > +       for (;;) {
> > +               struct hlist_node **pprev = pos->pprev;
> > +               struct task_work *twork = container_of(pos, struct task_work,
> > +                                                       hlist);
> > +               twork->func(twork);
> > +
> > +               if (pprev == &task_works.first)
> > +                       break;
> > +               pos = container_of(pprev, struct hlist_node, next);
> > +       }
> > +}
>
> No can do. You've removed the task-work from the process list, and you
> no longer hold the spinlock that protects that list. That means that
> you *cannot* access the task-work data structure any more, because it
> may long be gone.
>
> Look at the users of this interface that you wrote yourself. They
> allocate the task-work on the stack, and do a "task_work_cancel()"
> before returning. That data structure is *gone*. You can't dereference
> it any more.

tsk is always "current", probably this should be documented, I'll add
the comment.

So this can't race with irq_thread() which uses the task_work on stack.

> Basically, *any* access of 'twork' after it is removed from the list
> and you have released the task spinlock is unsafe, as far as I can
> tell.

I don't follow.

Once task_work_run() removes task_work from list (and drops the lock)
nobody can use this twork. task_work_cancel obviously can't find it,
it will return NULL.

Oleg.

