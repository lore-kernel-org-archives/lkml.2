Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1HJKs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 06:48:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab1HJKr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 06:47:26 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Johannes Weiner <jweiner@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3/7] xfs: Warn if direct reclaim tries to writeback pages
Date: Wed, 10 Aug 2011 11:47:16 +0100
Message-Id: <1312973240-32576-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1312973240-32576-1-git-send-email-mgorman@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Direct reclaim should never writeback pages. For now, handle the
situation and warn about it. Ultimately, this will be a BUG_ON.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 fs/xfs/linux-2.6/xfs_aops.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 79ce38b..afea9cd 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -930,11 +930,10 @@ xfs_vm_writepage(
 	 * random callers for direct reclaim or memcg reclaim.  We explicitly
 	 * allow reclaim from kswapd as the stack usage there is relatively low.
 	 *
-	 * This should really be done by the core VM, but until that happens
-	 * filesystems like XFS, btrfs and ext4 have to take care of this
-	 * by themselves.
+	 * This should never happen except in the case of a VM regression so
+	 * warn about it.
 	 */
-	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
+	if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC))
 		goto redirty;
 
 	/*
-- 
1.7.3.4

