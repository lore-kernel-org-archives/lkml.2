Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab1DHUrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:47:21 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56836 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944Ab1DHUrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:47:19 -0400
Subject: Re: [PATCH 2/2] print vmalloc() state after allocation failures
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <alpine.DEB.2.00.1104081337470.12689@chino.kir.corp.google.com>
References: <20110408202253.6D6D231C@kernel>
	 <20110408202255.9EE67DC9@kernel>
	 <alpine.DEB.2.00.1104081337470.12689@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 08 Apr 2011 13:47:14 -0700
Message-ID: <1302295634.7286.1146.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 13:39 -0700, David Rientjes wrote:
> On Fri, 8 Apr 2011, Dave Hansen wrote:
> > This patch will print out messages that look like this:
> > 
> > [   30.040774] bash: vmalloc failure allocating after 0 / 73728 bytes
> > 
> 
> Either the changelog or the patch is still wrong because the format of 
> this string is inconsistent.

Yeah, ya caught me. :)
> > diff -puN mm/vmalloc.c~vmalloc-warn mm/vmalloc.c
> > --- linux-2.6.git/mm/vmalloc.c~vmalloc-warn	2011-04-08 09:36:05.877020199 -0700
> > +++ linux-2.6.git-dave/mm/vmalloc.c	2011-04-08 09:38:00.373093593 -0700
> > @@ -1534,6 +1534,7 @@ static void *__vmalloc_node(unsigned lon
> >  static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> >  				 pgprot_t prot, int node, void *caller)
> >  {
> > +	int order = 0;
> 
> Unnecessary, we can continue to hardcode the 0, vmalloc isn't going to use 
> higher order allocs (it's there to avoid such things!).

The only reason I did that was to keep the printk from looking like
this:

> > +	nopage_warning(gfp_mask, 0,  "vmalloc: allocation failure, "
> > +			"allocated %ld of %ld bytes\n",
> > +			(area->nr_pages*PAGE_SIZE), area->size);

The order is pretty darn obvious in the direct allocator calls, but I
liked having it named where it wasn't as obvious.

> >  	struct page **pages;
> >  	unsigned int nr_pages, array_size, i;
> >  	gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
> > @@ -1560,11 +1561,12 @@ static void *__vmalloc_area_node(struct 
> >  
> >  	for (i = 0; i < area->nr_pages; i++) {
> >  		struct page *page;
> > +		gfp_t tmp_mask = gfp_mask | __GFP_NOWARN;
> 
> I think it would be better to just do away with this as well and just 
> hardwire the __GFP_NOWARN directly into the two allocation calls.

I did it because hard-wiring it takes the alloc_pages_node() one over 80
columns.  I figured if I was going to add a line, I might as well keep
it pretty.

-- Dave

