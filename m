Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1K2Kwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:52:43 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:54489 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638Ab1K2Kwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:52:36 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 3/7] mm: memcg: clean up fault accounting
Date: Tue, 29 Nov 2011 11:52:01 +0100
Message-Id: <1322563925-1667-4-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1322563925-1667-1-git-send-email-hannes@cmpxchg.org>
References: <1322563925-1667-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <jweiner@redhat.com>

The fault accounting functions have a single, memcg-internal user, so
they don't need to be global.  In fact, their one-line bodies can be
directly folded into the caller.  And since faults happen one at a
time, use this_cpu_inc() directly instead of this_cpu_add(foo, 1).

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Balbir Singh <bsingharora@gmail.com>
---
 mm/memcontrol.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 473b99f..d825af9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -589,16 +589,6 @@ static void mem_cgroup_swap_statistics(struct mem_cgroup *memcg,
 	this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SWAPOUT], val);
 }
 
-void mem_cgroup_pgfault(struct mem_cgroup *memcg, int val)
-{
-	this_cpu_add(memcg->stat->events[MEM_CGROUP_EVENTS_PGFAULT], val);
-}
-
-void mem_cgroup_pgmajfault(struct mem_cgroup *memcg, int val)
-{
-	this_cpu_add(memcg->stat->events[MEM_CGROUP_EVENTS_PGMAJFAULT], val);
-}
-
 static unsigned long mem_cgroup_read_events(struct mem_cgroup *memcg,
 					    enum mem_cgroup_events_index idx)
 {
@@ -913,10 +903,10 @@ void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx)
 
 	switch (idx) {
 	case PGMAJFAULT:
-		mem_cgroup_pgmajfault(memcg, 1);
+		this_cpu_inc(memcg->stat->events[MEM_CGROUP_EVENTS_PGFAULT]);
 		break;
 	case PGFAULT:
-		mem_cgroup_pgfault(memcg, 1);
+		this_cpu_inc(memcg->stat->events[MEM_CGROUP_EVENTS_PGMAJFAULT]);
 		break;
 	default:
 		BUG();
-- 
1.7.6.4

