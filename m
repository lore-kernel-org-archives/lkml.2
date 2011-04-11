Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab1DKWXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 18:23:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756250Ab1DKWXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 18:23:33 -0400
Date: Mon, 11 Apr 2011 15:22:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@freescale.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, Michal Nazarewicz <mina86@mina86.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/3] make new alloc_pages_exact()
Message-Id: <20110411152223.3fb91a62.akpm@linux-foundation.org>
In-Reply-To: <20110411220346.2FED5787@kernel>
References: <20110411220345.9B95067C@kernel>
	<20110411220346.2FED5787@kernel>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011 15:03:46 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> 
> What I really wanted in the end was a highmem-capable alloc_pages_exact(),
> so here it is.  This function can be used to allocate unmapped (like
> highmem) non-power-of-two-sized areas of memory.  This is in constast to
> get_free_pages_exact() which can only allocate from lowmem.
> 
> My plan is to use this in the virtio_balloon driver to allocate large,
> oddly-sized contiguous areas.
> 
> The new __alloc_pages_exact() now takes a size in numbers of pages,
> and returns a 'struct page', which means it can now address highmem.
> 
> It's a bit unfortunate that this introduces __free_pages_exact()
> alongside free_pages_exact().  But that mess already exists with
> __free_pages() vs. free_pages_exact().  So, at worst, this mirrors
> the mess that we already have.
> 
> I'm also a bit worried that I've not put in something named
> alloc_pages_exact(), but that behaves differently than it did before this
> set.  I got all of the in-tree cases, but I'm a bit worried about
> stragglers elsewhere.  So, I'm calling this __alloc_pages_exact() for
> the moment.  We can take out the __ some day if it bothers people.

Yup, that's fair enough.

> Note that the __get_free_pages() has a !GFP_HIGHMEM check.  Now that
> we are using alloc_pages_exact() instead of __get_free_pages() for
> get_free_pages_exact(), we had to add a new check in
> get_free_pages_exact().
> 
> This has been compile and boot tested, and I checked that
> 
> 	echo 2 > /sys/kernel/profiling
> 
> still works, since it uses get_free_pages_exact().
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6.git-dave/include/linux/gfp.h |    4 +
>  linux-2.6.git-dave/mm/page_alloc.c     |   84 ++++++++++++++++++++++++---------
>  2 files changed, 67 insertions(+), 21 deletions(-)
> 
> diff -puN include/linux/gfp.h~make_new_alloc_pages_exact include/linux/gfp.h
> --- linux-2.6.git/include/linux/gfp.h~make_new_alloc_pages_exact	2011-04-11 15:01:17.165822836 -0700
> +++ linux-2.6.git-dave/include/linux/gfp.h	2011-04-11 15:01:17.177822831 -0700
> @@ -351,6 +351,10 @@ extern struct page *alloc_pages_vma(gfp_
>  extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
>  extern unsigned long get_zeroed_page(gfp_t gfp_mask);
>  
> +/* 'struct page' version */
> +struct page *__alloc_pages_exact(gfp_t gfp_mask, size_t size);
> +void __free_pages_exact(struct page *page, size_t size);

The declarations use "size", but the definitions use "nr_pages". 
"nr_pages" is way better.

Should it really be size_t?  size_t's units are "bytes", usually.

> -void *get_free_pages_exact(gfp_t gfp_mask, size_t size)
> +struct page *__alloc_pages_exact(gfp_t gfp_mask, size_t nr_pages)

Most allocation functions are of the form foo(size, gfp_t), but this
one has the args reversed.  Was there a reason for that?


>  {
> -	unsigned int order = get_order(size);
> -	unsigned long addr;
> +	unsigned int order = get_order(nr_pages * PAGE_SIZE);
> +	struct page *page;
>  
> -	addr = __get_free_pages(gfp_mask, order);
> -	if (addr) {
> -		unsigned long alloc_end = addr + (PAGE_SIZE << order);
> -		unsigned long used = addr + PAGE_ALIGN(size);
> +	page = alloc_pages(gfp_mask, order);
> +	if (page) {
> +		struct page *alloc_end = page + (1 << order);
> +		struct page *used = page + nr_pages;
>  
> -		split_page(virt_to_page((void *)addr), order);
> +		split_page(page, order);
>  		while (used < alloc_end) {
> -			free_page(used);
> -			used += PAGE_SIZE;
> +			__free_page(used);
> +			used++;
>  		}
>  	}
>  
> -	return (void *)addr;
> +	return page;
> +}
> +EXPORT_SYMBOL(__alloc_pages_exact);
> +
> +/**
> + * __free_pages_exact - release memory allocated via __alloc_pages_exact()
> + * @virt: the value returned by get_free_pages_exact.
> + * @nr_pages: size in pages, same value as passed to __alloc_pages_exact().
> + *
> + * Release the memory allocated by a previous call to __alloc_pages_exact().
> + */
> +void __free_pages_exact(struct page *page, size_t nr_pages)
> +{
> +	struct page *end = page + nr_pages;
> +
> +	while (page < end) {

Hand-optimised.  Old school.  Doesn't trust the compiler :)

> +		__free_page(page);
> +		page++;
> +	}
> +}
> +EXPORT_SYMBOL(__free_pages_exact);

Really, this function duplicates release_pages().  release_pages() is
big and fat and complex and is a crime against uniprocessor but it does
make some effort to reduce the spinlocking frequency and in many
situations, release_pages() will cause vastly less locked bus traffic
than your __free_pages_exact().  And who knows, smart use of
release_pages()'s "cold" hint may provide some benefits.


