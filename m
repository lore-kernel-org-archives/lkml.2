Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab0LMGxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:53:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:28331 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374Ab0LMGto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="686523149"
Message-Id: <20101213064842.559030592@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:34 +0800
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
Subject: [PATCH 45/47] nfs: adapt congestion threshold to dirty threshold
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=nfs-congestion-thresh.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nfs_congestion_kb is to control the max allowed writeback and in-commit
pages. It's not reasonable for them to outnumber dirty and to-commit
pages. So each of them should not take more than 1/4 dirty threshold.

Considering that nfs_init_writepagecache() is called on fresh boot,
at the time dirty_thresh is much higher than the real dirty limit after
lots of user space memory consumptions, use 1/8 instead.

We might update nfs_congestion_kb when global dirty limit is changed
at runtime, but whatever, do it simple first.

CC: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/nfs/write.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- linux-next.orig/fs/nfs/write.c	2010-12-08 22:44:37.000000000 +0800
+++ linux-next/fs/nfs/write.c	2010-12-08 22:44:37.000000000 +0800
@@ -1698,6 +1698,9 @@ out:
 
 int __init nfs_init_writepagecache(void)
 {
+	unsigned long background_thresh;
+	unsigned long dirty_thresh;
+
 	nfs_wdata_cachep = kmem_cache_create("nfs_write_data",
 					     sizeof(struct nfs_write_data),
 					     0, SLAB_HWCACHE_ALIGN,
@@ -1735,6 +1738,16 @@ int __init nfs_init_writepagecache(void)
 	if (nfs_congestion_kb > 256*1024)
 		nfs_congestion_kb = 256*1024;
 
+	/*
+	 * Limit to 1/8 dirty threshold, so that writeback+in_commit pages
+	 * won't overnumber dirty+to_commit pages.
+	 */
+	global_dirty_limits(&background_thresh, &dirty_thresh);
+	dirty_thresh <<= PAGE_SHIFT - 10;
+
+	if (nfs_congestion_kb > dirty_thresh / 8)
+		nfs_congestion_kb = dirty_thresh / 8;
+
 	return 0;
 }
 


