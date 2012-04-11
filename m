Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab2DKFaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 01:30:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:42228 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab2DKFaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 01:30:13 -0400
Message-ID: <1334122182.2984.33.camel@pasglop>
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use
 irq_alloc_desc() instead
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 11 Apr 2012 15:29:42 +1000
In-Reply-To: <1334107996.2984.20.camel@pasglop>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
	 <1329383368-12122-7-git-send-email-grant.likely@secretlab.ca>
	 <m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home>
	 <20120402202848.1EB833E02A7@localhost>
	 <20120402215524.GM24211@n2100.arm.linux.org.uk>
	 <1333406005.30734.61.camel@pasglop>
	 <20120402225223.GN24211@n2100.arm.linux.org.uk>
	 <1333409927.30734.62.camel@pasglop> <m24nsx9iz1.fsf@igel.home>
	 <1333755470.3040.38.camel@pasglop> <m2aa2n7mmw.fsf@igel.home>
	 <1334106834.2984.17.camel@pasglop> <1334107996.2984.20.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-11 at 11:33 +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2012-04-11 at 11:13 +1000, Benjamin Herrenschmidt wrote:
> > On Sat, 2012-04-07 at 14:27 +0200, Andreas Schwab wrote:
> > > Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> > > 
> > > > It's arguable that this irq_set_irq_type(,NONE) shouln't be there but
> > > > still ... it's been around for ever and things worked :-) So something
> > > > -else- is causing the problem and I'd like to understand what exactly.
> > > 
> > > AFAICS before a09b659cd68c10ec6a30cb91ebd2c327fcd5bfe5
> > > irq_set_irq_type(,NONE) was actually a no-op.
> > 
> > So I'm still a bit baffled... ie, I understand some of what's happening
> > but not why it breaks things, I haven't yet managed to reproduce but I
> > haven't tried too hard just yet (was away from the HW) :
> 
> Allright, I have a repro-case, I'll dig.

Ok, so it's Grant's fault :-)

So basically, it's quite subtle and I'm only 99% sure of the details but
I believe what happens is:

 - The audio interrupts get virq 64 and 65 (so above NR_IRQS)

 - The reverse map isn't pre-filled at map time (we should probably do
it nowadays), we do it lazily so ...

 - The audio interrupt happens, it tries to pre-fill the reverse map
and ... fails (see below)

 - This cause irq_linear_revmap() to returns 0

 - This hits another bug in mpic where when that happens it doesn't EOI
the interrupt, which means the priority remains stuck high and we don't
get any other interrupt.

There's thus two bugs here:

 - We don't properly establish the reverse mapping for 64 and 65 (well,
not always, again see below)

 - We don't EOI an interrupt we can't reverse map (we should warn & EOI,
I'll send a patch for that).

The second problem is a bug we shouldn't hit if the first one didn't
happen, the first one comes from way irq_find_mapping() works. Basically
when the revmap entry is 0, we call it to find the mapping & populate
the revmap... and that fails.

That fails because it will only search up to irq_virq_count which is
statically initialized to NR_IRQS, which in our case is 64 so it won't
find our interrupts 64 and 65... 

The reason it works if you don't do the set_type(NONE) is a fluke, it
will crash as soon as you actually do audio:

The set_type(NONE) has the effect in mpic to configure the interrupt to
level low (default). This is also the idle state of the audio interrupt
(which is positive edge), and the MPIC appears to be latching it (yeah
odd, it does seem to latch level interrupts).

So as soon as the audio driver enables it, it fires, triggering the bug.
Without the set_type(NONE) the occurence of the bug is delayed to the
fist time you get a real audio interrupt.

Now what is the solution ? Well, there's several things I think we need
to do:

 - MPIC should properly EOI interrupts it can't revmap (I'll fix that)

 - MPIC should probably not do the set_type(NONE) on map, it's not
useful

 - However, we do have a risk of discrepency between the default trigger
type in the irq_desc vs. the default HW value at startup/map time, so we
do need to do something to reconcile them (that was the intend of NONE I
think)... without that, we risk having irq_create_of_mapping() not
setting the trigger because it thinks it thinks it's right... What do
you think is best here ? We can probably read the HW config and sync the
irq desc appropriately ...

 - The whole business with irq_virq_count needs fixing. Basically the
default value shouldn't be NR_IRQ. I suggest making it 0 and have all
the use sites do something like:

	max = irq_virq_count ? irq_virq_count : nr_irqs;

(Grant, can you take care of that ?)

 - We still need to clear up all the NR_IRQS occurences in arch/powerpc

Cheers,
Ben.


