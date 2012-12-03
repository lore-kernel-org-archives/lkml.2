Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab2LCO53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:57:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43549 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932094Ab2LCOfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:35:47 -0500
Message-Id: <20121203143149.542645375@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:03 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 17/89] tmpfs: change final i_blocks BUG to WARNING
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 0f3c42f522dc1ad7e27affc0a4aa8c790bce0a66 upstream.

Under a particular load on one machine, I have hit shmem_evict_inode()'s
BUG_ON(inode->i_blocks), enough times to narrow it down to a particular
race between swapout and eviction.

It comes from the "if (freed > 0)" asymmetry in shmem_recalc_inode(),
and the lack of coherent locking between mapping's nrpages and shmem's
swapped count.  There's a window in shmem_writepage(), between lowering
nrpages in shmem_delete_from_page_cache() and then raising swapped
count, when the freed count appears to be +1 when it should be 0, and
then the asymmetry stops it from being corrected with -1 before hitting
the BUG.

One answer is coherent locking: using tree_lock throughout, without
info->lock; reasonable, but the raw_spin_lock in percpu_counter_add() on
used_blocks makes that messier than expected.  Another answer may be a
further effort to eliminate the weird shmem_recalc_inode() altogether,
but previous attempts at that failed.

So far undecided, but for now change the BUG_ON to WARN_ON: in usual
circumstances it remains a useful consistency check.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -595,7 +595,7 @@ static void shmem_evict_inode(struct ino
 		kfree(xattr->name);
 		kfree(xattr);
 	}
-	BUG_ON(inode->i_blocks);
+	WARN_ON(inode->i_blocks);
 	shmem_free_inode(inode->i_sb);
 	end_writeback(inode);
 }


