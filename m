Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2LRKRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 05:17:46 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:38483 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab2LRKRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 05:17:44 -0500
X-Greylist: delayed 1055 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 05:17:43 EST
MIME-Version: 1.0
In-Reply-To: <50CF3916.4010001@intel.com>
References: <1355319092-30980-1-git-send-email-vincent.guittot@linaro.org>
	<1355319092-30980-4-git-send-email-vincent.guittot@linaro.org>
	<50C93AC1.1060202@intel.com>
	<CAKfTPtB9iz1ePsS+juQVRhuWREYB1duGWRJT7ya8XBXPhC-mkw@mail.gmail.com>
	<50C9E552.1010600@intel.com>
	<CAKfTPtCUDEC50xexmLQ1d9qvBz1iJnf4aGSGjN==jqZwpxrwiQ@mail.gmail.com>
	<CAKfTPtAhFtGKOtwumuav+pndoAZiKjHvYoE2NZxtgP+qHuHY3g@mail.gmail.com>
	<50CA84FF.5070907@intel.com>
	<CAKfTPtCarhT3J3xOD6jOh_91Pm5FK4V_DAk5QLs_=8rVF+-fsQ@mail.gmail.com>
	<50CD746E.7010807@intel.com>
	<CAKfTPtAt-TUoJpXbL+dAQ2zGTYtewdXpFDN_mSeu4MnuC-2Xjg@mail.gmail.com>
	<50CF3916.4010001@intel.com>
Date: Tue, 18 Dec 2012 10:53:31 +0100
Message-ID: <CAKfTPtDHcGrgSKxPvWzX5yia=_pct29ybKmUv=OEgCagZTpASA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/6] sched: pack small tasks
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Alex Shi <alex.shi@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, preeti@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, len.brown@intel.com,
        arjan@linux.intel.com, amit.kucheria@linaro.org,
        viresh.kumar@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 December 2012 16:24, Alex Shi <alex.shi@intel.com> wrote:
>>>>>>> The scheme below tries to summaries the idea:
>>>>>>>
>>>>>>> Socket      | socket 0 | socket 1   | socket 2   | socket 3   |
>>>>>>> LCPU        | 0 | 1-15 | 16 | 17-31 | 32 | 33-47 | 48 | 49-63 |
>>>>>>> buddy conf0 | 0 | 0    | 1  | 16    | 2  | 32    | 3  | 48    |
>>>>>>> buddy conf1 | 0 | 0    | 0  | 16    | 16 | 32    | 32 | 48    |
>>>>>>> buddy conf2 | 0 | 0    | 16 | 16    | 32 | 32    | 48 | 48    |
>>>>>>>
>>>>>>> But, I don't know how this can interact with NUMA load balance and the
>>>>>>> better might be to use conf3.
>>>>>>
>>>>>> I mean conf2 not conf3
>>>>>
>>>>> So, it has 4 levels 0/16/32/ for socket 3 and 0 level for socket 0, it
>>>>> is unbalanced for different socket.
>>>>
>>>> That the target because we have decided to pack the small tasks in
>>>> socket 0 when we have parsed the topology at boot.
>>>> We don't have to loop into sched_domain or sched_group anymore to find
>>>> the best LCPU when a small tasks wake up.
>>>
>>> iteration on domain and group is a advantage feature for power efficient
>>> requirement, not shortage. If some CPU are already idle before forking,
>>> let another waking CPU check their load/util and then decide which one
>>> is best CPU can reduce late migrations, that save both the performance
>>> and power.
>>
>> In fact, we have already done this job once at boot and we consider
>> that moving small tasks in the buddy CPU is always benefit so we don't
>> need to waste time looping sched_domain and sched_group to compute
>> current capacity of each LCPU for each wake up of each small tasks. We
>> want all small tasks and background activity waking up on the same
>> buddy CPU and let the default behavior of the scheduler choosing the
>> best CPU for heavy tasks or loaded CPUs.
>
> IMHO, the design should be very good for your scenario and your machine,
> but when the code move to general scheduler, we do want it can handle
> more general scenarios. like sometime the 'small task' is not as small
> as tasks in cyclictest which even hardly can run longer than migration

Cyclictest is the ultimate small tasks use case which points out all
weaknesses of a scheduler for such kind of tasks.
Music playback is a more realistic one and it also shows improvement

> granularity or one tick, thus we really don't need to consider task
> migration cost. But when the task are not too small, migration is more

For which kind of machine are you stating that hypothesis ?

> heavier than domain/group walking, that is the common sense in
> fork/exec/waking balance.

I would have said the opposite: The current scheduler limits its
computation of statistic during fork/exec/waking compared to a
periodic load balance because it's too heavy. It's even more true for
wake up if wake affine is possible.

>
>>
>>>
>>> On the contrary, move task walking on each level buddies is not only bad
>>> on performance but also bad on power. Consider the quite big latency of
>>> waking a deep idle CPU. we lose too much..
>>
>> My result have shown different conclusion.
>
> That should be due to your tasks are too small to need consider
> migration cost.
>> In fact, there is much more chance that the buddy will not be in a
>> deep idle as all the small tasks and background activity are already
>> waking on this CPU.
>
> powertop is helpful to tune your system for more idle time. Another
> reason is current kernel just try to spread tasks on more cpu for
> performance consideration. My power scheduling patch should helpful on this.
>>
>>>
>>>>
>>>>>
>>>>> And the ground level has just one buddy for 16 LCPUs - 8 cores, that's
>>>>> not a good design, consider my previous examples: if there are 4 or 8
>>>>> tasks in one socket, you just has 2 choices: spread them into all cores,
>>>>> or pack them into one LCPU. Actually, moving them just into 2 or 4 cores
>>>>> maybe a better solution. but the design missed this.
>>>>
>>>> You speak about tasks without any notion of load. This patch only care
>>>> of small tasks and light LCPU load, but it falls back to default
>>>> behavior for other situation. So if there are 4 or 8 small tasks, they
>>>> will migrate to the socket 0 after 1 or up to 3 migration (it depends
>>>> of the conf and the LCPU they come from).
>>>
>>> According to your patch, what your mean 'notion of load' is the
>>> utilization of cpu, not the load weight of tasks, right?
>>
>> Yes but not only. The number of tasks that run simultaneously, is
>> another important input
>>
>>>
>>> Yes, I just talked about tasks numbers, but it naturally extends to the
>>> task utilization on cpu. like 8 tasks with 25% util, that just can full
>>> fill 2 CPUs. but clearly beyond the capacity of the buddy, so you need
>>> to wake up another CPU socket while local socket has some LCPU idle...
>>
>> 8 tasks with a running period of 25ms per 100ms that wake up
>> simultaneously should probably run on 8 different LCPU in order to
>> race to idle
>
> nope, it's a rare probability of 8 tasks wakeuping simultaneously. And

Multimedia  is one example of tasks waking up simultaneously

> even so they should run in the same socket for power saving
> consideration(my power scheduling patch can do this), instead of spread
> to all sockets.

This is may be good for your scenario and your machine :-)
Packing small tasks is the best choice for any scenario and machine.
It's a more tricky point for not so small tasks because different
machine will want different behavior.

>>
>>
>> Regards,
>> Vincent
>>
>>>>
>>>> Then, if too much small tasks wake up simultaneously on the same LCPU,
>>>> the default load balance will spread them in the core/cluster/socket
>>>>
>>>>>
>>>>> Obviously, more and more cores is the trend on any kinds of CPU, the
>>>>> buddy system seems hard to catch up this.
>>>>>
>>>>>
>>>
>>>
>>> --
>>> Thanks
>>>     Alex
>
>
> --
> Thanks
>     Alex
