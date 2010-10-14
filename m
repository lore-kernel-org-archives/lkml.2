Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab0JNVKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:10:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:44598 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab0JNVKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:10:22 -0400
Message-Id: <20101014203625.340789919@chello.nl>
User-Agent: quilt/0.47-1
Date: Thu, 14 Oct 2010 22:34:06 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 2/7] perf: Find task before event alloc
References: <20101014203404.222133139@chello.nl>
Content-Disposition: inline; filename=perf-fix-hw_bp-1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that we can pass the task pointer to the event allocation, so that
we can use task associated data during event initialization.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -5485,10 +5485,18 @@ SYSCALL_DEFINE5(perf_event_open,
 			group_leader = NULL;
 	}
 
+	if (pid != -1) {
+		task = find_lively_task_by_vpid(pid);
+		if (IS_ERR(task)) {
+			err = PTR_ERR(task);
+			goto err_group_fd;
+		}
+	}
+
 	event = perf_event_alloc(&attr, cpu, group_leader, NULL, NULL);
 	if (IS_ERR(event)) {
 		err = PTR_ERR(event);
-		goto err_fd;
+		goto err_task;
 	}
 
 	/*
@@ -5520,21 +5528,13 @@ SYSCALL_DEFINE5(perf_event_open,
 		}
 	}
 
-	if (pid != -1) {
-		task = find_lively_task_by_vpid(pid);
-		if (IS_ERR(task)) {
-			err = PTR_ERR(task);
-			goto err_group_fd;
-		}
-	}
-
 	/*
 	 * Get the target context (task or percpu):
 	 */
 	ctx = find_get_context(pmu, task, cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
-		goto err_task;
+		goto err_alloc;
 	}
 
 	/*
@@ -5630,12 +5630,13 @@ SYSCALL_DEFINE5(perf_event_open,
 
 err_context:
 	put_ctx(ctx);
+err_alloc:
+	free_event(event);
 err_task:
 	if (task)
 		put_task_struct(task);
 err_group_fd:
 	fput_light(group_file, fput_needed);
-	free_event(event);
 err_fd:
 	put_unused_fd(event_fd);
 	return err;


