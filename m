Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1BVIAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:00:33 -0500
Received: from smtp-out.google.com ([74.125.121.67]:37217 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1BVIAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:00:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kgqpyKV79Ifz2F5u7jkxniVLKw2zBZ37bya0A2oxljjZluRMMPZLNSHs0UXGuQo/Ue
         dQI4lGEG+FcLpWG6JMXA==
MIME-Version: 1.0
In-Reply-To: <AANLkTim=TZaqZFSJwOAN2gntvu=fiHVPQVn12=WyF9Wi@mail.gmail.com>
References: <1298342392-21236-1-git-send-email-ccross@android.com>
	<1298342392-21236-6-git-send-email-ccross@android.com>
	<AANLkTim=TZaqZFSJwOAN2gntvu=fiHVPQVn12=WyF9Wi@mail.gmail.com>
Date: Tue, 22 Feb 2011 00:00:25 -0800
X-Google-Sender-Auth: hMis9uTpOgBa8b6vqrOG3zdSdBY
Message-ID: <AANLkTi=pJw7oTUY2jmaSB=chds0fXFaA3+jrT=y8Jpzv@mail.gmail.com>
Subject: Re: [PATCH 5/7] ARM: tegra: timer: Enable timer and rtc clocks
From: Colin Cross <ccross@android.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-tegra@vger.kernel.org, konkers@android.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mike@compulab.co.il, Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 9:32 PM, Olof Johansson <olof@lixom.net> wrote:
> Hi,
>
>
> On Mon, Feb 21, 2011 at 6:39 PM, Colin Cross <ccross@android.com> wrote:
>> Enable the timer and rtc clocks to prevent them being
>> turned off by the bootloader clock disabling code.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>> ---
>>  arch/arm/mach-tegra/timer.c |   14 ++++++++++++--
>>  1 files changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-tegra/timer.c b/arch/arm/mach-tegra/timer.c
>> index ffa6a68..31b4f56 100644
>> --- a/arch/arm/mach-tegra/timer.c
>> +++ b/arch/arm/mach-tegra/timer.c
>> @@ -18,6 +18,7 @@
>>  */
>>
>>  #include <linux/init.h>
>> +#include <linux/err.h>
>>  #include <linux/sched.h>
>>  #include <linux/time.h>
>>  #include <linux/interrupt.h>
>> @@ -193,9 +194,20 @@ static struct irqaction tegra_timer_irq = {
>>
>>  static void __init tegra_init_timer(void)
>>  {
>> +       struct clk *clk;
>>        unsigned long rate = clk_measure_input_freq();
>>        int ret;
>>
>> +       clk = clk_get_sys("timer", NULL);
>> +       BUG_ON(IS_ERR(clk));
>> +       clk_enable(clk);
>> +       clk_put(clk);
>> +
>> +       clk = clk_get_sys("rtc-tegra", NULL);
>> +       BUG_ON(IS_ERR(clk));
>> +       clk_enable(clk);
>> +       clk_put(clk);
>
> Why initialize the rtc clock here? Not all boards use it and instead
> use the rtc on the pmic. Seems wasteful to clock it unless the driver
> for it is probed and configured.

timekeeping_suspend uses read_persistent_clock and not the RTC driver
to track time in suspend.  The Tegra implementation of
read_persistent_clock reads from the internal RTC registers.  Its a 32
kHz clock, so it's power usage is negligible, and it is required on
all Tegra boards.
