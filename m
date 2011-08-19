Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1HSHtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 03:49:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45725 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1HSHtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 03:49:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:x-system-of-record;
	b=ifZq0i6ph3rpLjed9QfK1FFCzhP7aUkeJfIxyyoPzSdxkR4rvYIp/FACIhp+Q1QB7
	Od/kAXkxhSKJQ0Im4kdug==
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Andrea Arcangeli <aarcange@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH 8/9] mm: add API for setting a grace period cookie on compound pages
Date: Fri, 19 Aug 2011 00:48:30 -0700
Message-Id: <1313740111-27446-9-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313740111-27446-1-git-send-email-walken@google.com>
References: <1313740111-27446-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds the page_get_gp_cookie() / page_gp_cookie_elapsed()
API to be used on compound pages. page_get_gp_cookie() sets a cookie
on a page and page_gp_cookie_elapsed() returns true if an rcu grace
period has elapsed since the cookie was set.

page_clear_gp_cookie() is called before freeing compound pages so that
their state is always returned to a given standard (as enforced by
free_pages_check() in mm/page_alloc.c)

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 include/linux/mm.h       |   22 ++++++++++++++++++++++
 include/linux/mm_types.h |    6 +++++-
 mm/page_alloc.c          |    1 +
 3 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9ff5f2d..2649b59 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -494,6 +494,28 @@ static inline void set_compound_order(struct page *page, unsigned long order)
 	page[1].lru.prev = (void *)order;
 }
 
+static inline void page_get_gp_cookie(struct page *page)
+{
+	VM_BUG_ON(!PageHead(page));
+	rcu_get_gp_cookie(&page[1].thp_create_timestamp);
+}
+
+static inline bool page_gp_cookie_elapsed(struct page *page)
+{
+	VM_BUG_ON(!PageHead(page));
+	return rcu_gp_cookie_elapsed(&page[1].thp_create_timestamp);
+}
+
+static inline void page_clear_gp_cookie(struct page *page)
+{
+	VM_BUG_ON(!PageHead(page));
+	VM_BUG_ON(offsetof(struct page, thp_create_timestamp) !=
+		  offsetof(struct page, mapping));
+	VM_BUG_ON(sizeof(page->thp_create_timestamp) !=
+		  sizeof(page->mapping));
+	page[1].mapping = 0;
+}
+
 #ifdef CONFIG_MMU
 /*
  * Do pte_mkwrite, but only if the vma says VM_WRITE.  We do this when
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 027935c..a6f99aa 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -12,6 +12,7 @@
 #include <linux/completion.h>
 #include <linux/cpumask.h>
 #include <linux/page-debug-flags.h>
+#include <linux/rcupdate.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
 
@@ -66,7 +67,10 @@ struct page {
 	    spinlock_t ptl;
 #endif
 	    struct kmem_cache *slab;	/* SLUB: Pointer to slab */
-	    struct page *first_page;	/* Compound tail pages */
+	    struct {	/* Compound tail pages */
+		struct page *first_page;
+		struct rcu_cookie thp_create_timestamp;
+	    };
 	};
 	union {
 		pgoff_t index;		/* Our offset within mapping. */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4e8985a..dc42355 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -342,6 +342,7 @@ out:
 
 static void free_compound_page(struct page *page)
 {
+	page_clear_gp_cookie(page);
 	__free_pages_ok(page, compound_order(page));
 }
 
-- 
1.7.3.1

