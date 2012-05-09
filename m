Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab2EIICW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:02:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41961 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab2EIICS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:02:18 -0400
Date: Wed, 9 May 2012 10:02:14 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Robert Lee <rob.lee@linaro.org>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, amit.kucheria@linaro.org,
        daniel.lezcano@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, jj@chaosbits.net
Subject: Re: [PATCH v3 2/3] ARM: imx: Add imx5 cpuidle driver
Message-ID: <20120509080214.GJ27341@pengutronix.de>
References: <1336425407-20308-1-git-send-email-rob.lee@linaro.org>
 <1336425407-20308-3-git-send-email-rob.lee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336425407-20308-3-git-send-email-rob.lee@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:49:32 up 178 days, 15:36, 63 users,  load average: 0.02, 0.04,
 0.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 04:16:46PM -0500, Robert Lee wrote:
> Add imx5 cpuidle driver.
> 
> Signed-off-by: Robert Lee <rob.lee@linaro.org>
> ---
>  arch/arm/mach-imx/mm-imx5.c |   42 +++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mm-imx5.c b/arch/arm/mach-imx/mm-imx5.c
> index d6b7e9f..0b3a4cc 100644
> --- a/arch/arm/mach-imx/mm-imx5.c
> +++ b/arch/arm/mach-imx/mm-imx5.c
> @@ -20,26 +20,61 @@
>  
>  #include <mach/hardware.h>
>  #include <mach/common.h>
> +#include <mach/cpuidle.h>
>  #include <mach/devices-common.h>
>  #include <mach/iomux-v3.h>
>  
>  static struct clk *gpc_dvfs_clk;
>  
> -static void imx5_idle(void)
> +static int imx5_idle(void)
>  {
> +	int ret = 0;
> +
>  	/* gpc clock is needed for SRPG */
>  	if (gpc_dvfs_clk == NULL) {
>  		gpc_dvfs_clk = clk_get(NULL, "gpc_dvfs");

This clk_get should go away here and be moved somewhere to
initialization. Also, if getting this clock fails we can still
do regular cpu_do_idle. Additionally, if clk_get fails, we'll
have a ERR_PTR value in gpc_dvfs_clk in which case the
gpc_dvfs_clk == NULL won't trigger next time you are here and
then you'll enable a nonexisting clock below.

>  		if (IS_ERR(gpc_dvfs_clk))
> -			return;
> +			return -ENODEV;
>  	}
>  	clk_enable(gpc_dvfs_clk);
>  	mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
>  	if (!tzic_enable_wake())
>  		cpu_do_idle();
> +	else
> +		ret = -EBUSY;
>  	clk_disable(gpc_dvfs_clk);
> +
> +	return ret;
> +}
> +
> +static int imx5_cpuidle_enter(struct cpuidle_device *dev,
> +				struct cpuidle_driver *drv, int idx)
> +{
> +	int ret;
> +
> +	ret = imx5_idle();
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	return idx;
>  }
>  
> +static struct cpuidle_driver imx5_cpuidle_driver = {
> +	.name			= "imx5_cpuidle",
> +	.owner			= THIS_MODULE,
> +	.en_core_tk_irqen	= 1,
> +	.states[0]	= {
> +		.enter			= imx5_cpuidle_enter,
> +		.exit_latency		= 20, /* max latency at 160MHz */
> +		.target_residency	= 1,
> +		.flags			= CPUIDLE_FLAG_TIME_VALID,
> +		.name			= "IMX5 SRPG",
> +		.desc			= "CPU state retained,powered off",
> +	},

I wonder why you don't add the default ARM_CPUIDLE_WFI_STATE_PWR state.
The above is something different, right? It has a greater exit latency
than ARM_CPUIDLE_WFI_STATE_PWR, so why don't we add it here aswell?

> +	.state_count		= 1,
> +};
> +
>  /*
>   * Define the MX50 memory map.
>   */
> @@ -103,7 +138,7 @@ void __init imx51_init_early(void)
>  	mxc_set_cpu_type(MXC_CPU_MX51);
>  	mxc_iomux_v3_init(MX51_IO_ADDRESS(MX51_IOMUXC_BASE_ADDR));
>  	mxc_arch_reset_init(MX51_IO_ADDRESS(MX51_WDOG1_BASE_ADDR));
> -	arm_pm_idle = imx5_idle;
> +	arm_pm_idle = (void (*)(void))imx5_idle;

Still this looks suspicious. Reading this will lead to the question why
this prototype is casted. Please just add a imx5_pm_idle with the
correct prototype.

>  }
>  
>  void __init imx53_init_early(void)
> @@ -238,4 +273,5 @@ void __init imx53_soc_init(void)
>  void __init imx51_init_late(void)
>  {
>  	mx51_neon_fixup();
> +	imx_cpuidle_init(&imx5_cpuidle_driver);
>  }
> -- 
> 1.7.10
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
