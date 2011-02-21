Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab1BUTI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 14:08:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:29285 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab1BUTI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 14:08:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,201,1297065600"; 
   d="scan'208";a="605050285"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, aarcange@redhat.com,
        lwoodman@redhat.com, Andi Kleen <ak@linux.intel.com>,
        arcange@redhat.com
Subject: [PATCH 3/8] Preserve local node for KSM copies
Date: Mon, 21 Feb 2011 11:07:45 -0800
Message-Id: <1298315270-10434-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298315270-10434-1-git-send-email-andi@firstfloor.org>
References: <1298315270-10434-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a alloc_page_vma_node that allows passing the "local" node in.
Use it in ksm to allocate copy pages on the same node as
the original as possible.

Cc: arcange@redhat.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/gfp.h |    2 ++
 mm/ksm.c            |    3 ++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 782e74a..814d50e 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -343,6 +343,8 @@ extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
 #define alloc_page_vma(gfp_mask, vma, addr)			\
 	alloc_pages_vma(gfp_mask, 0, vma, addr, numa_node_id())
+#define alloc_page_vma_node(gfp_mask, vma, addr, node)		\
+	alloc_pages_vma(gfp_mask, 0, vma, addr, node)
 
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
diff --git a/mm/ksm.c b/mm/ksm.c
index c2b2a94..fc83335 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1575,7 +1575,8 @@ struct page *ksm_does_need_to_copy(struct page *page,
 {
 	struct page *new_page;
 
-	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
+	new_page = alloc_page_vma_node(GFP_HIGHUSER_MOVABLE, vma, address,
+				       page_to_nid(page));
 	if (new_page) {
 		copy_user_highpage(new_page, page, address, vma);
 
-- 
1.7.4

