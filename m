Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab1DFGeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 02:34:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab1DFGeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 02:34:24 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        WANG Cong <amwang@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [Patch v2] rcu: update the CONFIG logic in include/linux/pagemap.h
Date: Wed,  6 Apr 2011 14:32:48 +0800
Message-Id: <1302071569-23217-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TREE_RCU depends on !PREEMPT && SMP, when !CONFIG_SMP is true, CONFIG_TREE_RCU
will be false, thus "!defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)"
is always false.

Paul suggested to update the logic to
!defined(CONFIG_SMP) && defined(CONFIG_TREE_PREEMPT_RCU).

Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: WANG Cong <amwang@redhat.com>

---
 include/linux/pagemap.h |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index c119506..a296d7c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -133,10 +133,9 @@ static inline int page_cache_get_speculative(struct page *page)
 {
 	VM_BUG_ON(in_interrupt());
 
-#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
-# ifdef CONFIG_PREEMPT
+#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_PREEMPT_RCU)
+	/* Must have CONFIG_PREEMPT here, implied by CONFIG_TREE_PREEMPT_RCU. */
 	VM_BUG_ON(!in_atomic());
-# endif
 	/*
 	 * Preempt must be disabled here - we rely on rcu_read_lock doing
 	 * this for us.
@@ -171,10 +170,8 @@ static inline int page_cache_add_speculative(struct page *page, int count)
 {
 	VM_BUG_ON(in_interrupt());
 
-#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
-# ifdef CONFIG_PREEMPT
+#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_PREEMPT_RCU)
 	VM_BUG_ON(!in_atomic());
-# endif
 	VM_BUG_ON(page_count(page) == 0);
 	atomic_add(count, &page->_count);
 
