Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab2AIKJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 05:09:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57502 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2AIKJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 05:09:04 -0500
Date: Mon, 9 Jan 2012 11:11:06 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        James Simmons <jsimmons@infradead.org>,
        Jerome Glisse <j.glisse@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC] Future TTM DMA direction
Message-ID: <20120109101105.GC3723@phenom.ffwll.local>
Mail-Followup-To: Thomas Hellstrom <thellstrom@vmware.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	James Simmons <jsimmons@infradead.org>,
	Jerome Glisse <j.glisse@gmail.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
References: <4F0AB558.3050902@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0AB558.3050902@vmware.com>
X-Operating-System: Linux phenom 3.2.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 10:37:28AM +0100, Thomas Hellstrom wrote:
> Hi!
> 
> When TTM was originally written, it was assumed that GPU apertures
> could address pages directly, and that the CPU could access those
> pages without explicit synchronization. The process of binding a
> page to a GPU translation table was a simple one-step operation, and
> we needed to worry about fragmentation in the GPU aperture only.
> 
> Now that we "sort of" support DMA memory there are three things I
> think are missing:
> 
> 1) We can't gracefully handle coherent DMA OOMs or coherent DMA
> (Including CMA) memory fragmentation leading to failed allocations.
> 2) We can't handle dynamic mapping of pages into and out of dma, and
> corresponding IOMMU space shortage or fragmentation, and CPU
> synchronization.
> 3) We have no straightforward way of moving pages between devices.
> 
> I think a reasonable way to support this is to make binding to a
> non-fixed (system page based) TTM memory type a two-step binding
> process, so that a TTM placement consists of (DMA_TYPE, MEMORY_TYPE)
> instead of only (MEMORY_TYPE).
> 
> In step 1) the bo is bound to a specific DMA type. These could be
> for example:
> (NONE, DYNAMIC, COHERENT, CMA), .... device dependent types could be
> allowed as well.
> In this step, we perform dma_sync_for_device, or allocate
> dma-specific pages maintaining LRU lists so that if we receive a DMA
> memory allocation OOM, we can unbind bo:s bound to the same DMA
> type. Standard graphics cards would then, for example, use the NONE
> DMA type when run on bare metal or COHERENT when run on Xen. A
> "COHERENT" OOM condition would then lead to eviction of another bo.
> (Note that DMA eviction might involve data copies and be costly, but
> still better than failing).
> Binding with the DYNAMIC memory type would mean that CPU accesses
> are disallowed, and that user-space CPU page mappings might need to
> be killed, with a corresponding sync_for_cpu if they are faulted in
> again (perhaps on a page-by-page basis). Any attempt to bo_kmap() a
> bo page bound to DYNAMIC DMA mapping should trigger a BUG.
> 
> In step 2) The bo is bound to the GPU in the same way it's done
> today. Evicting from DMA will of course also trigger an evict from
> GPU, but an evict from GPU will not trigger a DMA evict.
> 
> Making a bo "anonymous" and thus moveable between devices would then
> mean binding it to the "NONE" DMA type.
> 
> Comments, suggestions?

Well I think we need to solve outstanding issues in the dma_buf framework
first. Currently dma_buf isn't really up to par to handle coherency
between the cpu and devices and there's also not yet any way to handle dma
address space fragmentation/exhaustion.

I fear that if you jump ahead with improving the ttm support alone we
might end up with something incompatible to the stuff dma_buf eventually
will grow, resulting in decent amounts of wasted efforts.

Cc'ed a bunch of relevant lists to foster input from people.

For a starter you seem to want much more low-level integration with the
dma api than existing users commonly need. E.g. if I understand things
correctly drivers just call dma_alloc_coherent and the platform/board code
then decides whether the device needs a contigious allocation from cma or
whether something else is good, too (e.g. vmalloc for the cpu + iommu).
Another thing is that I think doing lru eviction in case of dma address
space exhaustion (or fragmentation) needs at least awereness of what's
going on in the upper layers. iommus are commonly shared between devices
and I presume that two ttm drivers sitting behind the same iommu and
fighting over it's resources can lead to some hilarious outcomes.

Cheers, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
