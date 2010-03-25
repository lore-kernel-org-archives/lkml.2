Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab0CYQSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 12:18:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275Ab0CYQR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:17:57 -0400
Date: Thu, 25 Mar 2010 09:13:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jesse.brandeburg@intel.com
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
In-Reply-To: <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org> <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
 <20100325093744.GH20695@one.firstfloor.org> <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Mar 2010, Thomas Gleixner wrote:

> On Thu, 25 Mar 2010, Andi Kleen wrote:
> > On Thu, Mar 25, 2010 at 02:46:42AM +0100, Thomas Gleixner wrote:
> > > 3) Why does the NIC driver code not set IRQF_DISABLED in the first
> > >    place?  AFAICT the network drivers just kick off NAPI, so whats the
> > >    point to run those handlers with IRQs enabled at all ?
> > 
> > I think the idea was to minimize irq latency for other interrupts
> 
> So what's the point ? Is the irq handler of that card so long running,
> that it causes trouble ? If yes, then this needs to be fixed. If no,
> then it simply can run with IRQs disabled.

So historically _all_ interrupts allow nesting, except for what used to be 
called "fast" irq handlers. Notably the serial line, which especially on 
chips without buffering needs really low latencies.

So that's where the irq handler code comes from: a "fast" interrupt will 
not ever enable the CPU interrupts at all, and can run without ever doing 
the whole "mask and ACK" code. But no, we absolutely MUST NOT make regular 
interrupt handlers be that kind of fast handlers (ie IRQF_DISABLED in 
modern parlance), because that would make the whole point moot.

So Thomas, you're wrong. We can't fix all irq handlers to be really quick, 
and we MUST NOT run them with all other irq's disabled if they are not - 
because that obviates the whole point.

[ There's another historical issue, which is that at least the SCSI layer 
  used to depend on timer interrupts still coming in, because there were 
  literally cases where the cdoe would wait for a timer tick while 
  _inside_ the SCSI irq handler.

  That may or may not be true any more - I certainly hope it isn't. But 
  it's an example of the kinds of things drivers really can do. ]

> What's the cost? Nothing at all. There is no f*cking difference between:
> 
>  IRQ1 10us
>  IRQ2 10us
>  IRQ3 10us
>  IRQ4 10us

But there _is_ a big f*cking difference when there is another irq involved 
that wants to happen immediately. For a network card that's not (much) of 
an issue, since any sane network card will buffer things anyway. For an 
original 8250 with a single-byte buffer running at 19200 bps on a slow 
machine, it really is a _huge_ deal. On that slow machine, the other 
interrupt handlers won't be 10us anyway. A single PIO op is 1us!

There are other cases where this matters, but that 8250 is the historical 
one.

NOTE! Historically, the "fast" handlers also had a much faster irq 
response because they didn't do that whole MASK/ACK/END thing. So they'd 
just keep the CPU interrupts disabled, and ACK at the end, and I think 
we've even used AUTOEIO so that they didn't need any ACK at all, and we 
never touched the interrupt controller itself for them.

Again, that's a big deal when you're trying to push a serial line past 
19200bps on a slow machine with no hardware buffering (or even to 9600bps, 
for that matter - those IRQ controller accesses were traditionally all 1us 
each, and to do mask+ack+unmask was a minimum of three writes if you were 
off the slave chip, and while we have that magic 'cached_mask' we didn't 
always do that, so it ended up being three PIO writes and two PIO reads: a 
_minimim_ of 5us just for irq controller accesses).

> So what's the point of running a well written (short) interrupt
> handler with interrupts enabled ? Nothing at all. It just makes us
> deal with crap like stacks overflowing for no good reason.

If you know it's short and does almost nothing at all, then IRQF_DISABLED 
would be fine. But you haven't thought it through: IRQF_DISABLED also 
means that you cannot share interrupts with other people (think about it), 
so if this was _only_ about that particular case of four network cards on 
four separate irqs you'd be right, but it isn't.

You need to look at the bigger picture.

> You just don't get it. Long running interrupt handlers are a
> BUG. Period. If they are short they can run with IRQs disabled w/o any
> harm to the system.

Thomas, YOU are the one not getting it. Long-running is a fact. And 
long-running is all relative. 100us is a long time, but with certain 
hardware it's just a fact of life due to PIO costs. IDE drives in PIO mode 
are perhaps the most well-known and extreme example, but tens of 
microseconds is pretty much par for the course.

And yes, slow hardware still exists.

And even on fast hardware, we have the irq sharing issue, along with 
random legacy driver issues.

Now, that all said, I don't know whether Andi's patch is really the right 
thing. But it may well approach being the best thing we'd have.

Now, it's also true that our IRQ infrastructure handlers _could_ be 
smarter, and make the whole problem less likely to happen.

In particular, it's probably true that especially on modern hardware with 
multiple cores, and especially when you do _not_ have irq sharing (which 
is the common case these days for things like network drivers that can use 
MSI), we really would be better off having the irq disabled over the whole 
thing, and on some interrupt controllers it might even be worth it to do 
the old optimization of not masking-and-acking, but just acking.

But see above. This is _not_ something that a driver can do any more. They 
don't know whether the interrupt might end up being shared. Just blindly 
setting IRAF_DISABLED in a driver is _not_ the answer. But being smarter 
in the generic irq handler code might work.

And then, what we could do, is to mark the drivers that absolutely _must_ 
be able to nest specially. Like the IDE driver when in PIO mode. Or maybe 
the SCSI drivers, if they still depend on that timer interrupt happening 
while they are busy.

		Linus
