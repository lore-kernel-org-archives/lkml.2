Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab2BOW5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:57:52 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56730 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab2BOW5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:57:50 -0500
Subject: [PATCH RFC 11/15] mm: handle book relock in memory controller
To: linux-mm@kvack.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 16 Feb 2012 02:57:47 +0400
Message-ID: <20120215225747.22050.21367.stgit@zurg>
In-Reply-To: <20120215224221.22050.80605.stgit@zurg>
References: <20120215224221.22050.80605.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carefully relock book lru lock at page memory cgroup change.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/memcontrol.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84e04ae..90e21d2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2535,7 +2535,6 @@ __mem_cgroup_commit_charge_lrucare(struct page *page, struct mem_cgroup *memcg,
 					enum charge_type ctype)
 {
 	struct page_cgroup *pc = lookup_page_cgroup(page);
-	struct zone *zone = page_zone(page);
 	struct book *book;
 	unsigned long flags;
 	bool removed = false;
@@ -2545,20 +2544,19 @@ __mem_cgroup_commit_charge_lrucare(struct page *page, struct mem_cgroup *memcg,
 	 * is already on LRU. It means the page may on some other page_cgroup's
 	 * LRU. Take care of it.
 	 */
-	spin_lock_irqsave(&zone->lru_lock, flags);
+	book = lock_page_book(page, &flags);
 	if (PageLRU(page)) {
-		book = page_book(page);
 		del_page_from_lru_list(book, page, page_lru(page));
 		ClearPageLRU(page);
 		removed = true;
 	}
 	__mem_cgroup_commit_charge(memcg, page, 1, pc, ctype);
 	if (removed) {
-		book = page_book(page);
+		book = __relock_page_book(book, page);
 		add_page_to_lru_list(book, page, page_lru(page));
 		SetPageLRU(page);
 	}
-	spin_unlock_irqrestore(&zone->lru_lock, flags);
+	unlock_book(book, &flags);
 	return;
 }
 

