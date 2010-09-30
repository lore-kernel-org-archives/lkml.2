Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab0I3Q31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 12:29:27 -0400
Received: from smtp-out.google.com ([74.125.121.35]:46838 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab0I3Q30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 12:29:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IVlYkE5fMR3LEoGpaylTzBT6E3iimp5sw/oGPSS4jqzzIgnNupItbktPJFd5GwD1ER
         rV4I90F60T6ikn00Ucmg==
MIME-Version: 1.0
In-Reply-To: <1285844768.2144.11.camel@laptop>
References: <1285788096-29471-1-git-send-email-venki@google.com>
	<1285788096-29471-4-git-send-email-venki@google.com>
	<1285844768.2144.11.camel@laptop>
Date: Thu, 30 Sep 2010 09:29:22 -0700
Message-ID: <AANLkTi=r5DX52+735OtGHmJCS38n1P_WxEkKzLVf1E_m@mail.gmail.com>
Subject: Re: [PATCH 3/7] Add IRQ_TIME_ACCOUNTING, finer accounting of irq time -v3
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 4:06 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-09-29 at 12:21 -0700, Venkatesh Pallipadi wrote:
>> +void account_system_vtime(struct task_struct *curr)
>> +{
>> +       unsigned long flags;
>> +       int cpu;
>> +       u64 now, delta;
>> +
>> +       if (!sched_clock_irqtime)
>> +               return;
>> +
>> +       local_irq_save(flags);
>> +
>> +       now = sched_clock();
>> +       cpu = smp_processor_id();
>
> Like said before, that really wants to read like:
>
>        cpu = smp_processor_id();
>        now = sched_clock_cpu(cpu);
>
> sched_clock() is raw tsc + ns conversion and can go all over the place.

sched_clock_cpu() won't really work for here, due to what looks like
idle and timer tick dependencies. Using sched_clock_cpu(), I end up
accounting CPU idle time to hardirq due to time captured before the
handler and after the handler.

Thanks,
Venki

>
>> +       delta = now - per_cpu(irq_start_time, cpu);
>> +       per_cpu(irq_start_time, cpu) = now;
>> +       if (hardirq_count())
>> +               per_cpu(cpu_hardirq_time, cpu) += delta;
>> +       else if (in_serving_softirq())
>> +               per_cpu(cpu_softirq_time, cpu) += delta;
>> +
>> +       local_irq_restore(flags);
>> +}
>
