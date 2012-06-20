Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab2FTKwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:52:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34540 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab2FTKwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:52:00 -0400
Date: Wed, 20 Jun 2012 03:51:45 -0700
From: "tip-bot for Yan, Zheng" <zheng.z.yan@intel.com>
Message-ID: <tip-e2d37cd213dcc0aeb3db4b37b9bd1710fe36fbf7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, zheng.z.yan@intel.com, tglx@linutronix.de
In-Reply-To: <1339741902-8449-4-git-send-email-zheng.z.yan@intel.com>
References: <1339741902-8449-4-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Allow the PMU driver to choose the CPU on which to install events
Git-Commit-ID: e2d37cd213dcc0aeb3db4b37b9bd1710fe36fbf7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 03:51:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2d37cd213dcc0aeb3db4b37b9bd1710fe36fbf7
Gitweb:     http://git.kernel.org/tip/e2d37cd213dcc0aeb3db4b37b9bd1710fe36fbf7
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Fri, 15 Jun 2012 14:31:32 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Jun 2012 12:13:21 +0200

perf: Allow the PMU driver to choose the CPU on which to install events

Allow the pmu->event_init callback to change event->cpu, so the PMU driver
can choose the CPU on which to install events.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1339741902-8449-4-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 31d182e..fa36a39 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6306,7 +6306,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	/*
 	 * Get the target context (task or percpu):
 	 */
-	ctx = find_get_context(pmu, task, cpu);
+	ctx = find_get_context(pmu, task, event->cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
 		goto err_alloc;
@@ -6379,16 +6379,16 @@ SYSCALL_DEFINE5(perf_event_open,
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
