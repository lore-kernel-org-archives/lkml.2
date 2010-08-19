Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0HSRU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 13:20:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:50391 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab0HSRU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 13:20:56 -0400
Date: Fri, 20 Aug 2010 02:20:33 +0900
To: khc@pm.waw.pl
Cc: fujita.tomonori@lab.ntt.co.jp, benh@kernel.crashing.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <m38w42sfvx.fsf@intrepid.localdomain>
References: <1282213882.22370.360.camel@pasglop>
	<20100819234835Y.fujita.tomonori@lab.ntt.co.jp>
	<m38w42sfvx.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100820021915C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 20 Aug 2010 02:20:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010 18:53:38 +0200
Krzysztof Halasa <khc@pm.waw.pl> wrote:

> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
> 
> >> I'd rather have the arch (aka the bus) be able to filter the mask,
> >> better than having to deal with multiple masks in the generic code.
> >> Besides, in embedded-land, you never know how many busses are stacked
> >> before you reach the device, ie, you'd end up having to AND quite a few
> >> masks before getting there in some cases.
> >
> > You mean that you like to permit architectures to modify
> > dev->coherent_dma_mask behind a device? If so, I'm against it because
> > it means dev->coherent_dma_mask has two meanings. That's confusing.
> 
> Well, I think it may be the only really correct solution, and in fact
> it's arch-independent.
> 
> The coherent_dma_mask would mean one thing: address space shared between
> the CPU(s) and the device.

linux/device.h defines that it's the device dma mask.

Except for ARM, coherent_dma_mask represents the device dma mask.

We sometimes want to know the device dma mask. Moving to your
definition means that we lose that information.


> This usually equals device's address space - only because CPU and
> bridges next to it have wide (logical) address busses. It's not always
> the case, though, and may be not the case on any arch.
> 
> We should make sure we got it right (including drivers), since any
> reduction of the dma*mask would be irreversible (new masks would be
> ANDed with the existing masks).
> 
> > I think that having the generic place for bus'
> > dma mask would be better rather than architecture specific
> > places.
> 
> Definitely, if possible. BTW the dmabounce (and equivalent code on other
> archs, including probably swiotlb on x86-64) could probably be merged as
> well. I don't know the internals very well, though. At least it may be
> worth it looking at them.

btw, swiotlb is used by x86_64, ia64, and powerpc.

I'm sure that I can convert ARM to use it instead of dmabounce. But
well, even a bug fix patch for dmabounce haven't been merged so I'm
not sure that ARM people would accept such change.

http://marc.info/?l=linux-arm-kernel&m=128047064008554&w=2


> > Adding a new API to set bus' dma mask would make sense too.
> 
> Not sure. Which bus? There could be many :-)
> In practice - 64-bit PCIe -> 32-bit PCI -> 24-bit ISA - etc.
> Or, like with IXP/PXA - 26-bit PCI -> 32-bit device.

Seems that we are not on the same page. As I said before, have you
seen how POWERPC uses max_direct_dma_addr in dev_archdata struct? I
was talking about moving it to the generic place and the API to set
it.
