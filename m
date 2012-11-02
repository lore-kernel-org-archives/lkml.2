Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762234Ab2KBK70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 06:59:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40215 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2KBK7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 06:59:25 -0400
Message-ID: <5093A77B.4060300@ti.com>
Date: Fri, 2 Nov 2012 16:29:07 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linaro-dev@lists.linaro.org>, <peterz@infradead.org>,
        <mingo@redhat.com>, <pjt@google.com>, <linux@arm.linux.org.uk>
Subject: Re: [RFC 5/6] sched: pack the idle load balance
References: <1349595838-31274-1-git-send-email-vincent.guittot@linaro.org> <1349595838-31274-6-git-send-email-vincent.guittot@linaro.org> <50880774.5090605@ti.com> <CAKfTPtBsAJ4u265TzOz9qvL4d-eMmrVD-MtgG_Rri_2shGrPBQ@mail.gmail.com>
In-Reply-To: <CAKfTPtBsAJ4u265TzOz9qvL4d-eMmrVD-MtgG_Rri_2shGrPBQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 October 2012 06:57 PM, Vincent Guittot wrote:
> On 24 October 2012 17:21, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
>> On Sunday 07 October 2012 01:13 PM, Vincent Guittot wrote:
>>>
>>> Look for an idle CPU close the pack buddy CPU whenever possible.
>>
>> s/close/close to
>
> yes
>
>>
>>> The goal is to prevent the wake up of a CPU which doesn't share the power
>>> line of the pack CPU
>>>
>>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>>> ---
>>>    kernel/sched/fair.c |   18 ++++++++++++++++++
>>>    1 file changed, 18 insertions(+)
>>>
>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>> index 6df53b5..f76acdc 100644
>>> --- a/kernel/sched/fair.c
>>> +++ b/kernel/sched/fair.c
>>> @@ -5158,7 +5158,25 @@ static struct {
>>>
>>>    static inline int find_new_ilb(int call_cpu)
>>>    {
>>> +       struct sched_domain *sd;
>>>          int ilb = cpumask_first(nohz.idle_cpus_mask);
>>> +       int buddy = per_cpu(sd_pack_buddy, call_cpu);
>>> +
>>> +       /*
>>> +        * If we have a pack buddy CPU, we try to run load balance on a
>>> CPU
>>> +        * that is close to the buddy.
>>> +        */
>>> +       if (buddy != -1)
>>> +               for_each_domain(buddy, sd) {
>>> +                       if (sd->flags & SD_SHARE_CPUPOWER)
>>> +                               continue;
>>
>> Do you mean SD_SHARE_POWERLINE here ?
>
> No, I just don't want to take hyperthread level for ILB
>
>>
>>> +
>>> +                       ilb = cpumask_first_and(sched_domain_span(sd),
>>> +                                       nohz.idle_cpus_mask);
>>> +
>>> +                       if (ilb < nr_cpu_ids)
>>> +                               break;
>>> +               }
>>>
>>>          if (ilb < nr_cpu_ids && idle_cpu(ilb))
>>>                  return ilb;
>>>
>> Can you please expand "idle CPU _close_ the pack buddy CPU" ?
>
> The goal is to packed  the tasks on the pack buddy CPU so when the
> scheduler needs to start ILB, I try to wake up a CPU that is close to
> the buddy and preferably in the same cluster
>
I see your point now. Thanks for clarification.

Regards
santosh

