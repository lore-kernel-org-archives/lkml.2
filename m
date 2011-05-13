Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab1EMJdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:33:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38894 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758684Ab1EMJdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:33:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DCCFB37.9040001@jp.fujitsu.com>
Date: Fri, 13 May 2011 18:34:47 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] cpuset: fix cpuset_cpus_allowed_fallback() don't
 update tsk->rt.nr_cpus_allowed
References: <20110428161149.GA15658@redhat.com>	<20110502194416.2D61.A69D9226@jp.fujitsu.com>	<20110502195657.2D68.A69D9226@jp.fujitsu.com>	<1305129929.2914.247.camel@laptop>	<4DCCC61F.80408@jp.fujitsu.com>	<BANLkTik_weiOC82uRKRamFan4QMi1u3s7g@mail.gmail.com>	<4DCCDEC5.3040201@jp.fujitsu.com> <BANLkTik38FinwfSJr5eS40-v6te6-3PR1w@mail.gmail.com>
In-Reply-To: <BANLkTik38FinwfSJr5eS40-v6te6-3PR1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/13 16:43), Yong Zhang wrote:
> On Fri, May 13, 2011 at 3:33 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com>  wrote:
>> Hello,
>>
>>>>>> (3) schedule() makes fallback and cpuset_cpus_allowed_fallback
>>>>>>      change task->cpus_allowed
>>>>>
>>>>> I'm failing to see how this is happening, surely that kthread isn't
>>>>> actually running that early?
>>>>
>>>> If my understand correctly, current call graph is below.
>>>>
>>>> kernel_init()
>>>>         smp_init();
>>>>                 cpu_up()
>>>>                         ... cpu hotplug notification
>>>>                                 kthread_create()
>>>>         sched_init_smp();
>>>>
>>>>
>>>> So, cpu hotplug event is happen before sched_init_smp(). The old rule is,
>>>> all kthreads of using cpu-up notification have to use kthread_bind(). It
>>>> protected from sched load balance.
>>>>
>>>> but, now cpuset_cpus_allowed_fallback() forcedly change kthread's
>>>> cpumask.
>>>> Why is this works? the point are two.
>>>>
>>>> - rcu_cpu_kthread_should_stop() call set_cpus_allowed_ptr() again
>>>> periodically.
>>>>   then, it can reset cpumask if cpuset_cpus_allowed_fallback() change it.
>>>>   my debug print obseve following cpumask change occur at boot time.
>>>>      1) kthread_bind: bind cpu1
>>>>      2) cpuset_cpus_allowed_fallback: bind possible cpu
>>>>      3) rcu_cpu_kthread_should_stop: rebind cpu1
>>>> - while tsk->rt.nr_cpus_allowed == 1, sched load balancer never be crash.
>>>
>>> Seems rcu_spawn_one_cpu_kthread() call wake_up_process() directly,
>>> which is under hotplug event CPU_UP_PREPARE. Maybe it should be
>>> under CPU_ONLINE.
>>
>> Hmm..
>>
>> I haven't catch your point. cpu_up() call both CPU_UP_PREPARE and CPU_ONLINE
>> notification. Thus, CPU_ONLINE still be called before sched_init_smp().
>
> The difference is that CPU_ONLINE will set cpu_online_mask and cpu_active_mask,
> so wake_up_process()->ttwu()->select_task_rq() will not go back to
> cpuset_cpus_allowed_fallback().

Right. Thank you. Now I got your point!

> But the comments for rcu_cpu_kthread_should_stop() shot me, since
> rcu_spawn_one_cpu_kthread() must be called under CPU_UP_PREPARE
> for some reason.
>
> Maybe we should find a more suitable way for your issue :)

ok, I'll try to read and understand rcu-kthread design and find it out.



