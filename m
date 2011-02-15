Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab1BOWin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 17:38:43 -0500
Received: from relay2.sgi.com ([192.48.179.30]:41938 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755572Ab1BOWil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 17:38:41 -0500
Date: Tue, 15 Feb 2011 16:38:40 -0600
From: Jack Steiner <steiner@sgi.com>
To: linux-mm@kvack.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] - Improve drain pages performance on large systems
Message-ID: <20110215223840.GA27420@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Heavy swapping within a cpuset causes frequent calls to drain_all_pages().
This sends IPIs to all cpus to free PCP pages. In most cases, there are
no pages to be freed on cpus outside of the swapping cpuset.

Add checks to minimize locking and updates to potentially hot cachelines.
Before acquiring locks, do a quick check to see if any pages are in the PCP
queues. Exit if none.

On a 128 node SGI UV system, this reduced the IPI overhead to cpus outside of the
swapping cpuset by 38% and improved time to run a pass of the swaping test
from 98 sec to 51 sec. These times are obviously test & configuration
dependent but the improvements are significant.


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 mm/page_alloc.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c	2011-02-15 16:28:36.165921713 -0600
+++ linux/mm/page_alloc.c	2011-02-15 16:29:43.085502487 -0600
@@ -592,10 +592,24 @@ static void free_pcppages_bulk(struct zo
 	int batch_free = 0;
 	int to_free = count;
 
+	/*
+	 * Quick scan of zones. If all are empty, there is nothing to do.
+	 */
+	for (migratetype = 0; migratetype < MIGRATE_PCPTYPES; migratetype++) {
+		struct list_head *list;
+
+		list = &pcp->lists[migratetype];
+		if (!list_empty(list))
+			break;
+	}
+	if (migratetype == MIGRATE_PCPTYPES)
+		return;
+
 	spin_lock(&zone->lock);
 	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
+	migratetype = 0;
 	while (to_free) {
 		struct page *page;
 		struct list_head *list;
