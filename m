Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab0GSNLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 09:11:36 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39886 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338Ab0GSNLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 09:11:34 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>,
        Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 2/8] vmscan: tracing: Update trace event to track if page reclaim IO is for anon or file pages
Date: Mon, 19 Jul 2010 14:11:24 +0100
Message-Id: <1279545090-19169-3-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1279545090-19169-1-git-send-email-mel@csn.ul.ie>
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useful to distinguish between IO for anon and file pages. This
patch updates
vmscan-tracing-add-trace-event-when-a-page-is-written.patch to include
that information. The patches can be merged together.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/trace/events/vmscan.h |    8 ++++++--
 mm/vmscan.c                   |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index f2da66a..110aea2 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -158,23 +158,27 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 TRACE_EVENT(mm_vmscan_writepage,
 
 	TP_PROTO(struct page *page,
+		int file,
 		int sync_io),
 
-	TP_ARGS(page, sync_io),
+	TP_ARGS(page, file, sync_io),
 
 	TP_STRUCT__entry(
 		__field(struct page *, page)
+		__field(int, file)
 		__field(int, sync_io)
 	),
 
 	TP_fast_assign(
 		__entry->page = page;
+		__entry->file = file;
 		__entry->sync_io = sync_io;
 	),
 
-	TP_printk("page=%p pfn=%lu sync_io=%d",
+	TP_printk("page=%p pfn=%lu file=%d sync_io=%d",
 		__entry->page,
 		page_to_pfn(__entry->page),
+		__entry->file,
 		__entry->sync_io)
 );
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e6ddba9..6587155 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -400,6 +400,7 @@ static pageout_t pageout(struct page *page, struct address_space *mapping,
 			ClearPageReclaim(page);
 		}
 		trace_mm_vmscan_writepage(page,
+			page_is_file_cache(page),
 			sync_writeback == PAGEOUT_IO_SYNC);
 		inc_zone_page_state(page, NR_VMSCAN_WRITE);
 		return PAGE_SUCCESS;
-- 
1.7.1

