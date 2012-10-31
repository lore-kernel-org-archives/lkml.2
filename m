Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934027Ab2JaElH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 00:41:07 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48009 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab2JaElC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 00:41:02 -0400
MIME-Version: 1.0
In-Reply-To: <1351698945-3881-1-git-send-email-panto@antoniou-consulting.com>
References: <1351698945-3881-1-git-send-email-panto@antoniou-consulting.com>
Date: Tue, 30 Oct 2012 21:41:00 -0700
X-Google-Sender-Auth: nre7bYjvY7WZhDGHXa96uYOMn-w
Message-ID: <CA+Bv8XbCweGxKg-VsM2=g5KJEbLZhUA8F=iAG2st7c0JRLH58g@mail.gmail.com>
Subject: Re: [PATCH] ti_tscadc: Match mfd sub devices to regmap interface
From: Russ Dill <Russ.Dill@ti.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, "Patil, Rachna" <rachna@ti.com>,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 8:55 AM, Pantelis Antoniou
<panto@antoniou-consulting.com> wrote:
> The MFD parent device now uses a regmap, instead of direct
> memory access. Use the same method in the sub devices to avoid
> nasty surprises.
>
> Also rework the channel initialization of tiadc a bit.
>
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  drivers/iio/adc/ti_am335x_adc.c           | 27 +++++++++++++++++++--------
>  drivers/input/touchscreen/ti_am335x_tsc.c | 16 +++++++++++++---
>  drivers/mfd/ti_am335x_tscadc.c            |  7 +++++--
>  3 files changed, 37 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index d48fd79..5f325c1 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -23,7 +23,9 @@
>  #include <linux/iio/iio.h>
>  #include <linux/iio/machine.h>
>  #include <linux/iio/driver.h>
> +#include <linux/regmap.h>
>
> +#include <linux/io.h>
>  #include <linux/mfd/ti_am335x_tscadc.h>
>  #include <linux/platform_data/ti_am335x_adc.h>
>
> @@ -36,13 +38,17 @@ struct tiadc_device {
>
>  static unsigned int tiadc_readl(struct tiadc_device *adc, unsigned int reg)
>  {
> -       return readl(adc->mfd_tscadc->tscadc_base + reg);
> +       unsigned int val;
> +
> +       val = (unsigned int)-1;
> +       regmap_read(adc->mfd_tscadc->regmap_tscadc, reg, &val);
> +       return val;
>  }

Would it be cleaner to instead do:

static unsigned int tiadc_readl(struct tiadc_device *adc, unsigned int reg)
{
       unsigned int val;

       return regmap_read(adc->mfd_tscadc->regmap_tscadc, reg, &val) ? : val;
}

or
       int ret;

       ret = regmap_read(adc->mfd_tscadc->regmap_tscadc, reg, &val);
       return ret < 0 ret ? : val;



>  static void tiadc_writel(struct tiadc_device *adc, unsigned int reg,
>                                         unsigned int val)
>  {
> -       writel(val, adc->mfd_tscadc->tscadc_base + reg);
> +       regmap_write(adc->mfd_tscadc->regmap_tscadc, reg, val);
>  }
>
>  static void tiadc_step_config(struct tiadc_device *adc_dev)
> @@ -75,22 +81,24 @@ static void tiadc_step_config(struct tiadc_device *adc_dev)
>         tiadc_writel(adc_dev, REG_SE, STPENB_STEPENB);
>  }
>
> -static int tiadc_channel_init(struct iio_dev *indio_dev, int channels)
> +static int tiadc_channel_init(struct iio_dev *indio_dev,
> +               struct tiadc_device *adc_dev)
>  {
>         struct iio_chan_spec *chan_array;
>         struct iio_chan_spec *chan;
>         char *s;
>         int i, len, size, ret;
> +       int channels = adc_dev->channels;
>
> -       size = indio_dev->num_channels * (sizeof(struct iio_chan_spec) + 6);
> +       size = channels * (sizeof(struct iio_chan_spec) + 6);
>         chan_array = kzalloc(size, GFP_KERNEL);
>         if (chan_array == NULL)
>                 return -ENOMEM;
>
>         /* buffer space is after the array */
> -       s = (char *)(chan_array + indio_dev->num_channels);
> +       s = (char *)(chan_array + channels);
>         chan = chan_array;
> -       for (i = 0; i < indio_dev->num_channels; i++, chan++, s += len + 1) {
> +       for (i = 0; i < channels; i++, chan++, s += len + 1) {
>
>                 len = sprintf(s, "AIN%d", i);
>
> @@ -105,8 +113,9 @@ static int tiadc_channel_init(struct iio_dev *indio_dev, int channels)
>         }
>
>         indio_dev->channels = chan_array;
> +       indio_dev->num_channels = channels;
>
> -       size = (indio_dev->num_channels + 1) * sizeof(struct iio_map);
> +       size = (channels + 1) * sizeof(struct iio_map);
>         adc_dev->map = kzalloc(size, GFP_KERNEL);
>         if (adc_dev->map == NULL) {
>                 kfree(chan_array);
> @@ -203,7 +212,7 @@ static int __devinit tiadc_probe(struct platform_device *pdev)
>
>         tiadc_step_config(adc_dev);
>
> -       err = tiadc_channel_init(indio_dev, adc_dev->channels);
> +       err = tiadc_channel_init(indio_dev, adc_dev);
>         if (err < 0)
>                 goto err_free_device;
>
> @@ -213,6 +222,8 @@ static int __devinit tiadc_probe(struct platform_device *pdev)
>
>         platform_set_drvdata(pdev, indio_dev);
>
> +       dev_info(&pdev->dev, "Initialized\n");
> +
>         return 0;
>
>  err_free_channels:
> diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
> index 7a26810..d09e1a7 100644
> --- a/drivers/input/touchscreen/ti_am335x_tsc.c
> +++ b/drivers/input/touchscreen/ti_am335x_tsc.c
> @@ -26,6 +26,7 @@
>  #include <linux/io.h>
>  #include <linux/input/ti_am335x_tsc.h>
>  #include <linux/delay.h>
> +#include <linux/regmap.h>
>
>  #include <linux/mfd/ti_am335x_tscadc.h>
>
> @@ -64,13 +65,17 @@ struct titsc {
>
>  static unsigned int titsc_readl(struct titsc *ts, unsigned int reg)
>  {
> -       return readl(ts->mfd_tscadc->tscadc_base + reg);
> +       unsigned int val;
> +
> +       val = (unsigned int)-1;
> +       regmap_read(ts->mfd_tscadc->regmap_tscadc, reg, &val);
> +       return val;
>  }
>
>  static void titsc_writel(struct titsc *tsc, unsigned int reg,
>                                         unsigned int val)
>  {
> -       writel(val, tsc->mfd_tscadc->tscadc_base + reg);
> +       regmap_write(tsc->mfd_tscadc->regmap_tscadc, reg, val);
>  }
>
>  /*
> @@ -455,10 +460,15 @@ static int __devinit titsc_probe(struct platform_device *pdev)
>
>         /* register to the input system */
>         err = input_register_device(input_dev);
> -       if (err)
> +       if (err) {
> +               dev_err(&pdev->dev, "Failed to register input device\n");
>                 goto err_free_irq;
> +       }
>
>         platform_set_drvdata(pdev, ts_dev);
> +
> +       dev_info(&pdev->dev, "Initialized OK\n");
> +
>         return 0;
>
>  err_free_irq:
> diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
> index cbb8b70c..4a7041c 100644
> --- a/drivers/mfd/ti_am335x_tscadc.c
> +++ b/drivers/mfd/ti_am335x_tscadc.c
> @@ -31,6 +31,7 @@ static unsigned int tscadc_readl(struct ti_tscadc_dev *tsadc, unsigned int reg)
>  {
>         unsigned int val;
>
> +       val = (unsigned int)-1;
>         regmap_read(tsadc->regmap_tscadc, reg, &val);
>         return val;
>  }
> @@ -68,7 +69,7 @@ static        int __devinit ti_tscadc_probe(struct platform_device *pdev)
>         int                     irq;
>         int                     err, ctrl;
>         int                     clk_value, clock_rate;
> -       int                     tsc_wires, adc_channels = 0, total_channels;
> +       int                     tsc_wires = 0, adc_channels = 0, total_channels;
>
>         if (!pdata) {
>                 dev_err(&pdev->dev, "Could not find platform data\n");
> @@ -78,7 +79,9 @@ static        int __devinit ti_tscadc_probe(struct platform_device *pdev)
>         if (pdata->adc_init)
>                 adc_channels = pdata->adc_init->adc_channels;
>
> -       tsc_wires = pdata->tsc_init->wires;
> +       if (pdata->tsc_init)
> +               tsc_wires = pdata->tsc_init->wires;
> +
>         total_channels = tsc_wires + adc_channels;
>
>         if (total_channels > 8) {
> --
> 1.7.12
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
