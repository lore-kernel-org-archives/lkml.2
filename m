Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab2GaTrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 15:47:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:58934 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab2GaTon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 15:44:43 -0400
Message-Id: <20120731192808.397264606@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 31 Jul 2012 21:12:05 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, riel@redhat.com, oleg@redhat.com, pjt@google.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, Lee.Schermerhorn@hp.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 01/19] task_work: Remove dependency on sched.h
References: <20120731191204.540691987@chello.nl>
Content-Disposition: inline; filename=decouple-sched-task_work.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the need for sched.h from task_work.h so that we can use struct
task_work in struct task_struct in a later patch.

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/task_work.h |    7 -------
 kernel/exit.c             |    5 ++++-
 2 files changed, 4 insertions(+), 8 deletions(-)
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -2,7 +2,6 @@
 #define _LINUX_TASK_WORK_H
 
 #include <linux/list.h>
-#include <linux/sched.h>
 
 typedef void (*task_work_func_t)(struct callback_head *);
 
@@ -16,10 +15,4 @@ int task_work_add(struct task_struct *ta
 struct callback_head *task_work_cancel(struct task_struct *, task_work_func_t);
 void task_work_run(void);
 
-static inline void exit_task_work(struct task_struct *task)
-{
-	if (unlikely(task->task_works))
-		task_work_run();
-}
-
 #endif	/* _LINUX_TASK_WORK_H */
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -992,7 +992,10 @@ void do_exit(long code)
 	exit_shm(tsk);
 	exit_files(tsk);
 	exit_fs(tsk);
-	exit_task_work(tsk);
+
+	if (unlikely(tsk->task_works))
+		task_work_run();
+
 	check_stack_usage();
 	exit_thread();
 


