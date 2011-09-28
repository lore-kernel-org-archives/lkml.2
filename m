Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1I1UFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 16:05:53 -0400
Received: from mx2.parallels.com ([64.131.90.16]:53523 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab1I1UFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 16:05:52 -0400
Message-ID: <4E837DBE.5010904@parallels.com>
Date: Wed, 28 Sep 2011 17:04:14 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>
Subject: Re: [RFD 1/9] Change cpustat fields to an array.
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>   <1316816432-9237-2-git-send-email-glommer@parallels.com>  <1317157252.21836.3.camel@twins> <4E836546.7010004@parallels.com> <1317236957.24040.62.camel@twins>
In-Reply-To: <1317236957.24040.62.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [189.64.210.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 04:09 PM, Peter Zijlstra wrote:
> On Wed, 2011-09-28 at 15:19 -0300, Glauber Costa wrote:
>> On 09/27/2011 06:00 PM, Peter Zijlstra wrote:
>>> On Fri, 2011-09-23 at 19:20 -0300, Glauber Costa wrote:
>>>>    /* Must have preemption disabled for this to be meaningful. */
>>>> -#define kstat_this_cpu __get_cpu_var(kstat)
>>>> +#define kstat_this_cpu this_cpu_ptr(task_group_kstat(current))
>>>
>>> This just lost you a debug check, the former would whinge when called
>>> without preemption, the new one wont. Its part of the this_cpu feature
>>> set to make debugging impossible.
>>>
>>>> +#else
>>>> +#define kstat_cpu(cpu) per_cpu(kstat, cpu)
>>>> +#define kstat_this_cpu (&__get_cpu_var(kstat))
>>>> +#endif
>>>>
>>>>    extern unsigned long long nr_context_switches(void);
>>>>
>>>> @@ -52,8 +62,8 @@ struct irq_desc;
>>>>    static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
>>>>                                               struct irq_desc *desc)
>>>>    {
>>>> -       __this_cpu_inc(kstat.irqs[irq]);
>>>> -       __this_cpu_inc(kstat.irqs_sum);
>>>> +       kstat_this_cpu->irqs[irq]++;
>>>> +       kstat_this_cpu->irqs_sum++;
>>>
>>> It might be worth looking at the asm output of that, I think you made it
>>> worse, but I'm not quite sure how smart gcc is, it might just figure out
>>> what you meant.
>>
>> I'd say leave it alone.
>> The biggest difference is that we don't have access to task_group(), or
>> any of the fields in struct task_group. Because of that, we end up
>> having to export a function to do the job of dealing with it.
>>
>> Users inside sched.c won't have this problem. Outside of it, we'll add a
>> call to some paths. True, mostly handle_irq paths, but I don't think
>> that's what's going to kill us.
>>
>> Now if we really really want to save it, we'd have to move struct
>> task_group and its friends to a more visible location like a header...
>
> I'm not quite getting how task_group is relevant here.
>
> The above will do something like:
>
> 	mov gs:$per-cpu-offset-of-kstat, reg
> 	inc reg + idx*8

except offset of kstat is not fixed. It is dynamic allocated, so you have
to calculate it. You can't really do it without knowing at least the 
address of task_group, and then, the offset of kstat inside it.

