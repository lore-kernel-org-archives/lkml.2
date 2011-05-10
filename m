Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab1EJKUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:20:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44876 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab1EJKUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:20:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 10 May 2011 19:13:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ying Han <yinghan@google.com>, Johannes Weiner <jweiner@redhat.com>,
        Michal Hocko <mhocko@suse.cz>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC][PATCH 7/7] memcg: workqueue for async reclaim
Message-Id: <20110510191353.fb17efb8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110510190216.f4eefef7.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110510190216.f4eefef7.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

workqueue for memory cgroup asynchronous memory shrinker.

This patch implements the workqueue of async shrinker routine. each
memcg has a work and only one work can be scheduled at the same time.

If shrinking memory doesn't goes well, delay will be added to the work.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   82 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 79 insertions(+), 3 deletions(-)

Index: mmotm-May6/mm/memcontrol.c
===================================================================
--- mmotm-May6.orig/mm/memcontrol.c
+++ mmotm-May6/mm/memcontrol.c
@@ -305,6 +305,12 @@ struct mem_cgroup {
 	 * mem_cgroup ? And what type of charges should we move ?
 	 */
 	unsigned long 	move_charge_at_immigrate;
+
+	/* For asynchronous memory reclaim */
+	struct delayed_work	async_work;
+	unsigned long		async_work_flags;
+#define ASYNC_NORESCHED	(0)	/* need to stop scanning */
+#define ASYNC_RUNNING	(1)	/* a work is in schedule or running. */
 	/*
 	 * percpu counter.
 	 */
@@ -3631,6 +3637,74 @@ unsigned long mem_cgroup_soft_limit_recl
 	return nr_reclaimed;
 }
 
+struct workqueue_struct *memcg_async_shrinker;
+
+static int memcg_async_shrinker_init(void)
+{
+	memcg_async_shrinker = alloc_workqueue("memcg_async",
+				WQ_MEM_RECLAIM | WQ_UNBOUND | WQ_FREEZABLE, 0);
+	return 0;
+}
+module_init(memcg_async_shrinker_init);
+
+static void mem_cgroup_async_shrink(struct work_struct *work)
+{
+	struct delayed_work *dw = to_delayed_work(work);
+	struct mem_cgroup *mem = container_of(dw,
+			struct mem_cgroup, async_work);
+	bool congested = false;
+	int delay = 0;
+	unsigned long long required, usage, limit, shrink_to;
+
+	limit = res_counter_read_u64(&mem->res, RES_LIMIT);
+	shrink_to = limit - MEMCG_ASYNC_STOP_MARGIN - PAGE_SIZE;
+	usage = res_counter_read_u64(&mem->res, RES_USAGE);
+	if (shrink_to <= usage) {
+		required = usage - shrink_to;
+		required = (required >> PAGE_SHIFT) + 1;
+		/*
+		 * This scans some number of pages and returns that memory
+		 * reclaim was slow or now. If slow, we add a delay as
+		 * congestion_wait() in vmscan.c
+		 */
+		congested = mem_cgroup_shrink_static_scan(mem, (long)required);
+	}
+	if (test_bit(ASYNC_NORESCHED, &mem->async_work_flags)
+	    || mem_cgroup_async_should_stop(mem))
+		goto finish_scan;
+	/* If memory reclaim couldn't go well, add delay */
+	if (congested)
+		delay = HZ/10;
+
+	if (queue_delayed_work(memcg_async_shrinker, &mem->async_work, delay))
+		return;
+finish_scan:
+	cgroup_release_and_wakeup_rmdir(&mem->css);
+	clear_bit(ASYNC_RUNNING, &mem->async_work_flags);
+	return;
+}
+
+static void run_mem_cgroup_async_shrinker(struct mem_cgroup *mem)
+{
+	if (test_bit(ASYNC_NORESCHED, &mem->async_work_flags))
+		return;
+	if (test_and_set_bit(ASYNC_RUNNING, &mem->async_work_flags))
+		return;
+	cgroup_exclude_rmdir(&mem->css);
+	if (!queue_delayed_work(memcg_async_shrinker, &mem->async_work, 0)) {
+		cgroup_release_and_wakeup_rmdir(&mem->css);
+		clear_bit(ASYNC_RUNNING, &mem->async_work_flags);
+	}
+	return;
+}
+
+static void stop_mem_cgroup_async_shrinker(struct mem_cgroup *mem)
+{
+	set_bit(ASYNC_NORESCHED, &mem->async_work_flags);
+	flush_delayed_work(&mem->async_work);
+	clear_bit(ASYNC_NORESCHED, &mem->async_work_flags);
+}
+
 bool mem_cgroup_async_should_stop(struct mem_cgroup *mem)
 {
 	return res_counter_margin(&mem->res) >= MEMCG_ASYNC_STOP_MARGIN;
@@ -3640,9 +3714,8 @@ static void mem_cgroup_may_async_reclaim
 {
 	if (!mem->need_async_reclaim)
 		return;
-	if (res_counter_margin(&mem->res) <= MEMCG_ASYNC_START_MARGIN) {
-		/* Fill here */
-	}
+	if (res_counter_margin(&mem->res) <= MEMCG_ASYNC_START_MARGIN)
+		run_mem_cgroup_async_shrinker(mem);
 }
 
 /*
@@ -3727,6 +3800,7 @@ move_account:
 		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
 			goto out;
 		ret = -EINTR;
+		stop_mem_cgroup_async_shrinker(mem);
 		if (signal_pending(current))
 			goto out;
 		/* This is for making all *used* pages to be on LRU. */
@@ -4897,6 +4971,7 @@ mem_cgroup_create(struct cgroup_subsys *
 		mem->swappiness = mem_cgroup_swappiness(parent);
 	atomic_set(&mem->refcnt, 1);
 	mem->move_charge_at_immigrate = 0;
+	INIT_DELAYED_WORK(&mem->async_work, mem_cgroup_async_shrink);
 	mutex_init(&mem->thresholds_lock);
 	return &mem->css;
 free_out:

