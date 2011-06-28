Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab1F1T6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 15:58:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:57507 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab1F1T56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 15:57:58 -0400
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: david@gibson.dropbear.id.au, galak@kernel.crashing.org, wli@holomorphy.com,
        benh@kernel.crashing.org
Subject: [PATCH 2/5] hugetlb: add phys addr to struct huge_bootmem_page
Date: Tue, 28 Jun 2011 14:54:45 -0500
Message-Id: <13092910103675-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.3.rc2.29.gc4640f
In-Reply-To: <13092909493748-git-send-email-beckyb@kernel.crashing.org>
References: <1309290888309-git-send-email-beckyb@kernel.crashing.org>
 <13092909493748-git-send-email-beckyb@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Becky Bruce <beckyb@kernel.crashing.org>

This is needed on HIGHMEM systems - we don't always have a virtual
address so store the physical address and map it in as needed.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 include/linux/hugetlb.h |    3 +++
 mm/hugetlb.c            |    8 +++++++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 59225ef..19644e0 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -231,6 +231,9 @@ struct hstate {
 struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
+#ifdef CONFIG_HIGHMEM
+	phys_addr_t phys;
+#endif
 };
 
 struct page *alloc_huge_page_node(struct hstate *h, int nid);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6402458..2db81ea 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1105,8 +1105,14 @@ static void __init gather_bootmem_prealloc(void)
 	struct huge_bootmem_page *m;
 
 	list_for_each_entry(m, &huge_boot_pages, list) {
-		struct page *page = virt_to_page(m);
 		struct hstate *h = m->hstate;
+#ifdef CONFIG_HIGHMEM
+		struct page *page = pfn_to_page(m->phys >> PAGE_SHIFT);
+		free_bootmem_late((unsigned long)m,
+				  sizeof(struct huge_bootmem_page));
+#else
+		struct page *page = virt_to_page(m);
+#endif
 		__ClearPageReserved(page);
 		WARN_ON(page_count(page) != 1);
 		prep_compound_huge_page(page, h->order);
-- 
1.5.6.5

