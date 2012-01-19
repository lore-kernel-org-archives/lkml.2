Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab2ASM5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 07:57:36 -0500
Received: from mail.lippert-at.com ([62.80.22.186]:19353 "EHLO
	domex.lippertembedded.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752787Ab2ASM5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 07:57:32 -0500
Message-ID: <4F18133B.9020801@LiPPERTEmbedded.de>
Date: Thu, 19 Jan 2012 13:57:31 +0100
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Subject: Re: [PATCH] cs5535-clockevt: don't ignore MFGPT on SMP-capable kernels
References: <4EE620A5.7080402@LiPPERTEmbedded.de>	<20111212123131.502be350@queued.net>	<4EE77416.8090907@LiPPERTEmbedded.de>	<4EE8ECF3.6000900@LiPPERTEmbedded.de>	<20111214104724.292b02d4@queued.net>	<4EF1FE5C.6040101@LiPPERTEmbedded.de> <20120111021022.16ba5c93@debxo>
In-Reply-To: <20120111021022.16ba5c93@debxo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jan 2012 12:57:29.0728 (UTC) FILETIME=[E6D29800:01CCD6A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

and a happy new year to you. Sorry for the delay.

Andres Salomon wrote:
> Jens Rottmann <JRottmann@LiPPERTEmbedded.de> wrote:
>> cs5535-clockevt: don't ignore MFGPT on SMP-capable kernels
>>
>> On SMP-capable kernels (e.g. generic distro kernel) the
>> cs5535-clockevt driver loads but is not actually used.
>>
>> Setting cpumask to cpu_all_mask works for UP-only kernels, but if
>> compiled for SMP - though still running on the same UP hardware -
>> kernel/time/tick-common.c:tick_check_new_device() reads this as
>> "non-cpu-local" and silently ignores the device.
>>
>> If we leave cpumask unset clockevents_register_device() will
>> initialize it and the cs5535-clockevt driver will be used no matter
>> how the kernel was compiled. Should anyone ever manage to stick a
>> CS553x in an SMP system (is this even possible?) then a warning will
>> be printed.  This is fine as the cs5535-clockevt driver was never
>> written/tested for SMP.
>>
>> If bisecting led you here this patch may have exposed a pre-existing
>> MFGPT problem.  Configure for UP-only and re-check.
>>
>> Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
>> ---
>>
>> --- linux-3.2-rc6/drivers/clocksource/cs5535-clockevt.c
>> +++ use_mfgpt_on_smp_kernels/drivers/clocksource/cs5535-clockevt.c
>> @@ -100,7 +100,6 @@ static struct clock_event_device cs5535_
>>  	.set_mode = mfgpt_set_mode,
>>  	.set_next_event = mfgpt_next_event,
>>  	.rating = 250,
>> -	.cpumask = cpu_all_mask,
>>  	.shift = 32
>>  };
>>
>> _
>
> Hm, have you tried setting cpumask to cpumask_of(0), like a bunch of
> the other clock_event_device drivers do?

Yes, I've seen that, and it was my initial approach. cpumask_of(0)
isn't regarded constant, so moved it from the struct init to
cs5535_mfgpt_init() ... but then I saw

clockevents.c:clockevents_register_device():
	if (!dev->cpumask) {
		WARN_ON(num_possible_cpus() > 1);
		dev->cpumask = cpumask_of(smp_processor_id());
	}

Looks to me like meant exactly for this purpose. This will set cpumask to
cpumask_of(0), i.e. does exactly what you're suggesting.

Both do work fine, but I understand cpumask=cpumask_of(0) to mean "this timer
is hardware-tied to a specific CPU", whereas cpumask unset means more like
"wow, we never expected anybody putting this hardware in an SMP system".

And you've said it yourself:

> I've only ever tested it on UP kernels. [...] I hope all of those cs5535
> drivers that hadn't had their locking primitives tested aren't racy!

So I see the WARN_ON as a bonus.

Cheers
Jens
