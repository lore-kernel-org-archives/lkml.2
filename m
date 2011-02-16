Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab1BPWLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:11:13 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60771 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab1BPWLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:11:11 -0500
Date: Wed, 16 Feb 2011 15:11:08 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, devicetree-discuss@lists.ozlabs.org,
        x86@kernel.org, sodaville@linutronix.de
Subject: Re: [PATCH OF 13/14] rtc/cmos: add OF bindings
Message-ID: <20110216221108.GJ22837@angua.secretlab.ca>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
 <1295843342-1122-14-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295843342-1122-14-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 09:59:01AM +0530, Sebastian Andrzej Siewior wrote:
> This allows to load the OF driver based informations from the device
> tree. Systems without BIOS may need to perform some initialization.
> PowerPC creates a PNP device from the OF information and performs this
> kind of initialization in their private PCI quirk. This looks more
> generic.
> 
> Cc: rtc-linux@googlegroups.com
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  Documentation/powerpc/dts-bindings/rtc-cmos.txt |   28 ++++++++++++++
>  drivers/rtc/rtc-cmos.c                          |   46 +++++++++++++++++++++++
>  2 files changed, 74 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/powerpc/dts-bindings/rtc-cmos.txt
> 
> diff --git a/Documentation/powerpc/dts-bindings/rtc-cmos.txt b/Documentation/powerpc/dts-bindings/rtc-cmos.txt
> new file mode 100644
> index 0000000..7382989
> --- /dev/null
> +++ b/Documentation/powerpc/dts-bindings/rtc-cmos.txt

Move to Documentation/devicetree/bindings/rtc/

> @@ -0,0 +1,28 @@
> + Motorola mc146818 compatible RTC
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Required properties:
> +  - compatible : "motorola,mc146818"
> +  - reg : should contain registers location and length.
> +
> +Optional properties:
> +  - interrupts : should contain interrupt.
> +  - interrupt-parent : interrupt source phandle.
> +  - ctrl-reg : Contains the initial value of the control register also
> +    called "Register B".
> +  - freq-reg : Contains the initial value of the frequency register also
> +    called "Regsiter A".
> +
> +"Register A" and "B" are usually initialized by the firmware (BIOS for
> +instance). If this is not done, it can be performed by the driver.
> +
> +ISA Example:
> +
> +	rtc@70 {
> +	         compatible = "motorola,mc146818";
> +	         interrupts = <8 3>;
> +	         interrupt-parent = <&ioapic1>;
> +	         ctrl-reg = <2>;
> +	         freq-reg = <0x26>;
> +	         reg = <1 0x70 2>;
> +	 };
> diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
> index c7ff8df..2709e00 100644
> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -37,6 +37,8 @@
>  #include <linux/mod_devicetable.h>
>  #include <linux/log2.h>
>  #include <linux/pm.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
>  
>  /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
>  #include <asm-generic/rtc.h>
> @@ -1123,6 +1125,46 @@ static struct pnp_driver cmos_pnp_driver = {
>  
>  #endif	/* CONFIG_PNP */
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id of_cmos_match[] = {
> +	{
> +		.compatible = "motorola,mc146818",
> +	},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, of_cmos_match);
> +
> +static __init void cmos_of_init(struct platform_device *pdev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	struct rtc_time time;
> +	int ret;
> +	const __be32 *val;
> +
> +	if (!node)
> +		return;
> +
> +	val = of_get_property(node, "ctrl-reg", NULL);
> +	if (val)
> +		CMOS_WRITE(be32_to_cpup(val), RTC_CONTROL);
> +
> +	val = of_get_property(node, "freq-reg", NULL);
> +	if (val)
> +		CMOS_WRITE(be32_to_cpup(val), RTC_FREQ_SELECT);
> +
> +	get_rtc_time(&time);
> +	ret = rtc_valid_tm(&time);
> +	if (ret) {
> +		struct rtc_time def_time = {
> +			.tm_year = 1,
> +			.tm_mday = 1,
> +		};
> +		set_rtc_time(&def_time);
> +	}
> +}
> +#else
> +static inline void cmos_of_init(struct platform_device *pdev) {}
> +#endif
>  /*----------------------------------------------------------------*/
>  
>  /* Platform setup should have set up an RTC device, when PNP is
> @@ -1131,6 +1173,7 @@ static struct pnp_driver cmos_pnp_driver = {
>  
>  static int __init cmos_platform_probe(struct platform_device *pdev)
>  {
> +	cmos_of_init(pdev);
>  	cmos_wake_setup(&pdev->dev);
>  	return cmos_do_probe(&pdev->dev,
>  			platform_get_resource(pdev, IORESOURCE_IO, 0),
> @@ -1162,6 +1205,9 @@ static struct platform_driver cmos_platform_driver = {
>  #ifdef CONFIG_PM
>  		.pm		= &cmos_pm_ops,
>  #endif
> +#if defined(CONFIG_OF)
> +		.of_match_table = of_cmos_match,
> +#endif

The #if defined(CONFIG_OF) is no longer necessary around
.of_match_table, particularly if you have a #else above that #defines
of_cmos_match to NULL.

>  	}
>  };
>  
> -- 
> 1.7.3.2
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
