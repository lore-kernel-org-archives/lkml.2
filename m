Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab0CYLKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 07:10:07 -0400
Received: from www.tglx.de ([62.245.132.106]:42280 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab0CYLKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 07:10:03 -0400
Date: Thu, 25 Mar 2010 12:09:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
In-Reply-To: <20100325093744.GH20695@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org> <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
 <20100325093744.GH20695@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010, Andi Kleen wrote:
> On Thu, Mar 25, 2010 at 02:46:42AM +0100, Thomas Gleixner wrote:
> > 3) Why does the NIC driver code not set IRQF_DISABLED in the first
> >    place?  AFAICT the network drivers just kick off NAPI, so whats the
> >    point to run those handlers with IRQs enabled at all ?
> 
> I think the idea was to minimize irq latency for other interrupts

So what's the point ? Is the irq handler of that card so long running,
that it causes trouble ? If yes, then this needs to be fixed. If no,
then it simply can run with IRQs disabled.
 
> But yes defaulting to IRQF_DISABLED would fix it too, at some 
> cost. In principle that could be done also.

What's the cost? Nothing at all. There is no f*cking difference between:

 IRQ1 10us
 IRQ2 10us
 IRQ3 10us
 IRQ4 10us

and

 IRQ1 2us
  IRQ2 2us
   IRQ3 2us
    IRQ4 10us
   IRQ3 8us
  IRQ2 8us
 IRQ1 8us

The system is neither running a task nor a softirq for 40us in both
cases.

So what's the point of running a well written (short) interrupt
handler with interrupts enabled ? Nothing at all. It just makes us
deal with crap like stacks overflowing for no good reason.

> > 
> > > > case of MSI-X it just disables the IRQ when it comes again while the
> > > > first irq on that vector is still in progress. So the maximum nesting
> > > > is two up to handle_edge_irq() where it disables the IRQ and returns
> > > > right away.
> > > 
> > > Real maximum nesting is all IRQs running with interrupts on pointing
> > > to the same CPU. Enough from multiple busy IRQ sources and you go boom.
> > 
> > Which leads to the general question why we have that IRQF_DISABLED
> > shite at all. AFAICT the historical reason were IDE drivers, but we
> 
> My understanding was that traditionally the irq handlers were
> allowed to nest and the "fast" non nest case was only added for some 
> fast handlers like serial with small FIFOs.
> 
> > grew other abusers like USB, SCSI and other crap which runs hard irq
> > handlers for hundreds of micro seconds in the worst case. All those
> > offenders need to be fixed (e.g. by converting to threaded irq
> > handlers) so we can run _ALL_ hard irq context handlers with interrupts
> > disabled. lockdep will sort out the nasty ones which enable irqs in the
> > middle of that hard irq handler.
> 
> Ok glad to give you advertisement time for your pet project...

You just don't get it. Long running interrupt handlers are a
BUG. Period. If they are short they can run with IRQs disabled w/o any
harm to the system.

> Anyways if such a thing was done it would be a long term project
> and that short term fix would be still needed.

Your patch is not a fix, It's a lousy, horrible and unreliable
workaround. It's not fixing the root cause of the problem at hand.

The real fix is to run the NIC interrupt handlers with IRQs disabled
and be done with it. If you still think that introduces latencies then
prove it with numbers.

Thanks,

	tglx
