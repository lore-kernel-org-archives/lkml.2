Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab0JHQgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 12:36:03 -0400
Received: from relay1.sgi.com ([192.48.179.29]:48295 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756963Ab0JHQgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 12:36:02 -0400
Date: Fri, 8 Oct 2010 11:35:57 -0500
From: Jack Steiner <steiner@sgi.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: yinghai@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: Problem: scaling of /proc/stat on large systems
Message-ID: <20101008163557.GA13859@sgi.com>
References: <20100929122206.GA30317@sgi.com> <20100930140901.037f9dc7.kamezawa.hiroyu@jp.fujitsu.com> <20101004143414.GA4261@sgi.com> <20101005103650.7ebe64f0.kamezawa.hiroyu@jp.fujitsu.com> <20101005171907.23c75102.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005171907.23c75102.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 05:19:07PM +0900, KAMEZAWA Hiroyuki wrote:
> On Tue, 5 Oct 2010 10:36:50 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > I guess this requres different approarch as per-cpu counter + threshould.
> > like vmstat[] or lib/percpu_counter. 
> > Maybe people don't like to access shared counter in IRQ.
> > 
> > But, this seems to call radixtree-lookup for the # of possible cpus.
> > I guess impleimenting a call to calculate a sum of irqs in a radix-tree
> > lookup will reduce overhead. If it's not enough, we'll have to make the
> > counter not-precise. I'll write an another patch.
> > 
> 
> How about this ? This is an add-on patch.

Nice!!

The combination of the 2 patches solves the problem.
The timings are (4096p, 256 nodes, 4592 irqs):

	# time cat /proc/stat > /dev/null

	Baseline:		12.627 sec
	Patch1  :		 2.459 sec
	Patch 1 + Patch 2:	  .561 sec


Acked-by: Jack Steiner <steiner@sgi.com>


Thanks!!
--- jack


> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> In /proc/stat, the number of per-IRQ event is shown by making a sum
> each irq's events on all cpus. But we can make use of kstat_irqs().
> 
> kstat_irqs() make a sum of IRQ events per cpu, if !CONFIG_GENERIC_HARDIRQ,
> it's not a big cost. (Both of the number of cpus and irqs are small.)
> 
> If a system is very big, it does
> 
> 	for_each_irq()
> 		for_each_cpu()
> 			- look up a radix tree
> 			- read desc->irq_stat[cpu]
> This seems not efficient. This patch adds kstat_irqs() for CONFIG_GENRIC_HARDIRQ
> and change the calculation as
> 
> 	for_each_irq()
> 		look up radix tree
> 		for_each_cpu()
> 			- read desc->irq_stat[cpu]
> 
> and reduces cost.
> 
> Signged-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  fs/proc/stat.c              |    9 ++-------
>  include/linux/kernel_stat.h |    5 +++++
>  kernel/irq/handle.c         |   16 ++++++++++++++++
>  3 files changed, 23 insertions(+), 7 deletions(-)
> 
> Index: mmotm-0928/fs/proc/stat.c
> ===================================================================
> --- mmotm-0928.orig/fs/proc/stat.c
> +++ mmotm-0928/fs/proc/stat.c
> @@ -108,13 +108,8 @@ static int show_stat(struct seq_file *p,
>  	seq_printf(p, "intr %llu", (unsigned long long)sum);
>  
>  	/* sum again ? it could be updated? */
> -	for_each_irq_nr(j) {
> -		per_irq_sum = 0;
> -		for_each_possible_cpu(i)
> -			per_irq_sum += kstat_irqs_cpu(j, i);
> -
> -		seq_printf(p, " %u", per_irq_sum);
> -	}
> +	for_each_irq_nr(j)
> +		seq_printf(p, " %u", kstat_irqs(j));
>  
>  	seq_printf(p,
>  		"\nctxt %llu\n"
> Index: mmotm-0928/include/linux/kernel_stat.h
> ===================================================================
> --- mmotm-0928.orig/include/linux/kernel_stat.h
> +++ mmotm-0928/include/linux/kernel_stat.h
> @@ -62,6 +62,7 @@ static inline unsigned int kstat_irqs_cp
>  {
>         return kstat_cpu(cpu).irqs[irq];
>  }
> +
>  #else
>  #include <linux/irq.h>
>  extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
> @@ -86,6 +87,7 @@ static inline unsigned int kstat_softirq
>  /*
>   * Number of interrupts per specific IRQ source, since bootup
>   */
> +#ifndef CONFIG_GENERIC_HARDIRQS
>  static inline unsigned int kstat_irqs(unsigned int irq)
>  {
>  	unsigned int sum = 0;
> @@ -96,6 +98,9 @@ static inline unsigned int kstat_irqs(un
>  
>  	return sum;
>  }
> +#else
> +extern unsigned int unsigned int kstat_irqs(unsigned int irq);
> +#endif
>  
>  /*
>   * Number of interrupts per cpu, since bootup
> Index: mmotm-0928/kernel/irq/handle.c
> ===================================================================
> --- mmotm-0928.orig/kernel/irq/handle.c
> +++ mmotm-0928/kernel/irq/handle.c
> @@ -553,3 +553,19 @@ unsigned int kstat_irqs_cpu(unsigned int
>  }
>  EXPORT_SYMBOL(kstat_irqs_cpu);
>  
> +#ifdef CONFIG_GENERIC_HARDIRQS
> +unsigned int kstat_irqs(unsigned int irq)
> +{
> +	struct irq_desc *desc = irq_to_desc(irq);
> +	int cpu;
> +	int sum = 0;
> +
> +	if (!desc)
> +		return 0;
> +
> +	for_each_possible_cpu(cpu)
> +		sum += desc->kstat_irqs[cpu];
> +	return sum;
> +}
> +EXPORT_SYMBOL(kstat_irqs);
> +#endif
