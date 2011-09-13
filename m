Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab1IMSYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:24:13 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:38841 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755856Ab1IMSYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:24:11 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Koyamangalath\, Abhilash" <abhilash.kv@ti.com>
Cc: "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony\@atomide.com" <tony@atomide.com>,
        "linux\@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Lohithakshan\, Ranjith" <ranjithl@ti.com>
Subject: Re: [PATCH 1/4] AM3517 : support for suspend/resume
Organization: Texas Instruments, Inc.
References: <1313754927-11992-1-git-send-email-abhilash.kv@ti.com>
	<1313754927-11992-2-git-send-email-abhilash.kv@ti.com>
	<87fwkild5k.fsf@ti.com>
	<FCCFB4CDC6E5564B9182F639FC356087037B3D8823@dbde02.ent.ti.com>
Date: Tue, 13 Sep 2011 11:24:05 -0700
In-Reply-To: <FCCFB4CDC6E5564B9182F639FC356087037B3D8823@dbde02.ent.ti.com>
	(Abhilash Koyamangalath's message of "Tue, 13 Sep 2011 17:01:01
	+0530")
Message-ID: <8739g0b8sa.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhilash,

"Koyamangalath, Abhilash" <abhilash.kv@ti.com> writes:

> Hi
>
> On Wed, Aug 31, 2011 at 4:28 AM, Hilman, Kevin wrote:
>>
>> Abhilash K V <abhilash.kv@ti.com> writes:
>>
>>> 1. Patch to disable dynamic sleep (as it is not supported
>>>    on AM35xx).
>>> 2. Imported the unique suspend/resume sequence for AM3517,
>>>    contained in the new file arch/arm/mach-omap2/sleep3517.S.
>>> 3. Added omap3517_ to symbol-names in sleep3517.S which are common
>>>    with sleep34xx.S, and added appropriate checks.
>>>
>>> There are still 3 caveats:
>>>
>>> 1. If "no_console_suspend" is enabled (via boot-args), the device
>>>    doesnot resume but simply hangs.
>>> 2. Every second and subsequent attempt to suspend/resume prints this slow-path
>>>    WARNING (for both uart1 and uart2), while resuming :
>>>    [   70.943939] omap_hwmod: uart1: idle state can only be entered from
>>>    enabled state
>>> 3. Wakeup using the TSC2004 touch-screen controller is not supported.
>>>
>>> Signed-off-by: Ranjith Lohithakshan <ranjithl@ti.com>
>>> Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
>>> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
>>
>> In addition to Russell's comments about using the latest code from
>> mainline, I have some comments below.
> [Abhilash K V] I have reworked the patch against the tip (as suggested by
> Russell).
> And I've incorporated all of Kevin's comments too.

Great, thanks!

> There is one "known" issue left which needs to be closed before I can submit v2 of this patch.
> With no_console_suspend, suspend to RAM hangs right now on AM3517, after
> the message:
>           Disabling non-boot CPUs ...
> There is no error message or dump.
> I found that this crash is happening in a call to pr_warning(), from _omap_device_deactivate().
> The same code does not produce this issue on omap34xx due to this snippet from omap_sram_idle() :
>         /* PER */
>         if (per_next_state < PWRDM_POWER_ON) {
>                 per_going_off = (per_next_state == PWRDM_POWER_OFF) ? 1 : 0;
>                 omap_uart_prepare_idle(2);
>                 omap_uart_prepare_idle(3);
>                 omap2_gpio_prepare_for_idle(per_going_off);
>                 if (per_next_state == PWRDM_POWER_OFF)
>                                 omap3_per_save_context();
>         }
>         /* CORE */
>         if (core_next_state < PWRDM_POWER_ON) {
>                 omap_uart_prepare_idle(0);
>                 omap_uart_prepare_idle(1);
>                 if (core_next_state == PWRDM_POWER_OFF) {
>                         omap3_core_save_context();
>                         omap3_cm_save_context();
>                 }
>         }
> This happens in preparation to the suspend operation (I,e. the WFI).
> As seen here, on 34xx the sequence in which the uarts are disabled is 2, 3, 0 and 1.The console-uart, which is uart-1 here (starting from uart-0) is disabled last.

> For AM3517 EVM, the console-uart is uart-2 and this ought to be
> disabled at the last to prevent this crash from occurring.

There are several other OMAP3 platforms (n900, Beagle, etc.) where the
UART console is also UART2, so console ordering is not the problem.

The fact that that pr_warning is making it to the console suggests that
the console is not locked.  In the idle path, we take the console lock
(using console_trylock(), just above the code you showed above.)

But during suspend, there was an assumption (by me[2]) that the console
would always be locked in the suspend path.  During no_console_suspend,
it appears that is not the case.

Can you try the patch below[1] to see if that fixes your problem?  I
think it should.

Kevin


[1]
>From 5b5a73101fcfa042d53828c017ee3149eae44b50 Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@ti.com>
Date: Tue, 13 Sep 2011 11:18:44 -0700
Subject: [PATCH] OMAP3: PM: fix UART handling when using no_console_suspend

During the idle/suspend path, we expect the console lock to be held so
that no console output is done during/after the UARTs are idled.

However, when using the no_console_suspend argument on the
command-line, the console driver does not take the console lock.  This
allows the possibility of console activity after UARTs have been
disabled.

To fix, update the current is_suspending() to also check the
console_suspend_enabled flag.

NOTE: this is short-term workaround until the OMAP serial driver
      is fully converted to use runtime PM.

Signed-off-by: Kevin Hilman <khilman@ti.com>
---
 arch/arm/mach-omap2/pm34xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 7255d9b..c8cbd00 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -55,7 +55,7 @@
 static suspend_state_t suspend_state = PM_SUSPEND_ON;
 static inline bool is_suspending(void)
 {
-	return (suspend_state != PM_SUSPEND_ON);
+	return (suspend_state != PM_SUSPEND_ON) && console_suspend_enabled;
 }
 #else
 static inline bool is_suspending(void)
-- 
1.7.6



[2]
commit e83df17f178360a8e7874441bca04a710c869e42
Author: Kevin Hilman <khilman@deeprootsystems.com>
Date:   Wed Dec 8 22:40:40 2010 +0000

    OMAP2+: PM/serial: fix console semaphore acquire during suspend
    
    commit 0d8e2d0dad98a693bad88aea6876ac8b94ad95c6 (OMAP2+: PM/serial:
    hold console semaphore while OMAP UARTs are disabled) added use of the
    console semaphore to protect UARTs from being accessed after disabled
    during idle, but this causes problems in suspend.
    
    During suspend, the console semaphore is acquired by the console
    suspend method (console_suspend()) so the try_acquire_console_sem()
    will always fail and suspend will be aborted.
    
    To fix, introduce a check so the console semaphore is only attempted
    during idle, and not during suspend.  Also use the same check so that
    the console semaphore is not prematurely released during resume.
    
    Thanks to Paul Walmsley for suggesting adding the same check during
    resume.
    
    Cc: Paul Walmsley <paul@pwsan.com>
    Tested-by: Jean Pihet <j-pihet@ti.com>
    Tested-by: Paul Walmsley <paul@pwsan.com>
    Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
    Signed-off-by: Tony Lindgren <tony@atomide.com>


