Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab1KJT2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 14:28:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:54371 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab1KJT2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 14:28:51 -0500
Message-ID: <1320953319.535.11.camel@i7.infradead.org>
Subject: Re: [PATCH v4 2/7] iommu/core: split mapping to page sizes as
 supported by the hardware
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <Joerg.Roedel@amd.com>
Cc: Kai Huang <mail.kai.huang@gmail.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        iommu@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        KyongHo Cho <pullip.cho@samsung.com>, kvm@vger.kernel.org
Date: Thu, 10 Nov 2011 19:28:39 +0000
In-Reply-To: <20111110170918.GE13213@amd.com>
References: <1318850846-16066-1-git-send-email-ohad@wizery.com>
	 <1318850846-16066-3-git-send-email-ohad@wizery.com>
	 <CANqQZNH1YRSgYRVxceicQ3szD=t7zeJjhJKEQ30PeKsxtj5V+A@mail.gmail.com>
	 <1320938930.22195.17.camel@i7.infradead.org>
	 <20111110170918.GE13213@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 18:09 +0100, Joerg Roedel wrote:
> The requirement for the DMA-API is, that the IOTLB must be consistent
> with existing mappings, and only with the parts that are really mapped.
> The unmapped parts are not important.
> 
> This allows nice optimizations like your 'batched unmap' on the Intel
> IOMMU driver side. The AMD IOMMU driver uses a round-robin bitmap
> allocator for the IO addresses which makes it very easy to flush certain
> IOTLB ranges only before they are reused.

... which implies that a mapping, once made, might *never* actually get
torn down until we loop and start reusing address space? That has
interesting security implications. Is it true even for devices which
have been assigned to a VM and then unassigned?

> >   - ... unless booted with 'intel_iommu=strict', in which case we do the
> >     unmap and IOTLB flush immediately before returning to the driver.
> 
> There is something similar on the AMD IOMMU side. There it is called
> unmap_flush.

OK, so that definitely wants consolidating into a generic option.

> >   - But the IOMMU API for virtualisation is different. In fact that
> >     doesn't seem to flush the IOTLB at all. Which is probably a bug.
> 
> Well, *current* requirement is, that the IOTLB is in sync with the
> page-table at every time. This is true for the iommu_map and especially
> for the iommu_unmap function. It means basically that the unmapped area
> needs to be flushed out of the IOTLBs before iommu_unmap returns.
> 
> Some time ago I proposed the iommu_commit() interface which changes
> these requirements. With this interface the requirement is that after a
> couple of map/unmap operations the IOMMU-API user has to call
> iommu_commit() to make these changes visible to the hardware (so mostly
> sync the IOTLBs). As discussed at that time this would make sense for
> the Intel and AMD IOMMU drivers.

I would *really* want to keep those off the fast path (thinking mostly
about DMA API here, since that's the performance issue). But as long as
we can achieve that, that's fine.

> > What is acceptable, though? That batched unmap is quite important for
> > performance, because it means that we don't have to bash on the hardware
> > and wait for a flush to complete in the fast path of network driver RX,
> > for example.
> 
> Have you considered a round-robin bitmap-allocator? It allows quite nice
> flushing behavior.

Yeah, I was just looking through the AMD code with a view to doing
something similar. I was thinking of using that technique *within* each
larger range allocated from the whole address space.

> > If we move to a model where we have a separate ->flush_iotlb() call, we
> > need to be careful that we still allow necessary optimisations to
> > happen.
> 
> With iommu_commit() this should be possible, still.
> 
> > I'm looking at fixing performance issues in the Intel IOMMU code, with
> > its virtual address space allocation (the rbtree-based one in iova.c
> > that nobody else uses, which has a single spinlock that *all* CPUs bash
> > on when they need to allocate).
> > 
> > The plan is, vaguely, to allocate large chunks of space to each CPU, and
> > then for each CPU to allocate from its own region first, thus ensuring
> > that the common case doesn't bounce locks between CPUs. It'll be rare
> > for one CPU to have to touch a subregion 'belonging' to another CPU, so
> > lock contention should be drastically reduced.
> 
> Thats an interesting issue. It exists on the AMD IOMMU side too, the
> bitmap-allocator runs in a per-domain spinlock which can get high
> contention. I am not sure how per-cpu chunks of the address space scale
> to large numbers of cpus, though, given that some devices only have a
> small address range that they can address.

I don't care about performance of broken hardware. If we have a single
*global* "subrange" for the <4GiB range of address space, that's
absolutely fine by me.

But also, it's not *so* much of an issue to divide the space up even
when it's limited. The idea was not to have it *strictly* per-CPU, but
just for a CPU to try allocating from "its own" subrange first, and then
fall back to allocating a new subrange, and *then* fall back to
allocating from subranges "belonging" to other CPUs. It's not that the
allocation from a subrange would be lockless — it's that the lock would
almost never leave the l1 cache of the CPU that *normally* uses that
subrange.

With batched unmaps, the CPU doing the unmap may end up taking the lock
occasionally, and bounce cache lines then. But it's infrequent enough
that it shouldn't be a performance problem.

> I have been thinking about some lockless algorithms for the
> bitmap-allocator. But the ideas are not finalized yet, so I still don't
> know if they will work out at all :)

As explained above, I wasn't going for lockless. I was going for
lock-contention-less. Or at least mostly :)

Do you think that approach sounds reasonable?

> The plan is to have a single DMA-API implementation for all IOMMU
> drivers (X86 and ARM) which just uses the IOMMU-API. But to make this
> performing reasonalbly well a few changes to the IOMMU-API are required.
> I already have some ideas which we can discuss if you want.

Yeah, that sounds useful.

-- 
dwmw2

