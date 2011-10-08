Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1JHMiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 08:38:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55775 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab1JHMiO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 08:38:14 -0400
MIME-Version: 1.0
In-Reply-To: <201110071156.38283.arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
 <1317499438-14058-9-git-send-email-arnd@arndb.de> <CAMPhdO-tz2HgBYQGOUW6hrA6fC=x+CQJ3dwbW_0AazFB=cjvbA@mail.gmail.com>
 <201110071156.38283.arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 8 Oct 2011 20:37:53 +0800
Message-ID: <CAMPhdO97bJZ1FRHUq_VHQ8oHyY7U4ay-jv5Ft+gunRwtBvz8qw@mail.gmail.com>
Subject: Re: [PATCH 08/26] ARM: pxa: move z2 to generic cpu_suspend
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 5:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 07 October 2011, Eric Miao wrote:
>> commit 3f7961cbd3428c8639d42d1a51870466e4cbb0eb
>> Author: Eric Miao <eric.y.miao@gmail.com>
>> Date:   Sun Sep 11 17:19:11 2011 +0800
>>
>>     ARM: pxa/z2: fix building error of pxa27x_cpu_suspend() no longer available
>>
>>     Cc: Vasily Khoruzhick <anarsoul@gmail.com>
>>     Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
>>
>> diff --git a/arch/arm/mach-pxa/z2.c b/arch/arm/mach-pxa/z2.c
>> index 6c9275a..6fa4e74 100644
>> --- a/arch/arm/mach-pxa/z2.c
>> +++ b/arch/arm/mach-pxa/z2.c
>> @@ -679,6 +679,8 @@ static inline void z2_pmic_init(void) {}
>>  #endif
>>
>>  #ifdef CONFIG_PM
>> +extern void pxa27x_cpu_pm_enter(suspend_state_t state);
>> +
>>  static void z2_power_off(void)
>>  {
>>         /* We're using deep sleep as poweroff, so clear PSPR to ensure that
>
> You really shouldn't have an extern declaration in a .c file. Otherwise
> looks good to me.

How about this one?

diff --git a/arch/arm/mach-pxa/include/mach/pxa27x.h
b/arch/arm/mach-pxa/include/mach/pxa27x.h
index b9b1bdc..7cff640 100644
--- a/arch/arm/mach-pxa/include/mach/pxa27x.h
+++ b/arch/arm/mach-pxa/include/mach/pxa27x.h
@@ -1,6 +1,7 @@
 #ifndef __MACH_PXA27x_H
 #define __MACH_PXA27x_H

+#include <linux/suspend.h>
 #include <mach/hardware.h>
 #include <mach/pxa2xx-regs.h>
 #include <mach/mfp-pxa27x.h>
@@ -21,6 +22,7 @@
 extern void __init pxa27x_map_io(void);
 extern void __init pxa27x_init_irq(void);
 extern int __init pxa27x_set_pwrmode(unsigned int mode);
+extern void pxa27x_cpu_pm_enter(suspend_state_t state);

 #define pxa27x_handle_irq      ichp_handle_irq

diff --git a/arch/arm/mach-pxa/z2.c b/arch/arm/mach-pxa/z2.c
index 6c9275a..a82d420 100644
--- a/arch/arm/mach-pxa/z2.c
+++ b/arch/arm/mach-pxa/z2.c
@@ -686,7 +686,8 @@ static void z2_power_off(void)
         */
        PSPR = 0x0;
        local_irq_disable();
-       pxa27x_cpu_suspend(PWRMODE_DEEPSLEEP, PLAT_PHYS_OFFSET - PAGE_OFFSET);
+       pxa27x_set_pwrmode(PWRMODE_DEEPSLEEP);
+       pxa27x_cpu_pm_enter(PM_SUSPEND_MEM);
 }
 #else
 #define z2_power_off   NULL
