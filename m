Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2CSVi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 17:38:27 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52258 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755951Ab2CSVi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 17:38:26 -0400
Message-ID: <1332193105.6525.34.camel@joe2Laptop>
Subject: Re: [PATCH V3] TAOS tsl2x7x
From: Joe Perches <joe@perches.com>
To: Jon Brenner <jbrenner@taosinc.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-iio <linux-iio@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 19 Mar 2012 14:38:25 -0700
In-Reply-To: <1332191591.7034.2.camel@jonz-ub2>
References: <1332191591.7034.2.camel@jonz-ub2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 16:13 -0500, Jon Brenner wrote:
> TAOS device driver (version 3) for the tsl/tmd 2771 and 2772 device families (inc. all variants).

trivial comments follow.
> +++ b/drivers/staging/iio/light/tsl2x7x_core.c
> @@ -0,0 +1,1948 @@
[]
> +static int
> +tsl2x7x_i2c_read(struct i2c_client *client, u8 reg, u8 *val)
> +{
> +	int ret;
> +
> +	/* select register to write */
> +	ret = i2c_smbus_write_byte(client, (TSL2X7X_CMD_REG | reg));
> +	if (ret < 0) {
> +		dev_err(&client->dev, "tsl2x7x_i2c_read failed to write"
> +			" register %x\n", reg);

Please coalesce formats.
You can also use %s, __func__

		dev_err(&client->dev, "%s: failed to write register %x\n",
			__func__, reg);


> +static int tsl2x7x_get_lux(struct iio_dev *indio_dev)
> +{
[]
> +	if (mutex_trylock(&chip->als_mutex) == 0) {
> +		dev_info(&chip->client->dev, "tsl2x7x_get_lux device is busy\n");

		"%s:", __func___
> +		dev_err(&chip->client->dev, "tsl2x7x_get_lux device is not enabled\n");
[]
> +		dev_err(&chip->client->dev,
> +			"tsl2x7x_get_lux failed to read CMD_REG\n");
[]
> +		dev_err(&chip->client->dev,
> +			"tsl2x7x_get_lux data not valid yet\n");
[]
> +			dev_err(&chip->client->dev,
> +				"tsl2x7x_get_lux failed to read"
> +				" ret: %x\n", ret);
[]
> +		dev_err(&chip->client->dev,
> +		"tsl2x7x_i2c_write_command failed in tsl2x7x_get_lux, err = %d\n",
> +			ret);

Align arguments please and maybe:
		dev_err(&chip->client->dev,
			"%s: "tsl2x7x_i2c_write_command failed, err = %d\n",
			__func__, ret);
[]
> +	if (p->ratio == 0) {
> +		lux = 0;
> +	} else {
> +		ch0lux = ((ch0 * p->ch0) +
> +		(tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain] >> 1))
> +		/ tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain];

The alignment is pretty hard to read.  Maybe DIV_ROUND_UP?

> +		ch1lux = ((ch1 * p->ch1) +
> +		(tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain] >> 1))
> +		/ tsl2X7X_als_gainadj[chip->tsl2x7x_settings.als_gain];

and here.

> +		if (!(status & TSL2X7X_STA_PRX_VALID)) {
> +			err_cnt++;
> +			if (err_cnt > CONSECUTIVE_RETRIES) {
> +				dev_err(&chip->client->dev,
> +				"Consec. retries exceeded\n");

alignment, etc...

> +static int tsl2x7x_chip_on(struct iio_dev *indio_dev)
[]
> +	/* Non calculated parameters */
> +	chip->tsl2x7x_config[TSL2X7X_PRX_TIME] =
> +			chip->tsl2x7x_settings.prx_time;

maybe a macro or some temporaries for
chip->tsl2x7x_config and chip->tsl2x7x_settings?

	whatevertypeof chip->tsl2x7x_config *cfg = &chip->tsl2x7x_config;
	whatevertypeof chip->tsl2x7x_settings *settings = &chip->tsl2x7x_settings;

	cfg[TSL2X7X_PRX_TIME] = settings->prx_time;

> +	chip->tsl2x7x_config[TSL2X7X_WAIT_TIME] =
> +			chip->tsl2x7x_settings.wait_time;

	cfg[TSL2X7X_WAIT_TIME] = settings->wait_time;

> +	chip->tsl2x7x_config[TSL2X7X_PRX_CONFIG] =
> +			chip->tsl2x7x_settings.prox_config;
> +
> +	chip->tsl2x7x_config[TSL2X7X_ALS_MINTHRESHLO] =
> +		(chip->tsl2x7x_settings.als_thresh_low) & 0xFF;
> +	chip->tsl2x7x_config[TSL2X7X_ALS_MINTHRESHHI] =
> +		(chip->tsl2x7x_settings.als_thresh_low >> 8) & 0xFF;
> +	chip->tsl2x7x_config[TSL2X7X_ALS_MAXTHRESHLO] =
> +		(chip->tsl2x7x_settings.als_thresh_high) & 0xFF;
> +	chip->tsl2x7x_config[TSL2X7X_ALS_MAXTHRESHHI] =
> +		(chip->tsl2x7x_settings.als_thresh_high >> 8) & 0xFF;
> +	chip->tsl2x7x_config[TSL2X7X_PERSISTENCE] =
> +		chip->tsl2x7x_settings.als_persistence;
> +
> +	chip->tsl2x7x_config[TSL2X7X_PRX_COUNT] =
> +			chip->tsl2x7x_settings.prox_pulse_count;
> +	chip->tsl2x7x_config[TSL2X7X_PRX_MINTHRESHLO] =
> +	chip->tsl2x7x_settings.prox_thres_low;
> +	chip->tsl2x7x_config[TSL2X7X_PRX_MAXTHRESHLO] =
> +			chip->tsl2x7x_settings.prox_thres_high;

etc...

> +static unsigned long tsl2x7x_isqrt(unsigned long x)

There's int_sqrt in kernel.h

> + * Proximity calibration helper function
> + * runs through a collection of data samples,
> + * sets the min, max, mean, and std dev.
> + */
> +static
> +void tsl2x7x_prox_calculate(u16 *data, int length, struct prox_stat *statP)
> +{
> +	int i;
> +	int min, max, sum, mean;
> +	unsigned long stddev;
> +	int tmp;
> +
> +	if (length == 0)
> +		length = 1;
> +
> +	sum = 0;
> +	min = 0xffff;

INT_MAX?

> +	max = 0;

INT_MIN?

The rest of the patch is too long, and  didn't read more.
Maybe later.

