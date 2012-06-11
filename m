Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2FKMy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 08:54:56 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49773 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab2FKMyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 08:54:54 -0400
MIME-Version: 1.0
Date: Mon, 11 Jun 2012 20:54:53 +0800
Message-ID: <CAJd=RBDeN4icfKgduSx5TcOpLBgAbF+1GsxsQnJ2ks75xdOm_A@mail.gmail.com>
Subject: [patch] BFS 421: measure runqueue lock contention and cache affinity
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to single runqueue by design, the global lock is assumed to be hot,
so lets measure it. With cpu cache affinity considered when selecting
task of the earliest deadline, EDL is no longer strict but broken a bit,
and we have to know its earn.


--- a/kernel/sched/bfs.c	Mon Jun 11 20:32:18 2012
+++ b/kernel/sched/bfs.c	Mon Jun 11 20:21:50 2012
@@ -149,6 +149,12 @@ int rr_interval __read_mostly = 6;
  */
 int sched_iso_cpu __read_mostly = 70;

+#ifdef CONFIG_SMP
+unsigned long	grab_rq_lock = 0,
+		wait_rq_lock = 0,
+		tsk_csw = 0,
+		cpu_csw = 0;
+#endif
 /*
  * The relative length of deadline for each priority(nice) level.
  */
@@ -1151,6 +1157,13 @@ static inline void take_task(int cpu, st
 skip:
 #endif
 #endif
+#ifdef CONFIG_SMP
+	if (p != current) {
+		tsk_csw++;
+		if (cpu != task_cpu(p))
+			cpu_csw++;
+	}
+#endif
 	set_task_cpu(p, cpu);
 	dequeue_task(p);
 	clear_sticky(p);
@@ -3148,6 +3161,11 @@ need_resched:
 	deactivate = false;
 	schedule_debug(prev);

+#ifdef CONFIG_SMP
+	grab_rq_lock++;
+	if (grunqueue_is_locked())
+		wait_rq_lock++;
+#endif
 	grq_lock_irq();

 	switch_count = &prev->nivcsw;
--- a/kernel/sysctl.c	Mon Jun 11 20:13:08 2012
+++ b/kernel/sysctl.c	Mon Jun 11 20:30:12 2012
@@ -125,6 +125,12 @@ static int __maybe_unused one_hundred =
 #ifdef CONFIG_SCHED_BFS
 extern int rr_interval;
 extern int sched_iso_cpu;
+#ifdef CONFIG_SMP
+extern unsigned long grab_rq_lock,
+			wait_rq_lock,
+			tsk_csw,
+			cpu_csw;
+#endif
 static int __read_mostly one_thousand = 1000;
 #endif
 #ifdef CONFIG_PRINTK
@@ -876,6 +882,36 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
+#ifdef CONFIG_SMP
+	{
+		.procname	= "cpu_csw",
+		.data		= &cpu_csw,
+		.maxlen		= sizeof (unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+	{
+		.procname	= "tsk_csw",
+		.data		= &tsk_csw,
+		.maxlen		= sizeof (unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+	{
+		.procname	= "grab_rq_lock",
+		.data		= &grab_rq_lock,
+		.maxlen		= sizeof (unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+	{
+		.procname	= "wait_rq_lock",
+		.data		= &wait_rq_lock,
+		.maxlen		= sizeof (unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+#endif
 #endif
 #if defined(CONFIG_S390) && defined(CONFIG_SMP)
 	{
--
