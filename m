Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab2GFM2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:28:30 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42000 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab2GFM23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 08:28:29 -0400
MIME-Version: 1.0
Date: Fri, 6 Jul 2012 20:28:28 +0800
Message-ID: <CAJd=RBAi4_6=vnEQ2pZc2Kaykc_3P+U4jnnh1E+viMsxKUrfSg@mail.gmail.com>
Subject: [patch] BFS 421-1: cleanup online_cpus
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To remove cpu_online_map, lets clean up online_cpus.

SOB: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched/bfs.c	Thu Jul  5 21:43:36 2012
+++ b/kernel/sched/bfs.c	Fri Jul  6 20:09:08 2012
@@ -1365,24 +1365,6 @@ can_preempt(struct task_struct *p, int p
 }

 #ifdef CONFIG_SMP
-#ifdef CONFIG_HOTPLUG_CPU
-/*
- * Check to see if there is a task that is affined only to offline CPUs but
- * still wants runtime. This happens to kernel threads during suspend/halt and
- * disabling of CPUs.
- */
-static inline bool online_cpus(struct task_struct *p)
-{
-	return (likely(cpus_intersects(cpu_online_map, p->cpus_allowed)));
-}
-#else /* CONFIG_HOTPLUG_CPU */
-/* All available CPUs are always online without hotplug. */
-static inline bool online_cpus(struct task_struct *p)
-{
-	return true;
-}
-#endif
-
 /*
  * Check to see if p can run on cpu, and if not, whether there are any online
  * CPUs it can run on instead.
@@ -5063,7 +5045,8 @@ static void break_sole_affinity(int src_
 	struct task_struct *p, *t;

 	do_each_thread(t, p) {
-		if (p != idle && !online_cpus(p)) {
+		if (p != idle && !cpumask_intersects(tsk_cpus_allowed(p),
+							cpu_online_mask)) {
 			cpumask_copy(tsk_cpus_allowed(p), cpu_possible_mask);
 			/*
 			 * Don't tell them about moving exiting tasks or
--
