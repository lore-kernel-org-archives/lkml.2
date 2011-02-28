Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab1B1D2l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 22:28:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62221 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab1B1D2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 22:28:40 -0500
Message-ID: <4D6B16A8.4050405@cn.fujitsu.com>
Date: Mon, 28 Feb 2011 11:29:44 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
References: <20110223013917.GA20996@linux.vnet.ibm.com> <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com> <4D6765B6.1030401@cn.fujitsu.com> <20110225203219.GD2269@linux.vnet.ibm.com>
In-Reply-To: <20110225203219.GD2269@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-28 11:27:30,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-28 11:27:32,
	Serialize complete at 2011-02-28 11:27:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2011 04:32 AM, Paul E. McKenney wrote:
>>> +/*
>>> + * Handle cases where the rcu_cpu_kthread() ends up on the wrong CPU.
>>> + * This can happen while the corresponding CPU is either coming online
>>> + * or going offline.  We cannot wait until the CPU is fully online
>>> + * before starting the kthread, because the various notifier functions
>>> + * can wait for RCU grace periods.  So we park rcu_cpu_kthread() until
>>> + * the corresponding CPU is online.
>>> + *
>>> + * Return 1 if the kthread needs to stop, 0 otherwise.
>>> + *
>>> + * Caller must disable bh.  This function can momentarily enable it.
>>> + */
>>> +static int rcu_cpu_kthread_should_stop(int cpu)
>>> +{
>>> +	while (cpu_is_offline(cpu) || smp_processor_id() != cpu) {
>>> +		if (kthread_should_stop())
>>> +			return 1;
>>> +		local_bh_enable();
>>> +		schedule_timeout_uninterruptible(1);
>>> +		if (smp_processor_id() != cpu)
>>> +			set_cpus_allowed_ptr(current, cpumask_of(cpu));
>>
>> The current task is PF_THREAD_BOUND,
>> Why do "set_cpus_allowed_ptr(current, cpumask_of(cpu));" ?
> 
> Because I have seen CPU hotplug operations unbind PF_THREAD_BOUND threads.
> In addition, I end up having to spawn the kthread at CPU_UP_PREPARE time,
> at which point the thread must run unbound because its CPU isn't online
> yet.  I cannot invoke kthread_create() within the stop-machine handler
> (right?).  I cannot wait until CPU_ONLINE time because that results in
> hangs when other CPU notifiers wait for grace periods.
> 
> Yes, I did find out about the hangs the hard way.  Why do you ask?  ;-)

The current task is PF_THREAD_BOUND, "set_cpus_allowed_ptr(current, cpumask_of(cpu))"
will do nothing even it runs on the wrong CPU.

If the task runs on the wrong CPU. We have no API to force/migrate the task
to the bound CPU when the cpu becomes online. But wake_up_process() has
a side affect that it will move a slept task to the correct online CPU.
"schedule_timeout_uninterruptible(1);" will call
wake_up_process() when timeout, so it will do all thing you need.

But "set_cpus_allowed_ptr(current, cpumask_of(cpu));" will do nothing.

The code is a little nasty I think. The proper solution I like:
set the rcu_cpu_notify a proper priority, and wake up the kthread
in the notifier.

Steven, any suggestion? I just known very little about scheduler.

> 
> Please feel free to suggest improvements in the header comment above
> for rcu_cpu_kthread_should_stop(), which is my apparently insufficient
> attempt to explain this.
> 
>>> +		local_bh_disable();
>>> +	}
>>> +	return 0;
>>> +}
>>> +
>>> +/*
>>> + * Per-CPU kernel thread that invokes RCU callbacks.  This replaces the
>>> + * earlier RCU softirq.
>>> + */
>>> +static int rcu_cpu_kthread(void *arg)
>>> +{
>>> +	int cpu = (int)(long)arg;
>>> +	unsigned long flags;
>>> +	int spincnt = 0;
>>> +	wait_queue_head_t *wqp = &per_cpu(rcu_cpu_wq, cpu);
>>> +	char work;
>>> +	char *workp = &per_cpu(rcu_cpu_has_work, cpu);
>>> +
>>> +	for (;;) {
>>> +		wait_event_interruptible(*wqp,
>>> +					 *workp != 0 || kthread_should_stop());
>>> +		local_bh_disable();
>>> +		if (rcu_cpu_kthread_should_stop(cpu)) {
>>> +			local_bh_enable();
>>> +			break;
>>> +		}
>>> +		local_irq_save(flags);
>>> +		work = *workp;
>>> +		*workp = 0;
>>> +		local_irq_restore(flags);
>>> +		if (work)
>>> +			rcu_process_callbacks();
>>> +		local_bh_enable();
>>> +		if (*workp != 0)
>>> +			spincnt++;
>>> +		else
>>> +			spincnt = 0;
>>> +		if (spincnt > 10) {
>>
>> "10" is a magic number here.
> 
> It is indeed.  Suggestions for a cpp macro name to hide it behind?
> 
>>> +			rcu_yield(cpu);
>>> +			spincnt = 0;
>>> +		}
>>> +	}
>>> +	return 0;
>>> +}
>>> +
>>
>>
>>> +/*
>>> + * Per-rcu_node kthread, which is in charge of waking up the per-CPU
>>> + * kthreads when needed.
>>> + */
>>> +static int rcu_node_kthread(void *arg)
>>> +{
>>> +	int cpu;
>>> +	unsigned long flags;
>>> +	unsigned long mask;
>>> +	struct rcu_node *rnp = (struct rcu_node *)arg;
>>> +	struct sched_param sp;
>>> +	struct task_struct *t;
>>> +
>>> +	for (;;) {
>>> +		wait_event_interruptible(rnp->node_wq, rnp->wakemask != 0 ||
>>> +						       kthread_should_stop());
>>> +		if (kthread_should_stop())
>>> +			break;
>>> +		raw_spin_lock_irqsave(&rnp->lock, flags);
>>> +		mask = rnp->wakemask;
>>> +		rnp->wakemask = 0;
>>> +		raw_spin_unlock_irqrestore(&rnp->lock, flags);
>>> +		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask <<= 1) {
>>> +			if ((mask & 0x1) == 0)
>>> +				continue;
>>> +			preempt_disable();
>>> +			per_cpu(rcu_cpu_has_work, cpu) = 1;
>>> +			t = per_cpu(rcu_cpu_kthread_task, cpu);
>>> +			if (t == NULL) {
>>> +				preempt_enable();
>>> +				continue;
>>> +			}
>>
>> Obviously preempt_disable() is not for protecting remote percpu data.
>> Is it for disabling cpu hotplug? I am afraid the @t may leave
>> and become invalid.
> 
> Indeed, acquiring the rnp->lock is safer, except that I don't trust
> calling sched_setscheduler_nocheck() in that state.  So I need to check
> for the CPU being online after the preempt_disable().  This means that
> I ignore requests to do work after CPU_DYING time, but that is OK because
> force_quiescent_state() will figure out that the CPU is in fact offline.
> 
> Make sense?
> 

Yes.

Another:

#if CONFIG_HOTPLUG_CPU
get_task_struct() when set bit in wakemask
put_task_struct() when clear bit in wakemask
#endif



> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

