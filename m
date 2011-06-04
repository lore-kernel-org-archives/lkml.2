Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab1FDAX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 20:23:27 -0400
Received: from mail4.comsite.net ([205.238.176.238]:5196 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab1FDAXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 20:23:25 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=75.92.62.227;
From: Milton Miller <miltonm@bga.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: genirq: Ensure we locate the passed IRQ in irq_alloc_descs()
Message-ID: <irq-locate-ack@mdm.bga.com>
In-Reply-To: <20110603150636.GA9492@opensource.wolfsonmicro.com>
References: <1307037313-15733-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <nack-locate@mdm.bga.com>
 <20110603104217.GA4777@opensource.wolfsonmicro.com>
 <locate-from-more@mdm.bga.com>
 <20110603150636.GA9492@opensource.wolfsonmicro.com>
 <alpine.LFD.2.02.1106031823310.3078@ionos>
Date: Fri, 03 Jun 2011 19:23:24 -0500
X-Originating-IP: 75.92.62.227
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Replying to both Mark and Thomas]

On Fri, 3 Jun 2011 about 16:06:36 +0100, Mark Brown wrote:
> On Fri, Jun 03, 2011 at 09:43:42AM -0500, Milton Miller wrote:
> 
> > I treated the arguments to irq_alloc_descs as having grown to
> > accomidate the two uses having a common allocator with the partially
> > redunant encoding.  In one case an exact irq was specified (irq >= 0),
> > and one that allocates from anywhere (irq < 0, all callers passed -1).
> 
> > Maybe you have a new case.
> 
> No, I'm only aware of those two cases.  All my change does is make the
> irq parameter be enough to select between the two - at the minute it's
> just too weak.

Actually I do consider this a new case.   You are implementing some kind
of cascade, and your code does not know (or want to care) if it can use
any irq or needs a platform selected irq block.  The decision of "Is
this system fully enabled for dynamic irq selection?" is not in the
code but in some externally supplied data.

> 
> > Do you need a specific irq or an allocated one?
> 
> > Or do you have a case where you don't know?
> 
> I need either a specific IRQ or an allocated one.  This is just a very
> standard driver with an interrupt controller 

I don't know that I'd call an interrupt controller a standard driver
today, but agree we are heading towards that.

> > Do you need a block of 60?  or just 60 somewhere?
> 
> The driver assumes it's going to get a contiguous range, it'd be a lot
> of bookkeeping for no gain to have to cope with them being splattered
> all over the place.

The irq domain concept addresses mapping, but a simple fully allocated
block will be one of the options.  Having 60 irqdesc might be 
pushing the limit for some platforms but that can be addressed later
when irq domains are upstream.


> > How do you know from = 0 is safe?
> 
> If the user cares they can just pick a number for the base; if they're
> going to pick a number they may as well pick the actual number.

I'd argue the user is the wrong level to make this decision.  However,
saying the platform decides is valid, and the excerpt you had earlier
implied you were getting the irq argument from platform data, not the
user (eg via a module parameter)..

Also, read the last five paragraphs below.

> > > I don't really see the relevance of this patch?  You're adding
> > > functionality for limiting the maximum IRQ number allocated which seems
> > > orthogonal to the issue.
> 
> > Its relavant in that irq_alloc_descs_range no longer gets both irq and from;
> > the information is passed to the underling allocator in a different form.
> 
> That's not the goal of the patch, it's just something the patch happens
> to do as part of the implementation as far as I can see.

Well, eliminating the redundant information was a secondary goal.

On Fri, 3 Jun 2011 about 18:25:01 +0200 (CEST), Thomas Gleixner wrote:
> On Fri, 3 Jun 2011, Milton Miller wrote:
> > On Fri, 3 Jun 2011 about 11:42:17 +0100, Mark Brown wrote:
> > > On Fri, Jun 03, 2011 at 04:24:02AM -0500, Milton Miller wrote:
> > > > On Thu, 02 Jun 2011 17:55:13 -0000, Mark Brown wrote:
> > > 
> > > > >  	start = bitmap_find_next_zero_area(allocated_irqs, IRQ_BITMAP_BITS,
> > > 
> > > > and then right after this the code continues:
> > > 
> > > >         ret = -EEXIST;
> > > >         if (irq >=0 && start != irq)
> > > >                 goto err;
> > > 
> > > > This patch enables exactly the calls I want to forbid !  Why do
> > > 
> > > Which you wish to forbid because...?  You've not articulated any
> > > motivation for doing this which makes it rather hard to engage here.
> > 
> > In 2.6.39 all calls to irq_alloc_descs were from the helpers.  Either
> > from  irq_alloc_descriptor_at , which says "I need this exact irq",
> > or from irq_alloc_desc, which says "give me any irq".
> 
> That does not prevent a caller with uses irq_alloc_descs() directly
> with the wrong arguments. So we want to sanity check this.

I wasn't debating a sanity check.  I was claiming that the incoming
argument combination was not sane and should be outright rejected
instead of given new meaning and fixed up.

As I said earlier, I saw two valid use cases: the caller needed a
fixed irq, and the caller didn't care about the irq.  However, upon
the further discussion, it does appear that Mark has a third case:
the driver can handle either; the choice is up to the platform.

With the further discussion, and some time to sleep and reflect on
what the patch actually acomplishes and the use case, I withdraw
my objection.  The patch changes the semantics of the case irq >= 0
and from != irq, but it defines it in a meaningful way that removes
the current insane combindation of events required for a successful
allocation.

Acked-by: Milton Miller <miltonm@bga.com>

I should point out that several archtectures currently allocate irqs
in a architecture layer before calling the irq allocator asking for
the exact irq they choose on what they thought was free.  Among these
are x86 and powerpc.   Not calling the architecture layer will causein
all future allocations by other drivers using the architecture layer
to fail..

That means that any driver allocating irqs directly is not generic if
it actually allocates irqs unconditionally!  Instead it will cause
hotplug or even boot failures (if it allocates irqs too early).

I have a series in mind, inspired by Grant's initial proposal, to
change the master allocation for powerpc (and export its helpers as irq
domains), although I haven't been able to work on it for the last week
or so.

An alternative, that can be implemented easily today, is to add the
ability to specify from above what the architecture layer manages.
(eg depend on SPARSE_IRQ and set from to NR_IRQS).

Looking at my other patch I can hide this in irq_alloc_descs helper
as I already have a if ladder with two calls to irq_alloc_descs_range.
Presently I don't intend to offer this ambigious feature directly in
the _range call, but will support it through the wrapper for the
existing functions.


Thanks for the discussion
milton
