Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112Ab0EJXU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:20:58 -0400
Received: from kroah.org ([198.145.64.141]:51612 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431Ab0EJW5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:32 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:35 2010
Message-Id: <20100510223535.528832417@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <peterz@infradead.org>,
       Darren Hart <darren@dvhart.com>
Subject: [12/98] hugetlb: fix infinite loop in get_futex_key() when backed by huge pages
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mel Gorman <mel@csn.ul.ie>

commit 23be7468e8802a2ac1de6ee3eecb3ec7f14dc703 upstream.

If a futex key happens to be located within a huge page mapped
MAP_PRIVATE, get_futex_key() can go into an infinite loop waiting for a
page->mapping that will never exist.

See https://bugzilla.redhat.com/show_bug.cgi?id=552257 for more details
about the problem.

This patch makes page->mapping a poisoned value that includes
PAGE_MAPPING_ANON mapped MAP_PRIVATE.  This is enough for futex to
continue but because of PAGE_MAPPING_ANON, the poisoned value is not
dereferenced or used by futex.  No other part of the VM should be
dereferencing the page->mapping of a hugetlbfs page as its page cache is
not on the LRU.

This patch fixes the problem with the test case described in the bugzilla.

[akpm@linux-foundation.org: mel cant spel]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Darren Hart <darren@dvhart.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/poison.h |    9 +++++++++
 mm/hugetlb.c           |    5 ++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/include/linux/poison.h
+++ b/include/linux/poison.h
@@ -48,6 +48,15 @@
 #define POISON_FREE	0x6b	/* for use-after-free poisoning */
 #define	POISON_END	0xa5	/* end-byte of poisoning */
 
+/********** mm/hugetlb.c **********/
+/*
+ * Private mappings of hugetlb pages use this poisoned value for
+ * page->mapping. The core VM should not be doing anything with this mapping
+ * but futex requires the existence of some page->mapping value even though it
+ * is unused if PAGE_MAPPING_ANON is set.
+ */
+#define HUGETLB_POISON	((void *)(0x00300300 + POISON_POINTER_DELTA + PAGE_MAPPING_ANON))
+
 /********** arch/$ARCH/mm/init.c **********/
 #define POISON_FREE_INITMEM	0xcc
 
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -545,6 +545,7 @@ static void free_huge_page(struct page *
 
 	mapping = (struct address_space *) page_private(page);
 	set_page_private(page, 0);
+	page->mapping = NULL;
 	BUG_ON(page_count(page));
 	INIT_LIST_HEAD(&page->lru);
 
@@ -2095,8 +2096,10 @@ retry:
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


