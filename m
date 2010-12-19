Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab0LSLVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 06:21:07 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33150 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab0LSLVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 06:21:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PU9OM9l9FlZABB81futuedFda3MaVLFvrWrrKa3yFGQ5fRV/uwF7Eb6QSIWmG0w93M
         xP4WC7LeAhzqrZsGObNX813SvFPJgTwFjQOHVMUtsxDYD5oR2ut3WrG2bX2/a/NjEt1w
         SAAYw3BhJwfEcQXjSfy/qf6HcbtBQix7IGbV4=
Date: Sun, 19 Dec 2010 19:20:53 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
Message-ID: <20101219112053.GA1841@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20101216184229.GA15889@redhat.com>
 <1292525893.2708.50.camel@laptop>
 <1292526220.2708.55.camel@laptop>
 <1292528874.2708.85.camel@laptop>
 <1292531553.2708.89.camel@laptop>
 <20101217165414.GA8997@redhat.com>
 <1292607781.2266.295.camel@twins>
 <1292609740.2266.323.camel@twins>
 <AANLkTik86z7NZCqkYU1JY1NUW3qxthaBohY3CNk6awEd@mail.gmail.com>
 <20101218200850.GA17684@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101218200850.GA17684@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 09:08:50PM +0100, Oleg Nesterov wrote:
> On 12/18, Yong Zhang wrote:
> >
> > On Sat, Dec 18, 2010 at 2:15 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > static int
> > > try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
> > > {
> > > ? ? ? ?unsigned long flags;
> > > ? ? ? ?int cpu, ret = 0;
> > >
> > > ? ? ? ?smp_wmb();
> > > ? ? ? ?raw_spin_lock_irqsave(&p->pi_lock, flags);
> > >
> > > ? ? ? ?if (!(p->state & state))
> > > ? ? ? ? ? ? ? ?goto unlock;
> > >
> > > ? ? ? ?ret = 1; /* we qualify as a proper wakeup now */
> >
> > Could below happen in this __window__?
> >
> > p is going through wake_event
> 
> I don't think this can happen with wait_event/wake_up/etc,
> wait_queue_head_t->lock adds the necessary synchronization.

Actually I don't take different sight into wait_event/wake_up
and sleep/wake_up_process, beause nothing prevent the user
from using wake_up_process on an added-to-wait_queue sleeper
though we know that it's not recommended.

And you're right wait_queue_head_t->lock privide necessary
synchronization with wait_event/wake_up.

> 
> But, in general,
> 
> > and it first set TASK_UNINTERRUPTIBLE,
> > then waker see that and above if (!(p->state & state)) passed.
> > But at this time condition == true for p, and p return to run and
> > intend to sleep:
> >           p->state == XXX;
> >           sleep;
> >
> > then we could wake up a process which has wrong state, no?
> 
> I think this is possible, and this is possible whatever we do.
> Afaics, this patch changes nothing in this sense. Consider:
> 
> 	set_current_state(TASK_INTERRUPTIBLE);
> 
> 	set_current_state(TASK_UNINTERRUPTIBLE);
> 	schedule();
> 
> wake_up_state(TASK_INTERRUPTIBLE) in between can in fact wakeup
> this task in TASK_UNINTERRUPTIBLE state.

Hmmm, yeah. I missed that.

> 
> I do not think this is the problem. The user of wake_up_process()
> should take care and write the correct code ;) 

Fair enough ;)

> And in any case,
> any wait-event-like code should handle the spurious wakeups
> correctly.

Yup.

Thanks,
Yong
