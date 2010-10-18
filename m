Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988Ab0JRTUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:20:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:35046 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839Ab0JRTUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:20:41 -0400
Date: Mon, 18 Oct 2010 19:20:16 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101014203625.340789919@chello.nl>
References: <20101014203625.340789919@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Find task before event alloc
Message-ID: <tip-c6be5a5cb62592d9d661899a2aa78236eb00ffa5@git.kernel.org>
Git-Commit-ID: c6be5a5cb62592d9d661899a2aa78236eb00ffa5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:20:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c6be5a5cb62592d9d661899a2aa78236eb00ffa5
Gitweb:     http://git.kernel.org/tip/c6be5a5cb62592d9d661899a2aa78236eb00ffa5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 14 Oct 2010 16:59:46 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 19:58:54 +0200

perf: Find task before event alloc

So that we can pass the task pointer to the event allocation, so that
we can use task associated data during event initialization.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101014203625.340789919@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f928878..b21d06a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5551,10 +5551,18 @@ SYSCALL_DEFINE5(perf_event_open,
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
@@ -5586,21 +5594,13 @@ SYSCALL_DEFINE5(perf_event_open,
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
@@ -5696,12 +5696,13 @@ SYSCALL_DEFINE5(perf_event_open,
 
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
