Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab2BBTnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:43:03 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53992 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab2BBTnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:43:00 -0500
Date: Thu, 2 Feb 2012 12:42:58 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Cc: linux-omap@vger.kernel.org, khilman@ti.com, tony@atomide.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9 00/25] gpio/omap: driver cleanup and fixes
Message-ID: <20120202194258.GU15343@ponder.secretlab.ca>
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 11:00:26PM +0530, Tarun Kanti DebBarma wrote:
> The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:
>   Linus Torvalds (1):
>         Linux 3.3-rc2
> 
> are available in the git repository at:
> http://gitorious.org/~tarunkanti/omap-sw-develoment/tarunkantis-linux-omap-dev
> Branch: for_3.4/gpio_cleanup_fixes_v9

Bad git url.  I had to replace 'http:' with 'git:'.

I've merged this series into my gpio/next branch.  It should show up in
linux-next in a couple of days.

g.

> 
> This series is continuation of cleanup of OMAP GPIO driver and fixes.
> The cleanup include getting rid of cpu_is_* checks wherever possible,
> use of gpio_bank list instead of static array, use of unique platform
> specific value associated data member to OMAP platforms to avoid
> cpu_is_* checks. The series also include PM runtime support.
> 
> Power Tests
> a) OMAP3430SDP
> - Modify board-3430sdp.c file to have multiple GPIO modules active
>   with debounce timeout enabled.
> - Enable CPU-Idle
> - Enable UART timeouts
> - Enable offmode
> - echo mem > /sys/power/state
> - Verify retention and offmode count increment
> 
>   Used following patches to avoid exception during system suspend:-
>   [PATCH RFC 1/2] mtd : Prevent the NULL pointer access
>   [PATCH RFC 2/2] mtd : Make the mtd_suspend return 0 if the suspend is not implemented
> 
> # echo mem > /sys/power/state
> [   47.128021] PM: Syncing filesystems ... done.
> [   47.144104] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [   47.168243] Freezing remaining freezable tasks ... (elapsed 0.02 seconds) don                                                                                                 e.
> [   47.205139] Unable to handle kernel NULL pointer dereference at virtual addre                                                                                                 ss 000000a0
> [   47.213317] pgd = deaac000
> [   47.216033] [000000a0] *pgd=9e932831, *pte=00000000, *ppte=00000000
> [   47.222381] Internal error: Oops: 17 [#1] SMP
> [   47.226745] Modules linked in:
> [   47.229827] CPU: 0    Not tainted  (3.3.0-rc2-00031-g12c5c5c #235)
> [   47.236022] PC is at mtd_cls_suspend+0x8/0x20
> [   47.240386] LR is at mtd_cls_suspend+0x8/0x20
> [   47.244750] pc : [<c02e78f8>]    lr : [<c02e78f8>]    psr: a0000013
> [   47.244750] sp : dea1fe60  ip : 22222222  fp : c0ee7d40
> [   47.256256] r10: c0ee7cf0  r9 : 00000000  r8 : c02e78f0
> [   47.261474] r7 : 00000000  r6 : 00000000  r5 : 00000002  r4 : dea45800
> [   47.268005] r3 : deb4cac0  r2 : 00000000  r1 : 00000002  r0 : 00000000
> [   47.274536] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [   47.281677] Control: 10c5387d  Table: 9eaac019  DAC: 00000015
> [   47.287445] Process sh (pid: 1177, stack limit = 0xdea1e2f8)
> [   47.293090] Stack: (0xdea1fe60 to 0xdea20000)
> [...]
> 
> b) ZOOM3
> - Enable CPU-Idle
> - Enable UART timeout
> - echo mem > /sys/power/state
> - Wakeup system using serial keyboard
> - Verify retention count increment
> 
> Functional Tests
> - Done on OMAP2430, OMAP3430SDP, ZOOM3, OMAP4430
> 
> Bootup Test
> - Done on OMAP1710
>   Used following patch to fix OMAP1 build error:-
>   [PATCH] i2c: OMAP: Fix OMAP1 build error
> 
> v9:
> - Summary of Comments/Issues fixed
>   * GPIO wakeup does not work
> 
>   * Call debounce clock enable/disable functions from PM runtime callbacks.
>     This will avoid calling the functions from multiple places.
> 
>   * Modify description of following patch to match latest changes.
>     gpio/omap: save and restore debounce registers.
> 
>   * Use (bank->regs->set_dataout && bank->regs->clr_dataout) together instead
>     of using only one of them.
> 
>   * Remove cpu_is_omapxxxx() checks from set_gpio_trigger().
> 
>   * _gpio_dbck_enable() in runtime callback triggered from omap_gpio_request
>     does not enable dbck because dbck_enable_mask is not set at this point.
> 
>   * Workaround associated with an errata got missed in v8. This has been
>     included.
> 
> v8:
> - Remove PM_CONFIG macro around following assignment.
>   pdata->get_context_loss_count = omap_pm_get_dev_context_loss_count;
> 
> - Once pm_runtime is enabled there is no more need for calling the
>   omap_device_disable_idle_on_suspend(od).
> 
> - With pm_runtime, handling of clocks in Suspend is  taken care of by
>   powerdomain hooks. So remove usage of *_runtime_put/get* from
>   suspend/resume hooks and Idle path.
> 
> - Add handling of debounce clocks along the Suspend and Idle paths.
> 
> - Remove [PATCH 04/24] gpio/omap: fix pwrdm_post_transition call sequence
>   from this series. This will be merged as part of power cleanup series.
> 
> - Remove [PATCH v7 20/26] gpio/omap: skip operations in runtime callbacks
>   The bank->mod_usage check in this patch is not needed any more because
>   they are now already being taken care in suspend/resume and Idle paths.
> 
> - Remove [PATCH v7 26/26] gpio/omap: add dbclk aliases for all gpio modules
>   This is already taken care in hwmod.
> 
> - Remove redundant blank line in
>   [PATCH v7 14/26] gpio/omap: remove unnecessary bit-masking for read access
> 
> -               if (cpu_is_omap15xx() && (bank->method == METHOD_MPUIO))
> -                       isr &= 0x0000ffff;
> 
>                if (bank->level_mask)
>                        level_mask = bank->level_mask & enabled;
> 
> v7:
> - Use pm_runtime_put() instead of pm_runtime_put_sync_suspend()
> - Keep *_runtime_get/put*()  outside spinlock
> - Remove additional checking of conditions in _restore_context()
>  From:
>  if (bank->regs->set_dataout && bank->regs->clear_dataout)
>  ...
>  To:
>  if (bank->regs->set_dataout)
>  ...
> 
> - Use SET_RUNTIME_PM_OPS and SET_SYSTEM_SLEEP_PM_OPS macros
> - In [PATCH 19/25] gpio/omap: cleanup prepare_for_idle and resume_after_idle,
>   protect the bank data elements and register access using spinlock in
>   runtime_suspend/resume() callbacks.
>   This is because these callbacks run with interrupts enabled.
> - Add dbclk aliases for all GPIO modules. Without this, GPIO modules were not
>   getting the correct clock handle to enable/disable debounec clock.
> - Fix log comments on the following patches:
>   [PATCH 19/25] gpio/omap: cleanup prepare_for_idle and resume_after_idle
>   [PATCH 20/25] gpio/omap: skip operations in runtime callbacks
>   [PATCH 24/25] gpio/omap: restore OE only after setting the output level
> 
> v6:
> - Save and restore debounce registers for proper driver operation.
> - Restore interrupt enable after all configuration to avoid spurious interrupts.
> - Restore dataout register before oe register.
> - Restore dataout into dataout_set or dataout based upon the OMAP version.
> - Change register name from wkup_status to wkup_en.
> - Remove wrapper around omap_pm_get_dev_context_loss_count(). Use it directly.
>   Also, changed the signature of get_context_loss_count in pdata and bank structure
>   from int to u32.
> 
> - Use 'context' instead of 'ctx' for clarity wherever it is used.
> - Merged two patches into one which are related to bank_is_mpuio() modification.
> - Use shift operator instead of following:
> +       .irqctrl        = OMAP_MPUIO_GPIO_INT_EDGE / 2,
> 
> - Remove redundant check from the following
> +       if (bank_is_mpuio(bank)) {
> +               if (bank->regs->wkup_status) <--- redundant check
> +                       mpuio_init(bank);
> 
> - Change subject of following patch
>   [PATCH v5 15/22] gpio/omap: use readl in irq_handler for all access
>   into
>   [PATCH 14/25] gpio/omap: remove unnecessary bit-masking for read access
> 
> - Fix multi-line comments in
>   [PATCH v5 20/22] gpio/omap: cleanup prepare_for_idle and resume_after_idle
> 
> v5:
> - Reduce runtime callback overhead when *_get/put_sync() called from probe()
>   and *_gpio_request/free().
> 
> - Dynamic context save within functions where context is modified instead of
>   saving all context within a common function.
> 
> - Removed call to mpuio_init() from omap_gpio_mod_init(). Both the functions are
>   called once during initialization in *_gpio_probe().
>   Call to omap_gpio_mod_init() has been removed from omap_gpio_request() on the
>   first access to gpio bank. One time initialization looks sufficient.
> 
> - In *_gpio_irq_handler() use *_put_sync_suspend() instead of *_put_sync().
> 
> - Removed hardcoding of OMAP16xx sysconfig register value and instead defined an
>   associated constant.
> 
> - Removed *_get_sync() call from *_gpio_suspend() and *_put_sync() call from
>  *_gpio_resume(). They got wrongly slipped into the code.
> 
> - Removed following redundant zero allocated initialization from mach-omap2/gpio.c
> +       pdata->regs->irqctrl = 0;
> +       pdata->regs->edgectrl1 = 0;
> +       pdata->regs->edgectrl2 = 0;
> 
> - Removed following redundant code in gpio-omap.c
>  -#define bank_is_mpuio(bank)  ((bank)->method == METHOD_MPUIO)
> 
> v4:
> - since all accesses to registers are 4-byte aligned, removing special
>   checks and handling of 16 and 32-bit wide bank registers and instead
>   use 32-bit read/write access consistently.
> 
> - redundant usage of MOD_REG_BIT has been corrected and replaced with
>   _gpio_rmw().
> 
> - omap_gpio_mod_init() function has been simplified further using _gpio_rmw().
> 
> - sysconfig register offset specific to omap16xx has been removed along
>   with its usage.
> 
> - additional logic to skip from suspend/resume:
> 
>  if (!bank->regs->wkup_status || !bank->suspend_wakeup)
>        return 0;
> 
>  if (!bank->regs->wkup_status || !bank->saved_wakeup)
>        return 0;
> 
> - separated mpuio related changes into a different patch from the patch where
>   wakeup status register related changes are done.
> 
> - Incorrect replacement of !cpu_class_is_omap2() in gpio_irq_type()
>   corrected:
> +       if (!bank->regs->leveldetect0 &&
> +               (type & (IRQ_TYPE_LEVEL_LOW|IRQ_TYPE_LEVEL_HIGH)))
>                return -EINVAL;
> v3:
> - Avoid use of wkup_set and wkup_clear registers. Instead use wkup_status
>   register for all platforms. This is because on OMAP4 it is recommended
>   not to use them.
> 
> - Remove duplicate code in omap_gpio_mod_init() for handling the same for
>   32-bit and 16-bit GPIO bank widths. This is accomplished by having two
>   functions to handle each case while assiging a common function pointer
>   during initialization.
> 
> - Remove OMAP16xx specific one time initialization from omap_gpio_mod_init().
>   Move it inside omap16xx_gpio_init().
> 
> - Avoid usage of USHRT_MAX to indicate undefined values. Use 0 instead.
> 
> - In omap_gpio_suspend()/resume() functions remove code that checks
>   if the feature is supported. Instead, assign these functions to
>   struct platform_driver's suspend & resume function pointers for those
>   OMAP platforms whcih support this feature.
> 
> - Remove 'suspend_support' flag because it is redundant. Instead use
>   wkup_* registers to decode the same information.
> 
> - Restore context also when we don't know if the context is lost.
> 
> - Make omap_gpio_save_context() and omap_gpio_restore_context() static.
> 
> v2:
> - Do special handling of non-wakeup GPIOs only on OMAP2420. Avoid this
>   handling on OMAP3430.
> - Isolate cleanups and fixes into separate set of patches. Keep the cleanup
>   first followed by the fixes.
> - Avoid calling omap_gpio_get_context_loss() directly and instead call it
>   through function pointer in pdata initialized during init.
> - workaround_enabled flag is not longer needed and is removed.
> - Call pwrdm_post_transition() before calling omap_gpio_resume_after_idle().
> - In omap2_gpio_resume_after_idle() do context restore before handling
>   workaround.
> - Use PM runtime framework.
> - Modify register offset names to : wkup_status, wkup_clear, wkup_set.
>   Also use 'base + offset' for readibility in all relevant places.
> - Remove unwanted messages from commit section like TODO, etc.
> 
> 
> Charulatha V (8):
>   gpio/omap: remove dependency on gpio_bank_count
>   gpio/omap: use flag to identify wakeup domain
>   gpio/omap: make gpio_context part of gpio_bank structure
>   gpio/omap: make non-wakeup GPIO part of pdata
>   gpio/omap: avoid cpu checks during module ena/disable
>   gpio/omap: use pinctrl offset instead of macro
>   gpio/omap: remove bank->method & METHOD_* macros
>   gpio/omap: fix bankwidth for OMAP7xx MPUIO
> 
> Nishanth Menon (4):
>   gpio/omap: save and restore debounce registers
>   gpio/omap: enable irq at the end of all configuration in restore
>   gpio/omap: restore OE only after setting the output level
>   gpio/omap: handle set_dataout reg capable IP on restore
> 
> Tarun Kanti DebBarma (13):
>   gpio/omap: handle save/restore context in GPIO driver
>   gpio/omap: further cleanup using wkup_en register
>   gpio/omap: use level/edge detect reg offsets
>   gpio/omap: remove hardcoded offsets in context save/restore
>   gpio/omap: cleanup set_gpio_triggering function
>   gpio/omap: cleanup omap_gpio_mod_init function
>   gpio/omap: remove unnecessary bit-masking for read access
>   gpio/omap: use pm-runtime framework
>   gpio/omap: optimize suspend and resume functions
>   gpio/omap: cleanup prepare_for_idle and resume_after_idle
>   gpio/omap: fix debounce clock handling
>   gpio/omap: fix incorrect access of debounce module
>   gpio/omap: remove omap_gpio_save_context overhead
> 
>  arch/arm/mach-omap1/gpio15xx.c         |    7 +-
>  arch/arm/mach-omap1/gpio16xx.c         |   47 ++-
>  arch/arm/mach-omap1/gpio7xx.c          |   14 +-
>  arch/arm/mach-omap2/gpio.c             |   36 +-
>  arch/arm/mach-omap2/pm34xx.c           |   14 -
>  arch/arm/plat-omap/include/plat/gpio.h |   29 +-
>  drivers/gpio/gpio-omap.c               | 1099 +++++++++++++-------------------
>  7 files changed, 549 insertions(+), 697 deletions(-)
> 
