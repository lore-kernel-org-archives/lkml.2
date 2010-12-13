Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab0LMPMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:12:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:50490 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756997Ab0LMPIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:08:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,336,1288594800"; 
   d="scan'208";a="867612947"
Message-Id: <20101213150329.473271564@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 22:47:12 +0800
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
Subject: [PATCH 26/35] btrfs: wait on too many nr_async_bios
References: <20101213144646.341970461@intel.com>
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

--- linux-next.orig/fs/btrfs/disk-io.c	2010-12-13 21:45:55.000000000 +0800
+++ linux-next/fs/btrfs/disk-io.c	2010-12-13 21:46:20.000000000 +0800
@@ -590,6 +590,7 @@ int btrfs_wq_submit_bio(struct btrfs_fs_
 			extent_submit_bio_hook_t *submit_bio_done)
 {
 	struct async_submit_bio *async;
+	int limit;
 
 	async = kmalloc(sizeof(*async), GFP_NOFS);
 	if (!async)
@@ -617,6 +618,12 @@ int btrfs_wq_submit_bio(struct btrfs_fs_
 
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


