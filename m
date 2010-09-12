Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab0ILPzg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 11:55:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:35314 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab0ILPzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 11:55:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,355,1280732400"; 
   d="scan'208";a="656512014"
Message-Id: <20100912155203.047338681@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 12 Sep 2010 23:49:48 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Jan Kara <jack@suse.cz>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Li Shaohua <shaohua.li@intel.com>
Subject: [PATCH 03/17] writeback: per-task rate limit to balance_dirty_pages()
References: <20100912154945.758129106@intel.com>
Content-Disposition: inline; filename=writeback-per-task-dirty-count.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to limit the dirty throttle pause time in range (10ms, 100ms),
by controlling how many pages are dirtied before doing a throttle pause.

The dirty count will be directly billed to the task struct. Slow start
and quick back off is employed, so that the stable range will be biased
towards 10ms. Another intention is for fine timing control of slow
devices, which may need to pause for 100ms for several pages.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/sched.h |    7 +++++++
 mm/page-writeback.c   |   31 ++++++++++++++-----------------
 2 files changed, 21 insertions(+), 17 deletions(-)

--- linux-next.orig/include/linux/sched.h	2010-09-12 13:10:54.000000000 +0800
+++ linux-next/include/linux/sched.h	2010-09-12 13:16:20.000000000 +0800
@@ -1455,6 +1455,13 @@ struct task_struct {
 	int make_it_fail;
 #endif
 	struct prop_local_single dirties;
+	/*
+	 * when (nr_dirtied >= nr_dirtied_pause), it's time to call
+	 * balance_dirty_pages() for some dirty throttling pause
+	 */
+	int nr_dirtied;
+	int nr_dirtied_pause;
+
 #ifdef CONFIG_LATENCYTOP
 	int latency_record_count;
 	struct latency_record latency_record[LT_SAVECOUNT];
--- linux-next.orig/mm/page-writeback.c	2010-09-12 13:10:54.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-09-12 13:12:48.000000000 +0800
@@ -529,6 +529,12 @@ static void balance_dirty_pages(struct a
 		pause = HZ * (pages_dirtied << PAGE_CACHE_SHIFT) / (bw + 1);
 		pause = clamp_val(pause, 1, HZ/5);
 
+		if (pause > HZ/10) {
+			current->nr_dirtied_pause >>= 1;
+			current->nr_dirtied_pause++;
+		} else if (pause < HZ/100)
+			current->nr_dirtied_pause++;
+
 		__set_current_state(TASK_INTERRUPTIBLE);
 		io_schedule_timeout(pause);
 
@@ -570,8 +576,6 @@ void set_page_dirty_balance(struct page 
 	}
 }
 
-static DEFINE_PER_CPU(unsigned long, bdp_ratelimits) = 0;
-
 /**
  * balance_dirty_pages_ratelimited_nr - balance dirty memory state
  * @mapping: address_space which was dirtied
@@ -589,28 +593,21 @@ static DEFINE_PER_CPU(unsigned long, bdp
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
 					unsigned long nr_pages_dirtied)
 {
-	unsigned long ratelimit;
-	unsigned long *p;
+	if (!current->nr_dirtied_pause)
+		current->nr_dirtied_pause =
+			mapping->backing_dev_info->dirty_exceeded ?
+			8 : ratelimit_pages;
 
-	ratelimit = ratelimit_pages;
-	if (mapping->backing_dev_info->dirty_exceeded)
-		ratelimit = 8;
+	current->nr_dirtied += nr_pages_dirtied;
 
 	/*
 	 * Check the rate limiting. Also, we do not want to throttle real-time
 	 * tasks in balance_dirty_pages(). Period.
 	 */
-	preempt_disable();
-	p =  &__get_cpu_var(bdp_ratelimits);
-	*p += nr_pages_dirtied;
-	if (unlikely(*p >= ratelimit)) {
-		ratelimit = *p;
-		*p = 0;
-		preempt_enable();
-		balance_dirty_pages(mapping, ratelimit);
-		return;
+	if (current->nr_dirtied >= current->nr_dirtied_pause) {
+		balance_dirty_pages(mapping, current->nr_dirtied);
+		current->nr_dirtied = 0;
 	}
-	preempt_enable();
 }
 EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
 


