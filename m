Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab1CCIXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:23:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:10245 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab1CCIR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:17:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,257,1297065600"; 
   d="scan'208";a="715563052"
Message-Id: <20110303074949.543938784@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 03 Mar 2011 14:45:12 +0800
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
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Andrea Righi <arighi@develer.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/27] btrfs: wait on too many nr_async_bios
References: <20110303064505.718671603@intel.com>
Content-Disposition: inline; filename=btrfs-nr_async_bios-wait.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tests show that btrfs is repeatedly moving _all_ PG_dirty pages into
PG_writeback state. It's desirable to have some limit on the number of
writeback pages.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/btrfs/disk-io.c |    7 +++++++
 1 file changed, 7 insertions(+)

before patch:
	http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/tests/3G/btrfs-1dd-1M-8p-2952M-2.6.37-rc5+-2010-12-08-21-30/vmstat-dirty-300.png

after patch:
	http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/tests/3G/btrfs-1dd-1M-8p-2952M-2.6.37-rc5+-2010-12-08-21-14/vmstat-dirty-300.png

--- linux-next.orig/fs/btrfs/disk-io.c	2011-03-03 14:03:39.000000000 +0800
+++ linux-next/fs/btrfs/disk-io.c	2011-03-03 14:03:40.000000000 +0800
@@ -616,6 +616,7 @@ int btrfs_wq_submit_bio(struct btrfs_fs_
 			extent_submit_bio_hook_t *submit_bio_done)
 {
 	struct async_submit_bio *async;
+	int limit;
 
 	async = kmalloc(sizeof(*async), GFP_NOFS);
 	if (!async)
@@ -643,6 +644,12 @@ int btrfs_wq_submit_bio(struct btrfs_fs_
 
 	btrfs_queue_worker(&fs_info->workers, &async->work);
 
+	limit = btrfs_async_submit_limit(fs_info);
+
+	if (atomic_read(&fs_info->nr_async_bios) > limit)
+		wait_event(fs_info->async_submit_wait,
+			   (atomic_read(&fs_info->nr_async_bios) < limit));
+
 	while (atomic_read(&fs_info->async_submit_draining) &&
 	      atomic_read(&fs_info->nr_async_submits)) {
 		wait_event(fs_info->async_submit_wait,


