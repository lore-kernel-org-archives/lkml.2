Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0DSPdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 11:33:10 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33899 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab0DSPdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 11:33:06 -0400
Date: Mon, 19 Apr 2010 16:32:45 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Peter Zijlstra <peterz@infradead.org>
Cc: r6144 <rainy6144@gmail.com>, linux-kernel@vger.kernel.org,
       Darren Hart <dvhltc@us.ibm.com>, tglx <tglx@linutronix.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: Process-shared futexes on hugepages puts the kernel in an
	infinite loop in 2.6.32.11; is this fixed now?
Message-ID: <20100419153245.GX19264@csn.ul.ie>
References: <1271432722.2564.16.camel@localhost.localdomain> <1271449668.1674.466.camel@laptop> <20100419114300.GT19264@csn.ul.ie> <1271677956.1674.922.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1271677956.1674.922.camel@laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 01:52:36PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-04-19 at 12:43 +0100, Mel Gorman wrote:
> 
> > > Right, so I had a quick chat with Mel, and it appears MAP_PRIVATE
> > > hugetlb pages don't have their page->mapping set.
> > > 
> > > I guess something like the below might work, but I'd really rather not
> > > add hugetlb knowledge to futex.c. Does anybody else have a better idea?
> > > Maybe create something similar to an anon_vma for hugetlb pages?
> > > 
> > 
> > anon_vma for hugetlb pages sounds overkill, what would it gain? In this
> > context, futex only appears to distinguish between whether the
> > references are private or shared.
> > 
> > Looking at the hugetlbfs code, I can't see a place where it actually cares
> > about the mapping as such. It's used to find shared pages in the page cache
> > (but not in the LRU) that are backed by the hugetlbfs file. For hugetlbfs
> > though, the mapping is mostly kept in page->private for reservation accounting
> > purposes.
> > 
> > I can't think of other parts of the VM that touch the mapping if the
> > page is managed by hugetlbfs so the following patch should also work but
> > without futex having hugetlbfs-awareness. What do you think? Maybe for
> > safety, it would be better to make the mapping some obvious poison bytes
> > or'd with PAGE_MAPPING_ANON so an oops will be more obvious?
> 
> Yes, this seems perfectly adequate to me, that poison idea might be
> worthwhile too :-)
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 

Are you ok with an Ack to this slightly-difference patch too? If so,
I'll forward it on to Andrew.

==== CUT HERE ====

Fix infinite loop in get_futex_key when backed by huge pages

If a futex key happens to be located within a huge page mapped MAP_PRIVATE,
get_futex_key() can go into an infinite loop waiting for a page->mapping
that will never exist. This was reported and documented in an external
bugzilla at

https://bugzilla.redhat.com/show_bug.cgi?id=552257

This patch makes page->mapping a poisoned value that includes PAGE_MAPPING_ANON
mapped MAP_PRIVATE.  This is enough for futex to continue but because
of PAGE_MAPPING_ANON, the poisoned value is not dereferenced or used by
futex. No other part of the VM should be dereferencing the page->mapping of
a hugetlbfs page as its page cache is not on the LRU.

This patch fixes the problem with the test case described in the bugzilla.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/poison.h |   10 ++++++++++
 mm/hugetlb.c           |    6 +++++-
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/include/linux/poison.h b/include/linux/poison.h
index 2110a81..0f7b5ac 100644
--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -48,6 +48,16 @@
 #define POISON_FREE	0x6b	/* for use-after-free poisoning */
 #define	POISON_END	0xa5	/* end-byte of poisoning */
 
+/********** mm/hugetlb.c **********/
+/*
+ * Private mappings of hugetlb pages use this poisoned value for
+ * page->mapping. The core VM should not be doing anything with this mapping
+ * but futex requires the existance of some page->mapping value even if it
+ * is unused. If the core VM does deference the mapping, it'll look like a
+ * suspiciously high null-pointer offset starting from 0x2e5
+ */
+#define HUGETLB_PRIVATE_MAPPING	(0x2e4 | PAGE_MAPPING_ANON)
+
 /********** arch/$ARCH/mm/init.c **********/
 #define POISON_FREE_INITMEM	0xcc
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6034dc9..487e3c2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -546,6 +546,7 @@ static void free_huge_page(struct page *page)
 
 	mapping = (struct address_space *) page_private(page);
 	set_page_private(page, 0);
+	page->mapping = NULL;
 	BUG_ON(page_count(page));
 	INIT_LIST_HEAD(&page->lru);
 
@@ -2447,8 +2448,11 @@ retry:
 			spin_lock(&inode->i_lock);
 			inode->i_blocks += blocks_per_huge_page(h);
 			spin_unlock(&inode->i_lock);
-		} else
+		} else {
 			lock_page(page);
+			page->mapping = (struct address_space *)
+							HUGETLB_PRIVATE_MAPPING;
+		}
 	}
 
 	/*
