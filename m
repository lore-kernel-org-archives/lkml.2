Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab1HLPAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 11:00:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51455 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab1HLPAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 11:00:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 8/9] ARM: integrate CMA with DMA-mapping subsystem
Date: Fri, 12 Aug 2011 17:00:30 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jesse Barker <jesse.barker@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
References: <1313146711-1767-1-git-send-email-m.szyprowski@samsung.com> <1313146711-1767-9-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1313146711-1767-9-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108121700.30967.arnd@arndb.de>
X-Provags-ID: V02:K0:l5BzZwMZ2wpv2tTtqZnNejbqS4ePxQu9q72SWj8q0E4
 XUJNUQ1Q54jLBxFOmD+SFDXoiOnu4hQTS/aIrbtzYyucbD66Ny
 b9k572Sm3EMsJRqDYy10SGVzxtfSprIxwkiSAISJq6vJUQQU/u
 F81F35AO3ZAAvbT+Dq94MCInrqHs0JH+2d+zXGKH08h3kFd0vv
 jDhkRFqiRSkxIAceeircw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 August 2011, Marek Szyprowski wrote:
> @@ -82,16 +103,16 @@ static struct page *__dma_alloc_buffer(struct device *dev, size_t size, gfp_t gf
>  	if (mask < 0xffffffffULL)
>  		gfp |= GFP_DMA;
>  
> -	page = alloc_pages(gfp, order);
> -	if (!page)
> -		return NULL;
> -
>  	/*
> -	 * Now split the huge page and free the excess pages
> +	 * Allocate contiguous memory
>  	 */
> -	split_page(page, order);
> -	for (p = page + (size >> PAGE_SHIFT), e = page + (1 << order); p < e; p++)
> -		__free_page(p);
> +	if (cma_available())
> +		page = dma_alloc_from_contiguous(dev, count, order);
> +	else
> +		page = __dma_alloc_system_pages(count, gfp, order);
> +
> +	if (!page)
> +		return NULL;

Why do you need the fallback here? I would assume that CMA now has to be available
on ARMv6 and up to work at all. When you allocate from __dma_alloc_system_pages(),
wouldn't that necessarily fail in the dma_remap_area() stage?

>  
> -	if (arch_is_coherent() || nommu()) {
> +	if (arch_is_coherent() || nommu() ||
> +	   (cma_available() && !(gfp & GFP_ATOMIC))) {
> +		/*
> +		 * Allocate from system or CMA pages
> +		 */
>  		struct page *page = __dma_alloc_buffer(dev, size, gfp);
>  		if (!page)
>  			return NULL;
> +		dma_remap_area(page, size, area->prot);
>  		pfn = page_to_pfn(page);
>  		ret = page_address(page);

Similarly with coherent and nommu. It seems to me that lumping too
many cases together creates extra complexity here.

How about something like

	if (arch_is_coherent() || nommu())
		ret = alloc_simple_buffer();
	else if (arch_is_v4_v5())
		ret = alloc_remap();
	else if (gfp & GFP_ATOMIC)
		ret = alloc_from_pool();
	else
		ret = alloc_from_contiguous();

This also allows a natural conversion to dma_map_ops when we get there.

>  	/* reserve any platform specific memblock areas */
>  	if (mdesc->reserve)
>  		mdesc->reserve();
>  
> +	dma_coherent_reserve();
> +	dma_contiguous_reserve();
> +
>  	memblock_analyze();
>  	memblock_dump_all();
>  }

Since we can handle most allocations using CMA on ARMv6+, I would think
that we can have a much smaller reserved area. Have you tried changing
dma_coherent_reserve() to allocate out of the contiguous area instead of
wasting a full 2MB section of memory?

	Arnd
