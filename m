Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314Ab2EPRiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:38:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50928 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759178Ab2EPRiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:38:23 -0400
Date: Wed, 16 May 2012 19:38:15 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Robert Lee <rob.lee@linaro.org>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org,
        u.kleine-koenig@pengutronix.de, richard.zhao@freescale.com,
        amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, jj@chaosbits.net
Subject: Re: [PATCH v4 3/7] ARM: imx: clean and consolidate imx5 suspend and
 idle code
Message-ID: <20120516173815.GV30400@pengutronix.de>
References: <1337135616-8988-1-git-send-email-rob.lee@linaro.org>
 <1337135616-8988-4-git-send-email-rob.lee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337135616-8988-4-git-send-email-rob.lee@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:28:27 up 186 days,  1:15, 30 users,  load average: 1.37, 1.83,
 1.64
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

Overall this looks ok now, some comments inline.

Sascha

On Tue, May 15, 2012 at 09:33:32PM -0500, Robert Lee wrote:
> The imx5 idle code that existed in mm-imx5.c is moved to pm-imx5.c.
> The imx5_pm_init call is now exported and called during the
> MACHINE_START late_init in supported imx5 platforms.
> 
> Remove various enabling/disabling of the gpc_dvfs clock and
> enable it once during initialization.  This is a very low
> power clock that must be enabled during low power operations.
> 
> There are only two "suspend_state_t" imx5 low power modes ever
> used.  STOP_POWER_OFF for suspend to mem and
> WAIT_UNCLOCKED_POWER_OFF for idle and suspend to standby.  The
> latter mode only requires 500 nanoseconds of extra hardware
> exit time beyond a basic WFI operation (WAIT_CLOCKED mode) so
> no other idle mode is necessary.  Given this information, it
> is more efficient to keep the registers in the often used
> WAIT_UNCLOCKED_POWER_OFF state and only to and from the
> STOP_POWER_OFF register state as needed when suspend to
> mem is required.
> 
> Signed-off-by: Robert Lee <rob.lee@linaro.org>
> ---
>  arch/arm/mach-imx/mm-imx5.c             |   20 +---------
>  arch/arm/mach-imx/pm-imx5.c             |   63 ++++++++++++++++++-------------
>  arch/arm/plat-mxc/include/mach/common.h |    3 +-
>  3 files changed, 40 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mm-imx5.c b/arch/arm/mach-imx/mm-imx5.c
> index d6b7e9f..bb38747 100644
> --- a/arch/arm/mach-imx/mm-imx5.c
> +++ b/arch/arm/mach-imx/mm-imx5.c
> @@ -15,7 +15,6 @@
>  #include <linux/init.h>
>  #include <linux/clk.h>
>  
> -#include <asm/system_misc.h>
>  #include <asm/mach/map.h>
>  
>  #include <mach/hardware.h>
> @@ -23,23 +22,6 @@
>  #include <mach/devices-common.h>
>  #include <mach/iomux-v3.h>
>  
> -static struct clk *gpc_dvfs_clk;
> -
> -static void imx5_idle(void)
> -{
> -	/* gpc clock is needed for SRPG */
> -	if (gpc_dvfs_clk == NULL) {
> -		gpc_dvfs_clk = clk_get(NULL, "gpc_dvfs");
> -		if (IS_ERR(gpc_dvfs_clk))
> -			return;
> -	}
> -	clk_enable(gpc_dvfs_clk);
> -	mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
> -	if (!tzic_enable_wake())
> -		cpu_do_idle();
> -	clk_disable(gpc_dvfs_clk);
> -}
> -
>  /*
>   * Define the MX50 memory map.
>   */
> @@ -103,7 +85,6 @@ void __init imx51_init_early(void)
>  	mxc_set_cpu_type(MXC_CPU_MX51);
>  	mxc_iomux_v3_init(MX51_IO_ADDRESS(MX51_IOMUXC_BASE_ADDR));
>  	mxc_arch_reset_init(MX51_IO_ADDRESS(MX51_WDOG1_BASE_ADDR));
> -	arm_pm_idle = imx5_idle;
>  }
>  
>  void __init imx53_init_early(void)
> @@ -238,4 +219,5 @@ void __init imx53_soc_init(void)
>  void __init imx51_init_late(void)
>  {
>  	mx51_neon_fixup();
> +	imx5_pm_init();
>  }
> diff --git a/arch/arm/mach-imx/pm-imx5.c b/arch/arm/mach-imx/pm-imx5.c
> index e26a9cb..6e62d79 100644
> --- a/arch/arm/mach-imx/pm-imx5.c
> +++ b/arch/arm/mach-imx/pm-imx5.c
> @@ -13,18 +13,27 @@
>  #include <linux/io.h>
>  #include <linux/err.h>
>  #include <asm/cacheflush.h>
> +#include <asm/system_misc.h>
>  #include <asm/tlbflush.h>
>  #include <mach/common.h>
>  #include <mach/hardware.h>
>  #include "crm-regs-imx5.h"
>  
> -static struct clk *gpc_dvfs_clk;
> +/*
> + * The WAIT_UNCLOCKED_POWER_OFF state only requires <= 500ns to exit.
> + * This is also the lowest power state possible without affecting
> + * non-cpu parts of the system.  For these reasons, imx5 should default
> + * to always using this state for cpu idling.  The PM_SUSPEND_STANDBY also
> + * uses this state and needs to take no action when registers remain confgiured
> + * for this state.
> + */
> +#define IMX5_DEFAULT_CPU_IDLE_STATE WAIT_UNCLOCKED_POWER_OFF
>  
>  /*
>   * set cpu low power mode before WFI instruction. This function is called
>   * mx5 because it can be used for mx50, mx51, and mx53.
>   */
> -void mx5_cpu_lp_set(enum mxc_cpu_pwr_mode mode)
> +static void mx5_cpu_lp_set(enum mxc_cpu_pwr_mode mode)
>  {
>  	u32 plat_lpc, arm_srpgcr, ccm_clpcr;
>  	u32 empgc0, empgc1;
> @@ -87,11 +96,6 @@ void mx5_cpu_lp_set(enum mxc_cpu_pwr_mode mode)
>  	}
>  }
>  
> -static int mx5_suspend_prepare(void)
> -{
> -	return clk_prepare_enable(gpc_dvfs_clk);
> -}
> -
>  static int mx5_suspend_enter(suspend_state_t state)
>  {
>  	switch (state) {
> @@ -99,7 +103,7 @@ static int mx5_suspend_enter(suspend_state_t state)
>  		mx5_cpu_lp_set(STOP_POWER_OFF);
>  		break;
>  	case PM_SUSPEND_STANDBY:
> -		mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
> +		/* DEFAULT_IDLE_STATE already configured */
>  		break;
>  	default:
>  		return -EINVAL;
> @@ -114,12 +118,10 @@ static int mx5_suspend_enter(suspend_state_t state)
>  		__raw_writel(0, MXC_SRPG_EMPGC1_SRPGCR);
>  	}
>  	cpu_do_idle();
> -	return 0;
> -}
>  
> -static void mx5_suspend_finish(void)
> -{
> -	clk_disable_unprepare(gpc_dvfs_clk);
> +	/* return registers to default idle state */
> +	mx5_cpu_lp_set(IMX5_DEFAULT_CPU_IDLE_STATE);
> +	return 0;
>  }
>  
>  static int mx5_pm_valid(suspend_state_t state)
> @@ -129,25 +131,34 @@ static int mx5_pm_valid(suspend_state_t state)
>  
>  static const struct platform_suspend_ops mx5_suspend_ops = {
>  	.valid = mx5_pm_valid,
> -	.prepare = mx5_suspend_prepare,
>  	.enter = mx5_suspend_enter,
> -	.finish = mx5_suspend_finish,
>  };
>  
> -static int __init mx5_pm_init(void)
> +static void imx5_pm_idle(void)
> +{
> +	if (likely(!tzic_enable_wake()))
> +		cpu_do_idle();
> +}
> +
> +int __init imx5_pm_init(void)
>  {
> -	if (!cpu_is_mx51() && !cpu_is_mx53())
> -		return 0;
> +	int ret;
> +	struct clk *gpc_dvfs_clk = clk_get(NULL, "gpc_dvfs");
> +
> +	if (IS_ERR(gpc_dvfs_clk))
> +		return (int)gpc_dvfs_clk;

PTR_ERR please

> +
> +	ret = clk_enable(gpc_dvfs_clk);

clk_prepare_enable

> +	if (ret)
> +		return ret;
> +
> +	if (cpu_is_mx51())
> +		suspend_set_ops(&mx5_suspend_ops);

Now this is called only in i.MX51 context, so you can skip the cpu_is

>  
> -	if (gpc_dvfs_clk == NULL)
> -		gpc_dvfs_clk = clk_get(NULL, "gpc_dvfs");
> +	arm_pm_idle = imx5_pm_idle;
>  
> -	if (!IS_ERR(gpc_dvfs_clk)) {
> -		if (cpu_is_mx51())
> -			suspend_set_ops(&mx5_suspend_ops);
> -	} else
> -		return -EPERM;
> +	/* Set the registers to the default cpu idle state. */
> +	mx5_cpu_lp_set(IMX5_DEFAULT_CPU_IDLE_STATE);
>  
>  	return 0;
>  }
> -device_initcall(mx5_pm_init);
> diff --git a/arch/arm/plat-mxc/include/mach/common.h b/arch/arm/plat-mxc/include/mach/common.h
> index cf663d8..5660e1e 100644
> --- a/arch/arm/plat-mxc/include/mach/common.h
> +++ b/arch/arm/plat-mxc/include/mach/common.h
> @@ -95,7 +95,6 @@ enum mx3_cpu_pwr_mode {
>  };
>  
>  extern void mx3_cpu_lp_set(enum mx3_cpu_pwr_mode mode);
> -extern void mx5_cpu_lp_set(enum mxc_cpu_pwr_mode mode);
>  extern void imx_print_silicon_rev(const char *cpu, int srev);
>  
>  void avic_handle_irq(struct pt_regs *);
> @@ -146,8 +145,10 @@ extern void imx6q_clock_map_io(void);
>  
>  #ifdef CONFIG_PM
>  extern void imx6q_pm_init(void);
> +extern int imx5_pm_init(void);
>  #else
>  static inline void imx6q_pm_init(void) {}
> +static inline int imx5_pm_init(void) { return -ENODEV; }

Why not make it return void like imx6? We do not check the return value
anyway.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
