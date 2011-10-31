Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933743Ab1JaKjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 06:39:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37086 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab1JaKjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 06:39:35 -0400
Date: Mon, 31 Oct 2011 10:36:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@nvidia.com>
Cc: Marc Singer <elf@buici.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Sumit Bhattacharya <sumitb@nvidia.com>
Subject: Re: [RFC PATCH] arm: dma: Drop GFP_COMP for DMA memory allocations
Message-ID: <20111031103610.GG19187@n2100.arm.linux.org.uk>
References: <1319836732-31687-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319836732-31687-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 03:18:52PM -0600, Stephen Warren wrote:
> I believe the patch below was once posted to solve this for ARM, but never
> got picked up. Evidently, AVR32 did pick it up. I'm wondering if we should
> pick this up for ARM now, or if there's some other solution?

Well, Nick did talk about a solution using GFP_USERMAP in one of those
threads, which doesn't seem to have gone anywhere.  So I guess we need
this patch.

> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 82a093c..93b86e6 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -308,6 +308,13 @@ __dma_alloc(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp,
>  	struct page *page;
>  	void *addr;
>  
> +	/* Following is a work-around (a.k.a. hack) to prevent pages
> +	 * with __GFP_COMP being passed to split_page() which cannot
> +	 * handle them.  The real problem is that this flag probably
> +	 * should be 0 on ARM as it is not supported on this
> +	 * platform--see CONFIG_HUGETLB_PAGE. */

I don't think this comment makes sense anymore - HUGETLB_PAGE doesn't
have any help text.

> +	gfp &= ~(__GFP_COMP);
> +
>  	*handle = ~0;
>  	size = PAGE_ALIGN(size);
>  
> -- 
> 1.7.0.4
> 
> 
