Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab0JLDIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 23:08:01 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41286 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab0JLDIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 23:08:00 -0400
Message-ID: <4CB3D097.6000604@kernel.org>
Date: Mon, 11 Oct 2010 20:05:59 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Jack Steiner <steiner@sgi.com>,
        mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fix slowness of /proc/stat per-cpu IRQ sum calculation
 on large system by a new counter
References: <20100929122206.GA30317@sgi.com>	<20100930140901.037f9dc7.kamezawa.hiroyu@jp.fujitsu.com>	<20101004143414.GA4261@sgi.com>	<20101005103650.7ebe64f0.kamezawa.hiroyu@jp.fujitsu.com>	<20101005171907.23c75102.kamezawa.hiroyu@jp.fujitsu.com>	<20101008163557.GA13859@sgi.com>	<20101012090907.5dd1cf57.kamezawa.hiroyu@jp.fujitsu.com>	<20101011172226.6162476c.akpm@linux-foundation.org> <20101012113736.f34d1426.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101012113736.f34d1426.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2010 07:37 PM, KAMEZAWA Hiroyuki wrote:
> Jack Steiner reported slowness of /proc/stat on a large system.
> This patch set tries to improve it.
> 
>> The combination of the 2 patches solves the problem.
>> The timings are (4096p, 256 nodes, 4592 irqs):
>>
>> 	# time cat /proc/stat > /dev/null
>>
>> 	Baseline:		12.627 sec
>> 	Patch1  :		 2.459 sec
>> 	Patch 1 + Patch 2:	  .561 sec
> 
> please review.
> 
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Problem: 'cat /proc/stat' is too slow on verrry bis system.
> 
> /proc/stat shows the total number of all interrupts to each cpu. But when
> the number of IRQs are very large, it takes very long time and 'cat /proc/stat'
> takes more than 10 secs. This is because sum of all irq events are counted
> when /proc/stat is read. This patch adds "sum of all irq" counter percpu
> and update it at events.
> 
> The cost of reading /proc/stat is important because it's used by major
> applications as 'top', 'ps', 'w', etc....
> 
> A test on a host (4096cpu, 256 nodes, 4592 irqs) shows
> 
>  %time cat /proc/stat > /dev/null
>  Before Patch:  12.627 sec
>  After  Patch:  2.459 sec
> 
> Tested-by: Jack Steiner <steiner@sgi.com>
> Acked-by: Jack Steiner <steiner@sgi.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  fs/proc/stat.c              |    4 +---
>  include/linux/kernel_stat.h |   14 ++++++++++++--
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6.36-rc7/fs/proc/stat.c
> ===================================================================
> --- linux-2.6.36-rc7.orig/fs/proc/stat.c
> +++ linux-2.6.36-rc7/fs/proc/stat.c
> @@ -52,9 +52,7 @@ static int show_stat(struct seq_file *p,
>  		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
>  		guest_nice = cputime64_add(guest_nice,
>  			kstat_cpu(i).cpustat.guest_nice);
> -		for_each_irq_nr(j) {
> -			sum += kstat_irqs_cpu(j, i);
> -		}
> +		sum = kstat_cpu_irqs_sum(i);

should be 
+		sum += kstat_cpu_irqs_sum(i);

>  		sum += arch_irq_stat_cpu(i);
>  
>  		for (j = 0; j < NR_SOFTIRQS; j++) {
> Index: linux-2.6.36-rc7/include/linux/kernel_stat.h
> ===================================================================
> --- linux-2.6.36-rc7.orig/include/linux/kernel_stat.h
> +++ linux-2.6.36-rc7/include/linux/kernel_stat.h
> @@ -33,6 +33,7 @@ struct kernel_stat {
>  #ifndef CONFIG_GENERIC_HARDIRQS
>         unsigned int irqs[NR_IRQS];
>  #endif
> +	unsigned long irqs_sum;
>  	unsigned int softirqs[NR_SOFTIRQS];
>  };
>  
> @@ -54,6 +55,7 @@ static inline void kstat_incr_irqs_this_
>  					    struct irq_desc *desc)
>  {
>  	kstat_this_cpu.irqs[irq]++;
> +	kstat_this_cpu.irqs_sum++;
>  }
>  
>  static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
> @@ -65,8 +67,9 @@ static inline unsigned int kstat_irqs_cp
>  extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
>  #define kstat_irqs_this_cpu(DESC) \
>  	((DESC)->kstat_irqs[smp_processor_id()])
> -#define kstat_incr_irqs_this_cpu(irqno, DESC) \
> -	((DESC)->kstat_irqs[smp_processor_id()]++)
> +#define kstat_incr_irqs_this_cpu(irqno, DESC) do {\
> +	((DESC)->kstat_irqs[smp_processor_id()]++);\
> +	kstat_this_cpu.irqs_sum++; } while (0)
>  
>  #endif
>  
> @@ -94,6 +97,13 @@ static inline unsigned int kstat_irqs(un
>  	return sum;
>  }
>  
> +/*
> + * Number of interrupts per cpu, since bootup
> + */
> +static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
> +{
> +	return kstat_cpu(cpu).irqs_sum;
> +}
>  
>  /*
>   * Lock/unlock the current runqueue - to extract task statistics:

