Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab3AFHxh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 02:53:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:52114 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab3AFHxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 02:53:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,419,1355126400"; 
   d="scan'208";a="268106636"
Message-ID: <50E92DC3.4050906@intel.com>
Date: Sun, 06 Jan 2013 15:54:43 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>, pjt@google.com, mingo@redhat.com
CC: peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, namhyung@kernel.org,
        efault@gmx.de, vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v3 09/22] sched: compute runnable load avg in cpu_load
 and cpu_avg_load_per_task
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-10-git-send-email-alex.shi@intel.com> <50E7EAB1.6020302@intel.com>
In-Reply-To: <50E7EAB1.6020302@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>  static unsigned long weighted_cpuload(const int cpu)
>>  {
>> -	return cpu_rq(cpu)->load.weight;
>> +	return (unsigned long)cpu_rq(cpu)->cfs.runnable_load_avg;
> 
> Above line change cause aim9 multitask benchmark drop about 10%
> performance on many x86 machines. Profile just show there are more
> cpuidle enter called.
> The testing command:
> 
> #( echo $hostname ; echo test ; echo 1 ; echo 2000 ; echo 2 ; echo 2000
> ; echo 100 ) | ./multitask -nl
> 
> The oprofile output here:
> with this patch set
> 101978 total                                      0.0134
>  54406 cpuidle_wrap_enter                       499.1376
>   2098 __do_page_fault                            2.0349
>   1976 rwsem_wake                                29.0588
>   1824 finish_task_switch                        12.4932
>   1560 copy_user_generic_string                  24.3750
>   1346 clear_page_c                              84.1250
>   1249 unmap_single_vma                           0.6885
>   1141 copy_page_rep                             71.3125
>   1093 anon_vma_interval_tree_insert              8.1567
> 
> 3.8-rc2
>  68982 total                                      0.0090
>  22166 cpuidle_wrap_enter                       203.3578
>   2188 rwsem_wake                                32.1765
>   2136 __do_page_fault                            2.0718
>   1920 finish_task_switch                        13.1507
>   1724 poll_idle                                 15.2566
>   1433 copy_user_generic_string                  22.3906
>   1237 clear_page_c                              77.3125
>   1222 unmap_single_vma                           0.6736
>   1053 anon_vma_interval_tree_insert              7.8582
> 
> Without load avg in periodic balancing, each cpu will weighted with all
> tasks load.
> 
> with new load tracking, we just update the cfs_rq load avg with each
> task at enqueue/dequeue moment, and with just update current task in
> scheduler_tick. I am wondering if it's the sample is a bit rare.
> 
> What's your opinion of this, Paul?
> 

Ingo & Paul:

I just looked into the aim9 benchmark, in this case it forks 2000 tasks,
after all tasks ready, aim9 give a signal than all tasks burst waking up
and run until all finished.
Since each of tasks are finished very quickly, a imbalanced empty cpu
may goes to sleep till a regular balancing give it some new tasks. That
causes the performance dropping. cause more idle entering.

According to load avg's design, it needs time to accumulate its load
weight. So, it's hard to find a way resolving this problem.

As to other scheduler related benchmarks, like kbuild, specjbb2005,
hachbench, sysbench etc, I didn't find clear improvement or regression
on the load avg balancing.

Any comments for this problem?

-- 
Thanks Alex
