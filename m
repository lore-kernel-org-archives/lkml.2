Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab0CYOQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:16:57 -0400
Received: from www.tglx.de ([62.245.132.106]:39248 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab0CYOQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:16:56 -0400
Date: Thu, 25 Mar 2010 15:16:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
In-Reply-To: <20100325133204.GP20695@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.1003251441420.3147@localhost.localdomain>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org> <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
 <20100325093744.GH20695@one.firstfloor.org> <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain> <20100325121141.GO20695@one.firstfloor.org> <alpine.LFD.2.00.1003251338130.3147@localhost.localdomain> <20100325133204.GP20695@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010, Andi Kleen wrote:
> > > > > Anyways if such a thing was done it would be a long term project
> > > > > and that short term fix would be still needed.
> > > > 
> > > > Your patch is not a fix, It's a lousy, horrible and unreliable
> > > > workaround. It's not fixing the root cause of the problem at hand.
> > > 
> > > It fixes the bug in a minimally intrusive way.
> > 
> > It papers over the problem. We already know that the NIC driver floods
> > the machine with interrupts, so why are you insisting that we need to
> 
> Well in this case it's simply because it has 4 ports and they are all
> active and have a lot of MSI-X vectors for each stream. 
> 
> Even if you had the perfect interrupt handler that ran in
> one cycle, if you had enough of them in parallel from different ports
> there could be still a stack overflow problem on individual CPUs.

Not at all if the handler runs with irqs disabled.
 
> > The minimal intrusive way is a one liner in that very driver code and
> > if it causes problems for that very driver then we don't fix them with
> > adding a callback in the generic interrupt code path.
> 
> Ok.
> 
> > 
> > The message which we would send out with applying that band aid would
> > be simply: Go ahead driver writers and let your handlers run as long
> 
> Well it's simply the current state of affairs today. I'm merely
> attempting to make the current state slightly safer without breaking
> anything in the process.

Well, I'd agree if those stack overflows would be a massive reported
problem. 

Right now they happen with a weird test case which points out a
trouble spot. Multi vector NICs under heavy load. So why not go there
and change the handful of drivers to run their handlers with irqs
disabled?

Band aids are the last resort if we can't deal with a problem by other
sane means. And this problem falls not into that category, it can be
solved in the affected drivers with zero effort.

Thanks,

	tglx



