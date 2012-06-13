Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2FMSdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:33:18 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:36124 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2FMSdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:33:16 -0400
Date: Wed, 13 Jun 2012 11:33:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
Message-ID: <20120613183301.GE2427@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120613102823.373180763@linutronix.de>
 <20120613105815.206105518@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613105815.206105518@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061318-7408-0000-0000-000005D32F67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 11:00:54AM -0000, Thomas Gleixner wrote:
> Provide a generic interface for setting up and tearing down percpu
> threads.
> 
> On registration the threads for already online cpus are created and
> started. On deregistration (modules) the threads are stoppped.
> 
> During hotplug operations the threads are created, started, parked and
> unparked. The datastructure for registration provides a pointer to
> percpu storage space and optional setup, cleanup, park, unpark
> functions. These functions are called when the thread state changes.
> 
> Thread functions should look like the following:
> 
> int thread_fn(void *cookie)
> {
> 	while (!smpboot_thread_check_parking(cookie)) {
> 		do_stuff();
> 	}
> 	return 0;
> }

Very cool!!!

So I am currently trying to apply this to RCU's per-CPU kthread.
I don't believe that I need to mess with RCU's per-rcu_node kthread
because it can just have its affinity adjusted when the first CPU
onlines and the last CPU offlines for the corresponding rcu_node.

One question below about the order of parking.

Also, I have not yet figured out how this avoids a parked thread waking
up while the CPU is offline, but I am probably still missing something.

							Thanx, Paul

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/smpboot.h |   40 +++++++++
>  kernel/cpu.c            |    6 +
>  kernel/smpboot.c        |  205 ++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/smpboot.h        |    4 
>  4 files changed, 255 insertions(+)
> 
> Index: tip/include/linux/smpboot.h
> ===================================================================
> --- /dev/null
> +++ tip/include/linux/smpboot.h
> @@ -0,0 +1,40 @@
> +#ifndef _LINUX_SMPBOOT_H
> +#define _LINUX_SMPBOOT_H
> +
> +#include <linux/types.h>
> +
> +struct task_struct;
> +/* Cookie handed to the thread_fn*/
> +struct smpboot_thread_data;
> +
> +/**
> + * struct smp_hotplug_thread - CPU hotplug related thread descriptor
> + * @store:		Pointer to per cpu storage for the task pointers
> + * @list:		List head for core management
> + * @thread_fn:		The associated thread function
> + * @setup:		Optional setup function, called when the thread gets
> + *			operational the first time
> + * @cleanup:		Optional cleanup function, called when the thread
> + *			should stop (module exit)
> + * @park:		Optional park function, called when the thread is
> + *			parked (cpu offline)
> + * @unpark:		Optional unpark function, called when the thread is
> + *			unparked (cpu online)
> + * @thread_comm:	The base name of the thread
> + */
> +struct smp_hotplug_thread {
> +	struct task_struct __percpu	**store;
> +	struct list_head		list;
> +	int				(*thread_fn)(void *data);
> +	void				(*setup)(unsigned int cpu);
> +	void				(*cleanup)(unsigned int cpu, bool online);
> +	void				(*park)(unsigned int cpu);
> +	void				(*unpark)(unsigned int cpu);
> +	const char			*thread_comm;
> +};
> +
> +int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread);
> +void smpboot_unregister_percpu_thread(struct smp_hotplug_thread *plug_thread);
> +int smpboot_thread_check_parking(struct smpboot_thread_data *td);
> +
> +#endif
> Index: tip/kernel/cpu.c
> ===================================================================
> --- tip.orig/kernel/cpu.c
> +++ tip/kernel/cpu.c
> @@ -280,6 +280,7 @@ static int __ref _cpu_down(unsigned int 
>  				__func__, cpu);
>  		goto out_release;
>  	}
> +	smpboot_park_threads(cpu);
> 
>  	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
>  	if (err) {
> @@ -354,6 +355,10 @@ static int __cpuinit _cpu_up(unsigned in
>  		goto out;
>  	}
> 
> +	ret = smpboot_create_threads(cpu);
> +	if (ret)
> +		goto out;
> +
>  	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
>  	if (ret) {
>  		nr_calls--;
> @@ -370,6 +375,7 @@ static int __cpuinit _cpu_up(unsigned in
> 
>  	/* Now call notifier in preparation. */
>  	cpu_notify(CPU_ONLINE | mod, hcpu);
> +	smpboot_unpark_threads(cpu);
> 
>  out_notify:
>  	if (ret != 0)
> Index: tip/kernel/smpboot.c
> ===================================================================
> --- tip.orig/kernel/smpboot.c
> +++ tip/kernel/smpboot.c
> @@ -1,11 +1,17 @@
>  /*
>   * Common SMP CPU bringup/teardown functions
>   */
> +#include <linux/cpu.h>
>  #include <linux/err.h>
>  #include <linux/smp.h>
>  #include <linux/init.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
>  #include <linux/sched.h>
> +#include <linux/export.h>
>  #include <linux/percpu.h>
> +#include <linux/kthread.h>
> +#include <linux/smpboot.h>
> 
>  #include "smpboot.h"
> 
> @@ -65,3 +71,202 @@ void __init idle_threads_init(void)
>  	}
>  }
>  #endif
> +
> +static LIST_HEAD(hotplug_threads);
> +static DEFINE_MUTEX(smpboot_threads_lock);
> +
> +struct smpboot_thread_data {
> +	unsigned int			cpu;
> +	unsigned int			status;
> +	struct smp_hotplug_thread	*ht;
> +};
> +
> +enum {
> +	HP_THREAD_NONE = 0,
> +	HP_THREAD_ACTIVE,
> +	HP_THREAD_PARKED,
> +};
> +
> +/**
> + * smpboot_thread_check_parking - percpu hotplug thread loop function
> + * @td:		thread data pointer
> + *
> + * Checks for thread stop and park conditions. Calls the necessary
> + * setup, cleanup, park and unpark functions for the registered
> + * thread.
> + *
> + * Returns 1 when the thread should exit, 0 otherwise.
> + */
> +int smpboot_thread_check_parking(struct smpboot_thread_data *td)
> +{
> +	struct smp_hotplug_thread *ht = td->ht;
> +
> +again:
> +	if (kthread_should_stop()) {
> +		if (ht->cleanup)
> +			ht->cleanup(td->cpu, cpu_online(td->cpu));
> +		kfree(td);
> +		return 1;
> +	}
> +
> +	BUG_ON(td->cpu != smp_processor_id());
> +
> +	if (kthread_should_park()) {
> +		if (ht->park && td->status == HP_THREAD_ACTIVE) {
> +			ht->park(td->cpu);
> +			td->status = HP_THREAD_PARKED;
> +		}
> +		kthread_parkme();
> +		/* We might have been woken for stop */
> +		goto again;
> +	}
> +
> +	switch (td->status) {
> +	case HP_THREAD_NONE:
> +		if (ht->setup)
> +			ht->setup(td->cpu);
> +		td->status = HP_THREAD_ACTIVE;
> +		break;
> +	case HP_THREAD_PARKED:
> +		if (ht->unpark)
> +			ht->unpark(td->cpu);
> +		td->status = HP_THREAD_ACTIVE;
> +		break;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(smpboot_thread_check_parking);
> +
> +static int
> +__smpboot_create_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
> +{
> +	struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
> +	struct smpboot_thread_data *td;
> +
> +	if (tsk)
> +		return 0;
> +
> +	td = kzalloc_node(sizeof(*td), GFP_KERNEL, cpu_to_node(cpu));
> +	if (!td)
> +		return -ENOMEM;
> +	td->cpu = cpu;
> +	td->ht = ht;
> +
> +	tsk = kthread_create_on_cpu(ht->thread_fn, td, cpu, ht->thread_comm);
> +	if (IS_ERR(tsk))
> +		return PTR_ERR(tsk);
> +
> +	get_task_struct(tsk);
> +	*per_cpu_ptr(ht->store, cpu) = tsk;
> +	return 0;
> +}
> +
> +int smpboot_create_threads(unsigned int cpu)
> +{
> +	struct smp_hotplug_thread *cur;
> +	int ret = 0;
> +
> +	mutex_lock(&smpboot_threads_lock);
> +	list_for_each_entry(cur, &hotplug_threads, list) {
> +		ret = __smpboot_create_thread(cur, cpu);
> +		if (ret)
> +			break;
> +	}
> +	mutex_unlock(&smpboot_threads_lock);
> +	return ret;
> +}
> +
> +static void smpboot_unpark_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
> +{
> +	struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
> +
> +	kthread_unpark(tsk);
> +}
> +
> +void smpboot_unpark_threads(unsigned int cpu)
> +{
> +	struct smp_hotplug_thread *cur;
> +
> +	mutex_lock(&smpboot_threads_lock);
> +	list_for_each_entry(cur, &hotplug_threads, list)
> +		smpboot_unpark_thread(cur, cpu);
> +	mutex_unlock(&smpboot_threads_lock);
> +}
> +
> +static void smpboot_park_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
> +{
> +	struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
> +
> +	if (tsk)
> +		kthread_park(tsk);
> +}
> +
> +void smpboot_park_threads(unsigned int cpu)
> +{
> +	struct smp_hotplug_thread *cur;
> +
> +	mutex_lock(&smpboot_threads_lock);
> +	list_for_each_entry(cur, &hotplug_threads, list)

Shouldn't this be list_for_each_entry_reverse()?  Yes, the notifiers
still run in the same order for both online and offline, but all uses
of smpboot_park_threads() would be new, so should be OK with the
proper ordering, right?

> +		smpboot_park_thread(cur, cpu);
> +	mutex_unlock(&smpboot_threads_lock);
> +}
> +
> +static void smpboot_destroy_threads(struct smp_hotplug_thread *ht)
> +{
> +	unsigned int cpu;
> +
> +	/* We need to destroy also the parked threads of offline cpus */
> +	for_each_possible_cpu(cpu) {
> +		struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
> +
> +		if (tsk) {
> +			kthread_stop(tsk);
> +			put_task_struct(tsk);
> +			*per_cpu_ptr(ht->store, cpu) = NULL;
> +		}
> +	}
> +}
> +
> +/**
> + * smpboot_register_percpu_thread - Register a per_cpu thread related to hotplug
> + * @plug_thread:	Hotplug thread descriptor
> + *
> + * Creates and starts the threads on all online cpus.
> + */
> +int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
> +{
> +	unsigned int cpu;
> +	int ret = 0;
> +
> +	mutex_lock(&smpboot_threads_lock);
> +	for_each_online_cpu(cpu) {
> +		ret = __smpboot_create_thread(plug_thread, cpu);
> +		if (ret) {
> +			smpboot_destroy_threads(plug_thread);
> +			goto out;
> +		}
> +		smpboot_unpark_thread(plug_thread, cpu);
> +	}
> +	list_add(&plug_thread->list, &hotplug_threads);
> +out:
> +	mutex_unlock(&smpboot_threads_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(smpboot_register_percpu_thread);
> +
> +/**
> + * smpboot_unregister_percpu_thread - Unregister a per_cpu thread related to hotplug
> + * @plug_thread:	Hotplug thread descriptor
> + *
> + * Stops all threads on all possible cpus.
> + */
> +void smpboot_unregister_percpu_thread(struct smp_hotplug_thread *plug_thread)
> +{
> +	get_online_cpus();
> +	mutex_lock(&smpboot_threads_lock);
> +	list_del(&plug_thread->list);
> +	smpboot_destroy_threads(plug_thread);
> +	mutex_unlock(&smpboot_threads_lock);
> +	put_online_cpus();
> +}
> +EXPORT_SYMBOL_GPL(smpboot_unregister_percpu_thread);
> Index: tip/kernel/smpboot.h
> ===================================================================
> --- tip.orig/kernel/smpboot.h
> +++ tip/kernel/smpboot.h
> @@ -13,4 +13,8 @@ static inline void idle_thread_set_boot_
>  static inline void idle_threads_init(void) { }
>  #endif
> 
> +int smpboot_create_threads(unsigned int cpu);
> +void smpboot_park_threads(unsigned int cpu);
> +void smpboot_unpark_threads(unsigned int cpu);
> +
>  #endif
> 
> 

