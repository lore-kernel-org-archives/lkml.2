Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2JCM0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:26:12 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50290 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab2JCM0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:26:10 -0400
Date: Wed, 3 Oct 2012 17:52:09 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
Message-ID: <20121003122209.GA9076@linux.vnet.ibm.com>
Reply-To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
References: <20120921115942.27611.67488.sendpatchset@codeblue>
 <20120921120000.27611.71321.sendpatchset@codeblue>
 <505C654B.2050106@redhat.com>
 <505CA2EB.7050403@linux.vnet.ibm.com>
 <50607F1F.2040704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <50607F1F.2040704@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12100312-7182-0000-0000-000002BC10EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@redhat.com> [2012-09-24 17:41:19]:

> On 09/21/2012 08:24 PM, Raghavendra K T wrote:
> > On 09/21/2012 06:32 PM, Rik van Riel wrote:
> >> On 09/21/2012 08:00 AM, Raghavendra K T wrote:
> >>> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> >>>
> >>> When total number of VCPUs of system is less than or equal to physical
> >>> CPUs,
> >>> PLE exits become costly since each VCPU can have dedicated PCPU, and
> >>> trying to find a target VCPU to yield_to just burns time in PLE handler.
> >>>
> >>> This patch reduces overhead, by simply doing a return in such
> >>> scenarios by
> >>> checking the length of current cpu runqueue.
> >>
> >> I am not convinced this is the way to go.
> >>
> >> The VCPU that is holding the lock, and is not releasing it,
> >> probably got scheduled out. That implies that VCPU is on a
> >> runqueue with at least one other task.
> > 
> > I see your point here, we have two cases:
> > 
> > case 1)
> > 
> > rq1 : vcpu1->wait(lockA) (spinning)
> > rq2 : vcpu2->holding(lockA) (running)
> > 
> > Here Ideally vcpu1 should not enter PLE handler, since it would surely
> > get the lock within ple_window cycle. (assuming ple_window is tuned for
> > that workload perfectly).
> > 
> > May be this explains why we are not seeing benefit with kernbench.
> > 
> > On the other side, Since we cannot have a perfect ple_window tuned for
> > all type of workloads, for those workloads, which may need more than
> > 4096 cycles, we gain. thinking is it that we are seeing in benefited
> > cases?
> 
> Maybe we need to increase the ple window regardless.  4096 cycles is 2
> microseconds or less (call it t_spin).  The overhead from
> kvm_vcpu_on_spin() and the associated task switches is at least a few
> microseconds, increasing as contention is added (call it t_tield).  The
> time for a natural context switch is several milliseconds (call it
> t_slice).  There is also the time the lock holder owns the lock,
> assuming no contention (t_hold).
> 
> If t_yield > t_spin, then in the undercommitted case it dominates
> t_spin.  If t_hold > t_spin we lose badly.
> 
> If t_spin > t_yield, then the undercommitted case doesn't suffer as much
> as most of the spinning happens in the guest instead of the host, so it
> can pick up the unlock timely.  We don't lose too much in the
> overcommitted case provided the values aren't too far apart (say a
> factor of 3).
> 
> Obviously t_spin must be significantly smaller than t_slice, otherwise
> it accomplishes nothing.
> 
> Regarding t_hold: if it is small, then a larger t_spin helps avoid false
> exits.  If it is large, then we're not very sensitive to t_spin.  It
> doesn't matter if it takes us 2 usec or 20 usec to yield, if we end up
> yielding for several milliseconds.
> 
> So I think it's worth trying again with ple_window of 20000-40000.
> 

Hi Avi,

I ran different benchmarks increasing ple_window, and results does not
seem to be encouraging for increasing ple_window.

Results:
16 core PLE machine with 16 vcpu guest. 

base kernel = 3.6-rc5 + ple handler optimization patch 
base_pleopt_8k = base kernel + ple window = 8k
base_pleopt_16k = base kernel + ple window = 16k
base_pleopt_32k = base kernel + ple window = 32k


Percentage improvements of benchmarks w.r.t base_pleopt with ple_window = 4096

		base_pleopt_8k	base_pleopt_16k	base_pleopt_32k
-----------------------------------------------------------------			
kernbench_1x	-5.54915	-15.94529	-44.31562
kernbench_2x	-7.89399	-17.75039	-37.73498
-----------------------------------------------------------------			
sysbench_1x	0.45955		-0.98778	0.05252
sysbench_2x	1.44071		-0.81625	1.35620
sysbench_3x 	0.45549		1.51795		-0.41573
-----------------------------------------------------------------			
			
hackbench_1x	-3.80272	-13.91456	-40.79059
hackbench_2x 	-4.78999	-7.61382	-7.24475
-----------------------------------------------------------------			
ebizzy_1x	-2.54626	-16.86050	-38.46109
ebizzy_2x	-8.75526	-19.29116	-48.33314
-----------------------------------------------------------------			

I also got perf top output to analyse the difference. Difference comes
because of flushtlb (and also spinlock).

Ebizzy run for 4k ple_window
-  87.20%  [kernel]  [k] arch_local_irq_restore
   - arch_local_irq_restore
      - 100.00% _raw_spin_unlock_irqrestore
         + 52.89% release_pages
         + 47.10% pagevec_lru_move_fn
-   5.71%  [kernel]  [k] arch_local_irq_restore
   - arch_local_irq_restore
      + 86.03% default_send_IPI_mask_allbutself_phys
      + 13.96% default_send_IPI_mask_sequence_phys
-   3.10%  [kernel]  [k] smp_call_function_many
     smp_call_function_many


Ebizzy run for 32k ple_window

-  91.40%  [kernel]  [k] arch_local_irq_restore
   - arch_local_irq_restore
      - 100.00% _raw_spin_unlock_irqrestore
         + 53.13% release_pages
         + 46.86% pagevec_lru_move_fn
-   4.38%  [kernel]  [k] smp_call_function_many
     smp_call_function_many
-   2.51%  [kernel]  [k] arch_local_irq_restore
   - arch_local_irq_restore
      + 90.76% default_send_IPI_mask_allbutself_phys
      + 9.24% default_send_IPI_mask_sequence_phys


Below is the detailed result:			
patch = base_pleopt_8k 
+-----------+-----------+-----------+------------+-----------+
                              kernbench 
+-----------+-----------+-----------+------------+-----------+
    base         stddev    patch       stdev       %improve    
+-----------+-----------+-----------+------------+-----------+
    41.0027     0.7990	    43.2780     0.5180	  -5.54915
    89.2983     1.2406	    96.3475     1.8891	  -7.89399
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
                              sysbench 
+-----------+-----------+-----------+------------+-----------+
     9.9010     0.0558	     9.8555     0.1246	   0.45955
    19.7611     0.4290	    19.4764     0.0835	   1.44071
    29.1775     0.9903	    29.0446     0.8641	   0.45549
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
                              hackbench 
+-----------+-----------+-----------+------------+-----------+
    77.1580     1.9787	    80.0921     2.9696	  -3.80272
   239.2490     1.5660	   250.7090     2.6074	  -4.78999
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
                              ebizzy 
+-----------+-----------+-----------+------------+-----------+
  4256.2500   186.8053	  4147.8750   206.1840	  -2.54626
  2197.2500    93.1048	  2004.8750    85.7995	  -8.75526
+-----------+-----------+-----------+------------+-----------+

patch = base_pleopt_16k
+-----------+-----------+-----------+------------+-----------+
                              kernbench 
+-----------+-----------+-----------+------------+-----------+
    base         stddev    patch       stdev       %improve    
+-----------+-----------+-----------+------------+-----------+
    41.0027     0.7990	    47.5407     0.5739	 -15.94529
    89.2983     1.2406	   105.1491     1.2244	 -17.75039
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
                              sysbench 
+-----------+-----------+-----------+------------+-----------+
     9.9010     0.0558	     9.9988     0.1106	  -0.98778
    19.7611     0.4290	    19.9224     0.9016	  -0.81625
    29.1775     0.9903	    28.7346     0.2788	   1.51795
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
                              hackbench 
+-----------+-----------+-----------+------------+-----------+
    77.1580     1.9787	    87.8942     2.2132	 -13.91456
   239.2490     1.5660	   257.4650     5.3674	  -7.61382
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
                              ebizzy 
+-----------+-----------+-----------+------------+-----------+
  4256.2500   186.8053	  3538.6250   101.1165	 -16.86050
  2197.2500    93.1048	  1773.3750    91.8414	 -19.29116
+-----------+-----------+-----------+------------+-----------+

patch = base_pleopt_32k
+-----------+-----------+-----------+------------+-----------+
                              kernbench 
+-----------+-----------+-----------+------------+-----------+
    base         stddev    patch       stdev       %improve    
+-----------+-----------+-----------+------------+-----------+
    41.0027     0.7990	    59.1733     0.8102	 -44.31562
    89.2983     1.2406	   122.9950     1.5534	 -37.73498
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
                              sysbench 
+-----------+-----------+-----------+------------+-----------+
     9.9010     0.0558	     9.8958     0.0593	   0.05252
    19.7611     0.4290	    19.4931     0.1767	   1.35620
    29.1775     0.9903	    29.2988     1.0420	  -0.41573
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
                              hackbench 
+-----------+-----------+-----------+------------+-----------+
    77.1580     1.9787	   108.6312    13.1500	 -40.79059
   239.2490     1.5660	   256.5820     2.2722	  -7.24475
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
                              ebizzy 
+-----------+-----------+-----------+------------+-----------+
  4256.2500   186.8053	  2619.2500    80.8150	 -38.46109
  2197.2500    93.1048	  1135.2500    22.2887	 -48.33314
+-----------+-----------+-----------+------------+-----------+

