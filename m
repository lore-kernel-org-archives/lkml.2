Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab2LUADf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 19:03:35 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:47738 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2LUAD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 19:03:28 -0500
Date: Thu, 20 Dec 2012 16:03:26 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michal Nazarewicz <mpn@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cma: use unsigned type for count argument
In-Reply-To: <20121220153525.97841100.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1212201557270.13223@chino.kir.corp.google.com>
References: <52fd3c7b677ff01f1cd6d54e38a567b463ec1294.1355938871.git.mina86@mina86.com> <20121220153525.97841100.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2012, Andrew Morton wrote:

> > Specifying negative size of buffer makes no sense and thus this commit
> > changes the type of the count argument to unsigned.
> > 
> > --- a/arch/arm/mm/dma-mapping.c
> > +++ b/arch/arm/mm/dma-mapping.c
> > @@ -1038,9 +1038,9 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t size,
> >  					  gfp_t gfp, struct dma_attrs *attrs)
> >  {
> >  	struct page **pages;
> > -	int count = size >> PAGE_SHIFT;
> > -	int array_size = count * sizeof(struct page *);
> > -	int i = 0;
> > +	unsigned int count = size >> PAGE_SHIFT;
> > +	unsigned int array_size = count * sizeof(struct page *);
> > +	unsigned int i = 0;
> 
> C programmers expect a variable called `i' to have type `int'.  It
> would be clearer to find a new name for this.  `idx', perhaps.
> 

I didn't ack this because there's no bounds checking on 
dma_alloc_from_contiguous() and bitmap_set() has a dangerous side-effect 
when called with an overflowed nr since it takes a signed argument.  
Marek, is there some sane upper bound we can put on count?

Additionally, I think at least this is needed for callers of bitmap_set() 
for some sanity (unless someone wants to audit the almost 100 callers and 
change it to unsigned as well).  There's probably additional nastiness in 
this library as well, I didn't check.
---
diff --git a/lib/bitmap.c b/lib/bitmap.c
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -287,7 +287,7 @@ void bitmap_set(unsigned long *map, int start, int nr)
 		mask_to_set = ~0UL;
 		p++;
 	}
-	if (nr) {
+	if (nr > 0) {
 		mask_to_set &= BITMAP_LAST_WORD_MASK(size);
 		*p |= mask_to_set;
 	}
