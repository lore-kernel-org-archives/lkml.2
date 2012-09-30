Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab2I3XPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 19:15:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:7745 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab2I3XPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 19:15:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,514,1344236400"; 
   d="scan'208";a="228380619"
Date: Mon, 1 Oct 2012 01:15:36 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Patil, Rachna" <rachna@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH v4 2/5] MFD: ti_tscadc: Add support for TI's TSC/ADC
 MFDevice
Message-ID: <20120930231536.GE12231@sortiz-mobl>
References: <1348636814-14129-1-git-send-email-rachna@ti.com>
 <1348636814-14129-3-git-send-email-rachna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348636814-14129-3-git-send-email-rachna@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rachna,

On Wed, Sep 26, 2012 at 10:50:11AM +0530, Patil, Rachna wrote:
> Add the mfd core driver which supports touchscreen
> and ADC.
> With this patch we are only adding infrastructure to
> support the MFD clients.
> 
> Signed-off-by: Patil, Rachna <rachna@ti.com>
> ---
> Changes in v2:
> 	Merged "[PATCH 5/5] MFD: ti_tscadc: Add check on number of i/p channels",
> 	patch submitted in previous version into this file.
> 
> Changes in v3:
> 	No changes
> 
> Changes in v4:
> 	No changes
> 
>  drivers/mfd/Kconfig                  |    9 ++
>  drivers/mfd/Makefile                 |    1 +
>  drivers/mfd/ti_am335x_tscadc.c       |  193 ++++++++++++++++++++++++++++++++++
>  include/linux/mfd/ti_am335x_tscadc.h |  133 +++++++++++++++++++++++
>  4 files changed, 336 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/ti_am335x_tscadc.c
>  create mode 100644 include/linux/mfd/ti_am335x_tscadc.h
Looks good to me, I only have a few comments:

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index b1a1462..e472184 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -94,6 +94,15 @@ config MFD_TI_SSP
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called ti-ssp.
>  
> +config MFD_TI_AM335X_TSCADC
> +	tristate "TI ADC / Touch Screen chip support"
> +	depends on ARCH_OMAP2PLUS
- Why do you need to depend on that architecture ?
- You must select MFD_CORE.

> +static unsigned int tscadc_readl(struct ti_tscadc_dev *tsadc, unsigned int reg)
> +{
> +	return readl(tsadc->tscadc_base + reg);
> +}
> +
> +static void tscadc_writel(struct ti_tscadc_dev *tsadc, unsigned int reg,
> +					unsigned int val)
> +{
> +	writel(val, tsadc->tscadc_base + reg);
> +}
> +
Have you considered using the regmap MMIO API ? The benefits are not very
obvious in that case, but it's always better to use a common framework.


> +static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
> +{
> +	struct ti_tscadc_dev	*tscadc;
> +	struct resource		*res;
> +	struct clk		*clk;
> +	struct mfd_tscadc_board	*pdata = pdev->dev.platform_data;
> +	int			irq;
> +	int			err, ctrl;
> +	int			clk_value, clock_rate;
> +
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "Could not find platform data\n");
> +		return -EINVAL;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "no memory resource defined.\n");
> +		return -EINVAL;
> +	}
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "no irq ID is specified.\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Allocate memory for device */
> +	tscadc = kzalloc(sizeof(struct ti_tscadc_dev), GFP_KERNEL);
devm_kzalloc ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
