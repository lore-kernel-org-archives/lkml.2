Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab0GSNMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 09:12:24 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39938 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338Ab0GSNLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 09:11:37 -0400
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
Subject: [PATCH 7/8] writeback: sync old inodes first in background writeback
Date: Mon, 19 Jul 2010 14:11:29 +0100
Message-Id: <1279545090-19169-8-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1279545090-19169-1-git-send-email-mel@csn.ul.ie>
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <fengguang.wu@intel.com>

A background flush work may run for ever. So it's reasonable for it to
mimic the kupdate behavior of syncing old/expired inodes first.

This behavior also makes sense from the perspective of page reclaim.
File pages are added to the inactive list and promoted if referenced
after one recycling. If not referenced, it's very easy for pages to be
cleaned from reclaim context which is inefficient in terms of IO. If
background flush is cleaning pages, it's best it cleans old pages to
help minimise IO from reclaim.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 fs/fs-writeback.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index d5be169..cc81c67 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -612,13 +612,14 @@ static long wb_writeback(struct bdi_writeback *wb,
 		.range_cyclic		= work->range_cyclic,
 	};
 	unsigned long oldest_jif;
+	int expire_interval = msecs_to_jiffies(dirty_expire_interval * 10);
+	int fg_rounds = 0;
 	long wrote = 0;
 	struct inode *inode;
 
-	if (wbc.for_kupdate) {
+	if (wbc.for_kupdate || wbc.for_background) {
 		wbc.older_than_this = &oldest_jif;
-		oldest_jif = jiffies -
-				msecs_to_jiffies(dirty_expire_interval * 10);
+		oldest_jif = jiffies - expire_interval;
 	}
 	if (!wbc.range_cyclic) {
 		wbc.range_start = 0;
@@ -649,6 +650,18 @@ static long wb_writeback(struct bdi_writeback *wb,
 		work->nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 
+		if (work->for_background && expire_interval &&
+		    ++fg_rounds && list_empty(&wb->b_io)) {
+			if (fg_rounds < 10)
+				expire_interval >>= 1;
+			if (expire_interval)
+				oldest_jif = jiffies - expire_interval;
+			else
+				wbc.older_than_this = 0;
+			fg_rounds = 0;
+			continue;
+		}
+
 		/*
 		 * If we consumed everything, see if we have more
 		 */
-- 
1.7.1

