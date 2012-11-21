Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab2KUKW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:22:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633Ab2KUKWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:22:54 -0500
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 35/46] mm: numa: Introduce last_nid to the page frame
Date: Wed, 21 Nov 2012 10:21:41 +0000
Message-Id: <1353493312-8069-36-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1353493312-8069-1-git-send-email-mgorman@suse.de>
References: <1353493312-8069-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a last_nid field to the page struct. This is used
to build a two-stage filter in the next patch that is aimed at
mitigating a problem whereby pages migrate to the wrong node when
referenced by a process that was running off its home node.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/mm.h       |   30 ++++++++++++++++++++++++++++++
 include/linux/mm_types.h |    4 ++++
 mm/page_alloc.c          |    2 ++
 3 files changed, 36 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d04c2f0..a0834e1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -693,6 +693,36 @@ static inline int page_to_nid(const struct page *page)
 }
 #endif
 
+#ifdef CONFIG_BALANCE_NUMA
+static inline int page_xchg_last_nid(struct page *page, int nid)
+{
+	return xchg(&page->_last_nid, nid);
+}
+
+static inline int page_last_nid(struct page *page)
+{
+	return page->_last_nid;
+}
+static inline void reset_page_last_nid(struct page *page)
+{
+	page->_last_nid = -1;
+}
+#else
+static inline int page_xchg_last_nid(struct page *page, int nid)
+{
+	return page_to_nid(page);
+}
+
+static inline int page_last_nid(struct page *page)
+{
+	return page_to_nid(page);
+}
+
+static inline void reset_page_last_nid(struct page *page)
+{
+}
+#endif
+
 static inline struct zone *page_zone(const struct page *page)
 {
 	return &NODE_DATA(page_to_nid(page))->node_zones[page_zonenum(page)];
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b40f4ef..6b478ff 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -175,6 +175,10 @@ struct page {
 	 */
 	void *shadow;
 #endif
+
+#ifdef CONFIG_BALANCE_NUMA
+	int _last_nid;
+#endif
 }
 /*
  * The struct page can be forced to be double word aligned so that atomic ops
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index df58654..fd6a073 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -608,6 +608,7 @@ static inline int free_pages_check(struct page *page)
 		bad_page(page);
 		return 1;
 	}
+	reset_page_last_nid(page);
 	if (page->flags & PAGE_FLAGS_CHECK_AT_PREP)
 		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	return 0;
@@ -3826,6 +3827,7 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 		mminit_verify_page_links(page, zone, nid, pfn);
 		init_page_count(page);
 		reset_page_mapcount(page);
+		reset_page_last_nid(page);
 		SetPageReserved(page);
 		/*
 		 * Mark the block movable so that blocks are reserved for
-- 
1.7.9.2

