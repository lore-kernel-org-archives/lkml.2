Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760538Ab1DQAEE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 20:04:04 -0400
Received: from smtp-out.google.com ([74.125.121.67]:18212 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab1DQAD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 20:03:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ht5MuFSrARPNFIbjrb6G5WldEFR54wXhknkgDI2mYxnAlvYoUOhUS10DhtEVcih/YE
         LPvY6b0MbOtG3NhlSluw==
Date: Sat, 16 Apr 2011 17:03:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Michal Nazarewicz <mina86@mina86.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] print vmalloc() state after allocation failures
In-Reply-To: <1302889441.16562.3525.camel@nimitz>
Message-ID: <alpine.DEB.2.00.1104161702300.14788@chino.kir.corp.google.com>
References: <20110415170437.17E1AF36@kernel> <20110415170438.D5C317D5@kernel>  <op.vtzo4ejf3l0zgt@mnazarewicz-glaptop> <1302889441.16562.3525.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011, Dave Hansen wrote:

> diff -puN mm/vmalloc.c~vmalloc-warn mm/vmalloc.c
> --- linux-2.6.git/mm/vmalloc.c~vmalloc-warn	2011-04-15 10:39:05.928793559 -0700
> +++ linux-2.6.git-dave/mm/vmalloc.c	2011-04-15 10:39:18.716789177 -0700
> @@ -1534,6 +1534,7 @@ static void *__vmalloc_node(unsigned lon
>  static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  				 pgprot_t prot, int node, void *caller)
>  {
> +	const int order = 0;
>  	struct page **pages;
>  	unsigned int nr_pages, array_size, i;
>  	gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
> @@ -1560,11 +1561,12 @@ static void *__vmalloc_area_node(struct 
>  
>  	for (i = 0; i < area->nr_pages; i++) {
>  		struct page *page;
> +		gfp_t tmp_mask = gfp_mask | __GFP_NOWARN;
>  
>  		if (node < 0)
> -			page = alloc_page(gfp_mask);
> +			page = alloc_page(tmp_mask);
>  		else
> -			page = alloc_pages_node(node, gfp_mask, 0);
> +			page = alloc_pages_node(node, tmp_mask, order);
>  
>  		if (unlikely(!page)) {
>  			/* Successfully allocated i pages, free them in __vunmap() */
> @@ -1579,6 +1581,9 @@ static void *__vmalloc_area_node(struct 
>  	return area->addr;
>  
>  fail:
> +	warn_alloc_failed(gfp_mask, order, "vmalloc: allocation failure, "
> +			  "allocated %ld of %ld bytes\n",
> +			  (area->nr_pages*PAGE_SIZE), area->size);
>  	vfree(area->addr);
>  	return NULL;
>  }

Sorry, I still don't understand why this isn't just a three-liner patch to 
call warn_alloc_failed().  I don't see the benefit of the "order" or 
"tmp_mask" variables at all, they'll just be removed next time someone 
goes down the mm/* directory and looks for variables that are used only 
once or are unchanged as a cleanup.
