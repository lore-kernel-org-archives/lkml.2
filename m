Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854Ab2BNDQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:16:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55791 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2BNDQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:16:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 14 Feb 2012 12:15:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 5/6 v4] memcg: remove PCG_FILE_MAPPED
Message-Id: <20120214121515.34281b73.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120214120414.025625c2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120214120414.025625c2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 96407a510d5212179a4768f28591b35d5c17d403 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 2 Feb 2012 15:02:18 +0900
Subject: [PATCH 5/6] memcg: remove PCG_FILE_MAPPED

with new lock scheme for updating memcg's page stat, we don't need
a flag PCG_FILE_MAPPED which was duplicated information of page_mapped().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/page_cgroup.h |    6 ------
 mm/memcontrol.c             |    6 +-----
 2 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index 7a3af74..a88cdba 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -6,8 +6,6 @@ enum {
 	PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
 	PCG_USED, /* this object is in use. */
 	PCG_MIGRATION, /* under page migration */
-	/* flags for mem_cgroup and file and I/O status */
-	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
 	__NR_PCG_FLAGS,
 };
 
@@ -66,10 +64,6 @@ TESTPCGFLAG(Used, USED)
 CLEARPCGFLAG(Used, USED)
 SETPCGFLAG(Used, USED)
 
-SETPCGFLAG(FileMapped, FILE_MAPPED)
-CLEARPCGFLAG(FileMapped, FILE_MAPPED)
-TESTPCGFLAG(FileMapped, FILE_MAPPED)
-
 SETPCGFLAG(Migration, MIGRATION)
 CLEARPCGFLAG(Migration, MIGRATION)
 TESTPCGFLAG(Migration, MIGRATION)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 30afea5..ec55880 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1928,10 +1928,6 @@ void mem_cgroup_update_page_stat(struct page *page,
 
 	switch (idx) {
 	case MEMCG_NR_FILE_MAPPED:
-		if (val > 0)
-			SetPageCgroupFileMapped(pc);
-		else if (!page_mapped(page))
-			ClearPageCgroupFileMapped(pc);
 		idx = MEM_CGROUP_STAT_FILE_MAPPED;
 		break;
 	default:
@@ -2552,7 +2548,7 @@ static int mem_cgroup_move_account(struct page *page,
 
 	move_lock_mem_cgroup(from, &flags);
 
-	if (PageCgroupFileMapped(pc)) {
+	if (page_mapped(page)) {
 		/* Update mapped_file data for mem_cgroup */
 		preempt_disable();
 		__this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
-- 
1.7.4.1


