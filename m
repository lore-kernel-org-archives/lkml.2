Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1GUQ3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:29:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab1GUQ3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:29:12 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 4/8] btrfs: Warn if direct reclaim tries to writeback pages
Date: Thu, 21 Jul 2011 17:28:46 +0100
Message-Id: <1311265730-5324-5-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1311265730-5324-1-git-send-email-mgorman@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Direct reclaim should never writeback pages. Warn if an attempt is
made. By rights, btrfs should be allowing writepage from kswapd if
it is failing to reclaim pages by any other means but it's outside
the scope of this patch.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 fs/btrfs/disk-io.c |    2 ++
 fs/btrfs/inode.c   |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1ac8db5d..cc9c9cf 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -829,6 +829,8 @@ static int btree_writepage(struct page *page, struct writeback_control *wbc)
 
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 	if (!(current->flags & PF_MEMALLOC)) {
+		WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
+								PF_MEMALLOC);
 		return extent_write_full_page(tree, page,
 					      btree_get_extent, wbc);
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3601f0a..07d6c27 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6259,6 +6259,8 @@ static int btrfs_writepage(struct page *page, struct writeback_control *wbc)
 
 
 	if (current->flags & PF_MEMALLOC) {
+		WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
+								PF_MEMALLOC);
 		redirty_page_for_writepage(wbc, page);
 		unlock_page(page);
 		return 0;
-- 
1.7.3.4

