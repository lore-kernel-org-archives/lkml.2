Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab2FOGew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 02:34:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:19105 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab2FOGca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 02:32:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="156658699"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, jolsa@redhat.com,
        eranian@google.com, andi@firstfloor.org, linux-kernel@vger.kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V6 03/13] perf: Allow pmu to choose cpu on which to install event
Date: Fri, 15 Jun 2012 14:31:32 +0800
Message-Id: <1339741902-8449-4-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Allow the pmu->event_init callback to change event->cpu, so pmu can
choose cpu on which to install event.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
---
 kernel/events/core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d71a2d6..2c05027 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6302,7 +6302,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	/*
 	 * Get the target context (task or percpu):
 	 */
-	ctx = find_get_context(pmu, task, cpu);
+	ctx = find_get_context(pmu, task, event->cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
 		goto err_alloc;
@@ -6375,16 +6375,16 @@ SYSCALL_DEFINE5(perf_event_open,
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
-- 
1.7.6.5

