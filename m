Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab1IVVzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:55:12 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:47556 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461Ab1IVVzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:55:10 -0400
From: Kevin Hilman <khilman@ti.com>
To: Abhilash K V <abhilash.kv@ti.com>
Cc: <linux-omap@vger.kernel.org>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <aneesh@ti.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Ranjith Lohithakshan <ranjithl@ti.com>
Subject: Re: [PATCH v2] AM3517 : support for suspend/resume
Organization: Texas Instruments, Inc.
References: <1316008126-7322-1-git-send-email-abhilash.kv@ti.com>
Date: Thu, 22 Sep 2011 14:55:04 -0700
In-Reply-To: <1316008126-7322-1-git-send-email-abhilash.kv@ti.com> (Abhilash
	K. V.'s message of "Wed, 14 Sep 2011 19:18:46 +0530")
Message-ID: <87obycqm2v.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhilash K V <abhilash.kv@ti.com> writes:

> This patch-set adds support for suspension to RAM and
> resumption on the AM3517. This includes:
> 1. Patch to disable dynamic sleep (as it is not supported
>    on AM35xx).

This should still be a separate patch, with justification.  More on this
below.

> 2. Imported the unique suspend/resume sequence for AM3517,
>    contained in the new file arch/arm/mach-omap2/sleep3517.S.
>
> Caveat: If "no_console_suspend" is enabled (via boot-args),the
> device doesnot resume but simply hangs.
> Kevin's fix below should fix this:
>  http://marc.info/?l=linux-omap&m=131593828001388&w=2#1

should fix?  I assumed you tested it along with this.

> Signed-off-by: Ranjith Lohithakshan <ranjithl@ti.com>
> Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
> ---
> This patch is dependent on the following patch-sets:
> * [PATCH v3 0/2] AM3517: Booting up
>   at http://marc.info/?l=linux-omap&m=131548349725176&w=2
> * [PATCH v2 0/3] AM35x: Adding PM init
>   at http://marc.info/?l=linux-kernel&m=131548606728209&w=2
>
> The patches are tested on master of tmlind/linux-omap-2.6.git.
> Kernel version is 3.1-rc3 and last commit on top of which these patches
> were added is:
> 	b148d763841161894ed6629794064065a834aa2b: Linux-omap rebuilt: Updated to
> 	use omap_sdrc_init
>
> with the folowing commit reverted:
> 	f3637a5f2e2eb391ff5757bc83fb5de8f9726464: irq: Always set IRQF_ONESHOT
> 	if no primary handler is specified
>
> Changes in v2:
>  * Synchronised with the cleaned-up suspend-resume code for OMAP3
>  * Removed unused *_get_restore_pointer code
>  * Added SECURE_SRAM feature to disallow saving and restoring
>    secure ram context for AM35x

Adding a new feature flag should be a separate patch.

>  * Compacted the number of patches by squashing three closely coupled
>    ones and eliminating one that was no longer needed.
>
>  arch/arm/mach-omap2/Makefile          |    3 +-
>  arch/arm/mach-omap2/id.c              |    4 +-
>  arch/arm/mach-omap2/pm.h              |    3 +
>  arch/arm/mach-omap2/pm34xx.c          |   21 ++++-
>  arch/arm/mach-omap2/sleep3517.S       |  156 +++++++++++++++++++++++++++++++++
>  arch/arm/plat-omap/include/plat/cpu.h |    2 +
>  6 files changed, 183 insertions(+), 6 deletions(-)
>  create mode 100644 arch/arm/mach-omap2/sleep3517.S
>
> diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
> index 590e797..37f62ae 100644
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
> @@ -70,6 +70,7 @@ obj-$(CONFIG_OMAP_SMARTREFLEX_CLASS3)	+= smartreflex-class3.o
>  
>  AFLAGS_sleep24xx.o			:=-Wa,-march=armv6
>  AFLAGS_sleep34xx.o			:=-Wa,-march=armv7-a$(plus_sec)
> +AFLAGS_sleep3517.o			:=-Wa,-march=armv7-a$(plus_sec)
>  
>  ifeq ($(CONFIG_PM_VERBOSE),y)
>  CFLAGS_pm_bus.o				+= -DDEBUG
> diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
> index da71098..3e40c02 100644
> --- a/arch/arm/mach-omap2/id.c
> +++ b/arch/arm/mach-omap2/id.c
> @@ -202,7 +202,9 @@ static void __init omap3_check_features(void)
>  	if (cpu_is_omap3630())
>  		omap_features |= OMAP3_HAS_192MHZ_CLK;
>  	if (!cpu_is_omap3505() && !cpu_is_omap3517())
> -		omap_features |= (OMAP3_HAS_IO_WAKEUP | OMAP3_HAS_SR);
> +		omap_features |= (OMAP3_HAS_IO_WAKEUP
> +					| OMAP3_HAS_SR
> +					| OMAP3_HAS_SECURE_SRAM);

This is not related to suspend either, and should probably be part of
the bootup series.

The HAS_SECURE_SRAM part should be added to the separate patch that adds
this new feature flag.

>  	omap_features |= OMAP3_HAS_SDRC;
>  
> diff --git a/arch/arm/mach-omap2/pm.h b/arch/arm/mach-omap2/pm.h
> index ce028f6..952eb2b 100644
> --- a/arch/arm/mach-omap2/pm.h
> +++ b/arch/arm/mach-omap2/pm.h
> @@ -82,10 +82,13 @@ extern unsigned int omap24xx_cpu_suspend_sz;
>  
>  /* 3xxx */
>  extern void omap34xx_cpu_suspend(int save_state);
> +extern void omap3517_cpu_suspend(int save_state);
>  
>  /* omap3_do_wfi function pointer and size, for copy to SRAM */
>  extern void omap3_do_wfi(void);
> +extern void omap3517_do_wfi(void);
>  extern unsigned int omap3_do_wfi_sz;
> +extern unsigned int omap3517_do_wfi_sz;
>  /* ... and its pointer from SRAM after copy */
>  extern void (*omap3_do_wfi_sram)(void);
>  
> diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
> index 7255d9b..44f7bac 100644
> --- a/arch/arm/mach-omap2/pm34xx.c
> +++ b/arch/arm/mach-omap2/pm34xx.c
> @@ -80,6 +80,7 @@ static LIST_HEAD(pwrst_list);
>  
>  static int (*_omap_save_secure_sram)(u32 *addr);
>  void (*omap3_do_wfi_sram)(void);
> +void (*omap3517_do_wfi_sram)(void);
>  
>  static struct powerdomain *mpu_pwrdm, *neon_pwrdm;
>  static struct powerdomain *core_pwrdm, *per_pwrdm;
> @@ -323,7 +324,10 @@ static void omap34xx_save_context(u32 *save)
>  
>  static int omap34xx_do_sram_idle(unsigned long save_state)
>  {
> -	omap34xx_cpu_suspend(save_state);
> +	if (cpu_is_omap3505() || cpu_is_omap3517())
> +		omap3517_cpu_suspend(save_state);
> +	else
> +		omap34xx_cpu_suspend(save_state);

We don't want cpu_is_* checks at runtime.  Make this a function pointer
that is initialized at init time based on SoC.

>  	return 0;
>  }
>  
> @@ -485,6 +489,8 @@ console_still_active:
>  
>  int omap3_can_sleep(void)
>  {
> +	if (cpu_is_omap3505() || cpu_is_omap3517())
> +		return 0;

This needs to be a separate patch with a descriptive changelog and
justification as to why you can't do WFI in idle.

Adding something like this means the device will *never* attempt a WFI
during idle.  

I suspect that avoiding WFI in idle is masking a bug that you don't see
in the suspend path.

>  	if (!omap_uart_can_sleep())
>  		return 0;
>  	return 1;
> @@ -843,11 +849,18 @@ static int __init clkdms_setup(struct clockdomain *clkdm, void *unused)
>   */
>  void omap_push_sram_idle(void)
>  {
> -	omap3_do_wfi_sram = omap_sram_push(omap3_do_wfi, omap3_do_wfi_sz);
> +	if (cpu_is_omap3505() || cpu_is_omap3517())
> +		omap3517_do_wfi_sram = omap_sram_push(omap3517_do_wfi,
> +						 omap3517_do_wfi_sz);
> +	else
> +		omap3_do_wfi_sram = omap_sram_push(omap3_do_wfi,
> +						 omap3_do_wfi_sz);
>  
>  	if (omap_type() != OMAP2_DEVICE_TYPE_GP)
> -		_omap_save_secure_sram = omap_sram_push(save_secure_ram_context,
> -				save_secure_ram_context_sz);
> +		if (omap3_has_secure_sram())
> +			_omap_save_secure_sram = omap_sram_push(
> +						save_secure_ram_context,
> +						save_secure_ram_context_sz);

This should be part of the separate patch that add the secure SRAM
feature flag.

Kevin
