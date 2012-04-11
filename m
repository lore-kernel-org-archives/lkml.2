Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761247Ab2DKU5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:57:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35392 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2DKU5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:57:11 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v5 06/27] irq_domain/powerpc: eliminate irq_map; use irq_alloc_desc() instead
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andreas Schwab <schwab@linux-m68k.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Milton Miller <miltonm@bga.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1334122182.2984.33.camel@pasglop>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca> <1329383368-12122-7-git-send-email-grant.likely@secretlab.ca> <m2iphj3zxr.fsf@igel.home> <m2hax2qeqs.fsf@igel.home> <20120402202848.1EB833E02A7@localhost> <20120402215524.GM24211@n2100.arm.linux.org.uk> <1333406005.30734.61.camel@pasglop> <20120402225223.GN24211@n2100.arm.linux.org.uk> <1333409927.30734.62.camel@pasglop> <m24nsx9iz1.fsf@igel.home> <1333755470.3040.38.camel@pasglop> <m2aa2n7mmw.fsf@igel.home> <1334106834.2984.17.camel@pasglop> <1334107996.2984.20.camel@pasglop> <1334122182.2984.33.camel@pasglop>
Date: Wed, 11 Apr 2012 14:57:07 -0600
Message-Id: <20120411205707.68AC13E08B6@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2012 15:29:42 +1000, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Wed, 2012-04-11 at 11:33 +1000, Benjamin Herrenschmidt wrote:
> > On Wed, 2012-04-11 at 11:13 +1000, Benjamin Herrenschmidt wrote:
> > > On Sat, 2012-04-07 at 14:27 +0200, Andreas Schwab wrote:
> > > > Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> > > > 
> > > > > It's arguable that this irq_set_irq_type(,NONE) shouln't be there but
> > > > > still ... it's been around for ever and things worked :-) So something
> > > > > -else- is causing the problem and I'd like to understand what exactly.
> > > > 
> > > > AFAICS before a09b659cd68c10ec6a30cb91ebd2c327fcd5bfe5
> > > > irq_set_irq_type(,NONE) was actually a no-op.
> > > 
> > > So I'm still a bit baffled... ie, I understand some of what's happening
> > > but not why it breaks things, I haven't yet managed to reproduce but I
> > > haven't tried too hard just yet (was away from the HW) :
> > 
> > Allright, I have a repro-case, I'll dig.
> 
> Ok, so it's Grant's fault :-)

I pretty much expected it would be.  :-p

> So basically, it's quite subtle and I'm only 99% sure of the details but
> I believe what happens is:
> 
>  - The audio interrupts get virq 64 and 65 (so above NR_IRQS)
> 
>  - The reverse map isn't pre-filled at map time (we should probably do
> it nowadays), we do it lazily so ...

Hmmm... I though I had merged a patch that does that.

/me goes to look again...

Okay, I did write that patch, but I never merged it because it didn't
get much review and I was already nervous about the other irq_domain
changes.  I'll post it again and ask for feedback.

>  - The whole business with irq_virq_count needs fixing. Basically the
> default value shouldn't be NR_IRQ. I suggest making it 0 and have all
> the use sites do something like:
> 
> 	max = irq_virq_count ? irq_virq_count : nr_irqs;
> 
> (Grant, can you take care of that ?)

Yeah, I've got a different way to fix it though.  There is exactly one
user of irq_virq_count in-tree right now: PS3.  Also, irq_virq_count
is only useful for the NOMAP mapping.  So, instead of having a single
global irq_virq_count values, I've dropped it entirely and added a
max_irq argument to irq_domain_add_nomap().  That makes it a property
of an individual nomap irq domain instead of a global system settting.

Hopefully I'll have a draft patch ready today.

g.
