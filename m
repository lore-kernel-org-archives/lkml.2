Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2HBQmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:42:13 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:55171 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099Ab2HBQmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:42:12 -0400
Date: Thu, 2 Aug 2012 18:42:03 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Christoph Lameter <cl@linux.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] slub: use free_page instead of put_page for freeing
 kmalloc allocation
Message-ID: <20120802164203.GA30111@cmpxchg.org>
References: <1343913065-14631-1-git-send-email-glommer@parallels.com>
 <alpine.DEB.2.00.1208020902390.23049@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1208020902390.23049@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 09:06:41AM -0500, Christoph Lameter wrote:
> On Thu, 2 Aug 2012, Glauber Costa wrote:
> 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index e517d43..9ca4e20 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -3453,7 +3453,7 @@ void kfree(const void *x)
> >  	if (unlikely(!PageSlab(page))) {
> >  		BUG_ON(!PageCompound(page));
> >  		kmemleak_free(x);
> > -		put_page(page);
> > +		__free_pages(page, compound_order(page));
> 
> Hmmm... put_page would have called put_compound_page(). which would have
> called the dtor function. dtor is set to __free_pages() ok which does
> mlock checks and verifies that the page is in a proper condition for
> freeing. Then it calls free_one_page().
> 
> __free_pages() decrements the refcount and then calls __free_pages_ok().
> 
> So we loose the checking and the dtor stuff with this patch. Guess that is
> ok?

The changelog is not correct, however.  People DO get pages underlying
slab objects and even free the slab objects before returning the page.
See recent fix:

commit 5bf5f03c271907978489868a4c72aeb42b5127d2
Author: Pravin B Shelar <pshelar@nicira.com>
Date:   Tue May 29 15:06:49 2012 -0700

    mm: fix slab->page flags corruption
    
    Transparent huge pages can change page->flags (PG_compound_lock) without
    taking Slab lock.  Since THP can not break slab pages we can safely access
    compound page without taking compound lock.
    
    Specifically this patch fixes a race between compound_unlock() and slab
    functions which perform page-flags updates.  This can occur when
    get_page()/put_page() is called on a page from slab.
