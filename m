Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab1CCITv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:19:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:13732 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962Ab1CCIR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:17:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,257,1297065600"; 
   d="scan'208";a="715563068"
Message-Id: <20110303074950.979428322@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 03 Mar 2011 14:45:23 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Dave Chinner <david@fromorbit.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
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
Subject: [PATCH 18/27] writeback: enforce 1/4 gap between the dirty/background thresholds
References: <20110303064505.718671603@intel.com>
Content-Disposition: inline; filename=writeback-fix-oversize-background-thresh.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change is virtually a no-op for the majority users that use the
default 10/20 background/dirty ratios. For others don't know why they
are setting background ratio close enough to dirty ratio. Someone must
set background ratio equal to dirty ratio, but no one seems to notice or
complain that it's then silently halved under the hood..

The other solution is to return -EIO when setting a too large background
threshold or a too small dirty threshold. However that could possibly
break some disordered usage scenario, eg.

	echo 10 > /proc/sys/vm/dirty_ratio
	echo  5 > /proc/sys/vm/dirty_background_ratio

The first echo will fail because the background ratio is still 10.
Such order dependent behavior seems disgusting for end users.

CC: Peter Zijlstra <a.p.zijlstra@chello.nl> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-03-02 17:04:16.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-03-02 17:06:17.000000000 +0800
@@ -422,8 +422,14 @@ void global_dirty_limits(unsigned long *
 	else
 		background = (dirty_background_ratio * available_memory) / 100;
 
-	if (background >= dirty)
-		background = dirty / 2;
+	/*
+	 * Ensure at least 1/4 gap between background and dirty thresholds, so
+	 * that when dirty throttling starts at (background + dirty)/2, it's
+	 * below or at the entrance of the soft dirty throttle scope.
+	 */
+	if (background > dirty - dirty / (DIRTY_SCOPE / 2))
+		background = dirty - dirty / (DIRTY_SCOPE / 2);
+
 	tsk = current;
 	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
 		background += background / 4;


