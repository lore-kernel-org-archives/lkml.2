Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab0CYBrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 21:47:04 -0400
Received: from www.tglx.de ([62.245.132.106]:41815 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660Ab0CYBrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 21:47:01 -0400
Date: Thu, 25 Mar 2010 02:46:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
In-Reply-To: <20100325003652.GG20695@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010, Andi Kleen wrote:

> On Thu, Mar 25, 2010 at 12:08:23AM +0100, Thomas Gleixner wrote:
> > On Wed, 24 Mar 2010, Thomas Gleixner wrote:
> > 
> > > On Wed, 24 Mar 2010, Andi Kleen wrote:
> > > 
> > > > Prevent nested interrupts when the IRQ stack is near overflowing v2
> > > > 
> > > > Interrupts can always nest when they don't run with IRQF_DISABLED.
> > > > 
> > > > When a lot of interrupts hit the same vector on the same
> > > > CPU nested interrupts can overflow the irq stack and cause hangs.
> > That's utter nonsense. An interrupt storm on the same vector does not
> > cause irq nesting. The irq code prevents reentering a handler and in
> 
> Sorry it's the same CPU, not the same vector.  Yes the reference
> to same vector was misleading.

"misleading" is an euphemism at best ... 

This is ever repeating shit: your changelogs suck big time!

> "
> Multiple vectors on a multi port NIC pointing to the same CPU, 
> all hitting the irq stack until it overflows.
> "

So there are several questions:

1) Why are those multiple vectors all hitting the same cpu at the same
   time ? How many of them are firing at the same time ?

2) What kind of scenario is that ? Massive traffic on the card or some
   corner case ?

3) Why does the NIC driver code not set IRQF_DISABLED in the first
   place?  AFAICT the network drivers just kick off NAPI, so whats the
   point to run those handlers with IRQs enabled at all ?

> > case of MSI-X it just disables the IRQ when it comes again while the
> > first irq on that vector is still in progress. So the maximum nesting
> > is two up to handle_edge_irq() where it disables the IRQ and returns
> > right away.
> 
> Real maximum nesting is all IRQs running with interrupts on pointing
> to the same CPU. Enough from multiple busy IRQ sources and you go boom.

Which leads to the general question why we have that IRQF_DISABLED
shite at all. AFAICT the historical reason were IDE drivers, but we
grew other abusers like USB, SCSI and other crap which runs hard irq
handlers for hundreds of micro seconds in the worst case. All those
offenders need to be fixed (e.g. by converting to threaded irq
handlers) so we can run _ALL_ hard irq context handlers with interrupts
disabled. lockdep will sort out the nasty ones which enable irqs in the
middle of that hard irq handler.

Your band aid patch is just disgusting. How do you ensure that none of
the handlers on which you enforce IRQ_DISABLED does not enable
interrupts itself ? You _CANNOT_.

I'm not taking that patch unless you come up with a real convincing
story.

Thanks,

	tglx


