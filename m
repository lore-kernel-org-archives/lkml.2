Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab0LMG6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:58:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:15833 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab0LMGtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="686523122"
Message-Id: <20101213064838.403158401@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:01 +0800
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
Subject: [PATCH 12/47] writeback: make reasonable gap between the dirty/background thresholds
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-fix-oversize-background-thresh.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change is virtually a no-op for the majority users that use the
default 10/20 background/dirty ratios. For others don't know why they
are setting background ratio close enough to dirty ratio. Someone must
set background ratio equal to dirty ratio, but no one seems to notice or
complain that it's then silently halved under the hood..

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-12-08 22:44:25.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-08 22:44:25.000000000 +0800
@@ -403,8 +403,15 @@ void global_dirty_limits(unsigned long *
 	else
 		background = (dirty_background_ratio * available_memory) / 100;
 
-	if (background >= dirty)
-		background = dirty / 2;
+	/*
+	 * Ensure at least 1/4 gap between background and dirty thresholds, so
+	 * that when dirty throttling starts at (background + dirty)/2, it's at
+	 * the entrance of bdi soft throttle threshold, so as to avoid being
+	 * hard throttled.
+	 */
+	if (background > dirty - dirty * 2 / BDI_SOFT_DIRTY_LIMIT)
+		background = dirty - dirty * 2 / BDI_SOFT_DIRTY_LIMIT;
+
 	tsk = current;
 	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
 		background += background / 4;


