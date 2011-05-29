Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1E2SQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 14:16:16 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:54550 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab1E2SOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 14:14:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=e7t1BsGptr5qkdpLnVmaYOZv8JLz212WNLO+khIe1wv8TTKgIcXqYdh2z2aArEhPzL
         kbTULQe+5d5A/fPbtS4E4Lz5eiMwBscWr68OsIVl4OTHX7V4TC4g/oV2TL88DOE14x5m
         /hUjYcxexKQhcWDwCqhaRDR4x0I8WyyAOYulI=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v2 02/10] compaction: trivial clean up acct_isolated
Date: Mon, 30 May 2011 03:13:41 +0900
Message-Id: <d2a446699fd72bf439b0e538f798e3d600314d92.1306689214.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1306689214.git.minchan.kim@gmail.com>
References: <cover.1306689214.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1306689214.git.minchan.kim@gmail.com>
References: <cover.1306689214.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acct_isolated of compaction uses page_lru_base_type which returns only
base type of LRU list so it never returns LRU_ACTIVE_ANON or LRU_ACTIVE_FILE.
In addtion, cc->nr_[anon|file] is used in only acct_isolated so it doesn't have
fields in conpact_control.
This patch removes fields from compact_control and makes clear function of
acct_issolated which counts the number of anon|file pages isolated.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/compaction.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 021a296..61eab88 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -35,10 +35,6 @@ struct compact_control {
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
 	bool sync;			/* Synchronous migration */
 
-	/* Account for isolated anon and file pages */
-	unsigned long nr_anon;
-	unsigned long nr_file;
-
 	unsigned int order;		/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
 	struct zone *zone;
@@ -212,17 +208,13 @@ static void isolate_freepages(struct zone *zone,
 static void acct_isolated(struct zone *zone, struct compact_control *cc)
 {
 	struct page *page;
-	unsigned int count[NR_LRU_LISTS] = { 0, };
+	unsigned int count[2] = { 0, };
 
-	list_for_each_entry(page, &cc->migratepages, lru) {
-		int lru = page_lru_base_type(page);
-		count[lru]++;
-	}
+	list_for_each_entry(page, &cc->migratepages, lru)
+		count[!!page_is_file_cache(page)]++;
 
-	cc->nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
-	cc->nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
-	__mod_zone_page_state(zone, NR_ISOLATED_ANON, cc->nr_anon);
-	__mod_zone_page_state(zone, NR_ISOLATED_FILE, cc->nr_file);
+	__mod_zone_page_state(zone, NR_ISOLATED_ANON, count[0]);
+	__mod_zone_page_state(zone, NR_ISOLATED_FILE, count[1]);
 }
 
 /* Similar to reclaim, but different enough that they don't share logic */
-- 
1.7.0.4

