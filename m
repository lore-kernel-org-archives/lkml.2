Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab0I3Ui6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 16:38:58 -0400
Received: from smtp-out.google.com ([74.125.121.35]:14294 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652Ab0I3Ui5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 16:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KjwpYQyGJwItJrKrbdxGJpe87LivYU5cSR37ZxAeOdn8gsE6sCWtyoHR6bNU/nG3by
         OQ5ETmj0syXB66URqPqQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=r5DX52+735OtGHmJCS38n1P_WxEkKzLVf1E_m@mail.gmail.com>
References: <1285788096-29471-1-git-send-email-venki@google.com>
	<1285788096-29471-4-git-send-email-venki@google.com>
	<1285844768.2144.11.camel@laptop>
	<AANLkTi=r5DX52+735OtGHmJCS38n1P_WxEkKzLVf1E_m@mail.gmail.com>
Date: Thu, 30 Sep 2010 13:38:49 -0700
Message-ID: <AANLkTikHfyjjZfDcoO-yDW+JTnpDb42VxRMckk55Xp+O@mail.gmail.com>
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

On Thu, Sep 30, 2010 at 9:29 AM, Venkatesh Pallipadi <venki@google.com> wrote:
> On Thu, Sep 30, 2010 at 4:06 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Wed, 2010-09-29 at 12:21 -0700, Venkatesh Pallipadi wrote:
>>> +void account_system_vtime(struct task_struct *curr)
>>> +{
>>> +       unsigned long flags;
>>> +       int cpu;
>>> +       u64 now, delta;
>>> +
>>> +       if (!sched_clock_irqtime)
>>> +               return;
>>> +
>>> +       local_irq_save(flags);
>>> +
>>> +       now = sched_clock();
>>> +       cpu = smp_processor_id();
>>
>> Like said before, that really wants to read like:
>>
>>        cpu = smp_processor_id();
>>        now = sched_clock_cpu(cpu);
>>
>> sched_clock() is raw tsc + ns conversion and can go all over the place.
>
> sched_clock_cpu() won't really work for here, due to what looks like
> idle and timer tick dependencies. Using sched_clock_cpu(), I end up
> accounting CPU idle time to hardirq due to time captured before the
> handler and after the handler.
>

Specifically, here is the now and delta log from my test setup with
using sched_clock_cpu() above (data below from a particular CPU)

          <idle>-0     [001]  1697.910060: account_system_vtime:
SOFTIRQ STOP 1700897011613, delta 3555
          <idle>-0     [001]  1697.911047: account_system_vtime: IRQ
START 1700897999028
          <idle>-0     [001]  1697.911051: account_system_vtime:
HARDIRQ STOP 1700898005071, delta 6043
          <idle>-0     [001]  1697.911052: account_system_vtime: IRQ
START 1700898006003
          <idle>-0     [001]  1697.911057: account_system_vtime:
SOFTIRQ STOP 1700898010685, delta 4682
          <idle>-0     [001]  1697.911931: account_system_vtime: IRQ
START 1700898884039
          <idle>-0     [001]  1697.911935: account_system_vtime:
HARDIRQ STOP 1700898890304, delta 6265
          <idle>-0     [001]  1697.915040: account_system_vtime: IRQ
START 1700899887146
          <idle>-0     [001]  1697.915047: account_system_vtime:
HARDIRQ STOP 1700902008678, delta 2121532
          <idle>-0     [001]  1697.915048: account_system_vtime: IRQ
START 1700902009617
          <idle>-0     [001]  1697.915055: account_system_vtime:
SOFTIRQ STOP 1700902015924, delta 6307
          <idle>-0     [001]  1697.918958: account_system_vtime: IRQ
START 1700903006980
          <idle>-0     [001]  1697.918963: account_system_vtime:
HARDIRQ STOP 1700905931367, delta 2924387
          <idle>-0     [001]  1697.919553: account_system_vtime: IRQ
START 1700906521486
          <idle>-0     [001]  1697.919557: account_system_vtime:
HARDIRQ STOP 1700906527006, delta 5520
          <idle>-0     [001]  1697.933420: account_system_vtime: IRQ
START 1700907524219
          <idle>-0     [001]  1697.933428: account_system_vtime:
HARDIRQ STOP 1700920424020, delta 12899801
          <idle>-0     [001]  1697.936512: account_system_vtime: IRQ
START 1700921418037
          <idle>-0     [001]  1697.936523: account_system_vtime:
HARDIRQ STOP 1700923524497, delta 2106460
           <...>-13891 [001]  1697.937001: account_system_vtime: IRQ
START 1700924001105
           <...>-13891 [001]  1697.937013: account_system_vtime:
HARDIRQ STOP 1700924015861, delta 14756
           <...>-13891 [001]  1697.937015: account_system_vtime: IRQ
START 1700924017841
           <...>-13891 [001]  1697.937020: account_system_vtime:
SOFTIRQ STOP 1700924023189, delta 5348
           <...>-13891 [001]  1697.937188: account_system_vtime: IRQ
START 1700924191127
           <...>-13891 [001]  1697.937197: account_system_vtime:
HARDIRQ STOP 1700924199862, delta 8735
          <idle>-0     [001]  1697.938000: account_system_vtime: IRQ
START 1700924999818
          <idle>-0     [001]  1697.938013: account_system_vtime:
HARDIRQ STOP 1700925017573, delta 17755
          <idle>-0     [001]  1697.938015: account_system_vtime: IRQ
START 1700925019459
          <idle>-0     [001]  1697.938031: account_system_vtime:
SOFTIRQ STOP 1700925034677, delta 15218

Thanks,
Venki
