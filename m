Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab2EYNem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:34:42 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41834 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab2EYNeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:34:20 -0400
MIME-Version: 1.0
Date: Fri, 25 May 2012 21:34:19 +0800
Message-ID: <CAJd=RBCGT09TZL-KfAi5Ccm9MjHhzocyyQfgaNhTwzWBjjTuUg@mail.gmail.com>
Subject: [patch 2/4] BFS 420: fix ttwu_stat
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last parameter, wake_flags, as not used, is replaced by the result that the
sleeper is activated successfully or not. If not, only to increase ttwu counter.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Fri May 25 20:28:00 2012
@@ -1486,7 +1486,7 @@ static void try_preempt(struct task_stru
 #endif /* CONFIG_SMP */

 static void
-ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
+ttwu_stat(struct task_struct *p, int cpu, bool success)
 {
 #ifdef CONFIG_SCHEDSTATS
 	struct rq *rq = this_rq();
@@ -1494,6 +1494,8 @@ ttwu_stat(struct task_struct *p, int cpu
 #ifdef CONFIG_SMP
 	int this_cpu = smp_processor_id();

+	if (!success)
+		goto out;
 	if (cpu == this_cpu)
 		schedstat_inc(rq, ttwu_local);
 	else {
@@ -1508,7 +1510,7 @@ ttwu_stat(struct task_struct *p, int cpu
 		}
 		rcu_read_unlock();
 	}
-
+out:
 #endif /* CONFIG_SMP */

 	schedstat_inc(rq, ttwu_count);
@@ -1603,7 +1605,7 @@ out_running:
 out_unlock:
 	task_grq_unlock(&flags);

-	ttwu_stat(p, cpu, wake_flags);
+	ttwu_stat(p, cpu, success);

 	put_cpu();

@@ -1634,7 +1636,7 @@ static void try_to_wake_up_local(struct
 			schedstat_inc(rq, ttwu_local);
 		}
 		ttwu_activate(p, rq, false);
-		ttwu_stat(p, smp_processor_id(), 0);
+		ttwu_stat(p, smp_processor_id(), true);
 		success = true;
 	}
 	ttwu_post_activation(p, rq, success);
--
