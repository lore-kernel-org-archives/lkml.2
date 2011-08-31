Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1HaMTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 08:19:48 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:54250 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab1HaMTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 08:19:47 -0400
Date: Wed, 31 Aug 2011 08:02:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Pekka Paalanen <pq@iki.fi>
Cc: thellstrom@vmware.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bskeggs@redhat.com,
        j.glisse@redhat.com, thomas@shipmail.org, airlied@redhat.com,
        airlied@linux.ie, alexdeucher@gmail.com
Subject: Re: [PATCH 1/7] ttm/radeon/nouveau: Check the DMA address from TTM
 against known value.
Message-ID: <20110831120209.GB4297@dumpdata.com>
References: <1314758512-19285-1-git-send-email-konrad.wilk@oracle.com>
 <1314758512-19285-2-git-send-email-konrad.wilk@oracle.com>
 <20110831093329.1d948a92@farn.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110831093329.1d948a92@farn.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E5E22E5.0076:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 09:33:29AM +0300, Pekka Paalanen wrote:
> On Tue, 30 Aug 2011 22:41:46 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > . instead of checking against the DMA_ERROR_CODE value which is
> > per-platform specific. The zero value is a known invalid value
> > that the TTM layer sets on the dma_address array if it is not
> > used (ttm_tt_alloc_page_directory calls drm_calloc_large which
> > creates a page with GFP_ZERO).
> > 
> > We can't use pci_dma_mapping_error as that is IOMMU
> > specific (some check for a specific physical address, some
> > for ranges, some just do a check against zero).
> > 
> > Also update the comments in the header about the true state
> > of that parameter.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/gpu/drm/nouveau/nouveau_sgdma.c |    3 +--
> >  drivers/gpu/drm/radeon/radeon_gart.c    |    4 +---
> >  include/drm/ttm/ttm_page_alloc.h        |    4 ++--
> >  3 files changed, 4 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> > b/drivers/gpu/drm/nouveau/nouveau_sgdma.c index 82fad91..624e2db
> > 100644 --- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> > +++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
> > @@ -42,8 +42,7 @@ nouveau_sgdma_populate(struct ttm_backend *be,
> > unsigned long num_pages, 
> >  	nvbe->nr_pages = 0;
> >  	while (num_pages--) {
> > -		/* this code path isn't called and is incorrect
> > anyways */
> > -		if (0) { /*dma_addrs[nvbe->nr_pages] !=
> > DMA_ERROR_CODE)*/
> > +		if (dev->pdev, dma_addrs[nvbe->nr_pages] != 0) {
> 
> This is weird, do you mean && instead of a comma, or what?
> Or am I completely missing the comma operator semantics?

Earlier implementation had this:

if (!pci_dma_mapping_error(rdev->pdev, dma_addr[i])) {

And then I changed it to check just the dma_addrs[x] (as the
different IOMMUs would provide irregular values), but
this ',' is really weird - no idea how it actually even compiles.

It should have just been:

		if (dma_addrs[nvbe->nr_pages] != 0) {
> 
> >  			nvbe->pages[nvbe->nr_pages] =
> >  					dma_addrs[nvbe->nr_pages];
> >  		 	nvbe->ttm_alloced[nvbe->nr_pages] =
> > true; diff --git a/drivers/gpu/drm/radeon/radeon_gart.c
> > b/drivers/gpu/drm/radeon/radeon_gart.c index a533f52..41f7e51
> > 100644 --- a/drivers/gpu/drm/radeon/radeon_gart.c
> > +++ b/drivers/gpu/drm/radeon/radeon_gart.c
> > @@ -181,9 +181,7 @@ int radeon_gart_bind(struct radeon_device
> > *rdev, unsigned offset, p = t / (PAGE_SIZE /
> > RADEON_GPU_PAGE_SIZE); 
> >  	for (i = 0; i < pages; i++, p++) {
> > -		/* we reverted the patch using dma_addr in TTM
> > for now but this
> > -		 * code stops building on alpha so just comment
> > it out for now */
> > -		if (0) { /*dma_addr[i] != DMA_ERROR_CODE) */
> > +		if (rdev->pdev, dma_addr[i] != 0) {
> 
> The same question for this condition.

The same here. Reading
http://stackoverflow.com/questions/2087026/effect-of-using-a-comma-instead-of-a-semi-colon-in-c-and-c

says that it actually did the right thing (evaluated the last
thing) - but I am going to remove the pdev part.

Thanks for spotting this!
> 
> -- 
> Pekka Paalanen
> http://www.iki.fi/pq/
