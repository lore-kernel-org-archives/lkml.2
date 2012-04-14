Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2DNCkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 22:40:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59206 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab2DNCku convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 22:40:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120414021220.GA23393@redhat.com>
References: <20120414021201.GA23385@redhat.com> <20120414021220.GA23393@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Apr 2012 19:40:29 -0700
X-Google-Sender-Auth: Jh_J28hZVv3Ti8EHfBNYLFODYhM
Message-ID: <CA+55aFyxV8v2mOjb1Ly=1ttPyLvUt6RZO8wgjD_9owtO=VM0hw@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] task_work_add: generic process-context callbacks
To: Oleg Nesterov <oleg@redhat.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is seriously buggy:

On Fri, Apr 13, 2012 at 7:12 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> +void task_work_run(struct task_struct *task)
> +{
> +       struct hlist_head task_works;
> +       struct hlist_node *pos;
> +
> +       raw_spin_lock_irq(&task->pi_lock);
> +       hlist_move_list(&task->task_works, &task_works);
> +       raw_spin_unlock_irq(&task->pi_lock);
> +
> +       if (unlikely(hlist_empty(&task_works)))
> +               return;
> +       /*
> +        * We use hlist to save the space in task_struct, but we want fifo.
> +        * Find the last entry, the list should be short, then process them
> +        * in reverse order.
> +        */
> +       for (pos = task_works.first; pos->next; pos = pos->next)
> +               ;
> +
> +       for (;;) {
> +               struct hlist_node **pprev = pos->pprev;
> +               struct task_work *twork = container_of(pos, struct task_work,
> +                                                       hlist);
> +               twork->func(twork);
> +
> +               if (pprev == &task_works.first)
> +                       break;
> +               pos = container_of(pprev, struct hlist_node, next);
> +       }
> +}

No can do. You've removed the task-work from the process list, and you
no longer hold the spinlock that protects that list. That means that
you *cannot* access the task-work data structure any more, because it
may long be gone.

Look at the users of this interface that you wrote yourself. They
allocate the task-work on the stack, and do a "task_work_cancel()"
before returning. That data structure is *gone*. You can't dereference
it any more.

So quite frankly, the only safe approach is to copy the twork->func
while holding the lock. And passing in the "twork" to the function
isn't safe either, as far as I can see, since it may be gone too.

Basically, *any* access of 'twork' after it is removed from the list
and you have released the task spinlock is unsafe, as far as I can
tell.

Alternatively, you must make the rule be that the data can only be
freed by the caller *if* it was returned from "task_work_cancel()".
But then you can't allocate it on the stack any more, and have to
allocate it separately.

Or you need to implement some kind of "task_work_cancel_sync()"
function that guarantees that it waits for the actual work function to
finish. And I don't know how you'd do that.

But as it is, this series looks seriously buggy.

                      Linus
