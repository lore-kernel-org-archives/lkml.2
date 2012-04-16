Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2DPMII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 08:08:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:56235 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab2DPMIH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 08:08:07 -0400
Message-ID: <1334578074.28150.38.camel@twins>
Subject: Re: [PATCH 2/5] perf: generic intel uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, andi@firstfloor.org, eranian@google.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Date: Mon, 16 Apr 2012 14:07:54 +0200
In-Reply-To: <4F77C75B.4060105@intel.com>
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>
	  <1332916998-10628-3-git-send-email-zheng.z.yan@intel.com>
	 <1333163902.2960.63.camel@laptop> <4F77C75B.4060105@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-01 at 11:11 +0800, Yan, Zheng wrote:
> Any hints how to do this. I'm afraid it requires big changes to perf core.


Sorry for taking so long..


I think something like the (completely untested) below should suffice..

In your driver, have hotplug notifiers keep track of what cpu is the
active cpu for your node, if it needs to change due to it going offline,
pick a new one and use the below function to migrate the events.

The only missing piece is not doing the normal
perf_event_exit_cpu_context() thing for these PMUs, except of course
once there's no cpus left in your node.

Doing that might want an extra struct pmu method, which if not set
defaults to perf_event_exit_cpu_context, and otherwise does your custom
migrate/exit.

---
 kernel/events/core.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a6a9ec4..824becf 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1641,6 +1641,8 @@ perf_install_in_context(struct perf_event_context *ctx,
 	lockdep_assert_held(&ctx->mutex);
 
 	event->ctx = ctx;
+	if (event->cpu != -1)
+		event->cpu = cpu;
 
 	if (!task) {
 		/*
@@ -6375,6 +6377,8 @@ SYSCALL_DEFINE5(perf_event_open,
 	mutex_lock(&ctx->mutex);
 
 	if (move_group) {
+		synchronize_rcu();
+
 		perf_install_in_context(ctx, group_leader, cpu);
 		get_ctx(ctx);
 		list_for_each_entry(sibling, &group_leader->sibling_list,
@@ -6477,6 +6481,35 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 }
 EXPORT_SYMBOL_GPL(perf_event_create_kernel_counter);
 
+void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
+{
+	struct perf_cpu_context *src_cpuctx = per_cpu(pmu->pmu_cpu_context, src_cpu);
+	struct perf_cpu_context *dst_cpuctx = per_cpu(pmu->pmu_cpu_context, dst_cpu);
+	struct perf_event_context *src_ctx = &src_cpuctx->ctx;
+	struct perf_event_context *dst_ctx = &dst_cpuctx->ctx;
+	struct perf_event *event, *tmp;
+	LIST_HEAD(events);
+
+	mutex_lock(&src_ctx->mutex);
+	list_for_each_entry_safe(event, tmp, &src_ctx->event_list, event_entry) {
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

