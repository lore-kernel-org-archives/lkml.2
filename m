Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1AFGjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 01:39:32 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:35911 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab1AFGjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 01:39:31 -0500
Date: Thu, 6 Jan 2011 15:29:11 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: balbir@linux.vnet.ibm.com
Cc: Minchan Kim <minchan.kim@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [BUGFIX][PATCH v4] memcg: fix memory migration of shmem swapcache
Message-Id: <20110106152911.db6c5b2c.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20110106054200.GG3722@balbir.in.ibm.com>
References: <20110105130020.e2a854e4.nishimura@mxp.nes.nec.co.jp>
	<20110105115840.GD4654@cmpxchg.org>
	<20110106100923.24b1dd12.nishimura@mxp.nes.nec.co.jp>
	<AANLkTi=rp=WZa7PP4V6anU0SQ3BM-RJQwiDu1fJuoDig@mail.gmail.com>
	<20110106123415.895d6dfc.nishimura@mxp.nes.nec.co.jp>
	<20110106054200.GG3722@balbir.in.ibm.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry for nit-picking but succeed is not as good as succeeded,
> successful, successful_migration or migration_ok
> 
OK, I use "migration_ok".

===
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

In current implimentation, mem_cgroup_end_migration() decides whether the page
migration has succeeded or not by checking "oldpage->mapping".

But if we are tring to migrate a shmem swapcache, the page->mapping of it is
NULL from the begining, so the check would be invalid.
As a result, mem_cgroup_end_migration() assumes the migration has succeeded
even if it's not, so "newpage" would be freed while it's not uncharged.

This patch fixes it by passing mem_cgroup_end_migration() the result of the
page migration.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
v3->v4
  - s/succeed/migration_ok
v2->v3
  - s/success/succeed
v1->v2
  - pass mem_cgroup_end_migration() "bool" instead of "int".

 include/linux/memcontrol.h |    5 ++---
 mm/memcontrol.c            |    5 ++---
 mm/migrate.c               |    2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 159a076..769c318 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -93,7 +93,7 @@ extern int
 mem_cgroup_prepare_migration(struct page *page,
 	struct page *newpage, struct mem_cgroup **ptr);
 extern void mem_cgroup_end_migration(struct mem_cgroup *mem,
-	struct page *oldpage, struct page *newpage);
+	struct page *oldpage, struct page *newpage, bool migration_ok);
 
 /*
  * For memory reclaim.
@@ -231,8 +231,7 @@ mem_cgroup_prepare_migration(struct page *page, struct page *newpage,
 }
 
 static inline void mem_cgroup_end_migration(struct mem_cgroup *mem,
-					struct page *oldpage,
-					struct page *newpage)
+		struct page *oldpage, struct page *newpage, bool migration_ok)
 {
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 61678be..c35f817 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2856,7 +2856,7 @@ int mem_cgroup_prepare_migration(struct page *page,
 
 /* remove redundant charge if migration failed*/
 void mem_cgroup_end_migration(struct mem_cgroup *mem,
-	struct page *oldpage, struct page *newpage)
+	struct page *oldpage, struct page *newpage, bool migration_ok)
 {
 	struct page *used, *unused;
 	struct page_cgroup *pc;
@@ -2865,8 +2865,7 @@ void mem_cgroup_end_migration(struct mem_cgroup *mem,
 		return;
 	/* blocks rmdir() */
 	cgroup_exclude_rmdir(&mem->css);
-	/* at migration success, oldpage->mapping is NULL. */
-	if (oldpage->mapping) {
+	if (!migration_ok) {
 		used = oldpage;
 		unused = newpage;
 	} else {
diff --git a/mm/migrate.c b/mm/migrate.c
index 6ae8a66..be66b23 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -756,7 +756,7 @@ rcu_unlock:
 		rcu_read_unlock();
 uncharge:
 	if (!charge)
-		mem_cgroup_end_migration(mem, page, newpage);
+		mem_cgroup_end_migration(mem, page, newpage, rc == 0);
 unlock:
 	unlock_page(page);
 
-- 
1.7.1

