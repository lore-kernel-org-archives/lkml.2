Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab0C2NAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:00:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48081 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751955Ab0C2NAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:00:48 -0400
Date: Mon, 29 Mar 2010 14:00:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Todd Fischer <todd.fischer@ridgerun.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, sameo@linux.intel.com,
       lrg@slimlogic.co.uk
Subject: Re: [PATCH 3/5] Add MFD driver for TPS6507x family of
 multi-function chips
Message-ID: <20100329130046.GD8434@rakim.wolfsonmicro.main>
References: <1269634292-29686-1-git-send-email-todd.fischer@ridgerun.com>
 <1269634292-29686-2-git-send-email-todd.fischer@ridgerun.com>
 <1269634292-29686-3-git-send-email-todd.fischer@ridgerun.com>
 <1269634292-29686-4-git-send-email-todd.fischer@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269634292-29686-4-git-send-email-todd.fischer@ridgerun.com>
X-Cookie: Uncompensated overtime?  Just Say No.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 02:11:30PM -0600, Todd Fischer wrote:
> MFD driver for TPS6507x family of multi-function chips.

This patch should also be updating the regulator driver to work in terms
of this new MFD driver - otherwise after applying it you'll have two
incompatible drivers for the same chip at once.

> @@ -62,4 +63,4 @@ obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
>  obj-$(CONFIG_AB4500_CORE)	+= ab4500-core.o
>  obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
>  obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
> -obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
> \ No newline at end of file
> +obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o

Extra change in the diff here (not unreasonable, but...).

> + * Credits:
> + *
> + *    Using code from wm8350-i2c.c, Wolfson Microelectronics PLC.
> + *

The WM831x is a much better thing to be cloning here - it fits in much
more directly with the MFD framework, meaning that you don't need...

> +/*
> + * Register a client device.  This is non-fatal since there is no need to
> + * fail the entire device init due to a single platform device failing.
> + */
> +static void tps6507x_client_dev_register(struct tps6507x_dev *tps6507x,
> +					 const char *name,
> +					 struct platform_device **pdev)
> +{

...stuff like this, you can just use the MFD core.

> +static int tps6507x_i2c_probe(struct i2c_client *i2c,
> +			    const struct i2c_device_id *id)
> +{

...

> +	ret = tps6507x_device_init(tps6507x, i2c->irq, i2c->dev.platform_data);
> +	if (ret < 0)
> +		goto err;

Does the hardware support SPI?  The reason the Wolfson drivers are split
up like they are is that the hardware supports both I2C and SPI so room
is being left to add SPI support but if not then you may as well just
have a single probe() function which does all the init.

> +/**
> + * struct tps6507x_dev - tps6507x sub-driver chip access routines
> + * @read_dev() - I2C register read function
> + * @write_dev() - I2C register write function
> + *
> + * Device data may be used to access the TPS6507x chip
> + */
> +
> +struct tps6507x_dev {
> +	struct device *dev;
> +	struct i2c_client *i2c_client;
> +	int (*read_dev)(struct tps6507x_dev *tps6507x, char reg, int size,
> +			void *dest);
> +	int (*write_dev)(struct tps6507x_dev *tps6507x, char reg, int size,
> +			 void *src);
> +	struct mutex adc_mutex;

Perhaps worth saving adc_mutex until you add support for the ADC?
