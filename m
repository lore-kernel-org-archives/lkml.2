Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab2EBCHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 22:07:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:46532 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758387Ab2EBCH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 22:07:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="138970395"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] perf: Allow pmu to choose cpu on which to install event
Date: Wed,  2 May 2012 10:07:13 +0800
Message-Id: <1335924440-11242-3-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Allow the pmu->event_init callback to change event->cpu, so pmu can
choose cpu on which to install event.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
---
 kernel/events/core.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 32cfc76..84911de 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6250,6 +6250,8 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
+	get_online_cpus();
+
 	event = perf_event_alloc(&attr, cpu, task, group_leader, NULL,
 				 NULL, NULL);
 	if (IS_ERR(event)) {
@@ -6302,7 +6304,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	/*
 	 * Get the target context (task or percpu):
 	 */
-	ctx = find_get_context(pmu, task, cpu);
+	ctx = find_get_context(pmu, task, event->cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
 		goto err_alloc;
@@ -6375,20 +6377,22 @@ SYSCALL_DEFINE5(perf_event_open,
 	mutex_lock(&ctx->mutex);
 
 	if (move_group) {
-		perf_install_in_context(ctx, group_leader, cpu);
+		perf_install_in_context(ctx, group_leader, event->cpu);
 		get_ctx(ctx);
 		list_for_each_entry(sibling, &group_leader->sibling_list,
 				    group_entry) {
-			perf_install_in_context(ctx, sibling, cpu);
+			perf_install_in_context(ctx, sibling, event->cpu);
 			get_ctx(ctx);
 		}
 	}
 
-	perf_install_in_context(ctx, event, cpu);
+	perf_install_in_context(ctx, event, event->cpu);
 	++ctx->generation;
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
 
+	put_online_cpus();
+
 	event->owner = current;
 
 	mutex_lock(&current->perf_event_mutex);
@@ -6417,6 +6421,7 @@ SYSCALL_DEFINE5(perf_event_open,
 err_alloc:
 	free_event(event);
 err_task:
+	put_online_cpus();
 	if (task)
 		put_task_struct(task);
 err_group_fd:
-- 
1.7.7.6

