Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315Ab1AEEDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 23:03:31 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:33721 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab1AEEDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 23:03:30 -0500
Date: Wed, 5 Jan 2011 13:00:20 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: [BUGFIX][PATCH] memcg: fix memory migration of shmem swapcache
Message-Id: <20110105130020.e2a854e4.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

This is a fix for a problem which has bothered me for a month.

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
---
 include/linux/memcontrol.h |    5 ++---
 mm/memcontrol.c            |    5 ++---
 mm/migrate.c               |    2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 159a076..275157b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -93,7 +93,7 @@ extern int
 mem_cgroup_prepare_migration(struct page *page,
 	struct page *newpage, struct mem_cgroup **ptr);
 extern void mem_cgroup_end_migration(struct mem_cgroup *mem,
-	struct page *oldpage, struct page *newpage);
+	struct page *oldpage, struct page *newpage, int result);
 
 /*
  * For memory reclaim.
@@ -231,8 +231,7 @@ mem_cgroup_prepare_migration(struct page *page, struct page *newpage,
 }
 
 static inline void mem_cgroup_end_migration(struct mem_cgroup *mem,
-					struct page *oldpage,
-					struct page *newpage)
+		struct page *oldpage, struct page *newpage, int result)
 {
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 61678be..632d3bc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2856,7 +2856,7 @@ int mem_cgroup_prepare_migration(struct page *page,
 
 /* remove redundant charge if migration failed*/
 void mem_cgroup_end_migration(struct mem_cgroup *mem,
-	struct page *oldpage, struct page *newpage)
+	struct page *oldpage, struct page *newpage, int result)
 {
 	struct page *used, *unused;
 	struct page_cgroup *pc;
@@ -2865,8 +2865,7 @@ void mem_cgroup_end_migration(struct mem_cgroup *mem,
 		return;
 	/* blocks rmdir() */
 	cgroup_exclude_rmdir(&mem->css);
-	/* at migration success, oldpage->mapping is NULL. */
-	if (oldpage->mapping) {
+	if (result) {
 		used = oldpage;
 		unused = newpage;
 	} else {
diff --git a/mm/migrate.c b/mm/migrate.c
index 6ae8a66..9a5704a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -756,7 +756,7 @@ rcu_unlock:
 		rcu_read_unlock();
 uncharge:
 	if (!charge)
-		mem_cgroup_end_migration(mem, page, newpage);
+		mem_cgroup_end_migration(mem, page, newpage, rc);
 unlock:
 	unlock_page(page);
 
-- 
1.7.1

