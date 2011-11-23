Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab1KWPoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:44:12 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:44827 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753Ab1KWPnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:43:03 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 7/8] mm: memcg: modify PageCgroupAcctLRU non-atomically
Date: Wed, 23 Nov 2011 16:42:30 +0100
Message-Id: <1322062951-1756-8-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <jweiner@redhat.com>

This bit is protected by zone->lru_lock, there is no need for locked
operations when setting and clearing it.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
---
 include/linux/page_cgroup.h |   16 ++++++++++++----
 mm/memcontrol.c             |    4 ++--
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index aaa60da..a0bc9d0 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -57,14 +57,23 @@ static inline int PageCgroup##uname(struct page_cgroup *pc)	\
 #define SETPCGFLAG(uname, lname)			\
 static inline void SetPageCgroup##uname(struct page_cgroup *pc)\
 	{ set_bit(PCG_##lname, &pc->flags);  }
+#define __SETPCGFLAG(uname, lname)			\
+static inline void __SetPageCgroup##uname(struct page_cgroup *pc)\
+	{ __set_bit(PCG_##lname, &pc->flags);  }
 
 #define CLEARPCGFLAG(uname, lname)			\
 static inline void ClearPageCgroup##uname(struct page_cgroup *pc)	\
 	{ clear_bit(PCG_##lname, &pc->flags);  }
+#define __CLEARPCGFLAG(uname, lname)			\
+static inline void __ClearPageCgroup##uname(struct page_cgroup *pc)	\
+	{ __clear_bit(PCG_##lname, &pc->flags);  }
 
 #define TESTCLEARPCGFLAG(uname, lname)			\
 static inline int TestClearPageCgroup##uname(struct page_cgroup *pc)	\
 	{ return test_and_clear_bit(PCG_##lname, &pc->flags);  }
+#define __TESTCLEARPCGFLAG(uname, lname)			\
+static inline int __TestClearPageCgroup##uname(struct page_cgroup *pc)	\
+	{ return __test_and_clear_bit(PCG_##lname, &pc->flags);  }
 
 /* Cache flag is set only once (at allocation) */
 TESTPCGFLAG(Cache, CACHE)
@@ -75,11 +84,10 @@ TESTPCGFLAG(Used, USED)
 CLEARPCGFLAG(Used, USED)
 SETPCGFLAG(Used, USED)
 
-SETPCGFLAG(AcctLRU, ACCT_LRU)
-CLEARPCGFLAG(AcctLRU, ACCT_LRU)
+__SETPCGFLAG(AcctLRU, ACCT_LRU)
+__CLEARPCGFLAG(AcctLRU, ACCT_LRU)
 TESTPCGFLAG(AcctLRU, ACCT_LRU)
-TESTCLEARPCGFLAG(AcctLRU, ACCT_LRU)
-
+__TESTCLEARPCGFLAG(AcctLRU, ACCT_LRU)
 
 SETPCGFLAG(FileMapped, FILE_MAPPED)
 CLEARPCGFLAG(FileMapped, FILE_MAPPED)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b9a3b94..51aba19 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -995,7 +995,7 @@ struct lruvec *mem_cgroup_lru_add_list(struct zone *zone, struct page *page,
 		/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
 		smp_rmb();
 		memcg = pc->mem_cgroup;
-		SetPageCgroupAcctLRU(pc);
+		__SetPageCgroupAcctLRU(pc);
 	} else
 		memcg = root_mem_cgroup;
 	mz = page_cgroup_zoneinfo(memcg, page);
@@ -1031,7 +1031,7 @@ void mem_cgroup_lru_del_list(struct page *page, enum lru_list lru)
 	 * LRU-accounting happened against pc->mem_cgroup or
 	 * root_mem_cgroup.
 	 */
-	if (TestClearPageCgroupAcctLRU(pc)) {
+	if (__TestClearPageCgroupAcctLRU(pc)) {
 		VM_BUG_ON(!pc->mem_cgroup);
 		memcg = pc->mem_cgroup;
 	} else
-- 
1.7.6.4

