Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab0KIJZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:25:40 -0500
Received: from smtp-out.google.com ([74.125.121.35]:5180 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab0KIJZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:25:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=JF8kbnPchfGHi2ZDaHiCrk6hOZ3DmNhPOeIfQgxts8qhBnLSTHqRmb39vfZRQYLnC
	z3c6R9Lc4dWdRESTYjXKQ==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH 4/6] memcg: simplify mem_cgroup_page_stat()
Date: Tue,  9 Nov 2010 01:24:29 -0800
Message-Id: <1289294671-6865-5-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1289294671-6865-1-git-send-email-gthelen@google.com>
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cgroup given to mem_cgroup_page_stat() is no allowed to be
NULL or the root cgroup.  So there is no need to complicate the code
handling those cases.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 mm/memcontrol.c |   48 ++++++++++++++++++++++--------------------------
 1 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index eb621ee..f8df350 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1364,12 +1364,10 @@ memcg_hierarchical_free_pages(struct mem_cgroup *mem)
 
 /*
  * mem_cgroup_page_stat() - get memory cgroup file cache statistics
- * @mem:	optional memory cgroup to query.  If NULL, use current task's
- *		cgroup.
+ * @mem:	memory cgroup to query
  * @item:	memory statistic item exported to the kernel
  *
- * Return the accounted statistic value or negative value if current task is
- * root cgroup.
+ * Return the accounted statistic value.
  */
 long mem_cgroup_page_stat(struct mem_cgroup *mem,
 			  enum mem_cgroup_nr_pages_item item)
@@ -1377,29 +1375,27 @@ long mem_cgroup_page_stat(struct mem_cgroup *mem,
 	struct mem_cgroup *iter;
 	long value;
 
+	VM_BUG_ON(!mem);
+	VM_BUG_ON(mem_cgroup_is_root(mem));
+
 	get_online_cpus();
-	rcu_read_lock();
-	if (!mem)
-		mem = mem_cgroup_from_task(current);
-	if (__mem_cgroup_has_dirty_limit(mem)) {
-		/*
-		 * If we're looking for dirtyable pages we need to evaluate
-		 * free pages depending on the limit and usage of the parents
-		 * first of all.
-		 */
-		if (item == MEMCG_NR_DIRTYABLE_PAGES)
-			value = memcg_hierarchical_free_pages(mem);
-		else
-			value = 0;
-		/*
-		 * Recursively evaluate page statistics against all cgroup
-		 * under hierarchy tree
-		 */
-		for_each_mem_cgroup_tree(iter, mem)
-			value += mem_cgroup_local_page_stat(iter, item);
-	} else
-		value = -EINVAL;
-	rcu_read_unlock();
+
+	/*
+	 * If we're looking for dirtyable pages we need to evaluate
+	 * free pages depending on the limit and usage of the parents
+	 * first of all.
+	 */
+	if (item == MEMCG_NR_DIRTYABLE_PAGES)
+		value = memcg_hierarchical_free_pages(mem);
+	else
+		value = 0;
+	/*
+	 * Recursively evaluate page statistics against all cgroup
+	 * under hierarchy tree
+	 */
+	for_each_mem_cgroup_tree(iter, mem)
+		value += mem_cgroup_local_page_stat(iter, item);
+
 	put_online_cpus();
 
 	return value;
-- 
1.7.3.1

