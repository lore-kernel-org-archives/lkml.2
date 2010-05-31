Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0EaMrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 08:47:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab0EaMrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 08:47:52 -0400
Date: Mon, 31 May 2010 22:47:42 +1000
From: Nick Piggin <npiggin@suse.de>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
Message-ID: <20100531124742.GG9453@laptop>
References: <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
 <20100527065041.GA31073@ZenIV.linux.org.uk>
 <20100527072240.GM22536@laptop>
 <1274957469.13159.20.camel@localhost>
 <20100527120737.GN22536@laptop>
 <1274973693.15516.67.camel@localhost>
 <20100527154435.GS22536@laptop>
 <1275294352.2678.102.camel@localhost>
 <20100531083844.GF9453@laptop>
 <1275296644.2678.122.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275296644.2678.122.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 12:04:04PM +0300, Artem Bityutskiy wrote:
> > On Mon, May 31, 2010 at 11:25:52AM +0300, Artem Bityutskiy wrote:
> > > Hmm, but it looks like we cannot do that either. If we do
> > > 
> > > set_current_state(TASK_INTERRUPTIBLE);
> > > if (supers_dirty)
> > > 	bdi_arm_supers_timer();
> > > schedule();
> > > 
> > > and the kernel is preemptive, is it possible that we get preempted
> > > before we run 'bdi_arm_supers_timer()', but after we do
> > > 'set_current_state(TASK_INTERRUPTIBLE)'. And we will never wake up if
> > > the timer armed in mark_sb_dirty() went off.
> > > 
> > > So it looks like this is the way to go:
> > > 
> > > /*
> > >  * Disable preemption for a while to make sure we are not
> > >  * preempted before the timer is armed.
> > >  */
> > > preempt_disable();
> > > set_current_state(TASK_INTERRUPTIBLE);
> > > if (supers_dirty)
> > > 	bdi_arm_supers_timer();
> > > preempt_enable();
> > > schedule();
> > 
> > This should not be required because preempt is transparent to these
> > task sleep/schedule APIs.
> > 
> > The preempt event will not clear TASK_INTERRUPTIBLE, and so the timer
> > wakeup will set it to TASK_RUNNING (whether or not it has called
> > schedule() yet and whether or not it is currently preempted).
> 
> Nick, I'm sorry, but could you please elaborate:
> 
> set_current_state(TASK_INTERRUPTIBLE);
> /* 
>  * XXX: what if we are preempted here. No timer is armed. Our state is
>  * TASK_INTERRUPTIBLE, supers_dirty is 1, so no one will ever wake us
>  * up. Thus, we'll sleep forever.
>  */
> if (supers_dirty)
> 	bdi_arm_supers_timer();
> schedule();
> 
> Not sure, but I did quick search and it looks like in preemptive kernel,
> an interrupt may happen in the XXX place above, then it will call
> 'preempt_schedule_irq()', which sill call 'schedule()'.

Yes, preempt does not participate in tsak sleeping exactly for reasons
such as this.

>From kernel/sched.c:schedule()

        if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
                if (unlikely(signal_pending_state(prev->state, prev)))
                        prev->state = TASK_RUNNING;
                else
                        deactivate_task(rq, prev, DEQUEUE_SLEEP);
                switch_count = &prev->nvcsw;
        }

If the task is not running, then is only removed from the runqueue
(or reset to running in case of pending signal) IFF it has not been
scheduled from an involuntary kernel preemption.

So in the XXX region, the task will actually be allowed to run again
until it calls schedule().

