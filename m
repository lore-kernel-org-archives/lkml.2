Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab2EXLEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 07:04:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:54248 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753178Ab2EXLEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 07:04:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1935H0sDop3yNIVBoGjl/0kHRQXX023xAEahHfGvI
	UcrAb8q3vUA593
Message-ID: <1337857490.7300.19.camel@marge.simpson.net>
Subject: [rfc][patch] select_idle_sibling() inducing bouncing on westmere
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Date: Thu, 24 May 2012 13:04:50 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I love the goodstuff select_idle_sibling() delivers, but do wish the
two-faced little bi^Hugger would stop delivering badstuff along with it.

E5620, SMT enabled.

tbench 1
           ondemend                        performance
v3.4.0     244.82 MB/sec    1.000          369.89 MB/sec     1.000
v3.4.0-x   268.40 MB/sec    1.096          422.22 MB/sec     1.141

(ew, worse than nohz.. beware dainty little hammer ondemand)

Performance it is...

tbench 2
v3.4.0     703.48 MB/sec    1.000 
v3.4.0-x   806.51 MB/sec    1.146

netperf TCP_RR (1 byte ping/pong)
v3.4.0    104841.30         1.000
v3.4.0-x  122130.62         1.164

lmbench

*Local* Communication latencies in microseconds - smaller is better
---------------------------------------------------------------------
Host                 OS 2p/0K  Pipe AF     UDP  RPC/   TCP  RPC/ TCP
                        ctxsw       UNIX         UDP         TCP conn
--------- ------------- ----- ----- ---- ----- ----- ----- ----- ----
rtbox         3.4.0-smp 1.640 4.066 4.45 7.432  10.6 9.511  13.5  15.
rtbox         3.4.0-smp 1.630 4.122 4.38 7.510  10.7 9.503  13.4  15.
rtbox         3.4.0-smp 1.660 4.016 4.41 7.502  10.7 9.585  13.5  15.
rtbox        3.4.0-smpx 1.410 3.682 4.71 6.665 9.540 8.439  11.7  17.
rtbox        3.4.0-smpx 1.380 3.730 4.60 6.756 9.322 8.416  11.8  15.
rtbox        3.4.0-smpx 1.350 3.739 4.65 6.960 9.394 8.416  11.7  15.

*Local* Communication bandwidths in MB/s - bigger is better
-----------------------------------------------------------------------------
Host                OS  Pipe AF    TCP  File   Mmap  Bcopy  Bcopy  Mem   Mem
                             UNIX      reread reread (libc) (hand) read write
--------- ------------- ---- ---- ---- ------ ------ ------ ------ ---- -----
rtbox         3.4.0-smp 3248 6658 1562 4011.3 6917.8 2324.7 2372.5 5423 3441.
rtbox         3.4.0-smp 3178 6642 1450 4026.6 6969.8 2346.6 2321.6 5459 3454.
rtbox         3.4.0-smp 3184 6661 1353 4026.4 6868.5 2317.2 2323.4 5422 3465.
rtbox        3.4.0-smpx 3347 7985 1495 4003.6 6910.6 2304.2 2293.0 5458 3454.
rtbox        3.4.0-smpx 3342 7779 1419 4010.2 6912.6 2312.3 2312.6 5454 3466.
rtbox        3.4.0-smpx 3344 8003 1205 4006.8 6899.4 2350.6 2325.6 5458 3472.
                             ^--- bounce pain gone + throughput still there = !2busted
patches in both kernels:
patches/remove_irritating_plus.diff
patches/clockevents-Reinstate-the-per-cpu-tick-skew.patch
patches/sched-fix-task_groups-list
patches/sched-rt-fix-isolated-CPUs-leaving-root_task_group-indefinitely-throttled.patch
patches/sched-throttle-nohz.patch
patches/sched-domain-flags-proc-handler.patch

patches only in v3.4.0-x:
patches/sched-tweak-select_idle_sibling.patch

sched-domain-flags-proc-handler.patch:
sched: let the user turn select_idle_sibling() on/off again

Add really dumb proc handler.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 kernel/sched/core.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5235,6 +5235,32 @@ static struct ctl_table sd_ctl_root[] =
 	{}
 };
 
+int domain_flags_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret, cpu;
+	struct sched_domain *sd;
+	static DEFINE_MUTEX(mutex);
+
+	mutex_lock(&mutex);
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
+	if (!ret && write) {
+		get_online_cpus();
+		rcu_read_lock();
+		for_each_cpu(cpu, cpu_online_mask) {
+			sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
+			rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
+		}
+		rcu_read_unlock();
+		put_online_cpus();
+	}
+	mutex_unlock(&mutex);
+
+	return ret;
+}
+
 static struct ctl_table *sd_alloc_ctl_entry(int n)
 {
 	struct ctl_table *entry =
@@ -5306,7 +5332,7 @@ sd_alloc_ctl_domain_table(struct sched_d
 		&sd->cache_nice_tries,
 		sizeof(int), 0644, proc_dointvec_minmax);
 	set_table_entry(&table[10], "flags", &sd->flags,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, domain_flags_handler);
 	set_table_entry(&table[11], "name", sd->name,
 		CORENAME_MAX_SIZE, 0444, proc_dostring);
 	/* &table[12] is terminator */

sched-tweak-select_idle_sibling.patch:

sched: fix select_idle_sibling() induced bouncing

Traversing an entire package is not only expensive, it also leads to tasks
bouncing all over a partially idle and possible quite large package.  Fix
that up by assigning a 'buddy' CPU to try to motivate.  Each buddy may try
to motivate that one other CPU, if it's busy, tough, it may then try it's
SMT sibling, but that's all this optimization is allowed to cost.

Sibling cache buddies are cross-wired to prevent bouncing.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |   40 +++++++++++++++++++++++++++++++++++++++-
 kernel/sched/fair.c   |   28 +++++++++-------------------
 3 files changed, 49 insertions(+), 20 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -928,6 +928,7 @@ struct sched_domain {
 	struct sched_domain *parent;	/* top domain must be null terminated */
 	struct sched_domain *child;	/* bottom domain must be null terminated */
 	struct sched_group *groups;	/* the balancing groups of the domain */
+	struct sched_group *sibling;	/* group assigned to select_idle_sibling() */
 	unsigned long min_interval;	/* Minimum balance interval ms */
 	unsigned long max_interval;	/* Maximum balance interval ms */
 	unsigned int busy_factor;	/* less balancing by factor if busy */
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5888,9 +5888,47 @@ static void update_top_cache_domain(int
 	int id = cpu;
 
 	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
-	if (sd)
+	if (sd) {
+		struct sched_domain *tmp = sd;
+		struct sched_group *sg = tmp->groups, *prev = sg;
+		int smt = 0, right = 1;
+
 		id = cpumask_first(sched_domain_span(sd));
 
+		/*
+		 * Assign a 'buddy' CPU for select_idle_sibling()
+		 * to try to motivate.  These point at each other
+		 * at the MC level, and at own sibling at SIBLING
+		 * to prevent mad bouncing of tasks on a package
+		 * with many cores/siblings.
+		 */
+		while (cpumask_first(sched_group_cpus(sg)) != id)
+			sg = sg->next;
+
+		/*
+		 * Ok, have first group, should we point right or left?
+		 * sg is tmp->groups again when done, ie our group.
+		 */
+		while (!cpumask_test_cpu(cpu, sched_group_cpus(sg))) {
+			prev = sg;
+			sg = sg->next;
+			right = !right;
+		}
+
+		/* A CPU went down, never point back to package start. */
+		if (right && cpumask_first(sched_group_cpus(sg->next)) == id)
+			right = 0;
+
+		sg = right ? sg->next : prev;
+
+		do {
+			if (smt)
+				sg = tmp->groups->next;
+			rcu_assign_pointer(tmp->sibling, sg);
+			smt = 1;
+		} while ((tmp = tmp->child));
+	}
+
 	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
 	per_cpu(sd_llc_id, cpu) = id;
 }
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2655,29 +2655,19 @@ static int select_idle_sibling(struct ta
 		return prev_cpu;
 
 	/*
-	 * Otherwise, iterate the domains and find an elegible idle cpu.
+	 * Otherwise, check assigned siblings to find an elegible idle cpu.
 	 */
 	sd = rcu_dereference(per_cpu(sd_llc, target));
-	for_each_lower_domain(sd) {
-		sg = sd->groups;
-		do {
-			if (!cpumask_intersects(sched_group_cpus(sg),
-						tsk_cpus_allowed(p)))
-				goto next;
-
-			for_each_cpu(i, sched_group_cpus(sg)) {
-				if (!idle_cpu(i))
-					goto next;
-			}
 
-			target = cpumask_first_and(sched_group_cpus(sg),
-					tsk_cpus_allowed(p));
-			goto done;
-next:
-			sg = sg->next;
-		} while (sg != sd->groups);
+	for_each_lower_domain(sd) {
+		sg = rcu_dereference(sd->sibling);
+		for_each_cpu_and(i, sched_group_cpus(sg), tsk_cpus_allowed(p)) {
+			if (idle_cpu(i))
+				return i;
+			break;
+		}
 	}
-done:
+
 	return target;
 }
 


