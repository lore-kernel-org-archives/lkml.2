Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab0DWTGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:06:08 -0400
Received: from relais.videotron.ca ([24.201.245.36]:26836 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab0DWTGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:06:05 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 23 Apr 2010 15:06:03 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Jamie Lokier <jamie@shareable.org>
Cc: Paulius Zaleckas <paulius.zaleckas@gmail.com>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       u.kleine-koenig@pengutronix.de, simon.kagstrom@netinsight.net,
       akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
       rth@twiddle.net
Subject: Re: [PATCH v2] MTD: Fix Orion NAND driver compilation with ARM OABI
In-reply-to: <20100325204619.GC19308@shareable.org>
Message-id: <alpine.LFD.2.00.1004231443340.7232@xanadu.home>
References: <20100325152505.17612.40158.stgit@pauliusz>
 <20100325204619.GC19308@shareable.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010, Jamie Lokier wrote:

> Paulius Zaleckas wrote:
> > Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>
> 
> It's probably worth including the people who weighed in on the
> discussion with 'Cc:' headers.
> 
> > -		uint64_t x;
> > +		/*
> > +		 * Since GCC has no proper constraint (PR 43518)
> > +		 * force x variable to r2/r3 registers as ldrd instruction
> > +		 * requires first register to be even.
> > +		 */
> > +		register uint64_t x asm ("r2");
> > +
> >  		asm volatile ("ldrd\t%0, [%1]" : "=&r" (x) : "r" (io_base));
> >  		buf64[i++] = x;
> 
> The "register...asm" looks fine, but it occurs to me the constraints
> are too weak (and they were before), so GCC could optimise that to the
> wrong behaviour.
> 
> The "volatile" prevents GCC deleting the asm if it's output isn't
> used, but it doesn't stop GCC from reordering the asms, for example if
> it decides to unroll the loop.  It probably won't reorder in that
> case, but it could.  The result would be out of order values stored
> into buf[].  It could even move the ldrd earlier than the prior byte
> accesses, or after the later byte accesses.

I don't see how that could happen.  The store into buf[] puts a 
dependency on the output constraint of the inline asm statement.  And by 
vertue of being volatile, gcc cannot cache the result of the output from 
the asm as if it was a pure function.

> Any one of these should fix it:
> 
>    - Make io_base a pointer-to-volatile-u64 or cast it in the asm, and
>      make sure to dereference it and use an "m" constraint (or
>      tighter, such as "Q", if ldrd needs it).  It must be u64, not
>      pointer-to-void, to tell GCC the size.  That tells GCC which memory
>      the asm accesses, and the volatile dereference should tell GCC
>      not to reorder them in principle (but the GCC manual doesn't
>      make a specific promise about this for asms).

The LDRD has special range constraints on its addressing mode which is 
not expressable with any of the available gcc memory constraints.

> You aren't supposed to dereference pointers used with read{b,w,l}
> anyway.  It doesn't matter in this driver because we "know" it's only
> used on an SoC where read{b,w,l} don't do any address translation.
> But will that always be true?  I suppose the cleanest approach is to
> define readq, the 64-bit analogue of readl, and use that here.  x86
> already defines readq, so it's got precedent.

But yet it is not all ARM variants that can do 64-bit accesses.  
Anything pre ARMv5 doesn't have the LDRD instruction, and the equivalent 
LDM is not a possible substitute with regard to memory bus access 
either.

So I'd prefer to keep it as an obvious local exception that happens to 
exploit some specifics of the actual hardware implementation rather than 
something that was architecturally defined.


Nicolas
