Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab1KUNP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:15:57 -0500
Received: from mga03.intel.com ([143.182.124.21]:51780 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab1KUNPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:15:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,547,1315206000"; 
   d="scan'208";a="77539455"
Message-Id: <20111121131215.905222115@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 21:03:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
to: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Hellwig <hch@lst.de>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] writeback: fix dirtied pages accounting on sub-page writes
References: <20111121130342.211953629@intel.com>
Content-Disposition: inline; filename=writeback-accurate-task-dirtied.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dd in 512bytes, generic_perform_write() calls
balance_dirty_pages_ratelimited() 8 times for the same page, but
obviously the page is only dirtied once.

Fix it by accounting nr_dirtied at page dirty time.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-next.orig/mm/page-writeback.c	2011-11-17 20:57:13.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-11-17 20:57:15.000000000 +0800
@@ -1224,8 +1224,6 @@ void balance_dirty_pages_ratelimited_nr(
 	if (bdi->dirty_exceeded)
 		ratelimit = min(ratelimit, 32 >> (PAGE_SHIFT - 10));
 
-	current->nr_dirtied += nr_pages_dirtied;
-
 	preempt_disable();
 	/*
 	 * This prevents one CPU to accumulate too many dirtied pages without
@@ -1734,6 +1732,7 @@ void account_page_dirtied(struct page *p
 		__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
 		__inc_bdi_stat(mapping->backing_dev_info, BDI_DIRTIED);
 		task_io_account_write(PAGE_CACHE_SIZE);
+		current->nr_dirtied++;
 	}
 }
 EXPORT_SYMBOL(account_page_dirtied);


