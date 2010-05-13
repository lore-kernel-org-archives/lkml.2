Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab0EMHfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:35:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60810 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755514Ab0EMHfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:35:23 -0400
Message-ID: <4BEBAC0C.2060508@cn.fujitsu.com>
Date: Thu, 13 May 2010 15:36:44 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] cpuset,mm: make the write-side sleep if the read-side
 is not running
References: <4BEBA9A9.9080504@cn.fujitsu.com>
In-Reply-To: <4BEBA9A9.9080504@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this mail. I'm sorry for my mistake.

Thanks
Miao

on 2010-5-13 15:26, Miao Xie wrote:
> on 2010-5-12 12:32, Andrew Morton wrote:
>> On Wed, 12 May 2010 15:20:51 +0800 Miao Xie <miaox@cn.fujitsu.com> wrote:
>>
>>> @@ -985,6 +984,7 @@ repeat:
>>>  	 * for the read-side.
>>>  	 */
>>>  	while (ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
>>> +		task_unlock(tsk);
>>>  		if (!task_curr(tsk))
>>>  			yield();
>>>  		goto repeat;
>>
>> Oh, I meant to mention that.  No yield()s, please.  Their duration is
>> highly unpredictable.  Can we do something more deterministic here?
> 
> 根据Andrew的指摘，我做了下面的patch，如果读端的进程处于内存分配过程中但不在运行，
> 则让负责修改tsk->mems_allowed的进程睡眠，等待读端结束内存分配操作。
> 
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index 457ed76..d348c47 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -117,7 +117,11 @@ static inline void put_mems_allowed(void)
>  	 * nodemask.
>  	 */
>  	smp_mb();
> -	--ACCESS_ONCE(current->mems_allowed_change_disable);
> +	if (!--ACCESS_ONCE(current->mems_allowed_change_disable)
> +	    && unlikely(current->mems_read_done)) {
> +		complete(current->mems_read_done);
> +		current->mems_read_done = NULL;
> +	}
>  }
>  
>  static inline void set_mems_allowed(nodemask_t nodemask)
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 66620fa..8699900 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1423,6 +1423,8 @@ struct task_struct {
>  #ifdef CONFIG_CPUSETS
>  	nodemask_t mems_allowed;	/* Protected by alloc_lock */
>  	int mems_allowed_change_disable;
> +	/* for changing mems_allowed and mempolicy */
> +	struct completion *mems_read_done;
>  	int cpuset_mem_spread_rotor;
>  	int cpuset_slab_spread_rotor;
>  #endif
> @@ -2525,6 +2527,12 @@ static inline void inc_syscw(struct task_struct *tsk)
>  extern void task_oncpu_function_call(struct task_struct *p,
>  				     void (*func) (void *info), void *info);
>  
> +/*
> + * Call the function if the target task is not executing right now
> + */
> +extern void task_notcurr_function_call(struct task_struct *p,
> +				     void (*func) (void *info), void *info);
> +
>  
>  #ifdef CONFIG_MM_OWNER
>  extern void mm_update_next_owner(struct mm_struct *mm);
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index d243a22..a471ab2 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -938,6 +938,20 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
>  	guarantee_online_mems(task_cs(tsk),&tsk->mems_allowed);
>  }
>  
> +struct cpuset_task_info {
> +	struct task_struct *tsk;
> +	struct completion done;
> +	int ret;
> +};
> +
> +void set_mems_read_done_for_task(void *_info)
> +{
> +	struct cpuset_task_info *info = _info;
> +
> +	info->tsk->mems_read_done = &info->done;
> +	info->ret = 1;
> +}
> +
>  /*
>   * cpuset_change_task_nodemask - change task's mems_allowed and mempolicy
>   * @tsk: the task to change
> @@ -950,6 +964,8 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
>  static void cpuset_change_task_nodemask(struct task_struct *tsk,
>  					nodemask_t *newmems)
>  {
> +	struct cpuset_task_info info;
> +
>  repeat:
>  	/*
>  	 * Allow tasks that have access to memory reserves because they have
> @@ -980,13 +996,23 @@ repeat:
>  	smp_mb();
>  
>  	/*
> -	 * Allocating of memory is very fast, we needn't sleep when waitting
> -	 * for the read-side.
> +	 * If the read-side is running, we needn't sleep when waiting for the
> +	 * read-side because allocating page is very fast.
>  	 */
>  	while (ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
>  		task_unlock(tsk);
> -		if (!task_curr(tsk))
> -			yield();
> +		if (!task_curr(tsk)) {
> +			info.tsk = tsk;
> +			init_completion(&info.done);
> +			info.ret = 0;
> +
> +			task_notcurr_function_call(tsk,
> +						   set_mems_read_done_for_task,
> +						   &info);
> +			if (info.ret)
> +				wait_for_completion(&info.done);
> +		} else
> +			cpu_relax();
>  		goto repeat;
>  	}
>  
> diff --git a/kernel/fork.c b/kernel/fork.c
> index f4f0951..76a6ec8 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1090,6 +1090,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  #ifdef CONFIG_CPUSETS
>  	p->cpuset_mem_spread_rotor = node_random(p->mems_allowed);
>  	p->cpuset_slab_spread_rotor = node_random(p->mems_allowed);
> +	p->mems_read_done = NULL;
>  #endif
>  #ifdef CONFIG_TRACE_IRQFLAGS
>  	p->irq_events = 0;
> diff --git a/kernel/sched.c b/kernel/sched.c
> index e298c71..f839f8f 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2217,6 +2217,35 @@ void task_oncpu_function_call(struct task_struct *p,
>  	preempt_enable();
>  }
>  
> +/**
> + * task_notcurr_function_call - call a function when a task isn't running
> + * @p:		the task to evaluate
> + * @func:	the function to be called
> + * @info:	the function call argument
> + *
> + * Calls the function @func when the task is not currently running.
> + */
> +void task_notcurr_function_call(struct task_struct *p,
> +			      void (*func) (void *info), void *info)
> +{
> +	struct rq *rq;
> +	unsigned long flags;
> +
> +	if (p == current)
> +		return;
> +
> +#ifdef CONFIG_SMP
> +	rq = task_rq_lock(p, &flags);
> +	if (!task_curr(p))
> +		func(info);
> +	task_rq_unlock(rq, &flags);
> +#else
> +	preempt_disable();
> +	func(info);
> +	preempt_enable();
> +#endif
> +}
> +
>  #ifdef CONFIG_SMP
>  /*
>   * ->cpus_allowed is protected by either TASK_WAKING or rq->lock held.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 


