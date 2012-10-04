Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab2JDSOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:14:55 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58776 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab2JDSJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:31 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 2/2] mm: memcg: clean up mm_match_cgroup() signature
Date: Thu,  4 Oct 2012 14:09:17 -0400
Message-Id: <1349374157-20604-3-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349374157-20604-1-git-send-email-hannes@cmpxchg.org>
References: <1349374157-20604-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It really should return a boolean for match/no match.  And since it
takes a memcg, not a cgroup, fix that parameter name as well.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/memcontrol.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8686294..7698182 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -84,14 +84,14 @@ extern struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg);
 extern struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont);
 
 static inline
-int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
+bool mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *memcg;
-	int match;
+	struct mem_cgroup *task_memcg;
+	bool match;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
-	match = memcg && __mem_cgroup_same_or_subtree(cgroup, memcg);
+	task_memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
+	match = task_memcg && __mem_cgroup_same_or_subtree(memcg, task_memcg);
 	rcu_read_unlock();
 	return match;
 }
@@ -258,10 +258,10 @@ static inline struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm
 	return NULL;
 }
 
-static inline int mm_match_cgroup(struct mm_struct *mm,
+static inline bool mm_match_cgroup(struct mm_struct *mm,
 		struct mem_cgroup *memcg)
 {
-	return 1;
+	return true;
 }
 
 static inline int task_in_mem_cgroup(struct task_struct *task,
-- 
1.7.11.4

