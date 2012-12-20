Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab2LTXfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 18:35:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2LTXf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 18:35:26 -0500
Date: Thu, 20 Dec 2012 15:35:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Nazarewicz <mpn@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] cma: use unsigned type for count argument
Message-Id: <20121220153525.97841100.akpm@linux-foundation.org>
In-Reply-To: <52fd3c7b677ff01f1cd6d54e38a567b463ec1294.1355938871.git.mina86@mina86.com>
References: <52fd3c7b677ff01f1cd6d54e38a567b463ec1294.1355938871.git.mina86@mina86.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012 18:44:40 +0100
Michal Nazarewicz <mpn@google.com> wrote:

> From: Michal Nazarewicz <mina86@mina86.com>
> 
> Specifying negative size of buffer makes no sense and thus this commit
> changes the type of the count argument to unsigned.
> 
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -1038,9 +1038,9 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t size,
>  					  gfp_t gfp, struct dma_attrs *attrs)
>  {
>  	struct page **pages;
> -	int count = size >> PAGE_SHIFT;
> -	int array_size = count * sizeof(struct page *);
> -	int i = 0;
> +	unsigned int count = size >> PAGE_SHIFT;
> +	unsigned int array_size = count * sizeof(struct page *);
> +	unsigned int i = 0;

C programmers expect a variable called `i' to have type `int'.  It
would be clearer to find a new name for this.  `idx', perhaps.

Also, we later do

	int j;
	..
	pages[i + j] ...

So `j' should also be converted to unsigned.  And perhaps renamed, but
`j' isn't as egregious as `i'.

>  	if (array_size <= PAGE_SIZE)
>  		pages = kzalloc(array_size, gfp);
> @@ -1102,9 +1102,9 @@ error:
>  static int __iommu_free_buffer(struct device *dev, struct page **pages,
>  			       size_t size, struct dma_attrs *attrs)
>  {
> -	int count = size >> PAGE_SHIFT;
> -	int array_size = count * sizeof(struct page *);
> -	int i;
> +	unsigned int count = size >> PAGE_SHIFT;
> +	unsigned int array_size = count * sizeof(struct page *);
> +	unsigned int i;

ditto.


--- a/arch/arm/mm/dma-mapping.c~cma-use-unsigned-type-for-count-argument-fix
+++ a/arch/arm/mm/dma-mapping.c
@@ -1040,7 +1040,7 @@ static struct page **__iommu_alloc_buffe
 	struct page **pages;
 	unsigned int count = size >> PAGE_SHIFT;
 	unsigned int array_size = count * sizeof(struct page *);
-	unsigned int i = 0;
+	unsigned int idx = 0;
 
 	if (array_size <= PAGE_SIZE)
 		pages = kzalloc(array_size, gfp);
@@ -1049,8 +1049,7 @@ static struct page **__iommu_alloc_buffe
 	if (!pages)
 		return NULL;
 
-	if (dma_get_attr(DMA_ATTR_FORCE_CONTIGUOUS, attrs))
-	{
+	if (dma_get_attr(DMA_ATTR_FORCE_CONTIGUOUS, attrs)) {
 		unsigned long order = get_order(size);
 		struct page *page;
 
@@ -1060,38 +1059,39 @@ static struct page **__iommu_alloc_buffe
 
 		__dma_clear_buffer(page, size);
 
-		for (i = 0; i < count; i++)
-			pages[i] = page + i;
+		for (idx = 0; idx < count; idx++)
+			pages[i] = page + idx;
 
 		return pages;
 	}
 
 	while (count) {
-		int j, order = __fls(count);
+		unsigned int j;
+		unnsigned int order = __fls(count);
 
-		pages[i] = alloc_pages(gfp | __GFP_NOWARN, order);
-		while (!pages[i] && order)
-			pages[i] = alloc_pages(gfp | __GFP_NOWARN, --order);
-		if (!pages[i])
+		pages[idx] = alloc_pages(gfp | __GFP_NOWARN, order);
+		while (!pages[idx] && order)
+			pages[idx] = alloc_pages(gfp | __GFP_NOWARN, --order);
+		if (!pages[idx])
 			goto error;
 
 		if (order) {
-			split_page(pages[i], order);
+			split_page(pages[idx], order);
 			j = 1 << order;
 			while (--j)
-				pages[i + j] = pages[i] + j;
+				pages[idx + j] = pages[idx] + j;
 		}
 
-		__dma_clear_buffer(pages[i], PAGE_SIZE << order);
-		i += 1 << order;
+		__dma_clear_buffer(pages[idx], PAGE_SIZE << order);
+		idx += 1 << order;
 		count -= 1 << order;
 	}
 
 	return pages;
 error:
-	while (i--)
-		if (pages[i])
-			__free_pages(pages[i], 0);
+	while (idx--)
+		if (pages[idx])
+			__free_pages(pages[idx], 0);
 	if (array_size <= PAGE_SIZE)
 		kfree(pages);
 	else
@@ -1104,14 +1104,15 @@ static int __iommu_free_buffer(struct de
 {
 	unsigned int count = size >> PAGE_SHIFT;
 	unsigned int array_size = count * sizeof(struct page *);
-	unsigned int i;
 
 	if (dma_get_attr(DMA_ATTR_FORCE_CONTIGUOUS, attrs)) {
 		dma_release_from_contiguous(dev, pages[0], count);
 	} else {
-		for (i = 0; i < count; i++)
-			if (pages[i])
-				__free_pages(pages[i], 0);
+		unsigned int idx;
+
+		for (idx = 0; idx < count; idx++)
+			if (pages[idx])
+				__free_pages(pages[idx], 0);
 	}
 
 	if (array_size <= PAGE_SIZE)
diff -puN drivers/base/dma-contiguous.c~cma-use-unsigned-type-for-count-argument-fix drivers/base/dma-contiguous.c
diff -puN include/linux/dma-contiguous.h~cma-use-unsigned-type-for-count-argument-fix include/linux/dma-contiguous.h
_

