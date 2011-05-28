Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab1E1QlJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:41:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:55295 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab1E1QlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:41:06 -0400
Date: Sat, 28 May 2011 16:40:55 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-db24d33e08b88e990991760a44d72006a5dc6102@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110409192141.930282378@chello.nl>
References: <20110409192141.930282378@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Change and simplify ctx::is_active semantics
Git-Commit-ID: db24d33e08b88e990991760a44d72006a5dc6102
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 16:40:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db24d33e08b88e990991760a44d72006a5dc6102
Gitweb:     http://git.kernel.org/tip/db24d33e08b88e990991760a44d72006a5dc6102
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 9 Apr 2011 21:17:45 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 May 2011 18:01:17 +0200

perf: Change and simplify ctx::is_active semantics

Instead of tracking if a context is active or not, track which events
of the context are active. By making it a bitmask of
EVENT_PINNED|EVENT_FLEXIBLE we can simplify some of the scheduling
routines since it can avoid adding events that are already active.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110409192141.930282378@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 60b333a..71c2d44 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1763,8 +1763,9 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 			  enum event_type_t event_type)
 {
 	struct perf_event *event;
+	int is_active = ctx->is_active;
 
-	ctx->is_active = 0;
+	ctx->is_active &= ~event_type;
 	if (likely(!ctx->nr_events))
 		return;
 
@@ -1774,12 +1775,12 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 		return;
 
 	perf_pmu_disable(ctx->pmu);
-	if (event_type & EVENT_PINNED) {
+	if ((is_active & EVENT_PINNED) && (event_type & EVENT_PINNED)) {
 		list_for_each_entry(event, &ctx->pinned_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
 	}
 
-	if (event_type & EVENT_FLEXIBLE) {
+	if ((is_active & EVENT_FLEXIBLE) && (event_type & EVENT_FLEXIBLE)) {
 		list_for_each_entry(event, &ctx->flexible_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
 	}
@@ -2058,8 +2059,9 @@ ctx_sched_in(struct perf_event_context *ctx,
 	     struct task_struct *task)
 {
 	u64 now;
+	int is_active = ctx->is_active;
 
-	ctx->is_active = 1;
+	ctx->is_active |= event_type;
 	if (likely(!ctx->nr_events))
 		return;
 
@@ -2070,11 +2072,11 @@ ctx_sched_in(struct perf_event_context *ctx,
 	 * First go through the list and put on any pinned groups
 	 * in order to give them the best chance of going on.
 	 */
-	if (event_type & EVENT_PINNED)
+	if (!(is_active & EVENT_PINNED) && (event_type & EVENT_PINNED))
 		ctx_pinned_sched_in(ctx, cpuctx);
 
 	/* Then walk through the lower prio flexible groups */
-	if (event_type & EVENT_FLEXIBLE)
+	if (!(is_active & EVENT_FLEXIBLE) && (event_type & EVENT_FLEXIBLE))
 		ctx_flexible_sched_in(ctx, cpuctx);
 }
 
