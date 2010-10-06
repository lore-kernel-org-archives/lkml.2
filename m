Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692Ab0JFMiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 08:38:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:13260 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667Ab0JFMiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 08:38:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,290,1283756400"; 
   d="scan'208";a="613925106"
Date: Wed, 6 Oct 2010 20:37:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
        npiggin@kernel.dk, yanmin_zhang@linux.intel.com,
        "Shi, Alex" <alex.shi@intel.com>
Subject: Re: [UnifiedV4 00/16] The Unified slab allocator (V4)
Message-ID: <20101006123753.GA17674@localhost>
References: <20101005185725.088808842@linux.com>
 <AANLkTinPU4T59PvDH1wX2Rcy7beL=TvmHOZh_wWuBU-T@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinPU4T59PvDH1wX2Rcy7beL=TvmHOZh_wWuBU-T@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[add CC to Alex: he is now in charge of kernel performance tests]

On Wed, Oct 06, 2010 at 11:01:35AM +0300, Pekka Enberg wrote:
> (Adding more people who've taken interest in slab performance in the
> past to CC.)
> 
> On Tue, Oct 5, 2010 at 9:57 PM, Christoph Lameter <cl@linux.com> wrote:
> > V3->V4:
> > - Lots of debugging
> > - Performance optimizations (more would be good)...
> > - Drop per slab locking in favor of per node locking for
> >  partial lists (queuing implies freeing large amounts of objects
> >  to per node lists of slab).
> > - Implement object expiration via reclaim VM logic.
> >
> > The following is a release of an allocator based on SLAB
> > and SLUB that integrates the best approaches from both allocators. The
> > per cpu queuing is like in SLAB whereas much of the infrastructure
> > comes from SLUB.
> >
> > After this patches SLUB will track the cpu cache contents
> > like SLAB attemped to. There are a number of architectural differences:
> >
> > 1. SLUB accurately tracks cpu caches instead of assuming that there
> >   is only a single cpu cache per node or system.
> >
> > 2. SLUB object expiration is tied into the page reclaim logic. There
> >   is no periodic cache expiration.
> >
> > 3. SLUB caches are dynamically configurable via the sysfs filesystem.
> >
> > 4. There is no per slab page metadata structure to maintain (aside
> >   from the object bitmap that usually fits into the page struct).
> >
> > 5. Has all the resiliency and diagnostic features of SLUB.
> >
> > The unified allocator is a merging of SLUB with some queuing concepts from
> > SLAB and a new way of managing objects in the slabs using bitmaps. Memory
> > wise this is slightly more inefficient than SLUB (due to the need to place
> > large bitmaps --sized a few words--in some slab pages if there are more
> > than BITS_PER_LONG objects in a slab) but in general does not increase space
> > use too much.
> >
> > The SLAB scheme of not touching the object during management is adopted.
> > The unified allocator can efficiently free and allocate cache cold objects
> > without causing cache misses.
> >
> > Some numbers using tcp_rr on localhost
> >
> >
> > Dell R910 128G RAM, 64 processors, 4 NUMA nodes
> >
> > threads unified         slub            slab
> > 64      4141798         3729037         3884939
> > 128     4146587         3890993         4105276
> > 192     4003063         3876570         4110971
> > 256     3928857         3942806         4099249
> > 320     3922623         3969042         4093283
> > 384     3827603         4002833         4108420
> > 448     4140345         4027251         4118534
> > 512     4163741         4050130         4122644
> > 576     4175666         4099934         4149355
> > 640     4190332         4142570         4175618
> > 704     4198779         4173177         4193657
> > 768     4662216         4200462         4222686
> 
> Are there any stability problems left? Have you tried other benchmarks
> (e.g. hackbench, sysbench)? Can we merge the series in smaller
> batches? For example, if we leave out the NUMA parts in the first
> stage, do we expect to see performance regressions?
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
