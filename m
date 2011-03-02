Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab1CBBvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 20:51:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54668 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757768Ab1CBBvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 20:51:42 -0500
Message-ID: <4D6DA2F2.5080100@cn.fujitsu.com>
Date: Wed, 02 Mar 2011 09:52:50 +0800
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
References: <20110223013917.GA20996@linux.vnet.ibm.com> <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com> <4D6765B6.1030401@cn.fujitsu.com> <20110225203219.GD2269@linux.vnet.ibm.com> <4D6B16A8.4050405@cn.fujitsu.com> <20110228235136.GC2331@linux.vnet.ibm.com>
In-Reply-To: <20110228235136.GC2331@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-02 09:50:30,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-02 09:50:32,
	Serialize complete at 2011-03-02 09:50:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 07:51 AM, Paul E. McKenney wrote:
> On Mon, Feb 28, 2011 at 11:29:44AM +0800, Lai Jiangshan wrote:
>> On 02/26/2011 04:32 AM, Paul E. McKenney wrote:
>>>>> +/*
>>>>> + * Handle cases where the rcu_cpu_kthread() ends up on the wrong CPU.
>>>>> + * This can happen while the corresponding CPU is either coming online
>>>>> + * or going offline.  We cannot wait until the CPU is fully online
>>>>> + * before starting the kthread, because the various notifier functions
>>>>> + * can wait for RCU grace periods.  So we park rcu_cpu_kthread() until
>>>>> + * the corresponding CPU is online.
>>>>> + *
>>>>> + * Return 1 if the kthread needs to stop, 0 otherwise.
>>>>> + *
>>>>> + * Caller must disable bh.  This function can momentarily enable it.
>>>>> + */
>>>>> +static int rcu_cpu_kthread_should_stop(int cpu)
>>>>> +{
>>>>> +	while (cpu_is_offline(cpu) || smp_processor_id() != cpu) {
>>>>> +		if (kthread_should_stop())
>>>>> +			return 1;
>>>>> +		local_bh_enable();
>>>>> +		schedule_timeout_uninterruptible(1);
>>>>> +		if (smp_processor_id() != cpu)
>>>>> +			set_cpus_allowed_ptr(current, cpumask_of(cpu));
>>>>
>>>> The current task is PF_THREAD_BOUND,
>>>> Why do "set_cpus_allowed_ptr(current, cpumask_of(cpu));" ?
>>>
>>> Because I have seen CPU hotplug operations unbind PF_THREAD_BOUND threads.
>>> In addition, I end up having to spawn the kthread at CPU_UP_PREPARE time,
>>> at which point the thread must run unbound because its CPU isn't online
>>> yet.  I cannot invoke kthread_create() within the stop-machine handler
>>> (right?).  I cannot wait until CPU_ONLINE time because that results in
>>> hangs when other CPU notifiers wait for grace periods.
>>>
>>> Yes, I did find out about the hangs the hard way.  Why do you ask?  ;-)
>>
>> The current task is PF_THREAD_BOUND, "set_cpus_allowed_ptr(current, cpumask_of(cpu))"
>> will do nothing even it runs on the wrong CPU.
> 
> You lost me on this one.
> 
> Looking at set_cpus_allowed_ptr()...
> 
> The "again" loop won't happen because the task is already running.
> The CPU is online, so the cpumask_intersects() check won't kick
> us out.  We are working with the current task, so the check for
> PF_THREAD_BOUND, current, and cpumask_equal() won't kick us out.
> If the old and new cpumasks had been the same, we would not have called
> set_cpus_allowed_ptr() in the first place.  So we should get to
> the call to migrate_task().
> 
> What am I missing here?

You right. I forgot current tasks can change its cpumask even PF_THREAD_BOUND.
