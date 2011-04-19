Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1DSNCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 09:02:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49349 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab1DSNC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 09:02:29 -0400
Date: Tue, 19 Apr 2011 14:02:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, linux-kernel@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Ramesh Gupta <grgupta@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2
	cache
Message-ID: <20110419130201.GA24972@n2100.arm.linux.org.uk>
References: <1302817968-28516-1-git-send-email-fernando.lugo@ti.com> <201104181613.43572.arnd@arndb.de> <BANLkTi=dpqMFjW_B5-YsmoCJf62b8djj5g@mail.gmail.com> <201104191401.34818.arnd@arndb.de> <BANLkTim_30SbVhPLFOaq-KYwz5N6NGCe6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim_30SbVhPLFOaq-KYwz5N6NGCe6A@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 09:35:56PM +0900, Kyungmin Park wrote:
> On Tue, Apr 19, 2011 at 9:01 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 19 April 2011, Kyungmin Park wrote:
> >> On Mon, Apr 18, 2011 at 11:13 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> > On Monday 18 April 2011, Kyungmin Park wrote:
> >> >> On Mon, Apr 18, 2011 at 8:58 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> >> >
> >> >> > One missing piece is still a way for a platform to provide both
> >> >> > the iommu and the dma-mapping API in a unified driver. Right now,
> >> >> > you have to export both interface for a generic solution.
> >> >>
> >> >> Actually MSM and we (Michal, Marek) tried to merge the generic IOMMU
> >> >> implementation into mm, but MM did't accept it.
> >> >
> >> > I'm confused. What do you mean with MM?
> >> linux/mm, Memory Management.
> >
> > I'm still confused. What were you suggesting to merge in there?
> > Do you have a link to a mailing list discussion?
> 
> First, Zach Pfeffer <zpfeffer@codeaurora.org> sent the patch
> https://patchwork.kernel.org/patch/108736/
> 
> Second, Michal tried it.
> http://lkml.org/lkml/2010/9/6/41
> 
> http://lwn.net/Articles/403643/
> https://patchwork.kernel.org/patch/157451/

This shows why ARM is in such a problem.  People love to create new
frameworks and infrastructure where they find existing stuff lacking,
rather than looking at what other architectures do and adapt.

As I'm sure has already mentioned, the kernel already has support for
IOMMUs in the DMA path with several non-ARM architectures, and this
support is managed through the existing DMA API.

When you want a device behind an IOMMU to perform DMA, the driver
uses the DMA API in the standard way as if there was no IOMMU there.
As part of the DMA API, particularly the SG list part, the DMA API
is allowed to coalesce the SG entries together if it can arrange
the IOMMU mappings to achieve a continguous mapping for the device.
Remember, dma_map_sg() is allowed to return _fewer_ entries in the
scatterlist than was passed to it for this very purpose.

In order to transition ARM over to this, we need to modify the
scatterlist structure by enabling CONFIG_NEED_SG_DMA_LENGTH.  We
then need to arrange for the DMA API to have the hooks _both_ into
the DMA cache coherency code (to ensure that the data hits memory)
and the IOMMU code (this part is missing from ARM.)  The current
abstractions in the generic header files don't allow for this.

I don't believe there's any need for any major new framework - and I
don't think I'm alone in thinking that, especially as this point has
been raised more than once when this framework has been submitted.

I see no reason why ARM should be any different from other architectures
which have IOMMUs, and I don't see why ARM should have to invent a whole
new framework to handle IOMMUs.  And I see no explanation why the
existing hooks are unsuitable - at least as the _initial_ starting point.

So, can you please explain why your IOMMU code can not be hidden behind
the DMA API.  (Please omit any complaints about the mechanics of hooking
it in there, such things are solvable.)

