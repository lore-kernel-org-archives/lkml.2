Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab0KJCpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:45:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:45736 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab0KJCoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:44:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,176,1288594800"; 
   d="scan'208";a="855968057"
Message-Id: <20101110024224.144021908@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 10 Nov 2010 10:35:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Christoph Hellwig <hch@lst.de>, Jan Engelhardt <jengelh@medozas.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] writeback: check skipped pages on WB_SYNC_ALL
References: <20101110023500.404859581@intel.com>
Content-Disposition: inline; filename=writeback-warn-sync-skipped_pages.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In WB_SYNC_ALL mode, filesystems are not expected to skip dirty pages on
temporal lock contentions or non fatal errors, otherwise sync() will
return without actually syncing the skipped pages. Add a check to
catch possible redirty_page_for_writepage() callers that violate this
expectation.

I'd recommend to keep this check in -mm tree for some time and fixup the
possible warnings before pushing it to upstream.

If some FS triggers this warning and it's non-trivial to fix the FS,
we'll have to work out a sync retry scheme for skipped pages.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-next.orig/fs/fs-writeback.c	2010-11-10 07:04:43.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-11-10 07:11:03.000000000 +0800
@@ -527,6 +527,12 @@ static int writeback_sb_inodes(struct su
 			 * buffers.  Skip this inode for now.
 			 */
 			redirty_tail(inode);
+			/*
+			 * There's no logic to retry skipped pages for sync(),
+			 * filesystems are assumed not to skip dirty pages on
+			 * temporal lock contentions or non fatal errors.
+			 */
+			WARN_ON_ONCE(wbc->sync_mode == WB_SYNC_ALL);
 		}
 		spin_unlock(&inode_lock);
 		iput(inode);


