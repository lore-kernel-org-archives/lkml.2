Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1IFSzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:55:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:34443 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1IFSzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:55:17 -0400
Date: Tue, 6 Sep 2011 20:55:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/3] tick-broadcast: push down tick_broadcast_lock
In-Reply-To: <20110906174939.GK7761@one.firstfloor.org>
Message-ID: <alpine.LFD.2.02.1109062048190.2723@ionos>
References: <1314652136-11350-1-git-send-email-andi@firstfloor.org> <1314652136-11350-3-git-send-email-andi@firstfloor.org> <alpine.LFD.2.02.1109061652200.2723@ionos> <20110906174939.GK7761@one.firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Sep 2011, Andi Kleen wrote:

> On Tue, Sep 06, 2011 at 06:19:00PM +0200, Thomas Gleixner wrote:
> 
> > 
> > There is no full solution to that problem other than using sane
> > hardware.
> 
> Not convinced.
> 
> BTW can you at least merge the first patch for the notifiers. 
> This fixes the "fixed hardware" which is currently broken too.
> 
> >  raw_spin_lock(&tick_broadcast_lock);
> >  bc->next_event = KTIME_MAX;
> >  for_each_online_cpu() {
> > 	next_event = ...;
> >  }
> >  ....                                if (dev->next_event < bc->next_event) {
> >                                        raw_spin_lock(&tick_broadcast_lock);
> > 
> >  tick_broadcast_set_event(next_event, 0);
> >    bc->next_event = next_event;
> > 
> >  raw_spin_unlock(&tick_broadcast_lock);
> >                                        tick_broadcast_set_event(dev->next_event, 1);
> > 
> > So you unconditionally set the broadcast device to dev->next_event of
> > CPU1 even if the current pending event which was evaluated on CPU0 is
> > _BEFORE_ the CPU1 event. That can cause stalls and other hard to debug
> > horror. We've been there before.
> 
> I don't understand. It only sets it if the new event is earlier.
> So it can never be set back.

If you read the above you see that the broadcast handler sets the next
event to KTIME_MAX first. Then it looks for the next event and
programs it to that expiry time.

So when the check on the other CPU happens after CPU0 does
bc->next_event = KTIME_MAX and before CPU0 finished reprogramming,
then CPU1 sees KTIME_MAX and the comparison evaluates true. So CPU1
waits for the lock which is held by CPU0 and then sets the BC device
to CPU1 next event unconditionally, which might be _AFTER_ the already
pending event which was set by CPU0.
 
> You seem to say the opposite?

No, that's racy because you do not hold the lock when doing the
comparision.
 
> > 
> > Further the unprotected comparison on 32bit is completely bogus.
> 
> Ok.  Just need a ordered read like i_size_read().
> 
> > > -			if (dev->next_event.tv64 != KTIME_MAX)
> > > +
> > > +			/* Only take the lock if the event changes */
> > > +			if (dev->next_event.tv64 != KTIME_MAX) {
> > > +				raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
> > 
> > Why would you take the global lock to program the cpu local device?
> > Just because it happened to be under that lock before?
> 
> Yes, I didn't audit that code. But probably it can be dropped
> you're right.

That's not a question of auditing, it's a question of understanding
the code which you modify.

Thanks,

	tglx
