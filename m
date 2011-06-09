Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab1FIWmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 18:42:10 -0400
Received: from smtp-out.google.com ([74.125.121.67]:48121 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858Ab1FIWmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:42:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Qi1zICikNAJ0vQB0J308Ovkpw/Dsw1csHxo5QRspl4nfwTyDLgEVAC/7ADMlffIKlA
         5PpYWUGzRSSnmg2XvvOg==
Date: Thu, 9 Jun 2011 15:42:02 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Erez Zadok <ezk@fsl.cs.sunysb.edu>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 7/7] tmpfs: simplify unuse and writepage
In-Reply-To: <alpine.LSU.2.00.1106091529060.2200@sister.anvils>
Message-ID: <alpine.LSU.2.00.1106091540141.2200@sister.anvils>
References: <alpine.LSU.2.00.1106091529060.2200@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shmem_unuse_inode() and shmem_writepage() contain a little code to
cope with pages inserted independently into the filecache, probably
by a filesystem stacked on top of tmpfs, then fed to its ->readpage()
or ->writepage().

Unionfs was indeed experimenting with working in that way three years
ago, but I find no current examples: nowadays the stacking filesystems
use vfs interfaces to the lower filesystem.

It's now illegal: remove most of that code, adding some WARN_ON_ONCEs.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Erez Zadok <ezk@fsl.cs.sunysb.edu>
---
 mm/shmem.c |   50 ++++++++++++++++----------------------------------
 1 file changed, 16 insertions(+), 34 deletions(-)

--- linux.orig/mm/shmem.c	2011-06-09 11:39:50.369329884 -0700
+++ linux/mm/shmem.c	2011-06-09 11:40:02.761391246 -0700
@@ -972,20 +972,7 @@ found:
 	error = add_to_page_cache_locked(page, mapping, idx, GFP_NOWAIT);
 	/* which does mem_cgroup_uncharge_cache_page on error */
 
-	if (error == -EEXIST) {
-		struct page *filepage = find_get_page(mapping, idx);
-		error = 1;
-		if (filepage) {
-			/*
-			 * There might be a more uptodate page coming down
-			 * from a stacked writepage: forget our swappage if so.
-			 */
-			if (PageUptodate(filepage))
-				error = 0;
-			page_cache_release(filepage);
-		}
-	}
-	if (!error) {
+	if (error != -ENOMEM) {
 		delete_from_swap_cache(page);
 		set_page_dirty(page);
 		info->flags |= SHMEM_PAGEIN;
@@ -1072,16 +1059,17 @@ static int shmem_writepage(struct page *
 	/*
 	 * shmem_backing_dev_info's capabilities prevent regular writeback or
 	 * sync from ever calling shmem_writepage; but a stacking filesystem
-	 * may use the ->writepage of its underlying filesystem, in which case
+	 * might use ->writepage of its underlying filesystem, in which case
 	 * tmpfs should write out to swap only in response to memory pressure,
-	 * and not for the writeback threads or sync.  However, in those cases,
-	 * we do still want to check if there's a redundant swappage to be
-	 * discarded.
+	 * and not for the writeback threads or sync.
 	 */
-	if (wbc->for_reclaim)
-		swap = get_swap_page();
-	else
-		swap.val = 0;
+	if (!wbc->for_reclaim) {
+		WARN_ON_ONCE(1);	/* Still happens? Tell us about it! */
+		goto redirty;
+	}
+	swap = get_swap_page();
+	if (!swap.val)
+		goto redirty;
 
 	/*
 	 * Add inode to shmem_unuse()'s list of swapped-out inodes,
@@ -1092,15 +1080,12 @@ static int shmem_writepage(struct page *
 	 * we've taken the spinlock, because shmem_unuse_inode() will
 	 * prune a !swapped inode from the swaplist under both locks.
 	 */
-	if (swap.val) {
-		mutex_lock(&shmem_swaplist_mutex);
-		if (list_empty(&info->swaplist))
-			list_add_tail(&info->swaplist, &shmem_swaplist);
-	}
+	mutex_lock(&shmem_swaplist_mutex);
+	if (list_empty(&info->swaplist))
+		list_add_tail(&info->swaplist, &shmem_swaplist);
 
 	spin_lock(&info->lock);
-	if (swap.val)
-		mutex_unlock(&shmem_swaplist_mutex);
+	mutex_unlock(&shmem_swaplist_mutex);
 
 	if (index >= info->next_index) {
 		BUG_ON(!(info->flags & SHMEM_TRUNCATE));
@@ -1108,16 +1093,13 @@ static int shmem_writepage(struct page *
 	}
 	entry = shmem_swp_entry(info, index, NULL);
 	if (entry->val) {
-		/*
-		 * The more uptodate page coming down from a stacked
-		 * writepage should replace our old swappage.
-		 */
+		WARN_ON_ONCE(1);	/* Still happens? Tell us about it! */
 		free_swap_and_cache(*entry);
 		shmem_swp_set(info, entry, 0);
 	}
 	shmem_recalc_inode(inode);
 
-	if (swap.val && add_to_swap_cache(page, swap, GFP_ATOMIC) == 0) {
+	if (add_to_swap_cache(page, swap, GFP_ATOMIC) == 0) {
 		delete_from_page_cache(page);
 		shmem_swp_set(info, entry, swap.val);
 		shmem_swp_unmap(entry);
