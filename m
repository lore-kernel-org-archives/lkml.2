Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab2GQHEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 03:04:46 -0400
Received: from mail1.windriver.com ([147.11.146.13]:40395 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2GQHEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 03:04:44 -0400
From: Ying Xue <ying.xue@windriver.com>
To: <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
CC: <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@elte.hu>,
        <rostedt@goodmis.org>, <yong.zhang0@gmail.com>
Subject: [PATCH] sched/rt: Avoid updating RT entry timeout twice within one tick period
Date: Tue, 17 Jul 2012 15:03:43 +0800
Message-ID: <1342508623-2887-1-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firstly please pay attention to below issue which is found in a lower
version(2.6.34-rt) rather than mainline rt kernel. Although some big
changes have happened from that point to now, especially every softirq
does not run as one thread any more, we believe in the latest upstream
version the issue possibly exists. However, currently it's really hard
to be triggered after all softirqs are pushed off to the ksoftirqd
thread to complete them.

So please let me describe how to happen on 2.6.34-rt:

On this version, each softirq has its own thread, it means there has at
least one RT FIFO task per cpu. The priority of these tasks is set to 49
by default. If user launches an RT FIFO task with priority lower than 49
of softirq RT tasks, it's possible there have two RT FIFO tasks enqueued
one cpu runqueue at one moment. By current strategy of balancing RT tasks,
when it comes to RT tasks, we really need to put them off to a CPU that
they can run on as soon as possible. Even if it means a bit of cache line
flushing, but we can let RT task be run within the least latency.

When the user RT FIFO task which is just launched before is running,
the tick sched timer of current cpu happens. In this tick period, the
timeout value of the user RT task will be updated once. Subsequently,
we try to wake up one softirq RT task on its local cpu. As the priority
of current user RT task is lower than the softirq RT task, the current
task will be preempted by the higher priority softirq RT task. Before
preemption, we check to see if current can readily move to a different
cpu. If so, we will reschedule to allow RT push logic to try to move
current somewhere else. Whenever the woken softirq RT task runs, it
first tries to migrate the user FIFO RT task over to a cpu that is
running a task of lesser priority. If migration is done, it will send
an reschedule order to the found cpu by IPI interrupt. Once the target
cpu responds the IPI interrupt, it will pick the migrated user RT task
to preempt its current task. When the user RT task is running on the
new cpu, the tick sched timer of the cpu fires. So it will tick the
user RT task again. This also means the RT task timeout value will be
updated again. As the migration may be done in one tick period, it means
the user RT task timeout value will be updated twice within one tick.

If we set a limit on the amount of cpu time for the user RT task by
setrlimit(RLIMIT_RTTIME), the SIGXCPU signal should be posted upon
reaching the soft limit.

But when SIGXCPU signal should be sent depends on the RT task timeout
value. In fact the timeout mechanism of sending SIGXCPU signal hopes
the RT task timeout is increased once every tick. However, currently
the timeout value may be added twice per tick. So it results in the
SIGXCPU signal being sent earlier than our expected.

To solve the issue, we prevent the timeout value from increasing twice
within one tick time by remembering the jiffies value of lastly updating
the timeout. As long as the RT task's jiffies is different with the
global jiffies value, we allow its timeout to be updated.

Signed-off-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Fan Du <fan.du@windriver.com>
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
---
 include/linux/sched.h |    1 +
 kernel/sched/rt.c     |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4a1f493..f0656a2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1199,6 +1199,7 @@ struct sched_entity {
 struct sched_rt_entity {
 	struct list_head run_list;
 	unsigned long timeout;
+	unsigned long watchdog_stamp;
 	unsigned int time_slice;
 
 	struct sched_rt_entity *back;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 573e1ca..8240d4f 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1976,7 +1976,11 @@ static void watchdog(struct rq *rq, struct task_struct *p)
 	if (soft != RLIM_INFINITY) {
 		unsigned long next;
 
-		p->rt.timeout++;
+		if (p->rt.watchdog_stamp != jiffies) {
+			p->rt.timeout++;
+			p->rt.watchdog_stamp = jiffies;
+		}
+
 		next = DIV_ROUND_UP(min(soft, hard), USEC_PER_SEC/HZ);
 		if (p->rt.timeout > next)
 			p->cputime_expires.sched_exp = p->se.sum_exec_runtime;
-- 
1.7.1

