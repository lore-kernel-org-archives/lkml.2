Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab1BBMnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 07:43:47 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:42952 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab1BBMnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 07:43:45 -0500
Date: Wed, 2 Feb 2011 18:13:33 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mel@csn.ul.ie>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCHv8 07/12] mm: cma: Contiguous Memory Allocator added
Message-ID: <20110202124333.GB26396@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <cover.1292443200.git.m.nazarewicz@samsung.com>
 <eb8f43235c8ff2816ada7b56ffe371ea6140cae8.1292443200.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb8f43235c8ff2816ada7b56ffe371ea6140cae8.1292443200.git.m.nazarewicz@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Wed, Dec 15, 2010 at 09:34:27PM +0100, Michal Nazarewicz wrote:
> The Contiguous Memory Allocator is a set of functions that lets
> one initialise a region of memory which then can be used to perform
> allocations of contiguous memory chunks from.
> 
> CMA allows for creation of private and non-private contexts.
> The former is reserved for CMA and no other kernel subsystem can
> use it.  The latter allows for movable pages to be allocated within
> CMA's managed memory so that it can be used for page cache when
> CMA devices do not use it.
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> 

<snip>

> +/************************* Initialise CMA *************************/
> +
> +unsigned long cma_reserve(unsigned long start, unsigned long size,
> +			  unsigned long alignment)
> +{
> +	pr_debug("%s(%p+%p/%p)\n", __func__, (void *)start, (void *)size,
> +		 (void *)alignment);
> +
> +	/* Sanity checks */
> +	if (!size || (alignment & (alignment - 1)))
> +		return (unsigned long)-EINVAL;
> +
> +	/* Sanitise input arguments */
> +	start = PAGE_ALIGN(start);
> +	size  = PAGE_ALIGN(size);
> +	if (alignment < PAGE_SIZE)
> +		alignment = PAGE_SIZE;
> +
> +	/* Reserve memory */
> +	if (start) {
> +		if (memblock_is_region_reserved(start, size) ||
> +		    memblock_reserve(start, size) < 0)
> +			return (unsigned long)-EBUSY;
> +	} else {
> +		/*
> +		 * Use __memblock_alloc_base() since
> +		 * memblock_alloc_base() panic()s.
> +		 */
> +		u64 addr = __memblock_alloc_base(size, alignment, 0);
> +		if (!addr) {
> +			return (unsigned long)-ENOMEM;
> +		} else if (addr + size > ~(unsigned long)0) {
> +			memblock_free(addr, size);
> +			return (unsigned long)-EOVERFLOW;
> +		} else {
> +			start = addr;
> +		}
> +	}
> +

Reserving the areas of memory belonging to CMA using memblock_reserve,
would preclude that range from the zones, due to which it would not be
available for buddy allocations right ?

> +	return start;
> +}
> +
> +

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs,
Bangalore, India
