Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab1GACur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 22:50:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab1GACup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 22:50:45 -0400
Message-ID: <4E0D35E5.9080506@redhat.com>
Date: Thu, 30 Jun 2011 23:50:13 -0300
From: Glauber Costa <glommer@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH v3 7/9] KVM-GST: KVM Steal time accounting
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>	 <1309361388-30163-8-git-send-email-glommer@redhat.com> <1309470872.12449.609.camel@twins>
In-Reply-To: <1309470872.12449.609.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2011 06:54 PM, Peter Zijlstra wrote:
> On Wed, 2011-06-29 at 11:29 -0400, Glauber Costa wrote:
>> +static noinline bool touch_steal_time(int is_idle)
>
> That noinline is very unlucky there,
>
>> +{
>> +       u64 steal, st = 0;
>> +
>> +       if (static_branch(&paravirt_steal_enabled)) {
>> +
>> +               steal = paravirt_steal_clock(smp_processor_id());
>> +
>> +               steal -= this_rq()->prev_steal_time;
>> +
>> +               st = steal_ticks(steal);
>> +               this_rq()->prev_steal_time += st * TICK_NSEC;
>> +
>> +               if (is_idle || st == 0)
>> +                       return false;
>> +
>> +               account_steal_time(st);
>> +               return true;
>> +       }
>> +       return false;
>> +}
>> +
>>   static void update_rq_clock_task(struct rq *rq, s64 delta)
>>   {
>>          s64 irq_delta;
>> @@ -3716,6 +3760,9 @@ void account_user_time(struct task_struct *p,
>> cputime_t cputime,
>>          struct cpu_usage_stat *cpustat =&kstat_this_cpu.cpustat;
>>          cputime64_t tmp;
>>
>> +       if (touch_steal_time(0))
>> +               return;
>
> Means we have an unconditional call here, even if the static_branch() is
> patched out.
Ok.

I was under the impression that the proper use of jump labels required 
each label to be tied to a single location. If we make it inline, the 
same key would point to multiple locations, and we would have trouble
altering all of the locations. I might be wrong, of course. Isn't it the 
case?
