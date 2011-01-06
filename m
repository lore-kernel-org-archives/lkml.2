Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab1AFDiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 22:38:06 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:35956 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab1AFDiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 22:38:05 -0500
Date: Thu, 6 Jan 2011 12:34:15 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: [BUGFIX][PATCH v3] memcg: fix memory migration of shmem swapcache
Message-Id: <20110106123415.895d6dfc.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <AANLkTi=rp=WZa7PP4V6anU0SQ3BM-RJQwiDu1fJuoDig@mail.gmail.com>
References: <20110105130020.e2a854e4.nishimura@mxp.nes.nec.co.jp>
	<20110105115840.GD4654@cmpxchg.org>
	<20110106100923.24b1dd12.nishimura@mxp.nes.nec.co.jp>
	<AANLkTi=rp=WZa7PP4V6anU0SQ3BM-RJQwiDu1fJuoDig@mail.gmail.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 159a076..cc5a8fd 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -93,7 +93,7 @@ extern int
> >  mem_cgroup_prepare_migration(struct page *page,
> >        struct page *newpage, struct mem_cgroup **ptr);
> >  extern void mem_cgroup_end_migration(struct mem_cgroup *mem,
> > -       struct page *oldpage, struct page *newpage);
> > +       struct page *oldpage, struct page *newpage, bool success);
> 
> The term "success" implies present or future tense.
> The event this variable cares about in the past so "succeed" might be
> a more appropriate term.
> Sorry to be picky about the English but there is an important
> distinction here since we don't have any comment about the variable.
> 
> Am I being too fussy?
Not at all. Your comments are very helpful to make the code more readable :)

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
v2->v3
  - s/success/succeed

v1->v2
  - pass mem_cgroup_end_migration() "bool" instead of "int".

 include/linux/memcontrol.h |    5 ++---
 mm/memcontrol.c            |    5 ++---
 mm/migrate.c               |    2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 159a076..9f52b57 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -93,7 +93,7 @@ extern int
 mem_cgroup_prepare_migration(struct page *page,
 	struct page *newpage, struct mem_cgroup **ptr);
 extern void mem_cgroup_end_migration(struct mem_cgroup *mem,
-	struct page *oldpage, struct page *newpage);
+	struct page *oldpage, struct page *newpage, bool succeed);
 
 /*
  * For memory reclaim.
@@ -231,8 +231,7 @@ mem_cgroup_prepare_migration(struct page *page, struct page *newpage,
 }
 
 static inline void mem_cgroup_end_migration(struct mem_cgroup *mem,
-					struct page *oldpage,
-					struct page *newpage)
+		struct page *oldpage, struct page *newpage, bool succeed)
 {
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 61678be..71a39bc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2856,7 +2856,7 @@ int mem_cgroup_prepare_migration(struct page *page,
 
 /* remove redundant charge if migration failed*/
 void mem_cgroup_end_migration(struct mem_cgroup *mem,
-	struct page *oldpage, struct page *newpage)
+	struct page *oldpage, struct page *newpage, bool succeed)
 {
 	struct page *used, *unused;
 	struct page_cgroup *pc;
@@ -2865,8 +2865,7 @@ void mem_cgroup_end_migration(struct mem_cgroup *mem,
 		return;
 	/* blocks rmdir() */
 	cgroup_exclude_rmdir(&mem->css);
-	/* at migration success, oldpage->mapping is NULL. */
-	if (oldpage->mapping) {
+	if (!succeed) {
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

