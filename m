Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab1DKKqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 06:46:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:48168 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab1DKKqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 06:46:23 -0400
Date: Mon, 11 Apr 2011 10:45:57 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-e566b76ed30768140df8f0023904aed5a41244f7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110406005454.GA1062@quad>
References: <20110406005454.GA1062@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_event: Fix cgrp event scheduling bug in perf_enable_on_exec()
Git-Commit-ID: e566b76ed30768140df8f0023904aed5a41244f7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 10:46:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e566b76ed30768140df8f0023904aed5a41244f7
Gitweb:     http://git.kernel.org/tip/e566b76ed30768140df8f0023904aed5a41244f7
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 6 Apr 2011 02:54:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 11:07:55 +0200

perf_event: Fix cgrp event scheduling bug in perf_enable_on_exec()

There is a bug in perf_event_enable_on_exec() when cgroup events are
active on a CPU: the cgroup events may be scheduled twice causing event
state corruptions which eventually may lead to kernel panics.

The reason is that the function needs to first schedule out the cgroup
events, just like for the per-thread events. The cgroup event are
scheduled back in automatically from the perf_event_context_sched_in()
function.

The patch also adds a WARN_ON_ONCE() is perf_cgroup_switch() to catch any
bogus state.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110406005454.GA1062@quad
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 27960f1..8e81a98 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -364,6 +364,7 @@ void perf_cgroup_switch(struct task_struct *task, int mode)
 			}
 
 			if (mode & PERF_CGROUP_SWIN) {
+				WARN_ON_ONCE(cpuctx->cgrp);
 				/* set cgrp before ctxsw in to
 				 * allow event_filter_match() to not
 				 * have to pass task around
@@ -2423,6 +2424,14 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 	if (!ctx || !ctx->nr_events)
 		goto out;
 
+	/*
+	 * We must ctxsw out cgroup events to avoid conflict
+	 * when invoking perf_task_event_sched_in() later on
+	 * in this function. Otherwise we end up trying to
+	 * ctxswin cgroup events which are already scheduled
+	 * in.
+	 */
+	perf_cgroup_sched_out(current);
 	task_ctx_sched_out(ctx, EVENT_ALL);
 
 	raw_spin_lock(&ctx->lock);
@@ -2447,6 +2456,9 @@ static void perf_event_enable_on_exec(struct perf_event_context *ctx)
 
 	raw_spin_unlock(&ctx->lock);
 
+	/*
+	 * Also calls ctxswin for cgroup events, if any:
+	 */
 	perf_event_context_sched_in(ctx, ctx->task);
 out:
 	local_irq_restore(flags);
