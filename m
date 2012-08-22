Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab2HVMxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 08:53:21 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18397 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab2HVMxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 08:53:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 22 Aug 2012 05:52:40 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "chunsang.jeong@linaro.org" <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "subashrp@gmail.com" <subashrp@gmail.com>,
        "minchan@kernel.org" <minchan@kernel.org>
Date: Wed, 22 Aug 2012 14:52:28 +0200
Subject: Re: [RFC 2/4] ARM: dma-mapping: IOMMU allocates pages from pool
 with GFP_ATOMIC
Thread-Topic: [RFC 2/4] ARM: dma-mapping: IOMMU allocates pages from pool
 with GFP_ATOMIC
Thread-Index: Ac2AZQDahdqmGf/JQJyv1KfuJ++hkQ==
Message-ID: <20120822.155228.1203479129187316092.hdoyu@nvidia.com>
References: <1345630830-9586-1-git-send-email-hdoyu@nvidia.com><1345630830-9586-3-git-send-email-hdoyu@nvidia.com><005a01cd8061$d58998c0$809cca40$%szyprowski@samsung.com>
In-Reply-To: <005a01cd8061$d58998c0$809cca40$%szyprowski@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marek Szyprowski <m.szyprowski@samsung.com> wrote @ Wed, 22 Aug 2012 14:29:47 +0200:

> Hello,
> 
> On Wednesday, August 22, 2012 12:20 PM Hiroshi Doyu wrote:
> 
> > Makes use of the same atomic pool from DMA, and skips kernel page
> > mapping which can involves sleep'able operation at allocating a kernel
> > page table.
> > 
> > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> > ---
> >  arch/arm/mm/dma-mapping.c |   22 ++++++++++++++++++----
> >  1 files changed, 18 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> > index aec0c06..9260107 100644
> > --- a/arch/arm/mm/dma-mapping.c
> > +++ b/arch/arm/mm/dma-mapping.c
> > @@ -1028,7 +1028,6 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t
> > size,
> >  	struct page **pages;
> >  	int count = size >> PAGE_SHIFT;
> >  	int array_size = count * sizeof(struct page *);
> > -	int err;
> > 
> >  	if (array_size <= PAGE_SIZE)
> >  		pages = kzalloc(array_size, gfp);
> > @@ -1037,9 +1036,20 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t
> > size,
> >  	if (!pages)
> >  		return NULL;
> > 
> > -	err = __alloc_fill_pages(&pages, count, gfp);
> > -	if (err)
> > -		goto error
> > +	if (gfp & GFP_ATOMIC) {
> > +		struct page *page;
> > +		int i;
> > +		void *addr = __alloc_from_pool(size, &page);
> > +		if (!addr)
> > +			goto err_out;
> > +
> > +		for (i = 0; i < count; i++)
> > +			pages[i] = page + i;
> > +	} else {
> > +		int err = __alloc_fill_pages(&pages, count, gfp);
> > +		if (err)
> > +			goto error;
> > +	}
> > 
> >  	return pages;
> >  error:
> > @@ -1055,6 +1065,10 @@ static int __iommu_free_buffer(struct device *dev, struct page **pages,
> > size_t s
> >  	int count = size >> PAGE_SHIFT;
> >  	int array_size = count * sizeof(struct page *);
> >  	int i;
> > +
> > +	if (__free_from_pool(page_address(pages[0]), size))
> > +		return 0;
> 
> You leak memory here. pages array should be also freed.

Right, I'll fix as below:

	Modified arch/arm/mm/dma-mapping.c
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 47c4978..4656c0f 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1121,11 +1121,12 @@ static int __iommu_free_buffer(struct device *dev, struct page **pages, size_t s
 	int i;
 
 	if (__free_from_pool(page_address(pages[0]), size))
-		return 0;
+		goto out;
 
 	for (i = 0; i < count; i++)
 		if (pages[i])
 			__free_pages(pages[i], 0);
+out:
 	if (array_size <= PAGE_SIZE)
 		kfree(pages);
 	else
