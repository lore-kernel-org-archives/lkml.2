Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab3AGIOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 03:14:14 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:50225 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab3AGIOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 03:14:12 -0500
Date: Mon, 7 Jan 2013 16:14:04 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, rostedt@goodmis.org,
        axboe@kernel.dk
Subject: Re: [patch]smp: make smp_call_function_many use the similar logic
 like smp_call_function_single
Message-ID: <20130107081404.GC21779@kernel.org>
References: <20121224070330.GA9331@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121224070330.GA9331@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping!

On Mon, Dec 24, 2012 at 03:03:30PM +0800, Shaohua Li wrote:
> 
> I'm testing swapout workload in a two-socket Xeon machine. The workload has 10
> threads, each thread sequentially accesses separate memory region. TLB flush
> overhead is very big in the workload. For each page, page reclaim need move it
> from active lru list and then unmap it. Both need a TLB flush. And this is a
> multthread workload, TLB flush happens in 10 CPUs. In X86, TLB flush uses
> generic smp_call)function. So this workload stress smp_call_function_many
> heavily.
> 
> Without patch, perf shows:
> +  24.49%  [k] generic_smp_call_function_interrupt
> -  21.72%  [k] _raw_spin_lock 
>    - _raw_spin_lock 
>       + 79.80% __page_check_address 
>       + 6.42% generic_smp_call_function_interrupt
>       + 3.31% get_swap_page                       
>       + 2.37% free_pcppages_bulk                  
>       + 1.75% handle_pte_fault                    
>       + 1.54% put_super                           
>       + 1.41% grab_super_passive                  
>       + 1.36% __swap_duplicate                    
>       + 0.68% blk_flush_plug_list                 
>       + 0.62% swap_info_get                       
> +   6.55%  [k] flush_tlb_func                     
> +   6.46%  [k] smp_call_function_many             
> +   5.09%  [k] call_function_interrupt            
> +   4.75%  [k] default_send_IPI_mask_sequence_phys
> +   2.18%  [k] find_next_bit
> 
> swapout throughput is around 1300M/s.
> 
> With the patch, perf shows:
> -  27.23%  [k] _raw_spin_lock                           
>    - _raw_spin_lock                                     
>       + 80.53% __page_check_address                     
>       + 8.39% generic_smp_call_function_single_interrupt
>       + 2.44% get_swap_page                             
>       + 1.76% free_pcppages_bulk                        
>       + 1.40% handle_pte_fault                          
>       + 1.15% __swap_duplicate                          
>       + 1.05% put_super                                 
>       + 0.98% grab_super_passive                        
>       + 0.86% blk_flush_plug_list                       
>       + 0.57% swap_info_get                             
> +   8.25%  [k] default_send_IPI_mask_sequence_phys      
> +   7.55%  [k] call_function_interrupt                  
> +   7.47%  [k] smp_call_function_many                   
> +   7.25%  [k] flush_tlb_func                           
> +   3.81%  [k] _raw_spin_lock_irqsave                   
> +   3.78%  [k] generic_smp_call_function_single_interrupt
> 
> swapout throughput is around 1400M/s. So there is around a 7% improvement, and
> total cpu utilization doesn't change.
> 
> Without the patch, cfd_data is shared by all CPUs.
> generic_smp_call_function_interrupt does read/write cfd_data several times
> which will create a lot of cache ping-pong. With the patch, the data becomes
> per-cpu. The ping-pong is avoided. And from the perf data, this doesn't make
> call_single_queue lock contend.
> 
> Next step is to remove generic_smp_call_function_interrupt from arch code.
> 
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  include/linux/smp.h |    3 
>  kernel/smp.c        |  184 ++++++++--------------------------------------------
>  2 files changed, 32 insertions(+), 155 deletions(-)
> 
> Index: linux/kernel/smp.c
> ===================================================================
> --- linux.orig/kernel/smp.c	2012-12-24 11:37:28.150604463 +0800
> +++ linux/kernel/smp.c	2012-12-24 14:57:11.807949527 +0800
> @@ -16,22 +16,12 @@
>  #include "smpboot.h"
>  
>  #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
> -static struct {
> -	struct list_head	queue;
> -	raw_spinlock_t		lock;
> -} call_function __cacheline_aligned_in_smp =
> -	{
> -		.queue		= LIST_HEAD_INIT(call_function.queue),
> -		.lock		= __RAW_SPIN_LOCK_UNLOCKED(call_function.lock),
> -	};
> -
>  enum {
>  	CSD_FLAG_LOCK		= 0x01,
>  };
>  
>  struct call_function_data {
> -	struct call_single_data	csd;
> -	atomic_t		refs;
> +	struct call_single_data	__percpu *csd;
>  	cpumask_var_t		cpumask;
>  };
>  
> @@ -56,6 +46,11 @@ hotplug_cfd(struct notifier_block *nfb,
>  		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
>  				cpu_to_node(cpu)))
>  			return notifier_from_errno(-ENOMEM);
> +		cfd->csd = alloc_percpu(struct call_single_data);
> +		if (!cfd->csd) {
> +			free_cpumask_var(cfd->cpumask);
> +			return notifier_from_errno(-ENOMEM);
> +		}
>  		break;
>  
>  #ifdef CONFIG_HOTPLUG_CPU
> @@ -65,6 +60,7 @@ hotplug_cfd(struct notifier_block *nfb,
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
>  		free_cpumask_var(cfd->cpumask);
> +		free_percpu(cfd->csd);
>  		break;
>  #endif
>  	};
> @@ -166,85 +162,6 @@ void generic_exec_single(int cpu, struct
>  }
>  
>  /*
> - * Invoked by arch to handle an IPI for call function. Must be called with
> - * interrupts disabled.
> - */
> -void generic_smp_call_function_interrupt(void)
> -{
> -	struct call_function_data *data;
> -	int cpu = smp_processor_id();
> -
> -	/*
> -	 * Shouldn't receive this interrupt on a cpu that is not yet online.
> -	 */
> -	WARN_ON_ONCE(!cpu_online(cpu));
> -
> -	/*
> -	 * Ensure entry is visible on call_function_queue after we have
> -	 * entered the IPI. See comment in smp_call_function_many.
> -	 * If we don't have this, then we may miss an entry on the list
> -	 * and never get another IPI to process it.
> -	 */
> -	smp_mb();
> -
> -	/*
> -	 * It's ok to use list_for_each_rcu() here even though we may
> -	 * delete 'pos', since list_del_rcu() doesn't clear ->next
> -	 */
> -	list_for_each_entry_rcu(data, &call_function.queue, csd.list) {
> -		int refs;
> -		smp_call_func_t func;
> -
> -		/*
> -		 * Since we walk the list without any locks, we might
> -		 * see an entry that was completed, removed from the
> -		 * list and is in the process of being reused.
> -		 *
> -		 * We must check that the cpu is in the cpumask before
> -		 * checking the refs, and both must be set before
> -		 * executing the callback on this cpu.
> -		 */
> -
> -		if (!cpumask_test_cpu(cpu, data->cpumask))
> -			continue;
> -
> -		smp_rmb();
> -
> -		if (atomic_read(&data->refs) == 0)
> -			continue;
> -
> -		func = data->csd.func;		/* save for later warn */
> -		func(data->csd.info);
> -
> -		/*
> -		 * If the cpu mask is not still set then func enabled
> -		 * interrupts (BUG), and this cpu took another smp call
> -		 * function interrupt and executed func(info) twice
> -		 * on this cpu.  That nested execution decremented refs.
> -		 */
> -		if (!cpumask_test_and_clear_cpu(cpu, data->cpumask)) {
> -			WARN(1, "%pf enabled interrupts and double executed\n", func);
> -			continue;
> -		}
> -
> -		refs = atomic_dec_return(&data->refs);
> -		WARN_ON(refs < 0);
> -
> -		if (refs)
> -			continue;
> -
> -		WARN_ON(!cpumask_empty(data->cpumask));
> -
> -		raw_spin_lock(&call_function.lock);
> -		list_del_rcu(&data->csd.list);
> -		raw_spin_unlock(&call_function.lock);
> -
> -		csd_unlock(&data->csd);
> -	}
> -
> -}
> -
> -/*
>   * Invoked by arch to handle an IPI for call function single. Must be
>   * called from the arch with interrupts disabled.
>   */
> @@ -448,8 +365,7 @@ void smp_call_function_many(const struct
>  			    smp_call_func_t func, void *info, bool wait)
>  {
>  	struct call_function_data *data;
> -	unsigned long flags;
> -	int refs, cpu, next_cpu, this_cpu = smp_processor_id();
> +	int cpu, next_cpu, this_cpu = smp_processor_id();
>  
>  	/*
>  	 * Can deadlock when called with interrupts disabled.
> @@ -481,79 +397,39 @@ void smp_call_function_many(const struct
>  	}
>  
>  	data = &__get_cpu_var(cfd_data);
> -	csd_lock(&data->csd);
> -
> -	/* This BUG_ON verifies our reuse assertions and can be removed */
> -	BUG_ON(atomic_read(&data->refs) || !cpumask_empty(data->cpumask));
> -
> -	/*
> -	 * The global call function queue list add and delete are protected
> -	 * by a lock, but the list is traversed without any lock, relying
> -	 * on the rcu list add and delete to allow safe concurrent traversal.
> -	 * We reuse the call function data without waiting for any grace
> -	 * period after some other cpu removes it from the global queue.
> -	 * This means a cpu might find our data block as it is being
> -	 * filled out.
> -	 *
> -	 * We hold off the interrupt handler on the other cpu by
> -	 * ordering our writes to the cpu mask vs our setting of the
> -	 * refs counter.  We assert only the cpu owning the data block
> -	 * will set a bit in cpumask, and each bit will only be cleared
> -	 * by the subject cpu.  Each cpu must first find its bit is
> -	 * set and then check that refs is set indicating the element is
> -	 * ready to be processed, otherwise it must skip the entry.
> -	 *
> -	 * On the previous iteration refs was set to 0 by another cpu.
> -	 * To avoid the use of transitivity, set the counter to 0 here
> -	 * so the wmb will pair with the rmb in the interrupt handler.
> -	 */
> -	atomic_set(&data->refs, 0);	/* convert 3rd to 1st party write */
>  
> -	data->csd.func = func;
> -	data->csd.info = info;
> -
> -	/* Ensure 0 refs is visible before mask.  Also orders func and info */
> -	smp_wmb();
> -
> -	/* We rely on the "and" being processed before the store */
>  	cpumask_and(data->cpumask, mask, cpu_online_mask);
>  	cpumask_clear_cpu(this_cpu, data->cpumask);
> -	refs = cpumask_weight(data->cpumask);
>  
>  	/* Some callers race with other cpus changing the passed mask */
> -	if (unlikely(!refs)) {
> -		csd_unlock(&data->csd);
> +	if (unlikely(!cpumask_weight(data->cpumask)))
>  		return;
> -	}
> -
> -	raw_spin_lock_irqsave(&call_function.lock, flags);
> -	/*
> -	 * Place entry at the _HEAD_ of the list, so that any cpu still
> -	 * observing the entry in generic_smp_call_function_interrupt()
> -	 * will not miss any other list entries:
> -	 */
> -	list_add_rcu(&data->csd.list, &call_function.queue);
> -	/*
> -	 * We rely on the wmb() in list_add_rcu to complete our writes
> -	 * to the cpumask before this write to refs, which indicates
> -	 * data is on the list and is ready to be processed.
> -	 */
> -	atomic_set(&data->refs, refs);
> -	raw_spin_unlock_irqrestore(&call_function.lock, flags);
>  
> -	/*
> -	 * Make the list addition visible before sending the ipi.
> -	 * (IPIs must obey or appear to obey normal Linux cache
> -	 * coherency rules -- see comment in generic_exec_single).
> -	 */
> -	smp_mb();
> +	for_each_cpu(cpu, data->cpumask) {
> +		struct call_single_data *csd = per_cpu_ptr(data->csd, cpu);
> +		struct call_single_queue *dst =
> +					&per_cpu(call_single_queue, cpu);
> +		unsigned long flags;
> +
> +		csd_lock(csd);
> +		csd->func = func;
> +		csd->info = info;
> +
> +		raw_spin_lock_irqsave(&dst->lock, flags);
> +		list_add_tail(&csd->list, &dst->list);
> +		raw_spin_unlock_irqrestore(&dst->lock, flags);
> +	}
>  
>  	/* Send a message to all CPUs in the map */
>  	arch_send_call_function_ipi_mask(data->cpumask);
>  
> -	/* Optionally wait for the CPUs to complete */
> -	if (wait)
> -		csd_lock_wait(&data->csd);
> +	if (wait) {
> +		for_each_cpu(cpu, data->cpumask) {
> +			struct call_single_data *csd =
> +					per_cpu_ptr(data->csd, cpu);
> +			csd_lock_wait(csd);
> +		}
> +	}
>  }
>  EXPORT_SYMBOL(smp_call_function_many);
>  
> Index: linux/include/linux/smp.h
> ===================================================================
> --- linux.orig/include/linux/smp.h	2012-12-24 11:38:28.901840885 +0800
> +++ linux/include/linux/smp.h	2012-12-24 11:39:16.557243069 +0800
> @@ -89,7 +89,8 @@ void kick_all_cpus_sync(void);
>  #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
>  void __init call_function_init(void);
>  void generic_smp_call_function_single_interrupt(void);
> -void generic_smp_call_function_interrupt(void);
> +#define generic_smp_call_function_interrupt \
> +	generic_smp_call_function_single_interrupt
>  #else
>  static inline void call_function_init(void) { }
>  #endif
