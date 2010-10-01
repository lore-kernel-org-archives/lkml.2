Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab0JAXcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 19:32:25 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54078 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab0JAXcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 19:32:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QnBjzmddYs6tr67AKDYO7KfJ+sf3OyI7JDLJHgKke4OnxYIQGpENBnVly7Dy7j9Mxy
         1VTiGaUlo5mBtD1QOo0Q==
MIME-Version: 1.0
In-Reply-To: <1285974873.2144.65.camel@laptop>
References: <1285788096-29471-1-git-send-email-venki@google.com>
	<1285788096-29471-4-git-send-email-venki@google.com>
	<1285844768.2144.11.camel@laptop>
	<AANLkTi=r5DX52+735OtGHmJCS38n1P_WxEkKzLVf1E_m@mail.gmail.com>
	<AANLkTikHfyjjZfDcoO-yDW+JTnpDb42VxRMckk55Xp+O@mail.gmail.com>
	<1285933569.2144.57.camel@laptop>
	<AANLkTinmgCmozNMQyesaTxrAfzgJ7bKEAeyNRWh7ceZ5@mail.gmail.com>
	<AANLkTi=b2NaXOS05tT69hdmddxPPc5OxxnZ0qG0ZZZYe@mail.gmail.com>
	<1285974873.2144.65.camel@laptop>
Date: Fri, 1 Oct 2010 16:32:15 -0700
Message-ID: <AANLkTikcPX6m01F1rg--AKkSj_69kJJVsTrqB_FF6sJf@mail.gmail.com>
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
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 4:14 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-10-01 at 10:29 -0700, Venkatesh Pallipadi wrote:
>> So, on x86, sched_clock_stable is not set on all other kind of CPUs
>> and my test system happens to be one of them. So, sched_clock_cpu()
>> falls back to tick based even when TSC is not marked unstable and
>> clocksource is using TSC for timing.
>
> It is never tick based!! It's tick augmented! Because TSC is such a
> piece of crap we use external (slow) means of determining a window in
> which the TSC should live and then use the TSC to generate high
> resolution offsets inside that.
>
> So even if your usage is in the hardirq context that moves that window
> it should all work out.
>

You mean there should not be any "jumps" noticed with
sched_clock_cpu() when we are idle and get a interrupt?
Atleast thats what I am seeing. May be there is some other bug
somewhere causing that.

Loooking at one snapshot from my earlier log

<idle>-0     []  1697.915040: : START 1700899887146
// We were idle and got an interrupt and recorded sched_clock_cpu() as
1700899887146
<idle>-0     []  1697.915047: : HARD STOP 1700902008678, delta 2121532
// We finished handling the interrupt and recorded sched_clock_cpu()
as 1700902008678
// So, delta we see is > 2ms
// This is trace_printk based on local clock, which is using sched_clock()
// So, the trace timing shows delta of 7 us, which is kind of expected time here
