Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1DFAyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 20:54:47 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30459 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1DFAyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 20:54:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=EcFSQ1GDmW/YyLkX7QMAaNirv544d2lie98XPfUV6+gj5EVCagfuTlCiAwsGkVmBBL
         WmtJLAWfjg0VFowLRjJQ==
Date: Wed, 6 Apr 2011 02:54:54 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, perfmon2-devel@lists.sf.net,
        paulus@samba.org, davem@davemloft.net
Subject: [PATCH] perf_event: fix cgrp event scheduling bug in
 perf_enable_on_exec()
Message-ID: <20110406005454.GA1062@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is a bug in perf_event_enable_on_exec() when cgroup
events are active on a CPU. The cgroup events may be scheduled
twice causing event state corruptions which eventually may lead
to kernel panics. The reason is that the function needs to first
schedule out the cgroup events, just like for the per-thread events.
The cgroup event are scheduled back in automatically from the
perf_event_context_sched_in() function.

The patch also adds a WARN_ON_ONCE() is perf_cgroup_switch()
to catch any bogus state.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 27960f1..badeb0a 100644
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
+	 * we must ctxsw out cgroup events to avoid conflict
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
+	 * also calls ctxswin for cgroup events, if any
+	 */
 	perf_event_context_sched_in(ctx, ctx->task);
 out:
 	local_irq_restore(flags);
