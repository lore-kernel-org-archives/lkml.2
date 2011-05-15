Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179Ab1EORFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:05:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60280 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755745Ab1EORFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:05:43 -0400
Date: Sun, 15 May 2011 10:05:44 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Margarita Olaya <magi@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        sameo@linux.intel.com
Subject: Re: [PATCHv3 1/4] mfd: tps65912: Add new mfd device
Message-ID: <20110515170544.GB11579@opensource.wolfsonmicro.com>
References: <BANLkTinwGcDx7gU-vMX4=uHhLWC6qBb-jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinwGcDx7gU-vMX4=uHhLWC6qBb-jQ@mail.gmail.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 04:30:22PM -0500, Margarita Olaya wrote:

> +#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
> +static int tps65912_i2c_read(struct tps65912 *tps65912, u8 reg,
> +				  int bytes, void *dest)
> +{

Putting both SPI and I2C drivers into the same file means that I2C is
forced to be built in if SPI is enabled (SPI can't be built as a
module).  This isn't a big deal really but it's nice to avoid the
dependency.

> +	dcdc_avs = (pmic_plat_data->is_dcdc1_avs << 0 |
> +			pmic_plat_data->is_dcdc2_avs  << 1 |
> +				pmic_plat_data->is_dcdc3_avs << 2 |
> +					pmic_plat_data->is_dcdc4_avs << 3);
> +	if (dcdc_avs) {
> +		tps65912->read(tps65912, TPS65912_I2C_SPI_CFG, 1, &value);
> +		dcdc_avs |= value;
> +		tps65912->write(tps65912, TPS65912_I2C_SPI_CFG, 1, &dcdc_avs);
> +	}
> +
> +	ret = mfd_add_devices(tps65912->dev, -1,
> +			      tps65912s, ARRAY_SIZE(tps65912s),
> +			      NULL, 0);
> +	if (ret < 0)
> +		goto err;

The platform data and MFD handling are common to both I2C and SPI - it'd
seem sensible to factor them out into a separate function called by the
I2C and SPI init paths to ensure they are kept in sync.
