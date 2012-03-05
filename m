Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab2CEOSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:18:52 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47127 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab2CEOSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 09:18:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of consul.kautuk@gmail.com designates 10.68.136.234 as permitted sender) smtp.mail=consul.kautuk@gmail.com; dkim=pass header.i=consul.kautuk@gmail.com
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] page_alloc.c: Slightly improve the logic in __alloc_pages_high_priority
Date: Mon,  5 Mar 2012 09:18:25 -0500
Message-Id: <1330957105-3595-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loop in __alloc_pages_high_priority() seems to be checking for
(!page) and (gfp_mask & __GFP_NOFAIL) multiple times.

In fact, we don't really need to check (gfp_mask & __GFP_NOFAIL)
for every iteration of the loop as the gfp_mask remains constant.

Slightly improve the logic in __alloc_pages_high_priority() to
eliminate these multiple condition checks.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 mm/page_alloc.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a13ded1..6bb8b6d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2114,14 +2114,19 @@ __alloc_pages_high_priority(gfp_t gfp_mask, unsigned int order,
 {
 	struct page *page;
 
-	do {
-		page = get_page_from_freelist(gfp_mask, nodemask, order,
+	page = get_page_from_freelist(gfp_mask, nodemask, order,
 			zonelist, high_zoneidx, ALLOC_NO_WATERMARKS,
 			preferred_zone, migratetype);
 
-		if (!page && gfp_mask & __GFP_NOFAIL)
+	if (gfp_mask & __GFP_NOFAIL) {
+		while (!page) {
 			wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/50);
-	} while (!page && (gfp_mask & __GFP_NOFAIL));
+
+			page = get_page_from_freelist(gfp_mask, nodemask, order,
+				zonelist, high_zoneidx, ALLOC_NO_WATERMARKS,
+				preferred_zone, migratetype);
+		}
+	}
 
 	return page;
 }
-- 
1.7.5.4

