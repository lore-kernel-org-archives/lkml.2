Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab2I1IKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:10:48 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59576 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092Ab2I1IKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:10:34 -0400
X-AuditID: b753bd60-932c5ba0000047ca-bd-50655b77f0c2
X-AuditID: b753bd60-932c5ba0000047ca-bd-50655b77f0c2
Message-ID: <50655B8E.4060403@hitachi.com>
Date: Fri, 28 Sep 2012 17:10:54 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com, avi@redhat.com, mtosatti@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: Re: [RFC v2 PATCH 04/21] x86: Avoid RCU warnings on slave
 CPUs
References: <20120906112718.13320.8231.stgit@kvmdev> <20120906112739.13320.53090.stgit@kvmdev> <20120920173419.GH2449@linux.vnet.ibm.com>
In-Reply-To: <20120920173419.GH2449@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Thank you for your comments, and sorry for my late reply.

On 2012/09/21 2:34, Paul E. McKenney wrote:

> On Thu, Sep 06, 2012 at 08:27:40PM +0900, Tomoki Sekiyama wrote:
>> Initialize rcu related variables to avoid warnings about RCU usage while
>> slave CPUs is running specified functions. Also notify RCU subsystem before
>> the slave CPU is entered into idle state.
> 
> Hello, Tomoki,
> 
> A few questions and comments interspersed below.
>> <snip>
>> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>> index e8cfe377..45dfc1d 100644
>> --- a/arch/x86/kernel/smpboot.c
>> +++ b/arch/x86/kernel/smpboot.c
>> @@ -382,6 +382,8 @@ notrace static void __cpuinit start_slave_cpu(void *unused)
>>  		f = per_cpu(slave_cpu_func, cpu);
>>  		per_cpu(slave_cpu_func, cpu).func = NULL;
>>
>> +		rcu_note_context_switch(cpu);
>> +
> 
> Why not use rcu_idle_enter() and rcu_idle_exit()?  These would tell
> RCU to ignore the slave CPU for the duration of its idle period.
> The way you have it, if a slave CPU stayed idle for too long, you
> would get RCU CPU stall warnings, and possibly system hangs as well. 

That's true, rcu_idle_enter() and rcu_idle_exit() should be used when
the slave cpu is idle. Thanks.

> Or is this being called from some task that is not the idle task?
> If so, you instead want the new rcu_user_enter() and rcu_user_exit()
> that are hopefully on their way into 3.7.  Or maybe better, use a real
> idle task, so that idle_task(smp_processor_id()) returns true and RCU
> stops complaining.  ;-)
>
> Note that CPUs that RCU believes to be idle are not permitted to contain
> RCU read-side critical sections, which in turn means no entering the
> scheduler, no sleeping, and so on.  There is an RCU_NONIDLE() macro
> to tell RCU to pay attention to the CPU only for the duration of the
> statement passed to RCU_NONIDLE, and there are also an _rcuidle variant
> of the tracing statement to allow tracing from idle. 

This was for KVM is called as `func', which contains RCU read-side critical
sections, and rcu_virt_note_context_switch() (that is
rcu_note_context_switch(cpu)) before entering guest.
Maybe it should be replaced by rcu_user_enter() and rcu_user_exit() in the
future.

>> --- a/kernel/rcutree.c
>> +++ b/kernel/rcutree.c
>> @@ -2589,6 +2589,9 @@ static int __cpuinit rcu_cpu_notify(struc tnotifier_block *self,
>>  	switch (action) {
>>  	case CPU_UP_PREPARE:
>>  	case CPU_UP_PREPARE_FROZEN:
>> +#ifdef CONFIG_SLAVE_CPU
>> +	case CPU_SLAVE_UP_PREPARE:
>> +#endif
> 
> Why do you need #ifdef here?  Why not define CPU_SLAVE_UP_PREPARE
> unconditionally?  Then if CONFIG_SLAVE_CPU=n, rcu_cpu_notify() would
> never be invoked with CPU_SLAVE_UP_PREPARE, so no problems. 

Agreed. That will make the code simpler.

Thank you again,
-- 
Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory

