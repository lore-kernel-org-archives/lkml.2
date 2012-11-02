Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab2KBQWG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:22:06 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46018 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759187Ab2KBQWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:22:01 -0400
Date: Fri, 2 Nov 2012 12:21:57 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Alexander Duyck <alexander.duyck@gmail.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rob@landley.net,
        akpm@linux-foundation.org, joerg.roedel@amd.com, bhelgaas@google.com,
        shuahkhan@gmail.com, fujita.tomonori@lab.ntt.co.jp,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Alexander Duyck <alexander.h.duyck@intel.com>
Subject: Re: [PATCH v3 0/7] Improve swiotlb performance by using physical
 addresses
Message-ID: <20121102162156.GC4633@konrad-lan.dumpdata.com>
References: <20121015171707.25171.35294.stgit@gitlad.jf.intel.com>
 <CAKgT0UfG99tb29TOSQmDqnhy4uck5t+pjgeJnweqkV-EUuq3VA@mail.gmail.com>
 <20121029190555.GD2551@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029190555.GD2551@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 03:05:56PM -0400, Konrad Rzeszutek Wilk wrote:
> On Mon, Oct 29, 2012 at 11:18:09AM -0700, Alexander Duyck wrote:
> > On Mon, Oct 15, 2012 at 10:19 AM, Alexander Duyck
> > <alexander.h.duyck@intel.com> wrote:
> > > While working on 10Gb/s routing performance I found a significant amount of
> > > time was being spent in the swiotlb DMA handler. Further digging found that a
> > > significant amount of this was due to virtual to physical address translation
> > > and calling the function that did it. It accounted for nearly 60% of the
> > > total swiotlb overhead.
> > >
> > > This patch set works to resolve that by replacing the io_tlb_start and
> > > io_tlb_end virtual addresses with a physical addresses. In addition it changes
> > > the io_tlb_overflow_buffer from a virtual to a physical address. I followed
> > > through with the cleanup to the point that the only functions that really
> > > require the virtual address for the DMA buffer are the init, free, and
> > > bounce functions.
> > >
> > > In the case of devices that are using the bounce buffers these patches should
> > > result in only a slight performance gain if any. This is due to the locking
> > > overhead required to map and unmap the buffers.
> > >
> > > In the case of devices that are not making use of bounce buffers these patches
> > > can significantly reduce their overhead. In the case of an ixgbe routing test
> > > for example, these changes result in 7 fewer calls to __phys_addr and
> > > allow is_swiotlb_buffer to become inlined due to a reduction in the number of
> > > instructions. When running a routing throughput test using small packets I
> > > saw roughly a 6% increase in packets rates after applying these patches. This
> > > appears to match up with the CPU overhead reduction I was tracking via perf.
> > >
> > > Before:
> > > Results 10.0Mpps
> > >
> > > After:
> > > Results 10.6Mpps
> > >
> > > Finally, I updated the parameter names for several of the core function calls
> > > as there was some ambiguity in naming. Specifically virtual address pointers
> > > were named dma_addr. When I changed these pointers to physical I instead used
> > > the name tlb_addr as this value represented a physical address in the
> > > io_tlb_start region and is less likely to be confused with a bus address.
> > >
> > > v2:
> > > I reviewed the changes and realized that the first patch that was dropping
> > > io_tlb_end and calculating the value didn't actually gain me much once I had
> > > gone through and translated the rest of the addresses to physical addresses.
> > > As such I have updated the patch so that it instead is converting io_tlb_end
> > > from a virtual address to a physical address.  This actually helps to reduce
> > > the overhead for is_swiotlb_buffer and swiotlb_dma_supported by several
> > > instructions.
> > >
> > > v3:
> > > After reviewing the patches I realized I was causing some namespace pollution
> > > since a "static char *" was being replaced with "phys_addr_t" when it should
> > > have been "static phys_addr_t".  As such I have updated the first 3 patches to
> > > correctly replace static pointers with static physical addresses.
> > >
> > > ---
> > >
> > > Alexander Duyck (7):
> > >       swiotlb:  Do not export swiotlb_bounce since there are no external consumers
> > >       swiotlb: Use physical addresses instead of virtual in swiotlb_tbl_sync_single
> > >       swiotlb: Use physical addresses for swiotlb_tbl_unmap_single
> > >       swiotlb: Return physical addresses when calling swiotlb_tbl_map_single
> > >       swiotlb: Make io_tlb_overflow_buffer a physical address
> > >       swiotlb: Make io_tlb_start a physical address instead of a virtual one
> > >       swiotlb: Make io_tlb_end a physical address instead of a virtual one
> > >
> > >
> > >  drivers/xen/swiotlb-xen.c |   25 ++--
> > >  include/linux/swiotlb.h   |   20 ++-
> > >  lib/swiotlb.c             |  269 +++++++++++++++++++++++----------------------
> > >  3 files changed, 163 insertions(+), 151 deletions(-)
> > >
> > 
> > Is there any ETA on when this patch series might be pulled into a
> > tree?  I'm just wondering if I need to rebase this patch series and
> > resubmit it, and if so what tree I need to rebase it off of?
> 
> No need to rebase it. I did a test on V2 version with Xen, but I still
> need to do a IA64/Calgary/AMD Vi/Intel VT-d/GART test before
> pushing it out.

So you should your patches in linux-next.
> 
> > 
> > Thanks,
> > 
> > Alex
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
