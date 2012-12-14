Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab2LNXB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:01:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:40360 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836Ab2LNXB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:01:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 01/37] tmpfs: fix shared mempolicy leak
Date: Fri, 14 Dec 2012 15:00:38 -0800
Message-Id: <20121214222253.058397763@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222252.781413287@linuxfoundation.org>
References: <20121214222252.781413287@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/mempolicy.h |   16 ----------------
 mm/mempolicy.c            |   22 ----------------------
 mm/shmem.c                |   26 ++++++++++++++++----------
 3 files changed, 16 insertions(+), 48 deletions(-)

--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -137,16 +137,6 @@ static inline void mpol_cond_put(struct
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
@@ -270,12 +260,6 @@ static inline void mpol_cond_put(struct
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
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2035,28 +2035,6 @@ struct mempolicy *__mpol_dup(struct memp
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
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -921,25 +921,29 @@ static struct mempolicy *shmem_get_sbmpo
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
 	/* Bias interleave by inode number to distribute better across nodes */
 	pvma.vm_pgoff = index + info->vfs_inode.i_ino;
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
@@ -948,10 +952,12 @@ static struct page *shmem_alloc_page(gfp
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


