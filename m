Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab2EHV5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 17:57:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40593 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab2EHV5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 17:57:44 -0400
Date: Tue, 8 May 2012 14:57:25 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Stephane Marchesin <marcheu@chromium.org>
cc: linux-kernel@vger.kernel.org, keithp@keithp.com,
        torvalds@linux-foundation.org, seanpaul@chromium.org,
        olofj@chromium.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andi Kleen <andi@firstfloor.org>, Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <rob.clark@linaro.org>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] mm: Work around Intel SNB GTT bug with some physical
 pages.
In-Reply-To: <1336432421-17972-1-git-send-email-marcheu@chromium.org>
Message-ID: <alpine.LSU.2.00.1205081340080.4287@eggly.anvils>
References: <1336432421-17972-1-git-send-email-marcheu@chromium.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2012, Stephane Marchesin wrote:

> While investing some Sandy Bridge rendering corruption, I found out
> that all physical memory pages below 1MiB were returning garbage when
> read through the GTT. This has been causing graphics corruption (when
> it's used for textures, render targets and pixmaps) and GPU hangups
> (when it's used for GPU batch buffers).
> 
> I talked with some people at Intel and they confirmed my findings,
> and said that a couple of other random pages were also affected.
> 
> We could fix this problem by adding an e820 region preventing the
> memory below 1 MiB to be used, but that prevents at least my machine
> from booting. One could think that we should be able to fix it in
> i915, but since the allocation is done by the backing shmem this is
> not possible.
> 
> In the end, I came up with the ugly workaround of just leaking the
> offending pages in shmem.c. I do realize it's truly ugly, but I'm
> looking for a fix to the existing code, and am wondering if people on
> this list have a better idea, short of rewriting i915_gem.c to
> allocate its own pages directly.
> 
> Signed-off-by: Stephane Marchesin <marcheu@chromium.org>

Well done for discovering and pursuing this issue, but of course (as
you know: you're trying to provoke us to better) your patch is revolting.

And not even enough: swapin readahead and swapoff can read back
from swap into pages which the i915 will later turn out to dislike.

I do have a shmem.c patch coming up for gma500, which cannot use pages
over 4GB; but that fits more reasonably with memory allocation policies,
where we expect that anyone who can use a high page can use a lower as
well, and there's already __GFP_DMA32 to set the limit.

Your limitation is at the opposite end, so that patch won't help you at
all.  And I don't see how Andi's ZONE_DMA exclusion would work, without
equal hackery to enable private zonelists, avoiding that convention.

i915 is not the only user of shmem, and x86 not the only architecture:
we're not going to make everyone suffer for this.  Once the memory
allocator gets down to giving you the low 1MB, my guess is that it's
already short of memory, and liable to deadlock or OOM if you refuse
and soak up every page it then gives you.  Even if i915 has to live
with that possibility, we're not going to extend it to everyone else.

arch/x86/Kconfig has X86_RESERVE_LOW, default 64, range 4 640 (and
I think we reserve all the memory range from 640kB to 1MB anyway).
Would setting that to 640 allow you to boot, and avoid the i915
problem on all but the odd five pages?  I'm not pretending that's
an ideal solution at all (unless freeing initmem could release most
of it on non-SandyBridge and non-i915 machines), but it would be
useful to know if that does provide a stopgap solution.  If that
does work, maybe we just mark the odd five PageReserved at startup.

Is there really no way this can be handled closer to the source of
the problem, in the i915 driver itself?  I do not know the flow of
control in i915 (and X) at all, but on the surface it seems that the
problem only comes when you map these problematic pages into the GTT
(if I'm even using the right terminology), and something (not shmem.c)
actively has to do that.

Can't you check the pfn at that point, and if it's an unsuitable page,
copy into a suitable page (perhaps allocated then, perhaps from a pool
you primed earlier) and map that suitable page into the GTT instead?
Maybe using page->private to link them if that helps.

So long as the page (or its shadow) is mapped into the GTT, I imagine
it would be pinned, and not liable to be swapped out or otherwise
interfered with by shmem.c.  And when you unmap it from GTT, copy
back to the unsuitable shmem object page before unpinning.

I fully accept that I have very little understanding of GPU DRM GTT
and i915, and this may be impossible or incoherent: but please, let's
try to keep the strangeness where it belongs.  If necessary, we'll
have add some kind of flag and callback from shmem.c to the driver;
but I'd so much prefer to avoid that.

Hugh

> 
> Change-Id: I957e125fb280e0b0d6b05a83cc4068df2f05aa0a
> ---
>  mm/shmem.c |   39 +++++++++++++++++++++++++++++++++++++--
>  1 files changed, 37 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 6c253f7..dcbb58b 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -768,6 +768,31 @@ redirty:
>  	return 0;
>  }
>  
> +/*
> + * Some intel GPUs can't use those pages in the GTT, which results in
> + * graphics corruption. Sadly, it's impossible to prevent usage of those
> + * pages in the intel allocator.
> + *
> + * Instead, we test for those areas here and leak the corresponding pages.
> + *
> + * Some day, when the intel GPU memory is not backed by shmem any more,
> + * we'll be able to come up with a solution which is contained in i915.
> + */
> +static bool i915_usable_page(struct page *page)
> +{
> +	dma_addr_t addr = page_to_phys(page);
> +
> +	if (unlikely((addr < 1 * 1024 * 1024) ||
> +		(addr == 0x20050000) ||
> +		(addr == 0x20110000) ||
> +		(addr == 0x20130000) ||
> +		(addr == 0x20138000) ||
> +		(addr == 0x40004000)))
> +		return false;
> +
> +	return true;
> +}
> +
>  #ifdef CONFIG_NUMA
>  #ifdef CONFIG_TMPFS
>  static void shmem_show_mpol(struct seq_file *seq, struct mempolicy *mpol)
> @@ -816,6 +841,7 @@ static struct page *shmem_alloc_page(gfp_t gfp,
>  			struct shmem_inode_info *info, pgoff_t index)
>  {
>  	struct vm_area_struct pvma;
> +	struct page *page;
>  
>  	/* Create a pseudo vma that just contains the policy */
>  	pvma.vm_start = 0;
> @@ -826,7 +852,11 @@ static struct page *shmem_alloc_page(gfp_t gfp,
>  	/*
>  	 * alloc_page_vma() will drop the shared policy reference
>  	 */
> -	return alloc_page_vma(gfp, &pvma, 0);
> +	do {
> +		page = alloc_page_vma(gfp, &pvma, 0);
> +	} while (!i915_usable_page(page));
> +
> +	return page;
>  }
>  #else /* !CONFIG_NUMA */
>  #ifdef CONFIG_TMPFS
> @@ -844,7 +874,12 @@ static inline struct page *shmem_swapin(swp_entry_t swap, gfp_t gfp,
>  static inline struct page *shmem_alloc_page(gfp_t gfp,
>  			struct shmem_inode_info *info, pgoff_t index)
>  {
> -	return alloc_page(gfp);
> +	struct page *page;
> +	do {
> +		page = alloc_page(gfp);
> +	} while (!i915_usable_page(page));
> +
> +	return page;
>  }
>  #endif /* CONFIG_NUMA */
>  
> -- 
> 1.7.5.3.367.ga9930
