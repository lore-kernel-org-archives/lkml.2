Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275Ab2HWTD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 15:03:56 -0400
Received: from a83-160-107-163.adsl.xs4all.nl ([83.160.107.163]:41305 "EHLO
	d4rwin.no-ip.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933189Ab2HWTDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 15:03:53 -0400
Date: Thu, 23 Aug 2012 21:02:39 +0200
From: Matthias Kaehlcke <matthias.list@kaehlcke.net>
To: "Patil, Rachna" <rachna@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 4/5] IIO : ADC: tiadc: Add support of TI's ADC driver
Message-ID: <20120823190239.GF27787@darwin>
Mail-Followup-To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
	"Patil, Rachna" <rachna@ti.com>, linux-kernel@vger.kernel.org,
	linux-input@vger.kernel.org, linux-iio@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
	Samuel Ortiz <sameo@linux.intel.com>
References: <1345719021-22835-1-git-send-email-rachna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345719021-22835-1-git-send-email-rachna@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

El Thu, Aug 23, 2012 at 04:20:21PM +0530 Patil, Rachna ha dit:

> This patch adds support for TI's ADC driver.
> This is a multifunctional device.
> Analog input lines are provided on which
> voltage measurements can be carried out.
> You can have upto 8 input lines.
> 
> Signed-off-by: Patil, Rachna <rachna@ti.com>
> ---
>
> diff --git a/drivers/iio/adc/ti_adc.c b/drivers/iio/adc/ti_adc.c
> ...
> +static int __devinit tiadc_probe(struct platform_device *pdev)
> +{
> +	struct iio_dev		*idev;
> +	int			err;
> +	struct adc_device	*adc_dev = NULL;
> +	struct ti_tscadc_dev	*tscadc_dev = pdev->dev.platform_data;
> +	struct mfd_tscadc_board	*board_data;
> +
> +	board_data = (struct mfd_tscadc_board *)tscadc_dev->dev->platform_data;
> +	if (!board_data) {
> +		dev_err(tscadc_dev->dev, "Could not find platform data\n");
> +		return -EINVAL;
> +	}
> +
> +	idev = iio_device_alloc(sizeof(struct adc_device));
> +	if (idev == NULL) {
> +		dev_err(&pdev->dev, "failed to allocate iio device.\n");
> +		err = -ENOMEM;
> +		goto err_ret;
> +	}
> +	adc_dev = iio_priv(idev);
> +
> +	tscadc_dev->adc = adc_dev;
> +	adc_dev->mfd_tscadc = tscadc_dev;
> +	adc_dev->idev = idev;
> +	adc_dev->adc_channels = board_data->adc_init->adc_channels;
> +
> +	idev->dev.parent = &pdev->dev;
> +	idev->name = dev_name(&pdev->dev);
> +	idev->modes = INDIO_DIRECT_MODE;
> +	idev->info = &tiadc_info;
> +
> +	adc_step_config(adc_dev);
> +
> +	err = tiadc_channel_init(idev, adc_dev);
> +	if (err < 0)
> +		goto err_fail;
> +
> +	err = iio_device_register(idev);
> +	if (err)
> +		goto err_free_channels;
> +
> +	dev_info(&pdev->dev, "attached adc driver\n");
> +	platform_set_drvdata(pdev, idev);
> +
> +	return 0;
> +
> +err_free_channels:
> +	tiadc_channel_remove(idev);
> +err_fail:
> +	iio_device_unregister(idev);
> +	iio_device_free(idev);
> +err_ret:
> +	platform_set_drvdata(pdev, NULL);

not necessary, the platform device doesn't exist anymore

> +	iio_device_free(idev);

already done some lines above and could be executed without having
allocated the iio device (when iio_device_alloc() fails)

> +static int __devexit tiadc_remove(struct platform_device *pdev)
> +{
> +	struct ti_tscadc_dev   *tscadc_dev = pdev->dev.platform_data;
> +	struct adc_device	*adc_dev = tscadc_dev->adc;
> +	struct iio_dev		*idev = adc_dev->idev;
> +
> +	iio_device_unregister(idev);
> +	tiadc_channel_remove(idev);
> +
> +	tscadc_dev->adc = NULL;
> +
> +	iio_device_free(idev);
> +	platform_set_drvdata(pdev, NULL);

see above

best regards

-- 
Matthias Kaehlcke
Embedded Linux Developer
Amsterdam

               If sharing a thing in no way diminishes it,
               it is not rightly owned if it is not shared
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
