Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab0HOFnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 01:43:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:34468 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab0HOFnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 01:43:15 -0400
Date: Sun, 15 Aug 2010 14:42:51 +0900
To: linux@arm.linux.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, khc@pm.waw.pl, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100814184605.GA1999@n2100.arm.linux.org.uk>
References: <20100813215413.GA21607@n2100.arm.linux.org.uk>
	<20100814181306U.fujita.tomonori@lab.ntt.co.jp>
	<20100814184605.GA1999@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100815144122O.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 15 Aug 2010 14:42:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Aug 2010 19:46:05 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Sat, Aug 14, 2010 at 06:30:37PM +0900, FUJITA Tomonori wrote:
> > On Fri, 13 Aug 2010 22:54:13 +0100
> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > >  This means that when dmabounce comes to allocate the replacement
> > > buffer, it gets a buffer which won't be accessible to the DMA
> > > controller
> > 
> > Really? looks like dmabounce does nothing for coherent memory that
> > dma_alloc_coherent() allocates.
> > 
> > The following very hacky patch works?
> 
> So what happens if you use a driver which uses dma_alloc_coherent()
> directly?  Should the driver really be passed memory which is
> inaccessible to the device because its outside the host bridge PCI
> window?

I'm not sure what you mean.

A driver which uses dma_alloc_coherent() directly should
work. dma_alloc_coherent() allocates memory with GFP_DMA with that
patch for dmabounce devices. So the driver gets the access-able
memory.

The memory that dma_alloc_coherent() returns should be always
consistent. We can't bounce it. All we can do is returning a memory
that a device (and its bus) can access to.

Krzysztof, can you try the patch?


> No, this is clearly wrong, so this patch doesn't fix anything.  It's
> a bodge, nothing more.  The real solution is to have _both_ masks
> both reduced down according to the host bridge, as we used to do.
> 
> So I suggest 6fee48c is reverted so that these platforms don't regress
> for -rc1.

Sorry, the original ARM code is wrong. dev->dma_mask and
dev->coherent_dma_mask represent the driver of dma restriction. ARM
tries to use them for both a driver and a bus so ARM needs a
workaround that doesn't set the driver of dma restriction to
dev->dma_mask and dev->coherent_dma_mask.

The proper solution is having a separate dma mask for a bus. I think
that POWERPC already does the similar. It has max_direct_dma_addr in
struct dev_archdata, which represents the dma restriction of a bus.

