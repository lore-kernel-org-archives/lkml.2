Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635Ab1I3OKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 10:10:23 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40270 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab1I3OKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 10:10:21 -0400
Date: Fri, 30 Sep 2011 10:09:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, j.glisse@redhat.com, thomas@shipmail.org,
        airlied@redhat.com, airlied@linux.ie, alexdeucher@gmail.com,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH] TTM DMA pool v1.8
Message-ID: <20110930140949.GA18905@phenom.oracle.com>
References: <1317328432-25620-1-git-send-email-konrad.wilk@oracle.com>
 <4E8568E8.1070800@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8568E8.1070800@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090201.4E85CDBD.00E3,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 08:59:52AM +0200, Thomas Hellstrom wrote:
> Konrad,
> 
> I'm really sorry for taking so long to review this.

That is OK. We all are busy - and it gave me some time to pretty
up the code even more.

> 
> I'd like to go through a couple of high-level things first before
> reviewing the coding itself.
> 
> The page_alloc_func structure looks nice, but I'd like to have it
> per ttm backend,

Meaning the 'struct ttm_backend_func' right?

> we would just need to make sure that the backend is alive when we
> alloc / free pages.
> The reason for this is that there may be backends that want to
> allocate dma memory running simultaneously with those who don't.

As in for some TTM manager use the non-DMA, and for other DMA
(is_dma32 is set?) Or say two cards - one that has the concept
of MMU and one that does not and both of them are readeon?

> When the backend fires up, it can determine whether to use DMA
> memory or not.

Or more of backends (and drivers) that do not have any concept
of MMU and just use framebuffers and such?

I think we would just have to stick in a pointer to the
appropiate 'struct ttm_page_alloc_func' (and the 'struct device')
in the 'struct ttm_backend_func'. And this would be done by
backend that would decided which one to use.

And the TTM could find out which page_alloc_func to use straight
from the ttm_backend_func and call that (along with the 'struct device'
also gathered from that structure). Rough idea (on top of the patches):

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index dd05db3..e7a0c3c 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -902,12 +902,12 @@ struct ttm_page_alloc_func ttm_page_alloc_default = {
 
 int ttm_get_pages(struct list_head *pages, int flags,
 		  enum ttm_caching_state cstate, unsigned count,
-		  dma_addr_t *dma_address, struct device *dev)
+		  dma_addr_t *dma_address, struct ttm_backend *be)
 {
-	if (ttm_page_alloc && ttm_page_alloc->get_pages)
-		return ttm_page_alloc->get_pages(pages, flags, cstate, count,
-						 dma_address, dev);
-	return -1;
+	if (be->page_backend && be->page_backend->get_pages)
+		return be->page_backend->get_pages(pages, flags, cstate, count,
+				     dma_address, be->dev);
+	return __ttm_get_pages(pages, flags, cstate, count, dma_address, NULL);
 }
 void ttm_put_pages(struct list_head *pages, unsigned page_count, int flags,
 		   enum ttm_caching_state cstate, dma_addr_t *dma_address,
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 0f5ce97..0d75213 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -111,7 +111,7 @@ static struct page *__ttm_tt_get_page(struct ttm_tt *ttm, int index)
 		INIT_LIST_HEAD(&h);
 
 		ret = ttm_get_pages(&h, ttm->page_flags, ttm->caching_state, 1,
-				    &ttm->dma_address[index], ttm->dev);
+				    &ttm->dma_address[index], ttm->be);
 
 		if (ret != 0)
 			return NULL;
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index 6509544..9729753 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -100,6 +100,18 @@ struct ttm_backend_func {
 	 * Destroy the backend.
 	 */
 	void (*destroy) (struct ttm_backend *backend);
+
+	/*
+	 * Pointer to the struct ttm_page_alloc_func this backend wants
+	 * to use.
+	 */
+	struct ttm_page_alloc_func *page_backend;
+
+	/*
+	 * The device that the ttm_page_alloc_func should use for this
+	 * backend.
+	 */
+	struct device *dev;
 };
 
 /**
> 
> This also eliminates the need for patch 3/9. and is in line with patch 8/9.

<nods> That would be " ttm: Pass in 'struct device' to TTM so it can do
DMA API on behalf of device." as now the driver would be responsible for
saving that.

And "ttm/tt: Move ttm_tt_set_page_caching implementation in TTM page pool code."
would still be there, except it would be done per ttm-backend. Well
by choosing which TTM page pool the TTM backend would use.

> 
> 2) Memory accounting: If the number DMA pages are limited in a way
> that the ttm memory global routines are not aware of. How do we
> handle memory accounting? (How do we avoid exhausting IOMMU space)?

Good question. Not entirely sure about that. I know that on
SWIOTLB there is no limit (as you do not use the bounce buffer)
but not sure about VT-D, AMD-VI, GART, or when there is no IOMMU.

Let me get back to you on that.

Granted, the code _only_ gets activated when we use SWIOTLB right
now so the answer is "no exhausting" currently. Either way let me
dig a bit deeper.

> 
> 3) Page swapping. Currently we just copy pages to shmem pages and
> then free device pages. In the future we'd probably like to insert
> non-dma pages directly into the swap cache. Is it possible to
> differentiate dma pages from pages that are directly insertable?

Yes. The TTM DMA pool keeps track of which pages belong to which
pool and will reject non-dma pages (or pages which belong to
a different pool). It is fairly easy to expose that check
so that the generic TTM code can make the proper distinction.

But also - once you free a device page ('cached') it gets freed.
The other pages (writecombine,  writeback, uncached) end up sitting
in a recycle pool to be used. This is believe how the current
TTM page code works right now (and this TTM DMA pool follows).

The swapping code back (so from swap to pool) does not seem to
distinguish it that much - it just allocates a new page - and
then copies from whatever was in the swap cache?

This is something you were thinking to do in the future I presume?
