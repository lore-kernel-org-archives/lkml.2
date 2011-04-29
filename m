Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab1D2Hf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 03:35:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:49135 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833Ab1D2Hf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 03:35:57 -0400
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Jerome Glisse <j.glisse@gmail.com>, linaro-mm-sig@lists.linaro.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <4DBA5194.7080609@vmware.com>
References: <201104212129.17013.arnd@arndb.de>
	 <201104281428.56780.arnd@arndb.de>
	 <20110428131531.GK17290@n2100.arm.linux.org.uk>
	 <201104281629.52863.arnd@arndb.de>
	 <20110428143440.GP17290@n2100.arm.linux.org.uk>
	 <BANLkTinhm7ar1mf1D-dSMiLtw5hRNY36RA@mail.gmail.com>
	 <1304036962.2513.202.camel@pasglop>  <4DBA5194.7080609@vmware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 17:35:23 +1000
Message-ID: <1304062523.2513.235.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I've been doing some thinking over the years on how we could extend that 
> functionality to other architectures. The reason we need those is 
> because some x86 processors (early AMDs and, I think VIA c3) dislike 
> multiple mappings of the same pages with conflicting caching attributes.
> 
> What we really want to be able to do is to unmap pages from the linear 
> kernel map, to avoid having to transition the linear kernel map every 
> time we change other mappings.
>
> The reason we need to do this in the first place is that AGP and modern 
> GPUs has a fast mode where snooping is turned off.

Right. Unfortunately, unmapping pages from the linear mapping is
precisely what I cannot give you on powerpc :-(

This is due to our tendency to map it using the largest page size
available. That translates to things like:

 - On hash based ppc64, I use 16M pages. I can't "break them up" due to
the limitation of the processor of having a single page size per segment
(and we use 1T segments nowadays). I could break the whole thing down to
4K but that would very seriously affect system performances.

 - On embedded, I map it using 1G pages. I suppose I could break it up
since it's SW loaded but here too, system performance would suffer. In
addition, we rely on ppc32 embedded to have the first 768M of the linear
mapping and on ppc64 embedded, the first 1G, mapped using bolted TLB
entries, which we can really only do using very large entries
(respectively 256M and 1G) that can't be broken up.
 
So you need to make sure whatever APIs you come up with will work on
architectures where memory -has- to be cachable and coherent and you
cannot play with the linear mapping. But that won't help with our
non-coherent embedded systems :-(

Maybe with future chips we'll have more flexibility here but not at this
point.

> However, we should be able to construct a completely generic api around 
> these operations, and for architectures that don't support them we need 
> to determine
> 
> a)  Whether we want to support them anyway (IIRC the problem with PPC is 
> that the linear kernel map has huge tlb entries that are very 
> inefficient to break up?)

Depends on the PPC variant / type of MMU. Inefficiency is part of the
problem. The need to have things bolted is another part. 4xx/BookE for
example needs to have lowmem bolted in the TLB. If it's broken up,
you'll quickly use up the TLB with bolted entries.

We could relax that to a certain extent until only the kernel
text/data/bss needs to be bolted, tho that would be at the expense of
performance of the TLB miss handlers which would have issues walking the
page tables. We'd also need to make sure we don't hand out to your API
the memory that is within the bolted entries that cover the kernel.

IE. If the kernel is large (32M ?) then the smallest entry I can use on
some CPUs will be 256M. So I'll need to have a way to allocate outside
of the first 256M. The linux allocators today don't allow for that sort
of restrictions.

> b)  Whether they are needed at all on the particular architecture. The 
> Intel x86 spec is, (according to AMD), supposed to forbid conflicting 
> caching attributes, but the Intel graphics guys use them for GEM. PPC 
> appears not to need it.

We have problems with AGP and macs, we chose to mostly ignore them and
things have been working so-so ... with the old DRM. With DRI2 being
much more aggressive at mapping/unmapping things, things became a lot
less stable and it could be in part related to that. IE. Aliases are
similarily forbidden but we create them anyways.

> c)  If neither of the above applies, we might be able to either use 
> explicit cache flushes (which will require a TTM cache sync API), or 
> require the device to use snooping mode. The architecture may also 
> perhaps have a pool of write-combined pages that we can use. This should 
> be indicated by defines in the api header.

Right. We should still shoot HW designers who give up coherency for the
sake of 3D benchmarks. It's insanely stupid.

Cheers,
Ben.

> /Thomas
> 
> 
> 
> 
> > _______________________________________________
> > Linaro-mm-sig mailing list
> > Linaro-mm-sig@lists.linaro.org
> > http://lists.linaro.org/mailman/listinfo/linaro-mm-sig
> >    


