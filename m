Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1HOP5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:57:19 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43560 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab1HOPxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:30 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [PATCH 15/32] nohz/cpuset: Restart tick when switching to idle task
Date: Mon, 15 Aug 2011 17:52:12 +0200
Message-Id: <1313423549-27093-16-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ideally if we are in adaptive nohz mode and we switch to the
the idle task, we shouldn't restart the tick since it's going
to stop the tick soon anyway.

That optimization requires some minor tweaks here and there
though, lets handle that later.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 kernel/sched.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 353a66f..9b6b8eb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2477,6 +2477,18 @@ void cpuset_update_nohz(void)
 	if (!cpuset_nohz_can_stop_tick())
 		cpuset_nohz_restart_tick();
 }
+
+static void cpuset_nohz_task_switch(struct task_struct *next)
+{
+	int cpu = smp_processor_id();
+
+	if (tick_nohz_adaptive_mode() && next == idle_task(cpu))
+		cpuset_nohz_restart_tick();
+}
+#else
+static void cpuset_nohz_task_switch(struct task_struct *next)
+{
+}
 #endif
 
 static void
@@ -3023,6 +3035,7 @@ static inline void
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
+	cpuset_nohz_task_switch(next);
 	sched_info_switch(prev, next);
 	perf_event_task_sched_out(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
-- 
1.7.5.4

