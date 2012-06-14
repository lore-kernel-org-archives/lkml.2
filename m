Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2FNMZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 08:25:08 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47997 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab2FNMZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 08:25:04 -0400
MIME-Version: 1.0
Date: Thu, 14 Jun 2012 20:25:03 +0800
Message-ID: <CAJd=RBAYnCnugDmFiU0tzRQkqmd5uDku3C4vRvP2Sk-H-AKoNQ@mail.gmail.com>
Subject: [patch] BFS 421: remove mem barrier when setting task cpu
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With runqueue lock held, update tasks cpu without mem barrier.

--- a/kernel/sched/bfs.c	Thu Jun 14 20:05:42 2012
+++ b/kernel/sched/bfs.c	Thu Jun 14 20:06:22 2012
@@ -1034,13 +1034,8 @@ void set_task_cpu(struct task_struct *p,
 	if (task_cpu(p) != cpu)
 		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, NULL, 0);

-	/*
-	 * After ->cpu is set up to a new value, task_grq_lock(p, ...) can be
-	 * successfully executed on another CPU. We must ensure that updates of
-	 * per-task data have been completed by this moment.
-	 */
-	smp_wmb();
-	task_thread_info(p)->cpu = cpu;
+	if (task_thread_info(p)->cpu != cpu)
+		task_thread_info(p)->cpu = cpu;
 }

 static inline void clear_sticky(struct task_struct *p)
--
