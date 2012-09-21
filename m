Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2IUMDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:03:32 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:50495 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2IUMDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:03:30 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Date: Fri, 21 Sep 2012 17:29:42 +0530
Message-Id: <20120921115942.27611.67488.sendpatchset@codeblue>
Subject: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios in PLE handler
x-cbid: 12092112-5140-0000-0000-0000021C1FBD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some special scenarios like #vcpu <= #pcpu, PLE handler may 
prove very costly, because there is no need to iterate over vcpus
and do unsuccessful yield_to burning CPU.

An idea to solve this is:
1) As Avi had proposed we can modify hardware ple_window
dynamically to avoid frequent PL-exit. (IMHO, it is difficult to
decide when we have mixed type of VMs).

Another idea, proposed in the first patch, is to identify
non-overcommit case and just return from the PLE handler.

There are are many ways to identify non-overcommit scenario.
1) Using loadavg etc (get_avenrun/calc_global_load
 /this_cpu_load)

2) Explicitly check nr_running()/num_online_cpus()

3) Check source vcpu runqueue length.

Not sure how can we make use of (1) effectively/how to use it.
(2) has significant overhead since it iterates all cpus.
so this patch uses third method. (I feel it is uglier to export
runqueue length, but expecting suggestion on this).

In second patch, when we have large number of small guests, it is
possible that a spinning vcpu fails to yield_to any vcpu of same 
VM and go back and spin. This is also not effective when we are
over-committed. Instead, we do a schedule() so that we give chance
to other VMs to run.

Raghavendra K T(2):
 Handle undercommitted guest case in PLE handler
 Be courteous to other VMs in overcommitted scenario in PLE handler 

Results:
base = 3.6.0-rc5 + ple handler optimization patches from kvm tree.
patched = base + patch1 + patch2
machine: x240 with 16 core with HT enabled (32 cpu thread).
32 vcpu guest with 8GB RAM.

+-----------+-----------+-----------+------------+-----------+
         ebizzy (record/sec higher is better)
+-----------+-----------+-----------+------------+-----------+
   base        stddev       patched    stdev        %improve     
+-----------+-----------+-----------+------------+-----------+
 11293.3750   624.4378	 18209.6250   371.7061	  61.24166
  3641.8750   468.9400	  3725.5000   253.7823	   2.29621
+-----------+-----------+-----------+------------+-----------+

+-----------+-----------+-----------+------------+-----------+
        kernbench (time in sec lower is better)
+-----------+-----------+-----------+------------+-----------+
   base        stddev       patched    stdev        %improve     
+-----------+-----------+-----------+------------+-----------+
    30.6020     1.3018	    30.8287     1.1517	  -0.74080
    64.0825     2.3764	    63.4721     5.0191	   0.95252
    95.8638     8.7030	    94.5988     8.3832	   1.31958
+-----------+-----------+-----------+------------+-----------+

Note:
on mx3850x5 machine with 32 cores HT disabled I got around
ebizzy      209%
kernbench   6%
improvement for 1x scenario.

Thanks Srikar for his active partipation in discussing ideas and
reviewing the patch.

Please let me know your suggestions and comments.
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |    6 ++++++
 virt/kvm/kvm_main.c   |    7 +++++++
 3 files changed, 14 insertions(+), 0 deletions(-)

