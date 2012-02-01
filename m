Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab2BAXwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 18:52:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2BAXwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 18:52:36 -0500
Date: Wed, 1 Feb 2012 15:52:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: rtc-linux@googlegroups.com
Cc: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        Ivan Kuten <ivan.kuten@promwad.com>
Subject: Re: [rtc-linux] [PATCH] RTC: Add driver for NXP PCF8523 RTC chip
Message-Id: <20120201155235.044d77dc.akpm@linux-foundation.org>
In-Reply-To: <1317815823-27297-1-git-send-email-yauhen.kharuzhy@promwad.com>
References: <1317815823-27297-1-git-send-email-yauhen.kharuzhy@promwad.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry, catching up on rtc things whcih I wasn't cc'ed on)

On Wed,  5 Oct 2011 14:57:03 +0300
Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com> wrote:

> This driver is based on PCF8563 driver and supports only base functions
> now: read/write date & time.
> 
>
> ...
>
> --- /dev/null
> +++ b/drivers/rtc/rtc-pcf8523.c
> @@ -0,0 +1,246 @@
> +/*
> + * An I2C driver for the NXP PCF8523 RTC
> + * Copyright 2011 Promwad Innovation Company
> + *
> + * Author: Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
> + *	Promwad Innovation Company, http://promwad.com/
> + *
> + * based on the pcf8563 driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/i2c.h>

Should this driver have a "depends on I2C" in Kconfig?

>
> ...
>
> +/*
> + * In the routines that deal directly with the pcf8523 hardware, we use
> + * rtc_time -- month 0-11, hour 0-23, yr = calendar year-epoch.
> + */
> +static int pcf8523_get_datetime(struct i2c_client *client, struct rtc_time *tm)
> +{
> +	struct pcf8523 *pcf8523 = i2c_get_clientdata(client);
> +	unsigned char buf[14] = { PCF8523_REG_CTL1 };

Please try to make local arrays such as the above "static const". 
Because the above code can needlessly cause the kernel to assemble and
evaluate the array on the stack each time this function is called.

> +	struct i2c_msg msgs[] = {
> +		{ client->addr, 0, 1, buf },	/* setup read ptr */
> +		{ client->addr, I2C_M_RD, 14, buf },	/* read status + date */
> +	};
> +
> +	/* read registers */
> +	if ((i2c_transfer(client->adapter, msgs, 2)) != 2) {
> +		dev_err(&client->dev, "%s: read error\n", __func__);
> +		return -EIO;
> +	}
> +
> +	if (buf[PCF8523_REG_CTL3] & PCF8523_CTL3_BLF)

"buf" wasn't a very good choice of name.  Is there something more
descriptive whcih we can use?

> +		dev_info(&client->dev,
> +			"low voltage detected, date/time is not reliable.\n");
> +
> +	dev_dbg(&client->dev,
> +		"%s: raw data is ctl1=%02x, ctl2=%02x, ctl3=%02x, "
> +		"sec=%02x, min=%02x, hr=%02x, "
> +		"mday=%02x, wday=%02x, mon=%02x, year=%02x\n",
> +		__func__,
> +		buf[0], buf[1], buf[2], buf[3],
> +		buf[4], buf[5], buf[6], buf[7],
> +		buf[8], buf[9]);
> +
> +
> +	tm->tm_sec = bcd2bin(buf[PCF8523_REG_SC] & 0x7F);
> +	tm->tm_min = bcd2bin(buf[PCF8523_REG_MN] & 0x7F);
> +	tm->tm_hour = bcd2bin(buf[PCF8523_REG_HR] & 0x3F); /* rtc hr 0-23 */
> +	tm->tm_mday = bcd2bin(buf[PCF8523_REG_DM] & 0x3F);
> +	tm->tm_wday = buf[PCF8523_REG_DW] & 0x07;
> +	tm->tm_mon = bcd2bin(buf[PCF8523_REG_MO] & 0x1F) - 1; /* rtc mn 1-12 */
> +	tm->tm_year = bcd2bin(buf[PCF8523_REG_YR]);
> +	if (tm->tm_year < 70)
> +		tm->tm_year += 100;	/* assume we are in 1970...2069 */
> +
> +	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d, "
> +		"mday=%d, mon=%d, year=%d, wday=%d\n",
> +		__func__,
> +		tm->tm_sec, tm->tm_min, tm->tm_hour,
> +		tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
> +
> +	/* the clock can give out invalid datetime, but we cannot return
> +	 * -EINVAL otherwise hwclock will refuse to set the time on bootup.
> +	 */

This comment seems to imply that the driver allows hwclock to set the
time to something which we know is incorrect?  If so, wouldn't it be
better to leave the time at something obviously wrong, such as 1 Jan
1970?

> +	if (rtc_valid_tm(tm) < 0)
> +		dev_err(&client->dev, "retrieved date/time is not valid.\n");
> +
> +	return 0;
> +}
> +
>
> ...
>
