Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab2HXLwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 07:52:38 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6353 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab2HXLwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 07:52:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 24 Aug 2012 04:52:06 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
CC: "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "chunsang.jeong@linaro.org" <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        "subashrp@gmail.com" <subashrp@gmail.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "pullip.cho@samsung.com" <pullip.cho@samsung.com>
Date: Fri, 24 Aug 2012 13:52:00 +0200
Subject: Re: [v3 1/4] ARM: dma-mapping: atomic_pool with struct page **pages
Thread-Topic: [v3 1/4] ARM: dma-mapping: atomic_pool with struct page **pages
Thread-Index: Ac2B7t/Rw3DAj1KmRFC3t/i1MGI/Mg==
Message-ID: <20120824.145200.843951079622652894.hdoyu@nvidia.com>
References: <1345796945-21115-1-git-send-email-hdoyu@nvidia.com><1345796945-21115-2-git-send-email-hdoyu@nvidia.com><20120824111323.GB11007@konrad-lan.dumpdata.com>
In-Reply-To: <20120824111323.GB11007@konrad-lan.dumpdata.com>
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

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote @ Fri, 24 Aug 2012 13:13:23 +0200:

> On Fri, Aug 24, 2012 at 11:29:02AM +0300, Hiroshi Doyu wrote:
> > struct page **pages is necessary to align with non atomic path in
> > __iommu_get_pages(). atomic_pool() has the intialized **pages instead
> > of just *page.
> > 
> > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> > ---
> >  arch/arm/mm/dma-mapping.c |   17 +++++++++++++----
> >  1 files changed, 13 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> > index 601da7a..b14ee64 100644
> > --- a/arch/arm/mm/dma-mapping.c
> > +++ b/arch/arm/mm/dma-mapping.c
> > @@ -296,7 +296,7 @@ struct dma_pool {
> >  	unsigned long *bitmap;
> >  	unsigned long nr_pages;
> >  	void *vaddr;
> > -	struct page *page;
> > +	struct page **pages;
> >  };
> >  
> >  static struct dma_pool atomic_pool = {
> > @@ -335,12 +335,16 @@ static int __init atomic_pool_init(void)
> >  	unsigned long nr_pages = pool->size >> PAGE_SHIFT;
> >  	unsigned long *bitmap;
> >  	struct page *page;
> > +	struct page **pages;
> >  	void *ptr;
> >  	int bitmap_size = BITS_TO_LONGS(nr_pages) * sizeof(long);
> > +	size_t size = nr_pages * sizeof(struct page *);
> >  
> > -	bitmap = kzalloc(bitmap_size, GFP_KERNEL);
> > +	size += bitmap_size;
> > +	bitmap = kzalloc(size, GFP_KERNEL);
> >  	if (!bitmap)
> >  		goto no_bitmap;
> > +	pages = (void *)bitmap + bitmap_size;
> 
> So you stuck a bitmap field in front of the array then?
> Why not just define a structure where this is clearly defined
> instead of doing the casting.

I just wanted to allocate only once for the members "pool->bitmap" and
"pool->pages" at once. Since the size of a whole bitmap isn't known in
advance, I couldn't find any fixed type for this bitmap, which pointer
can be shifted without casting. IOW, they are variable length.
