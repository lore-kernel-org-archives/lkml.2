Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab0JNVKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:10:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:44621 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab0JNVKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:10:41 -0400
Message-Id: <20101014203625.278436085@chello.nl>
User-Agent: quilt/0.47-1
Date: Thu, 14 Oct 2010 22:34:05 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: [RFC][PATCH 1/7] perf: Fix task refcount issues
References: <20101014203404.222133139@chello.nl>
Content-Disposition: inline; filename=perf-fix-hw_bp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently it looks like find_lively_task_by_vpid() takes a task ref
and relies on find_get_context() to drop it.

The problem is that perf_event_create_kernel_counter() shouldn't be
dropping task refs.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
---
 kernel/perf_event.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -2124,11 +2124,9 @@ find_get_context(struct pmu *pmu, struct
 		}
 	}
 
-	put_task_struct(task);
 	return ctx;
 
 errout:
-	put_task_struct(task);
 	return ERR_PTR(err);
 }
 
@@ -5536,7 +5534,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	ctx = find_get_context(pmu, task, cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
-		goto err_group_fd;
+		goto err_task;
 	}
 
 	/*
@@ -5632,6 +5630,9 @@ SYSCALL_DEFINE5(perf_event_open,
 
 err_context:
 	put_ctx(ctx);
+err_task:
+	if (task)
+		put_task_struct(task);
 err_group_fd:
 	fput_light(group_file, fput_needed);
 	free_event(event);


