Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab1DXA0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 20:26:16 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39848 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab1DXA0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 20:26:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qnE6NP1Xl99f75EE20eJ986/Z5VJw4X1N7we1bJbfWLttu0lt5GWoOF61r0GEwvQOx
         Wcw4YKF2soKiIrhk6T16Ry2Wk26By3JmAbXTesDydkYookKyJ1Uqtgtht9xZtX7RPm7c
         av8lDs0cVCEJoJptH8lD77pa1R3vchkIVFhkk=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: [PATCH] Check PageActive when evictable page and unevicetable page race happen
Date: Sun, 24 Apr 2011 09:25:51 +0900
Message-Id: <1303604751-4980-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In putback_lru_page, unevictable page can be changed into evictable
's one while we move it among lru. So we have checked it again and
rescued it. But we don't check PageActive, again. It could add
active page into inactive list so we can see the BUG in isolate_lru_pages.
(But I didn't see any report because I think it's very subtle)

It could happen in race that zap_pte_range's mark_page_accessed and
putback_lru_page. It's subtle but could be possible.

Note:
While I review the code, I found it. So it's not real report.

Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/vmscan.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b3a569f..c0cd1aa 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -562,7 +562,7 @@ int remove_mapping(struct address_space *mapping, struct page *page)
 void putback_lru_page(struct page *page)
 {
 	int lru;
-	int active = !!TestClearPageActive(page);
+	int active;
 	int was_unevictable = PageUnevictable(page);
 
 	VM_BUG_ON(PageLRU(page));
@@ -571,6 +571,7 @@ redo:
 	ClearPageUnevictable(page);
 
 	if (page_evictable(page, NULL)) {
+		active = !!TestClearPageActive(page);
 		/*
 		 * For evictable pages, we can use the cache.
 		 * In event of a race, worst case is we end up with an
@@ -584,6 +585,7 @@ redo:
 		 * Put unevictable pages directly on zone's unevictable
 		 * list.
 		 */
+		ClearPageActive(page);
 		lru = LRU_UNEVICTABLE;
 		add_page_to_unevictable_list(page);
 		/*
-- 
1.7.1

