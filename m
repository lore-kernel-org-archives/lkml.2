Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab1EZNha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 09:37:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33245 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab1EZNh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 09:37:29 -0400
Date: Thu, 26 May 2011 14:36:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
	locks up on ARM
Message-ID: <20110526133648.GH24876@n2100.arm.linux.org.uk>
References: <1306343335.21578.65.camel@twins> <1306358128.21578.107.camel@twins> <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com> <1306405979.1200.63.camel@twins> <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com> <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins> <20110526122623.GA11875@elte.hu> <20110526123137.GG24876@n2100.arm.linux.org.uk> <20110526125007.GA27083@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526125007.GA27083@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 02:50:07PM +0200, Ingo Molnar wrote:
> 
> * Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > On Thu, May 26, 2011 at 02:26:23PM +0200, Ingo Molnar wrote:
> > > 
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > Sort this by reverting to the old behaviour for this situation 
> > > > and perform a full remote wake-up.
> > > 
> > > Btw., ARM should consider switching most of its subarchitectures 
> > > to !__ARCH_WANT_INTERRUPTS_ON_CTXSW - enabling irqs during 
> > > context switches is silly and now expensive as well.
> > 
> > Not going to happen.  The reason we do it is because most of the 
> > CPUs have to (slowly) flush their caches during switch_mm(), and to 
> > have IRQs off over the cache flush means that we lose IRQs.
> 
> How much time does that take on contemporary ARM hardware, typically 
> (and worst-case)?

I can't give you precise figures because it really depends on the hardware
and how stuff is setup.  All I can do is give you examples from platforms
I have here running which rely upon this.

Some ARM CPUs have to read 32K of data into the data cache in order to
ensure that any dirty data is flushed out.  Others have to loop over the
cache segments/entries, cleaning and invalidating each one (that's 8 x 64
for ARM920 so 512 interations).

If my userspace program is correct, then it looks like StrongARM takes
about 700us to read 32K of data into the cache.

Measuring the context switches per second on the same machine (using an
old version of the Byte Benchmarks) gives about 904 context switches per
second (equating to 1.1ms per switch), so this figure looks about right.

Same CPU but different hardware gives 698 context switches per second -
about 1.4ms per switch.  With IRQs enabled, its possible to make this
work but you have to read 64K of data instead, which would double the
ctxt switch latency here.

On an ARM920 machine, running the same program gives around 2476 per
second, which is around 400us per switch.

Your typical 16550A with a 16-byte FIFO running at 115200 baud will fill
from completely empty to overrun in 1.1ms.  Realistically, you'll start
getting overruns well below that because of the FIFO thresholds - which
may be trigger an IRQ at half-full.  So 600us.

This would mean 16550A's would be entirely unusable with StrongARM, with
an overrun guaranteed at every context switch.

This is not the whole story: if you have timing sensitive peripherals
like UARTs, then 1.1ms - 700us doesn't sound that bad, until you start
considering other IRQ load which can lock out servicing those peripherals
while other interrupt handlers are running.

So all in all, having IRQs off for the order of 700us over a context
switch is a complete non-starter of an idea.
