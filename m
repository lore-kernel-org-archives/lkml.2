Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212Ab2HWStv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:49:51 -0400
Received: from a83-160-107-163.adsl.xs4all.nl ([83.160.107.163]:41226 "EHLO
	d4rwin.no-ip.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab2HWSts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:49:48 -0400
Date: Thu, 23 Aug 2012 20:48:31 +0200
From: Matthias Kaehlcke <matthias.list@kaehlcke.net>
To: "Patil, Rachna" <rachna@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/5] MFD: ti_tscadc: Add support for TI's TSC/ADC MFDevice
Message-ID: <20120823184830.GE27787@darwin>
Mail-Followup-To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
	"Patil, Rachna" <rachna@ti.com>, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org, linux-iio@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
	Samuel Ortiz <sameo@linux.intel.com>
References: <1345718997-18304-1-git-send-email-rachna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345718997-18304-1-git-send-email-rachna@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

El Thu, Aug 23, 2012 at 04:19:57PM +0530 Patil, Rachna ha dit:

> Add the mfd core driver which supports touchscreen
> and ADC.
> With this patch we are only adding infrastructure to
> support the MFD clients.
> 
> Signed-off-by: Patil, Rachna <rachna@ti.com>
> ---
> diff --git a/drivers/mfd/ti_tscadc.c b/drivers/mfd/ti_tscadc.c
> ...
> +static	int __devinit ti_tscadc_probe(struct platform_device *pdev)
> +{
> +	struct ti_tscadc_dev		*tscadc;
> +	int				err, ctrl;
> +	int				clk_value, clock_rate;
> +	struct resource			*res;
> +	struct clk			*clk;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "no memory resource defined.\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Allocate memory for device */
> +	tscadc = kzalloc(sizeof(struct ti_tscadc_dev), GFP_KERNEL);
> +	if (!tscadc) {
> +		dev_err(&pdev->dev, "failed to allocate memory.\n");
> +		return -ENOMEM;
> +	}
> +
> +	res = request_mem_region(res->start, resource_size(res), pdev->name);
> +	if (!res) {
> +		dev_err(&pdev->dev, "failed to reserve registers.\n");
> +		err = -EBUSY;
> +		goto err_free_mem;
> +	}
> +
> +	tscadc->tscadc_base = ioremap(res->start, resource_size(res));
> +	if (!tscadc->tscadc_base) {
> +		dev_err(&pdev->dev, "failed to map registers.\n");
> +		err = -ENOMEM;
> +		goto err_release_mem;
> +	}
> +
> +	tscadc->irq = platform_get_irq(pdev, 0);
> +	if (tscadc->irq < 0) {
> +		dev_err(&pdev->dev, "no irq ID is specified.\n");
> +		return -ENODEV;

goto err_iounmap_mem;

> ...
> +err_fail:
> +	pm_runtime_put_sync(&pdev->dev);
> +	pm_runtime_disable(&pdev->dev);
> +	iounmap(tscadc->tscadc_base);
> +err_release_mem:
> +	release_mem_region(res->start, resource_size(res));
> +	mfd_remove_devices(tscadc->dev);
> +err_free_mem:
> +	platform_set_drvdata(pdev, NULL);

shouldn't be necessary as the platform device doesn't exist any longer

> ...
> +static int __devexit ti_tscadc_remove(struct platform_device *pdev)
> +{
> +	struct ti_tscadc_dev	*tscadc = platform_get_drvdata(pdev);
> +	struct resource		*res;
> +
> +	tscadc_writel(tscadc, REG_SE, 0x00);
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	iounmap(tscadc->tscadc_base);
> +	release_mem_region(res->start, resource_size(res));
> +
> +	pm_runtime_put_sync(&pdev->dev);
> +	pm_runtime_disable(&pdev->dev);
> +
> +	mfd_remove_devices(tscadc->dev);
> +	kfree(tscadc);
> +
> +	platform_set_drvdata(pdev, NULL);

same as above

best regards

-- 
Matthias Kaehlcke
Embedded Linux Developer
Amsterdam

         The only way to do great work is to love what you do
                            (Steve Jobs)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
