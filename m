Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab1AKIvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 03:51:37 -0500
Received: from mail-gw0-f66.google.com ([74.125.83.66]:63262 "EHLO
	mail-gw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472Ab1AKIv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 03:51:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UPcKCQ1j2R18FH3901gWG+keS+9ewRrgMB2/qhRL5w0o7WVsLJcIk80rJluoIeF66u
         eDu+NvawJQLGjspfAMJ/sig4ISeE4Fm6lC9OT2Wm7ZA7jS4NBnsTd05it9oNJt73p2jK
         7rY94IYcUKA8W/jlQCQSGsccEqk3bb0O8XocA=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 2/2] memcg: remove charge variable in unmap_and_move
Date: Tue, 11 Jan 2011 17:51:12 +0900
Message-Id: <f6f15f90ecf0df32586fcc103038fd7ea01acc16.1294735182.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <41390917af25769cd59eb001370b80ef6520a8bb.1294735182.git.minchan.kim@gmail.com>
References: <41390917af25769cd59eb001370b80ef6520a8bb.1294735182.git.minchan.kim@gmail.com>
In-Reply-To: <41390917af25769cd59eb001370b80ef6520a8bb.1294735182.git.minchan.kim@gmail.com>
References: <41390917af25769cd59eb001370b80ef6520a8bb.1294735182.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memcg charge/uncharge could be handled by mem_cgroup_[prepare/end]
migration itself so charge local variable in unmap_and_move lost the role
since we introduced 01b1ae63c2.

In addition, the variable name is not good like below.

int unmap_and_move()
{
	charge = mem_cgroup_prepare_migration(xxx);
	..
		BUG_ON(charge); <-- BUG if it is charged?
		..
uncharge:
		if (!charge)    <-- why do we have to uncharge !charge?
			mem_group_end_migration(xxx);
	..
}

So let's remove unnecessary and confusing variable.

Suggested-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/memcontrol.c |    1 +
 mm/migrate.c    |    9 +++------
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8ab8410..b1b572f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2804,6 +2804,7 @@ static inline int mem_cgroup_move_swap_account(swp_entry_t entry,
 /*
  * Before starting migration, account PAGE_SIZE to mem_cgroup that the old
  * page belongs to.
+ * Note : Should not return -EAGAIN. unmap_and_move depends on it.
  */
 int mem_cgroup_prepare_migration(struct page *page,
 	struct page *newpage, struct mem_cgroup **ptr)
diff --git a/mm/migrate.c b/mm/migrate.c
index 8f0f131..5f2169f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -623,7 +623,6 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 	struct page *newpage = get_new_page(page, private, &result);
 	int remap_swapcache = 1;
 	int rcu_locked = 0;
-	int charge = 0;
 	struct mem_cgroup *mem = NULL;
 	struct anon_vma *anon_vma = NULL;
 
@@ -638,7 +637,7 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 		if (unlikely(split_huge_page(page)))
 			goto move_newpage;
 
-	/* prepare cgroup just returns 0 or -ENOMEM */
+	/* mem_cgroup_prepare_migration never returns -EAGAIN */
 	rc = -EAGAIN;
 
 	if (!trylock_page(page)) {
@@ -662,8 +661,7 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
 	}
 
 	/* charge against new page */
-	charge = mem_cgroup_prepare_migration(page, newpage, &mem);
-	if (charge == -ENOMEM) {
+	if (mem_cgroup_prepare_migration(page, newpage, &mem)) {
 		rc = -ENOMEM;
 		goto unlock;
 	}
@@ -759,8 +757,7 @@ rcu_unlock:
 	if (rcu_locked)
 		rcu_read_unlock();
 uncharge:
-	if (!charge)
-		mem_cgroup_end_migration(mem, page, newpage, rc == 0);
+	mem_cgroup_end_migration(mem, page, newpage, rc == 0);
 unlock:
 	unlock_page(page);
 
-- 
1.7.0.4

