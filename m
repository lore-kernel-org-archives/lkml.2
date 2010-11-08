Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab0KHXTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:19:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:15198 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab0KHXTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:19:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,171,1288594800"; 
   d="scan'208";a="571503171"
Message-Id: <20101108231727.275529265@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 09 Nov 2010 07:09:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Christoph Hellwig <hch@lst.de>, Jan Engelhardt <jengelh@medozas.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] writeback: check skipped pages on WB_SYNC_ALL
References: <20101108230916.826791396@intel.com>
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

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next.orig/fs/fs-writeback.c	2010-11-07 22:01:06.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-11-07 22:01:15.000000000 +0800
@@ -527,6 +527,7 @@ static int writeback_sb_inodes(struct su
 			 * buffers.  Skip this inode for now.
 			 */
 			redirty_tail(inode);
+			WARN_ON_ONCE(wbc->sync_mode == WB_SYNC_ALL);
 		}
 		spin_unlock(&inode_lock);
 		iput(inode);


