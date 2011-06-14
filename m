Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1FNK4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 06:56:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:12980 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab1FNK4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:56:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=jb8marMNUKDO2wC2KqCM4DzPduSjnDuHWnbMP0ePj9+3/6hrTfy98W+LuE2GR/3tQv
         dB5RsmUyB2wLojsHuLSA==
Date: Tue, 14 Jun 2011 03:56:16 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 10/12] tmpfs: convert shmem_writepage and enable swap
In-Reply-To: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
Message-ID: <alpine.LSU.2.00.1106140355050.29206@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert shmem_writepage() to use shmem_delete_from_page_cache() to use
shmem_radix_tree_replace() to substitute swap entry for page pointer
atomically in the radix tree.

As with shmem_add_to_page_cache(), it's not entirely satisfactory to be
copying such code from delete_from_swap_cache, but again judged easier
to sell than making its other callers go through the extras.

Remove the toy implementation's shmem_put_swap() and shmem_get_swap(),
now unreferenced, and the hack to disable swap: it's now good to go.

The way things have worked out, info->lock no longer helps to guard the
shmem_swaplist: we increment swapped under shmem_swaplist_mutex only.
That global mutex exclusion between shmem_writepage() and shmem_unuse()
is not pretty, and we ought to find another way; but it's been forced
on us by recent race discoveries, not a consequence of this patchset.

And what has become of the WARN_ON_ONCE(1) free_swap_and_cache() if a
swap entry was found already present?  That's no longer possible, the
(unknown) one inserting this page into filecache would hit the swap
entry occupying that slot.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/shmem.c |   88 +++++++++++++++++++++------------------------------
 1 file changed, 37 insertions(+), 51 deletions(-)

--- linux.orig/mm/shmem.c	2011-06-14 00:45:20.685161581 -0700
+++ linux/mm/shmem.c	2011-06-14 00:54:36.499917716 -0700
@@ -6,7 +6,8 @@
  *		 2000-2001 Christoph Rohland
  *		 2000-2001 SAP AG
  *		 2002 Red Hat Inc.
- * Copyright (C) 2002-2005 Hugh Dickins.
+ * Copyright (C) 2002-2011 Hugh Dickins.
+ * Copyright (C) 2011 Google Inc.
  * Copyright (C) 2002-2005 VERITAS Software Corporation.
  * Copyright (C) 2004 Andi Kleen, SuSE Labs
  *
@@ -219,19 +220,6 @@ static void shmem_recalc_inode(struct in
 	}
 }
 
-static void shmem_put_swap(struct shmem_inode_info *info, pgoff_t index,
-			   swp_entry_t swap)
-{
-	if (index < SHMEM_NR_DIRECT)
-		info->i_direct[index] = swap;
-}
-
-static swp_entry_t shmem_get_swap(struct shmem_inode_info *info, pgoff_t index)
-{
-	return (index < SHMEM_NR_DIRECT) ?
-		info->i_direct[index] : (swp_entry_t){0};
-}
-
 /*
  * Replace item expected in radix tree by a new item, while holding tree lock.
  */
@@ -300,6 +288,25 @@ static int shmem_add_to_page_cache(struc
 }
 
 /*
+ * Like delete_from_page_cache, but substitutes swap for page.
+ */
+static void shmem_delete_from_page_cache(struct page *page, void *radswap)
+{
+	struct address_space *mapping = page->mapping;
+	int error;
+
+	spin_lock_irq(&mapping->tree_lock);
+	error = shmem_radix_tree_replace(mapping, page->index, page, radswap);
+	page->mapping = NULL;
+	mapping->nrpages--;
+	__dec_zone_page_state(page, NR_FILE_PAGES);
+	__dec_zone_page_state(page, NR_SHMEM);
+	spin_unlock_irq(&mapping->tree_lock);
+	page_cache_release(page);
+	BUG_ON(error);
+}
+
+/*
  * Like find_get_pages, but collecting swap entries as well as pages.
  */
 static unsigned shmem_find_get_pages_and_swap(struct address_space *mapping,
@@ -664,14 +671,10 @@ int shmem_unuse(swp_entry_t swap, struct
 	mutex_lock(&shmem_swaplist_mutex);
 	list_for_each_safe(this, next, &shmem_swaplist) {
 		info = list_entry(this, struct shmem_inode_info, swaplist);
-		if (!info->swapped) {
-			spin_lock(&info->lock);
-			if (!info->swapped)
-				list_del_init(&info->swaplist);
-			spin_unlock(&info->lock);
-		}
 		if (info->swapped)
 			found = shmem_unuse_inode(info, swap, page);
+		else
+			list_del_init(&info->swaplist);
 		cond_resched();
 		if (found)
 			break;
@@ -694,10 +697,10 @@ out:
 static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 {
 	struct shmem_inode_info *info;
-	swp_entry_t swap, oswap;
 	struct address_space *mapping;
-	pgoff_t index;
 	struct inode *inode;
+	swp_entry_t swap;
+	pgoff_t index;
 
 	BUG_ON(!PageLocked(page));
 	mapping = page->mapping;
@@ -720,55 +723,38 @@ static int shmem_writepage(struct page *
 		WARN_ON_ONCE(1);	/* Still happens? Tell us about it! */
 		goto redirty;
 	}
-
-	/*
-	 * Disable even the toy swapping implementation, while we convert
-	 * functions one by one to having swap entries in the radix tree.
-	 */
-	if (index < ULONG_MAX)
-		goto redirty;
-
 	swap = get_swap_page();
 	if (!swap.val)
 		goto redirty;
 
 	/*
 	 * Add inode to shmem_unuse()'s list of swapped-out inodes,
-	 * if it's not already there.  Do it now because we cannot take
-	 * mutex while holding spinlock, and must do so before the page
-	 * is moved to swap cache, when its pagelock no longer protects
+	 * if it's not already there.  Do it now before the page is
+	 * moved to swap cache, when its pagelock no longer protects
 	 * the inode from eviction.  But don't unlock the mutex until
-	 * we've taken the spinlock, because shmem_unuse_inode() will
-	 * prune a !swapped inode from the swaplist under both locks.
+	 * we've incremented swapped, because shmem_unuse_inode() will
+	 * prune a !swapped inode from the swaplist under this mutex.
 	 */
 	mutex_lock(&shmem_swaplist_mutex);
 	if (list_empty(&info->swaplist))
 		list_add_tail(&info->swaplist, &shmem_swaplist);
 
-	spin_lock(&info->lock);
-	mutex_unlock(&shmem_swaplist_mutex);
-
-	oswap = shmem_get_swap(info, index);
-	if (oswap.val) {
-		WARN_ON_ONCE(1);	/* Still happens? Tell us about it! */
-		free_swap_and_cache(oswap);
-		shmem_put_swap(info, index, (swp_entry_t){0});
-		info->swapped--;
-	}
-	shmem_recalc_inode(inode);
-
 	if (add_to_swap_cache(page, swap, GFP_ATOMIC) == 0) {
-		delete_from_page_cache(page);
-		shmem_put_swap(info, index, swap);
-		info->swapped++;
 		swap_shmem_alloc(swap);
+		shmem_delete_from_page_cache(page, swp_to_radix_entry(swap));
+
+		spin_lock(&info->lock);
+		info->swapped++;
+		shmem_recalc_inode(inode);
 		spin_unlock(&info->lock);
+
+		mutex_unlock(&shmem_swaplist_mutex);
 		BUG_ON(page_mapped(page));
 		swap_writepage(page, wbc);
 		return 0;
 	}
 
-	spin_unlock(&info->lock);
+	mutex_unlock(&shmem_swaplist_mutex);
 	swapcache_free(swap, NULL);
 redirty:
 	set_page_dirty(page);
