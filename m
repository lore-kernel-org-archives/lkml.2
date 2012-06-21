Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab2FUGwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 02:52:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34811 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab2FUGwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 02:52:38 -0400
Date: Wed, 20 Jun 2012 23:52:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] mm, thp: abort compaction if migration page cannot be charged
 to memcg
Message-ID: <alpine.DEB.2.00.1206202351030.28770@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If page migration cannot charge the new page to the memcg,
migrate_pages() will return -ENOMEM.  This isn't considered in memory
compaction however, and the loop continues to iterate over all pageblocks
trying in a futile attempt to continue migrations which are only bound to
fail.

This will short circuit and fail memory compaction if migrate_pages()
returns -ENOMEM.  COMPACT_PARTIAL is returned in case some migrations
were successful so that the page allocator will retry.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/compaction.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -701,8 +701,11 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 		if (err) {
 			putback_lru_pages(&cc->migratepages);
 			cc->nr_migratepages = 0;
+			if (err == -ENOMEM) {
+				ret = COMPACT_PARTIAL;
+				goto out;
+			}
 		}
-
 	}
 
 out:
