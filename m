Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab2HBRK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:10:27 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:55185 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab2HBRK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:10:26 -0400
Date: Thu, 2 Aug 2012 19:10:19 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] slub: use free_page instead of put_page for freeing
 kmalloc allocation
Message-ID: <20120802171019.GA1239@cmpxchg.org>
References: <1343913065-14631-1-git-send-email-glommer@parallels.com>
 <alpine.DEB.2.00.1208020902390.23049@router.home>
 <20120802164203.GA30111@cmpxchg.org>
 <501AB013.1090607@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501AB013.1090607@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 08:51:31PM +0400, Glauber Costa wrote:
> On 08/02/2012 08:42 PM, Johannes Weiner wrote:
> > On Thu, Aug 02, 2012 at 09:06:41AM -0500, Christoph Lameter wrote:
> >> On Thu, 2 Aug 2012, Glauber Costa wrote:
> >>
> >>> diff --git a/mm/slub.c b/mm/slub.c
> >>> index e517d43..9ca4e20 100644
> >>> --- a/mm/slub.c
> >>> +++ b/mm/slub.c
> >>> @@ -3453,7 +3453,7 @@ void kfree(const void *x)
> >>>  	if (unlikely(!PageSlab(page))) {
> >>>  		BUG_ON(!PageCompound(page));
> >>>  		kmemleak_free(x);
> >>> -		put_page(page);
> >>> +		__free_pages(page, compound_order(page));
> >>
> >> Hmmm... put_page would have called put_compound_page(). which would have
> >> called the dtor function. dtor is set to __free_pages() ok which does
> >> mlock checks and verifies that the page is in a proper condition for
> >> freeing. Then it calls free_one_page().
> >>
> >> __free_pages() decrements the refcount and then calls __free_pages_ok().
> >>
> >> So we loose the checking and the dtor stuff with this patch. Guess that is
> >> ok?
> > 
> > The changelog is not correct, however.  People DO get pages underlying
> > slab objects and even free the slab objects before returning the page.
> > See recent fix:
> 
> Well, yes, in the sense that slab objects are page-backed.
> 
> The point is that a user of kmalloc/kfree should not treat a memory area
> as if it were a page, even if it is page-sized.

I whole-heartedly agree.  But it's hard to verify there aren't any
doing that.  And even though it's ugly to do, it's technically
working, no?  No longer supporting it would be a regression.

> If it is just the Changelog you are unhappy about, I can do another
> submission rewording it.

__free_pages still respects the refcount, so I think the Changelog is
not actually appropriate for the change you're making.  You're just
changing what Christoph outlined above, the compound page handling.
