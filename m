Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab1E2SOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 14:14:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53799 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab1E2SOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 14:14:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SfdAULslNbU9OuORWbBJlq9hyUKFdd7pu/aht2toa2BElPWx56Sej7fOUDHD0GmFIs
         O0iuNmk4oB0PigOHNLQN6q4YV5s7KVRVd9TYigRQnoj54rTz9Ia10XITHZc9Pu4u1U9h
         sRGunM1Os4QFFNYOvvn0jrR9y/hLP3oek2SGM=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v2 05/10] compaction: make isolate_lru_page with filter aware
Date: Mon, 30 May 2011 03:13:44 +0900
Message-Id: <4feb21bdac4c00a30f3c0d9361bd3565e6afa72f.1306689214.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1306689214.git.minchan.kim@gmail.com>
References: <cover.1306689214.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1306689214.git.minchan.kim@gmail.com>
References: <cover.1306689214.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In async mode, compaction doesn't migrate dirty or writeback pages.
So, it's meaningless to pick the page and re-add it to lru list.

Of course, when we isolate the page in compaction, the page might
be dirty or writeback but when we try to migrate the page, the page
would be not dirty, writeback. So it could be migrated. But it's
very unlikely as isolate and migration cycle is much faster than
writeout.

So, this patch helps cpu and prevent unnecessary LRU churning.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/compaction.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 61eab88..e218562 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -243,6 +243,7 @@ static unsigned long isolate_migratepages(struct zone *zone,
 	unsigned long last_pageblock_nr = 0, pageblock_nr;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
+	enum ISOLATE_PAGE_MODE mode = ISOLATE_BOTH;
 
 	/* Do not scan outside zone boundaries */
 	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
@@ -327,7 +328,9 @@ static unsigned long isolate_migratepages(struct zone *zone,
 		}
 
 		/* Try isolate the page */
-		if (__isolate_lru_page(page, ISOLATE_BOTH, 0) != 0)
+		if (!cc->sync)
+			mode |= ISOLATE_CLEAN;
+		if (__isolate_lru_page(page, mode, 0) != 0)
 			continue;
 
 		VM_BUG_ON(PageTransCompound(page));
-- 
1.7.0.4

