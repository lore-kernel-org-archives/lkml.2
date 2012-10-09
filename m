Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab2JISzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:55:32 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51928 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab2JISz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:55:29 -0400
Date: Wed, 10 Oct 2012 00:21:09 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
Message-ID: <20121009185108.GA2549@linux.vnet.ibm.com>
Reply-To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
References: <20120921120000.27611.71321.sendpatchset@codeblue>
 <505C654B.2050106@redhat.com>
 <505CA2EB.7050403@linux.vnet.ibm.com>
 <50607F1F.2040704@redhat.com>
 <20121003122209.GA9076@linux.vnet.ibm.com>
 <506C7057.6000102@redhat.com>
 <506D69AB.7020400@linux.vnet.ibm.com>
 <506D83EE.2020303@redhat.com>
 <1349356038.14388.3.camel@twins>
 <506DA48C.8050200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <506DA48C.8050200@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100918-7282-0000-0000-00000DC0B5A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@redhat.com> [2012-10-04 17:00:28]:

> On 10/04/2012 03:07 PM, Peter Zijlstra wrote:
> > On Thu, 2012-10-04 at 14:41 +0200, Avi Kivity wrote:
> >> 
> >> Again the numbers are ridiculously high for arch_local_irq_restore.
> >> Maybe there's a bad perf/kvm interaction when we're injecting an
> >> interrupt, I can't believe we're spending 84% of the time running the
> >> popf instruction. 
> > 
> > Smells like a software fallback that doesn't do NMI, hrtimer based
> > sampling typically hits popf where we re-enable interrupts.
> 
> Good nose, that's probably it.  Raghavendra, can you ensure that the PMU
> is properly exposed?  'dmesg' in the guest will tell.  If it isn't, -cpu
> host will expose it (and a good idea anyway to get best performance).
> 

Hi Avi, you are right. SandyBridge machine result was not proper.
I cleaned up the services, enabled PMU, re-ran all the test again.

Here is the summary:
We do get good benefit by increasing ple window. Though we don't
see good benefit for kernbench and sysbench, for ebizzy, we get huge
improvement for 1x scenario. (almost 2/3rd of ple disabled case).

Let me know if you think we can increase the default ple_window
itself to 16k.

I am experimenting with V2 version of undercommit improvement(this) patch
series, But I think if you wish  to go for increase of
default ple_window, then we would have to measure the benefit of patches
when ple_window = 16k.

I can respin the whole series including this default ple_window change.

I also have the perf kvm top result for both ebizzy and kernbench.
I think they are in expected lines now.

Improvements
================

16 core PLE machine with 16 vcpu guest

base = 3.6.0-rc5 + ple handler optimization patches
base_pleopt_16k = base + ple_window = 16k
base_pleopt_32k = base + ple_window = 32k
base_pleopt_nople = base + ple_gap = 0
kernbench, hackbench, sysbench (time in sec lower is better)
ebizzy (rec/sec higher is better)

% improvements w.r.t base (ple_window = 4k)
---------------+---------------+-----------------+-------------------+
               |base_pleopt_16k| base_pleopt_32k | base_pleopt_nople |
---------------+---------------+-----------------+-------------------+
kernbench_1x   |  0.42371      |  1.15164        |   0.09320         |
kernbench_2x   | -1.40981      | -17.48282       |  -570.77053       |
---------------+---------------+-----------------+-------------------+
sysbench_1x    | -0.92367      | 0.24241         | -0.27027          |
sysbench_2x    | -2.22706      |-0.30896         | -1.27573          |
sysbench_3x    | -0.75509      | 0.09444         | -2.97756          |
---------------+---------------+-----------------+-------------------+
ebizzy_1x      | 54.99976      | 67.29460        |  74.14076         |
ebizzy_2x      | -8.83386      |-27.38403        | -96.22066         |
---------------+---------------+-----------------+-------------------+

perf kvm top observation for kernbench and ebizzy (nople, 4k, 32k window) 
========================================================================
pleopt   ple_gap=0
--------------------
ebizzy : 18131 records/s
63.78%  [guest.kernel]  [g] _raw_spin_lock_irqsave
    5.65%  [guest.kernel]  [g] smp_call_function_many
    3.12%  [guest.kernel]  [g] clear_page
    3.02%  [guest.kernel]  [g] down_read_trylock
    1.85%  [guest.kernel]  [g] async_page_fault
    1.81%  [guest.kernel]  [g] up_read
    1.76%  [guest.kernel]  [g] native_apic_mem_write
    1.70%  [guest.kernel]  [g] find_vma

kernbench :Elapsed Time 29.4933 (27.6007)
   5.72%  [guest.kernel]  [g] async_page_fault
    3.48%  [guest.kernel]  [g] pvclock_clocksource_read
    2.68%  [guest.kernel]  [g] copy_user_generic_unrolled
    2.58%  [guest.kernel]  [g] clear_page
    2.09%  [guest.kernel]  [g] page_cache_get_speculative
    2.00%  [guest.kernel]  [g] do_raw_spin_lock
    1.78%  [guest.kernel]  [g] unmap_single_vma
    1.74%  [guest.kernel]  [g] kmem_cache_alloc

pleopt ple_window = 4k
---------------------------
ebizzy: 10176 records/s
   69.17%  [guest.kernel]  [g] _raw_spin_lock_irqsave
    3.34%  [guest.kernel]  [g] clear_page
    2.16%  [guest.kernel]  [g] down_read_trylock
    1.94%  [guest.kernel]  [g] async_page_fault
    1.89%  [guest.kernel]  [g] native_apic_mem_write
    1.63%  [guest.kernel]  [g] smp_call_function_many
    1.58%  [guest.kernel]  [g] SetPageLRU
    1.37%  [guest.kernel]  [g] up_read
    1.01%  [guest.kernel]  [g] find_vma


kernbench: 29.9533
nts: 240K cycles
    6.04%  [guest.kernel]  [g] async_page_fault
    4.17%  [guest.kernel]  [g] pvclock_clocksource_read
    3.28%  [guest.kernel]  [g] clear_page
    2.57%  [guest.kernel]  [g] copy_user_generic_unrolled
    2.30%  [guest.kernel]  [g] do_raw_spin_lock
    2.13%  [guest.kernel]  [g] _raw_spin_lock_irqsave
    1.93%  [guest.kernel]  [g] page_cache_get_speculative
    1.92%  [guest.kernel]  [g] unmap_single_vma
    1.77%  [guest.kernel]  [g] kmem_cache_alloc
    1.61%  [guest.kernel]  [g] __d_lookup_rcu
    1.19%  [guest.kernel]  [g] find_vma
    1.19%  [guest.kernel]  [g] __list_del_entry


pleopt: ple_window=16k
-------------------------
ebizzy: 16990
 62.35%  [guest.kernel]  [g] _raw_spin_lock_irqsave
    5.22%  [guest.kernel]  [g] smp_call_function_many
    3.57%  [guest.kernel]  [g] down_read_trylock
    3.20%  [guest.kernel]  [g] clear_page
    2.16%  [guest.kernel]  [g] up_read
    1.89%  [guest.kernel]  [g] find_vma
    1.86%  [guest.kernel]  [g] async_page_fault
    1.81%  [guest.kernel]  [g] native_apic_mem_write

kernbench: 28.5
 6.24%  [guest.kernel]  [g] async_page_fault
    4.16%  [guest.kernel]  [g] pvclock_clocksource_read
    3.33%  [guest.kernel]  [g] clear_page
    2.50%  [guest.kernel]  [g] copy_user_generic_unrolled
    2.08%  [guest.kernel]  [g] do_raw_spin_lock
    1.98%  [guest.kernel]  [g] unmap_single_vma
    1.89%  [guest.kernel]  [g] kmem_cache_alloc
    1.82%  [guest.kernel]  [g] page_cache_get_speculative
    1.46%  [guest.kernel]  [g] __d_lookup_rcu
    1.42%  [guest.kernel]  [g] _raw_spin_lock_irqsave
    1.15%  [guest.kernel]  [g] __list_del_entry
    1.10%  [guest.kernel]  [g] find_vma



Detailed result for the run
=============================
patched = base_pleopt_16k 
+-----------+-----------+-----------+------------+-----------+
                              kernbench 
+-----------+-----------+-----------+------------+-----------+
   base        stddev       patched    stdev        %improve     
+-----------+-----------+-----------+------------+-----------+
1x    30.0440     1.1896    29.9167     1.6755	   0.42371
2x    62.0083     3.4884    62.8825     2.5509	  -1.40981
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
                              sysbench 
+-----------+-----------+-----------+------------+-----------+
1x     7.1779     0.0577     7.2442     0.0479	  -0.92367
2x    15.5362     0.3370    15.8822     0.3591	  -2.22706
3x    23.8249     0.1513    24.0048     0.1844	  -0.75509
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
                              ebizzy 
+-----------+-----------+-----------+------------+-----------+
1x 10358.0000   442.6598   16054.8750  252.5088    54.99976
2x  2705.5000   130.0286   2466.5000   120.0024	  -8.83386
+-----------+-----------+-----------+------------+-----------+

patched = base_pleopt_32k
+-----------+-----------+-----------+------------+-----------+
                              kernbench 
+-----------+-----------+-----------+------------+-----------+
   base        stddev       patched    stdev        %improve     
+-----------+-----------+-----------+------------+-----------+
1x    30.0440     1.1896    29.6980     0.6760	   1.15164
2x    62.0083     3.4884    72.8491     4.4616	 -17.48282
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
                              sysbench 
+-----------+-----------+-----------+------------+-----------+
1x     7.1779     0.0577     7.1605     0.0447	   0.24241
2x    15.5362     0.3370    15.5842     0.1731	  -0.30896
3x    23.8249     0.1513    23.8024     0.2342	   0.09444
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
                              ebizzy 
+-----------+-----------+-----------+------------+-----------+
1x  10358.0000   442.6598   17328.3750   281.4569   67.29460
2x  2705.5000   130.0286    1964.6250   143.0793   -27.38403
+-----------+-----------+-----------+------------+-----------+

patched = base_pleopt_nople
+-----------+-----------+-----------+------------+-----------+
                              kernbench 
+-----------+-----------+-----------+------------+-----------+
   base        stddev       patched    stdev        %improve     
+-----------+-----------+-----------+------------+-----------+
1x    30.0440     1.1896    30.0160     0.7523	   0.09320
2x    62.0083     3.4884   415.9334   189.9901	  -570.77053
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
                              sysbench 
+-----------+-----------+-----------+------------+-----------+
1x     7.1779     0.0577     7.1973     0.0354	  -0.27027
2x    15.5362     0.3370    15.7344     0.2315	  -1.27573
3x    23.8249     0.1513    24.5343     0.3437	  -2.97756
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
                              ebizzy 
+-----------+-----------+-----------+------------+-----------+
1x 10358.0000   442.6598 18037.5000   315.2074	   74.14076
2x  2705.5000   130.0286   102.2500   104.3521	  -96.22066
+-----------+-----------+-----------+------------+-----------+

