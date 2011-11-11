Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab1KKOSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 09:18:25 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:7676 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab1KKOSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 09:18:23 -0500
X-SpamScore: -28
X-BigFish: VPS-28(zzc89bh936eK179dN1432N98dKzz1202hzz15d4Rz2dh668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LUI2EF-01-6CC-02
X-M-MSG: 
Date: Fri, 11 Nov 2011 15:18:08 +0100
From: Joerg Roedel <Joerg.Roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: Kai Huang <mail.kai.huang@gmail.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        <iommu@lists.linux-foundation.org>, <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        KyongHo Cho <pullip.cho@samsung.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 2/7] iommu/core: split mapping to page sizes as
 supported by the hardware
Message-ID: <20111111141807.GJ13213@amd.com>
References: <1318850846-16066-1-git-send-email-ohad@wizery.com>
 <1318850846-16066-3-git-send-email-ohad@wizery.com>
 <CANqQZNH1YRSgYRVxceicQ3szD=t7zeJjhJKEQ30PeKsxtj5V+A@mail.gmail.com>
 <1320938930.22195.17.camel@i7.infradead.org>
 <20111110170918.GE13213@amd.com>
 <1320953319.535.11.camel@i7.infradead.org>
 <20111111125837.GF13213@amd.com>
 <1321018048.2027.44.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1321018048.2027.44.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 01:27:28PM +0000, David Woodhouse wrote:
> On Fri, 2011-11-11 at 13:58 +0100, Joerg Roedel wrote:
> > For AMD IOMMU there is a feature called not-present cache. It says that
> > the IOMMU caches non-present entries as well and needs an IOTLB flush
> > when something is mapped (meant for software implementations of the
> > IOMMU).
> > So it can't be really taken out of the fast-path. But the IOMMU driver
> > can optimize the function so that it only flushes the IOTLB when there
> > was an unmap-call before. 
> 
> We have exactly the same situation with the Intel IOMMU (we call it
> 'Caching Mode') for the same reasons.
> 
> I'd be wary about making the IOMMU driver *track* whether there was an
> unmap call before — that seems like hard work and more cache contention,
> especially if the ->commit() call happens on a CPU other than the one
> that just did the unmap.

Well, the IOMMU driver does not need to track this globally or
per-IOMMU. It basically tracks it per-domain. This lowers the
cache-bouncing a bit.

> I'm also not sure exactly when you'd call the ->commit() function when
> the DMA API is being used, and which 'side' of that API the
> deferred-flush optimisations would live.

The commit function is called every time before one of the DMA-API
functions return.

> Would the optimisation be done on the generic side, only calling
> ->commit when it absolutely *has* to happen? (Or periodically after
> unmaps have happened to avoid entries hanging around for ever?)
> 
> Or would the optimisation be done in the IOMMU driver, thus turning the
> ->commit() function into more of a *hint*? You could add a 'simon_says'
> boolean argument to it, I suppose...?

The IOMMU driver can't do that because special knowledge about the
address allocator is needed. So it has to happen in the generic part.
Okay, that optimization does not really work with the ->commit() idea,
as I think about it. With the requirement to call commit() on the
map-side would result in too many flushes to happen.

So it may be better to just call it iommu_flush_tlb(domain) or
something. The user of the IOMMU-API can assume that the flush is only
necessary on the unmap-path. Stricter flushing rules need to be handled
in the IOMMU driver itself.

> > It is also an improvement over the current
> > situation where every iommu_unmap call results in a flush implicitly.
> > This pretty much a no-go for using IOMMU-API in DMA mapping at the
> > moment.
> 
> Right. That definitely needs to be handled. We just need to work out the
> (above and other) details.

Yes, I am convinced now that the commit() idea is not the right solution
:)
Some less generic semantics like a iommu_flush_tlb call-back would do
better with such an optimization.

> Certainly your concerns are valid, but I think we can cope with them
> fairly reasonably. If we *do* have large number of CPUs allocating for a
> given domain, we can move to a per-node rather than per-CPU allocator.
> And we can have dynamically sized allocation regions, so we aren't
> wasting too much space on unused bitmaps if you map just *one* page from
> each of your 4096 CPUs.

It also requires somewhat that the chunks are reasonably small. On a
typical small system the amount of allocated DMA memory is rather small
(GPUs are the exception, of course).

Btw, do you have numbers how much time is spent in spinlocks for
multi-node machines and the VT-d driver for some workloads? I remember
that I did this measurement some time ago on a 24 core AMD machine with
netperf on a 10GBit network card and the time spent spinning came out
at ~5%.
For 1Gbit network and disk-load it was around 0.5% on that machine.

> > How much lock contention will be lowered also depends on the work-load.
> > If dma-handles are frequently freed from another cpu than they were
> > allocated from the same problem re-appears.
> 
> The idea is that dma handles are *infrequently* freed, in batches. So
> we'll bounce the lock's cache line occasionally, but not all the time.

Hmm, btw, how does this batch-freeing works? Is the freeing done when
the address space is filled up or is another approach used?

> > But in the end we have to try it out and see what works best :)
> 
> Indeed. I'm just trying to work out if I should try to do the allocator
> thing purely inside the Intel code first, and then try to move it out
> and make it generic — or if I should start with making the DMA API work
> with a wrapper around the IOMMU API, with your ->commit() and other
> necessary changes. I think I'd prefer the latter, if we can work out how
> it should look.

I think it is the best to start with a generic DMA-mapping
implementation, benchmark it and then find the bottlenecks and try out
possible optimizations. In the beginning it is hard enough to come up
with an implementation that fits X86 and ARM at the same time. When this
is worked out we can continue to optimize :)


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

