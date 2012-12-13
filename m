Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992Ab2LMOdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:33:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44761 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899Ab2LMOKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:10:38 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 159/241] tmpfs: fix shared mempolicy leak
Date: Thu, 13 Dec 2012 11:58:44 -0200
Message-Id: <1355407206-17100-160-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 18a2f371f5edf41810f6469cb9be39931ef9deb9 upstream.

This fixes a regression in 3.7-rc, which has since gone into stable.

Commit 00442ad04a5e ("mempolicy: fix a memory corruption by refcount
imbalance in alloc_pages_vma()") changed get_vma_policy() to raise the
refcount on a shmem shared mempolicy; whereas shmem_alloc_page() went
on expecting alloc_page_vma() to drop the refcount it had acquired.
This deserves a rework: but for now fix the leak in shmem_alloc_page().

Hugh: shmem_swapin() did not need a fix, but surely it's clearer to use
the same refcounting there as in shmem_alloc_page(), delete its onstack
mempolicy, and the strange mpol_cond_copy() and __mpol_cond_copy() -
those were invented to let swapin_readahead() make an unknown number of
calls to alloc_pages_vma() with one mempolicy; but since 00442ad04a5e,
alloc_pages_vma() has kept refcount in balance, so now no problem.

Reported-and-tested-by: Tommi Rantala <tt.rantala@gmail.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/mempolicy.h |   16 ----------------
 mm/mempolicy.c            |   22 ----------------------
 mm/shmem.c                |   26 ++++++++++++++++----------
 3 files changed, 16 insertions(+), 48 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index c252970..7539a67 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -137,16 +137,6 @@ static inline void mpol_cond_put(struct mempolicy *pol)
 		__mpol_put(pol);
 }
 
-extern struct mempolicy *__mpol_cond_copy(struct mempolicy *tompol,
-					  struct mempolicy *frompol);
-static inline struct mempolicy *mpol_cond_copy(struct mempolicy *tompol,
-						struct mempolicy *frompol)
-{
-	if (!frompol)
-		return frompol;
-	return __mpol_cond_copy(tompol, frompol);
-}
-
 extern struct mempolicy *__mpol_dup(struct mempolicy *pol);
 static inline struct mempolicy *mpol_dup(struct mempolicy *pol)
 {
@@ -270,12 +260,6 @@ static inline void mpol_cond_put(struct mempolicy *pol)
 {
 }
 
-static inline struct mempolicy *mpol_cond_copy(struct mempolicy *to,
-						struct mempolicy *from)
-{
-	return from;
-}
-
 static inline void mpol_get(struct mempolicy *pol)
 {
 }
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index cee020c..e65ca51 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2029,28 +2029,6 @@ struct mempolicy *__mpol_dup(struct mempolicy *old)
 	return new;
 }
 
-/*
- * If *frompol needs [has] an extra ref, copy *frompol to *tompol ,
- * eliminate the * MPOL_F_* flags that require conditional ref and
- * [NOTE!!!] drop the extra ref.  Not safe to reference *frompol directly
- * after return.  Use the returned value.
- *
- * Allows use of a mempolicy for, e.g., multiple allocations with a single
- * policy lookup, even if the policy needs/has extra ref on lookup.
- * shmem_readahead needs this.
- */
-struct mempolicy *__mpol_cond_copy(struct mempolicy *tompol,
-						struct mempolicy *frompol)
-{
-	if (!mpol_needs_cond_ref(frompol))
-		return frompol;
-
-	*tompol = *frompol;
-	tompol->flags &= ~MPOL_F_SHARED;	/* copy doesn't need unref */
-	__mpol_put(frompol);
-	return tompol;
-}
-
 /* Slow path of a mempolicy comparison */
 bool __mpol_equal(struct mempolicy *a, struct mempolicy *b)
 {
diff --git a/mm/shmem.c b/mm/shmem.c
index 8d0c102..626a7e7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -921,24 +921,28 @@ static struct mempolicy *shmem_get_sbmpol(struct shmem_sb_info *sbinfo)
 static struct page *shmem_swapin(swp_entry_t swap, gfp_t gfp,
 			struct shmem_inode_info *info, pgoff_t index)
 {
-	struct mempolicy mpol, *spol;
 	struct vm_area_struct pvma;
-
-	spol = mpol_cond_copy(&mpol,
-			mpol_shared_policy_lookup(&info->policy, index));
+	struct page *page;
 
 	/* Create a pseudo vma that just contains the policy */
 	pvma.vm_start = 0;
 	pvma.vm_pgoff = index;
 	pvma.vm_ops = NULL;
-	pvma.vm_policy = spol;
-	return swapin_readahead(swap, gfp, &pvma, 0);
+	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
+
+	page = swapin_readahead(swap, gfp, &pvma, 0);
+
+	/* Drop reference taken by mpol_shared_policy_lookup() */
+	mpol_cond_put(pvma.vm_policy);
+
+	return page;
 }
 
 static struct page *shmem_alloc_page(gfp_t gfp,
 			struct shmem_inode_info *info, pgoff_t index)
 {
 	struct vm_area_struct pvma;
+	struct page *page;
 
 	/* Create a pseudo vma that just contains the policy */
 	pvma.vm_start = 0;
@@ -946,10 +950,12 @@ static struct page *shmem_alloc_page(gfp_t gfp,
 	pvma.vm_ops = NULL;
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, index);
 
-	/*
-	 * alloc_page_vma() will drop the shared policy reference
-	 */
-	return alloc_page_vma(gfp, &pvma, 0);
+	page = alloc_page_vma(gfp, &pvma, 0);
+
+	/* Drop reference taken by mpol_shared_policy_lookup() */
+	mpol_cond_put(pvma.vm_policy);
+
+	return page;
 }
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
-- 
1.7.9.5

