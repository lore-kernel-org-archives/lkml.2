Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722Ab2EIS17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 14:27:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43564 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760659Ab2EIS16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 14:27:58 -0400
Date: Wed, 9 May 2012 19:27:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] mfd: Add support for MAX77686.
Message-ID: <20120509182757.GB32037@sirena.org.uk>
References: <1336580695-1184-1-git-send-email-yadi.brar@samsung.com>
 <1336580695-1184-2-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336580695-1184-2-git-send-email-yadi.brar@samsung.com>
X-Cookie: Now, let's SEND OUT for QUICHE!!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 09:54:54PM +0530, Yadwinder Singh wrote:

> +int max77686_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_read_byte_data(i2c, reg);
> +	if (ret < 0)

It would really be better if this used the regmap API - the regulator
API is starting to build out functionality on top of regmap which this
won't be able to take advantage of if it doesn't use regmap.

> +	if (of_get_property(dev->of_node, "max77686,wakeup", NULL))
> +		pd->wakeup = true;

You haven't included any binding documentatiojn for the device tree
bindings - you should do this.

> +	max77686 = kzalloc(sizeof(struct max77686_dev), GFP_KERNEL);
> +	if (max77686 == NULL) {
> +		dev_err(max77686->dev, "could not allocate memory\n");
> +		return -ENOMEM;
> +	}

devm_kzalloc().

> +	device_init_wakeup(max77686->dev, max77686->wakeup);

Why is this not just done unconditionally?  There's sysfs files to allow
userspace control.

> +	if (max77686_read_reg(i2c, MAX77686_REG_DEVICE_ID, &data) < 0) {
> +		ret = -EIO;
> +		dbg_info("%s : device not found on this channel\n", __func__);
> +		goto err_mfd;
> +	} else
> +		dev_info(max77686->dev, "device found\n");

You should verify that the device ID you read back is the expected one.

> +	dev_err(max77686->dev, "device probe failed : %d\n", ret);

Driver core should do this for you.
