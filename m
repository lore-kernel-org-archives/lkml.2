Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab0LMGvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:51:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:4455 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab0LMGtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="867484089"
Message-Id: <20101213064842.173584535@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:31 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Dave Chinner <david@fromorbit.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 42/47] nfs: heuristics to avoid commit
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-nfs-should-commit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The heuristics introduced by commit 420e3646 ("NFS: Reduce the number of
unnecessary COMMIT calls") do not work well for large inodes being
actively written to.

Refine the criterion to
- it has gone quiet (all data transfered to server)
- has accumulated >= 4MB data to commit (so it will be large IO)
- too few active commits (hence active IO) in the server

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/nfs/write.c |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

--- linux-next.orig/fs/nfs/write.c	2010-12-09 12:19:24.000000000 +0800
+++ linux-next/fs/nfs/write.c	2010-12-09 12:20:20.000000000 +0800
@@ -1518,17 +1518,38 @@ out_mark_dirty:
 	return res;
 }
 
-static int nfs_commit_unstable_pages(struct inode *inode, struct writeback_control *wbc)
+static bool nfs_should_commit(struct inode *inode,
+			      struct writeback_control *wbc)
 {
+	struct nfs_server *nfss = NFS_SERVER(inode);
 	struct nfs_inode *nfsi = NFS_I(inode);
+	unsigned long npages = nfsi->npages;
+	unsigned long to_commit = nfsi->ncommit;
+	unsigned long in_commit = atomic_long_read(&nfss->in_commit);
+
+	/* no more active writes */
+	if (to_commit == npages)
+		return true;
+
+	/* big enough */
+	if (to_commit >= MIN_WRITEBACK_PAGES)
+		return true;
+
+	/* active commits drop low: kick more IO for the server disk */
+	if (to_commit > in_commit / 2)
+		return true;
+
+	return false;
+}
+
+static int nfs_commit_unstable_pages(struct inode *inode,
+				     struct writeback_control *wbc)
+{
 	int flags = FLUSH_SYNC;
 	int ret = 0;
 
 	if (wbc->sync_mode == WB_SYNC_NONE) {
-		/* Don't commit yet if this is a non-blocking flush and there
-		 * are a lot of outstanding writes for this mapping.
-		 */
-		if (nfsi->ncommit <= (nfsi->npages >> 1))
+		if (!nfs_should_commit(inode, wbc))
 			goto out_mark_dirty;
 
 		/* don't wait for the COMMIT response */


