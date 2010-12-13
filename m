Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab0LMG7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:59:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:4455 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab0LMGtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="867484064"
Message-Id: <20101213064839.047784036@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:06 +0800
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
Subject: [PATCH 17/47] writeback: do uninterruptible sleep in balance_dirty_pages()
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-pause-TASK_UNINTERRUPTIBLE.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comments from Andrew Morton:

Using TASK_INTERRUPTIBLE in balance_dirty_pages() seems wrong.  If it's
going to do that then it must break out if signal_pending(), otherwise
it's pretty much guaranteed to degenerate into a busywait loop.  Plus
we *do* want these processes to appear in D state and to contribute to
load average.

So it should be TASK_UNINTERRUPTIBLE.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next.orig/mm/page-writeback.c	2010-12-08 22:44:26.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-08 22:44:27.000000000 +0800
@@ -673,7 +673,7 @@ pause:
 					  pages_dirtied,
 					  pause);
 		bdi_update_write_bandwidth(bdi, &bw_time, &bw_written);
-		__set_current_state(TASK_INTERRUPTIBLE);
+		__set_current_state(TASK_UNINTERRUPTIBLE);
 		io_schedule_timeout(pause);
 		bdi_update_write_bandwidth(bdi, &bw_time, &bw_written);
 


