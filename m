Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab2ENSCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:02:01 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58824 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434Ab2ENSBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:01:01 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 5/6] mm: memcg: group swapped-out statistics counter logically
Date: Mon, 14 May 2012 20:00:50 +0200
Message-Id: <1337018451-27359-6-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337018451-27359-1-git-send-email-hannes@cmpxchg.org>
References: <1337018451-27359-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The counter of currently swapped out pages in a memcg (hierarchy) is
sitting amidst ever-increasing event counters.  Move this item to the
other counters that reflect current state rather than history.

This technically breaks the kernel ABI, but hopefully nobody relies on
the order of items in memory.stat.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 546e7db..3ee63f6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4257,9 +4257,9 @@ enum {
 	MCS_RSS,
 	MCS_FILE_MAPPED,
 	MCS_MLOCK,
+	MCS_SWAP,
 	MCS_PGPGIN,
 	MCS_PGPGOUT,
-	MCS_SWAP,
 	MCS_PGFAULT,
 	MCS_PGMAJFAULT,
 	MCS_INACTIVE_ANON,
@@ -4279,9 +4279,9 @@ static const char *memcg_stat_strings[NR_MCS_STAT] = {
 	"rss",
 	"mapped_file",
 	"mlock",
+	"swap",
 	"pgpgin",
 	"pgpgout",
-	"swap",
 	"pgfault",
 	"pgmajfault",
 	"inactive_anon",
@@ -4306,14 +4306,14 @@ mem_cgroup_get_local_stat(struct mem_cgroup *memcg, struct mcs_total_stat *s)
 	s->stat[MCS_FILE_MAPPED] += val * PAGE_SIZE;
 	val = mem_cgroup_read_stat(memcg, MEM_CGROUP_STAT_MLOCK);
 	s->stat[MCS_MLOCK] += val * PAGE_SIZE;
-	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGPGIN);
-	s->stat[MCS_PGPGIN] += val;
-	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGPGOUT);
-	s->stat[MCS_PGPGOUT] += val;
 	if (do_swap_account) {
 		val = mem_cgroup_read_stat(memcg, MEM_CGROUP_STAT_SWAPOUT);
 		s->stat[MCS_SWAP] += val * PAGE_SIZE;
 	}
+	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGPGIN);
+	s->stat[MCS_PGPGIN] += val;
+	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGPGOUT);
+	s->stat[MCS_PGPGOUT] += val;
 	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGFAULT);
 	s->stat[MCS_PGFAULT] += val;
 	val = mem_cgroup_read_events(memcg, MEM_CGROUP_EVENTS_PGMAJFAULT);
-- 
1.7.10.1

