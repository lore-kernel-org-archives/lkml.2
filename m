Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab2BNL2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:28:43 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:46089 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2BNL2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:28:39 -0500
Date: Tue, 14 Feb 2012 16:58:27 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: mingo@elte.hu, a.p.zijlstra@chello.nl, pjt@google.com, efault@gmx.de,
        venki@google.com, suresh.b.siddha@intel.com
Cc: linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: sched: Performance of Trade workload running inside VM
Message-ID: <20120214112827.GA22653@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12021411-5816-0000-0000-0000014A3B03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was investigating a performance issue which appears to be linked to
scheduler in some ways. Before I mention the potential scheduler issue,
here's the benchmark description:

Machine : 2 Intel quad-core CPU with HT enabled (16 logical CPUs), 48GB RAM
Linux kernel version : tip (HEAD at a80142eb)

cpu cgroups:
	/libvirt/qemu/VM1 (cpu.shares = 8192)
	/libvirt/qemu/VM2 (cpu.shares = 1024)
	/libvirt/qemu/VM3 (cpu.shares = 1024)
	/libvirt/qemu/VM4 (cpu.shares = 1024)
	/libvirt/qemu/VM5 (cpu.shares = 1024)

VM1-5 correspond to virtual machines. VM1 has 8 vcpus, while each of VM2-5 has
4 VCPUs. VM1 runs the (most important) Trade (OLTP) benchmark, while VM2-5 run 
CPU hogs to keep all their vcpus busy. 

A load generator running on the host bombards Trade server running
inside VM1 with requests and measures throughput alongwith response times.

			Only VM1 active		All VMs active
		=====================================================
Throughput		33395.083/min		18294.48/min  (-45%)
VM1 CPU utilization	21.4%			13.73%	      (-35%)

In the first case, only VM1 (running Trade server) is kept active while
VM2-5 are kept suspended. In that case, we see VM1 consume 21.4% CPU
with benchmark score at 33395.083/min.

Next, we activate all VMs (VM2-5 are resumed), which leads to benchmark
score dropping by 45% and CPU utilization of VM1 dropping by 35%. This
is despite VM1's shares of 8192 entitling it to receive 66% CPU resource
upon demand (8192/8192+4*1024 = 66%). Assigning lots and lots more shares to
VM1 doesn't help at all improve the situation.

Examining the execution pattern of VM1 (with help from scheduling
traces) revealed that:

a. VCPU tasks of VM1 sleep and run in short bursts (in microseconds scale),
   stressing the wakeup path of scheduler. 

b. In the "all VMs active" case, VM1's vcpu tasks were found to incur
   "high" wait times when two of VM1's tasks were scheduled on the same
   CPU (i.e a VCPU task had to wait behind a sibling VCPU task for
   obtaining CPU resource).

Further enabling SD_BALANCE_WAKE at SMT and MC domains and disabling
SD_WAKE_AFFINE at all domains (smt/mc/node) helped improve the CPU utilization
(and benchmark score) quite a bit. CPU utilization of VM1 (when all VMs are
active) went up to 17.5%.

This lead me to investigate the wakeup code path closely and in
particular select_idle_sibling(). select_idle_sibling() looks for a core
that is fully idle, failing which causes the task to wakeup on prev_cpu
(or cur_cpu). In particular, it does not go hunt for the least loaded
cpu, which is what SD_BALANCE_WAKE provides.

It seemed to me that we could have SD_BALANCE_WAKE enabled in SMT/MC
domains atleast without losing on cache benefits. However Peterz seems
to have noted that SD_BALANCE_WAKE can hurt sysbench.

https://lkml.org/lkml/2009/9/16/340

which I could easily verify on this system (i.e sysbench oltp throughput
drops when SD_BALANCE_WAKE is enabled).

I have tried coming up with something that allows us to keep
SD_BALANCE_WAKE enabled at smt/mc domains, not hurt sysbench and
also help the Trade benchmark that I had begun investigating. The patch
falls back to SD_BALANCE_WAKE type balance when the cpu returned by
select_idle_cpu() is not idle.

				tip		tip + patch
			=============================================
sysbench 			4032.313	4558.780     (+13%)
Trade thr'put (all VMs active) 	18294.48/min	31916.393    (+74%)
VM1 cpu util (all VMs active)   13.7%	   	17.3%	     (+26%)

[Note : sysbench was run with 16 threads as:

# sysbench --num-threads=16 --max-requests=100000 --test=oltp --oltp-table-size=500000 --mysql-socket=/var/lib/mysql/mysql.sock --oltp-read-only --mysql-user=root --mysql-password=blah run

]

Any other suggestions to help recover this particular benchmark score in
contended situation?

Not yet Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 include/linux/topology.h |    4 ++--
 kernel/sched/fair.c      |    4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

Index: linux-3.3-rc3-tip-a80142eb/include/linux/topology.h
===================================================================
--- linux-3.3-rc3-tip-a80142eb.orig/include/linux/topology.h
+++ linux-3.3-rc3-tip-a80142eb/include/linux/topology.h
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
Index: linux-3.3-rc3-tip-a80142eb/kernel/sched/fair.c
===================================================================
--- linux-3.3-rc3-tip-a80142eb.orig/kernel/sched/fair.c
+++ linux-3.3-rc3-tip-a80142eb/kernel/sched/fair.c
@@ -2783,7 +2783,9 @@ select_task_rq_fair(struct task_struct *
 			prev_cpu = cpu;
 
 		new_cpu = select_idle_sibling(p, prev_cpu);
-		goto unlock;
+		if (idle_cpu(new_cpu))
+			goto unlock;
+		sd = rcu_dereference(per_cpu(sd_llc, prev_cpu));
 	}
 
 	while (sd) {

















