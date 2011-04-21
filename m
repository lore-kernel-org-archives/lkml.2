Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab1DUNMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 09:12:54 -0400
Received: from relay.parallels.com ([195.214.232.42]:48176 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1DUNMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:12:43 -0400
Subject: [PATCH 3/3] mm: strictly require elevated page refcount in
 isolate_lru_page()
To: <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: Andi Kleen <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 21 Apr 2011 17:12:42 +0400
Message-ID: <20110421131242.17363.49785.stgit@localhost6>
In-Reply-To: <20110421131239.17363.82750.stgit@localhost6>
References: <20110421131239.17363.82750.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

isolate_lru_page() must be called only with stable reference to the page,
this is what is written in the comment above it, this is reasonable.

current isolate_lru_page() users and its page extra reference sources:

mm/huge_memory.c
__collapse_huge_page_isolate()		- reference from pte

mm/memcontrol.c
mem_cgroup_move_parent()		- get_page_unless_zero()
mem_cgroup_move_charge_pte_range()	- reference from pte

mm/memory-failure.c
soft_offline_page()			- fixed, reference from get_any_page()
delete_from_lru_cache() - reference from caller or get_page_unless_zero()
[seems like there bug, because __memory_failure() can call page_action() for
 hpages tail, but it is ok for isolate_lru_page(), tail getted and not in lru]

mm/memory_hotplug.c
do_migrate_range()			- fixed, get_page_unless_zero()

mm/mempolicy.c
migrate_page_add()			- reference from pte

mm/migrate.c
do_move_page_to_node_array()		- reference from follow_page()

mlock.c					- various external references

mm/vmscan.c
putback_lru_page()			- reference from isolate_lru_page()

It seems that all isolate_lru_page() users are ready now for this restriction.
So, let's replace redundant get_page_unless_zero() with get_page() and
add page initial reference count check with VM_BUG_ON()

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/vmscan.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f6b435c..0175f39 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1201,13 +1201,16 @@ int isolate_lru_page(struct page *page)
 {
 	int ret = -EBUSY;
 
+	VM_BUG_ON(!page_count(page));
+
 	if (PageLRU(page)) {
 		struct zone *zone = page_zone(page);
 
 		spin_lock_irq(&zone->lru_lock);
-		if (PageLRU(page) && get_page_unless_zero(page)) {
+		if (PageLRU(page)) {
 			int lru = page_lru(page);
 			ret = 0;
+			get_page(page);
 			ClearPageLRU(page);
 
 			del_page_from_lru_list(zone, page, lru);

