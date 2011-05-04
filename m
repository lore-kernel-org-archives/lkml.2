Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab1EDJaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:30:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:4162 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab1EDJ2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:28:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,313,1301900400"; 
   d="scan'208";a="917806828"
Message-Id: <20110504091909.904141006@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 04 May 2011 17:17:13 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 6/6] writeback: convert to relative older_than_this in trace events
References: <20110504091707.910929441@intel.com>
Content-Disposition: inline; filename=writeback-trace-older.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a format change that could break established scripts.

But hopefully it's more human friendly to show the relative values like
"30000" (30s old) or "0" (all fresh ones) than long absolute jiffy
numbers.

Note that the initial 30000 or 0 may increase over time as they are now
relative numbers.

CC: Jan Kara <jack@suse.cz>
CC: Dave Chinner <david@fromorbit.com> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/trace/events/writeback.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- linux-next.orig/include/trace/events/writeback.h	2011-05-04 16:09:59.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-05-04 16:10:57.000000000 +0800
@@ -115,7 +115,7 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__field(int, for_reclaim)
 		__field(int, range_cyclic)
 		__field(int, more_io)
-		__field(unsigned long, older_than_this)
+		__field(int, older)
 		__field(long, range_start)
 		__field(long, range_end)
 	),
@@ -130,14 +130,15 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__entry->for_reclaim	= wbc->for_reclaim;
 		__entry->range_cyclic	= wbc->range_cyclic;
 		__entry->more_io	= wbc->more_io;
-		__entry->older_than_this = wbc->older_than_this ?
-						*wbc->older_than_this : 0;
+		__entry->older		= wbc->older_than_this ?
+				(jiffies - *wbc->older_than_this) * 1000 / HZ
+				: -1;
 		__entry->range_start	= (long)wbc->range_start;
 		__entry->range_end	= (long)wbc->range_end;
 	),
 
 	TP_printk("bdi %s: towrt=%ld skip=%ld mode=%d kupd=%d "
-		"bgrd=%d reclm=%d cyclic=%d more=%d older=0x%lx "
+		"bgrd=%d reclm=%d cyclic=%d more=%d older=%d "
 		"start=0x%lx end=0x%lx",
 		__entry->name,
 		__entry->nr_to_write,
@@ -148,7 +149,7 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__entry->for_reclaim,
 		__entry->range_cyclic,
 		__entry->more_io,
-		__entry->older_than_this,
+		__entry->older,
 		__entry->range_start,
 		__entry->range_end)
 )


