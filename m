Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3AHWil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:38:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab3AHWij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:38:39 -0500
Date: Tue, 8 Jan 2013 14:38:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, rostedt@goodmis.org,
        axboe@kernel.dk
Subject: Re: [patch]smp: make smp_call_function_many use the similar logic
 like smp_call_function_single
Message-Id: <20130108143837.93b4cd29.akpm@linux-foundation.org>
In-Reply-To: <20121224070330.GA9331@kernel.org>
References: <20121224070330.GA9331@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Dec 2012 15:03:30 +0800
Shaohua Li <shli@kernel.org> wrote:

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

Boy, that was a biiiig cleanup.  I hope it works ;)

The naming of locals in that code makes my eyes hurt.  How's this?


From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/smp.c: cleanups

We sometimes use "struct call_single_data *data" and sometimes "struct
call_single_data *csd".  Use "cfd" consistently.

We sometimes use "struct call_function_data *data" and sometimes "struct
call_function_data *cfd".  Use "cfd" consistently.

Also, avoid some 80-col layout tricks.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smp.c |   87 ++++++++++++++++++++++++-------------------------
 1 file changed, 44 insertions(+), 43 deletions(-)

diff -puN include/linux/smp.h~kernel-smpc-cleanups include/linux/smp.h
diff -puN kernel/smp.c~kernel-smpc-cleanups kernel/smp.c
--- a/kernel/smp.c~kernel-smpc-cleanups
+++ a/kernel/smp.c
@@ -95,16 +95,16 @@ void __init call_function_init(void)
  * previous function call. For multi-cpu calls its even more interesting
  * as we'll have to ensure no other cpu is observing our csd.
  */
-static void csd_lock_wait(struct call_single_data *data)
+static void csd_lock_wait(struct call_single_data *csd)
 {
-	while (data->flags & CSD_FLAG_LOCK)
+	while (csd->flags & CSD_FLAG_LOCK)
 		cpu_relax();
 }
 
-static void csd_lock(struct call_single_data *data)
+static void csd_lock(struct call_single_data *csd)
 {
-	csd_lock_wait(data);
-	data->flags = CSD_FLAG_LOCK;
+	csd_lock_wait(csd);
+	csd->flags = CSD_FLAG_LOCK;
 
 	/*
 	 * prevent CPU from reordering the above assignment
@@ -114,16 +114,16 @@ static void csd_lock(struct call_single_
 	smp_mb();
 }
 
-static void csd_unlock(struct call_single_data *data)
+static void csd_unlock(struct call_single_data *csd)
 {
-	WARN_ON(!(data->flags & CSD_FLAG_LOCK));
+	WARN_ON(!(csd->flags & CSD_FLAG_LOCK));
 
 	/*
 	 * ensure we're all done before releasing data:
 	 */
 	smp_mb();
 
-	data->flags &= ~CSD_FLAG_LOCK;
+	csd->flags &= ~CSD_FLAG_LOCK;
 }
 
 /*
@@ -132,7 +132,7 @@ static void csd_unlock(struct call_singl
  * ->func, ->info, and ->flags set.
  */
 static
-void generic_exec_single(int cpu, struct call_single_data *data, int wait)
+void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
 {
 	struct call_single_queue *dst = &per_cpu(call_single_queue, cpu);
 	unsigned long flags;
@@ -140,7 +140,7 @@ void generic_exec_single(int cpu, struct
 
 	raw_spin_lock_irqsave(&dst->lock, flags);
 	ipi = list_empty(&dst->list);
-	list_add_tail(&data->list, &dst->list);
+	list_add_tail(&csd->list, &dst->list);
 	raw_spin_unlock_irqrestore(&dst->lock, flags);
 
 	/*
@@ -158,7 +158,7 @@ void generic_exec_single(int cpu, struct
 		arch_send_call_function_single_ipi(cpu);
 
 	if (wait)
-		csd_lock_wait(data);
+		csd_lock_wait(csd);
 }
 
 /*
@@ -168,7 +168,6 @@ void generic_exec_single(int cpu, struct
 void generic_smp_call_function_single_interrupt(void)
 {
 	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
-	unsigned int data_flags;
 	LIST_HEAD(list);
 
 	/*
@@ -181,25 +180,26 @@ void generic_smp_call_function_single_in
 	raw_spin_unlock(&q->lock);
 
 	while (!list_empty(&list)) {
-		struct call_single_data *data;
+		struct call_single_data *csd;
+		unsigned int csd_flags;
 
-		data = list_entry(list.next, struct call_single_data, list);
-		list_del(&data->list);
+		csd = list_entry(list.next, struct call_single_data, list);
+		list_del(&csd->list);
 
 		/*
-		 * 'data' can be invalid after this call if flags == 0
+		 * 'csd' can be invalid after this call if flags == 0
 		 * (when called through generic_exec_single()),
 		 * so save them away before making the call:
 		 */
-		data_flags = data->flags;
+		csd_flags = csd->flags;
 
-		data->func(data->info);
+		csd->func(csd->info);
 
 		/*
 		 * Unlocked CSDs are valid through generic_exec_single():
 		 */
-		if (data_flags & CSD_FLAG_LOCK)
-			csd_unlock(data);
+		if (csd_flags & CSD_FLAG_LOCK)
+			csd_unlock(csd);
 	}
 }
 
@@ -244,16 +244,16 @@ int smp_call_function_single(int cpu, sm
 		local_irq_restore(flags);
 	} else {
 		if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu)) {
-			struct call_single_data *data = &d;
+			struct call_single_data *csd = &d;
 
 			if (!wait)
-				data = &__get_cpu_var(csd_data);
+				csd = &__get_cpu_var(csd_data);
 
-			csd_lock(data);
+			csd_lock(csd);
 
-			data->func = func;
-			data->info = info;
-			generic_exec_single(cpu, data, wait);
+			csd->func = func;
+			csd->info = info;
+			generic_exec_single(cpu, csd, wait);
 		} else {
 			err = -ENXIO;	/* CPU not online */
 		}
@@ -320,7 +320,7 @@ EXPORT_SYMBOL_GPL(smp_call_function_any)
  * pre-allocated data structure. Useful for embedding @data inside
  * other structures, for instance.
  */
-void __smp_call_function_single(int cpu, struct call_single_data *data,
+void __smp_call_function_single(int cpu, struct call_single_data *csd,
 				int wait)
 {
 	unsigned int this_cpu;
@@ -338,11 +338,11 @@ void __smp_call_function_single(int cpu,
 
 	if (cpu == this_cpu) {
 		local_irq_save(flags);
-		data->func(data->info);
+		csd->func(csd->info);
 		local_irq_restore(flags);
 	} else {
-		csd_lock(data);
-		generic_exec_single(cpu, data, wait);
+		csd_lock(csd);
+		generic_exec_single(cpu, csd, wait);
 	}
 	put_cpu();
 }
@@ -364,7 +364,7 @@ void __smp_call_function_single(int cpu,
 void smp_call_function_many(const struct cpumask *mask,
 			    smp_call_func_t func, void *info, bool wait)
 {
-	struct call_function_data *data;
+	struct call_function_data *cfd;
 	int cpu, next_cpu, this_cpu = smp_processor_id();
 
 	/*
@@ -396,21 +396,21 @@ void smp_call_function_many(const struct
 		return;
 	}
 
-	data = &__get_cpu_var(cfd_data);
+	cfd = &__get_cpu_var(cfd_data);
 
-	cpumask_and(data->cpumask, mask, cpu_online_mask);
-	cpumask_clear_cpu(this_cpu, data->cpumask);
+	cpumask_and(cfd->cpumask, mask, cpu_online_mask);
+	cpumask_clear_cpu(this_cpu, cfd->cpumask);
 
 	/* Some callers race with other cpus changing the passed mask */
-	if (unlikely(!cpumask_weight(data->cpumask)))
+	if (unlikely(!cpumask_weight(cfd->cpumask)))
 		return;
 
-	for_each_cpu(cpu, data->cpumask) {
-		struct call_single_data *csd = per_cpu_ptr(data->csd, cpu);
-		struct call_single_queue *dst =
-					&per_cpu(call_single_queue, cpu);
+	for_each_cpu(cpu, cfd->cpumask) {
+		struct call_single_data *csd = per_cpu_ptr(cfd->csd, cpu);
+		struct call_single_queue *dst;
 		unsigned long flags;
 
+		dst = &per_cpu(call_single_queue, cpu);
 		csd_lock(csd);
 		csd->func = func;
 		csd->info = info;
@@ -421,12 +421,13 @@ void smp_call_function_many(const struct
 	}
 
 	/* Send a message to all CPUs in the map */
-	arch_send_call_function_ipi_mask(data->cpumask);
+	arch_send_call_function_ipi_mask(cfd->cpumask);
 
 	if (wait) {
-		for_each_cpu(cpu, data->cpumask) {
-			struct call_single_data *csd =
-					per_cpu_ptr(data->csd, cpu);
+		for_each_cpu(cpu, cfd->cpumask) {
+			struct call_single_data *csd;
+
+			csd = per_cpu_ptr(cfd->csd, cpu);
 			csd_lock_wait(csd);
 		}
 	}
_

