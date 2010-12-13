Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab0LMPKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:10:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:38705 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758003Ab0LMPJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:09:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,336,1288594800"; 
   d="scan'208";a="360909752"
Message-Id: <20101213150330.555135409@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 22:47:21 +0800
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
Subject: [PATCH 35/35] nfs: trace nfs_commit_release()
References: <20101213144646.341970461@intel.com>
Content-Disposition: inline; filename=trace-nfs-commit-release.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/nfs/write.c             |    3 +++
 include/trace/events/nfs.h |   31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

--- linux-next.orig/fs/nfs/write.c	2010-12-13 21:46:23.000000000 +0800
+++ linux-next/fs/nfs/write.c	2010-12-13 21:46:23.000000000 +0800
@@ -1475,6 +1475,9 @@ static void nfs_commit_release(void *cal
 	}
 	nfs_commit_clear_lock(NFS_I(data->inode));
 	nfs_commit_wakeup(NFS_SERVER(data->inode));
+	trace_nfs_commit_release(data->inode,
+				 data->args.offset,
+				 data->args.count);
 	nfs_commitdata_release(calldata);
 }
 
--- linux-next.orig/include/trace/events/nfs.h	2010-12-13 21:46:23.000000000 +0800
+++ linux-next/include/trace/events/nfs.h	2010-12-13 21:46:23.000000000 +0800
@@ -51,6 +51,37 @@ TRACE_EVENT(nfs_commit_unstable_pages,
 	)
 );
 
+TRACE_EVENT(nfs_commit_release,
+
+	TP_PROTO(struct inode *inode,
+		 unsigned long offset,
+		 unsigned long len),
+
+	TP_ARGS(inode, offset, len),
+
+	TP_STRUCT__entry(
+		__array(char, name, 32)
+		__field(unsigned long,	ino)
+		__field(unsigned long,	offset)
+		__field(unsigned long,	len)
+	),
+
+	TP_fast_assign(
+		strncpy(__entry->name,
+			dev_name(inode->i_mapping->backing_dev_info->dev), 32);
+		__entry->ino		= inode->i_ino;
+		__entry->offset		= offset;
+		__entry->len		= len;
+	),
+
+	TP_printk("bdi %s: ino=%lu offset=%lu len=%lu",
+		  __entry->name,
+		  __entry->ino,
+		  __entry->offset,
+		  __entry->len
+	)
+);
+
 
 #endif /* _TRACE_NFS_H */
 


