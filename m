Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804Ab2KVWT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:19:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:49361 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab2KVSia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 036/171] tmpfs: change final i_blocks BUG to WARNING
Date: Wed, 21 Nov 2012 16:39:42 -0800
Message-Id: <20121122004036.994153524@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


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


