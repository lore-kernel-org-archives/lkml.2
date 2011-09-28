Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1I1POZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:14:25 -0400
Received: from mx2.parallels.com ([64.131.90.16]:48796 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab1I1POX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:14:23 -0400
Message-ID: <4E833993.3020608@parallels.com>
Date: Wed, 28 Sep 2011 12:13:23 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>
Subject: Re: [RFD 1/9] Change cpustat fields to an array.
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>  <1316816432-9237-2-git-send-email-glommer@parallels.com> <1317157252.21836.3.camel@twins>
In-Reply-To: <1317157252.21836.3.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.46.219.221]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2011 06:00 PM, Peter Zijlstra wrote:
> On Fri, 2011-09-23 at 19:20 -0300, Glauber Costa wrote:
>>   /* Must have preemption disabled for this to be meaningful. */
>> -#define kstat_this_cpu __get_cpu_var(kstat)
>> +#define kstat_this_cpu this_cpu_ptr(task_group_kstat(current))
>
> This just lost you a debug check, the former would whinge when called
> without preemption, the new one wont. Its part of the this_cpu feature
> set to make debugging impossible.

Why is that?

from percpu.h:
#define __get_cpu_var(var) (*this_cpu_ptr(&(var)))

So I don't get it.

>> +#else
>> +#define kstat_cpu(cpu) per_cpu(kstat, cpu)
>> +#define kstat_this_cpu (&__get_cpu_var(kstat))
>> +#endif
>>
>>   extern unsigned long long nr_context_switches(void);
>>
>> @@ -52,8 +62,8 @@ struct irq_desc;
>>   static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
>>                                              struct irq_desc *desc)
>>   {
>> -       __this_cpu_inc(kstat.irqs[irq]);
>> -       __this_cpu_inc(kstat.irqs_sum);
>> +       kstat_this_cpu->irqs[irq]++;
>> +       kstat_this_cpu->irqs_sum++;
>
> It might be worth looking at the asm output of that, I think you made it
> worse, but I'm not quite sure how smart gcc is, it might just figure out
> what you meant.
>
>>   }

Yes, it is indeed a bit worse, but the reason appears to be an extra 
call to  something related to task_group(). That one is inline, but it 
calls more stuff in the way. And it is hard to dodge from that once we 
move to this path. It might be acceptable to lose some cycles here to 
gain more back once cpuacct is out.

That said, I'll also see if we can squeeze something more clever out of it.



