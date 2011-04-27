Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287Ab1D0XhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:37:21 -0400
Received: from mout.perfora.net ([74.208.4.195]:53473 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760257Ab1D0XhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:37:18 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] mm: remove MPOL_MF_STATS
Date: Wed, 27 Apr 2011 19:35:44 -0400
Message-Id: <1303947349-3620-4-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1303947349-3620-1-git-send-email-wilsons@start.ca>
References: <1303947349-3620-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:+vIMDpCClO58rX3/sSP02kEbVWq4tbYf5D6ufWheOxX
 1YTRFECKr8NVMqZTfT1+QeyB9PkRozZe+jqH+F5Cjps+Cj3UQU
 lW0EpI9zeNXjaq5lvMZJOhUI6ByMYTxp91lLhSzx5xs1Keaa0B
 B+LcIp8xO3PVoYTxxXmMQp4lr8HoaPckwxf+sCiZi1YyPBZtRl
 9TIKzCRRfMNY82j0JZKfbsgVH1qWpicOraw1qeuvAo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mapping statistics in a NUMA environment is now computed using the
generic walk_page_range() logic.  Remove the old/equivalent
functionality.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
---
 mm/mempolicy.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index dfe27e3..63c0d69 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -99,7 +99,6 @@
 /* Internal flags */
 #define MPOL_MF_DISCONTIG_OK (MPOL_MF_INTERNAL << 0)	/* Skip checks for continuous vmas */
 #define MPOL_MF_INVERT (MPOL_MF_INTERNAL << 1)		/* Invert check for nodemask */
-#define MPOL_MF_STATS (MPOL_MF_INTERNAL << 2)		/* Gather statistics */
 
 static struct kmem_cache *policy_cache;
 static struct kmem_cache *sn_cache;
@@ -492,9 +491,7 @@ static int check_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		if (node_isset(nid, *nodes) == !!(flags & MPOL_MF_INVERT))
 			continue;
 
-		if (flags & MPOL_MF_STATS)
-			gather_stats(page, private, pte_dirty(*pte));
-		else if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
+		if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
 			migrate_page_add(page, private, flags);
 		else
 			break;
@@ -2572,6 +2569,7 @@ static int gather_pte_stats(pte_t *pte, unsigned long addr,
 		unsigned long pte_size, struct mm_walk *walk)
 {
 	struct page *page;
+	int nid;
 
 	if (pte_none(*pte))
 		return 0;
@@ -2580,6 +2578,10 @@ static int gather_pte_stats(pte_t *pte, unsigned long addr,
 	if (!page)
 		return 0;
 
+	nid = page_to_nid(page);
+	if (!node_isset(nid, node_states[N_HIGH_MEMORY]))
+		return 0;
+
 	gather_stats(page, walk->private, pte_dirty(*pte));
 	return 0;
 }
-- 
1.7.3.5

