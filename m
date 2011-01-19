Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1ASOKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 09:10:40 -0500
Received: from dan.rpsys.net ([93.97.175.187]:50566 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab1ASOKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 09:10:39 -0500
Subject: Re: [PATCH 1/2] leds: add driver for LM3530 ALS
From: Richard Purdie <richard.purdie@linuxfoundation.org>
To: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: linus.walleij@stericsson.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1295420175-22332-1-git-send-email-shreshthakumar.sahu@stericsson.com>
References: <1295420175-22332-1-git-send-email-shreshthakumar.sahu@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 14:10:13 +0000
Message-ID: <1295446213.14388.21898.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 12:26 +0530, Shreshtha Kumar SAHU wrote:
> From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> 
> simple backlight driver for National Semiconductor LM3530.
> Presently only manual mode is supported, PWM and ALS support
> to be added.
> 
[...]
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_GEN_CONFIG, gen_config);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_CONFIG, als_config);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_BRT_RAMP_RATE, brt_ramp);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_IMP_SELECT, als_imp_sel);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_BRT_CTRL_REG, brightness);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_ZB0_REG, LM3530_DEF_ZB_0);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_ZB1_REG, LM3530_DEF_ZB_1);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_ZB2_REG, LM3530_DEF_ZB_2);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_ZB3_REG, LM3530_DEF_ZB_3);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_Z0T_REG, LM3530_DEF_ZT_0);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_Z1T_REG, LM3530_DEF_ZT_1);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_Z2T_REG, LM3530_DEF_ZT_2);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_Z3T_REG, LM3530_DEF_ZT_3);
> +	if (ret)
> +		return ret;
> +	ret = i2c_smbus_write_byte_data(client,
> +			LM3530_ALS_Z4T_REG, LM3530_DEF_ZT_4);
> +	if (ret)
> +		return ret;
> +
> +	return ret;

I can't help wonder if a table of values iterated over would look a
little neater here. The last if is harmless but pointless too.


> +static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
> +				   *attr, const char *buf, size_t size)
> +{
> +	int err;
> +	struct i2c_client *client = container_of(
> +					dev->parent, struct i2c_client, dev);
> +	struct lm3530_data *drvdata = i2c_get_clientdata(client);
> +	unsigned long mode;
> +
> +	err = strict_strtoul(buf, 10, &mode);
> +	if (err < 0)
> +		return -EINVAL;
> +
> +	if (mode == LM3530_BL_MODE_MANUAL)
> +		drvdata->mode = LM3530_BL_MODE_MANUAL;
> +	else if (mode == LM3530_BL_MODE_ALS)
> +		drvdata->mode = LM3530_BL_MODE_ALS;
> +	else if (mode == LM3530_BL_MODE_PWM) {
> +		dev_err(dev, "PWM mode not supported\n");
> +		return -EINVAL;
> +	}
> +
> +	err = lm3530_init_registers(drvdata);
> +	if (err) {
> +		dev_err(dev, "Setting %s Mode failed :%d\n", buf, err);
> +		return err;
> +	}
> +
> +	return sizeof(drvdata->mode);
> +}
> +
> +static DEVICE_ATTR(mode, 0644, NULL, lm3530_mode_set);

So you poke random values of 0, 1, 2 into sysfs? I suspect that breaks
sysfs guidelines and these should be meaningful values like "pwm", "als"
and "led". The enum is ok within the kernel but not for exposure outside
of it. 

Also, calling out PWM specifically as not supported seems like the wrong
approach and I'm curious what happens if I poke 4 in there.

The rest looked ok at a quick glance.

Cheers,

Richard

