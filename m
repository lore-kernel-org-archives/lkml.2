Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab1INNDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 09:03:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33854 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab1INNDM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 09:03:12 -0400
From: "Koyamangalath, Abhilash" <abhilash.kv@ti.com>
To: "Hilman, Kevin" <khilman@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Lohithakshan, Ranjith" <ranjithl@ti.com>
Date: Wed, 14 Sep 2011 18:30:51 +0530
Subject: RE: [PATCH 1/4] AM3517 : support for suspend/resume
Thread-Topic: [PATCH 1/4] AM3517 : support for suspend/resume
Thread-Index: AcxyQleNXbiQscP0QIye7IkLjp/jygAm/yhR
Message-ID: <FCCFB4CDC6E5564B9182F639FC356087037AF843DD@dbde02.ent.ti.com>
References: <1313754927-11992-1-git-send-email-abhilash.kv@ti.com>
	<1313754927-11992-2-git-send-email-abhilash.kv@ti.com>
	<87fwkild5k.fsf@ti.com>
	<FCCFB4CDC6E5564B9182F639FC356087037B3D8823@dbde02.ent.ti.com>,<8739g0b8sa.fsf@ti.com>
In-Reply-To: <8739g0b8sa.fsf@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi  Kevin

On Tue, Sep 13, 2011 at 11:54 PM, Hilman, Kevin wrote:
> Hi Abhilash,
>
> "Koyamangalath, Abhilash" <abhilash.kv@ti.com> writes:
>
>> Hi
>>
>> On Wed, Aug 31, 2011 at 4:28 AM, Hilman, Kevin wrote:
>>>
>>> Abhilash K V <abhilash.kv@ti.com> writes:
>>>
<snip>
>>>
>>> In addition to Russell's comments about using the latest code from
>>> mainline, I have some comments below.
>> [Abhilash K V] I have reworked the patch against the tip (as suggested by
>> Russell).
>> And I've incorporated all of Kevin's comments too.
>
> Great, thanks!
>
>> There is one "known" issue left which needs to be closed before I can submit v2 of this patch.
>> With no_console_suspend, suspend to RAM hangs right now on AM3517, after
>> the message:
>>           Disabling non-boot CPUs ...
>> There is no error message or dump.
>> I found that this crash is happening in a call to pr_warning(), from _omap_device_deactivate().
>> The same code does not produce this issue on omap34xx due to this snippet from omap_sram_idle() :
>>         /* PER */
>>         if (per_next_state < PWRDM_POWER_ON) {
>>                 per_going_off = (per_next_state == PWRDM_POWER_OFF) ? 1 : 0;
>>                 omap_uart_prepare_idle(2);
>>                 omap_uart_prepare_idle(3);
>>                 omap2_gpio_prepare_for_idle(per_going_off);
>>                 if (per_next_state == PWRDM_POWER_OFF)
>>                                 omap3_per_save_context();
>>         }
>>         /* CORE */
>>         if (core_next_state < PWRDM_POWER_ON) {
>>                 omap_uart_prepare_idle(0);
>>                 omap_uart_prepare_idle(1);
>>                 if (core_next_state == PWRDM_POWER_OFF) {
>>                         omap3_core_save_context();
>>                         omap3_cm_save_context();
>>                 }
>>         }
>> This happens in preparation to the suspend operation (I,e. the WFI).
>> As seen here, on 34xx the sequence in which the uarts are disabled is 2, 3, 0 and 1.The console-uart, which is uart-1 here (starting from uart-0) is disabled last.
>
>> For AM3517 EVM, the console-uart is uart-2 and this ought to be
>> disabled at the last to prevent this crash from occurring.
>
> There are several other OMAP3 platforms (n900, Beagle, etc.) where the
> UART console is also UART2, so console ordering is not the problem.
[Abhilash K V]  OK. Yet changing the order so that uart-2 is disabled at the last
seems to rid me of the crash on AM35x. 
I understand that holding the console_sem before suspend (your fix below) is the
way to go, but I'm just curious over what's happening here.
Simply put what is the rationale behind choosing this order of UART-disables ?

>
> The fact that that pr_warning is making it to the console suggests that
> the console is not locked.  In the idle path, we take the console lock
> (using console_trylock(), just above the code you showed above.)
>
> But during suspend, there was an assumption (by me[2]) that the console
> would always be locked in the suspend path.  During no_console_suspend,
> it appears that is not the case.
>
> Can you try the patch below[1] to see if that fixes your problem?  I
> think it should.
[Abhilash K V] Yes it does, thanks.
>
> Kevin
>
>
> [1]
> From 5b5a73101fcfa042d53828c017ee3149eae44b50 Mon Sep 17 00:00:00 2001
> From: Kevin Hilman <khilman@ti.com>
> Date: Tue, 13 Sep 2011 11:18:44 -0700
> Subject: [PATCH] OMAP3: PM: fix UART handling when using no_console_suspend
>
> During the idle/suspend path, we expect the console lock to be held so
> that no console output is done during/after the UARTs are idled.
>
> However, when using the no_console_suspend argument on the
> command-line, the console driver does not take the console lock.  This
> allows the possibility of console activity after UARTs have been
> disabled.
>
> To fix, update the current is_suspending() to also check the
> console_suspend_enabled flag.
>
> NOTE: this is short-term workaround until the OMAP serial driver
>      is fully converted to use runtime PM.
>
> Signed-off-by: Kevin Hilman <khilman@ti.com>
> ---
>  arch/arm/mach-omap2/pm34xx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
> index 7255d9b..c8cbd00 100644
> --- a/arch/arm/mach-omap2/pm34xx.c
> +++ b/arch/arm/mach-omap2/pm34xx.c
> @@ -55,7 +55,7 @@
>  static suspend_state_t suspend_state = PM_SUSPEND_ON;
>  static inline bool is_suspending(void)
>  {
> -       return (suspend_state != PM_SUSPEND_ON);
> +       return (suspend_state != PM_SUSPEND_ON) && console_suspend_enabled;
>  }
>  #else
>  static inline bool is_suspending(void)
> --
> 1.7.6
>
>
>
> [2]
> commit e83df17f178360a8e7874441bca04a710c869e42
> Author: Kevin Hilman <khilman@deeprootsystems.com>
> Date:   Wed Dec 8 22:40:40 2010 +0000
>
>    OMAP2+: PM/serial: fix console semaphore acquire during suspend
>
>    commit 0d8e2d0dad98a693bad88aea6876ac8b94ad95c6 (OMAP2+: PM/serial:
>    hold console semaphore while OMAP UARTs are disabled) added use of the
>    console semaphore to protect UARTs from being accessed after disabled
>    during idle, but this causes problems in suspend.
>
>    During suspend, the console semaphore is acquired by the console
>    suspend method (console_suspend()) so the try_acquire_console_sem()
>    will always fail and suspend will be aborted.
>
>    To fix, introduce a check so the console semaphore is only attempted
>    during idle, and not during suspend.  Also use the same check so that
>    the console semaphore is not prematurely released during resume.
>
>    Thanks to Paul Walmsley for suggesting adding the same check during
>    resume.
>
>    Cc: Paul Walmsley <paul@pwsan.com>
>    Tested-by: Jean Pihet <j-pihet@ti.com>
>    Tested-by: Paul Walmsley <paul@pwsan.com>
>    Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
>    Signed-off-by: Tony Lindgren <tony@atomide.com>
>
>
>

