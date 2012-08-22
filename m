Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab2HVMaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 08:30:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13855 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab2HVMaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 08:30:04 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-76-5034d0cb1bb2
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Hiroshi Doyu'" <hdoyu@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, arnd@arndb.de, linux@arm.linux.org.uk,
        chunsang.jeong@linaro.org, "'Krishna Reddy'" <vdumpa@nvidia.com>,
        konrad.wilk@oracle.com, subashrp@gmail.com, minchan@kernel.org
References: <1345630830-9586-1-git-send-email-hdoyu@nvidia.com>
 <1345630830-9586-3-git-send-email-hdoyu@nvidia.com>
In-reply-to: <1345630830-9586-3-git-send-email-hdoyu@nvidia.com>
Subject: RE: [RFC 2/4] ARM: dma-mapping: IOMMU allocates pages from pool with
 GFP_ATOMIC
Date: Wed, 22 Aug 2012 14:29:47 +0200
Organization: SPRC
Message-id: <005a01cd8061$d58998c0$809cca40$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2AT9uuO/2txWXlSZq7YtMXoVumjgAEdNKw
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jAd3TF0wCDD4tFbS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZl5aWFzzlr7j+dzJ7A2MvTxcjJ4eEgIlEx/S3zBC2mMSFe+vZ
	uhi5OIQEFjFK7Hy3mwnCmcUk0dH4kx2kik3AUKLrbRdQFQeHiICqxNO5jCA1zAJHmCTuN/1h
	A6kREiiVWH58OpjNKeAg8WzDeRaQemGBKIn7U0NBwixAracfrAML8wsISUycpQAS5hVwkVh9
	9DkLhC0o8WPyPTCbWUBLYv3O40wQtrzE5jUgN3MA3awu8eivLkhYRMBIYu/yBqgSEYm7Dc9Z
	JzAKz0IyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODQfia9g3FV
	g8UhRgEORiUeXo8EkwAh1sSy4srcQ4wSHMxKIryPdgOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ
	8/L3GQYICaQnlqRmp6YWpBbBZJk4OKUaGD3s3cW0OfbNt5np4j47z9q1QfNvv47WFfEnM25M
	XDJ5c6TZ6gf302c/tIgK5vqZuum3TN3K4J2HK5+82XYpL9uvfHLNrIo/X8vZ3yye5f7i4UK2
	TRdWO72w4ltSUexWrbQvxipC/nON1JGbCeucj0wunhr2te3dG68pzIKquk7XlScpz5GcMVOJ
	pTgj0VCLuag4EQBTl61KaQIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wednesday, August 22, 2012 12:20 PM Hiroshi Doyu wrote:

> Makes use of the same atomic pool from DMA, and skips kernel page
> mapping which can involves sleep'able operation at allocating a kernel
> page table.
> 
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> ---
>  arch/arm/mm/dma-mapping.c |   22 ++++++++++++++++++----
>  1 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index aec0c06..9260107 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -1028,7 +1028,6 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t
> size,
>  	struct page **pages;
>  	int count = size >> PAGE_SHIFT;
>  	int array_size = count * sizeof(struct page *);
> -	int err;
> 
>  	if (array_size <= PAGE_SIZE)
>  		pages = kzalloc(array_size, gfp);
> @@ -1037,9 +1036,20 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t
> size,
>  	if (!pages)
>  		return NULL;
> 
> -	err = __alloc_fill_pages(&pages, count, gfp);
> -	if (err)
> -		goto error
> +	if (gfp & GFP_ATOMIC) {
> +		struct page *page;
> +		int i;
> +		void *addr = __alloc_from_pool(size, &page);
> +		if (!addr)
> +			goto err_out;
> +
> +		for (i = 0; i < count; i++)
> +			pages[i] = page + i;
> +	} else {
> +		int err = __alloc_fill_pages(&pages, count, gfp);
> +		if (err)
> +			goto error;
> +	}
> 
>  	return pages;
>  error:
> @@ -1055,6 +1065,10 @@ static int __iommu_free_buffer(struct device *dev, struct page **pages,
> size_t s
>  	int count = size >> PAGE_SHIFT;
>  	int array_size = count * sizeof(struct page *);
>  	int i;
> +
> +	if (__free_from_pool(page_address(pages[0]), size))
> +		return 0;

You leak memory here. pages array should be also freed.

> +
>  	for (i = 0; i < count; i++)
>  		if (pages[i])
>  			__free_pages(pages[i], 0);
> --
> 1.7.5.4


Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



