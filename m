Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab1EMIvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 04:51:01 -0400
Received: from smtp-out.google.com ([74.125.121.67]:38832 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370Ab1EMIu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 04:50:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=OivkPo0Hf6uA739ANCfRGwfHP6IzquqDwxigU8j7Ovs/n13b68txiJI5qZMUP/8dJ
	SG5NkNr/gvpH++LU+CcWg==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, linux-fsdevel@vger.kernel.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>
Subject: [RFC][PATCH v7 06/14] memcg: add dirty limits to mem_cgroup
Date: Fri, 13 May 2011 01:47:45 -0700
Message-Id: <1305276473-14780-7-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1305276473-14780-1-git-send-email-gthelen@google.com>
References: <1305276473-14780-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend mem_cgroup to contain dirty page limits.

Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrea Righi <arighi@develer.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Changelog since v5:
- To simplify this patch, deferred adding routines for kernel to query dirty
  usage and limits to a later patch in this series.
- Collapsed __mem_cgroup_has_dirty_limit() into mem_cgroup_has_dirty_limit().
- Renamed __mem_cgroup_dirty_param() to mem_cgroup_dirty_param().

Changelog since v4:
- Added support for hierarchical dirty limits.
- Simplified __mem_cgroup_dirty_param().
- Simplified mem_cgroup_page_stat().
- Deleted mem_cgroup_nr_pages_item enum, which was added little value.
  Instead the mem_cgroup_page_stat_item enum values are used to identify
  memcg dirty statistics exported to kernel.
- Fixed overflow issues in mem_cgroup_hierarchical_free_pages().

Changelog since v3:
- Previously memcontrol.c used struct vm_dirty_param and vm_dirty_param() to
  advertise dirty memory limits.  Now struct dirty_info and
  mem_cgroup_dirty_info() is used to share dirty limits between memcontrol and
  the rest of the kernel.
- __mem_cgroup_has_dirty_limit() now returns false if use_hierarchy is set.
- memcg_hierarchical_free_pages() now uses parent_mem_cgroup() and is simpler.
- created internal routine, __mem_cgroup_has_dirty_limit(), to consolidate the
  logic.

Changelog since v1:
- Rename (for clarity):
  - mem_cgroup_write_page_stat_item -> mem_cgroup_page_stat_item
  - mem_cgroup_read_page_stat_item -> mem_cgroup_nr_pages_item
- Removed unnecessary get_ prefix from get_xxx() functions.
- Avoid lockdep warnings by using rcu_read_[un]lock() in
  mem_cgroup_has_dirty_limit().

 mm/memcontrol.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 50 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a4cb991..f496677 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -216,6 +216,14 @@ struct mem_cgroup_eventfd_list {
 static void mem_cgroup_threshold(struct mem_cgroup *mem);
 static void mem_cgroup_oom_notify(struct mem_cgroup *mem);
 
+/* Dirty memory parameters */
+struct vm_dirty_param {
+	int dirty_ratio;
+	int dirty_background_ratio;
+	unsigned long dirty_bytes;
+	unsigned long dirty_background_bytes;
+};
+
 /*
  * The memory controller data structure. The memory controller controls both
  * page cache and RSS per cgroup. We would eventually like to provide
@@ -260,6 +268,10 @@ struct mem_cgroup {
 	atomic_t	refcnt;
 
 	unsigned int	swappiness;
+
+	/* control memory cgroup dirty pages */
+	struct vm_dirty_param dirty_param;
+
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
 
@@ -1309,6 +1321,36 @@ static unsigned int get_swappiness(struct mem_cgroup *memcg)
 	return memcg->swappiness;
 }
 
+/*
+ * Return true if the current memory cgroup has local dirty memory settings.
+ * There is an allowed race between the current task migrating in-to/out-of the
+ * root cgroup while this routine runs.  So the return value may be incorrect if
+ * the current task is being simultaneously migrated.
+ */
+static bool mem_cgroup_has_dirty_limit(struct mem_cgroup *mem)
+{
+	return mem && !mem_cgroup_is_root(mem);
+}
+
+/*
+ * Returns a snapshot of the current dirty limits which is not synchronized with
+ * the routines that change the dirty limits.  If this routine races with an
+ * update to the dirty bytes/ratio value, then the caller must handle the case
+ * where neither dirty_[background_]_ratio nor _bytes are set.
+ */
+static void mem_cgroup_dirty_param(struct vm_dirty_param *param,
+				   struct mem_cgroup *mem)
+{
+	if (mem_cgroup_has_dirty_limit(mem)) {
+		*param = mem->dirty_param;
+	} else {
+		param->dirty_ratio = vm_dirty_ratio;
+		param->dirty_bytes = vm_dirty_bytes;
+		param->dirty_background_ratio = dirty_background_ratio;
+		param->dirty_background_bytes = dirty_background_bytes;
+	}
+}
+
 static void mem_cgroup_start_move(struct mem_cgroup *mem)
 {
 	int cpu;
@@ -4917,8 +4959,15 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 	mem->last_scanned_node = MAX_NUMNODES;
 	INIT_LIST_HEAD(&mem->oom_notify);
 
-	if (parent)
+	if (parent) {
 		mem->swappiness = get_swappiness(parent);
+		mem_cgroup_dirty_param(&mem->dirty_param, parent);
+	} else {
+		/*
+		 * The root cgroup dirty_param field is not used, instead,
+		 * system-wide dirty limits are used.
+		 */
+	}
 	atomic_set(&mem->refcnt, 1);
 	mem->move_charge_at_immigrate = 0;
 	mutex_init(&mem->thresholds_lock);
-- 
1.7.3.1

