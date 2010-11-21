Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab0KUOZW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 09:25:22 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59403 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab0KUOZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 09:25:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=svIFmVIoFk/cqj2AVmSmqiuKEVHSN+2GC6IhY5+TvT9qcaf0Sf6wY75zgF/qRrbr5J
         RE5nOmB5p3z6RpoKeChzZVe9a/4HBf8l22eOtkwer7Sgf5c+J/5F8boZQqvFMkCck4Bz
         LK2MtY0HXb5XF8STIWEm31MayuezF/U9fe9xs=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] vmscan: Make move_active_pages_to_lru more generic
Date: Sun, 21 Nov 2010 23:24:56 +0900
Message-Id: <1290349496-13297-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now move_active_pages_to_lru can move pages into active or inactive.
if it moves the pages into inactive, it itself can clear PG_acive.
It makes the function more generic.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>

---
 mm/vmscan.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index aa4f1cb..bd408b3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1457,6 +1457,10 @@ static void move_active_pages_to_lru(struct zone *zone,
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
 
+		/* we are de-activating */
+		if (!is_active_lru(lru))
+			ClearPageActive(page);
+
 		list_move(&page->lru, &zone->lru[lru].list);
 		mem_cgroup_add_lru_list(page, lru);
 		pgmoved++;
@@ -1543,7 +1547,6 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 			}
 		}
 
-		ClearPageActive(page);  /* we are de-activating */
 		list_add(&page->lru, &l_inactive);
 	}
 
-- 
1.7.0.4

