Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab0G2LsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 07:48:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:32966 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab0G2LsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 07:48:02 -0400
Date: Thu, 29 Jul 2010 12:47:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-arm-msm@vger.kernel.org, dwalker@codeaurora.org,
        stepanm@codeaurora.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Message-ID: <20100729114726.GA17991@n2100.arm.linux.org.uk>
References: <1280270466-13503-1-git-send-email-stepanm@codeaurora.org> <201007281950.20847.arnd@arndb.de> <20100728212156.GA6729@n2100.arm.linux.org.uk> <201007291012.05986.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007291012.05986.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 10:12:05AM +0200, Arnd Bergmann wrote:
> On Wednesday 28 July 2010 23:21:56 Russell King - ARM Linux wrote:
> > On Wed, Jul 28, 2010 at 07:50:20PM +0200, Arnd Bergmann wrote:
> > > The DMA API is extremely flexible, it works just fine with all the
> > > IOMMUs that I've seen so far. Please take a look at
> > > include/asm-generic/dma-mapping-common.h and its users to see how
> > > to use multiple IOMMUs depending on the device.
> > 
> > We don't yet use those DMA API interface extensions because we haven't
> > had the need.  If someone who has the need wants to put the effort in
> > though...
> 
> Right, it shouldn't be hard now that the groundwork for that is done.
> Also, it's only really needed if you have IOMMUs of different types in the
> same system. If msm doesn't have any swiotlb or dmabounce devices,
> it could always use the same implementation for all devices.
> 
> > One of the problems with it though is the abstraction of the sync*
> > operations is the wrong way around for stuff like dmabounce - we want
> > to be passed the base address of the buffer (so we can look this up),
> > plus offset and length.  We don't want to know just the region which
> > is affected.
> 
> Yes, but that is an unrelated (dmabounce specific) problem that seems to
> be fixed by an existing patch.

It's not unrelated because it stands in the way of using that interface.
The patch also seems to be buggy in that it doesn't fix the for_device
case - it leaves 'off' as zero.

I'm also not sold on this idea that the sync_range API is being obsoleted.
It seems to me to be a step in the wrong direction.  The range API is a
natural subset of the 'normal' sync API, yet people are trying to shoehorn
the range API into the 'norma' API.  If anything it's the 'normal' API
which should be obsoleted as it provides reduced information to
implementations, which then have to start fuzzy-matching the passed
address.

If we're going to start fuzzy-matching the passed address, then I think
we also need to add detection of overlapping mappings and BUG() on such
cases - otherwise we risk the possibility of having multiple overlapping
mappings and hitting the wrong mapping with this reduced-information sync
API.

> The driver posted by Stepan doesn't even support the dma_sync_single_*
> style operations, and I don't think it can run into that specific problem.
> Are there even (hardware) IOMMUs that are connected to noncoherent
> buses?

Yes.  Virtually all ARM systems have non-cache coherent DMA.  Doesn't
matter if there's an IOMMU or not.
