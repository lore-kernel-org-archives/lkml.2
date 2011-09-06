Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab1IFRtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 13:49:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49858 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab1IFRtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 13:49:41 -0400
Date: Tue, 6 Sep 2011 19:49:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/3] tick-broadcast: push down tick_broadcast_lock
Message-ID: <20110906174939.GK7761@one.firstfloor.org>
References: <1314652136-11350-1-git-send-email-andi@firstfloor.org> <1314652136-11350-3-git-send-email-andi@firstfloor.org> <alpine.LFD.2.02.1109061652200.2723@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1109061652200.2723@ionos>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 06:19:00PM +0200, Thomas Gleixner wrote:

> 
> There is no full solution to that problem other than using sane
> hardware.

Not convinced.

BTW can you at least merge the first patch for the notifiers. 
This fixes the "fixed hardware" which is currently broken too.

>  raw_spin_lock(&tick_broadcast_lock);
>  bc->next_event = KTIME_MAX;
>  for_each_online_cpu() {
> 	next_event = ...;
>  }
>  ....                                if (dev->next_event < bc->next_event) {
>                                        raw_spin_lock(&tick_broadcast_lock);
> 
>  tick_broadcast_set_event(next_event, 0);
>    bc->next_event = next_event;
> 
>  raw_spin_unlock(&tick_broadcast_lock);
>                                        tick_broadcast_set_event(dev->next_event, 1);
> 
> So you unconditionally set the broadcast device to dev->next_event of
> CPU1 even if the current pending event which was evaluated on CPU0 is
> _BEFORE_ the CPU1 event. That can cause stalls and other hard to debug
> horror. We've been there before.

I don't understand. It only sets it if the new event is earlier.
So it can never be set back.

You seem to say the opposite?

> 
> Further the unprotected comparison on 32bit is completely bogus.

Ok.  Just need a ordered read like i_size_read().

> > -			if (dev->next_event.tv64 != KTIME_MAX)
> > +
> > +			/* Only take the lock if the event changes */
> > +			if (dev->next_event.tv64 != KTIME_MAX) {
> > +				raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
> 
> Why would you take the global lock to program the cpu local device?
> Just because it happened to be under that lock before?

Yes, I didn't audit that code. But probably it can be dropped
you're right.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
