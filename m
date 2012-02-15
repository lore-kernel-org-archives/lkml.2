Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab2BORLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:11:08 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:45355 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab2BORLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:11:07 -0500
Date: Wed, 15 Feb 2012 22:40:32 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, pjt@google.com, efault@gmx.de, venki@google.com,
        suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: Re: sched: Performance of Trade workload running inside VM
Message-ID: <20120215171032.GB9918@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20120214112827.GA22653@linux.vnet.ibm.com>
 <1329307161.2293.66.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1329307161.2293.66.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12021507-7014-0000-0000-000000945920
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-02-15 12:59:21]:

> > @@ -2783,7 +2783,9 @@ select_task_rq_fair(struct task_struct *
> >  			prev_cpu = cpu;
> >  
> >  		new_cpu = select_idle_sibling(p, prev_cpu);
> > -		goto unlock;
> > +		if (idle_cpu(new_cpu))
> > +			goto unlock;
> > +		sd = rcu_dereference(per_cpu(sd_llc, prev_cpu));
> >  	}
> >  
> >  	while (sd) {
> 
> Right, so the problem with this is that it might defeat wake_affine,
> wake_affine tries to pull a task towards it wakeup source (irrespective
> of idleness thereof).

Isn't it already broken in some respect, given that
select_idle_sibling() could select a cpu which is different from wakeup
source (thus forcing a task to run on a cpu different from wakeup
source)?

Are there benchmarks you would suggest that could be sensitive to
wake_affine? I have already tried sysbench and found that it benefits
from this patch:

> Also, wake_balance is somewhat expensive, which seems like a bad thing
> considering your workload is already wakeup heavy.

The patch seems to help both my workload and sysbench.

                                tip       	tip + patch
                        =============================================
sysbench                        4032.313        4558.780     (+13%)
Trade thr'put (all VMs active)  18294.48/min    31916.393    (+74%)
VM1 cpu util (all VMs active)   13.7%           17.3%        (+26%)


> That said, there was a lot of text in your email which hid what your
> actual problem was. So please try again, less words, more actual content
> please.

Ok ..let me see if these numbers highlight the problem better.

Machine : 2 Quad-core Intel CPUs w/ HT enabled (16 logical cpus)
Host kernel : tip (HEAD at 2ce21a52)

cgroups:
	/libvirt	  (cpu.shares = 20000)
	/libvirt/qemu/VM1 (cpu.shares varied from 1024 -> 131072)
	/libvirt/qemu/VM2 (cpu.shares = 1024)
	/libvirt/qemu/VM3 (cpu.shares = 1024)
	/libvirt/qemu/VM4 (cpu.shares = 1024)
	/libvirt/qemu/VM5 (cpu.shares = 1024)

VM1-5 are (KVM) virtual machines. VM1 runs the most important benchmark
and has 8 vcpus.  VM2-5 each has 4 vcpus and run cpu hogs to keep their vcpus
busy. A load generator running on host bombards web+database server
running in VM1 and measures throughput alongwith response times.

First lets see the performance of benchmark when only VM1 is running
(other VMs suspended)

			Throughput 	VM1 %cpu utilization
			(tx/min)	(measured over 30-sec window)
		=========================================================

Only VM1 active		32900		20.35

>From this we know that VM1 is capable of delivering upto 32900 tx/min
performance in uncontended situation.

Next we activate all VMs. VM2-5 are running cpu hogs and are run at
constant cpu.shares of 1024. VM1's cpu.shares is varied from 1024 ->
131072 and its impact on benchmark performance is noted as below:

			Throughput 	VM1 %cpu utilization
VM1 cpu.shares		(tx/min)	(measured over 30-sec window)
========================================================================

1024			1547		4
2048			5900		9
4096			14000		12.4
8192			17700		13.5
16384			18800		13.5
32768			19600		13.6
65536			18323		13.4
131072			19000		13.8


Observed results:
	No matter how high cpu.shares we assign to VM1, its utilization
	flattens at ~14% and benchmark score does not improve beyond
	19000

Expected results:
	Increasing cpu.shares should let VM1 consume more and more CPU
	until it reaches close to its peak demand (20.35%) and delivers close 
	to peak performance possible (32900).

I will share similar results with patch applied by tomorrow. Also I am
trying to recreate the problem using simpler programs (like sload). Will
let you know if I am successful with that!

- vatsa

