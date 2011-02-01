Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab1BAU7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:59:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:41375 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab1BAU7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:59:44 -0500
Subject: Re: [PATCH] perf: Cure task_oncpu_function_call() races
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1296583698.26581.279.camel@laptop>
References: <20110127221856.GA10539@redhat.com>
	 <1296215577.15234.333.camel@laptop> <1296226667.15234.337.camel@laptop>
	 <20110128162847.GA25088@redhat.com> <1296238278.15234.340.camel@laptop>
	 <20110131172626.GA5407@redhat.com> <1296498205.26581.54.camel@laptop>
	 <20110131191109.GA10906@redhat.com> <1296502154.26581.72.camel@laptop>
	 <1296569037.26581.194.camel@laptop>  <20110201172757.GA4586@redhat.com>
	 <1296583698.26581.279.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 22:00:38 +0100
Message-ID: <1296594038.26581.304.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 19:08 +0100, Peter Zijlstra wrote:
> perf_install_in_context() works on a ctx obtained by find_get_context(),
> that context is either new (uncloned) or existing in which case it
> called unclone_ctx(). So I was thinking there was no race with the ctx
> flipping in perf_event_context_sched_out(), _however_ since it only
> acquires ctx->mutex after calling unclone_ctx() there is a race window
> with perf_event_init_task().
> 
> This race we should fix with perf_pin_task_context()

I came up with the below.. I'll give it some runtime tomorrow, my brain
just gave up for today.. 

---
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -327,7 +327,6 @@ static void perf_unpin_context(struct pe
 	raw_spin_lock_irqsave(&ctx->lock, flags);
 	--ctx->pin_count;
 	raw_spin_unlock_irqrestore(&ctx->lock, flags);
-	put_ctx(ctx);
 }
 
 /*
@@ -741,10 +740,10 @@ static void perf_remove_from_context(str
 
 	raw_spin_lock_irq(&ctx->lock);
 	/*
-	 * If we failed to find a running task, but find it running now that
-	 * we've acquired the ctx->lock, retry.
+	 * If we failed to find a running task, but find the context active now
+	 * that we've acquired the ctx->lock, retry.
 	 */
-	if (task_curr(task)) {
+	if (ctx->is_active) {
 		raw_spin_unlock_irq(&ctx->lock);
 		goto retry;
 	}
@@ -1104,10 +1103,10 @@ perf_install_in_context(struct perf_even
 
 	raw_spin_lock_irq(&ctx->lock);
 	/*
-	 * If we failed to find a running task, but find it running now that
-	 * we've acquired the ctx->lock, retry.
+	 * If we failed to find a running task, but find the context active now
+	 * that we've acquired the ctx->lock, retry.
 	 */
-	if (task_curr(task)) {
+	if (ctx->is_active) {
 		raw_spin_unlock_irq(&ctx->lock);
 		goto retry;
 	}
@@ -2278,6 +2277,9 @@ find_lively_task_by_vpid(pid_t vpid)
 
 }
 
+/*
+ * Returns a matching context with refcount and pincount.
+ */
 static struct perf_event_context *
 find_get_context(struct pmu *pmu, struct task_struct *task, int cpu)
 {
@@ -2302,6 +2304,7 @@ find_get_context(struct pmu *pmu, struct
 		cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
 		ctx = &cpuctx->ctx;
 		get_ctx(ctx);
+		++ctx->pin_count;
 
 		return ctx;
 	}
@@ -2315,6 +2318,7 @@ find_get_context(struct pmu *pmu, struct
 	ctx = perf_lock_task_context(task, ctxn, &flags);
 	if (ctx) {
 		unclone_ctx(ctx);
+		++ctx->pin_count;
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	}
 
@@ -6041,6 +6045,7 @@ SYSCALL_DEFINE5(perf_event_open,
 
 	perf_install_in_context(ctx, event, cpu);
 	++ctx->generation;
+	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
 
 	event->owner = current;
@@ -6066,6 +6071,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	return event_fd;
 
 err_context:
+	perf_unpin_context(ctx);
 	put_ctx(ctx);
 err_alloc:
 	free_event(event);
@@ -6116,6 +6122,7 @@ perf_event_create_kernel_counter(struct
 	mutex_lock(&ctx->mutex);
 	perf_install_in_context(ctx, event, cpu);
 	++ctx->generation;
+	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
 
 	return event;
@@ -6591,6 +6598,7 @@ int perf_event_init_context(struct task_
 	mutex_unlock(&parent_ctx->mutex);
 
 	perf_unpin_context(parent_ctx);
+	put_ctx(parent_ctx);
 
 	return ret;
 }


