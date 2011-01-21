Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1AUAEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 19:04:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753127Ab1AUAEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 19:04:42 -0500
Date: Thu, 20 Jan 2011 16:04:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
Cc: <linus.walleij@stericsson.com>, <richard.purdie@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 1/2] leds: add driver for LM3530 ALS
Message-Id: <20110120160407.00ffc28e.akpm@linux-foundation.org>
In-Reply-To: <1295518249-28316-1-git-send-email-shreshthakumar.sahu@stericsson.com>
References: <1295518249-28316-1-git-send-email-shreshthakumar.sahu@stericsson.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011 15:40:49 +0530
Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com> wrote:

> From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> 
> simple backlight driver for National Semiconductor LM3530.
> Presently only manual mode is supported, PWM and ALS support
> to be added.
> 
>
> ...
>
> +static int lm3530_get_mode_from_str(const char *str, int count)
> +{
> +	int i;
> +
> +	if (str[0] == '\n')
> +		return -1;

Why is this here?  I think the function would work OK if it was removed?

> +	for (i = 0; i < LM3530_BL_MODE_MAX; i++)

Could use ARRAY_SIZE(mode_map) here and do away with
LM3530_BL_MODE_MAX.

> +		if (!strncmp(mode_map[i].mode, str, count))

Why strncmp?  The code will treat input of the form "alsfoo" as "als",
which is sloppy.

> +			return mode_map[i].mode_val;
> +
> +	return -1;
> +}
> +
>
> ...
>
> +static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
> +				   *attr, const char *buf, size_t size)
> +{
> +	int err;
> +	struct i2c_client *client = container_of(
> +					dev->parent, struct i2c_client, dev);
> +	struct lm3530_data *drvdata = i2c_get_clientdata(client);
> +	int mode;
> +
> +	mode = lm3530_get_mode_from_str(buf, size-1);

And why the "size-1"?  Assuming there's a \n?  But userspace should be
able to do write(fd, 3, "als")?

Perhaps all this can be tidied up with

	mode = lm3530_get_mode_from_str(strim(buf));

Alternatively, see sysfs_streq() - it was added to address these sorts
of things.

> +	if (mode < 0) {
> +		dev_err(dev, "Invalid mode\n");
> +		return -EINVAL;
> +	}
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
>
> ...
>

