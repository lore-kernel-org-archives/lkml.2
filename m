Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760514Ab1DPXtD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 19:49:03 -0400
Received: from smtp-out.google.com ([74.125.121.67]:15226 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1DPXsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 19:48:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=F7Uu8BExENFFm0bn7lTialYQCuzEILiBeCwjI+MlfUUu0VUBz5u05mqRkqpKlFXbVB
         N28EfDsutDIoPW1dpkpA==
Date: Sat, 16 Apr 2011 16:48:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: make read-only accessors take const parameters
In-Reply-To: <1302861377-8048-2-git-send-email-ext-phil.2.carmody@nokia.com>
Message-ID: <alpine.DEB.2.00.1104161609380.827@chino.kir.corp.google.com>
References: <1302861377-8048-1-git-send-email-ext-phil.2.carmody@nokia.com> <1302861377-8048-2-git-send-email-ext-phil.2.carmody@nokia.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011, Phil Carmody wrote:

> Pulling out bits from flags and atomic_read() do not modify
> anything, nor do we want to modify anything. We can extend that
> insight to clients. This makes static code analysis easier.
> 
> I'm not happy with the _ro bloat, but at least it doesn't change
> the size of the generated code. An alternative would be a type-
> less macro.
> 

The only advantage I can see by doing this is that functions calling these 
helpers can mark their struct page * formals or automatic variables with 
const as well.

That's only worthwhile if you have actual usecases where these newly-
converted helpers generate more efficient code as a result of being able 
to be marked const themselves.  If that's the case, then they should 
be proposed as an individual patch with both the caller and the helper 
being marked const at the same time.

It doesn't really matter that these helpers are all inline since the 
qualifiers will still be enforced at compile time.

> Also cleaned up some unnecessary (brackets).
> 

These cleanups can be pushed through the trivial tree if you're 
interested, email Jiri Kosina <trivial@kernel.org>.

> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> ---
>  include/linux/mm.h         |   27 +++++++++++++++++----------
>  include/linux/page-flags.h |    8 ++++----
>  2 files changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 692dbae..7134563 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -353,9 +353,16 @@ static inline struct page *compound_head(struct page *page)
>  	return page;
>  }
>  
> -static inline int page_count(struct page *page)
> +static inline const struct page *compound_head_ro(const struct page *page)
>  {
> -	return atomic_read(&compound_head(page)->_count);
> +	if (unlikely(PageTail(page)))
> +		return page->first_page;
> +	return page;
> +}
> +
> +static inline int page_count(const struct page *page)
> +{
> +	return atomic_read(&compound_head_ro(page)->_count);
>  }
>  
>  static inline void get_page(struct page *page)

Adding this excess code, however, is unnecessary since no caller of 
page_count() is optimized to use a const struct page * itself; if such an 
optimization actually exists, then it would need to be demonstrated with 
data before we'd want to add this extra function.

If you'd like to propose a patch for the remainder of the 
"struct page *" -> "const struct page *" changes in this email, then 
there's no downside and could potentially be useful in the future for 
callers, so you can add my

	Acked-by: David Rientjes <rientjes@google.com>

to such a patch.

 [ Please separate out the trivial changes by removing the brackets, 
   though, and submit them to Jiri instead. ]

> @@ -638,7 +645,7 @@ static inline pte_t maybe_mkwrite(pte_t pte, struct vm_area_struct *vma)
>  #define SECTIONS_MASK		((1UL << SECTIONS_WIDTH) - 1)
>  #define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
>  
> -static inline enum zone_type page_zonenum(struct page *page)
> +static inline enum zone_type page_zonenum(const struct page *page)
>  {
>  	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
>  }
> @@ -651,7 +658,7 @@ static inline enum zone_type page_zonenum(struct page *page)
>   * We guarantee only that it will return the same value for two
>   * combinable pages in a zone.
>   */
> -static inline int page_zone_id(struct page *page)
> +static inline int page_zone_id(const struct page *page)
>  {
>  	return (page->flags >> ZONEID_PGSHIFT) & ZONEID_MASK;
>  }
> @@ -786,7 +793,7 @@ static inline void *page_rmapping(struct page *page)
>  	return (void *)((unsigned long)page->mapping & ~PAGE_MAPPING_FLAGS);
>  }
>  
> -static inline int PageAnon(struct page *page)
> +static inline int PageAnon(const struct page *page)
>  {
>  	return ((unsigned long)page->mapping & PAGE_MAPPING_ANON) != 0;
>  }
> @@ -809,20 +816,20 @@ static inline pgoff_t page_index(struct page *page)
>   */
>  static inline void reset_page_mapcount(struct page *page)
>  {
> -	atomic_set(&(page)->_mapcount, -1);
> +	atomic_set(&page->_mapcount, -1);
>  }
>  
> -static inline int page_mapcount(struct page *page)
> +static inline int page_mapcount(const struct page *page)
>  {
> -	return atomic_read(&(page)->_mapcount) + 1;
> +	return atomic_read(&page->_mapcount) + 1;
>  }
>  
>  /*
>   * Return true if this page is mapped into pagetables.
>   */
> -static inline int page_mapped(struct page *page)
> +static inline int page_mapped(const struct page *page)
>  {
> -	return atomic_read(&(page)->_mapcount) >= 0;
> +	return atomic_read(&page->_mapcount) >= 0;
>  }
>  
>  /*
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 811183d..7f8e553 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -135,7 +135,7 @@ enum pageflags {
>   * Macros to create function definitions for page flags
>   */
>  #define TESTPAGEFLAG(uname, lname)					\
> -static inline int Page##uname(struct page *page) 			\
> +static inline int Page##uname(const struct page *page)			\
>  			{ return test_bit(PG_##lname, &page->flags); }
>  
>  #define SETPAGEFLAG(uname, lname)					\
> @@ -173,7 +173,7 @@ static inline int __TestClearPage##uname(struct page *page)		\
>  	__SETPAGEFLAG(uname, lname)  __CLEARPAGEFLAG(uname, lname)
>  
>  #define PAGEFLAG_FALSE(uname) 						\
> -static inline int Page##uname(struct page *page) 			\
> +static inline int Page##uname(const struct page *page)			\
>  			{ return 0; }
>  
>  #define TESTSCFLAG(uname, lname)					\
> @@ -345,7 +345,7 @@ static inline void set_page_writeback(struct page *page)
>  __PAGEFLAG(Head, head) CLEARPAGEFLAG(Head, head)
>  __PAGEFLAG(Tail, tail)
>  
> -static inline int PageCompound(struct page *page)
> +static inline int PageCompound(const struct page *page)
>  {
>  	return page->flags & ((1L << PG_head) | (1L << PG_tail));
>  
> @@ -379,7 +379,7 @@ __PAGEFLAG(Head, compound)
>   */
>  #define PG_head_tail_mask ((1L << PG_compound) | (1L << PG_reclaim))
>  
> -static inline int PageTail(struct page *page)
> +static inline int PageTail(const struct page *page)
>  {
>  	return ((page->flags & PG_head_tail_mask) == PG_head_tail_mask);
>  }
