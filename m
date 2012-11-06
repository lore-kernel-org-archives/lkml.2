Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441Ab2KFBez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 20:34:55 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:46606 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372Ab2KFBey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 20:34:54 -0500
Date: Mon, 5 Nov 2012 17:34:56 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tmpfs: change final i_blocks BUG to WARNING
Message-ID: <alpine.LNX.2.00.1211051732591.963@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under a particular load on one machine, I have hit shmem_evict_inode()'s
BUG_ON(inode->i_blocks), enough times to narrow it down to a particular
race between swapout and eviction.

It comes from the "if (freed > 0)" asymmetry in shmem_recalc_inode(),
and the lack of coherent locking between mapping's nrpages and shmem's
swapped count.  There's a window in shmem_writepage(), between lowering
nrpages in shmem_delete_from_page_cache() and then raising swapped count,
when the freed count appears to be +1 when it should be 0, and then the
asymmetry stops it from being corrected with -1 before hitting the BUG.

One answer is coherent locking: using tree_lock throughout, without
info->lock; reasonable, but the raw_spin_lock in percpu_counter_add()
on used_blocks makes that messier than expected.  Another answer may be
a further effort to eliminate the weird shmem_recalc_inode() altogether,
but previous attempts at that failed.

So far undecided, but for now change the BUG_ON to WARN_ON:
in usual circumstances it remains a useful consistency check.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@vger.kernel.org
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.7-rc4/mm/shmem.c	2012-10-14 16:16:58.361309122 -0700
+++ linux/mm/shmem.c	2012-11-01 14:31:04.288185742 -0700
@@ -643,7 +643,7 @@ static void shmem_evict_inode(struct ino
 		kfree(info->symlink);
 
 	simple_xattrs_free(&info->xattrs);
-	BUG_ON(inode->i_blocks);
+	WARN_ON(inode->i_blocks);
 	shmem_free_inode(inode->i_sb);
 	clear_inode(inode);
 }
