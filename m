Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab2DXQ4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:56:33 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:48739 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab2DXQ42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:56:28 -0400
Date: Tue, 24 Apr 2012 22:26:19 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v1] sched: steer waking task to empty cfs_rq for better
 latencies
Message-ID: <20120424165619.GA28701@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12042416-8256-0000-0000-0000021FD019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During my investigation of a performance issue, I found that
we can do a better job of reducing latencies for a waking task by
steering it towards a cpu where it will get better sleeper credits.

Consider a system with two nodes: N0-N1, each with 4 cpus and a cgroup
/a which is of highest priority. Further all 4 cpus in a node are in the same
llc (MC) domain.

		  	N0		   N1
			(0,1,2,3)	(4,5,6,7)

rq.nr_run ->	 	2 1 1 1         2 2 1 1
/a cfs_rq.nr_run ->     0 0 0 0  	0 0 0 1

Consider a task of "/a" waking up after a short (< sysctl_sched_latency) sleep.
Its prev_cpu was 7. select_idle_sibling(), failing to find a idle core, simply 
wakes up the task on CPU7, where it may be unable to preempt the
currently running task (as its new vruntime is not sufficiently behind
currently running tasks vruntime - owing to the short sleep it
incurred). As a result, the task woken up is unable to run immediately
and thus incurs some latency.

A better choice would be to find a cpu in cpu7's MC domain where its
cgroup has 0 tasks (thus allowing the waking task to get better sleeper
credits).

Patch below implements this idea. Some results with various benchmarks
is enclosed.

Machine : 2 Quad-core Intel X5570 CPU w/ H/T enabled (16 cpus)
Kernel  : tip (HEAD at 2adb096)
guest VM : 2.6.18 linux kernel based enterprise guest

Benchmarks are run in two scenarios:

1. BM -> Bare Metal. Benchmark is run on bare metal in root cgroup
2. VM -> Benchmark is run inside a guest VM. Several cpu hogs (in
        various cgroups) are run on host. Cgroup setup is as below:

	/libvirt/qemu/VM (cpu.shares = 8192. guest VM w/ 8 vcpus)
	/libvirt/qemu/hoga[bcd] (cpu.shares = 1024. hosts 4 cpu hogs each)

Mean and std. dev. (in brackets) for both tip and tip+patch cases provided
below:

BM scenario:
			tip 		tip+patch	Remarks
			mean(std. dev)  mean (std. dev)

volano 			1 (6.5%)	0.97 (4.7%)	3% loss
sysbench [n1]		1 (0.6%)	1.004 (0.7%)	0.4% win
tbench 1 [n2]		1 (2%)		1.024 (1.6%)	2.4% win
pipe bench [n3]		1 (5.5%)	1.009 (2.5%)	0.9% win

VM scenario

sysbench [n4]		1 (1.2%)	2.21 (1.3%)	121% win
httperf  [n5]		1 (5.7%)	1.522 (6%)	52.2% win
tbench 8 [n6]		1 (3.1%)	1.91 (6.4%)	91% win
volano			1  (4.3%)	1.06 (2.8%)	6% win
Trade    		1		1.94 		94% win


Notes:

n1. sysbench was run with 16 threads.
n2. tbench was run on localhost with 1 client
n3. ops/sec metric from pipe bench captured. pipe bench run as:
	perf stat --repeat 10 --null perf bench sched pipe
n4. sysbench was run (inside VM) with 8 threads.
n5. httperf was run as with burst-length of 100 and wsess of 100,500,0.
    Webserver was running inside VM while benchmark was run on a 
    physically different host.
n6. tbench was run over network with 8 clients

This is an improved version of the patch previously published that
minimizes/avoids regressions seen earlier:

	https://lkml.org/lkml/2012/3/22/220 

Comments/flames wellcome!


--

Steer a waking task towards a cpu where its cgroup has zero tasks (in
order to provide it better sleeper credits and hence reduce its wakeup
latency).

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 kernel/sched/fair.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

Index: current/kernel/sched/fair.c
===================================================================
--- current.orig/kernel/sched/fair.c
+++ current/kernel/sched/fair.c
@@ -2459,6 +2459,32 @@ static long effective_load(struct task_g
 
 	return wl;
 }
+
+/*
+ * Look for a CPU within @target's MC domain where the task's cgroup has
+ * zero tasks in its cfs_rq.
+ */
+static __always_inline int
+select_idle_cfs_rq(struct task_struct *p, int target)
+{
+	struct cpumask tmpmask;
+	struct task_group *tg = task_group(p);
+	struct sched_domain *sd;
+	int i;
+
+	if (tg == &root_task_group)
+		return target;
+
+	sd = rcu_dereference(per_cpu(sd_llc, target));
+	cpumask_and(&tmpmask, sched_domain_span(sd), tsk_cpus_allowed(p));
+	for_each_cpu(i, &tmpmask) {
+		if (!tg->cfs_rq[i]->nr_running)
+			return i;
+	}
+
+	return target;
+}
+
 #else
 
 static inline unsigned long effective_load(struct task_group *tg, int cpu,
@@ -2467,6 +2493,12 @@ static inline unsigned long effective_lo
 	return wl;
 }
 
+static __always_inline int
+select_idle_cfs_rq(struct task_struct *p, int target)
+{
+	return target;
+}
+
 #endif
 
 static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
@@ -2677,6 +2709,13 @@ next:
 			sg = sg->next;
 		} while (sg != sd->groups);
 	}
+
+	/*
+	 * Look for the next best possibility - a cpu where this task gets
+	 * (better) sleeper credits.
+	 */
+	target = select_idle_cfs_rq(p, target);
+
 done:
 	return target;
 }







