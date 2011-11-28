Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1K1OJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:09:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:26312 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab1K1OJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:09:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,584,1315206000"; 
   d="scan'208";a="79787559"
Message-Id: <20111128140513.275099009@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 28 Nov 2011 21:53:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] writeback: fix dirtied pages accounting on sub-page writes
References: <20111128135338.249672012@intel.com>
Content-Disposition: inline; filename=writeback-accurate-task-dirtied.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dd in 512bytes, generic_perform_write() calls
balance_dirty_pages_ratelimited() 8 times for the same page, but
obviously the page is only dirtied once.

Fix it by accounting tsk->nr_dirtied and bdp_ratelimits at page dirty time.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-11-28 21:23:20.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-11-28 21:23:23.000000000 +0800
@@ -1239,8 +1239,6 @@ void balance_dirty_pages_ratelimited_nr(
 	if (bdi->dirty_exceeded)
 		ratelimit = min(ratelimit, 32 >> (PAGE_SHIFT - 10));
 
-	current->nr_dirtied += nr_pages_dirtied;
-
 	preempt_disable();
 	/*
 	 * This prevents one CPU to accumulate too many dirtied pages without
@@ -1251,12 +1249,9 @@ void balance_dirty_pages_ratelimited_nr(
 	p =  &__get_cpu_var(bdp_ratelimits);
 	if (unlikely(current->nr_dirtied >= ratelimit))
 		*p = 0;
-	else {
-		*p += nr_pages_dirtied;
-		if (unlikely(*p >= ratelimit_pages)) {
-			*p = 0;
-			ratelimit = 0;
-		}
+	else if (unlikely(*p >= ratelimit_pages)) {
+		*p = 0;
+		ratelimit = 0;
 	}
 	/*
 	 * Pick up the dirtied pages by the exited tasks. This avoids lots of
@@ -1749,6 +1744,8 @@ void account_page_dirtied(struct page *p
 		__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
 		__inc_bdi_stat(mapping->backing_dev_info, BDI_DIRTIED);
 		task_io_account_write(PAGE_CACHE_SIZE);
+		current->nr_dirtied++;
+		this_cpu_inc(bdp_ratelimits);
 	}
 }
 EXPORT_SYMBOL(account_page_dirtied);


