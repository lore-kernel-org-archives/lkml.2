Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab2GWBnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:43:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54428 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753558Ab2GWBni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:38 -0400
Message-Id: <20120723010657.532005062@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Rientjes <rientjes@google.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>
Subject: [ 040/108] mm, thp: abort compaction if migration page cannot be charged to
 memcg
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rientjes <rientjes@google.com>

commit 4bf2bba3750f10aa9e62e6949bc7e8329990f01b upstream.

If page migration cannot charge the temporary page to the memcg,
migrate_pages() will return -ENOMEM.  This isn't considered in memory
compaction however, and the loop continues to iterate over all
pageblocks trying to isolate and migrate pages.  If a small number of
very large memcgs happen to be oom, however, these attempts will mostly
be futile leading to an enormous amout of cpu consumption due to the
page migration failures.

This patch will short circuit and fail memory compaction if
migrate_pages() returns -ENOMEM.  COMPACT_PARTIAL is returned in case
some migrations were successful so that the page allocator will retry.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/compaction.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 7ea259d..2f42d95 100644
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


