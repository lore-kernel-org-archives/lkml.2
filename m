Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab1BVP3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 10:29:15 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34353 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab1BVP3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 10:29:14 -0500
MIME-Version: 1.0
X-Originating-IP: [172.22.72.244]
In-Reply-To: <AANLkTi=pJw7oTUY2jmaSB=chds0fXFaA3+jrT=y8Jpzv@mail.gmail.com>
References: <1298342392-21236-1-git-send-email-ccross@android.com>
	<1298342392-21236-6-git-send-email-ccross@android.com>
	<AANLkTim=TZaqZFSJwOAN2gntvu=fiHVPQVn12=WyF9Wi@mail.gmail.com>
	<AANLkTi=pJw7oTUY2jmaSB=chds0fXFaA3+jrT=y8Jpzv@mail.gmail.com>
Date: Tue, 22 Feb 2011 07:28:29 -0800
Message-ID: <AANLkTi=Z=WRUaYY4H3JXxNtmQYHDu=p+SAU-QNFMbMuf@mail.gmail.com>
Subject: Re: [PATCH 5/7] ARM: tegra: timer: Enable timer and rtc clocks
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, konkers@android.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mike@compulab.co.il, Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 12:00 AM, Colin Cross <ccross@android.com> wrote:
> On Mon, Feb 21, 2011 at 9:32 PM, Olof Johansson <olof@lixom.net> wrote:
>> Hi,
>>
>>
>> On Mon, Feb 21, 2011 at 6:39 PM, Colin Cross <ccross@android.com> wrote:
>>> Enable the timer and rtc clocks to prevent them being
>>> turned off by the bootloader clock disabling code.
>>>
>>> Signed-off-by: Colin Cross <ccross@android.com>
>>> ---
>>>  arch/arm/mach-tegra/timer.c |   14 ++++++++++++--
>>>  1 files changed, 12 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-tegra/timer.c b/arch/arm/mach-tegra/timer.c
>>> index ffa6a68..31b4f56 100644
>>> --- a/arch/arm/mach-tegra/timer.c
>>> +++ b/arch/arm/mach-tegra/timer.c
>>> @@ -18,6 +18,7 @@
>>>  */
>>>
>>>  #include <linux/init.h>
>>> +#include <linux/err.h>
>>>  #include <linux/sched.h>
>>>  #include <linux/time.h>
>>>  #include <linux/interrupt.h>
>>> @@ -193,9 +194,20 @@ static struct irqaction tegra_timer_irq = {
>>>
>>>  static void __init tegra_init_timer(void)
>>>  {
>>> +       struct clk *clk;
>>>        unsigned long rate = clk_measure_input_freq();
>>>        int ret;
>>>
>>> +       clk = clk_get_sys("timer", NULL);
>>> +       BUG_ON(IS_ERR(clk));
>>> +       clk_enable(clk);
>>> +       clk_put(clk);
>>> +
>>> +       clk = clk_get_sys("rtc-tegra", NULL);
>>> +       BUG_ON(IS_ERR(clk));
>>> +       clk_enable(clk);
>>> +       clk_put(clk);
>>
>> Why initialize the rtc clock here? Not all boards use it and instead
>> use the rtc on the pmic. Seems wasteful to clock it unless the driver
>> for it is probed and configured.
>
> timekeeping_suspend uses read_persistent_clock and not the RTC driver
> to track time in suspend.  The Tegra implementation of
> read_persistent_clock reads from the internal RTC registers.  Its a 32
> kHz clock, so it's power usage is negligible, and it is required on
> all Tegra boards.

Ah, right. A short comment to that effect near the clock enablement
would be useful, but other than that:

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
