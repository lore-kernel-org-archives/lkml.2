Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886Ab1D0Xgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:36:43 -0400
Received: from mout.perfora.net ([74.208.4.194]:60381 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294Ab1D0Xgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:36:41 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] mm: use walk_page_range() instead of custom page table walking code
Date: Wed, 27 Apr 2011 19:35:43 -0400
Message-Id: <1303947349-3620-3-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1303947349-3620-1-git-send-email-wilsons@start.ca>
References: <1303947349-3620-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:eiOOPbcJEQhP7XkeYdVGVu/dOkCln/Y2+U35K1U5mov
 EGnbZB8GTNawP4Wd8/dcsfGna1dLsbnOYRlqCRiiSbdsISa8RN
 syDJ9xp+WlyjiDbtCliCYKUTcUDekAE9hKCG22Vbi1CA0i0NSo
 n2f8ki76psPzBaDx5n7jYRJ5QneEaR32If2UDvCzfz+e8JWnC4
 GurChgzugsxzKJgSeOv6vlUS+nDWepvCgl2RPWAeKQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the specific case of show_numa_map(), the custom page table walking
logic implemented in mempolicy.c does not provide any special service
beyond that provided by walk_page_range().

Also, converting show_numa_map() to use the generic routine decouples
the function from mempolicy.c, allowing it to be moved out of the mm
subsystem and into fs/proc.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
---
 mm/mempolicy.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 5bfb03e..dfe27e3 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2568,6 +2568,22 @@ static void gather_stats(struct page *page, void *private, int pte_dirty)
 	md->node[page_to_nid(page)]++;
 }
 
+static int gather_pte_stats(pte_t *pte, unsigned long addr,
+		unsigned long pte_size, struct mm_walk *walk)
+{
+	struct page *page;
+
+	if (pte_none(*pte))
+		return 0;
+
+	page = pte_page(*pte);
+	if (!page)
+		return 0;
+
+	gather_stats(page, walk->private, pte_dirty(*pte));
+	return 0;
+}
+
 #ifdef CONFIG_HUGETLB_PAGE
 static void check_huge_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end,
@@ -2597,12 +2613,35 @@ static void check_huge_range(struct vm_area_struct *vma,
 		gather_stats(page, md, pte_dirty(*ptep));
 	}
 }
+
+static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
+		unsigned long addr, unsigned long end, struct mm_walk *walk)
+{
+	struct page *page;
+
+	if (pte_none(*pte))
+		return 0;
+
+	page = pte_page(*pte);
+	if (!page)
+		return 0;
+
+	gather_stats(page, walk->private, pte_dirty(*pte));
+	return 0;
+}
+
 #else
 static inline void check_huge_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end,
 		struct numa_maps *md)
 {
 }
+
+static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
+		unsigned long addr, unsigned long end, struct mm_walk *walk)
+{
+	return 0;
+}
 #endif
 
 /*
@@ -2615,6 +2654,7 @@ int show_numa_map(struct seq_file *m, void *v)
 	struct numa_maps *md;
 	struct file *file = vma->vm_file;
 	struct mm_struct *mm = vma->vm_mm;
+	struct mm_walk walk = {};
 	struct mempolicy *pol;
 	int n;
 	char buffer[50];
@@ -2626,6 +2666,11 @@ int show_numa_map(struct seq_file *m, void *v)
 	if (!md)
 		return 0;
 
+	walk.hugetlb_entry = gather_hugetbl_stats;
+	walk.pte_entry = gather_pte_stats;
+	walk.private = md;
+	walk.mm = mm;
+
 	pol = get_vma_policy(priv->task, vma, vma->vm_start);
 	mpol_to_str(buffer, sizeof(buffer), pol, 0);
 	mpol_cond_put(pol);
@@ -2642,13 +2687,7 @@ int show_numa_map(struct seq_file *m, void *v)
 		seq_printf(m, " stack");
 	}
 
-	if (is_vm_hugetlb_page(vma)) {
-		check_huge_range(vma, vma->vm_start, vma->vm_end, md);
-		seq_printf(m, " huge");
-	} else {
-		check_pgd_range(vma, vma->vm_start, vma->vm_end,
-			&node_states[N_HIGH_MEMORY], MPOL_MF_STATS, md);
-	}
+	walk_page_range(vma->vm_start, vma->vm_end, &walk);
 
 	if (!md->pages)
 		goto out;
-- 
1.7.3.5

