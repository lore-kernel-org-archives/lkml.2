Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205Ab0LMGtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:49:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:53133 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347Ab0LMGto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="583111653"
Message-Id: <20101213064842.688172491@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:35 +0800
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
Subject: [PATCH 46/47] nfs: trace nfs_commit_unstable_pages()
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=nfs-trace-write_inode.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/nfs/write.c             |   10 ++++--
 include/trace/events/nfs.h |   58 +++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 2 deletions(-)

--- linux-next.orig/fs/nfs/write.c	2010-12-08 22:44:37.000000000 +0800
+++ linux-next/fs/nfs/write.c	2010-12-08 22:44:38.000000000 +0800
@@ -29,6 +29,9 @@
 #include "nfs4_fs.h"
 #include "fscache.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/nfs.h>
+
 #define NFSDBG_FACILITY		NFSDBG_PAGECACHE
 
 #define MIN_POOL_WRITE		(32)
@@ -1566,10 +1569,13 @@ static int nfs_commit_unstable_pages(str
 
 	ret = nfs_commit_inode(inode, flags);
 	if (ret >= 0)
-		return 0;
+		goto out;
+
 out_mark_dirty:
 	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
-	return ret;
+out:
+	trace_nfs_commit_unstable_pages(inode, wbc, flags, ret);
+	return ret >= 0 ? 0 : ret;
 }
 #else
 static int nfs_commit_unstable_pages(struct inode *inode, struct writeback_control *wbc)
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/include/trace/events/nfs.h	2010-12-08 22:44:38.000000000 +0800
@@ -0,0 +1,58 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM nfs
+
+#if !defined(_TRACE_NFS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_NFS_H
+
+#include <linux/nfs_fs.h>
+
+
+TRACE_EVENT(nfs_commit_unstable_pages,
+
+	TP_PROTO(struct inode *inode,
+		 struct writeback_control *wbc,
+		 int sync,
+		 int ret
+	),
+
+	TP_ARGS(inode, wbc, sync, ret),
+
+	TP_STRUCT__entry(
+		__array(char, name, 32)
+		__field(unsigned long,	ino)
+		__field(unsigned long,	npages)
+		__field(unsigned long,	in_commit)
+		__field(unsigned long,	write_chunk)
+		__field(int,		sync)
+		__field(int,		ret)
+	),
+
+	TP_fast_assign(
+		strncpy(__entry->name,
+			dev_name(inode->i_mapping->backing_dev_info->dev), 32);
+		__entry->ino		= inode->i_ino;
+		__entry->npages		= NFS_I(inode)->npages;
+		__entry->in_commit	=
+			atomic_long_read(&NFS_SERVER(inode)->in_commit);
+		__entry->write_chunk	= wbc->per_file_limit;
+		__entry->sync		= sync;
+		__entry->ret		= ret;
+	),
+
+	TP_printk("bdi %s: ino=%lu npages=%ld "
+		  "incommit=%lu write_chunk=%lu sync=%d ret=%d",
+		  __entry->name,
+		  __entry->ino,
+		  __entry->npages,
+		  __entry->in_commit,
+		  __entry->write_chunk,
+		  __entry->sync,
+		  __entry->ret
+	)
+);
+
+
+#endif /* _TRACE_NFS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>


