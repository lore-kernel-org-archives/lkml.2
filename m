Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab0GSNLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 09:11:41 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39930 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932484Ab0GSNLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 09:11:37 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>,
        Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 6/8] fs,xfs: Allow kswapd to writeback pages
Date: Mon, 19 Jul 2010 14:11:28 +0100
Message-Id: <1279545090-19169-7-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1279545090-19169-1-git-send-email-mel@csn.ul.ie>
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As only kswapd and memcg are writing back pages, there should be no
danger of overflowing the stack. Allow the writing back of dirty pages
in xfs from the VM.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 fs/xfs/linux-2.6/xfs_aops.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 34640d6..4c89db3 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1333,21 +1333,6 @@ xfs_vm_writepage(
 	trace_xfs_writepage(inode, page, 0);
 
 	/*
-	 * Refuse to write the page out if we are called from reclaim context.
-	 *
-	 * This is primarily to avoid stack overflows when called from deep
-	 * used stacks in random callers for direct reclaim, but disabling
-	 * reclaim for kswap is a nice side-effect as kswapd causes rather
-	 * suboptimal I/O patters, too.
-	 *
-	 * This should really be done by the core VM, but until that happens
-	 * filesystems like XFS, btrfs and ext4 have to take care of this
-	 * by themselves.
-	 */
-	if (current->flags & PF_MEMALLOC)
-		goto out_fail;
-
-	/*
 	 * We need a transaction if:
 	 *  1. There are delalloc buffers on the page
 	 *  2. The page is uptodate and we have unmapped buffers
-- 
1.7.1

