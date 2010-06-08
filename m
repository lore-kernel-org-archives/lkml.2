Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab0FHJDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 05:03:38 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54906 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530Ab0FHJC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 05:02:28 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 3/6] tracing, vmscan: Add trace event when a page is written
Date: Tue,  8 Jun 2010 10:02:22 +0100
Message-Id: <1275987745-21708-4-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a trace event for when page reclaim queues a page for IO and
records whether it is synchronous or asynchronous. Excessive synchronous
IO for a process can result in noticeable stalls during direct reclaim.
Excessive IO from page reclaim may indicate that the system is seriously
under provisioned for the amount of dirty pages that exist.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/trace/events/vmscan.h |   23 +++++++++++++++++++++++
 mm/vmscan.c                   |    2 ++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index a331454..b26daa9 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -154,6 +154,29 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__entry->nr_lumpy_dirty,
 		__entry->nr_lumpy_failed)
 );
+
+TRACE_EVENT(mm_vmscan_writepage,
+
+	TP_PROTO(struct page *page,
+		int sync_io),
+
+	TP_ARGS(page, sync_io),
+
+	TP_STRUCT__entry(
+		__field(struct page *, page)
+		__field(int, sync_io)
+	),
+
+	TP_fast_assign(
+		__entry->page = page;
+		__entry->sync_io = sync_io;
+	),
+
+	TP_printk("page=%p pfn=%lu sync_io=%d",
+		__entry->page,
+		page_to_pfn(__entry->page),
+		__entry->sync_io)
+);
 		
 #endif /* _TRACE_VMSCAN_H */
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 25bf05a..58527c4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -399,6 +399,8 @@ static pageout_t pageout(struct page *page, struct address_space *mapping,
 			/* synchronous write or broken a_ops? */
 			ClearPageReclaim(page);
 		}
+		trace_mm_vmscan_writepage(page,
+			sync_writeback == PAGEOUT_IO_SYNC);
 		inc_zone_page_state(page, NR_VMSCAN_WRITE);
 		return PAGE_SUCCESS;
 	}
-- 
1.7.1

