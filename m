Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab0CZMGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:06:39 -0400
Received: from mail2.shareable.org ([80.68.89.115]:58927 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab0CZMGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:06:36 -0400
Date: Fri, 26 Mar 2010 12:06:20 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [patch 0/2] Run interrupt handlers always with interrupts disabled
Message-ID: <20100326120620.GD19308@shareable.org>
References: <20100326000325.917127328@linutronix.de> <20100326081457.GA23570@flint.arm.linux.org.uk> <20100326092023.GH27394@elte.hu> <20100326095929.063c5f63@lxorguk.ukuu.org.uk> <1269598133.12097.138.camel@laptop> <alpine.LFD.2.00.1003260756540.694@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003260756540.694@xanadu.home>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre wrote:
> On Fri, 26 Mar 2010, Peter Zijlstra wrote:
> 
> > On Fri, 2010-03-26 at 09:59 +0000, Alan Cox wrote:
> > > > As long as it's rare (which it is) i dont see a problem: you can enable 
> > > > interrupts in the handler by using local_irq_enable(), like the IDE PIO 
> > > > drivers do. That way it's documented a bit better as well, because it shows 
> > > > the precise source of the latency, with a big comment explaining it, etc.
> > > 
> > > I don't think it's as rare as you think particularly in embedded, and the
> > > moment you start explicitly using local_irq_enable() you've simply moved
> > > the underlying problem back and made it far harder to grep for.
> > 
> > We've got local_irq_enable_in_hardirq() which should be used and can
> > easily be grep'ed for.
> > 
> > But yes, I would much prefer to simply convert these known slow handlers
> > to threaded interrupts.
> 
> Can't do that.  The smc91x has a very small internal buffer which has to 
> be emptied using PIO.  Threaded interrupts simply have too high 
> latencies for overruns not to occur.  That's why the RX path is entirely 
> done in hardirq context while the TX path is done in softirq context.

Although I wouldn't be surprised to find threaded interrupts are too
slow on certain hardware, is that _fundamental_ to threaded
interrupts, or is it just that our implementation doesn't have the
funky hot path straight direct from hardirq -> running high priority
RT irq thread when it exceeds previously running priority?

In other words, can we swizzle threaded irqs into something more
resembling software-implemented hard irq priorities, while cunningly
updating the kernel state just enough to look like it's a thread?

-- Jamie
