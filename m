Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab1HKW37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 18:29:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40465 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab1HKW36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 18:29:58 -0400
Date: Thu, 11 Aug 2011 23:29:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Gupta, Ramesh" <grgupta@ti.com>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tony@atomide.com
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2
	cache
Message-ID: <20110811222940.GA26209@n2100.arm.linux.org.uk>
References: <1302817968-28516-1-git-send-email-fernando.lugo@ti.com> <20110414223036.GA7335@n2100.arm.linux.org.uk> <BANLkTin8gugnVoai6VHC7qMgK4eKRXRtHg@mail.gmail.com> <20110428134055.GA19709@n2100.arm.linux.org.uk> <BANLkTikKnE-9WncNCADKfZVqkP1LFPYeXA@mail.gmail.com> <CADysL2bp08WP798_MvUJthGi9ACySDE=Dc_BM9Vd0A=YcKpm+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADysL2bp08WP798_MvUJthGi9ACySDE=Dc_BM9Vd0A=YcKpm+Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 02:28:39PM -0500, Gupta, Ramesh wrote:
> Hi Russel,

grr.

> On Thu, Apr 28, 2011 at 11:48 AM, Gupta, Ramesh <grgupta@ti.com> wrote:
> > Hi Russel,
> >
> > On Thu, Apr 28, 2011 at 8:40 AM, Russell King - ARM Linux
> > <linux@arm.linux.org.uk> wrote:
> >> We _could_ invent a new API to deal with this, which is probably going
> >> to be far better in the longer term for page table based iommus.  That's
> >> going to need some thought - eg, do we need to pass a struct device
> >> argument for the iommu cache flushing so we know whether we need to flush
> >> or not (eg, if we have cache coherent iommus)...
> 
> my apologies for a late mail on this topic.
> 
> do you think of any other requirements for this new API?
> 
> Could we use the existing dmac_flush_range(), outer_flush_range()
> for this purpose instead of a new API?
> 
> I see a comment in the arch/arm/include/asm/cacheflush.h
> for  _not_ to use these APIs directly, but I am not really understand
> the reason for that.

When I create APIs, I create them to solve a _purpose_ to code which wants
to do something.  They're not created to provide some facility which can
be re-used for unrelated stuff.

This has been proven many times to be the correct approach.  Over time,
things change.

Let's say for arguments sake that you decide to use the DMA API stuff
to achieve your goals.  Then, lets say that ARM DMA becomes fully
cache coherent, but your IOMMU tables still need to be flushed from
the L1 caches.

Suddenly, dmac_flush_range() starts doing absolutely nothing.  Your
driver breaks.  I get whinged at because a previously working driver
stops working.  In effect, that usage _prevents_ me making the changes
necessary to keep the core architecture support moving forward as
things develop.  Or, alternatively I just ignore your driver, make the
changes anyway and leave it to rot.

So, APIs get created to provide a purpose.  Like - handling the DMA
issues when mapping a buffer to DMA.  Like handling the DMA issues
when unmapping a buffer from DMA.  If you start using those _because_
they happen to clean or invalidate the cache for you, you're really
asking for your driver to be broken at some point in the future.

What is far better to do is to ensure that we have the right APIs in
place for the purposes for which they are to be used.  So, if we need
an API to flush out the IOMMU page table entries, then that's what
we need, not some bodged lets-reuse-the-dma-flushing-functions thing.
Inside the processors implementation, yes, it may well be the same
thing, but that's a decision for the _processor_ support code to make,
not the IOMMU writer.

As to what shape a new API should be - as I said above, maybe it should
take a struct device argument, virtual base address and size.  Or maybe
if we don't have any coherent IOMMUs then just ignore the device
argument for the time being, and just pass the virtual base address and
size.

The next issue is whether it should require the virtual base address to
be in the kernel direct mapped region.  If you're touching L2, then
that's a yes, because we need to use virt_to_phys on it to get at the
phys address for the L2 operations.

So, I think: extend the cpu cache operations structure to have a method
for dealing with IOMMUs.  Add an inline function to deal with calling
that, and the L2 ops if that's what's required.
