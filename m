Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1LMC1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 21:27:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:41768 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab1LMC1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 21:27:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="85015406"
Date: Tue, 13 Dec 2011 10:17:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Shaohua <shaohua.li@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] writeback: avoid tiny dirty poll intervals
Message-ID: <20111213021740.GA14660@localhost>
References: <20111213021633.GA14193@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111213021633.GA14193@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LKP tests see big 56% regression for the case fio_mmap_randwrite_64k.
Shaohua manages to root cause it to be the much smaller dirty pause times
and hence much more frequent invocations to the IO-less balance_dirty_pages().
Since fio_mmap_randwrite_64k effectively contains both reads and writes,
the more frequent pauses triggered more idling in the cfq IO scheduler.

The solution is to increase pause time all the way up to the max 200ms
in this case, which is found to restore most performance. This will help
reduce CPU overheads in other cases, too.

Note that I don't expect many performance critical workloads to run this
access pattern: the mmap read-on-write is rather inefficient and could
be avoided by doing normal writes syscalls.

CC: Jan Kara <jack@suse.cz>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Li Shaohua <shaohua.li@intel.com>
Tested-by: Li Shaohua <shaohua.li@intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- linux-next.orig/mm/page-writeback.c	2011-12-11 19:53:09.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-12-11 20:08:45.000000000 +0800
@@ -42,6 +42,12 @@
 #define MAX_PAUSE		max(HZ/5, 1)
 
 /*
+ * Try to keep balance_dirty_pages() call intervals higher than this many pages
+ * by raising pause time to max_pause when falls below it.
+ */
+#define DIRTY_POLL_THRESH	(128 >> (PAGE_SHIFT - 10))
+
+/*
  * Estimate write bandwidth at 200ms intervals.
  */
 #define BANDWIDTH_INTERVAL	max(HZ/5, 1)
@@ -1019,6 +1025,23 @@ static long bdi_min_pause(struct backing
 	t = min(t, 1 + max_pause / 2);
 	pages = dirty_ratelimit * t / roundup_pow_of_two(HZ);
 
+	/*
+	 * Tiny nr_dirtied_pause is found to hurt I/O performance in the test
+	 * case fio-mmap-randwrite-64k, which does 16*{sync read, async write}.
+	 * When the 16 consecutive reads are often interrupted by some dirty
+	 * throttling pause during the async writes, cfq will go into idles
+	 * (deadline is fine). So push nr_dirtied_pause as high as possible
+	 * until reaches DIRTY_POLL_THRESH=32 pages.
+	 */
+	if (pages < DIRTY_POLL_THRESH) {
+		t = max_pause;
+		pages = dirty_ratelimit * t / roundup_pow_of_two(HZ);
+		if (pages > DIRTY_POLL_THRESH) {
+			pages = DIRTY_POLL_THRESH;
+			t = HZ * DIRTY_POLL_THRESH / dirty_ratelimit;
+		}
+	}
+
 	pause = HZ * pages / (task_ratelimit + 1);
 	if (pause > max_pause) {
 		t = max_pause;
@@ -1029,7 +1052,7 @@ static long bdi_min_pause(struct backing
 	/*
 	 * The minimal pause time will normally be half the target pause time.
 	 */
-	return 1 + t / 2;
+	return pages >= DIRTY_POLL_THRESH ? 1 + t / 2 : t;
 }
 
 /*
