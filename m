Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2B1GSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 01:18:17 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41321 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab2B1GSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 01:18:16 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dmitry.antipov@linaro.org designates 10.205.133.208 as permitted sender) smtp.mail=dmitry.antipov@linaro.org
Message-ID: <4F4C71F4.7000604@linaro.org>
Date: Tue, 28 Feb 2012 10:19:32 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
        Yong Zhang <yong.zhang0@gmail.com>, Venki Pallipadi <venki@google.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] sched: generalize CONFIG_IRQ_TIME_ACCOUNTING for X86
 and ARM
References: <1329717859-19378-1-git-send-email-dmitry.antipov@linaro.org> <1330337535.11248.45.camel@twins>
In-Reply-To: <1330337535.11248.45.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2012 02:12 PM, Peter Zijlstra wrote:

>> -extern void enable_sched_clock_irqtime(void);
>> -extern void disable_sched_clock_irqtime(void);
>> +extern int sched_clock_irqtime;
>> +static inline void enable_sched_clock_irqtime(void)
>> +{
>> +	if (sched_clock_irqtime == -1)
>> +		sched_clock_irqtime = 1;
>> +}
>> +static inline void disable_sched_clock_irqtime(void)
>> +{
>> +	sched_clock_irqtime = 0;
>> +}
>>   #else
>>   static inline void enable_sched_clock_irqtime(void) {}
>>   static inline void disable_sched_clock_irqtime(void) {}
>
> Please keep them out-of-line, its not a fast path and it avoids having
> to expose the state variable.

OK

>> +/*
>> + * -1 if not initialized, 0 if disabled with "noirqtime" kernel option
>> + * or after unstable clock was detected, 1 if enabled and active.
>> + */
>
> You forgot to explain what you need the tri-state for.
>
>> +__read_mostly int sched_clock_irqtime = -1;

The comment above should be a sufficient explanation, isn't it?

It's a tri-state just because it "merges" two variables: internal state (enabled/disabled)
and the value passed by "noirqtime" option (turn it on, default/turn it off). It can be
enabled only if it was not turned off explicitly, i.e. -1 => 1 transition is possible,
but 0 -> 1 is not. The same rule applies to a situation when an unstable clock is detected.

Dmitry
