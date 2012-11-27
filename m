Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab2K0VgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 16:36:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab2K0VgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 16:36:15 -0500
Date: Tue, 27 Nov 2012 13:36:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] rtc: Add NXP PCF8523 support
Message-Id: <20121127133614.c8ff3be2.akpm@linux-foundation.org>
In-Reply-To: <1353683857-20010-1-git-send-email-thierry.reding@avionic-design.de>
References: <1353683857-20010-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012 16:17:37 +0100
Thierry Reding <thierry.reding@avionic-design.de> wrote:

> This commit adds an RTC driver for PCF8523 chips by NXP Semiconductors.
> No support is currently provided for the alarm and interrupt functions.
> Only the time and date functionality is implemented.
> 
> ...
>
> +static int pcf8523_rtc_read_time(struct device *dev, struct rtc_time *tm)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	u8 start = REG_SECONDS, regs[7];
> +	struct i2c_msg msgs[2];
> +	int err;
> +
> +	msgs[0].addr = client->addr;
> +	msgs[0].flags = 0;
> +	msgs[0].len = 1;
> +	msgs[0].buf = &start;
> +
> +	msgs[1].addr = client->addr;
> +	msgs[1].flags = I2C_M_RD;
> +	msgs[1].len = sizeof(regs);
> +	msgs[1].buf = regs;
> +
> +	err = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
> +	if (err < 0)
> +		return err;
> +
> +	if (regs[0] & REG_SECONDS_OS) {
> +		dev_dbg(dev, "clock integrity is not guaranteed\n");
> +
> +		/* try to clear the flag */

The comment explains the "what", which was pretty obvious from the code.

But readers want to know "why".

> +		regs[0] &= ~REG_SECONDS_OS;
> +
> +		err = pcf8523_write(client, REG_SECONDS, regs[0]);
> +		if (err < 0)
> +			return err;
> +	}
> +
> +	tm->tm_sec = bcd2bin(regs[0] & 0x7f);
> +	tm->tm_min = bcd2bin(regs[1] & 0x7f);
> +	tm->tm_hour = bcd2bin(regs[2] & 0x3f);
> +	tm->tm_mday = bcd2bin(regs[3] & 0x3f);
> +	tm->tm_wday = regs[4] & 0x7;
> +	tm->tm_mon = bcd2bin(regs[5] & 0x1f);
> +	tm->tm_year = bcd2bin(regs[6]) + 100;
> +
> +	return rtc_valid_tm(tm);
> +}
> +
> +static int pcf8523_rtc_set_time(struct device *dev, struct rtc_time *tm)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct i2c_msg msg;
> +	u8 regs[8];
> +	int err;
> +
> +	err = pcf8523_stop_rtc(client);
> +	if (err < 0)
> +		return err;
> +
> +	regs[0] = REG_SECONDS;
> +	regs[1] = bin2bcd(tm->tm_sec);
> +	regs[2] = bin2bcd(tm->tm_min);
> +	regs[3] = bin2bcd(tm->tm_hour);
> +	regs[4] = bin2bcd(tm->tm_mday);
> +	regs[5] = tm->tm_wday;
> +	regs[6] = bin2bcd(tm->tm_mon);
> +	regs[7] = bin2bcd(tm->tm_year - 100);
> +
> +	msg.addr = client->addr;
> +	msg.flags = 0;
> +	msg.len = sizeof(regs);
> +	msg.buf = regs;
> +
> +	err = i2c_transfer(client->adapter, &msg, 1);
> +	if (err < 0)
> +		return err;

Should we restart the rtc if the transfer failed?

> +	return pcf8523_start_rtc(client);
> +}
> 
> ...
>

