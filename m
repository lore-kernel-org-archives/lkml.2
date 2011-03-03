Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1CCIR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:17:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:59999 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab1CCIRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:17:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,257,1297065600"; 
   d="scan'208";a="893290335"
Message-Id: <20110303074949.419321686@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 03 Mar 2011 14:45:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Dave Chinner <david@fromorbit.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
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
Subject: [PATCH 06/27] btrfs: lower the dirty balance poll interval
References: <20110303064505.718671603@intel.com>
Content-Disposition: inline; filename=btrfs-limit-nr-dirtied.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call balance_dirty_pages_ratelimit_nr() on every 32 pages dirtied.

Tests show that original larger intervals can easily make the bdi
dirty limit exceeded on 100 concurrent dd.

CC: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/btrfs/file.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-next.orig/fs/btrfs/file.c	2011-03-02 20:15:19.000000000 +0800
+++ linux-next/fs/btrfs/file.c	2011-03-02 20:35:07.000000000 +0800
@@ -949,9 +949,8 @@ static ssize_t btrfs_file_aio_write(stru
 	}
 
 	iov_iter_init(&i, iov, nr_segs, count, num_written);
-	nrptrs = min((iov_iter_count(&i) + PAGE_CACHE_SIZE - 1) /
-		     PAGE_CACHE_SIZE, PAGE_CACHE_SIZE /
-		     (sizeof(struct page *)));
+	nrptrs = min(DIV_ROUND_UP(iov_iter_count(&i), PAGE_CACHE_SIZE),
+		     min(32UL, PAGE_CACHE_SIZE / sizeof(struct page *)));
 	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
 	if (!pages) {
 		ret = -ENOMEM;


