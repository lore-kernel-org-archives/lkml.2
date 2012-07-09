Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab2GIMYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:24:40 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51864 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab2GIMYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:24:39 -0400
MIME-Version: 1.0
Date: Mon, 9 Jul 2012 20:24:38 +0800
Message-ID: <CAJd=RBBa6_p-ZSHHwNcTuPh6ikEZs35uiJWY+2q1e-5CiLaQKQ@mail.gmail.com>
Subject: [patch] BFS 421-1: refactor sys_sched_yield
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Runqueue lock is replaced with preempt.

SOB: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched/bfs.c	Mon Jul  9 20:06:50 2012
+++ b/kernel/sched/bfs.c	Mon Jul  9 20:08:50 2012
@@ -4518,19 +4518,8 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t
  */
 SYSCALL_DEFINE0(sched_yield)
 {
-	struct task_struct *p;
-
-	p = current;
-	grq_lock_irq();
-	schedstat_inc(task_rq(p), yld_count);
-
-	/*
-	 * Since we are going to call schedule() anyway, there's
-	 * no need to preempt or enable interrupts:
-	 */
-	__release(grq.lock);
-	spin_release(&grq.lock.dep_map, 1, _THIS_IP_);
-	do_raw_spin_unlock(&grq.lock);
+	preempt_disable();
+	schedstat_inc(this_rq(), yld_count);
 	preempt_enable_no_resched();

 	schedule();
--
