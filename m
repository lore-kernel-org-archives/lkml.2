Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab2ATD2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 22:28:23 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39013 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2ATD2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 22:28:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 20 Jan 2012 12:26:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.cz>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>
Subject: [PATCH v3] memcg: remove PCG_CACHE page_cgroup flag
Message-Id: <20120120122658.1b14b512.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120119181711.8d697a6b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120119181711.8d697a6b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this version is much simplified.

==
>From 5700a4fe9c581e1ebaa021ba6119dc8d921b024f Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 19 Jan 2012 17:09:41 +0900
Subject: [PATCH v3] memcg: remove PCG_CACHE

We record 'the page is cache' by PCG_CACHE bit to page_cgroup.
Here, "CACHE" means anonymous user pages (and SwapCache). This
doesn't include shmem.

Consdering callers, at charge/uncharge, the caller should know
what  the page is and we don't need to record it by using 1bit
per page.

This patch removes PCG_CACHE bit and make callers of
mem_cgroup_charge_statistics() to specify what the page is.

Changelog since v2
 - removed 'not_rss', added 'anon'
 - changed a meaning of arguments to mem_cgroup_charge_statisitcs()
 - removed a patch to mem_cgroup_uncharge_cache
 - simplified comment.

Changelog since RFC.
 - rebased onto memcg-devel
 - rename 'file' to 'not_rss'
 - some cleanup and added comment.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/page_cgroup.h |    8 +------
 mm/memcontrol.c             |   48 +++++++++++++++++++++++-------------------
 2 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index a2d1177..1060292 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -4,7 +4,6 @@
 enum {
 	/* flags for mem_cgroup */
 	PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
-	PCG_CACHE, /* charged as cache */
 	PCG_USED, /* this object is in use. */
 	PCG_MIGRATION, /* under page migration */
 	/* flags for mem_cgroup and file and I/O status */
@@ -64,11 +63,6 @@ static inline void ClearPageCgroup##uname(struct page_cgroup *pc)	\
 static inline int TestClearPageCgroup##uname(struct page_cgroup *pc)	\
 	{ return test_and_clear_bit(PCG_##lname, &pc->flags);  }
 
-/* Cache flag is set only once (at allocation) */
-TESTPCGFLAG(Cache, CACHE)
-CLEARPCGFLAG(Cache, CACHE)
-SETPCGFLAG(Cache, CACHE)
-
 TESTPCGFLAG(Used, USED)
 CLEARPCGFLAG(Used, USED)
 SETPCGFLAG(Used, USED)
@@ -85,7 +79,7 @@ static inline void lock_page_cgroup(struct page_cgroup *pc)
 {
 	/*
 	 * Don't take this lock in IRQ context.
-	 * This lock is for pc->mem_cgroup, USED, CACHE, MIGRATION
+	 * This lock is for pc->mem_cgroup, USED, MIGRATION
 	 */
 	bit_spin_lock(PCG_LOCK, &pc->flags);
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ff24520..f000c82 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -672,15 +672,19 @@ static unsigned long mem_cgroup_read_events(struct mem_cgroup *memcg,
 }
 
 static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
-					 bool file, int nr_pages)
+					 bool rss, int nr_pages)
 {
 	preempt_disable();
 
-	if (file)
-		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_CACHE],
+	/*
+	 * Here, RSS means 'mapped anon' and anon's SwapCache. Shmem/tmpfs is
+	 * counted as CACHE even if it's on ANON LRU.
+	 */
+	if (rss)
+		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_RSS],
 				nr_pages);
 	else
-		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_RSS],
+		__this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_CACHE],
 				nr_pages);
 
 	/* pagein of a big page is an event. So, ignore page size */
@@ -2409,6 +2413,8 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 				       struct page_cgroup *pc,
 				       enum charge_type ctype)
 {
+	bool anon;
+
 	lock_page_cgroup(pc);
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
@@ -2428,21 +2434,14 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 	 * See mem_cgroup_add_lru_list(), etc.
  	 */
 	smp_wmb();
-	switch (ctype) {
-	case MEM_CGROUP_CHARGE_TYPE_CACHE:
-	case MEM_CGROUP_CHARGE_TYPE_SHMEM:
-		SetPageCgroupCache(pc);
-		SetPageCgroupUsed(pc);
-		break;
-	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
-		ClearPageCgroupCache(pc);
-		SetPageCgroupUsed(pc);
-		break;
-	default:
-		break;
-	}
 
-	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), nr_pages);
+	SetPageCgroupUsed(pc);
+	if (ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
+		anon = true;
+	else
+		anon = false;
+
+	mem_cgroup_charge_statistics(memcg, anon, nr_pages);
 	unlock_page_cgroup(pc);
 	WARN_ON_ONCE(PageLRU(page));
 	/*
@@ -2507,6 +2506,7 @@ static int mem_cgroup_move_account(struct page *page,
 {
 	unsigned long flags;
 	int ret;
+	bool anon = PageAnon(page);
 
 	VM_BUG_ON(from == to);
 	VM_BUG_ON(PageLRU(page));
@@ -2535,14 +2535,14 @@ static int mem_cgroup_move_account(struct page *page,
 		__this_cpu_inc(to->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
 		preempt_enable();
 	}
-	mem_cgroup_charge_statistics(from, PageCgroupCache(pc), -nr_pages);
+	mem_cgroup_charge_statistics(from, anon, -nr_pages);
 	if (uncharge)
 		/* This is not "cancel", but cancel_charge does all we need. */
 		__mem_cgroup_cancel_charge(from, nr_pages);
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
-	mem_cgroup_charge_statistics(to, PageCgroupCache(pc), nr_pages);
+	mem_cgroup_charge_statistics(to, anon, nr_pages);
 	/*
 	 * We charges against "to" which may not have any tasks. Then, "to"
 	 * can be under rmdir(). But in current implementation, caller of
@@ -2890,6 +2890,7 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 	struct mem_cgroup *memcg = NULL;
 	unsigned int nr_pages = 1;
 	struct page_cgroup *pc;
+	bool anon;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -2921,6 +2922,7 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 		/* See mem_cgroup_prepare_migration() */
 		if (page_mapped(page) || PageCgroupMigration(pc))
 			goto unlock_out;
+		anon = true;
 		break;
 	case MEM_CGROUP_CHARGE_TYPE_SWAPOUT:
 		if (!PageAnon(page)) {	/* Shared memory */
@@ -2928,12 +2930,14 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 				goto unlock_out;
 		} else if (page_mapped(page)) /* Anon */
 				goto unlock_out;
+		anon = true;
 		break;
 	default:
+		anon = false;
 		break;
 	}
 
-	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), -nr_pages);
+	mem_cgroup_charge_statistics(memcg, anon, -nr_pages);
 
 	ClearPageCgroupUsed(pc);
 	/*
@@ -3319,7 +3323,7 @@ void mem_cgroup_replace_page_cache(struct page *oldpage,
 	/* fix accounting on old pages */
 	lock_page_cgroup(pc);
 	memcg = pc->mem_cgroup;
-	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), -1);
+	mem_cgroup_charge_statistics(memcg, false, -1);
 	ClearPageCgroupUsed(pc);
 	unlock_page_cgroup(pc);
 
-- 
1.7.4.1


