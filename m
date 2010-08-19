Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab0HSVy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 17:54:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:45479 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab0HSVy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 17:54:56 -0400
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: khc@pm.waw.pl, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100820021915C.fujita.tomonori@lab.ntt.co.jp>
References: <1282213882.22370.360.camel@pasglop>
	 <20100819234835Y.fujita.tomonori@lab.ntt.co.jp>
	 <m38w42sfvx.fsf@intrepid.localdomain>
	 <20100820021915C.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 07:54:28 +1000
Message-ID: <1282254868.22370.370.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> linux/device.h defines that it's the device dma mask.
> 
> Except for ARM, coherent_dma_mask represents the device dma mask.

That's just verbiage in a header file. Nobody cares. The point is, the
device DMA mask per-se is a completely useless piece of information, and
thus there is absolutely no point keeping it around there.

The only thing that matters is the intersection of all the masks on the
way to memory, which defines where memory can be allocated.

Now the mask thing itself might end up not being enough for ARM in the
long run, I wouldn't be surprised if we end up with busses that can DMA
to areas of memory that are not 0 based, but that's a discussion for
another day.

> We sometimes want to know the device dma mask. Moving to your
> definition means that we lose that information.

When ?

Cheers,
Ben.

> > This usually equals device's address space - only because CPU and
> > bridges next to it have wide (logical) address busses. It's not always
> > the case, though, and may be not the case on any arch.
> > 
> > We should make sure we got it right (including drivers), since any
> > reduction of the dma*mask would be irreversible (new masks would be
> > ANDed with the existing masks).
> > 
> > > I think that having the generic place for bus'
> > > dma mask would be better rather than architecture specific
> > > places.
> > 
> > Definitely, if possible. BTW the dmabounce (and equivalent code on other
> > archs, including probably swiotlb on x86-64) could probably be merged as
> > well. I don't know the internals very well, though. At least it may be
> > worth it looking at them.
> 
> btw, swiotlb is used by x86_64, ia64, and powerpc.
> 
> I'm sure that I can convert ARM to use it instead of dmabounce. But
> well, even a bug fix patch for dmabounce haven't been merged so I'm
> not sure that ARM people would accept such change.
> 
> http://marc.info/?l=linux-arm-kernel&m=128047064008554&w=2
> 
> 
> > > Adding a new API to set bus' dma mask would make sense too.
> > 
> > Not sure. Which bus? There could be many :-)
> > In practice - 64-bit PCIe -> 32-bit PCI -> 24-bit ISA - etc.
> > Or, like with IXP/PXA - 26-bit PCI -> 32-bit device.
> 
> Seems that we are not on the same page. As I said before, have you
> seen how POWERPC uses max_direct_dma_addr in dev_archdata struct? I
> was talking about moving it to the generic place and the API to set
> it.


