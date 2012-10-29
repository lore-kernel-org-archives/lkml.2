Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab2J2N15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:27:57 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:42672 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab2J2N14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:27:56 -0400
MIME-Version: 1.0
In-Reply-To: <50880774.5090605@ti.com>
References: <1349595838-31274-1-git-send-email-vincent.guittot@linaro.org>
	<1349595838-31274-6-git-send-email-vincent.guittot@linaro.org>
	<50880774.5090605@ti.com>
Date: Mon, 29 Oct 2012 14:27:54 +0100
Message-ID: <CAKfTPtBsAJ4u265TzOz9qvL4d-eMmrVD-MtgG_Rri_2shGrPBQ@mail.gmail.com>
Subject: Re: [RFC 5/6] sched: pack the idle load balance
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, peterz@infradead.org, mingo@redhat.com,
        pjt@google.com, linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 October 2012 17:21, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
> On Sunday 07 October 2012 01:13 PM, Vincent Guittot wrote:
>>
>> Look for an idle CPU close the pack buddy CPU whenever possible.
>
> s/close/close to

yes

>
>> The goal is to prevent the wake up of a CPU which doesn't share the power
>> line of the pack CPU
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>   kernel/sched/fair.c |   18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 6df53b5..f76acdc 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -5158,7 +5158,25 @@ static struct {
>>
>>   static inline int find_new_ilb(int call_cpu)
>>   {
>> +       struct sched_domain *sd;
>>         int ilb = cpumask_first(nohz.idle_cpus_mask);
>> +       int buddy = per_cpu(sd_pack_buddy, call_cpu);
>> +
>> +       /*
>> +        * If we have a pack buddy CPU, we try to run load balance on a
>> CPU
>> +        * that is close to the buddy.
>> +        */
>> +       if (buddy != -1)
>> +               for_each_domain(buddy, sd) {
>> +                       if (sd->flags & SD_SHARE_CPUPOWER)
>> +                               continue;
>
> Do you mean SD_SHARE_POWERLINE here ?

No, I just don't want to take hyperthread level for ILB

>
>> +
>> +                       ilb = cpumask_first_and(sched_domain_span(sd),
>> +                                       nohz.idle_cpus_mask);
>> +
>> +                       if (ilb < nr_cpu_ids)
>> +                               break;
>> +               }
>>
>>         if (ilb < nr_cpu_ids && idle_cpu(ilb))
>>                 return ilb;
>>
> Can you please expand "idle CPU _close_ the pack buddy CPU" ?

The goal is to packed  the tasks on the pack buddy CPU so when the
scheduler needs to start ILB, I try to wake up a CPU that is close to
the buddy and preferably in the same cluster

>
> Regards
> santosh
