Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161351Ab2GLQ62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:58:28 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42690 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521Ab2GLQ60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:58:26 -0400
Message-ID: <4FFF01FD.4050005@linaro.org>
Date: Thu, 12 Jul 2012 09:57:33 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Marc Zyngier <marc.zyngier@arm.com>, Deepak Saxena <dsaxena@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Marc Zyngier <maz@misterjones.org>
Subject: Re: [PATCH 33/36] AArch64: Generic timers support
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <1341608777-12982-34-git-send-email-catalin.marinas@arm.com> <CAKnu2MrHibKWezjEK+6oOnamkjxWnWwKfoVYRDBURZ3VkaoxEQ@mail.gmail.com> <12a7f9b8e6d0b4dc3e3f6fcf91ad2a18@localhost> <CACRpkdbMjRzTVo6o-+z6mNNkKWp1mFL76ptKd8PFV8orgFLeOg@mail.gmail.com>
In-Reply-To: <CACRpkdbMjRzTVo6o-+z6mNNkKWp1mFL76ptKd8PFV8orgFLeOg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071216-9360-0000-0000-000008585C15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 03:56 AM, Linus Walleij wrote:
> On Thu, Jul 12, 2012 at 12:09 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>
>> On Thu, 12 Jul 2012 02:18:42 +0200, Linus Walleij
>> <linus.ml.walleij@gmail.com> wrote:
>>
>> Hi Linus,
>>
>>> I'm reviewing the only patch I really understand...
>>>
>>> 2012/7/6 Catalin Marinas <catalin.marinas@arm.com>:
>>>
>>>> +/* This isn't really used any more */
>>>> +#define CLOCK_TICK_RATE 1000
>>> Is it still necessary to even have it there?
>> It is used as part of the LATCH/TICK_* computation in
>> include/linux/jiffies.h. It seems that any value could do, actually, and it
>> only seem to be used in kernel/time/ntp.c. Any guidance on this much
>> appreciated.
>>
>> By the way, there is a very interesting comment about this in
>> arch/ia64/include/asm/timex.h.
> Hmmmm paging John Stultz, TGLX, Deepak Saxena who have been in
> this area...

Yea, its definitely crufty, but CLOCK_TICK_RATE is still important if 
you use the jiffies clocksource (usually in the case of hardware that 
does not support clocksources).

Basically its just trying to handle the cases where the time interval 
1sec/HZ  (for the various values of HZ) can not be accurately computed 
due to the granularity of the tick device.  In those cases we use 
CLOCK_TICK_RATE to figure out the granularity error and modify the 
length of a jiffie,  just slightly, so it matches the hardware.

Most architectures have some sort of copy-pasted version of i386's 
CLOCK_TICK_RATE (although I guess its possible some non-x86 systems 
might actually have an 8253 or similar timer) and since the move to 
GENERIC_TIME and clocksources, any incorrectly calculated error has very 
little effect on most hardware since its not used to track time.

So following ia64's method is probably better then copying the 8253's 
rate if you're not concerned about tick-granularity error.

thanks
-john


