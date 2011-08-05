Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1HEDup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 23:50:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:33125 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967Ab1HEDun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 23:50:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,320,1309762800"; 
   d="scan'208";a="38087607"
Date: Fri, 5 Aug 2011 11:50:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@linux.intel.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] readahead: add comments on PG_readahead
Message-ID: <20110805035040.GB11532@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add comments to clarify the easily misunderstood PG_readahead timing.

PG_readahead is a trigger to say, when you get this far, it's time to
think about kicking off the _next_ readahead.            -- Hugh

CC: Hugh Dickins <hughd@google.com>
CC: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/readahead.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- linux-next.orig/mm/readahead.c	2011-08-05 10:53:01.000000000 +0800
+++ linux-next/mm/readahead.c	2011-08-05 11:40:06.000000000 +0800
@@ -185,6 +185,14 @@ __do_page_cache_readahead(struct address
 			break;
 		page->index = page_offset;
 		list_add(&page->lru, &page_pool);
+		/*
+		 * set PG_readahead to trigger the _next_ ASYNC readahead.
+		 *
+		 *     |----------------- nr_to_read ---------------->|
+		 *     |==================#===========================|
+		 *                        |<---- lookahead_size ------|
+		 *       PG_readahead mark^
+		 */
 		if (page_idx == nr_to_read - lookahead_size)
 			SetPageReadahead(page);
 		ret++;
@@ -321,6 +329,25 @@ static unsigned long get_next_ra_size(st
  * indicator. The flag won't be set on already cached pages, to avoid the
  * readahead-for-nothing fuss, saving pointless page cache lookups.
  *
+ * A typical readahead time chart for a sequential read stream. Note that when
+ * read(2) hits the PG_readahead mark, a new readahead will be started and the
+ * PG_readahead mark will be "pushed forward" by clearing the old PG_readahead
+ * and setting a new PG_readahead in the new readahead window.
+ *
+ * t0
+ * t1 +#__                         ==>  SYNC readahead triggered by page miss
+ * t2 -+__#_______                 ==> ASYNC readahead triggered by PG_readahead
+ * t3 --+_#_______
+ * t4 ---+#_______
+ * t5 ----+_______#_______________ ==> ASYNC readahead triggered by PG_readahead
+ * t6 -----+______#_______________
+ * t7 ------+_____#_______________
+ *
+ * [-] accessed page
+ * [+] the page read(2) is accessing
+ * [#] the PG_readahead mark
+ * [_] readahead page (newly brought into page cache but not yet accessed)
+ *
  * prev_pos tracks the last visited byte in the _previous_ read request.
  * It should be maintained by the caller, and will be used for detecting
  * small random reads. Note that the readahead algorithm checks loosely
