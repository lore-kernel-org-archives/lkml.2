Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab2CBHZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:25:24 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41728 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab2CBHZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:25:22 -0500
Message-ID: <4F5075D5.9090201@linux.vnet.ibm.com>
Date: Fri, 02 Mar 2012 12:55:09 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        "mingo@elte.hu" <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: [PATCH RT 3/9][RFC] [PATCH 3/9] lglock/rt: Use non-rt for_each_cpu()
 in -rt code
References: <20120301185527.064629423@goodmis.org> <20120301190345.374756214@goodmis.org>
In-Reply-To: <20120301190345.374756214@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12030122-3568-0000-0000-0000014DD2A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 12:25 AM, Steven Rostedt wrote:

> Currently the RT version of the lglocks() does a for_each_online_cpu()
> in the name##_global_lock_online() functions. Non-rt uses its own
> mask for this, and for good reason.
> 
> A task may grab a *_global_lock_online(), and in the mean time, one
> of the CPUs goes offline. Now when that task does a *_global_unlock_online()
> it releases all the locks *except* the one that went offline.
> 
> Now if that CPU were to come back on line, its lock is now owned by a
> task that never released it when it should have.
> 
> This causes all sorts of fun errors. Like owners of a lock no longer
> existing, or sleeping on IO, waiting to be woken up by a task that
> happens to be blocked on the lock it never released.
> 
> Convert the RT versions to use the lglock specific cpumasks. As once
> a CPU comes on line, the mask is set, and never cleared even when the
> CPU goes offline. The locks for that CPU will still be taken and released.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/lglock.h |   35 ++++++++++++++++++++++++++++++++---
>  1 files changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/lglock.h b/include/linux/lglock.h
> index 52b289f..cdfcef3 100644
> --- a/include/linux/lglock.h
> +++ b/include/linux/lglock.h
> @@ -203,9 +203,31 @@
>  #else /* !PREEMPT_RT_FULL */
>  #define DEFINE_LGLOCK(name)						\
>  									\
> - DEFINE_PER_CPU(struct rt_mutex, name##_lock);					\
> + DEFINE_PER_CPU(struct rt_mutex, name##_lock);				\
> + DEFINE_SPINLOCK(name##_cpu_lock);					\
> + cpumask_t name##_cpus __read_mostly;					\
>   DEFINE_LGLOCK_LOCKDEP(name);						\
>  									\
> + static int								\
> + name##_lg_cpu_callback(struct notifier_block *nb,			\
> +				unsigned long action, void *hcpu)	\
> + {									\
> +	switch (action & ~CPU_TASKS_FROZEN) {				\
> +	case CPU_UP_PREPARE:						\
> +		spin_lock(&name##_cpu_lock);				\
> +		cpu_set((unsigned long)hcpu, name##_cpus);		\
> +		spin_unlock(&name##_cpu_lock);				\
> +		break;							\
> +	case CPU_UP_CANCELED: case CPU_DEAD:				\
> +		spin_lock(&name##_cpu_lock);				\
> +		cpu_clear((unsigned long)hcpu, name##_cpus);		\
> +		spin_unlock(&name##_cpu_lock);				\
> +	}								\
> +	return NOTIFY_OK;						\
> + }									\
> + static struct notifier_block name##_lg_cpu_notifier = {		\
> +	.notifier_call = name##_lg_cpu_callback,			\
> + };									\
>   void name##_lock_init(void) {						\
>  	int i;								\
>  	LOCKDEP_INIT_MAP(&name##_lock_dep_map, #name, &name##_lock_key, 0); \
> @@ -214,6 +236,11 @@
>  		lock = &per_cpu(name##_lock, i);			\
>  		rt_mutex_init(lock);					\
>  	}								\
> +	register_hotcpu_notifier(&name##_lg_cpu_notifier);		\
> +	get_online_cpus();						\
> +	for_each_online_cpu(i)						\
> +		cpu_set(i, name##_cpus);				\


This can be further improved. We don't really need this loop. We can replace
it with:

cpumask_copy(&name##_cpus, cpu_online_mask);

(as pointed out by Ingo. See: https://lkml.org/lkml/2012/2/29/93 and
https://lkml.org/lkml/2012/2/29/153).

I will try sending a patch for this to non-RT after the numerous patches
currently flying around this code (in non-RT) settle down..


> +	put_online_cpus();						\
>   }									\
>   EXPORT_SYMBOL(name##_lock_init);					\
>  									\
> @@ -254,7 +281,8 @@
>   void name##_global_lock_online(void) {					\
>  	int i;								\
>  	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
> -	for_each_online_cpu(i) {					\
> +	spin_lock(&name##_cpu_lock);					\
> +	for_each_cpu(i, &name##_cpus) {					\
>  		struct rt_mutex *lock;					\
>  		lock = &per_cpu(name##_lock, i);			\
>  		__rt_spin_lock(lock);					\
> @@ -265,11 +293,12 @@
>   void name##_global_unlock_online(void) {				\
>  	int i;								\
>  	rwlock_release(&name##_lock_dep_map, 1, _RET_IP_);		\
> -	for_each_online_cpu(i) {					\
> +	for_each_cpu(i, &name##_cpus) {					\
>  		struct rt_mutex *lock;					\
>  		lock = &per_cpu(name##_lock, i);			\
>  		__rt_spin_unlock(lock);					\
>  	}								\
> +	spin_unlock(&name##_cpu_lock);					\
>   }									\
>   EXPORT_SYMBOL(name##_global_unlock_online);				\
>  									\


Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

