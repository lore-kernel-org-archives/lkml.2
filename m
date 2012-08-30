Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab2H3SqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:46:07 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43390 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870Ab2H3Spy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:45:54 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/5] rcu: Track CPU-hotplug duration statistics
Date: Thu, 30 Aug 2012 11:45:09 -0700
Message-Id: <1346352312-31987-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346352312-31987-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830184448.GA31753@linux.vnet.ibm.com>
 <1346352312-31987-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083018-7182-0000-0000-0000027445B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Many rcutorture runs include CPU-hotplug operations in their stress
testing.  This commit accumulates statistics on the durations of these
operations in deference to the recent concern about the overhead and
latency of these operations.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |   42 +++++++++++++++++++++++++++++++++++++-----
 1 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 86315d3..c6cf6ff 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -176,8 +176,14 @@ static long n_rcu_torture_boosts;
 static long n_rcu_torture_timers;
 static long n_offline_attempts;
 static long n_offline_successes;
+static unsigned long sum_offline;
+static int min_offline = -1;
+static int max_offline;
 static long n_online_attempts;
 static long n_online_successes;
+static unsigned long sum_online;
+static int min_online = -1;
+static int max_online;
 static long n_barrier_attempts;
 static long n_barrier_successes;
 static struct list_head rcu_torture_removed;
@@ -1214,11 +1220,13 @@ rcu_torture_printk(char *page)
 		       n_rcu_torture_boost_failure,
 		       n_rcu_torture_boosts,
 		       n_rcu_torture_timers);
-	cnt += sprintf(&page[cnt], "onoff: %ld/%ld:%ld/%ld ",
-		       n_online_successes,
-		       n_online_attempts,
-		       n_offline_successes,
-		       n_offline_attempts);
+	cnt += sprintf(&page[cnt],
+		       "onoff: %ld/%ld:%ld/%ld %d,%d:%d,%d %lu:%lu (HZ=%d) ",
+		       n_online_successes, n_online_attempts,
+		       n_offline_successes, n_offline_attempts,
+		       min_online, max_online,
+		       min_offline, max_offline,
+		       sum_online, sum_offline, HZ);
 	cnt += sprintf(&page[cnt], "barrier: %ld/%ld:%ld",
 		       n_barrier_successes,
 		       n_barrier_attempts,
@@ -1490,8 +1498,10 @@ static int __cpuinit
 rcu_torture_onoff(void *arg)
 {
 	int cpu;
+	unsigned long delta;
 	int maxcpu = -1;
 	DEFINE_RCU_RANDOM(rand);
+	unsigned long starttime;
 
 	VERBOSE_PRINTK_STRING("rcu_torture_onoff task started");
 	for_each_online_cpu(cpu)
@@ -1509,6 +1519,7 @@ rcu_torture_onoff(void *arg)
 				printk(KERN_ALERT "%s" TORTURE_FLAG
 				       "rcu_torture_onoff task: offlining %d\n",
 				       torture_type, cpu);
+			starttime = jiffies;
 			n_offline_attempts++;
 			if (cpu_down(cpu) == 0) {
 				if (verbose)
@@ -1516,12 +1527,23 @@ rcu_torture_onoff(void *arg)
 					       "rcu_torture_onoff task: offlined %d\n",
 					       torture_type, cpu);
 				n_offline_successes++;
+				delta = jiffies - starttime;
+				sum_offline += delta;
+				if (min_offline < 0) {
+					min_offline = delta;
+					max_offline = delta;
+				}
+				if (min_offline > delta)
+					min_offline = delta;
+				if (max_offline < delta)
+					max_offline = delta;
 			}
 		} else if (cpu_is_hotpluggable(cpu)) {
 			if (verbose)
 				printk(KERN_ALERT "%s" TORTURE_FLAG
 				       "rcu_torture_onoff task: onlining %d\n",
 				       torture_type, cpu);
+			starttime = jiffies;
 			n_online_attempts++;
 			if (cpu_up(cpu) == 0) {
 				if (verbose)
@@ -1529,6 +1551,16 @@ rcu_torture_onoff(void *arg)
 					       "rcu_torture_onoff task: onlined %d\n",
 					       torture_type, cpu);
 				n_online_successes++;
+				delta = jiffies - starttime;
+				sum_online += delta;
+				if (min_online < 0) {
+					min_online = delta;
+					max_online = delta;
+				}
+				if (min_online > delta)
+					min_online = delta;
+				if (max_online < delta)
+					max_online = delta;
 			}
 		}
 		schedule_timeout_interruptible(onoff_interval * HZ);
-- 
1.7.8

