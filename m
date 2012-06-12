Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab2FLFiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 01:38:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:15233 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab2FLFiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 01:38:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="111014182"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, jolsa@redhat.com,
        eranian@google.com, andi@firstfloor.org, linux-kernel@vger.kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V5 03/13] perf: Allow pmu to choose cpu on which to install event
Date: Tue, 12 Jun 2012 13:37:38 +0800
Message-Id: <1339479468-3815-4-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1339479468-3815-1-git-send-email-zheng.z.yan@intel.com>
References: <1339479468-3815-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Allow the pmu->event_init callback to change event->cpu, so pmu can
choose cpu on which to install event.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
---
 kernel/events/core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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
1.7.10.2

