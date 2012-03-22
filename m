Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068Ab2CVV5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:57:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57572 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031171Ab2CVV4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:56:44 -0400
Subject: [PATCH v6 6/7] mm/memcg: kill mem_cgroup_lru_del()
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 23 Mar 2012 01:56:39 +0400
Message-ID: <20120322215639.27814.4996.stgit@zurg>
In-Reply-To: <20120322214944.27814.42039.stgit@zurg>
References: <20120322214944.27814.42039.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch kills mem_cgroup_lru_del(), we can use mem_cgroup_lru_del_list()
instead. On 0-order isolation we already have right lru list id.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
---
 include/linux/memcontrol.h |    5 -----
 mm/memcontrol.c            |    5 -----
 mm/vmscan.c                |    7 +++++--
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 95dc32c..58d820c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -66,7 +66,6 @@ struct lruvec *mem_cgroup_zone_lruvec(struct zone *, struct mem_cgroup *);
 struct lruvec *mem_cgroup_lru_add_list(struct zone *, struct page *,
 				       enum lru_list);
 void mem_cgroup_lru_del_list(struct page *, enum lru_list);
-void mem_cgroup_lru_del(struct page *);
 struct lruvec *mem_cgroup_lru_move_lists(struct zone *, struct page *,
 					 enum lru_list, enum lru_list);
 
@@ -260,10 +259,6 @@ static inline void mem_cgroup_lru_del_list(struct page *page, enum lru_list lru)
 {
 }
 
-static inline void mem_cgroup_lru_del(struct page *page)
-{
-}
-
 static inline struct lruvec *mem_cgroup_lru_move_lists(struct zone *zone,
 						       struct page *page,
 						       enum lru_list from,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 59697fb..16db6c1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1115,11 +1115,6 @@ void mem_cgroup_lru_del_list(struct page *page, enum lru_list lru)
 	mz->lru_size[lru] -= 1 << compound_order(page);
 }
 
-void mem_cgroup_lru_del(struct page *page)
-{
-	mem_cgroup_lru_del_list(page, page_lru(page));
-}
-
 /**
  * mem_cgroup_lru_move_lists - account for moving a page between lrus
  * @zone: zone of the page
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5f6ed98..9de66be 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1147,7 +1147,7 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 
 		switch (__isolate_lru_page(page, mode)) {
 		case 0:
-			mem_cgroup_lru_del(page);
+			mem_cgroup_lru_del_list(page, lru);
 			list_move(&page->lru, dst);
 			nr_taken += hpage_nr_pages(page);
 			break;
@@ -1205,8 +1205,11 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 
 			if (__isolate_lru_page(cursor_page, mode) == 0) {
 				unsigned int isolated_pages;
+				enum lru_list cursor_lru;
 
-				mem_cgroup_lru_del(cursor_page);
+				cursor_lru = page_lru(cursor_page);
+				mem_cgroup_lru_del_list(cursor_page,
+							cursor_lru);
 				list_move(&cursor_page->lru, dst);
 				isolated_pages = hpage_nr_pages(cursor_page);
 				nr_taken += isolated_pages;

