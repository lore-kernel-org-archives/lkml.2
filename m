Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab2JDSO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:14:57 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58774 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab2JDSJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:30 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 1/2] mm: memcontrol: handle potential crash when rmap races with task exit
Date: Thu,  4 Oct 2012 14:09:16 -0400
Message-Id: <1349374157-20604-2-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349374157-20604-1-git-send-email-hannes@cmpxchg.org>
References: <1349374157-20604-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page_referenced() counts only references of mm's that are associated
with the memcg hierarchy that is being reclaimed.  However, if it
races with the owner of the mm exiting, mm->owner may be NULL.  Don't
crash, just ignore the reference.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: stable@kernel.org [3.5]
---
 include/linux/memcontrol.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8d9489f..8686294 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -91,7 +91,7 @@ int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
-	match = __mem_cgroup_same_or_subtree(cgroup, memcg);
+	match = memcg && __mem_cgroup_same_or_subtree(cgroup, memcg);
 	rcu_read_unlock();
 	return match;
 }
-- 
1.7.11.4

