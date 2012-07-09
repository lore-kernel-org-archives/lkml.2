Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab2GIMWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:22:19 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55848 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab2GIMWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:22:18 -0400
MIME-Version: 1.0
Date: Mon, 9 Jul 2012 20:22:17 +0800
Message-ID: <CAJd=RBCxbAVMQCzkHmV8UAf_dcdk=XeEgSKGc3FsZMELoUaTuw@mail.gmail.com>
Subject: [patch] BFS 421-1: cleanup try_preempt
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The helper, resched_suitable_idle, is changed to be used in try_preempt.

SOB: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched/bfs.c	Fri Jul  6 20:30:10 2012
+++ b/kernel/sched/bfs.c	Mon Jul  9 20:00:52 2012
@@ -859,10 +859,15 @@ static void resched_best_idle(struct tas
 	resched_best_mask(task_cpu(p), task_rq(p), &tmpmask);
 }

-static inline void resched_suitable_idle(struct task_struct *p)
+static inline bool resched_suitable_idle(struct task_struct *p)
 {
-	if (suitable_idle_cpus(p))
+	bool rc = false;
+
+	if (suitable_idle_cpus(p)) {
 		resched_best_idle(p);
+		rc = true;
+	}
+	return rc;
 }
 /*
  * Flags to tell us whether this CPU is running a CPU frequency governor that
@@ -915,8 +920,9 @@ static inline bool suitable_idle_cpus(st
 	return uprq->curr == uprq->idle;
 }

-static inline void resched_suitable_idle(struct task_struct *p)
+static inline bool resched_suitable_idle(struct task_struct *p)
 {
+	return false;
 }

 void cpu_scaling(int __unused)
@@ -1390,12 +1396,12 @@ static void try_preempt(struct task_stru
 	 * try_preempt with the sticky flag enabled means some complicated
 	 * re-scheduling has occurred and we should ignore the sticky flag.
 	 */
-	clear_sticky(p);
+	if (task_sticky(p))
+		clear_sticky(p);

-	if (suitable_idle_cpus(p)) {
-		resched_best_idle(p);
+	/* check if idle cpu available */
+	if (resched_suitable_idle(p))
 		return;
-	}

 	/* IDLEPRIO tasks never preempt anything but idle */
 	if (p->policy == SCHED_IDLEPRIO)
--
