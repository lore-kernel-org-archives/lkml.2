Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab1CCIZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:25:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:59999 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab1CCIRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:17:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,257,1297065600"; 
   d="scan'208";a="893290340"
Message-Id: <20110303074949.935848193@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 03 Mar 2011 14:45:15 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Dave Chinner <david@fromorbit.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Andrea Righi <arighi@develer.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/27] nfs: limit the commit size to reduce fluctuations
References: <20110303064505.718671603@intel.com>
Content-Disposition: inline; filename=nfs-more-smooth-commit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the commit size to 1/8 dirty control scope, so that the arrival of
one commit will not knock the overall dirty pages off the scope.

CC: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/nfs/write.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

After patch, there are still drop offs from the control scope,

http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/NFS/nfs-1dd-1M-8p-2945M-20%25-2.6.38-rc6-dt6+-2011-02-22-21-09/balance_dirty_pages-pages.png

due to bursty arrival of commits:

http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/NFS/nfs-1dd-1M-8p-2945M-20%25-2.6.38-rc6-dt6+-2011-02-22-21-09/nfs-commit.png

--- linux-next.orig/fs/nfs/write.c	2011-03-02 20:39:01.000000000 +0800
+++ linux-next/fs/nfs/write.c	2011-03-02 20:39:01.000000000 +0800
@@ -1492,9 +1492,10 @@ static int nfs_commit_unstable_pages(str
 
 	if (wbc->sync_mode == WB_SYNC_NONE) {
 		/* Don't commit yet if this is a non-blocking flush and there
-		 * are a lot of outstanding writes for this mapping.
+		 * are a lot of outstanding writes for this mapping, until
+		 * collected enough pages to commit.
 		 */
-		if (nfsi->ncommit <= (nfsi->npages >> 1))
+		if (nfsi->ncommit <= nfsi->npages / 32 /* DIRTY_MARGIN */)
 			goto out_mark_dirty;
 
 		/* don't wait for the COMMIT response */


