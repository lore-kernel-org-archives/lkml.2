Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab2EBHdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 03:33:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43708 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab2EBHdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 03:33:35 -0400
Date: Wed, 2 May 2012 09:33:31 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Robert Lee <rob.lee@linaro.org>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, amit.kucheria@linaro.org,
        daniel.lezcano@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, jj@chaosbits.net
Subject: Re: [PATCH v2 2/3] ARM: imx: Add imx5 cpuidle driver
Message-ID: <20120502073331.GS4141@pengutronix.de>
References: <1335924760-796-1-git-send-email-rob.lee@linaro.org>
 <1335924760-796-3-git-send-email-rob.lee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335924760-796-3-git-send-email-rob.lee@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:28:17 up 171 days, 15:15, 28 users,  load average: 0.36, 1.33,
 0.79
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 09:12:39PM -0500, Robert Lee wrote:
> Add imx5 cpuidle driver.
> 
> Signed-off-by: Robert Lee <rob.lee@linaro.org>
> ---
>  arch/arm/mach-imx/mm-imx5.c |   42 +++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 39 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mm-imx5.c b/arch/arm/mach-imx/mm-imx5.c
> index d6b7e9f..cbd9bad 100644
> --- a/arch/arm/mach-imx/mm-imx5.c
> +++ b/arch/arm/mach-imx/mm-imx5.c
> @@ -22,24 +22,59 @@
>  #include <mach/common.h>
>  #include <mach/devices-common.h>
>  #include <mach/iomux-v3.h>
> +#include <mach/cpuidle.h>
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
> +	arm_pm_idle = (void *)imx5_idle;

I don't like this. It will cover all warnings when the prototype of
arm_pm_idle changes in future. Better add a static void imx5_idle
which calls a static int imx5_do_idle, then you have an idle function
which returns an int.

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
