Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab2FTKwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:52:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34555 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab2FTKwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:52:51 -0400
Date: Wed, 20 Jun 2012 03:52:37 -0700
From: "tip-bot for Yan, Zheng" <zheng.z.yan@intel.com>
Message-ID: <tip-0cda4c023132aa93f2dd94811061f812e88daf4c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, zheng.z.yan@intel.com, tglx@linutronix.de
In-Reply-To: <1339741902-8449-5-git-send-email-zheng.z.yan@intel.com>
References: <1339741902-8449-5-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Introduce perf_pmu_migrate_context()
Git-Commit-ID: 0cda4c023132aa93f2dd94811061f812e88daf4c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 03:52:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0cda4c023132aa93f2dd94811061f812e88daf4c
Gitweb:     http://git.kernel.org/tip/0cda4c023132aa93f2dd94811061f812e88daf4c
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Fri, 15 Jun 2012 14:31:33 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Jun 2012 12:13:21 +0200

perf: Introduce perf_pmu_migrate_context()

Originally from Peter Zijlstra. The helper migrates perf events
from one cpu to another cpu.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1339741902-8449-5-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index fa36a39..f1cf0ed 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1645,6 +1645,8 @@ perf_install_in_context(struct perf_event_context *ctx,
 	lockdep_assert_held(&ctx->mutex);
 
 	event->ctx = ctx;
+	if (event->cpu != -1)
+		event->cpu = cpu;
 
 	if (!task) {
 		/*
@@ -6379,6 +6381,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	mutex_lock(&ctx->mutex);
 
 	if (move_group) {
+		synchronize_rcu();
 		perf_install_in_context(ctx, group_leader, event->cpu);
 		get_ctx(ctx);
 		list_for_each_entry(sibling, &group_leader->sibling_list,
@@ -6484,6 +6487,39 @@ err:
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
