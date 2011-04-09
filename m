Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693Ab1DITXO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 15:23:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34440 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab1DITWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 15:22:43 -0400
Message-Id: <20110409192141.719340481@chello.nl>
User-Agent: quilt/0.48-1
Date: Sat, 09 Apr 2011 21:17:41 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 2/9] perf: Clean up ctx reference counting
References: <20110409191739.813727025@chello.nl>
Content-Disposition: inline; filename=perf-cleanup-ctx-ref.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small cleanup to how we refcount in find_get_context(), this also
allows us to use put_ctx() to free things instead of using kfree().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -2831,16 +2831,12 @@ find_get_context(struct pmu *pmu, struct
 		unclone_ctx(ctx);
 		++ctx->pin_count;
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
-	}
-
-	if (!ctx) {
+	} else {
 		ctx = alloc_perf_context(pmu, task);
 		err = -ENOMEM;
 		if (!ctx)
 			goto errout;
 
-		get_ctx(ctx);
-
 		err = 0;
 		mutex_lock(&task->perf_event_mutex);
 		/*
@@ -2852,14 +2848,14 @@ find_get_context(struct pmu *pmu, struct
 		else if (task->perf_event_ctxp[ctxn])
 			err = -EAGAIN;
 		else {
+			get_ctx(ctx);
 			++ctx->pin_count;
 			rcu_assign_pointer(task->perf_event_ctxp[ctxn], ctx);
 		}
 		mutex_unlock(&task->perf_event_mutex);
 
 		if (unlikely(err)) {
-			put_task_struct(task);
-			kfree(ctx);
+			put_ctx(ctx);
 
 			if (err == -EAGAIN)
 				goto retry;


