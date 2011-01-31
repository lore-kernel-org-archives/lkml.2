Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab1AaG1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 01:27:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab1AaG1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 01:27:49 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: WANG Cong <amwang@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>
Subject: [Patch] rcu: remove dead code in include/linux/pagemap.h
Date: Mon, 31 Jan 2011 14:27:04 +0800
Message-Id: <1296455224-14065-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TREE_RCU depends on !PREEMPT && SMP, when !CONFIG_SMP is true, CONFIG_TREE_RCU
will be false, thus "!defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)"
is always false.

Remove these dead code.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

---
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 9c66e99..e2bbbe3 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -133,23 +133,6 @@ static inline int page_cache_get_speculative(struct page *page)
 {
 	VM_BUG_ON(in_interrupt());
 
-#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
-# ifdef CONFIG_PREEMPT
-	VM_BUG_ON(!in_atomic());
-# endif
-	/*
-	 * Preempt must be disabled here - we rely on rcu_read_lock doing
-	 * this for us.
-	 *
-	 * Pagecache won't be truncated from interrupt context, so if we have
-	 * found a page in the radix tree here, we have pinned its refcount by
-	 * disabling preempt, and hence no need for the "speculative get" that
-	 * SMP requires.
-	 */
-	VM_BUG_ON(page_count(page) == 0);
-	atomic_inc(&page->_count);
-
-#else
 	if (unlikely(!get_page_unless_zero(page))) {
 		/*
 		 * Either the page has been freed, or will be freed.
@@ -158,7 +141,6 @@ static inline int page_cache_get_speculative(struct page *page)
 		 */
 		return 0;
 	}
-#endif
 	VM_BUG_ON(PageTail(page));
 
 	return 1;
@@ -171,17 +153,9 @@ static inline int page_cache_add_speculative(struct page *page, int count)
 {
 	VM_BUG_ON(in_interrupt());
 
-#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
-# ifdef CONFIG_PREEMPT
-	VM_BUG_ON(!in_atomic());
-# endif
-	VM_BUG_ON(page_count(page) == 0);
-	atomic_add(count, &page->_count);
-
-#else
 	if (unlikely(!atomic_add_unless(&page->_count, count, 0)))
 		return 0;
-#endif
+
 	VM_BUG_ON(PageCompound(page) && page != compound_head(page));
 
 	return 1;
