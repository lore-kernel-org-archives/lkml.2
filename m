Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab0DESkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 14:40:43 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:55406 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab0DESkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 14:40:37 -0400
Date: Mon, 5 Apr 2010 11:38:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: mingo@elte.hu, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       Nick Piggin <npiggin@suse.de>, Chris Friesen <cfriesen@nortel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce sys_membarrier(): process-wide memory barrier
 (v10)
Message-Id: <20100405113837.e475db7b.randy.dunlap@oracle.com>
In-Reply-To: <20100405175736.GA12656@Krystal>
References: <20100405175736.GA12656@Krystal>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BBA2E3C.00E6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Apr 2010 13:57:37 -0400 Mathieu Desnoyers wrote:

> [ The last RFC submission got no reply, so I am submitting for real now, hoping
> to hear something else than the sound of "crickets" (yeah, it's unsually warm in
> Montreal for this time of the year). The only objections that remain are style
> issues pointed out by Ingo. These are answered below. ]
> 

more chirping.

...

> This patch applies on top of -tip based on 2.6.34-rc3.
> 
> Here is an implementation of a new system call, sys_membarrier(), which
> executes a memory barrier on all threads of the current process. It can be used
> to distribute the cost of user-space memory barriers asymmetrically by
> transforming pairs of memory barriers into pairs consisting of sys_membarrier()
> and a compiler barrier. For synchronization primitives that distinguish between
> read-side and write-side (e.g. userspace RCU, rwlocks), the read-side can be
> accelerated significantly by moving the bulk of the memory barrier overhead to
> the write-side.
>  
> The first user of this system call is the "liburcu" Userspace RCU implementation
> found at http://lttng.org/urcu. It aims at greatly simplifying and enhancing the
> current implementation, which uses a scheme similar to the sys_membarrier(), but
> based on signals sent to each reader thread.

and what uses liburcu?

> This patch mostly sits in kernel/sched.c (it needs to access struct rq). It is
> based on kernel v2.6.34-rc3, and also applies fine to tip/master . I am
> proposing it for merge for 2.6.35. I think the -tip tree would be the right one
> to pick up this patch, as it touches sched.c.
> 
...

> 
> This patch only adds the system calls to x86 32/64. See the sys_membarrier()
> comments for memory barriers requirement in switch_mm() to port to other
> architectures.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> CC: Nicholas Miell <nmiell@comcast.net>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: mingo@elte.hu
> CC: laijs@cn.fujitsu.com
> CC: dipankar@in.ibm.com
> CC: akpm@linux-foundation.org
> CC: josh@joshtriplett.org
> CC: dvhltc@us.ibm.com
> CC: niv@us.ibm.com
> CC: tglx@linutronix.de
> CC: peterz@infradead.org
> CC: Valdis.Kletnieks@vt.edu
> CC: dhowells@redhat.com
> CC: Nick Piggin <npiggin@suse.de>
> CC: Chris Friesen <cfriesen@nortel.com>
> ---
>  arch/x86/ia32/ia32entry.S          |    1 
>  arch/x86/include/asm/mmu_context.h |   28 ++++-
>  arch/x86/include/asm/unistd_32.h   |    3 
>  arch/x86/include/asm/unistd_64.h   |    2 
>  arch/x86/kernel/syscall_table_32.S |    1 
>  include/linux/Kbuild               |    1 
>  include/linux/membarrier.h         |   47 ++++++++
>  kernel/sched.c                     |  194 +++++++++++++++++++++++++++++++++++++
>  8 files changed, 274 insertions(+), 3 deletions(-)
> 
> Index: linux.trees.git/arch/x86/include/asm/unistd_64.h
> ===================================================================
> --- linux.trees.git.orig/arch/x86/include/asm/unistd_64.h	2010-03-30 09:48:03.000000000 -0400
> +++ linux.trees.git/arch/x86/include/asm/unistd_64.h	2010-04-05 13:46:16.000000000 -0400
> @@ -663,6 +663,8 @@ __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt
>  __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
>  #define __NR_recvmmsg				299
>  __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
> +#define __NR_membarrier				300
> +__SYSCALL(__NR_membarrier, sys_membarrier)
>  
>  #ifndef __NO_STUBS
>  #define __ARCH_WANT_OLD_READDIR
> Index: linux.trees.git/kernel/sched.c
> ===================================================================
> --- linux.trees.git.orig/kernel/sched.c	2010-04-05 13:45:52.000000000 -0400
> +++ linux.trees.git/kernel/sched.c	2010-04-05 13:53:49.000000000 -0400
> @@ -71,6 +71,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/ctype.h>
>  #include <linux/ftrace.h>
> +#include <linux/membarrier.h>
>  
>  #include <asm/tlb.h>
>  #include <asm/irq_regs.h>
> @@ -8951,6 +8952,199 @@ struct cgroup_subsys cpuacct_subsys = {
>  };
>  #endif	/* CONFIG_CGROUP_CPUACCT */
>  
> +#ifdef CONFIG_SMP
> +
> +/*
> + * Execute a memory barrier on all active threads from the current process
> + * on SMP systems. Do not rely on implicit barriers in IPI handler execution,
> + * because batched IPI lists are synchronized with spinlocks rather than full
> + * memory barriers. This is not the bulk of the overhead anyway, so let's stay
> + * on the safe side.
> + */
> +static void membarrier_ipi(void *unused)
> +{
> +	smp_mb();
> +}
> +
> +/*
> + * Handle out-of-mem by sending per-cpu IPIs instead.
> + */
> +static void membarrier_retry(void)
> +{
> +	struct mm_struct *mm;
> +	int cpu;
> +
> +	for_each_cpu(cpu, mm_cpumask(current->mm)) {
> +		raw_spin_lock_irq(&cpu_rq(cpu)->lock);
> +		mm = cpu_curr(cpu)->mm;
> +		raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
> +		if (current->mm == mm)
> +			smp_call_function_single(cpu, membarrier_ipi, NULL, 1);
> +	}
> +}
> +
> +/*
> + * sys_membarrier - issue memory barrier on current process running threads
> + * @flags: One of these must be set:
> + *         MEMBARRIER_EXPEDITED
> + *             Adds some overhead, fast execution (few microseconds)
> + *         MEMBARRIER_DELAYED
> + *             Low overhead, but slow execution (few milliseconds)
> + *
> + *         MEMBARRIER_QUERY
> + *           This optional flag can be set to query if the kernel supports
> + *           a set of flags.
> + *
> + * return values: Returns -EINVAL if the flags are incorrect. Testing for kernel
> + * sys_membarrier support can be done by checking for -ENOSYS return value.
> + * Return values >= 0 indicate success. For a given set of flags on a given
> + * kernel, this system call will always return the same value. It is therefore
> + * correct to check the return value only once at library load, passing the

library load assumes caller is a library?  does the kernel care about that?


> + * MEMBARRIER_QUERY flag in addition to only check if the flags are supported,
> + * without performing any synchronization.
> + *
> + * This system call executes a memory barrier on all running threads of the
> + * current process. Upon completion, the caller thread is ensured that all
> + * process threads have passed through a state where all memory accesses to
> + * user-space addresses match program order. (non-running threads are de facto
> + * in such a state)

                state.)

> + *
> + * Using the non-expedited mode is recommended for applications which can
> + * afford leaving the caller thread waiting for a few milliseconds. A good
> + * example would be a thread dedicated to execute RCU callbacks, which waits
> + * for callbacks to enqueue most of the time anyway.
> + *
> + * The expedited mode is recommended whenever the application needs to have
> + * control returning to the caller thread as quickly as possible. An example
> + * of such application would be one which uses the same thread to perform
> + * data structure updates and issue the RCU synchronization.
> + *
> + * It is perfectly safe to call both expedited and non-expedited
> + * sys_membarrier() in a process.
> + *
> + * mm_cpumask is used as an approximation of the processors which run threads
> + * belonging to the current process. It is a superset of the cpumask to which we
> + * must send IPIs, mainly due to lazy TLB shootdown. Therefore, for each CPU in
> + * the mm_cpumask, we check each runqueue with the rq lock held to make sure our
> + * ->mm is indeed running on them. The rq lock ensures that a memory barrier is
> + * issued each time the rq current task is changed. This reduces the risk of
> + * disturbing a RT task by sending unnecessary IPIs. There is still a slight
> + * chance to disturb an unrelated task, because we do not lock the runqueues
> + * while sending IPIs, but the real-time effect of this heavy locking would be
> + * worse than the comparatively small disruption of an IPI.
> + *
> + * RED PEN: before assinging a system call number for sys_membarrier() to an

                      assigning

> + * architecture, we must ensure that switch_mm issues full memory barriers
> + * (or a synchronizing instruction having the same effect) between:
> + * - memory accesses to user-space addresses and clear mm_cpumask.
> + * - set mm_cpumask and memory accesses to user-space addresses.
> + *
> + * The reason why these memory barriers are required is that mm_cpumask updates,
> + * as well as iteration on the mm_cpumask, offer no ordering guarantees.
> + * These added memory barriers ensure that any thread modifying the mm_cpumask
> + * is in a state where all memory accesses to user-space addresses are
> + * guaranteed to be in program order.
> + *
> + * In some case adding a comment to this effect will suffice, in others we
> + * will need to add smp_mb__before_clear_bit()/smp_mb__after_clear_bit() or
> + * simply smp_mb(). These barriers are required to ensure we do not _miss_ a
> + * CPU that need to receive an IPI, which would be a bug.
> + *
> + * On uniprocessor systems, this system call simply returns 0 without doing
> + * anything, so user-space knows it is implemented.
> + *
> + * The flags argument has room for extensibility, with 16 lower bits holding
> + * mandatory flags for which older kernels will fail if they encounter an
> + * unknown flag. The high 16 bits are used for optional flags, which older
> + * kernels don't have to care about.
> + *
> + * This synchronization only takes care of threads using the current process
> + * memory map. It should not be used to synchronize accesses performed on memory
> + * maps shared between different processes.
> + */
> +SYSCALL_DEFINE1(membarrier, unsigned int, flags)
> +{
> +	struct mm_struct *mm;
> +	cpumask_var_t tmpmask;
> +	int cpu;
> +
> +	/*
> +	 * Expect _only_ one of expedited or delayed flags.
> +	 * Don't care about optional mask for now.
> +	 */
> +	switch (flags & MEMBARRIER_MANDATORY_MASK) {
> +	case MEMBARRIER_EXPEDITED:
> +	case MEMBARRIER_DELAYED:
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	if (unlikely(flags & MEMBARRIER_QUERY
> +		     || thread_group_empty(current))
> +		     || num_online_cpus() == 1)
> +		return 0;
> +	if (flags & MEMBARRIER_DELAYED) {
> +		synchronize_sched();
> +		return 0;
> +	}
> +	/*
> +	 * Memory barrier on the caller thread between previous memory accesses
> +	 * to user-space addresses and sending memory-barrier IPIs. Orders all
> +	 * user-space address memory accesses prior to sys_membarrier() before
> +	 * mm_cpumask read and membarrier_ipi executions. This barrier is paired
> +	 * with memory barriers in:
> +	 * - membarrier_ipi() (for each running threads of the current process)
> +	 * - switch_mm() (ordering scheduler mm_cpumask update wrt memory
> +	 *                accesses to user-space addresses)
> +	 * - Each CPU ->mm update performed with rq lock held by the scheduler.
> +	 *   A memory barrier is issued each time ->mm is changed while the rq
> +	 *   lock is held.
> +	 */
> +	smp_mb();
> +	if (!alloc_cpumask_var(&tmpmask, GFP_NOWAIT)) {
> +		membarrier_retry();
> +		goto out;
> +	}
> +	cpumask_copy(tmpmask, mm_cpumask(current->mm));
> +	preempt_disable();
> +	cpumask_clear_cpu(smp_processor_id(), tmpmask);
> +	for_each_cpu(cpu, tmpmask) {
> +		raw_spin_lock_irq(&cpu_rq(cpu)->lock);
> +		mm = cpu_curr(cpu)->mm;
> +		raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
> +		if (current->mm != mm)
> +			cpumask_clear_cpu(cpu, tmpmask);
> +	}
> +	smp_call_function_many(tmpmask, membarrier_ipi, NULL, 1);
> +	preempt_enable();
> +	free_cpumask_var(tmpmask);
> +out:
> +	/*
> +	 * Memory barrier on the caller thread between sending&waiting for

                                                       sending & waiting

> +	 * memory-barrier IPIs and following memory accesses to user-space
> +	 * addresses. Orders mm_cpumask read and membarrier_ipi executions
> +	 * before all user-space address memory accesses following
> +	 * sys_membarrier(). This barrier is paired with memory barriers in:
> +	 * - membarrier_ipi() (for each running threads of the current process)
> +	 * - switch_mm() (ordering scheduler mm_cpumask update wrt memory
> +	 *                accesses to user-space addresses)
> +	 * - Each CPU ->mm update performed with rq lock held by the scheduler.
> +	 *   A memory barrier is issued each time ->mm is changed while the rq
> +	 *   lock is held.
> +	 */
> +	smp_mb();
> +	return 0;
> +}
> +
> +#else /* #ifdef CONFIG_SMP */

I don't know that we have a known convention for that, but I would use:

#else /* not CONFIG_SMP */

or

#else /* !CONFIG_SMP */

> +
> +SYSCALL_DEFINE1(membarrier, unsigned int, flags)
> +{
> +	return 0;
> +}
> +
> +#endif /* #else #ifdef CONFIG_SMP */

and:

#endif /* CONFIG_SMP */

The "#else #ifdef" is both ugly and too wordy IMO.

> +
>  #ifndef CONFIG_SMP
>  
>  int rcu_expedited_torture_stats(char *page)


---
~Randy

