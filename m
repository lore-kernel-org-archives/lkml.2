Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab1LGPpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 10:45:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48679 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab1LGPpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 10:45:11 -0500
Date: Wed, 7 Dec 2011 07:44:48 -0800
From: tip-bot for Gleb Natapov <gleb@redhat.com>
Message-ID: <tip-86b47c25494b824da655b95f6fdb4fdb3f17aa77@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111122140821.GF2557@redhat.com>
References: <20111122140821.GF2557@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Do no try to schedule task events if there are none
Git-Commit-ID: 86b47c25494b824da655b95f6fdb4fdb3f17aa77
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 07 Dec 2011 07:44:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86b47c25494b824da655b95f6fdb4fdb3f17aa77
Gitweb:     http://git.kernel.org/tip/86b47c25494b824da655b95f6fdb4fdb3f17aa77
Author:     Gleb Natapov <gleb@redhat.com>
AuthorDate: Tue, 22 Nov 2011 16:08:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 7 Dec 2011 16:31:22 +0100

perf: Do no try to schedule task events if there are none

perf_event_sched_in() shouldn't try to schedule task events if there
are none otherwise task's ctx->is_active will be set and will not be
cleared during sched_out. This will prevent newly added events from
being scheduled into the task context.

Fixes a boo-boo in commit 1d5f003f5a9 ("perf: Do not set task_ctx
pointer in cpuctx if there are no events in the context").

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111122140821.GF2557@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 600c162..d3b9df5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2174,11 +2174,11 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 	 */
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
-	perf_event_sched_in(cpuctx, ctx, task);
-
 	if (ctx->nr_events)
 		cpuctx->task_ctx = ctx;
 
+	perf_event_sched_in(cpuctx, cpuctx->task_ctx, task);
+
 	perf_pmu_enable(ctx->pmu);
 	perf_ctx_unlock(cpuctx, ctx);
 
