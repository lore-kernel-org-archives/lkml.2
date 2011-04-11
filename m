Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab1DKWgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 18:36:12 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42644 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755356Ab1DKWgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 18:36:10 -0400
Subject: Re: [PATCH 2/3] make new alloc_pages_exact()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@freescale.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, Michal Nazarewicz <mina86@mina86.com>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <20110411152223.3fb91a62.akpm@linux-foundation.org>
References: <20110411220345.9B95067C@kernel>
	 <20110411220346.2FED5787@kernel>
	 <20110411152223.3fb91a62.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 11 Apr 2011 15:36:00 -0700
Message-ID: <1302561360.7286.16848.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 15:22 -0700, Andrew Morton wrote:
> > +/* 'struct page' version */
> > +struct page *__alloc_pages_exact(gfp_t gfp_mask, size_t size);
> > +void __free_pages_exact(struct page *page, size_t size);
> 
> The declarations use "size", but the definitions use "nr_pages". 
> "nr_pages" is way better.

I'll fix that.

> Should it really be size_t?  size_t's units are "bytes", usually.

Yeah, the nr_pages one should probably be an unsigned long.

> > -void *get_free_pages_exact(gfp_t gfp_mask, size_t size)
> > +struct page *__alloc_pages_exact(gfp_t gfp_mask, size_t nr_pages)
> 
> Most allocation functions are of the form foo(size, gfp_t), but this
> one has the args reversed.  Was there a reason for that?

I'm trying to make this a clone of alloc_pages(), which does:

	#define alloc_pages(gfp_mask, order)

It needs a note in the changelog on why I did it.

> >  {
> > -	unsigned int order = get_order(size);
> > -	unsigned long addr;
> > +	unsigned int order = get_order(nr_pages * PAGE_SIZE);
> > +	struct page *page;
> >  
> > -	addr = __get_free_pages(gfp_mask, order);
> > -	if (addr) {
> > -		unsigned long alloc_end = addr + (PAGE_SIZE << order);
> > -		unsigned long used = addr + PAGE_ALIGN(size);
> > +	page = alloc_pages(gfp_mask, order);
> > +	if (page) {
> > +		struct page *alloc_end = page + (1 << order);
> > +		struct page *used = page + nr_pages;
> >  
> > -		split_page(virt_to_page((void *)addr), order);
> > +		split_page(page, order);
> >  		while (used < alloc_end) {
> > -			free_page(used);
> > -			used += PAGE_SIZE;
> > +			__free_page(used);
> > +			used++;
> >  		}
> >  	}
> >  
> > -	return (void *)addr;
> > +	return page;
> > +}
> > +EXPORT_SYMBOL(__alloc_pages_exact);
> > +
> > +/**
> > + * __free_pages_exact - release memory allocated via __alloc_pages_exact()
> > + * @virt: the value returned by get_free_pages_exact.
> > + * @nr_pages: size in pages, same value as passed to __alloc_pages_exact().
> > + *
> > + * Release the memory allocated by a previous call to __alloc_pages_exact().
> > + */
> > +void __free_pages_exact(struct page *page, size_t nr_pages)
> > +{
> > +	struct page *end = page + nr_pages;
> > +
> > +	while (page < end) {
> 
> Hand-optimised.  Old school.  Doesn't trust the compiler :)

Hey, ask the dude who put free_pages_exact() in there! :)

> > +		__free_page(page);
> > +		page++;
> > +	}
> > +}
> > +EXPORT_SYMBOL(__free_pages_exact);
> 
> Really, this function duplicates release_pages().  release_pages() is
> big and fat and complex and is a crime against uniprocessor but it does
> make some effort to reduce the spinlocking frequency and in many
> situations, release_pages() will cause vastly less locked bus traffic
> than your __free_pages_exact().  And who knows, smart use of
> release_pages()'s "cold" hint may provide some benefits.

Seems like a decent enough thing to try.  I'll give it a shot and make
sure it's OK to use.

-- Dave

