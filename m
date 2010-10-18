Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab0JRTUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:20:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:35038 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757513Ab0JRTUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:20:22 -0400
Date: Mon, 18 Oct 2010 19:19:54 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, matthltc@us.ibm.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, matthltc@us.ibm.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101014203625.278436085@chello.nl>
References: <20101014203625.278436085@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix task refcount bugs
Message-ID: <tip-e7d0bc047548d76feee6b23f7d3d9da927189a50@git.kernel.org>
Git-Commit-ID: e7d0bc047548d76feee6b23f7d3d9da927189a50
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:19:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7d0bc047548d76feee6b23f7d3d9da927189a50
Gitweb:     http://git.kernel.org/tip/e7d0bc047548d76feee6b23f7d3d9da927189a50
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 14 Oct 2010 16:54:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 19:58:52 +0200

perf: Fix task refcount bugs

Currently it looks like find_lively_task_by_vpid() takes a task ref
and relies on find_get_context() to drop it.

The problem is that perf_event_create_kernel_counter() shouldn't be
dropping task refs.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Matt Helsley <matthltc@us.ibm.com>
LKML-Reference: <20101014203625.278436085@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 346dc0e..f928878 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2190,11 +2190,9 @@ retry:
 		}
 	}
 
-	put_task_struct(task);
 	return ctx;
 
 errout:
-	put_task_struct(task);
 	return ERR_PTR(err);
 }
 
@@ -5602,7 +5600,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	ctx = find_get_context(pmu, task, cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
-		goto err_group_fd;
+		goto err_task;
 	}
 
 	/*
@@ -5698,6 +5696,9 @@ SYSCALL_DEFINE5(perf_event_open,
 
 err_context:
 	put_ctx(ctx);
+err_task:
+	if (task)
+		put_task_struct(task);
 err_group_fd:
 	fput_light(group_file, fput_needed);
 	free_event(event);
