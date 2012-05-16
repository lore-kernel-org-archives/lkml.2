Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967312Ab2EPFA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 01:00:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:40526 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967299Ab2EPFAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 01:00:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100617199"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] perf: Introduce perf_pmu_migrate_context
Date: Wed, 16 May 2012 12:59:57 +0800
Message-Id: <1337144403-30841-5-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
References: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Originally from Peter Zijlstra. The helper migrates perf events
from one cpu to another cpu.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
---
 include/linux/perf_event.h |    2 ++
 kernel/events/core.c       |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8adf70e..c8abdd2 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1104,6 +1104,8 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr,
 				struct task_struct *task,
 				perf_overflow_handler_t callback,
 				void *context);
+extern void perf_pmu_migrate_context(struct pmu *pmu,
+				int src_cpu, int dst_cpu);
 extern u64 perf_event_read_value(struct perf_event *event,
 				 u64 *enabled, u64 *running);
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6a2d0b9..2857878 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1641,6 +1641,8 @@ perf_install_in_context(struct perf_event_context *ctx,
 	lockdep_assert_held(&ctx->mutex);
 
 	event->ctx = ctx;
+	if (event->cpu != -1)
+		event->cpu = cpu;
 
 	if (!task) {
 		/*
@@ -6382,6 +6384,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	mutex_lock(&ctx->mutex);
 
 	if (move_group) {
+		synchronize_rcu();
 		perf_install_in_context(ctx, group_leader, event->cpu);
 		get_ctx(ctx);
 		list_for_each_entry(sibling, &group_leader->sibling_list,
@@ -6487,6 +6490,39 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 }
 EXPORT_SYMBOL_GPL(perf_event_create_kernel_counter);
 
+void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
+{
+	struct perf_event_context *src_ctx;
+	struct perf_event_context *dst_ctx;
+	struct perf_event *event, *tmp;
+	LIST_HEAD(events);
+
+	src_ctx = &per_cpu_ptr(pmu->pmu_cpu_context, src_cpu)->ctx;
+	dst_ctx = &per_cpu_ptr(pmu->pmu_cpu_context, dst_cpu)->ctx;
+
+	mutex_lock(&src_ctx->mutex);
+	list_for_each_entry_safe(event, tmp, &src_ctx->event_list,
+				 event_entry) {
+		perf_remove_from_context(event);
+		put_ctx(src_ctx);
+		list_add(&event->event_entry, &events);
+	}
+	mutex_unlock(&src_ctx->mutex);
+
+	synchronize_rcu();
+
+	mutex_lock(&dst_ctx->mutex);
+	list_for_each_entry_safe(event, tmp, &events, event_entry) {
+		list_del(&event->event_entry);
+		if (event->state >= PERF_EVENT_STATE_OFF)
+			event->state = PERF_EVENT_STATE_INACTIVE;
+		perf_install_in_context(dst_ctx, event, dst_cpu);
+		get_ctx(dst_ctx);
+	}
+	mutex_unlock(&dst_ctx->mutex);
+}
+EXPORT_SYMBOL_GPL(perf_pmu_migrate_context);
+
 static void sync_child_event(struct perf_event *child_event,
 			       struct task_struct *child)
 {
-- 
1.7.7.6

