Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab0LMG44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:56:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:15822 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807Ab0LMGtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:49:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,335,1288594800"; 
   d="scan'208";a="686523124"
Message-Id: <20101213064839.531946766@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 14:43:10 +0800
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
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 21/47] writeback: prevent divide error on tiny HZ
References: <20101213064249.648862451@intel.com>
Content-Disposition: inline; filename=writeback-bandwidth-HZ-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Andrew and Peter:

I do recall hearing of people who set HZ very low, perhaps because their
huge machines were seeing performance problems when the timer tick went
off.  Probably there's no need to do that any more.

But still, we shouldn't hard-wire the (HZ >= 100) assumption if we don't
absolutely need to, and I don't think it is absolutely needed here.

People who do cpu bring-up on very slow FPGAs also lower HZ as far as
possible.

CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2010-12-08 22:44:28.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-08 22:44:28.000000000 +0800
@@ -527,6 +527,7 @@ void bdi_update_write_bandwidth(struct b
 				unsigned long *bw_time,
 				s64 *bw_written)
 {
+	const unsigned long unit_time = max(HZ/100, 1);
 	unsigned long written;
 	unsigned long elapsed;
 	unsigned long bw;
@@ -536,7 +537,7 @@ void bdi_update_write_bandwidth(struct b
 		goto snapshot;
 
 	elapsed = jiffies - *bw_time;
-	if (elapsed < HZ/100)
+	if (elapsed < unit_time)
 		return;
 
 	/*
@@ -550,7 +551,7 @@ void bdi_update_write_bandwidth(struct b
 
 	written = percpu_counter_read(&bdi->bdi_stat[BDI_WRITTEN]) - *bw_written;
 	bw = (HZ * PAGE_CACHE_SIZE * written + elapsed/2) / elapsed;
-	w = min(elapsed / (HZ/100), 128UL);
+	w = min(elapsed / unit_time, 128UL);
 	bdi->write_bandwidth = (bdi->write_bandwidth * (1024-w) + bw * w) >> 10;
 	bdi->write_bandwidth_update_time = jiffies;
 snapshot:


