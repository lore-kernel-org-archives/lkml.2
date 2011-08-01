Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab1HAImp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 04:42:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35566 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1HAImh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 04:42:37 -0400
MIME-Version: 1.0
In-Reply-To: <20110731150707.GA2975@n2100.arm.linux.org.uk>
References: <1312124593-6088-1-git-send-email-linux@bohmer.net>
	<20110731150707.GA2975@n2100.arm.linux.org.uk>
Date: Mon, 1 Aug 2011 10:42:35 +0200
X-Google-Sender-Auth: PnmD6d0d7-tyb8ypd4PU0AwxMW8
Message-ID: <CANqCtQJwUsLXfA408GzAr0rQtc2DRjtKqP8-m2UBUGEy-YP5dg@mail.gmail.com>
Subject: Re: [PATCH] Add sched_clock to AT91 TCB clocksource driver
From: Remy Bohmer <linux@bohmer.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Remy Bohmer <l.pinguin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

2011/7/31 Russell King - ARM Linux <linux@arm.linux.org.uk>:
>> +++ b/arch/arm/Kconfig
>> @@ -296,6 +296,7 @@ config ARCH_AT91
>>       select HAVE_CLK
>>       select CLKDEV_LOOKUP
>>       select ARM_PATCH_PHYS_VIRT if MMU
>> +     select HAVE_SCHED_CLOCK if ATMEL_TCB_CLKSRC
>>       help
>>         This enables support for systems based on the Atmel AT91RM9200,
>>         AT91SAM9 and AT91CAP9 processors.
>> diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
>> index 9a46370..f9028e4 100644
>> --- a/arch/arm/kernel/sched_clock.c
>> +++ b/arch/arm/kernel/sched_clock.c
>> @@ -20,6 +20,13 @@ static void (*sched_clock_update_fn)(void);
>>
>>  static void sched_clock_poll(unsigned long wrap_ticks)
>>  {
>> +     /*
>> +      * The sched_clock_update_fn may be initialised AFTER first call to
>> +      * time_init()
>> +      */
>> +     if (unlikely(!sched_clock_update_fn))
>> +             return;
>
> NAK.  I've said this before - sched_clock _must_ be up and running by the
> time this function is called - because shortly after this call is when
> the scheduler initializes, and the scheduler wants sched_clock() working
> at that point.

OK, I know that too, but the jiffies based fallback does it even
worse, since it does not run at all...  (It only updates in steps of a
couple of 100msecs and stops after a while, and even does not display
a real time...) This sched_clock implementation at least works before
the drivers are being initialised...

Anyway, do you have a better suggestion how to fix this? The tcb
clocksource is loaded during a arch_initcall(), perhaps we need
something before that point.
I do not see an easy way to integrate it in MACHINE_START(.timer).
Would 'late_time_init' be a better solution?

Kind regards,

Remy
