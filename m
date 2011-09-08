Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab1IHPPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 11:15:51 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:49895 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753695Ab1IHPPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 11:15:48 -0400
Message-ID: <4E68DBF7.1030009@metafoo.de>
Date: Thu, 08 Sep 2011 17:15:03 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Mans Rullgard <mans.rullgard@linaro.org>
CC: linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        linaro-dev@lists.linaro.org, Liam Girdwood <lrg@ti.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH] ASoC: omap: convert per-board modules to
 platform drivers
References: <1315494354-17597-1-git-send-email-mans.rullgard@linaro.org>
In-Reply-To: <1315494354-17597-1-git-send-email-mans.rullgard@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2011 05:05 PM, Mans Rullgard wrote:
> This converts the per-board modules to platform drivers for a
> device created by in main platform setup.  These drivers call
> snd_soc_register_card() directly instead of going via a "soc-audio"
> device and the corresponding driver in soc-core.
>
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index 5b8ca68..7cb93d9 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -299,6 +299,11 @@ static struct platform_device omap_pcm = {
>  	.id	= -1,
>  };
>  
> +static struct platform_device omap_soc_audio = {
> +	.name	= "omap-soc-audio",
> +	.id	= -1,
> +};
> +
>  /*
>   * OMAP2420 has 2 McBSP ports
>   * OMAP2430 has 5 McBSP ports
> @@ -323,6 +328,7 @@ static void omap_init_audio(void)
>  		platform_device_register(&omap_mcbsp5);
>  
>  	platform_device_register(&omap_pcm);
> +	platform_device_register(&omap_soc_audio);
>  }
>  
>  #else
> diff --git a/sound/soc/omap/am3517evm.c b/sound/soc/omap/am3517evm.c
> index 73dde4a..fcd18af 100644
> --- a/sound/soc/omap/am3517evm.c
> +++ b/sound/soc/omap/am3517evm.c
> @@ -151,45 +151,60 @@ static struct snd_soc_card snd_soc_am3517evm = {
>  	.num_links = 1,
>  };
>  
> [...]
> +static struct platform_driver am3517evm_driver = {
> +	.driver = {
> +		.name = "omap-soc-audio",
> +		.owner = THIS_MODULE,
> +	},
>  
> -	return ret;
> +	.probe = am3517evm_soc_probe,
> +	.remove = __devexit_p(am3517evm_soc_remove),
> +};
> +[...]
> +
> +static struct platform_driver igep2_driver = {
> +	.driver = {
> +		.name = "omap-soc-audio",
> +		.owner = THIS_MODULE,
> +	},
> +
> +	.probe = igep2_soc_probe,
> +	.remove = __devexit_p(igep2_soc_remove),
> +};
> [...]
>  
> +static struct platform_driver n810_driver = {
> +	.driver = {
> +		.name = "omap-soc-audio",
> +		.owner = THIS_MODULE,
> +	},
> +
> +	.probe = n810_soc_probe,
> +	.remove = __devexit_p(n810_soc_remove),
> +};
> [...]

This isn't really any better then using the soc-core device, since all your
drivers are still named the same. udev still wouldn't know which one to load.
Use different device driver names for different drivers.
