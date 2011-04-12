Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab1DLPYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:24:37 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56746 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700Ab1DLPYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:24:30 -0400
Subject: Re: [PATCH 3/3] reuse __free_pages_exact() in __alloc_pages_exact()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@freescale.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
In-Reply-To: <op.vttl33xz3l0zgt@mnazarewicz-glaptop>
References: <20110411220345.9B95067C@kernel>
	 <20110411220348.D0280E4D@kernel>  <op.vttl33xz3l0zgt@mnazarewicz-glaptop>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 12 Apr 2011 08:24:24 -0700
Message-ID: <1302621864.8321.1856.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 12:29 +0200, Michal Nazarewicz wrote:
> On Tue, 12 Apr 2011 00:03:48 +0200, Dave Hansen <dave@linux.vnet.ibm.com>  
> wrote:
> > diff -puN mm/page_alloc.c~reuse-free-exact mm/page_alloc.c
> > --- linux-2.6.git/mm/page_alloc.c~reuse-free-exact	2011-04-11  
> > 15:01:17.701822598 -0700
> > +++ linux-2.6.git-dave/mm/page_alloc.c	2011-04-11 15:01:17.713822594  
> > -0700
> > @@ -2338,14 +2338,11 @@ struct page *__alloc_pages_exact(gfp_t g
> > 	page = alloc_pages(gfp_mask, order);
> >  	if (page) {
> > -		struct page *alloc_end = page + (1 << order);
> > -		struct page *used = page + nr_pages;
> > +		struct page *unused_start = page + nr_pages;
> > +		int nr_unused = (1 << order) - nr_pages;
> 
> How about unsigned long?

Personally, I'd rather leave this up to the poor sucker that tries to
set MAX_ORDER to 33.  If someone did that, we'd end up with kernels that
couldn't even boot on systems with less than 16GB of RAM since the
(required) flatmem mem_map[] would take up ~14.3GB.  They couldn't
handle memory holes and couldn't be NUMA-aware, either. 

So, if someone had a system like that, fixed up all the other spots
where we store numbers of pages in ints, and then did an 8TB+4k
allocation, yes, this would matter.  I'd rather save the 10 bytes of
source code and 4 bytes of stack than account for such an impossibly
improbable system.

-- Dave

