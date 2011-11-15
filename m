Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab1KOUfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:35:11 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:42463 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab1KOUfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:35:09 -0500
Subject: Re: [PATCH v7] hwmon: Add driver for EXYNOS4 TMU
From: Paul Bolle <pebolle@tiscali.nl>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: lm-sensors@lm-sensors.org, linux-doc@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1315388948-20346-1-git-send-email-dg77.kim@samsung.com>
References: <1315388948-20346-1-git-send-email-dg77.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Nov 2011 21:34:39 +0100
Message-ID: <1321389279.20271.241.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This is an attempt to do a bit of review after the fact. See, this
appears to be to the patch that ended up as commit
9d97e5c81e15afaef65d00f077f863c94f750839 in the mainline tree. Since
that tree is at v3.2-rc2 now this might be in time for v3.2. If my
comments have merit, that is.)

On Wed, 2011-09-07 at 18:49 +0900, Donggeun Kim wrote:
> This patch allows to read temperature
> from TMU(Thermal Management Unit) of SAMSUNG EXYNOS4 series of SoC.
[...]
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 0b62c3c..c6fb761 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -303,6 +303,16 @@ config SENSORS_DS1621
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called ds1621.
>  
> +config SENSORS_EXYNOS4_TMU
> +	tristate "Temperature sensor on Samsung EXYNOS4"
> +	depends on EXYNOS4_DEV_TMU

It doesn't look like that Kconfig symbol is part of the tree just yet.
That means people will not be able to build this driver from the
mainline tree. Why is this dependency needed? In a (rather quick) scan
of the code of this driver I couldn't spot anything not yet available in
the tree.

> +	help
> +	  If you say yes here you get support for TMU (Thermal Managment
> +	  Unit) on SAMSUNG EXYNOS4 series of SoC.
> +
> +	  This driver can also be built as a module. If so, the module
> +	  will be called exynos4-tmu.
> +
>  config SENSORS_I5K_AMB
>  	tristate "FB-DIMM AMB temperature sensor on Intel 5000 series chipsets"
>  	depends on PCI && EXPERIMENTAL
[...]
> diff --git a/drivers/hwmon/exynos4_tmu.c b/drivers/hwmon/exynos4_tmu.c
> new file mode 100644
> index 0000000..0170c90
> --- /dev/null
> +++ b/drivers/hwmon/exynos4_tmu.c
[...]
> +#ifdef CONFIG_PM
> +static int exynos4_tmu_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	exynos4_tmu_control(pdev, false);
> +
> +	return 0;
> +}
> +
> +static int exynos4_tmu_resume(struct platform_device *pdev)
> +{
> +	exynos4_tmu_initialize(pdev);
> +	exynos4_tmu_control(pdev, true);
> +
> +	return 0;
> +}
> +#else
> +#define exynos4_tmu_suspend NULL
> +#define exynos4_tmu_resume NULL
> +#endif
> +
> +static struct platform_driver exynos4_tmu_driver = {
> +	.driver = {
> +		.name   = "exynos4-tmu",
> +		.owner  = THIS_MODULE,
> +	},
> +	.probe = exynos4_tmu_probe,
> +	.remove	= __devexit_p(exynos4_tmu_remove),
> +	.suspend = exynos4_tmu_suspend,
> +	.resume = exynos4_tmu_resume,
> +};

A common idiom seems to be (I'm speaking from memory here) to
wrap .suspend and .resume inside an "#ifdef CONFIG_PM" / "#endif" pair.
That would allow to drop both "#define exynos4_tmu_suspend NULL" and
"#define exynos4_tmu_resume NULL" above. Would that work here too?


Paul Bolle

