Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab1KWPnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:43:47 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:44830 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781Ab1KWPnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:43:04 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 8/8] mm: memcg: modify PageCgroupCache non-atomically
Date: Wed, 23 Nov 2011 16:42:31 +0100
Message-Id: <1322062951-1756-9-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <jweiner@redhat.com>

This bit is protected by lock_page_cgroup(), there is no need for
locked operations when setting and clearing it.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
---
 include/linux/page_cgroup.h |    4 ++--
 mm/memcontrol.c             |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index a0bc9d0..14ddcaf 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -77,8 +77,8 @@ static inline int __TestClearPageCgroup##uname(struct page_cgroup *pc)	\
 
 /* Cache flag is set only once (at allocation) */
 TESTPCGFLAG(Cache, CACHE)
-CLEARPCGFLAG(Cache, CACHE)
-SETPCGFLAG(Cache, CACHE)
+__CLEARPCGFLAG(Cache, CACHE)
+__SETPCGFLAG(Cache, CACHE)
 
 TESTPCGFLAG(Used, USED)
 CLEARPCGFLAG(Used, USED)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 51aba19..8cd1d1c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2444,11 +2444,11 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
 	switch (ctype) {
 	case MEM_CGROUP_CHARGE_TYPE_CACHE:
 	case MEM_CGROUP_CHARGE_TYPE_SHMEM:
-		SetPageCgroupCache(pc);
+		__SetPageCgroupCache(pc);
 		SetPageCgroupUsed(pc);
 		break;
 	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
-		ClearPageCgroupCache(pc);
+		__ClearPageCgroupCache(pc);
 		SetPageCgroupUsed(pc);
 		break;
 	default:
-- 
1.7.6.4

