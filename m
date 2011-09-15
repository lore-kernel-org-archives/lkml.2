Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934582Ab1IOTcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:32:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:45789 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934571Ab1IOTck convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:40 -0400
Subject: Re: [RFC][PATCH 3/3] ipc/sem: Rework wakeup scheme
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
Date: Thu, 15 Sep 2011 21:32:15 +0200
In-Reply-To: <4E7235F6.1030303@colorfullife.com>
References: <20110914133034.687048806@chello.nl>
	 <20110914133750.916911903@chello.nl> <4E7235F6.1030303@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316115135.4060.19.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 19:29 +0200, Manfred Spraul wrote:
> Hi Peter,

> What is broken?

I'm not quite sure yet, but the results are that sembench doesn't
complete properly; http://oss.oracle.com/~mason/sembench.c

That seems to be happening is that we get spurious wakeups in the
ipc/sem code resulting it semtimedop returning -EINTR, even though
there's no pending signal.

(there really should be a if (!signal_pending(current)) goto again thing
in that semtimedop wait loop)

Adding a loop in userspace like:

again:
        ret = semtimedop(semid_lookup[l->id], &sb, 1, tvp);
        if (ret) {
                if (errno == EINTR) {
                        l->spurious++;
                        kill_tracer();
                        goto again;
                }
                perror("semtimedop");
        }

makes it complete again (although performance seems to suffer a lot
compared to a kernel without this patch).

It seems related to patch 2/3 converting the futex code, without that
patch I can't seem to reproduce. All this is strange though, because if
there were multiple wakeups on the same task wake_lists ought to result
in less wakeups in total, not more.

I've been trying to trace the thing but so far no luck.. when I enable
too much tracing it goes away.. silly heisenbugger.

> > +static void wake_up_sem_queue_prepare(struct wake_list_head *wake_list,
> >   				struct sem_queue *q, int error)
> >   {
> > +	struct task_struct *p = ACCESS_ONCE(q->sleeper);
> >
> > +	get_task_struct(p);
> > +	q->status = error;
> > +	/*
> > +	 * implies a full barrier
> > +	 */
> > +	wake_list_add(wake_list, p);
> > +	put_task_struct(p);
> >   }

> I think the get_task_struct()/put_task_struct is not necessary:
> Just do the wake_list_add() before writing q->status:
> wake_list_add() is identical to list_add_tail(&q->simple_list, pt).
> [except that it contains additional locking, which doesn't matter here]

But the moment we write q->status, q can disappear right? 

Suppose the task gets a wakeup (say from a signal) right after we write
q->status. Then p can disappear (do_exit) and we'd try to enqueue dead
memory -> BOOM!

> > +static void wake_up_sem_queue_do(struct wake_list_head *wake_list)
> >   {
> > +	wake_up_list(wake_list, TASK_ALL);
> >   }
> >   
> wake_up_list() calls wake_up_state() that calls try_to_wake_up().
> try_to_wake_up() seems to return immediately when the state is TASK_DEAD.
> 
> That leaves: Is it safe to call wake_up_list() in parallel with do_exit()?
> The current implementation avoids that.

Ah, wake_list_add() does get_task_struct() and wake_up_list() will first
issue the wakeup and then drop the reference.

Hrmm,. it looks like its all these atomic ops {get,put}_task_struct()
that are causing the performance drop.. I just removed the ones in
wake_up_sem_queue_prepare() just for kicks and I got about half my
performance gap back.


