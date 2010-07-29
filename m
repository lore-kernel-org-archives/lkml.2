Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab0G2MXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 08:23:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:34429 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049Ab0G2MXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 08:23:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,280,1278313200"; 
   d="scan'208";a="590895255"
Message-Id: <20100729121423.754455334@intel.com>
User-Agent: quilt/0.48-1
Date: Thu, 29 Jul 2010 19:51:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
cc: "linux-mm@kvack.org" <linux-mm@kvack.org>
cc: Dave Chinner <david@fromorbit.com>
cc: Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>
cc: Rik van Riel <riel@redhat.com>
cc: Johannes Weiner <hannes@cmpxchg.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>
cc: Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 5/5] vmscan: transfer async file writeback to the flusher
References: <20100729115142.102255590@intel.com>
Content-Disposition: inline; filename=vmscan-writeback-inode-page.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This relays all ASYNC file writeback IOs to the flusher threads.
The lesser SYNC pageout()s will work as before (as a last resort).

It's a minimal prototype implementation and barely runs without panic.
It potentially requires lots of more work to go stable. 

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/vmscan.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- linux-next.orig/mm/vmscan.c	2010-07-29 17:07:07.000000000 +0800
+++ linux-next/mm/vmscan.c	2010-07-29 17:09:16.000000000 +0800
@@ -379,6 +379,13 @@ static pageout_t pageout(struct page *pa
 	}
 	if (mapping->a_ops->writepage == NULL)
 		return PAGE_ACTIVATE;
+
+	if (sync_writeback == PAGEOUT_IO_ASYNC &&
+	    page_is_file_cache(page)) {
+		bdi_start_inode_writeback(mapping->host, page->index);
+		return PAGE_KEEP;
+	}
+
 	if (!may_write_to_queue(mapping->backing_dev_info))
 		return PAGE_KEEP;
 
@@ -1366,7 +1373,6 @@ shrink_inactive_list(unsigned long nr_to
 				list_add(&page->lru, &putback_list);
 			}
 
-			wakeup_flusher_threads(laptop_mode ? 0 : nr_dirty);
 			congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 			/*


