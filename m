Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab0JOVUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 17:20:00 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23204 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab0JOVT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 17:19:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=J70JVZpfR6DL+Ckhc5vGBzYTb/xylUkh0Y0sgNCkZQGL4JUUXKgNCzq5kYITojI0R
	LV1wyx/K9C0+7CkvQ00nw==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>
Subject: [PATCH v2 11/11] memcg: check memcg dirty limits in page writeback
Date: Fri, 15 Oct 2010 14:14:39 -0700
Message-Id: <1287177279-30876-12-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287177279-30876-1-git-send-email-gthelen@google.com>
References: <1287177279-30876-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the current process is in a non-root memcg, then
global_dirty_limits() will consider the memcg dirty limit.
This allows different cgroups to have distinct dirty limits
which trigger direct and background writeback at different
levels.

Signed-off-by: Andrea Righi <arighi@develer.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
---
 mm/page-writeback.c |   89 +++++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 73 insertions(+), 16 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index a0bb3e2..9b34f01 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -180,7 +180,7 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
  * Returns the numebr of pages that can currently be freed and used
  * by the kernel for direct mappings.
  */
-static unsigned long determine_dirtyable_memory(void)
+static unsigned long global_dirtyable_memory(void)
 {
 	unsigned long x;
 
@@ -192,6 +192,58 @@ static unsigned long determine_dirtyable_memory(void)
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
+static unsigned long dirtyable_memory(void)
+{
+	unsigned long memory;
+	s64 memcg_memory;
+
+	memory = global_dirtyable_memory();
+	if (!mem_cgroup_has_dirty_limit())
+		return memory;
+	memcg_memory = mem_cgroup_page_stat(MEMCG_NR_DIRTYABLE_PAGES);
+	BUG_ON(memcg_memory < 0);
+
+	return min((unsigned long)memcg_memory, memory);
+}
+
+static long reclaimable_pages(void)
+{
+	s64 ret;
+
+	if (!mem_cgroup_has_dirty_limit())
+		return global_page_state(NR_FILE_DIRTY) +
+			global_page_state(NR_UNSTABLE_NFS);
+	ret = mem_cgroup_page_stat(MEMCG_NR_RECLAIM_PAGES);
+	BUG_ON(ret < 0);
+
+	return ret;
+}
+
+static long writeback_pages(void)
+{
+	s64 ret;
+
+	if (!mem_cgroup_has_dirty_limit())
+		return global_page_state(NR_WRITEBACK);
+	ret = mem_cgroup_page_stat(MEMCG_NR_WRITEBACK);
+	BUG_ON(ret < 0);
+
+	return ret;
+}
+
+static unsigned long dirty_writeback_pages(void)
+{
+	s64 ret;
+
+	if (!mem_cgroup_has_dirty_limit())
+		return global_page_state(NR_UNSTABLE_NFS) +
+			global_page_state(NR_WRITEBACK);
+	ret = mem_cgroup_page_stat(MEMCG_NR_DIRTY_WRITEBACK_PAGES);
+	BUG_ON(ret < 0);
+
+	return ret;
+}
+
 /*
  * couple the period to the dirty_ratio:
  *
@@ -204,8 +256,8 @@ static int calc_period_shift(void)
 	if (vm_dirty_bytes)
 		dirty_total = vm_dirty_bytes / PAGE_SIZE;
 	else
-		dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
-				100;
+		dirty_total = (vm_dirty_ratio * global_dirtyable_memory()) /
+			100;
 	return 2 + ilog2(dirty_total - 1);
 }
 
@@ -410,18 +462,23 @@ void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
 {
 	unsigned long background;
 	unsigned long dirty;
-	unsigned long available_memory = determine_dirtyable_memory();
+	unsigned long available_memory = dirtyable_memory();
 	struct task_struct *tsk;
+	struct vm_dirty_param dirty_param;
 
-	if (vm_dirty_bytes)
-		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
+	vm_dirty_param(&dirty_param);
+
+	if (dirty_param.dirty_bytes)
+		dirty = DIV_ROUND_UP(dirty_param.dirty_bytes, PAGE_SIZE);
 	else
-		dirty = (vm_dirty_ratio * available_memory) / 100;
+		dirty = (dirty_param.dirty_ratio * available_memory) / 100;
 
-	if (dirty_background_bytes)
-		background = DIV_ROUND_UP(dirty_background_bytes, PAGE_SIZE);
+	if (dirty_param.dirty_background_bytes)
+		background = DIV_ROUND_UP(dirty_param.dirty_background_bytes,
+					  PAGE_SIZE);
 	else
-		background = (dirty_background_ratio * available_memory) / 100;
+		background = (dirty_param.dirty_background_ratio *
+			      available_memory) / 100;
 
 	if (background >= dirty)
 		background = dirty / 2;
@@ -493,9 +550,8 @@ static void balance_dirty_pages(struct address_space *mapping,
 			.range_cyclic	= 1,
 		};
 
-		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
-					global_page_state(NR_UNSTABLE_NFS);
-		nr_writeback = global_page_state(NR_WRITEBACK);
+		nr_reclaimable = reclaimable_pages();
+		nr_writeback = writeback_pages();
 
 		global_dirty_limits(&background_thresh, &dirty_thresh);
 
@@ -652,6 +708,7 @@ void throttle_vm_writeout(gfp_t gfp_mask)
 {
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
+	unsigned long dirty;
 
         for ( ; ; ) {
 		global_dirty_limits(&background_thresh, &dirty_thresh);
@@ -662,9 +719,9 @@ void throttle_vm_writeout(gfp_t gfp_mask)
                  */
                 dirty_thresh += dirty_thresh / 10;      /* wheeee... */
 
-                if (global_page_state(NR_UNSTABLE_NFS) +
-			global_page_state(NR_WRITEBACK) <= dirty_thresh)
-                        	break;
+		dirty = dirty_writeback_pages();
+		if (dirty <= dirty_thresh)
+			break;
                 congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		/*
-- 
1.7.1

