Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab0CYNS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:18:28 -0400
Received: from www.tglx.de ([62.245.132.106]:47917 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab0CYNSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:18:25 -0400
Date: Thu, 25 Mar 2010 14:17:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
In-Reply-To: <20100325121141.GO20695@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.1003251338130.3147@localhost.localdomain>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org> <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
 <20100325093744.GH20695@one.firstfloor.org> <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain> <20100325121141.GO20695@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010, Andi Kleen wrote:

> On Thu, Mar 25, 2010 at 12:09:10PM +0100, Thomas Gleixner wrote:
> > On Thu, 25 Mar 2010, Andi Kleen wrote:
> > > On Thu, Mar 25, 2010 at 02:46:42AM +0100, Thomas Gleixner wrote:
> > > > 3) Why does the NIC driver code not set IRQF_DISABLED in the first
> > > >    place?  AFAICT the network drivers just kick off NAPI, so whats the
> > > >    point to run those handlers with IRQs enabled at all ?
> > > 
> > > I think the idea was to minimize irq latency for other interrupts
> > 
> > So what's the point ? Is the irq handler of that card so long running,
> > that it causes trouble ? 
> 
> I believe it's more like that you have a lot of them (even with interrupt
> mitigation and NAPI polling) and they have to scale up the work to handle
> high bandwidths, so it ends up with a lot of time in them anyways,
>  ending with skew in the timers and similar issues.

Timekeeping is an absolute non issue here. The time keeping code can
cope with pretty large delays and there is nothing which 
 
> Anyways my goal here was simply to have a least intrusive fix, not
> change semantics for everyone.
>
> Yes it could work out this. Or it could not. I'm not sure, so I chose
> the safe option.

Oh it's safe because it solves the problem on that particular machine
and workload?

No, it's not safe at all. 

    - it does not prevent a driver reenabling interrupts

    - it will cause real large latencies when the interrupt which
      happens to trigger that check is one of the long running
      ones. Are you going to deal with the "oh we see >500us" latencies
      bugreports ?

    - worst case it'll brick your machine if the interrupt which
      happens to trigger that check relies on irq enabled semantics
      (e.g. missing jiffies update). Yes, such a driver is broken by
      design, but we have such crap lurking. So much for not changing
      semantics.
 
> > So what's the point of running a well written (short) interrupt
> > handler with interrupts enabled ? Nothing at all. It just makes us
> > deal with crap like stacks overflowing for no good reason.
> 
> Ok so you're just proposing to always set IRQF_DISABLED? 

For any sane written driver, yes. We have crap irq handlers which need
to be fixed, so we can't enforce it right away. See above.
 
> I don't know what problems it would cause. My fear is that any latency problems
> would be answered with a "move to RT, moron" from your mouth though.

Oh well.
 
> > > Anyways if such a thing was done it would be a long term project
> > > and that short term fix would be still needed.
> > 
> > Your patch is not a fix, It's a lousy, horrible and unreliable
> > workaround. It's not fixing the root cause of the problem at hand.
> 
> It fixes the bug in a minimally intrusive way.

It papers over the problem. We already know that the NIC driver floods
the machine with interrupts, so why are you insisting that we need to
bandaid that problem ?

The minimal intrusive way is a one liner in that very driver code and
if it causes problems for that very driver then we don't fix them with
adding a callback in the generic interrupt code path.

The message which we would send out with applying that band aid would
be simply: Go ahead driver writers and let your handlers run as long
as they want, we'll safe you in 99.9% of the cases and we'll happily
go and debug the 0.1% of completely undebuggable shit which will
result out of that.

No thanks,

	tglx
