Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0FGGDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 02:03:33 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:38861 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab0FGGDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 02:03:32 -0400
Date: Mon, 7 Jun 2010 14:52:39 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [cleanup][PATCH -mmotm 1/2] memcg: remove redundant codes
Message-Id: <20100607145239.cb5cb917.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are based on mmotm-2010-06-03-16-36 + some already merged patches
for memcg.

===
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

- try_get_mem_cgroup_from_mm() calls rcu_read_lock/unlock by itself, so we
  don't have to call them in task_in_mem_cgroup().
- *mz is not used in __mem_cgroup_uncharge_common().
- we don't have to call lookup_page_cgroup() in mem_cgroup_end_migration()
  after we've cleared PCG_MIGRATION of @oldpage.
- remove empty comment.
- remove redundant empty line in mem_cgroup_cache_charge().

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/memcontrol.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9c1d227..7146055 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -840,9 +840,7 @@ int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
 	struct mem_cgroup *curr = NULL;
 
 	task_lock(task);
-	rcu_read_lock();
 	curr = try_get_mem_cgroup_from_mm(task->mm);
-	rcu_read_unlock();
 	task_unlock(task);
 	if (!curr)
 		return 0;
@@ -2099,7 +2097,6 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 	if (!(gfp_mask & __GFP_WAIT)) {
 		struct page_cgroup *pc;
 
-
 		pc = lookup_page_cgroup(page);
 		if (!pc)
 			return 0;
@@ -2293,7 +2290,6 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 {
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
-	struct mem_cgroup_per_zone *mz;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -2347,7 +2343,6 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
 	 * special functions.
 	 */
 
-	mz = page_cgroup_zoneinfo(pc);
 	unlock_page_cgroup(pc);
 
 	memcg_check_events(mem, page);
@@ -2659,11 +2654,8 @@ void mem_cgroup_end_migration(struct mem_cgroup *mem,
 	ClearPageCgroupMigration(pc);
 	unlock_page_cgroup(pc);
 
-	if (unused != oldpage)
-		pc = lookup_page_cgroup(unused);
 	__mem_cgroup_uncharge_common(unused, MEM_CGROUP_CHARGE_TYPE_FORCE);
 
-	pc = lookup_page_cgroup(used);
 	/*
 	 * If a page is a file cache, radix-tree replacement is very atomic
 	 * and we can skip this check. When it was an Anon page, its mapcount
@@ -3807,8 +3799,6 @@ static int mem_cgroup_oom_control_read(struct cgroup *cgrp,
 	return 0;
 }
 
-/*
- */
 static int mem_cgroup_oom_control_write(struct cgroup *cgrp,
 	struct cftype *cft, u64 val)
 {
-- 
1.6.5.2

