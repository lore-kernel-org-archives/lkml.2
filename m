Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab0F2Lf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 07:35:57 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42896 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755743Ab0F2Le6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 07:34:58 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 13/14] fs,btrfs: Allow kswapd to writeback pages
Date: Tue, 29 Jun 2010 12:34:47 +0100
Message-Id: <1277811288-5195-14-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277811288-5195-1-git-send-email-mel@csn.ul.ie>
References: <1277811288-5195-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As only kswapd and memcg are writing back pages, there should be no
danger of overflowing the stack. Allow the writing back of dirty pages
in btrfs from the VM.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 fs/btrfs/disk-io.c |   21 +--------------------
 1 files changed, 1 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 34f7c37..e4aa547 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -696,26 +696,7 @@ static int btree_writepage(struct page *page, struct writeback_control *wbc)
 	int was_dirty;
 
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
-	if (!(current->flags & PF_MEMALLOC)) {
-		return extent_write_full_page(tree, page,
-					      btree_get_extent, wbc);
-	}
-
-	redirty_page_for_writepage(wbc, page);
-	eb = btrfs_find_tree_block(root, page_offset(page),
-				      PAGE_CACHE_SIZE);
-	WARN_ON(!eb);
-
-	was_dirty = test_and_set_bit(EXTENT_BUFFER_DIRTY, &eb->bflags);
-	if (!was_dirty) {
-		spin_lock(&root->fs_info->delalloc_lock);
-		root->fs_info->dirty_metadata_bytes += PAGE_CACHE_SIZE;
-		spin_unlock(&root->fs_info->delalloc_lock);
-	}
-	free_extent_buffer(eb);
-
-	unlock_page(page);
-	return 0;
+	return extent_write_full_page(tree, page, btree_get_extent, wbc);
 }
 
 static int btree_writepages(struct address_space *mapping,
-- 
1.7.1

