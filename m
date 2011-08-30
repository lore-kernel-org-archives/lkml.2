Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab1H3W64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:58:56 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:42302 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753274Ab1H3W6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:58:52 -0400
From: Kevin Hilman <khilman@ti.com>
To: Abhilash K V <abhilash.kv@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        Ranjith Lohithakshan <ranjithl@ti.com>
Subject: Re: [PATCH 1/4] AM3517 : support for suspend/resume
Organization: Texas Instruments, Inc.
References: <1313754927-11992-1-git-send-email-abhilash.kv@ti.com>
	<1313754927-11992-2-git-send-email-abhilash.kv@ti.com>
Date: Tue, 30 Aug 2011 15:58:47 -0700
In-Reply-To: <1313754927-11992-2-git-send-email-abhilash.kv@ti.com> (Abhilash
	K. V.'s message of "Fri, 19 Aug 2011 17:25:24 +0530")
Message-ID: <87fwkild5k.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhilash K V <abhilash.kv@ti.com> writes:

> 1. Patch to disable dynamic sleep (as it is not supported
>    on AM35xx).
> 2. Imported the unique suspend/resume sequence for AM3517,
>    contained in the new file arch/arm/mach-omap2/sleep3517.S.
> 3. Added omap3517_ to symbol-names in sleep3517.S which are common
>    with sleep34xx.S, and added appropriate checks.
>
> There are still 3 caveats:
>
> 1. If "no_console_suspend" is enabled (via boot-args), the device
>    doesnot resume but simply hangs.
> 2. Every second and subsequent attempt to suspend/resume prints this slow-path
>    WARNING (for both uart1 and uart2), while resuming :
>    [   70.943939] omap_hwmod: uart1: idle state can only be entered from
>    enabled state
> 3. Wakeup using the TSC2004 touch-screen controller is not supported.
>
> Signed-off-by: Ranjith Lohithakshan <ranjithl@ti.com>
> Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>

In addition to Russell's comments about using the latest code from
mainline, I have some comments below.


> ---
>  arch/arm/mach-omap2/Makefile    |    2 +-
>  arch/arm/mach-omap2/control.c   |    7 ++-
>  arch/arm/mach-omap2/control.h   |    1 +
>  arch/arm/mach-omap2/pm.h        |    4 +
>  arch/arm/mach-omap2/pm34xx.c    |   18 ++++-
>  arch/arm/mach-omap2/sleep3517.S |  144 +++++++++++++++++++++++++++++++++++++++
>  6 files changed, 170 insertions(+), 6 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/sleep3517.S
>
> diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
> index 46f5fbc..3fdf086 100644
> --- a/arch/arm/mach-omap2/Makefile
> +++ b/arch/arm/mach-omap2/Makefile
> @@ -61,7 +61,7 @@ endif
>  ifeq ($(CONFIG_PM),y)
>  obj-$(CONFIG_ARCH_OMAP2)		+= pm24xx.o
>  obj-$(CONFIG_ARCH_OMAP2)		+= sleep24xx.o
> -obj-$(CONFIG_ARCH_OMAP3)		+= pm34xx.o sleep34xx.o \
> +obj-$(CONFIG_ARCH_OMAP3)		+= pm34xx.o sleep34xx.o sleep3517.o \
>  					   cpuidle34xx.o
>  obj-$(CONFIG_ARCH_OMAP4)		+= pm44xx.o
>  obj-$(CONFIG_PM_DEBUG)			+= pm-debug.o
> diff --git a/arch/arm/mach-omap2/control.c b/arch/arm/mach-omap2/control.c
> index da53ba3..7d2d8a8 100644
> --- a/arch/arm/mach-omap2/control.c
> +++ b/arch/arm/mach-omap2/control.c
> @@ -284,10 +284,13 @@ void omap3_save_scratchpad_contents(void)
>  	 * The restore pointer is stored into the scratchpad.
>  	 */
>  	scratchpad_contents.boot_config_ptr = 0x0;
> -	if (cpu_is_omap3630())
> +	if (cpu_is_omap3505() || cpu_is_omap3517()) {
> +		scratchpad_contents.public_restore_ptr =
> +			virt_to_phys(omap3517_get_restore_pointer());

Based on the contents of the get_restore_pointer() added below, this
value is obviously not being used.  Either off-mode was not tested (or not
supported.)   Either way, unused code like this should not be
added if it is not tested or supported.

> +	} else if (cpu_is_omap3630()) {
>  		scratchpad_contents.public_restore_ptr =
>  			virt_to_phys(get_omap3630_restore_pointer());
> -	else if (omap_rev() != OMAP3430_REV_ES3_0 &&
> +	} else if (omap_rev() != OMAP3430_REV_ES3_0 &&
>  					omap_rev() != OMAP3430_REV_ES3_1)
>  		scratchpad_contents.public_restore_ptr =
>  			virt_to_phys(get_restore_pointer());
> diff --git a/arch/arm/mach-omap2/control.h b/arch/arm/mach-omap2/control.h
> index ad024df..3003940 100644
> --- a/arch/arm/mach-omap2/control.h
> +++ b/arch/arm/mach-omap2/control.h
> @@ -389,6 +389,7 @@ extern void omap4_ctrl_pad_writel(u32 val, u16 offset);
>  extern void omap3_save_scratchpad_contents(void);
>  extern void omap3_clear_scratchpad_contents(void);
>  extern u32 *get_restore_pointer(void);
> +extern u32 *omap3517_get_restore_pointer(void);
>  extern u32 *get_es3_restore_pointer(void);
>  extern u32 *get_omap3630_restore_pointer(void);
>  extern u32 omap3_arm_context[128];
> diff --git a/arch/arm/mach-omap2/pm.h b/arch/arm/mach-omap2/pm.h
> index 5c2bd2f..d773e07 100644
> --- a/arch/arm/mach-omap2/pm.h
> +++ b/arch/arm/mach-omap2/pm.h
> @@ -77,13 +77,17 @@ extern void omap24xx_idle_loop_suspend(void);
>  extern void omap24xx_cpu_suspend(u32 dll_ctrl, void __iomem *sdrc_dlla_ctrl,
>  					void __iomem *sdrc_power);
>  extern void omap34xx_cpu_suspend(u32 *addr, int save_state);
> +extern void omap3517_cpu_suspend(u32 *addr, int save_state);
>  extern int save_secure_ram_context(u32 *addr);
> +extern void omap3517_save_secure_ram_context(u32 *addr);
>  extern void omap3_save_scratchpad_contents(void);
>  
>  extern unsigned int omap24xx_idle_loop_suspend_sz;
>  extern unsigned int save_secure_ram_context_sz;
> +extern unsigned int omap3517_save_secure_ram_context_sz;
>  extern unsigned int omap24xx_cpu_suspend_sz;
>  extern unsigned int omap34xx_cpu_suspend_sz;
> +extern unsigned int omap3517_cpu_suspend_sz;
>  
>  #define PM_RTA_ERRATUM_i608		(1 << 0)
>  #define PM_SDRC_WAKEUP_ERRATUM_i583	(1 << 1)
> diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
> index 96a7624..12af5b9 100644
> --- a/arch/arm/mach-omap2/pm34xx.c
> +++ b/arch/arm/mach-omap2/pm34xx.c
> @@ -497,6 +497,8 @@ console_still_active:
>  
>  int omap3_can_sleep(void)
>  {
> +	if (cpu_is_omap3505() || cpu_is_omap3517())
> +		return 0;
>  	if (!omap_uart_can_sleep())
>  		return 0;
>  	return 1;
> @@ -848,11 +850,21 @@ static int __init clkdms_setup(struct clockdomain *clkdm, void *unused)
>  
>  void omap_push_sram_idle(void)
>  {
> -	_omap_sram_idle = omap_sram_push(omap34xx_cpu_suspend,
> +	if (cpu_is_omap3505() || cpu_is_omap3517())
> +		_omap_sram_idle = omap_sram_push(omap3517_cpu_suspend,
> +					omap3517_cpu_suspend_sz);
> +	else
> +		_omap_sram_idle = omap_sram_push(omap34xx_cpu_suspend,
>  					omap34xx_cpu_suspend_sz);
>  	if (omap_type() != OMAP2_DEVICE_TYPE_GP)
> -		_omap_save_secure_sram = omap_sram_push(save_secure_ram_context,
> -				save_secure_ram_context_sz);
> +		if (cpu_is_omap3505() || cpu_is_omap3517())
> +			_omap_save_secure_sram = omap_sram_push(
> +					omap3517_save_secure_ram_context,
> +					omap3517_save_secure_ram_context_sz);
> +		else
> +			_omap_save_secure_sram = omap_sram_push(
> +					save_secure_ram_context,
> +					save_secure_ram_context_sz);
>  }

You add a new assembly function for save secure context, but that
function is essentially a nop.

It would be better to just not have a function for these devices.

To that end, it would help to add an OMAP "feature" stating whether or
not the device has secure RAM.  Then, instead of the cpu_is_* checks
here, that feature flag can be checked.

>  
>  static void __init pm_errata_configure(void)
> diff --git a/arch/arm/mach-omap2/sleep3517.S b/arch/arm/mach-omap2/sleep3517.S
> new file mode 100644
> index 0000000..3fceefc
> --- /dev/null
> +++ b/arch/arm/mach-omap2/sleep3517.S
> @@ -0,0 +1,144 @@
> +/*
> +/* linux/arch/arm/mach-omap2/sleep3517.S

You can leave out filenames in comments.  Files tend to move, and the
comments don't get changed and become stale.

Kevin
