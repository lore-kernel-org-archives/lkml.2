Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab0JTFI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 01:08:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45796 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab0JTFI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 01:08:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 20 Oct 2010 14:02:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v2][memcg+dirtylimit] Fix  overwriting global vm dirty limit
 setting by memcg (Re: [PATCH v3 00/11] memcg: per cgroup dirty page
 accounting
Message-Id: <20101020140255.5b8afb63.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101020122144.47f2b60b.kamezawa.hiroyu@jp.fujitsu.com>
References: <1287448784-25684-1-git-send-email-gthelen@google.com>
	<20101020122144.47f2b60b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed one here.
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, at calculating dirty limit, vm_dirty_param() is called.
This function returns dirty-limit related parameters considering
memory cgroup settings.

Now, assume that vm_dirty_bytes=100M (global dirty limit) and
memory cgroup has 1G of pages and 40 dirty_ratio, dirtyable memory is
500MB.

In this case, global_dirty_limits will consider dirty_limt as
500 *0.4 = 200MB. This is bad...memory cgroup is not back door.

This patch limits the return value of vm_dirty_param() considring
global settings.

Changelog:
 - fixed an argument "mem" int to u64
 - fixed to use global available memory to cap memcg's value.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    5 +++--
 mm/memcontrol.c            |   30 +++++++++++++++++++++++++++++-
 mm/page-writeback.c        |    3 ++-
 3 files changed, 34 insertions(+), 4 deletions(-)

Index: dirty_limit_new/mm/memcontrol.c
===================================================================
--- dirty_limit_new.orig/mm/memcontrol.c
+++ dirty_limit_new/mm/memcontrol.c
@@ -1171,9 +1171,11 @@ static void __mem_cgroup_dirty_param(str
  * can be moved after our access and writeback tends to take long time.  At
  * least, "memcg" will not be freed while holding rcu_read_lock().
  */
-void vm_dirty_param(struct vm_dirty_param *param)
+void vm_dirty_param(struct vm_dirty_param *param,
+	 u64 mem, u64 global)
 {
 	struct mem_cgroup *memcg;
+	u64 limit, bglimit;
 
 	if (mem_cgroup_disabled()) {
 		global_vm_dirty_param(param);
@@ -1183,6 +1185,32 @@ void vm_dirty_param(struct vm_dirty_para
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(current);
 	__mem_cgroup_dirty_param(param, memcg);
+	/*
+	 * A limitation under memory cgroup is under global vm, too.
+	 */
+	if (vm_dirty_ratio)
+		limit = global * vm_dirty_ratio / 100;
+	else
+		limit = vm_dirty_bytes;
+	if (param->dirty_ratio) {
+		param->dirty_bytes = mem * param->dirty_ratio / 100;
+		param->dirty_ratio = 0;
+	}
+	if (param->dirty_bytes > limit)
+		param->dirty_bytes = limit;
+
+	if (dirty_background_ratio)
+		bglimit = global * dirty_background_ratio / 100;
+	else
+		bglimit = dirty_background_bytes;
+
+	if (param->dirty_background_ratio) {
+		param->dirty_background_bytes =
+			mem * param->dirty_background_ratio / 100;
+		param->dirty_background_ratio = 0;
+	}
+	if (param->dirty_background_bytes > bglimit)
+		param->dirty_background_bytes = bglimit;
 	rcu_read_unlock();
 }
 
Index: dirty_limit_new/include/linux/memcontrol.h
===================================================================
--- dirty_limit_new.orig/include/linux/memcontrol.h
+++ dirty_limit_new/include/linux/memcontrol.h
@@ -171,7 +171,7 @@ static inline void mem_cgroup_dec_page_s
 }
 
 bool mem_cgroup_has_dirty_limit(void);
-void vm_dirty_param(struct vm_dirty_param *param);
+void vm_dirty_param(struct vm_dirty_param *param, u64 mem, u64 global);
 s64 mem_cgroup_page_stat(enum mem_cgroup_nr_pages_item item);
 
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
@@ -360,7 +360,8 @@ static inline bool mem_cgroup_has_dirty_
 	return false;
 }
 
-static inline void vm_dirty_param(struct vm_dirty_param *param)
+static inline void vm_dirty_param(struct vm_dirty_param *param,
+		u64 mem, u64 global)
 {
 	global_vm_dirty_param(param);
 }
Index: dirty_limit_new/mm/page-writeback.c
===================================================================
--- dirty_limit_new.orig/mm/page-writeback.c
+++ dirty_limit_new/mm/page-writeback.c
@@ -466,7 +466,8 @@ void global_dirty_limits(unsigned long *
 	struct task_struct *tsk;
 	struct vm_dirty_param dirty_param;
 
-	vm_dirty_param(&dirty_param);
+	vm_dirty_param(&dirty_param,
+		available_memory, global_dirtyable_memory());
 
 	if (dirty_param.dirty_bytes)
 		dirty = DIV_ROUND_UP(dirty_param.dirty_bytes, PAGE_SIZE);

