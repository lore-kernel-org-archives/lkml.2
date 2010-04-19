Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0DSQfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 12:35:12 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59646 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab0DSQfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 12:35:10 -0400
Date: Mon, 19 Apr 2010 17:34:48 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Peter Zijlstra <peterz@infradead.org>
Cc: r6144 <rainy6144@gmail.com>, linux-kernel@vger.kernel.org,
       Darren Hart <dvhltc@us.ibm.com>, tglx <tglx@linutronix.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: Process-shared futexes on hugepages puts the kernel in an
	infinite loop in 2.6.32.11; is this fixed now?
Message-ID: <20100419163448.GY19264@csn.ul.ie>
References: <1271432722.2564.16.camel@localhost.localdomain> <1271449668.1674.466.camel@laptop> <20100419114300.GT19264@csn.ul.ie> <1271677956.1674.922.camel@laptop> <20100419153245.GX19264@csn.ul.ie> <1271691905.1488.317.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1271691905.1488.317.camel@laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 05:45:05PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-04-19 at 16:32 +0100, Mel Gorman wrote:
> > Fix infinite loop in get_futex_key when backed by huge pages
> > 
> > If a futex key happens to be located within a huge page mapped MAP_PRIVATE,
> > get_futex_key() can go into an infinite loop waiting for a page->mapping
> > that will never exist. This was reported and documented in an external
> > bugzilla at
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=552257
> > 
> > This patch makes page->mapping a poisoned value that includes PAGE_MAPPING_ANON
> > mapped MAP_PRIVATE.  This is enough for futex to continue but because
> > of PAGE_MAPPING_ANON, the poisoned value is not dereferenced or used by
> > futex. No other part of the VM should be dereferencing the page->mapping of
> > a hugetlbfs page as its page cache is not on the LRU.
> > 
> > This patch fixes the problem with the test case described in the bugzilla.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > ---
> >  include/linux/poison.h |   10 ++++++++++
> >  mm/hugetlb.c           |    6 +++++-
> >  2 files changed, 15 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/poison.h b/include/linux/poison.h
> > index 2110a81..0f7b5ac 100644
> > --- a/include/linux/poison.h
> > +++ b/include/linux/poison.h
> > @@ -48,6 +48,16 @@
> >  #define POISON_FREE    0x6b    /* for use-after-free poisoning */
> >  #define        POISON_END      0xa5    /* end-byte of poisoning */
> >  
> > +/********** mm/hugetlb.c **********/
> > +/*
> > + * Private mappings of hugetlb pages use this poisoned value for
> > + * page->mapping. The core VM should not be doing anything with this mapping
> > + * but futex requires the existance of some page->mapping value even if it
> > + * is unused. If the core VM does deference the mapping, it'll look like a
> > + * suspiciously high null-pointer offset starting from 0x2e5
> > + */
> > +#define HUGETLB_PRIVATE_MAPPING        (0x2e4 | PAGE_MAPPING_ANON)
> 
> Wouldn't a longer poison be more recognisable? Also, shouldn't this use
> POISON_POINTER_DELTA?
> 

I was looking for an address < 0x1000 because it would only be valid in very
rare cases. I wasn't so sure about any other pointer value and only x86-64
appears to define POISON_POINTER_DELTA.

> Something like:
> 
> #define HUGETBL_POISON	((void *) 0x00300300 + POISON_POINTER_DELTA)
> 
> 0x2e5 isn't that high, I've had actual derefs in that range.
> 

So have I, but it couldn't be too near the page boundary either and pretty
much any address can be valid.  Still, architectures aren't stopped from
defining the delta and it is something we appear to rely on for the list
poisoning. I'd prefer a value below 0x1000 but matching list poisoning should
work for the most part.

How about?

==== CUT HERE ====
Fix infinite loop in get_futex_key when backed by huge pages

If a futex key happens to be located within a huge page mapped MAP_PRIVATE,
get_futex_key() can go into an infinite loop waiting for a page->mapping that
will never exist. This was reported and documented in an external bugzilla at

https://bugzilla.redhat.com/show_bug.cgi?id=552257

This patch makes page->mapping a poisoned value that includes
PAGE_MAPPING_ANON mapped MAP_PRIVATE.  This is enough for futex to continue
but because of PAGE_MAPPING_ANON, the poisoned value is not dereferenced
or used by futex. No other part of the VM should be dereferencing the
page->mapping of a hugetlbfs page as its page cache is not on the LRU.

This patch fixes the problem with the test case described in the bugzilla.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/poison.h |    9 +++++++++
 mm/hugetlb.c           |    5 ++++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/include/linux/poison.h b/include/linux/poison.h
index 2110a81..bab71f3 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -48,6 +48,15 @@
 #define POISON_FREE	0x6b	/* for use-after-free poisoning */
 #define	POISON_END	0xa5	/* end-byte of poisoning */
 
+/********** mm/hugetlb.c **********/
+/*
+ * Private mappings of hugetlb pages use this poisoned value for
+ * page->mapping. The core VM should not be doing anything with this mapping
+ * but futex requires the existance of some page->mapping value even though it
+ * is unused if PAGE_MAPPING_ANON is set.
+ */
+#define HUGETLB_POISON	((void *)(0x00300300 + POISON_POINTER_DELTA + PAGE_MAPPING_ANON))
+
 /********** arch/$ARCH/mm/init.c **********/
 #define POISON_FREE_INITMEM	0xcc
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6034dc9..ffbdfc8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -546,6 +546,7 @@ static void free_huge_page(struct page *page)
 
 	mapping = (struct address_space *) page_private(page);
 	set_page_private(page, 0);
+	page->mapping = NULL;
 	BUG_ON(page_count(page));
 	INIT_LIST_HEAD(&page->lru);
 
@@ -2447,8 +2448,10 @@ retry:
 			spin_lock(&inode->i_lock);
 			inode->i_blocks += blocks_per_huge_page(h);
 			spin_unlock(&inode->i_lock);
-		} else
+		} else {
 			lock_page(page);
+			page->mapping = HUGETLB_POISON;
+		}
 	}
 
 	/*
