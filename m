Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab1FFOie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:38:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab1FFOid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:38:33 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: pzijlstr@redhat.com, paulus@samba.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf, core: Fix initial task_ctx/event installation
Date: Mon,  6 Jun 2011 16:38:15 +0200
Message-Id: <1307371095-10141-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I think I found a bug in the __perf_install_in_context. The attached
patch fixies the problem for me, but I'm not sure it did not break
anything else.. ;)

thanks,
jirka

---
The __perf_install_in_context function does not install context
events in case there's no active task context.

This might cause incorrect counts if application opens counter
in its own task context. 

Following scenario leads to wrong counts:
(this is the case for "perf test - test__open_syscall_event
which counts sys_enter_open calls)

1  - application is scheduled in
2  - application enters perf_event_open syscall with its own pid
3  - event/context is created
4  - __perf_install_in_context is called
5  - cpuctx->task_ctx is NULL
6  - perf_event_sched_in gets called with ctx == NULL, new event is not scheduled in
7  - application leaves the perf_event_open syscall
8  - application running code leading to increment the event counter
     !!! this is where we lost the counts, since the event is not scheduled in !!!
9  - application is scheduled out
11 - application is scheduled in
12 - event is properly sceduled in
13 - event counter is now incremented

If the task is scheduled out and back in after the context is installed,
but before it exits the perf_event_open syscall, the task_ctx gets
properly set and event is properly scheduled in. In this case
the perf test returns proper counts.

Attached patch changed this behaviour to install new task_ctx
even if the current task_ctx is NULL.

Tested by succesfully running perf test command.


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/events/core.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ba89f40..291fb72 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1511,17 +1511,18 @@ static int  __perf_install_in_context(void *info)
 	/*
 	 * If there was an active task_ctx schedule it out.
 	 */
-	if (task_ctx) {
+	if (task_ctx)
 		task_ctx_sched_out(task_ctx);
-		/*
-		 * If the context we're installing events in is not the
-		 * active task_ctx, flip them.
-		 */
-		if (ctx->task && task_ctx != ctx) {
-			raw_spin_unlock(&cpuctx->ctx.lock);
-			raw_spin_lock(&ctx->lock);
-			cpuctx->task_ctx = task_ctx = ctx;
-		}
+
+	/*
+	 * If the context we're installing events in is not the
+	 * active task_ctx, flip them.
+	 */
+	if (ctx->task && task_ctx != ctx) {
+		if (task_ctx)
+			raw_spin_unlock(&task_ctx->lock);
+		raw_spin_lock(&ctx->lock);
+		cpuctx->task_ctx = task_ctx = ctx;
 		task = task_ctx->task;
 	}
 	cpu_ctx_sched_out(cpuctx, EVENT_ALL);
-- 
1.7.1

