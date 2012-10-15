Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab2JOPw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 11:52:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44803 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab2JOPw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 11:52:28 -0400
Message-ID: <507C3125.70702@ti.com>
Date: Mon, 15 Oct 2012 10:52:05 -0500
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nishanth Menon <nm@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linus.walleij@stericsson.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Will Deacon <will.deacon@arm.com>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Subject: Re: [PATCH] Boottime: A tool for automatic measurement of kernel/bootloader
 boot time
References: <1349966545-19340-1-git-send-email-lee.jones@linaro.org> <20121012134542.GH12567@gmail.com> <20121012134813.GK21164@n2100.arm.linux.org.uk> <201210121353.16798.arnd@arndb.de> <20121012140149.GJ12567@gmail.com> <50784729.4030302@ti.com> <20121012164221.GN12567@gmail.com>
In-Reply-To: <20121012164221.GN12567@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/12/2012 11:42 AM, Lee Jones wrote:
> On Fri, 12 Oct 2012, Dan Murphy wrote:
>
>> On 10/12/2012 09:01 AM, Lee Jones wrote:
>>> On Fri, 12 Oct 2012, Arnd Bergmann wrote:
>>>
>>>> On Friday 12 October 2012, Russell King - ARM Linux wrote:
>>>>>> root@ME:/ cat /sys/kernel/debug/boottime/bootgraph
>>>>>> [    0.185254] calling  splash+0x0/0x0
>>>>>> [    2.984335] initcall splash+0x0/0x0 returned 0 after 2799 msecs.
>>>>>> [    2.984335] calling  autoboot_delay+0x0/0x0
>>>>>> [    4.089513] initcall autoboot_delay+0x0/0x0 returned 0 after 1105 msecs.
>>>>>> [    4.089513] calling  load_kernel+0x0/0x0
>>>>>> [    4.239174] initcall load_kernel+0x0/0x0 returned 0 after 149 msecs.
>>>>>> [    4.239174] calling  boot_kernel+0x0/0x0
>>>>>> [    4.276260] initcall boot_kernel+0x0/0x0 returned 0 after 37 msecs.
>>>>>> [    4.276260] calling  uncompress_ll_init+0x0/0x0
>>>>>> [    4.276260] initcall uncompress_ll_init+0x0/0x0 returned 0 after 0 msecs.
>>>>>> [    4.276260] Freeing init memory: 0K
>>>>> Umm, what happened to sysfs not becoming procfs v2?  I thought we had
>>>>> a fairly strict requirement for "one value per file and not nicely
>>>>> formatted" for sysfs?
>>>>>
>>>> I was thinking the same thing at first, but then I noticed it's actually
>>>> debugfs, which has no such rules.
>>> Right. :)
>>>
>> OK I don't see when boottime_activate is called.
>>
>> Where would this call actually be made from?
>>
>> I see the call to deactivate but no call to activate.
> Here perhaps (Jonas, alerted me to the missing patch):
>
> commit 4c49a18bcfd2d041cbad7f41c6e6b39d90008382 (HEAD, refs/heads/dt-snowball-pre-rc1)
> Author: Jonas Aaberg<jonas.aberg@stericsson.com>
> Date:   Wed Sep 14 09:29:20 2011 +0200
>
>      drivers: clocksource: dbx500-prcmu: Add boottime support
>
>      Change-Id: I9b5e3d050131c08c08786ae84cb76619c0525049
>      Signed-off-by: Jonas Aaberg<jonas.aberg@stericsson.com>
>      Reviewed-on: http://gerrit.lud.stericsson.com/gerrit/32055
>
> diff --git a/drivers/clocksource/clksrc-dbx500-prcmu.c b/drivers/clocksource/clksrc-dbx500-prcmu.c
> index c26c369..0069cd9 100644
> --- a/drivers/clocksource/clksrc-dbx500-prcmu.c
> +++ b/drivers/clocksource/clksrc-dbx500-prcmu.c
> @@ -14,6 +14,7 @@
>    */
>   #include<linux/clockchips.h>
>   #include<linux/clksrc-dbx500-prcmu.h>
> +#include<linux/boottime.h>
>
>   #include<asm/sched_clock.h>
>
> @@ -68,6 +69,23 @@ static u32 notrace dbx500_prcmu_sched_clock_read(void)
>
>   #endif
>
> +#ifdef CONFIG_BOOTTIME
> +static unsigned long __init boottime_get_time(void)
> +{
> +	return div_s64(clocksource_cyc2ns(clocksource_dbx500_prcmu.read(
> +						&clocksource_dbx500_prcmu),
> +					  clocksource_dbx500_prcmu.mult,
> +					  clocksource_dbx500_prcmu.shift),
> +		       1000);
> +}
> +
> +static struct boottime_timer __initdata boottime_timer = {
> +	.init     = NULL,
> +	.get_time = boottime_get_time,
> +	.finalize = NULL,
> +};
> +#endif
> +
>   void __init clksrc_dbx500_prcmu_init(void __iomem *base)
>   {
>   	clksrc_dbx500_timer_base = base;
> @@ -90,4 +108,6 @@ void __init clksrc_dbx500_prcmu_init(void __iomem *base)
>   			 32, RATE_32K);
>   #endif
>   	clocksource_register_hz(&clocksource_dbx500_prcmu, RATE_32K);
> +
> +	boottime_activate(&boottime_timer);
>   }
>

OK So has this been validated and tested on any other IC then a ST part?
This boottime_activate patch seems to be only for the dbx500.  If this 
is supposed to be a generic solution I would expect
a generic patch for ARM to enable boot time activation.

Have you profiled how much time the boot time logging has added to the 
over all boot?
Also the boottime commit message should explain a little more what it is 
measuring.
i.e.  This patch enables logging the boot time from point x to point y 
for the kernel only.  This does not include init.

What about adding the boot time from the init sequence to init complete?

