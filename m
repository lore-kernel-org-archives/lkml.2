Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1DPODz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:03:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:20815 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab1DPODd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:03:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,223,1301900400"; 
   d="scan'208";a="910491960"
Message-Id: <20110416134333.176703613@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 16 Apr 2011 21:25:52 +0800
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
Subject: [PATCH 06/12] writeback: enforce 1/4 gap between the dirty/background thresholds
References: <20110416132546.765212221@intel.com>
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

--- linux-next.orig/mm/page-writeback.c	2011-04-13 17:18:13.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-04-13 17:18:13.000000000 +0800
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
+	if (background > dirty - dirty / DIRTY_FULL_SCOPE)
+		background = dirty - dirty / DIRTY_FULL_SCOPE;
+
 	tsk = current;
 	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
 		background += background / 4;


