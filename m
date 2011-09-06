Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab1IGGWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:22:15 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38034 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847Ab1IGGV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:21:56 -0400
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
Subject: [PATCH tip/core/rcu 01/55] rcu: Use kthread_create_on_node()
Date: Tue,  6 Sep 2011 10:59:55 -0700
Message-Id: <1315332049-2604-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
x-cbid: 11090706-6078-0000-0000-00000071191B
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
 kernel/rcutorture.c     |    5 +++--
 kernel/rcutree_plugin.h |    5 ++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 2e138db..920eb50 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1282,8 +1282,9 @@ static int rcutorture_booster_init(int cpu)
 	/* Don't allow time recalculation while creating a new task. */
 	mutex_lock(&boost_mutex);
 	VERBOSE_PRINTK_STRING("Creating rcu_torture_boost task");
-	boost_tasks[cpu] = kthread_create(rcu_torture_boost, NULL,
-					  "rcu_torture_boost");
+	boost_tasks[cpu] = kthread_create_on_node(rcu_torture_boost, NULL,
+						  cpu_to_node(cpu),
+						  "rcu_torture_boost");
 	if (IS_ERR(boost_tasks[cpu])) {
 		retval = PTR_ERR(boost_tasks[cpu]);
 		VERBOSE_PRINTK_STRING("rcu_torture_boost task create failed");
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 8aafbb8..7b850cd 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1560,7 +1560,10 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
 	if (!rcu_scheduler_fully_active ||
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

