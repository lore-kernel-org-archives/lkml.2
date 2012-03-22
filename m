Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030774Ab2CVPcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 11:32:17 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:55200 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758292Ab2CVPcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 11:32:16 -0400
Date: Thu, 22 Mar 2012 21:02:05 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
Message-ID: <20120322153205.GA28570@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <1329764866.2293.376.camhel@twins>
 <20120305152443.GE26559@linux.vnet.ibm.com>
 <20120306091410.GD27238@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120306091410.GD27238@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12032215-8878-0000-0000-000001CDFBA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2012-03-06 10:14:11]:

> > I did some experiments with volanomark and it does turn out to 
> > be sensitive to SD_BALANCE_WAKE, while the other wake-heavy 
> > benchmark that I am dealing with (Trade) benefits from it.
> 
> Does volanomark still do yield(), thereby invoking a random 
> shuffle of thread scheduling and pretty much voluntarily 
> ejecting itself from most scheduler performance considerations?
> 
> If it uses a real locking primitive such as futexes then its 
> performance matters more.

Some more interesting results on more recent tip kernel.

Machine : 2 Quad-core Intel X5570 CPU w/ H/T enabled (16 cpus)
Kernel  : tip (HEAD at ee415e2)
guest VM : 2.6.18 linux kernel based enterprise guest

Benchmarks are run in two scenarios:

1. BM -> Bare Metal. Benchmark is run on bare metal in root cgroup
2. VM -> Benchmark is run inside a guest VM. Several cpu hogs (in
 	 various cgroups) are run on host. Cgroup setup is as below:

	/sys (cpu.shares = 1024, hosts all system tasks)
	/libvirt (cpu.shares = 20000)
 	/libvirt/qemu/VM (cpu.shares = 8192. guest VM w/ 8 vcpus)
	/libvirt/qemu/hoga (cpu.shares = 1024. hosts 4 cpu hogs)
	/libvirt/qemu/hogb (cpu.shares = 1024. hosts 4 cpu hogs)
	/libvirt/qemu/hogc (cpu.shares = 1024. hosts 4 cpu hogs)
	/libvirt/qemu/hogd (cpu.shares = 1024. hosts 4 cpu hogs)

First BM (bare metal) scenario:

		tip	tip + patch

volano 		1	0.955   (4.5% degradation)
sysbench [n1] 	1	0.9984  (0.16% degradation)
tbench 1 [n2]	1	0.9096  (9% degradation)

Now the more interesting VM scenario:

		tip	tip + patch

volano		1	1.29   (29% improvement)
sysbench [n3]	1	2      (100% improvement)
tbench 1 [n4] 	1       1.07   (7% improvement)
tbench 8 [n5] 	1       1.26   (26% improvement)
httperf  [n6]	1 	1.05   (5% improvement)
Trade		1	1.31   (31% improvement)

Notes:
 
n1. sysbench was run with 16 threads.
n2. tbench was run on localhost with 1 client 
n3. sysbench was run with 8 threads
n4. tbench was run on localhost with 1 client
n5. tbench was run over network with 8 clients
n6. httperf was run as with burst-length of 100 and wsess of 100,500,0

So the patch seems to be a wholesome win when VCPU threads are waking
up (in a highly contended environment). One reason could be that any assumption 
of better cache hits by running (vcpu) threads on its prev_cpu may not
be fully correct as vcpu threads could represent many different threads
internally?

Anyway, there are degradations as well, considering which I see several 
possibilities:

1. Do balance-on-wake for vcpu threads only.
2. Document tuning possibility to improve performance in virtualized
   environment:
	- Either via sched_domain flags (disable SD_WAKE_AFFINE 
 	  at all levels and enable SD_BALANCE_WAKE at SMT/MC levels)
	- Or via a new sched_feat(BALANCE_WAKE) tunable

Any other thoughts or suggestions for more experiments?


--

Balance threads on wakeup to let it run on least-loaded CPU in the same
cache domain as its prev_cpu (or cur_cpu if wake_affine() test obliges).

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>


---
 include/linux/topology.h |    4 ++--
 kernel/sched/fair.c      |    5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

Index: current/include/linux/topology.h
===================================================================
--- current.orig/include/linux/topology.h
+++ current/include/linux/topology.h
@@ -96,7 +96,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
+				| 1*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
@@ -129,7 +129,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_BALANCE_WAKE			\
+				| 1*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
 				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
Index: current/kernel/sched/fair.c
===================================================================
--- current.orig/kernel/sched/fair.c
+++ current/kernel/sched/fair.c
@@ -2766,7 +2766,10 @@ select_task_rq_fair(struct task_struct *
 			prev_cpu = cpu;
 
 		new_cpu = select_idle_sibling(p, prev_cpu);
-		goto unlock;
+		if (idle_cpu(new_cpu))
+			goto unlock;
+		sd = rcu_dereference(per_cpu(sd_llc, prev_cpu));
+		cpu = prev_cpu;
 	}
 
 	while (sd) {

