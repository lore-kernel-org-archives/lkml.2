Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934073Ab1ESSfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:35:33 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36375 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934393Ab1ESScp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:32:45 -0400
X-Sasl-enc: 7z2tQiNV3AhvA8SixU2prPdxU5InqBsQK1smnDgw3+/e 1305829964
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:31:27 2011
Message-Id: <20110519183127.122729561@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:30:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: [15/24] tmpfs: fix spurious ENOSPC when racing with unswap
In-Reply-To: <20110519182446.GA23751@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 3111
Lines: 91

From: Hugh Dickins <hughd@google.com>

commit 59a16ead572330deb38e5848151d30ed1af754bc upstream.

Testing the shmem_swaplist replacements for igrab() revealed another bug:
writes to /dev/loop0 on a tmpfs file which fills its filesystem were
sometimes failing with "Buffer I/O error"s.

These came from ENOSPC failures of shmem_getpage(), when racing with
swapoff: the same could happen when racing with another shmem_getpage(),
pulling the page in from swap in between our find_lock_page() and our
taking the info->lock (though not in the single-threaded loop case).

This is unacceptable, and surprising that I've not noticed it before:
it dates back many years, but (presumably) was made a lot easier to
reproduce in 2.6.36, which sited a page preallocation in the race window.

Fix it by rechecking the page cache before settling on an ENOSPC error.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 mm/shmem.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1035,6 +1035,7 @@ static int shmem_writepage(struct page *
 	struct address_space *mapping;
 	unsigned long index;
 	struct inode *inode;
+	bool unlock_mutex = false;
 
 	BUG_ON(!PageLocked(page));
 	mapping = page->mapping;
@@ -1060,7 +1061,26 @@ static int shmem_writepage(struct page *
 	else
 		swap.val = 0;
 
+	/*
+	 * Add inode to shmem_unuse()'s list of swapped-out inodes,
+	 * if it's not already there.  Do it now because we cannot take
+	 * mutex while holding spinlock, and must do so before the page
+	 * is moved to swap cache, when its pagelock no longer protects
+	 * the inode from eviction.  But don't unlock the mutex until
+	 * we've taken the spinlock, because shmem_unuse_inode() will
+	 * prune a !swapped inode from the swaplist under both locks.
+	 */
+	if (swap.val && list_empty(&info->swaplist)) {
+		mutex_lock(&shmem_swaplist_mutex);
+		/* move instead of add in case we're racing */
+		list_move_tail(&info->swaplist, &shmem_swaplist);
+		unlock_mutex = true;
+	}
+
 	spin_lock(&info->lock);
+	if (unlock_mutex)
+		mutex_unlock(&shmem_swaplist_mutex);
+
 	if (index >= info->next_index) {
 		BUG_ON(!(info->flags & SHMEM_TRUNCATE));
 		goto unlock;
@@ -1080,22 +1100,11 @@ static int shmem_writepage(struct page *
 		remove_from_page_cache(page);
 		shmem_swp_set(info, entry, swap.val);
 		shmem_swp_unmap(entry);
-		if (list_empty(&info->swaplist))
-			inode = igrab(inode);
-		else
-			inode = NULL;
 		spin_unlock(&info->lock);
 		swap_shmem_alloc(swap);
 		BUG_ON(page_mapped(page));
 		page_cache_release(page);	/* pagecache ref */
 		swap_writepage(page, wbc);
-		if (inode) {
-			mutex_lock(&shmem_swaplist_mutex);
-			/* move instead of add in case we're racing */
-			list_move_tail(&info->swaplist, &shmem_swaplist);
-			mutex_unlock(&shmem_swaplist_mutex);
-			iput(inode);
-		}
 		return 0;
 	}
 


