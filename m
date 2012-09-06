Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab2IFPNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:13:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60468 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384Ab2IFPNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:13:18 -0400
Message-ID: <5048BD7A.7060408@ti.com>
Date: Thu, 6 Sep 2012 17:12:58 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Omar Ramirez Luna <omar.luna@linaro.org>
CC: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Kevin Hilman <khilman@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: OMAP: hwmod: revise deassert sequence
References: <1345614150-25723-1-git-send-email-omar.luna@linaro.org> <1345614150-25723-3-git-send-email-omar.luna@linaro.org>
In-Reply-To: <1345614150-25723-3-git-send-email-omar.luna@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Omar,

On 08/22/2012 07:42 AM, Omar Ramirez Luna wrote:
> For a reset sequence to complete cleanly, a module needs its
> associated clocks to be enabled, otherwise the timeout check
> in prcm code can print a false failure (failed to hardreset)
> that occurs because the clocks aren't powered ON and the status
> bit checked can't transition without them.
> 
> Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
> ---
>  arch/arm/mach-omap2/omap_hwmod.c |   37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
> index eaedc33..b65e021 100644
> --- a/arch/arm/mach-omap2/omap_hwmod.c
> +++ b/arch/arm/mach-omap2/omap_hwmod.c
> @@ -1509,6 +1509,7 @@ static int _deassert_hardreset(struct omap_hwmod *oh, const char *name)
>  {
>  	struct omap_hwmod_rst_info ohri;
>  	int ret = -EINVAL;
> +	int hwsup = 0;
>  
>  	if (!oh)
>  		return -EINVAL;
> @@ -1520,10 +1521,46 @@ static int _deassert_hardreset(struct omap_hwmod *oh, const char *name)
>  	if (IS_ERR_VALUE(ret))
>  		return ret;
>  
> +	if (oh->clkdm) {
> +		/*
> +		 * A clockdomain must be in SW_SUP otherwise reset
> +		 * might not be completed. The clockdomain can be set
> +		 * in HW_AUTO only when the module become ready.
> +		 */
> +		hwsup = clkdm_in_hwsup(oh->clkdm);
> +		ret = clkdm_hwmod_enable(oh->clkdm, oh);
> +		if (ret) {> 

> +			WARN(1, "omap_hwmod: %s: could not enable clockdomain %s: %d\n",
> +			     oh->name, oh->clkdm->name, ret);
> +			return ret;
> +		}
> +	}
> +
> +	_enable_clocks(oh);
> +	if (soc_ops.enable_module)
> +		soc_ops.enable_module(oh);
> +
>  	ret = soc_ops.deassert_hardreset(oh, &ohri);
> +
> +	if (soc_ops.disable_module)
> +		soc_ops.disable_module(oh);
> +	_disable_clocks(oh);
> +
>  	if (ret == -EBUSY)
>  		pr_warning("omap_hwmod: %s: failed to hardreset\n", oh->name);
>  
> +	if (!ret) {
> +		/*
> +		 * Set the clockdomain to HW_AUTO, assuming that the
> +		 * previous state was HW_AUTO.
> +		 */
> +		if (oh->clkdm && hwsup)
> +			clkdm_allow_idle(oh->clkdm);
> +	} else {
> +		if (oh->clkdm)
> +			clkdm_hwmod_disable(oh->clkdm, oh);
> +	}
> +
>  	return ret;
>  }
>  

The sequence is good, I'm just a little bit concern about the
duplication of code compared to _enable sequence.

That being said, this is the consequence of removing the hardreset
sequence outside of the main _enable/_shutdown sequence.

So I'm not sure I have any better way of doing that :-(

Regards,
Benoit

