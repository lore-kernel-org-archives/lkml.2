Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab1AGPda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:33:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:40674 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab1AGPd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:33:28 -0500
Date: Fri, 7 Jan 2011 15:32:58 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4d220593.2308e30a.48c5.ffff8ae9@mx.google.com>
References: <4d220593.2308e30a.48c5.ffff8ae9@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Generalize use of event_filter_match()
Message-ID: <tip-5632ab12e9e1fcd7e94058567e181d8f35e83798@git.kernel.org>
Git-Commit-ID: 5632ab12e9e1fcd7e94058567e181d8f35e83798
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 Jan 2011 15:32:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5632ab12e9e1fcd7e94058567e181d8f35e83798
Gitweb:     http://git.kernel.org/tip/5632ab12e9e1fcd7e94058567e181d8f35e83798
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 3 Jan 2011 18:20:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Jan 2011 15:08:51 +0100

perf_events: Generalize use of event_filter_match()

Replace all occurrences of:
	event->cpu != -1 && event->cpu == smp_processor_id()
by a call to:
	event_filter_match(event)

This makes the code more consistent and will make the cgroup
patch smaller.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4d220593.2308e30a.48c5.ffff8ae9@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 2c14e3a..dcdb19e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -949,7 +949,7 @@ static void __perf_install_in_context(void *info)
 
 	add_event_to_ctx(event, ctx);
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event))
 		goto unlock;
 
 	/*
@@ -1094,7 +1094,7 @@ static void __perf_event_enable(void *info)
 		goto unlock;
 	__perf_event_mark_enabled(event, ctx);
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event))
 		goto unlock;
 
 	/*
@@ -1441,7 +1441,7 @@ ctx_pinned_sched_in(struct perf_event_context *ctx,
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
 		if (event->state <= PERF_EVENT_STATE_OFF)
 			continue;
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event))
 			continue;
 
 		if (group_can_go_on(event, cpuctx, 1))
@@ -1473,7 +1473,7 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 		 * Listen to the 'cpu' scheduling filter constraint
 		 * of events:
 		 */
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event))
 			continue;
 
 		if (group_can_go_on(event, cpuctx, can_add_hw)) {
@@ -1700,7 +1700,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
 
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event))
 			continue;
 
 		hwc = &event->hw;
@@ -3899,7 +3899,7 @@ static int perf_event_task_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event))
 		return 0;
 
 	if (event->attr.comm || event->attr.mmap ||
@@ -4036,7 +4036,7 @@ static int perf_event_comm_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event))
 		return 0;
 
 	if (event->attr.comm)
@@ -4184,7 +4184,7 @@ static int perf_event_mmap_match(struct perf_event *event,
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event))
 		return 0;
 
 	if ((!executable && event->attr.mmap_data) ||
