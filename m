Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab1DHNTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 09:19:53 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37590 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab1DHNTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 09:19:52 -0400
Subject: Re: [PATCH 2/2] make new alloc_pages_exact()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@freescale.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <op.vtmcx9kd3l0zgt@mnazarewicz-glaptop>
References: <20110407172104.1F8B7329@kernel>
	 <20110407172105.831B9A0A@kernel>  <op.vtmcx9kd3l0zgt@mnazarewicz-glaptop>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 08 Apr 2011 06:19:46 -0700
Message-ID: <1302268786.8184.6879.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 14:28 +0200, Michal Nazarewicz wrote:
> On Thu, 07 Apr 2011 19:21:05 +0200, Dave Hansen <dave@linux.vnet.ibm.com>  
> wrote:
> > +struct page *__alloc_pages_exact(gfp_t gfp_mask, size_t size)
> >  {
> >  	unsigned int order = get_order(size);
> > -	unsigned long addr;
> > +	struct page *page;
> > -	addr = __get_free_pages(gfp_mask, order);
> > -	if (addr) {
> > -		unsigned long alloc_end = addr + (PAGE_SIZE << order);
> > -		unsigned long used = addr + PAGE_ALIGN(size);
> > +	page = alloc_pages(gfp_mask, order);
> > +	if (page) {
> > +		struct page *alloc_end = page + (1 << order);
> > +		struct page *used = page + PAGE_ALIGN(size)/PAGE_SIZE;
> > -		split_page(virt_to_page((void *)addr), order);
> > +		split_page(page, order);
> >  		while (used < alloc_end) {
> > -			free_page(used);
> > -			used += PAGE_SIZE;
> > +			__free_page(used);
> > +			used++;
> >  		}
> 
> Have you thought about moving this loop to a separate function, ie.
> _free_page_range(start, end)?  I'm asking because this loop appears
> in two places and my CMA would also benefit from such a function.

Sounds like a good idea to me.  Were you thinking start/end 'struct
page's as arguments?

-- Dave

