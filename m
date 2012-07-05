Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab2GEAqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 20:46:15 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53417 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145Ab2GEApq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 20:45:46 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 07/11] mm: memcg: remove unneeded shmem charge type
Date: Thu,  5 Jul 2012 02:44:59 +0200
Message-Id: <1341449103-1986-8-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shmem page charges have not needed a separate charge type to tell them
from regular file pages since 08e552c 'memcg: synchronized LRU'.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4a41b55..418b47d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -379,7 +379,6 @@ static bool move_file(void)
 enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
 	MEM_CGROUP_CHARGE_TYPE_ANON,
-	MEM_CGROUP_CHARGE_TYPE_SHMEM,	/* used by page migration of shmem */
 	MEM_CGROUP_CHARGE_TYPE_SWAPOUT,	/* for accounting swapcache */
 	MEM_CGROUP_CHARGE_TYPE_DROP,	/* a page was unused swap cache */
 	NR_CHARGE_TYPE,
@@ -2835,8 +2834,6 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 
 	if (unlikely(!mm))
 		mm = &init_mm;
-	if (!page_is_file_cache(page))
-		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
 
 	if (!PageSwapCache(page))
 		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
@@ -3243,10 +3240,8 @@ void mem_cgroup_prepare_migration(struct page *page, struct page *newpage,
 	 */
 	if (PageAnon(page))
 		ctype = MEM_CGROUP_CHARGE_TYPE_ANON;
-	else if (page_is_file_cache(page))
-		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	else
-		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
+		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	/*
 	 * The page is committed to the memcg, but it's not actually
 	 * charged to the res_counter since we plan on replacing the
@@ -3340,10 +3335,6 @@ void mem_cgroup_replace_page_cache(struct page *oldpage,
 	 */
 	if (!memcg)
 		return;
-
-	if (PageSwapBacked(oldpage))
-		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
-
 	/*
 	 * Even if newpage->mapping was NULL before starting replacement,
 	 * the newpage may be on LRU(or pagevec for LRU) already. We lock
-- 
1.7.7.6

