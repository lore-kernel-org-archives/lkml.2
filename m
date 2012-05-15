Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966379Ab2EOSnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:43:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51618 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966356Ab2EOSnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:43:33 -0400
Date: Tue, 15 May 2012 20:43:30 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Geon Si Jeong <gshark.jeong@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Daniel Jeong <daniel.jeong@ti.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 1/1 v1] leds: Add LED driver for lm3556 chip
Message-ID: <20120515184330.GB5654@localhost>
References: <1333936855-8807-1-git-send-email-gshark.jeong@gmail.com>
 <1333936855-8807-2-git-send-email-gshark.jeong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333936855-8807-2-git-send-email-gshark.jeong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 11:00:55AM +0900, Geon Si Jeong wrote:
> It is a simple driver for LM3556 Chip(Texas Instruments)
> LM3556 :
> The LM3556 is a 4 MHz fixed-frequency synchronous boost
> converter plus 1.5A constant current driver for a high-current white LED.
> Datasheet: www.national.com/ds/LM/LM3556.pdf
> 
> Tested on OMAP4430
> 
> Signed-off-by: Geon Si Jeong <gshark.jeong@gmail.com>

[...]

> +/* i2c access*/
> +static int lm3556_read_reg(struct i2c_client *client, u8 reg, u8 * val)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_read_byte_data(client, reg);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "i2c reading fail at 0x%02x error %d\n",
> +			reg, ret);
> +		return ret;
> +	}
> +	*val = ret & 0xff;
> +	return ret;
> +}
> +
> +static int lm3556_write_reg(struct i2c_client *client, u8 reg, u8 val)
> +{
> +	int ret = 0;
> +
> +	ret = i2c_smbus_write_byte_data(client, reg, val);
> +
> +	if (ret < 0)
> +		dev_err(&client->dev, "i2c writting fail at 0x%02x\n", reg);
> +	return ret;
> +}
> +
> +static int lm3556_write_bits(struct i2c_client *client,
> +			     u8 reg, u8 val, u8 mask, u8 shift)
> +{
> +	int ret;
> +	u8 reg_val;
> +	struct lm3556_chip_data *chip = i2c_get_clientdata(client);
> +
> +	mutex_lock(&chip->lock);
> +	ret = lm3556_read_reg(client, reg, &reg_val);
> +	if (ret < 0)
> +		goto out;
> +	reg_val &= (~(mask << shift));
> +	reg_val |= ((val & mask) << shift);
> +	ret = lm3556_write_reg(client, reg, reg_val);
> +out:
> +	mutex_unlock(&chip->lock);
> +	return ret;
> +}

The register io-locking above is broken. You need to protect both 
write_reg and write_bits using the mutex (but you must restructure
your code because write_bits currently calls write_reg). This is
required to avoid register corruption due to concurrent write_reg and
write_bits.

As has been suggested elsewhere, you could consider using regmap.

Thanks,
Johan
