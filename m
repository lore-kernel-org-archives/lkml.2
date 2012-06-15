Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab2FOGcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 02:32:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:19105 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043Ab2FOGcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 02:32:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="156658712"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, jolsa@redhat.com,
        eranian@google.com, andi@firstfloor.org, linux-kernel@vger.kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V6 04/13] perf: Introduce perf_pmu_migrate_context
Date: Fri, 15 Jun 2012 14:31:33 +0800
Message-Id: <1339741902-8449-5-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
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
index 1ce887a..76c5c8b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1107,6 +1107,8 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr,
 				struct task_struct *task,
 				perf_overflow_handler_t callback,
 				void *context);
+extern void perf_pmu_migrate_context(struct pmu *pmu,
+				int src_cpu, int dst_cpu);
 extern u64 perf_event_read_value(struct perf_event *event,
 				 u64 *enabled, u64 *running);
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2c05027..2e54e74 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1641,6 +1641,8 @@ perf_install_in_context(struct perf_event_context *ctx,
 	lockdep_assert_held(&ctx->mutex);
 
 	event->ctx = ctx;
+	if (event->cpu != -1)
+		event->cpu = cpu;
 
 	if (!task) {
 		/*
@@ -6375,6 +6377,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	mutex_lock(&ctx->mutex);
 
 	if (move_group) {
+		synchronize_rcu();
 		perf_install_in_context(ctx, group_leader, event->cpu);
 		get_ctx(ctx);
 		list_for_each_entry(sibling, &group_leader->sibling_list,
@@ -6480,6 +6483,39 @@ err:
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
1.7.6.5

