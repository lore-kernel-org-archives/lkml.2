Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab0LMG6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:58:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:28331 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028Ab0LMGtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="583111645"
Message-Id: <20101213064842.427980918@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:33 +0800
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
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 44/47] nfs: limit the range of commits
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=nfs-commit-range.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully this will help limit the number of unstable pages to be synced
at one time, more timely return of the commit request and reduce dirty
throttle fluctuations.

CC: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/nfs/write.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- linux-next.orig/fs/nfs/write.c	2010-12-08 22:54:08.000000000 +0800
+++ linux-next/fs/nfs/write.c	2010-12-08 22:54:13.000000000 +0800
@@ -1333,7 +1333,7 @@ static void nfs_commitdata_release(void 
  */
 static int nfs_commit_rpcsetup(struct list_head *head,
 		struct nfs_write_data *data,
-		int how)
+		int how, pgoff_t offset, pgoff_t count)
 {
 	struct nfs_page *first = nfs_list_entry(head->next);
 	struct inode *inode = first->wb_context->path.dentry->d_inode;
@@ -1365,8 +1365,8 @@ static int nfs_commit_rpcsetup(struct li
 
 	data->args.fh     = NFS_FH(data->inode);
 	/* Note: we always request a commit of the entire inode */
-	data->args.offset = 0;
-	data->args.count  = 0;
+	data->args.offset = offset;
+	data->args.count  = count;
 	data->args.context = get_nfs_open_context(first->wb_context);
 	data->res.count   = 0;
 	data->res.fattr   = &data->fattr;
@@ -1389,7 +1389,8 @@ static int nfs_commit_rpcsetup(struct li
  * Commit dirty pages
  */
 static int
-nfs_commit_list(struct inode *inode, struct list_head *head, int how)
+nfs_commit_list(struct inode *inode, struct list_head *head, int how,
+		pgoff_t offset, pgoff_t count)
 {
 	struct nfs_write_data	*data;
 	struct nfs_page         *req;
@@ -1400,7 +1401,7 @@ nfs_commit_list(struct inode *inode, str
 		goto out_bad;
 
 	/* Set up the argument struct */
-	return nfs_commit_rpcsetup(head, data, how);
+	return nfs_commit_rpcsetup(head, data, how, offset, count);
  out_bad:
 	while (!list_empty(head)) {
 		req = nfs_list_entry(head->next);
@@ -1485,6 +1486,8 @@ static const struct rpc_call_ops nfs_com
 int nfs_commit_inode(struct inode *inode, int how)
 {
 	LIST_HEAD(head);
+	pgoff_t first_index;
+	pgoff_t last_index;
 	int sync = how & FLUSH_SYNC;
 	int res = 0;
 
@@ -1494,9 +1497,14 @@ int nfs_commit_inode(struct inode *inode
 		nfs_commit_wait(NFS_SERVER(inode));
 	spin_lock(&inode->i_lock);
 	res = nfs_scan_commit(inode, &head, 0, 0);
+	if (res) {
+		first_index = nfs_list_entry(head.next)->wb_index;
+		last_index  = nfs_list_entry(head.prev)->wb_index;
+	}
 	spin_unlock(&inode->i_lock);
 	if (res) {
-		int error = nfs_commit_list(inode, &head, how);
+		int error = nfs_commit_list(inode, &head, how, first_index,
+					    last_index - first_index + 1);
 		if (error < 0)
 			return error;
 		if (sync)


