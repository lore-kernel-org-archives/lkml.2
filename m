Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1IVWaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:30:17 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:47442 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754099Ab1IVWaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:30:13 -0400
From: Kevin Hilman <khilman@ti.com>
To: Abhilash K V <abhilash.kv@ti.com>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <santosh.shilimkar@ti.com>, <premi@ti.com>,
        <david.woodhouse@intel.com>, <christian.gmeiner@gmail.com>
Subject: Re: [PATCH v3 1/3] AM35x: voltage: Basic initialization
Organization: Texas Instruments, Inc.
References: <1316698155-954-1-git-send-email-abhilash.kv@ti.com>
	<1316698155-954-2-git-send-email-abhilash.kv@ti.com>
Date: Thu, 22 Sep 2011 15:30:07 -0700
In-Reply-To: <1316698155-954-2-git-send-email-abhilash.kv@ti.com> (Abhilash
	K. V.'s message of "Thu, 22 Sep 2011 18:59:13 +0530")
Message-ID: <877h50p5w0.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhilash,

Abhilash K V <abhilash.kv@ti.com> writes:

> This patch adds the basic initialization of voltage layer
> for AM35x. Since AM35x doesn't support voltage scaling,

I must admit to still being confused by this series.  

This patch says AM35x doesn't support voltage scaling, and the next
patch adds PMIC support, and registers it with the voltage layer.

However, with each voltdm->scalable flag set to false, none of the PMIC
values will ever be used (by the current voltage layer.)  Do you have
more patches on top of this that extend the voltage layer to directly
use the PMIC instead of using VC or VP?

I'm assuming we have some more assumptions in our current voltage layer
about the presence of VC/VP that are wrong and need to be fixed.  Now
that the big voltage layer cleanup is done, I am *very* interested in
getting rid of any more assumptions we have in that code about how
devices are hooked up with PMICs.

Can you summarize how these devices are using (or want to use) the
voltage layer?

Thanks,

Kevin

> Many functions have been defined to plug into existing
> voltage layer.
>
> Signed-off-by: Sanjeev Premi <premi@ti.com>
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
> ---
>  arch/arm/mach-omap2/omap_opp_data.h           |    1 +
>  arch/arm/mach-omap2/opp3xxx_data.c            |    9 +++++++++
>  arch/arm/mach-omap2/voltagedomains3xxx_data.c |   10 ++++++++--
>  3 files changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/omap_opp_data.h b/arch/arm/mach-omap2/omap_opp_data.h
> index c784c12..c7cedf3 100644
> --- a/arch/arm/mach-omap2/omap_opp_data.h
> +++ b/arch/arm/mach-omap2/omap_opp_data.h
> @@ -88,6 +88,7 @@ extern struct omap_volt_data omap34xx_vddmpu_volt_data[];
>  extern struct omap_volt_data omap34xx_vddcore_volt_data[];
>  extern struct omap_volt_data omap36xx_vddmpu_volt_data[];
>  extern struct omap_volt_data omap36xx_vddcore_volt_data[];
> +extern struct omap_volt_data am35xx_vdd_volt_data[];
>  
>  extern struct omap_volt_data omap44xx_vdd_mpu_volt_data[];
>  extern struct omap_volt_data omap44xx_vdd_iva_volt_data[];
> diff --git a/arch/arm/mach-omap2/opp3xxx_data.c b/arch/arm/mach-omap2/opp3xxx_data.c
> index d95f3f9..e4a5ee6 100644
> --- a/arch/arm/mach-omap2/opp3xxx_data.c
> +++ b/arch/arm/mach-omap2/opp3xxx_data.c
> @@ -85,6 +85,15 @@ struct omap_volt_data omap36xx_vddcore_volt_data[] = {
>  	VOLT_DATA_DEFINE(0, 0, 0, 0),
>  };
>  
> +/* AM35x
> + *
> + * Fields related to SmartReflex and Voltage Processor are set to 0.
> + */

fix multi-line comment style (search for 'multi-line' in Documentation/CodingStyle)

> +struct omap_volt_data am35xx_vdd_volt_data[] = {
> +	VOLT_DATA_DEFINE(OMAP3430_VDD_MPU_OPP3_UV, 0x0, 0x0, 0x0),
> +	VOLT_DATA_DEFINE(0, 0, 0, 0),
> +};
> +
>  /* OPP data */
>  
>  static struct omap_opp_def __initdata omap34xx_opp_def_list[] = {
> diff --git a/arch/arm/mach-omap2/voltagedomains3xxx_data.c b/arch/arm/mach-omap2/voltagedomains3xxx_data.c
> index 071101d..530082f 100644
> --- a/arch/arm/mach-omap2/voltagedomains3xxx_data.c
> +++ b/arch/arm/mach-omap2/voltagedomains3xxx_data.c
> @@ -85,7 +85,10 @@ void __init omap3xxx_voltagedomains_init(void)
>  	 * XXX Will depend on the process, validation, and binning
>  	 * for the currently-running IC
>  	 */
> -	if (cpu_is_omap3630()) {
> +	if (cpu_is_omap3505() || cpu_is_omap3517()) {
> +		omap3_voltdm_mpu.volt_data = am35xx_vdd_volt_data;
> +		omap3_voltdm_core.volt_data = am35xx_vdd_volt_data;
> +	} else if (cpu_is_omap3630()) {
>  		omap3_voltdm_mpu.volt_data = omap36xx_vddmpu_volt_data;
>  		omap3_voltdm_core.volt_data = omap36xx_vddcore_volt_data;
>  	} else {
> @@ -93,8 +96,11 @@ void __init omap3xxx_voltagedomains_init(void)
>  		omap3_voltdm_core.volt_data = omap34xx_vddcore_volt_data;
>  	}
>  
> -	for (i = 0; voltdm = voltagedomains_omap3[i], voltdm; i++)
> +	for (i = 0; voltdm = voltagedomains_omap3[i], voltdm; i++) {
> +		if (cpu_is_omap3505() || cpu_is_omap3517())
> +			voltdm->scalable = false;
>  		voltdm->sys_clk.name = sys_clk_name;
> +	}
>  
>  	voltdm_init(voltagedomains_omap3);
>  };
