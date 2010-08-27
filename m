Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab0H0Gzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 02:55:48 -0400
Received: from sh.osrg.net ([192.16.179.4]:55527 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab0H0Gzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 02:55:45 -0400
Date: Fri, 27 Aug 2010 15:54:54 +0900
To: linux@arm.linux.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, benh@kernel.crashing.org, khc@pm.waw.pl,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100826175719.GC13224@n2100.arm.linux.org.uk>
References: <20100826205344E.fujita.tomonori@lab.ntt.co.jp>
	<20100826225352S.fujita.tomonori@lab.ntt.co.jp>
	<20100826175719.GC13224@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100827155440T.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 27 Aug 2010 15:55:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 18:57:19 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Thu, Aug 26, 2010 at 10:54:39PM +0900, FUJITA Tomonori wrote:
> > On Thu, 26 Aug 2010 20:55:09 +0900
> > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > On Fri, 20 Aug 2010 07:51:52 +1000
> > > Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > > 
> > > > On Thu, 2010-08-19 at 23:50 +0900, FUJITA Tomonori wrote:
> > > > > 
> > > > > You mean that you like to permit architectures to modify
> > > > > dev->coherent_dma_mask behind a device? If so, I'm against it because
> > > > > it means dev->coherent_dma_mask has two meanings. That's confusing.
> > > > 
> > > > No it's not. It has one and only one meaning which is the mask defining
> > > > where the coherent memory can come from for that device. Nobody cares if
> > > > the device can do more and has been "clipped" at set_coherent_dma_mask()
> > > > time by the bus. This is not useful information.
> > > 
> > > Ok.
> > 
> > btw, I'm still not sure, letting architectures to clip the dma mask
> > (and coherent mask) behind a driver is correct by defintion of the DMA
> > API (it's not a real problem).
> > 
> > DMA-API.txt defines dma_set_mask is "checks to see if the mask is
> > possible and update the device parameters if it is". It means that
> > architectures can't clip the mask behind a driver, I think.
> > 
> > Lots of drivers do something like:
> > 
> > if (dma_set_mask(dev, DMA_BIT_MASK(64)))
> >         if (dma_set_mask(dev, DMA_BIT_MASK(32)))
> > 
> > What arm does is accepting whatever dma mask and setting the clipped
> > mask behind a driver. If we use this sementics (archs are free to clip
> > the mask), drivers don't need the second dma_set_mask call. And the
> > driver wrongly assumes that it successfully set 64bit dma mask (and
> > possibly set the hardware to 64bit dma mode needlessly).
> 
> Ok, in that case lets disable all PCI drivers which do this on IXP4xx
> then, because they obviously can't cope with the 64MB window that this
> platform has.
> 
> Clearly they need to be rewritten such that they can cope with this,
> irrespective of the fact that they've worked for ages with the current
> solution.

I didn't insist such (I wrote, "it's not a real proble"). 

As I wrote in another mail, we could make every architecutre have the own
dma_set_coherent_mask(). It's fine by me.

I simply wanted to know your opinions:

Looks like that the DMA API doesn't expect architectures to clip the
mask. It might be better to add the new API to set the dma mask in the
long term? (i.e. calling dma_set_mask twice is the best interface?)
It's better to forget it since it's only about one architecture (too
much change provides little benefit).
