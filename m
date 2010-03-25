Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab0CYMLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:11:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51079 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab0CYMLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:11:42 -0400
Date: Thu, 25 Mar 2010 13:11:41 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jesse.brandeburg@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near overflowing v2
Message-ID: <20100325121141.GO20695@one.firstfloor.org>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org> <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain> <20100325093744.GH20695@one.firstfloor.org> <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 12:09:10PM +0100, Thomas Gleixner wrote:
> On Thu, 25 Mar 2010, Andi Kleen wrote:
> > On Thu, Mar 25, 2010 at 02:46:42AM +0100, Thomas Gleixner wrote:
> > > 3) Why does the NIC driver code not set IRQF_DISABLED in the first
> > >    place?  AFAICT the network drivers just kick off NAPI, so whats the
> > >    point to run those handlers with IRQs enabled at all ?
> > 
> > I think the idea was to minimize irq latency for other interrupts
> 
> So what's the point ? Is the irq handler of that card so long running,
> that it causes trouble ? 

I believe it's more like that you have a lot of them (even with interrupt
mitigation and NAPI polling) and they have to scale up the work to handle
high bandwidths, so it ends up with a lot of time in them anyways,
 ending with skew in the timers and similar issues.

Anyways my goal here was simply to have a least intrusive fix, not
change semantics for everyone.

> > cost. In principle that could be done also.
> 
> What's the cost? Nothing at all. There is no f*cking difference between:
> 
>  IRQ1 10us
>  IRQ2 10us
>  IRQ3 10us
>  IRQ4 10us
> 
> and
> 
>  IRQ1 2us
>   IRQ2 2us
>    IRQ3 2us
>     IRQ4 10us
>    IRQ3 8us
>   IRQ2 8us
>  IRQ1 8us
> 
> The system is neither running a task nor a softirq for 40us in both
> cases.

Yes it could work out this. Or it could not. I'm not sure, so I chose
the safe option.

> 
> So what's the point of running a well written (short) interrupt
> handler with interrupts enabled ? Nothing at all. It just makes us
> deal with crap like stacks overflowing for no good reason.

Ok so you're just proposing to always set IRQF_DISABLED? 

If you can force everyone to use that that would work I guess.

I don't know what problems it would cause. My fear is that any latency problems
would be answered with a "move to RT, moron" from your mouth though.

> > Anyways if such a thing was done it would be a long term project
> > and that short term fix would be still needed.
> 
> Your patch is not a fix, It's a lousy, horrible and unreliable
> workaround. It's not fixing the root cause of the problem at hand.

It fixes the bug in a minimally intrusive way.
> 
> The real fix is to run the NIC interrupt handlers with IRQs disabled
> and be done with it. If you still think that introduces latencies then
> prove it with numbers.

Sorry you got that wrong. I'm not proposing to change semantics, you
are proposing that. So you would need to prove anything if at all.

Anyways if you think you can write a better patch to fix that bug
please fell free to write one.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
