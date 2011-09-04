Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab1IDCOZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 22:14:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:49417 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab1IDCN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 22:13:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,326,1312182000"; 
   d="scan'208";a="45377090"
Message-Id: <20110904020916.588150387@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 04 Sep 2011 09:53:20 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@lst.de>
CC: Dave Chinner <david@fromorbit.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Andrea Righi <arighi@develer.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/18] writeback: charge leaked page dirties to active tasks
References: <20110904015305.367445271@intel.com>
Content-Disposition: inline; filename=writeback-save-leaks-at-exit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a years long problem that a large number of short-lived dirtiers
(eg. gcc instances in a fast kernel build) may starve long-run dirtiers
(eg. dd) as well as pushing the dirty pages to the global hard limit.

The solution is to charge the pages dirtied by the exited gcc to the
other random gcc/dd instances. It sounds not perfect, however should
behave good enough in practice.

CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/writeback.h |    2 ++
 kernel/exit.c             |    2 ++
 mm/page-writeback.c       |   12 ++++++++++++
 3 files changed, 16 insertions(+)

--- linux-next.orig/include/linux/writeback.h	2011-08-29 19:14:22.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-08-29 19:14:32.000000000 +0800
@@ -7,6 +7,8 @@
 #include <linux/sched.h>
 #include <linux/fs.h>
 
+DECLARE_PER_CPU(int, dirty_leaks);
+
 /*
  * The 1/4 region under the global dirty thresh is for smooth dirty throttling:
  *
--- linux-next.orig/mm/page-writeback.c	2011-08-29 19:14:22.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-08-29 19:14:32.000000000 +0800
@@ -1237,6 +1237,7 @@ void set_page_dirty_balance(struct page 
 }
 
 static DEFINE_PER_CPU(int, bdp_ratelimits);
+DEFINE_PER_CPU(int, dirty_leaks) = 0;
 
 /**
  * balance_dirty_pages_ratelimited_nr - balance dirty memory state
@@ -1285,6 +1286,17 @@ void balance_dirty_pages_ratelimited_nr(
 			ratelimit = 0;
 		}
 	}
+	/*
+	 * Pick up the dirtied pages by the exited tasks. This avoids lots of
+	 * short-lived tasks (eg. gcc invocations in a kernel build) escaping
+	 * the dirty throttling and livelock other long-run dirtiers.
+	 */
+	p = &__get_cpu_var(dirty_leaks);
+	if (*p > 0 && current->nr_dirtied < ratelimit) {
+		nr_pages_dirtied = min(*p, ratelimit - current->nr_dirtied);
+		*p -= nr_pages_dirtied;
+		current->nr_dirtied += nr_pages_dirtied;
+	}
 	preempt_enable();
 
 	if (unlikely(current->nr_dirtied >= ratelimit))
--- linux-next.orig/kernel/exit.c	2011-08-26 16:19:27.000000000 +0800
+++ linux-next/kernel/exit.c	2011-08-29 19:14:22.000000000 +0800
@@ -1044,6 +1044,8 @@ NORET_TYPE void do_exit(long code)
 	validate_creds_for_do_exit(tsk);
 
 	preempt_disable();
+	if (tsk->nr_dirtied)
+		__this_cpu_add(dirty_leaks, tsk->nr_dirtied);
 	exit_rcu();
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;


