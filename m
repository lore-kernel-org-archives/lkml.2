Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab1DRPVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:21:42 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:47615 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab1DRPVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:21:34 -0400
Subject: Re: [PATCH 2/2] print vmalloc() state after allocation failures
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Michal Nazarewicz <mina86@mina86.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1104161702300.14788@chino.kir.corp.google.com>
References: <20110415170437.17E1AF36@kernel>
	 <20110415170438.D5C317D5@kernel> <op.vtzo4ejf3l0zgt@mnazarewicz-glaptop>
	 <1302889441.16562.3525.camel@nimitz>
	 <alpine.DEB.2.00.1104161702300.14788@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 18 Apr 2011 08:21:22 -0700
Message-ID: <1303140082.9615.2584.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-16 at 17:03 -0700, David Rientjes wrote:
> >  fail:
> > +     warn_alloc_failed(gfp_mask, order, "vmalloc: allocation failure, "
> > +                       "allocated %ld of %ld bytes\n",
> > +                       (area->nr_pages*PAGE_SIZE), area->size);
> >       vfree(area->addr);
> >       return NULL;
> >  }
> 
> Sorry, I still don't understand why this isn't just a three-liner patch to 
> call warn_alloc_failed().  I don't see the benefit of the "order" or 
> "tmp_mask" variables at all, they'll just be removed next time someone 
> goes down the mm/* directory and looks for variables that are used only 
> once or are unchanged as a cleanup. 

Without the "order" variable, we have:

	warn_alloc_failed(gfp_mask, 0, "vmalloc: allocation failure, "
		"allocated %ld of %ld bytes\n",
		(area->nr_pages*PAGE_SIZE), area->size);

I *HATE* those with a passion.  What is the '0' _doing_?  Is it for "0
pages", "do not print", "_do_ print"?  There's no way to tell without
going and finding warn_alloc_failed()'s definition.

With 'order' in there, the code self-documents, at least from the
caller's side.  It makes it 100% clear that the "0" being passed to the
allocators is that same as the one passed to the warning; it draws a
link between the allocations and the allocation error message:

	warn_alloc_failed(gfp_mask, order, "vmalloc: allocation failure, "
		"allocated %ld of %ld bytes\n",
		(area->nr_pages*PAGE_SIZE), area->size);

As for the 'tmp_mask' business.  Right now we have:

        for (i = 0; i < area->nr_pages; i++) {
                struct page *page;
+               gfp_t tmp_mask = gfp_mask | __GFP_NOWARN;

                if (node < 0)
-                       page = alloc_page(gfp_mask);
+                       page = alloc_page(tmp_mask);
                else
-                       page = alloc_pages_node(node, gfp_mask, 0);
+                       page = alloc_pages_node(node, tmp_mask, order);

The alternative is this:

        for (i = 0; i < area->nr_pages; i++) {
                struct page *page;

                if (node < 0)
-                       page = alloc_page(gfp_mask);
+                       page = alloc_page(gfp_mask | __GFP_NOWARN);
                else
-                       page = alloc_pages_node(node, gfp_mask, 0);
+                       page = alloc_pages_node(node, gfp_mask | __GFP_NOWARN,
+						order);

I can go look, but I bet the compiler compiles down to the same thing.
Plus, they're the same number of lines in the end.  I know which one
appeals to me visually.

I think we're pretty deep in personal preference territory here.  If I
hear a consensus that folks like it one way over another, I'm happy to
change it.

-- Dave

