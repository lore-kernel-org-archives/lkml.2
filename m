Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761521Ab1EOWWn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 18:22:43 -0400
Received: from mout.perfora.net ([74.208.4.194]:62126 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761468Ab1EOWWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 18:22:22 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH v2 4/9] mm: make gather_stats() type-safe and remove forward declaration
Date: Sun, 15 May 2011 18:20:24 -0400
Message-Id: <1305498029-11677-5-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305498029-11677-1-git-send-email-wilsons@start.ca>
References: <1305498029-11677-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:5PudiharWM1lvLxxGDx++NsCRgZzSRxaTTABNPmwxNh
 Vd4KzIZadsOq6K5sBSKcxFZL1K2octgliXfQmFdkiS+17ToNVq
 oCmWTDpUCaFtg/e1PGb6fPKXnkcLkloHgqDG4jwVgFump7cKI6
 wfm1M8NobzZ9gJpLzvFv6zMuQUkzQ/ns6KiA6lC9N5e8iapcxF
 8aVdI0t+iklsNBPZxzwpYqEy3bPtDyMK41DcxrHM1s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the prototype of gather_stats() to take a struct numa_maps as
argument instead of a generic void *.  Update all callers to make the
required type explicit.

Since gather_stats() is not needed before its definition and is
scheduled to be moved out of mempolicy.c the declaration is removed as
well.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 mm/mempolicy.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index d43d05e..108f858 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -457,7 +457,6 @@ static const struct mempolicy_operations mpol_ops[MPOL_MAX] = {
 	},
 };
 
-static void gather_stats(struct page *, void *, int pte_dirty);
 static void migrate_page_add(struct page *page, struct list_head *pagelist,
 				unsigned long flags);
 
@@ -2555,9 +2554,8 @@ struct numa_maps {
 	unsigned long node[MAX_NUMNODES];
 };
 
-static void gather_stats(struct page *page, void *private, int pte_dirty)
+static void gather_stats(struct page *page, struct numa_maps *md, int pte_dirty)
 {
-	struct numa_maps *md = private;
 	int count = page_mapcount(page);
 
 	md->pages++;
@@ -2650,6 +2648,7 @@ static void check_huge_range(struct vm_area_struct *vma,
 static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
 {
+	struct numa_maps *md;
 	struct page *page;
 
 	if (pte_none(*pte))
@@ -2659,7 +2658,8 @@ static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
 	if (!page)
 		return 0;
 
-	gather_stats(page, walk->private, pte_dirty(*pte));
+	md = walk->private;
+	gather_stats(page, md, pte_dirty(*pte));
 	return 0;
 }
 
-- 
1.7.4.4

