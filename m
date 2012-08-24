Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328Ab2HXMWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 08:22:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31793 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2HXMWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 08:22:31 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-e4-503771dad4e9
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Hiroshi Doyu'" <hdoyu@nvidia.com>, konrad.wilk@oracle.com
Cc: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, arnd@arndb.de, linux@arm.linux.org.uk,
        chunsang.jeong@linaro.org, "'Krishna Reddy'" <vdumpa@nvidia.com>,
        subashrp@gmail.com, minchan@kernel.org, pullip.cho@samsung.com
References: <1345796945-21115-1-git-send-email-hdoyu@nvidia.com>
 <1345796945-21115-2-git-send-email-hdoyu@nvidia.com>
 <20120824111323.GB11007@konrad-lan.dumpdata.com>
 <20120824.145200.843951079622652894.hdoyu@nvidia.com>
In-reply-to: <20120824.145200.843951079622652894.hdoyu@nvidia.com>
Subject: RE: [v3 1/4] ARM: dma-mapping: atomic_pool with struct page **pages
Date: Fri, 24 Aug 2012 14:21:22 +0200
Organization: SPRC
Message-id: <026901cd81f2$fffea680$fffbf380$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2B7t/Rw3DAj1KmRFC3t/i1MGI/MgAA5/Lw
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t9jAd1bheYBBk+vCFhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mju9dbAVnhCqun53M2sC4l6+LkZNDQsBEYvqrhYwQtpjEhXvr
	2boYuTiEBBYxSjRc2sEE4cxiknh49TgzSBWbgKFE19suNhBbRMBWYuv+I2BFzAJHmCQOLVrG
	AtHxiFHi44c/7CBVnAJOEgcnfgDrFhbwkXj3vYEJxGYRUJXYfXU/axcjBwe/gJDExFkKICav
	gIvE38dSIBW8AoISPybfYwGxmQW0JNbvPM4EYctLbF7zlhmkXEJAXeLRX12Ic4wkpv66wQpR
	IiJxt+E56wRG4VlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc
	4M+kdzCuarA4xCjAwajEw7ujxSxAiDWxrLgy9xCjBAezkgivgJ95gBBvSmJlVWpRfnxRaU5q
	8SFGaQ4WJXFe/j7DACGB9MSS1OzU1ILUIpgsEwenVAOj2qWVyXaqGfvUk3LPxn8on/h6y+Zu
	NSmu+QIXXzlHnwuqWTu35EbOO+mFnwKzphmfvc1h8LNqviqbpm7z6pyCIFH2P30bDrw301mU
	KBUz8+kVn4ITCWfs6zfdWLo8RPsLT/tsvXCxTdHm7NO+r6oPDa048uTQpxKd1bxJ4ifUbISF
	IgTOMBxXYinOSDTUYi4qTgQApsqlsmwCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday, August 24, 2012 1:52 PM Hiroshi Doyu wrote:

> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote @ Fri, 24 Aug 2012 13:13:23 +0200:
> 
> > On Fri, Aug 24, 2012 at 11:29:02AM +0300, Hiroshi Doyu wrote:
> > > struct page **pages is necessary to align with non atomic path in
> > > __iommu_get_pages(). atomic_pool() has the intialized **pages instead
> > > of just *page.
> > >
> > > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> > > ---
> > >  arch/arm/mm/dma-mapping.c |   17 +++++++++++++----
> > >  1 files changed, 13 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> > > index 601da7a..b14ee64 100644
> > > --- a/arch/arm/mm/dma-mapping.c
> > > +++ b/arch/arm/mm/dma-mapping.c
> > > @@ -296,7 +296,7 @@ struct dma_pool {
> > >  	unsigned long *bitmap;
> > >  	unsigned long nr_pages;
> > >  	void *vaddr;
> > > -	struct page *page;
> > > +	struct page **pages;
> > >  };
> > >
> > >  static struct dma_pool atomic_pool = {
> > > @@ -335,12 +335,16 @@ static int __init atomic_pool_init(void)
> > >  	unsigned long nr_pages = pool->size >> PAGE_SHIFT;
> > >  	unsigned long *bitmap;
> > >  	struct page *page;
> > > +	struct page **pages;
> > >  	void *ptr;
> > >  	int bitmap_size = BITS_TO_LONGS(nr_pages) * sizeof(long);
> > > +	size_t size = nr_pages * sizeof(struct page *);
> > >
> > > -	bitmap = kzalloc(bitmap_size, GFP_KERNEL);
> > > +	size += bitmap_size;
> > > +	bitmap = kzalloc(size, GFP_KERNEL);
> > >  	if (!bitmap)
> > >  		goto no_bitmap;
> > > +	pages = (void *)bitmap + bitmap_size;
> >
> > So you stuck a bitmap field in front of the array then?
> > Why not just define a structure where this is clearly defined
> > instead of doing the casting.
> 
> I just wanted to allocate only once for the members "pool->bitmap" and
> "pool->pages" at once. Since the size of a whole bitmap isn't known in
> advance, I couldn't find any fixed type for this bitmap, which pointer
> can be shifted without casting. IOW, they are variable length.

IMHO it is better to avoid any non-trivial things in generic arch code. Merging
those 2 allocations doesn't save any significant bit of memory and might confuse
someone. Better just allocate them separately.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



