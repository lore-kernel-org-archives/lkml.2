Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934932Ab2JaCyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 22:54:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64089 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab2JaCyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 22:54:06 -0400
MIME-Version: 1.0
In-Reply-To: <1351650181.4004.70.camel@gandalf.local.home>
References: <1351611301-3520-1-git-send-email-fweisbec@gmail.com>
	<1351611301-3520-3-git-send-email-fweisbec@gmail.com>
	<1351622024.1504.13.camel@anish-Inspiron-N5050>
	<CAFTL4hz7Jy69rr4Ze1pOtYPo5CFSZuTGXdY+w3jR4ZboA_8EYg@mail.gmail.com>
	<1351650181.4004.70.camel@gandalf.local.home>
Date: Wed, 31 Oct 2012 03:54:03 +0100
Message-ID: <CAFTL4hzMFw=n0SC9DCfppztuGznpf14xk4K=jt2T3QjwY5+c+A@mail.gmail.com>
Subject: Re: [PATCH 2/2] irq_work: Fix racy IRQ_WORK_BUSY flag setting
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: anish kumar <anish198519851985@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/31 Steven Rostedt <rostedt@goodmis.org>:
> More confidence over what? The xchg()? They are equivalent (wrt memory
> barriers).
>
> Here's the issue that currently exists. Let's look at the code:
>
>
> /*
>  * Claim the entry so that no one else will poke at it.
>  */
> static bool irq_work_claim(struct irq_work *work)
> {
>         unsigned long flags, nflags;
>
>         for (;;) {
>                 flags = work->flags;
>                 if (flags & IRQ_WORK_PENDING)
>                         return false;
>                 nflags = flags | IRQ_WORK_FLAGS;
>                 if (cmpxchg(&work->flags, flags, nflags) == flags)
>                         break;
>                 cpu_relax();
>         }
>
>         return true;
> }
>
> and
>
>         llnode = llist_del_all(this_list);
>         while (llnode != NULL) {
>                 work = llist_entry(llnode, struct irq_work, llnode);
>
>                 llnode = llist_next(llnode);
>
>                 /*
>                  * Clear the PENDING bit, after this point the @work
>                  * can be re-used.
>                  */
>                 work->flags = IRQ_WORK_BUSY;
>                 work->func(work);
>                 /*
>                  * Clear the BUSY bit and return to the free state if
>                  * no-one else claimed it meanwhile.
>                  */
>                 (void)cmpxchg(&work->flags, IRQ_WORK_BUSY, 0);
>         }
>
> The irq_work_claim() will only queue its work if it's not already
> pending. If it is pending, then someone is going to process it anyway.
> But once we start running the function, new work needs to be processed
> again.
>
> Thus we have:
>
>         CPU 1                                   CPU 2
>         -----                                   -----
>         (flags = 0)
>         cmpxchg(flags, 0, IRQ_WORK_FLAGS)
>         (flags = 3)
>         [...]
>
>                                                 if (flags & IRQ_WORK_PENDING)
>                                                         return false
>         flags = IRQ_WORK_BUSY
>         (flags = 2)
>         func()
>
> The above shows the normal case were CPU 2 doesn't need to queue work,
> because its going to be done for it by CPU 1. But...
>
>
>
>         CPU 1                                   CPU 2
>         -----                                   -----
>         (flags = 0)
>         cmpxchg(flags, 0, IRQ_WORK_FLAGS)
>         (flags = 3)
>         [...]
>         flags = IRQ_WORK_BUSY
>         (flags = 2)
>         func()
>                                                 (sees flags = 3)
>                                                 if (flags & IRQ_WORK_PENDING)
>                                                         return false
>         cmpxchg(flags, 2, 0);
>         (flags = 0)
>
>
> Here, because we did not do a memory barrier after
> flags = IRQ_WORK_BUSY, CPU 2 saw stale data and did not queue its work,
> and missed the opportunity. Now if you had this fix with the xchg() as
> you have in your patch, then CPU 2 would not see the stale flags.
> Except, with the code I showed above it still can!
>
>         CPU 1                                   CPU 2
>         -----                                   -----
>         (flags = 0)
>         cmpxchg(flags, 0, IRQ_WORK_FLAGS)
>         (flags = 3)
>         [...]
>                                                 (fetch flags)
>         xchg(&flags, IRQ_WORK_BUSY)
>         (flags = 2)
>         func()
>                                                 (sees flags = 3)
>                                                 if (flags & IRQ_WORK_PENDING)
>                                                         return false
>         cmpxchg(flags, 2, 0);
>         (flags = 0)
>
>
> Even with the update of xchg(), if CPU2 fetched the flags before CPU1
> did the xchg, then it would still lose out. But that's where your
> previous patch comes in that does:
>
>        flags = work->flags & ~IRQ_WORK_PENDING;
>        for (;;) {
>                nflags = flags | IRQ_WORK_FLAGS;
>                oflags = cmpxchg(&work->flags, flags, nflags);
>                if (oflags == flags)
>                        break;
>                if (oflags & IRQ_WORK_PENDING)
>                        return false;
>                flags = oflags;
>                cpu_relax();
>        }
>
>
> This now does:
>
>         CPU 1                                   CPU 2
>         -----                                   -----
>         (flags = 0)
>         cmpxchg(flags, 0, IRQ_WORK_FLAGS)
>         (flags = 3)
>         [...]
>         xchg(&flags, IRQ_WORK_BUSY)
>         (flags = 2)
>         func()
>                                                 oflags = cmpxchg(&flags, flags, nflags);
>                                                 (sees flags = 2)
>                                                 if (flags & IRQ_WORK_PENDING)
>                                                         (not true)
>                                                 (loop)
>         cmpxchg(flags, 2, 0);
>         (flags = 2)
>                                                 flags = 3
>
>
>
> With both patch 1 and 2 you fixed the bug.
>
> I guess you suffer from...
>
>  http://weknowmemes.com/wp-content/uploads/2012/09/my-code-doesnt-work-i-have-no-idea-why.jpg
>
> ;-)
>

Heh. No I was ok with all the above :) My point was that
xchg()/cmpxchg() is good to synchronize against flag values and the
need or not to queue the work, but memory barriers couldn't replace
that, and my ordering assumption against user data manipulated by work
were wrong. As such my changelogs are buggy.

My last doubt was: does the cmpxchg/xchg pair we have can settle an
ordering between flags and user data such that we don't need locking
for these. But as you highlight below, we definetly need locking for
user data anyway.

>>
>>
>> CPU 0                                                CPU 1
>>
>> store(work data)                                  xchg(flags, IRQ_WORK_BUSY)
>> cmpxchg(flags, IRQ_WORK_FLAGS)    load(work data)
>>
>> Can I make this assumption?
>>
>> - If CPU 0 fails the cmpxchg() (which means CPU 1 has not yet xchg())
>> then CPU 1 will execute the work and see our data.
>>
>> At least cmpxchg / xchg pair orders correctly to ensure somebody will
>> execute our work. Now probably some locking is needed from the work
>> function itself if it's not per cpu.
>
> Yeah, there's nothing stopping the work->func() from executing from two
> different CPUs. The protection is just for the internal use of llist
> that is used. We don't need to worry about it being queued twice and
> corrupting the work->llnode.
>
> But the synchronization of the func() should be up to the func() code
> itself, not a guarantee of the irq_work.

Agreed.

I'll refine my changelogs accordingly.

Thanks!
