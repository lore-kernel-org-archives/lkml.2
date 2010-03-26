Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab0CZMAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:00:54 -0400
Received: from relais.videotron.ca ([24.201.245.36]:28756 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab0CZMAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:00:51 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 26 Mar 2010 08:00:29 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [patch 0/2] Run interrupt handlers always with interrupts disabled
In-reply-to: <1269598133.12097.138.camel@laptop>
Message-id: <alpine.LFD.2.00.1003260756540.694@xanadu.home>
References: <20100326000325.917127328@linutronix.de>
 <20100326081457.GA23570@flint.arm.linux.org.uk>
 <20100326092023.GH27394@elte.hu> <20100326095929.063c5f63@lxorguk.ukuu.org.uk>
 <1269598133.12097.138.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Mar 2010, Peter Zijlstra wrote:

> On Fri, 2010-03-26 at 09:59 +0000, Alan Cox wrote:
> > > As long as it's rare (which it is) i dont see a problem: you can enable 
> > > interrupts in the handler by using local_irq_enable(), like the IDE PIO 
> > > drivers do. That way it's documented a bit better as well, because it shows 
> > > the precise source of the latency, with a big comment explaining it, etc.
> > 
> > I don't think it's as rare as you think particularly in embedded, and the
> > moment you start explicitly using local_irq_enable() you've simply moved
> > the underlying problem back and made it far harder to grep for.
> 
> We've got local_irq_enable_in_hardirq() which should be used and can
> easily be grep'ed for.
> 
> But yes, I would much prefer to simply convert these known slow handlers
> to threaded interrupts.

Can't do that.  The smc91x has a very small internal buffer which has to 
be emptied using PIO.  Threaded interrupts simply have too high 
latencies for overruns not to occur.  That's why the RX path is entirely 
done in hardirq context while the TX path is done in softirq context.


Nicolas
