Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab2LEVtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 16:49:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab2LEVr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 16:47:57 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi.kleen@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH 1/3] HWPOISON, hugetlbfs: fix warning on freeing hwpoisoned hugepage
Date: Wed,  5 Dec 2012 16:47:36 -0500
Message-Id: <1354744058-26373-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1354744058-26373-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1354744058-26373-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the warning from __list_del_entry() which is triggered
when a process tries to do free_huge_page() for a hwpoisoned hugepage.

Originally, page->lru of hugetlbfs head page was dangling when the
hugepage was in use. This behavior has changed by commit 0edaecfab218d7
("hugetlb: add a list for tracking in-use HugeTLB pages"), where hugepages
in use are linked to hugepage_activelist. HWpoisoned hugepages should not
be charged to any process, so we introduce another list to link hwpoisoned
hugepages.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 include/linux/hugetlb.h | 3 +++
 mm/hugetlb.c            | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git v3.7-rc8.orig/include/linux/hugetlb.h v3.7-rc8/include/linux/hugetlb.h
index 2251648..13858ba 100644
--- v3.7-rc8.orig/include/linux/hugetlb.h
+++ v3.7-rc8/include/linux/hugetlb.h
@@ -230,6 +230,9 @@ struct hstate {
 	unsigned long nr_overcommit_huge_pages;
 	struct list_head hugepage_activelist;
 	struct list_head hugepage_freelists[MAX_NUMNODES];
+#ifdef CONFIG_MEMORY_FAILURE
+	struct list_head hugepage_hwpoisonedlist;
+#endif
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
diff --git v3.7-rc8.orig/mm/hugetlb.c v3.7-rc8/mm/hugetlb.c
index 59a0059..e61a749 100644
--- v3.7-rc8.orig/mm/hugetlb.c
+++ v3.7-rc8/mm/hugetlb.c
@@ -1939,6 +1939,7 @@ void __init hugetlb_add_hstate(unsigned order)
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
 	INIT_LIST_HEAD(&h->hugepage_activelist);
+	INIT_LIST_HEAD(&h->hugepage_hwpoisonedlist);
 	h->next_nid_to_alloc = first_node(node_states[N_HIGH_MEMORY]);
 	h->next_nid_to_free = first_node(node_states[N_HIGH_MEMORY]);
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
@@ -3170,7 +3171,7 @@ int dequeue_hwpoisoned_huge_page(struct page *hpage)
 
 	spin_lock(&hugetlb_lock);
 	if (is_hugepage_on_freelist(hpage)) {
-		list_del(&hpage->lru);
+		list_move(&hpage->lru, &h->hugepage_hwpoisonedlist);
 		set_page_refcounted(hpage);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
-- 
1.7.11.7

