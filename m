Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab2EIIzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:55:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57076 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab2EIIzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:55:09 -0400
Date: Wed, 9 May 2012 10:56:13 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Hugh Dickins <hughd@google.com>
Cc: Stephane Marchesin <marcheu@chromium.org>, linux-kernel@vger.kernel.org,
        keithp@keithp.com, torvalds@linux-foundation.org,
        seanpaul@chromium.org, olofj@chromium.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
        Daniel Vetter <daniel@ffwll.ch>, Rob Clark <rob.clark@linaro.org>,
        dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] mm: Work around Intel SNB GTT bug with some physical
 pages.
Message-ID: <20120509085427.GA4963@phenom.ffwll.local>
Mail-Followup-To: Hugh Dickins <hughd@google.com>,
	Stephane Marchesin <marcheu@chromium.org>,
	linux-kernel@vger.kernel.org, keithp@keithp.com,
	torvalds@linux-foundation.org, seanpaul@chromium.org,
	olofj@chromium.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andi Kleen <andi@firstfloor.org>, Rob Clark <rob.clark@linaro.org>,
	dri-devel@lists.freedesktop.org,
	Chris Wilson <chris@chris-wilson.co.uk>
References: <1336432421-17972-1-git-send-email-marcheu@chromium.org>
 <alpine.LSU.2.00.1205081340080.4287@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1205081340080.4287@eggly.anvils>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 02:57:25PM -0700, Hugh Dickins wrote:
> On Mon, 7 May 2012, Stephane Marchesin wrote:
> 
> > While investing some Sandy Bridge rendering corruption, I found out
> > that all physical memory pages below 1MiB were returning garbage when
> > read through the GTT. This has been causing graphics corruption (when
> > it's used for textures, render targets and pixmaps) and GPU hangups
> > (when it's used for GPU batch buffers).
> > 
> > I talked with some people at Intel and they confirmed my findings,
> > and said that a couple of other random pages were also affected.
> > 
> > We could fix this problem by adding an e820 region preventing the
> > memory below 1 MiB to be used, but that prevents at least my machine
> > from booting. One could think that we should be able to fix it in
> > i915, but since the allocation is done by the backing shmem this is
> > not possible.
> > 
> > In the end, I came up with the ugly workaround of just leaking the
> > offending pages in shmem.c. I do realize it's truly ugly, but I'm
> > looking for a fix to the existing code, and am wondering if people on
> > this list have a better idea, short of rewriting i915_gem.c to
> > allocate its own pages directly.
> > 
> > Signed-off-by: Stephane Marchesin <marcheu@chromium.org>
> 
> Well done for discovering and pursuing this issue, but of course (as
> you know: you're trying to provoke us to better) your patch is revolting.
> 
> And not even enough: swapin readahead and swapoff can read back
> from swap into pages which the i915 will later turn out to dislike.
> 
> I do have a shmem.c patch coming up for gma500, which cannot use pages
> over 4GB; but that fits more reasonably with memory allocation policies,
> where we expect that anyone who can use a high page can use a lower as
> well, and there's already __GFP_DMA32 to set the limit.
> 
> Your limitation is at the opposite end, so that patch won't help you at
> all.  And I don't see how Andi's ZONE_DMA exclusion would work, without
> equal hackery to enable private zonelists, avoiding that convention.
> 
> i915 is not the only user of shmem, and x86 not the only architecture:
> we're not going to make everyone suffer for this.  Once the memory
> allocator gets down to giving you the low 1MB, my guess is that it's
> already short of memory, and liable to deadlock or OOM if you refuse
> and soak up every page it then gives you.  Even if i915 has to live
> with that possibility, we're not going to extend it to everyone else.
> 
> arch/x86/Kconfig has X86_RESERVE_LOW, default 64, range 4 640 (and
> I think we reserve all the memory range from 640kB to 1MB anyway).
> Would setting that to 640 allow you to boot, and avoid the i915
> problem on all but the odd five pages?  I'm not pretending that's
> an ideal solution at all (unless freeing initmem could release most
> of it on non-SandyBridge and non-i915 machines), but it would be
> useful to know if that does provide a stopgap solution.  If that
> does work, maybe we just mark the odd five PageReserved at startup.

Hm, as a stopgap measure to make Sandybridge gpus not die that sounds
pretty good. But we still need a more generic solution for the long-term,
see below

> Is there really no way this can be handled closer to the source of
> the problem, in the i915 driver itself?  I do not know the flow of
> control in i915 (and X) at all, but on the surface it seems that the
> problem only comes when you map these problematic pages into the GTT
> (if I'm even using the right terminology), and something (not shmem.c)
> actively has to do that.
> 
> Can't you check the pfn at that point, and if it's an unsuitable page,
> copy into a suitable page (perhaps allocated then, perhaps from a pool
> you primed earlier) and map that suitable page into the GTT instead?
> Maybe using page->private to link them if that helps.
> 
> So long as the page (or its shadow) is mapped into the GTT, I imagine
> it would be pinned, and not liable to be swapped out or otherwise
> interfered with by shmem.c.  And when you unmap it from GTT, copy
> back to the unsuitable shmem object page before unpinning.
> 
> I fully accept that I have very little understanding of GPU DRM GTT
> and i915, and this may be impossible or incoherent: but please, let's
> try to keep the strangeness where it belongs.  If necessary, we'll
> have add some kind of flag and callback from shmem.c to the driver;
> but I'd so much prefer to avoid that.

The copy stuff back&forth approach is pretty much what ttm uses atm: It
allocates suitable pages with whatever means it has (usually through the
dma api) and if the shrinker callback tells it that it's sitting on too
much memory, it copies stuff out to the shmem backing storage used by gem.

There are quite a few issues with that approach:
- We expose mmap to the shmem file directly to userspace in i915. We use
  these extensively on Sandybridge because there direct cpu access is
  coherent with what the gpu does. Original userspace would always tell
  the kernel when it's done writing through cpu mappings so that the
  kernel could ensure coherency (by clflushing + some magic memory
  controller flush on older platforms), but because snb is coherent, we've
  dropped that. So the kernel has no idea when it should copy stuff
  around.

- The problem that shmem allocates unsuitable pages ins't limited to hw
  issues on snb: We have random dma limits (like the 4G limit for gma500),
  newer intel gpus support large pages (64K), and they would be beneficial
  for some (video encode/decode related) workloads, with have crazy arm
  gpus that want to allocate pages from specific CMA pools (because it
  needs to spread video date over 2 buffer objects, both contigious but on
  different memory banks) and so on ...

- I don't like the copy stuff around, especially since that moves drm
  drivers further away from shmem and the swapout decisions of the vm. Atm
  it's ridiculously easy to oom a system when drm/i915 is sitting on too
  much shmem memory. Despite that there's tons of free swap around. One
  idea to fix that is to stop mlocking pages we use on the gpu and instead
  wire up the drm drivers into the shmem swapout path. The current
  shrinker approach we're using doesn't stand a chance against a busy gpu.

- A related problem is that sitting on a few hundred meg to a few gig of
  !GFP_MOVEABLE memory isn't really nice to nifty features like
  transparent hugepages and other cool stuff that recently popped up
  around page migration. Again I think we should work towards wiring up
  drm drivers into the shmfs migrate_page callback so that this works
  reliably.

ARM ppl with their crazy gpus suffer much more from this than x86/Intel,
so Rob Clark from Linaro has volunteered himself to look into a gemfs
(Chris Wilson from our team created such a beast for drm/i915 a while
back, but that one bitrotted a bit).

Cheers, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
