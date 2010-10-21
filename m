Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab0JUTKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 15:10:35 -0400
Received: from smtp-out.google.com ([74.125.121.35]:42013 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab0JUTKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 15:10:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JhRi2Ywb9ZuG81b/Z4T0wxu69HTHz+qjGw17jmkBpp45eo6OuLKzOHrN6AW2SRXLcL
         slTROcL78DBtv6OVWcDA==
MIME-Version: 1.0
In-Reply-To: <1287672809.3488.142.camel@twins>
References: <1287614941-32325-1-git-send-email-venki@google.com>
	<1287614941-32325-6-git-send-email-venki@google.com>
	<1287672809.3488.142.camel@twins>
Date: Thu, 21 Oct 2010 12:10:29 -0700
Message-ID: <AANLkTing_EuL2ei4dgcK-o7fP3brAJLCY4p9ySRYze6Q@mail.gmail.com>
Subject: Re: [PATCH 5/6] Account ksoftirq time as cpustat softirq
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 7:53 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-10-20 at 15:49 -0700, Venkatesh Pallipadi wrote:
>> @@ -1979,15 +1980,20 @@ void account_system_vtime(struct task_struct *curr)
>>         delta = now - per_cpu(irq_start_time, cpu);
>>         per_cpu(irq_start_time, cpu) = now;
>>         /*
>> -        * We do not account for softirq time from ksoftirqd here.
>>          * We want to continue accounting softirq time to ksoftirqd thread
>>          * in that case, so as not to confuse scheduler with a special task
>>          * that do not consume any time, but still wants to run.
>> +        * So, softirq time in ksoftirqd is accounted separately and used
>> +        * for softirq time reporting in /proc/stat.
>>          */
>> -       if (in_irq())
>> +       if (in_irq()) {
>>                 per_cpu(cpu_hardirq_time, cpu) += delta;
>> -       else if (in_serving_softirq() && !(is_ksoftirqd_context()))
>> -               per_cpu(cpu_softirq_time, cpu) += delta;
>> +       } else if (in_serving_softirq()) {
>> +               if (is_ksoftirqd_context())
>> +                       per_cpu(cpu_ksoftirqd_time, cpu) += delta;
>> +               else
>> +                       per_cpu(cpu_softirq_time, cpu) += delta;
>> +       }
>>
>>         local_irq_restore(flags);
>>  }
>> @@ -2025,7 +2031,9 @@ static int irqtime_account_si_update(void)
>>         int ret = 0;
>>
>>         local_irq_save(flags);
>> -       latest_ns = __get_cpu_var(cpu_softirq_time);
>> +       latest_ns = __get_cpu_var(cpu_softirq_time) +
>> +                       __get_cpu_var(cpu_ksoftirqd_time);
>
> wouldn't something like:
>
>        latest_ns = this_cpu_read(cpu_softirq_time) +
>                this_softirq_task()->se.sum_exec_runtime;
>
> be easier?
>

Yes. As we are using this ksoftirqd_time at only one place,
this_softirq_task()->se.sum_exec_runtime with a comment on why we are
doing that would be simpler. Will do.

Thanks,
Venki
