Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab1FHTcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:32:22 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44687 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894Ab1FHTaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:30:46 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Tejun Heo <tj@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/28] rcu: Use kthread_create_on_node()
Date: Wed,  8 Jun 2011 12:29:41 -0700
Message-Id: <1307561407-13809-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110608192943.GA13211@linux.vnet.ibm.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

Commit a26ac2455ffc (move TREE_RCU from softirq to kthread) added
per-CPU kthreads.  However, kthread creation uses kthread_create(), which
can put the kthread's stack and task struct on the wrong NUMA node.
Therefore, use kthread_create_on_node() instead of kthread_create()
so that the stacks and task structs are placed on the correct NUMA node.

A similar change was carried out in commit 94dcf29a11b3 (kthread:
use kthread_create_on_node()).

Also change rcutorture's priority-boost-test kthread creation.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Tejun Heo <tj@kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    3 ++-
 kernel/rcutree.c    |    5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 2e138db..40d9ed2 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1282,7 +1282,8 @@ static int rcutorture_booster_init(int cpu)
 	/* Don't allow time recalculation while creating a new task. */
 	mutex_lock(&boost_mutex);
 	VERBOSE_PRINTK_STRING("Creating rcu_torture_boost task");
-	boost_tasks[cpu] = kthread_create(rcu_torture_boost, NULL,
+	boost_tasks[cpu] = kthread_create_on_node(rcu_torture_boost, NULL,
+						  cpu_to_node(cpu),
 					  "rcu_torture_boost");
 	if (IS_ERR(boost_tasks[cpu])) {
 		retval = PTR_ERR(boost_tasks[cpu]);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 36e79d2..c67b9f4 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1657,7 +1657,10 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
 	if (!rcu_kthreads_spawnable ||
 	    per_cpu(rcu_cpu_kthread_task, cpu) != NULL)
 		return 0;
-	t = kthread_create(rcu_cpu_kthread, (void *)(long)cpu, "rcuc%d", cpu);
+	t = kthread_create_on_node(rcu_cpu_kthread,
+				   (void *)(long)cpu,
+				   cpu_to_node(cpu),
+				   "rcuc%d", cpu);
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 	if (cpu_online(cpu))
-- 
1.7.3.2

