Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab0CYJhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:37:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44418 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab0CYJht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:37:49 -0400
Date: Thu, 25 Mar 2010 10:37:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jesse.brandeburg@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near overflowing v2
Message-ID: <20100325093744.GH20695@one.firstfloor.org>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org> <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 02:46:42AM +0100, Thomas Gleixner wrote:
> "misleading" is an euphemism at best ... 
> 
> This is ever repeating shit: your changelogs suck big time!

As much as your comments I guess.

> 
> > "
> > Multiple vectors on a multi port NIC pointing to the same CPU, 
> > all hitting the irq stack until it overflows.
> > "
> 
> So there are several questions:
> 
> 1) Why are those multiple vectors all hitting the same cpu at the same
>    time ? How many of them are firing at the same time ?

This was 4 NIC ports being operational under stress at the same time

> 
> 2) What kind of scenario is that ? Massive traffic on the card or some
>    corner case ?

Massive traffic on the card from multiple ports on a large system.

> 3) Why does the NIC driver code not set IRQF_DISABLED in the first
>    place?  AFAICT the network drivers just kick off NAPI, so whats the
>    point to run those handlers with IRQs enabled at all ?

I think the idea was to minimize irq latency for other interrupts

But yes defaulting to IRQF_DISABLED would fix it too, at some 
cost. In principle that could be done also.

> 
> > > case of MSI-X it just disables the IRQ when it comes again while the
> > > first irq on that vector is still in progress. So the maximum nesting
> > > is two up to handle_edge_irq() where it disables the IRQ and returns
> > > right away.
> > 
> > Real maximum nesting is all IRQs running with interrupts on pointing
> > to the same CPU. Enough from multiple busy IRQ sources and you go boom.
> 
> Which leads to the general question why we have that IRQF_DISABLED
> shite at all. AFAICT the historical reason were IDE drivers, but we

My understanding was that traditionally the irq handlers were
allowed to nest and the "fast" non nest case was only added for some 
fast handlers like serial with small FIFOs.

> grew other abusers like USB, SCSI and other crap which runs hard irq
> handlers for hundreds of micro seconds in the worst case. All those
> offenders need to be fixed (e.g. by converting to threaded irq
> handlers) so we can run _ALL_ hard irq context handlers with interrupts
> disabled. lockdep will sort out the nasty ones which enable irqs in the
> middle of that hard irq handler.

Ok glad to give you advertisement time for your pet project...

Anyways if such a thing was done it would be a long term project
and that short term fix would be still needed.

> the handlers on which you enforce IRQ_DISABLED does not enable
> interrupts itself ? You _CANNOT_.

I can't, just as much as I cannot enforce they won't crash or not loop
forever or something. But afaik they don't. 

I did some quick grepping and didn't found a driver who does that
at least.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
