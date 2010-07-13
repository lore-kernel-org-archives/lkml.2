Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab0GMKAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 06:00:52 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53191 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627Ab0GMKAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 06:00:51 -0400
Date: Tue, 13 Jul 2010 11:00:34 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Minchan Kim <minchan.kim@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, Yakui Zhao <yakui.zhao@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] Tight check of pfn_valid on sparsemem
Message-ID: <20100713100034.GF29885@csn.ul.ie>
References: <20100712155348.GA2815@barrios-desktop> <20100713093700.GD29885@csn.ul.ie> <20100713094612.GF20590@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100713094612.GF20590@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 10:46:12AM +0100, Russell King - ARM Linux wrote:
> On Tue, Jul 13, 2010 at 10:37:00AM +0100, Mel Gorman wrote:
> > I prefer Kamezawa's suggestion of mapping on a ZERO_PAGE-like page full
> > of PageReserved struct pages because it would have better performance
> > and be more in line with maintaining the assumptions of the memory
> > model. If we go in this direction, I would strongly prefer it was an
> > ARM-only thing.
> 
> As I've said, this is not possible without doing some serious page
> manipulation.
> 

Yep, x86 used to do something like this for discontig. It wasn't pretty.

> Plus the pages that where there become unusable as they don't correspond
> with a PFN or obey phys_to_virt().  So there's absolutely no point to
> this.
> 
> Now, why do we free the holes in the mem_map - because these holes can
> be extremely large.  Every 512K of hole equates to one page of mem_map
> array.

Sure, the holes might be large but at least they are contiguous. Is
there ever a case where you have

512K_Valid 512K_Hole 512K_Valid 512K_Hole

or is it typically

512K_hole 512K_hole ...... 512K_Valid 512K_Valid etc

If holes are typically contiguos, memmap is not allocated in the first place
and the savings from punching holes in memmap in the latter configuration
are minimal.

I recognise if you have a 2M section with a hole in it, you are
potentially wasting 3 pages on unused memmap. If this is really a problem,
Minchan's modification to sparsemem to increase the size of mem_section on
CONFIG_ARCH_HAS_HOLES_MEMORYMODEL is a messy option. I say messy because
it only works if the hole is on either end of the section and it's adding
quirks to the memory model.

>  Balance that against memory placed at 0xc0000000 physical on
> some platforms, and with PHYSMEM_BITS at 32 and SECTION_SIZE_BITS at
> 19 - well, you do the maths.  The result is certainly not pretty.
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
