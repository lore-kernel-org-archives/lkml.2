Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067Ab0EYUxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:53:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758539Ab0EYUxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:53:15 -0400
Date: Tue, 25 May 2010 13:51:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
       Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
       <STEricsson_nomadik_linux@list.st.com>,
       Virupax Sadashivpetimath 
	<virupax.sadashivpetimath@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] rtc: AB8500 RTC driver
Message-Id: <20100525135159.166d91c6.akpm@linux-foundation.org>
In-Reply-To: <1274453796-9141-1-git-send-email-rabin.vincent@stericsson.com>
References: <1274453796-9141-1-git-send-email-rabin.vincent@stericsson.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 20:26:36 +0530
Rabin Vincent <rabin.vincent@stericsson.com> wrote:

> From: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
> 
> Add a driver for the RTC on the AB8500 power management chip.  This is a
> client of the AB8500 MFD driver.
> 
>
> ...
>
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -611,6 +611,14 @@ config RTC_DRV_AB3100
>  	  Select this to enable the ST-Ericsson AB3100 Mixed Signal IC RTC
>  	  support. This chip contains a battery- and capacitor-backed RTC.
>  
> +config RTC_DRV_AB8500
> +	tristate "ST-Ericsson AB8500 RTC"
> +	depends on AB8500_CORE
> +	default y

Really?  So all AB8500_CORE users will get to include this driver in
their builds just by running `make oldconfig'?

> +	help
> +	  Select this to enable the ST-Ericsson AB8500 power management IC RTC
> +	  support. This chip contains a battery- and capacitor-backed RTC.
> +
>
> ...
>
> +static unsigned long get_elapsed_seconds(int year)
> +{
> +	unsigned long secs;
> +	struct rtc_time tm;
> +
> +	memset(&tm, 0, sizeof(tm));
> +	tm.tm_year = year - 1900;
> +	tm.tm_mon  = 0;
> +	tm.tm_mday  = 1;

It would be neater to do

	struct rtc_time tm = {
		.tm_year = year - 1900,
		.tm_mday = 1,
	};

> +	/*
> +	 * This function calculates secs from 1970 and not from
> +	 * 1900, even if we supply the offset from year 1900.
> +	 */
> +	rtc_tm_to_time(&tm, &secs);
> +	return secs;
> +}
> +
> +static int ab8500_rtc_read_time(struct device *dev, struct rtc_time *tm)
> +{
> +	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
> +	unsigned long timeout = jiffies + HZ;
> +	int retval, i;
> +	unsigned long mins, secs;
> +	unsigned char buf[5];
> +	const unsigned long time_regs[] = {AB8500_RTC_WATCH_TMIN_HI_REG,
> +		AB8500_RTC_WATCH_TMIN_MID_REG, AB8500_RTC_WATCH_TMIN_LOW_REG,
> +		AB8500_RTC_WATCH_TSECHI_REG, AB8500_RTC_WATCH_TSECMID_REG};

iirc, the compiler will quietly treat this as `static const', which is
what we want.

> +	/* Request a data read */
> +	retval = ab8500_write(ab8500, AB8500_RTC_READ_REQ_REG,
> +			      RTC_READ_REQUEST);
> +	if (retval < 0)
> +		return retval;
> +
> +	if (!ab8500->revision) {
> +		msleep(1);

This bit needs a comment.  Because there's no way of understanding it
by reading the code!

> +	} else {
> +		/* Wait for some cycles after enabling the rtc read in ab8500 */
> +		while (time_before(jiffies, timeout)) {
> +			retval = ab8500_read(ab8500, AB8500_RTC_READ_REQ_REG);
> +			if (retval < 0)
> +				return retval;
> +
> +			if (!(retval & RTC_READ_REQUEST))
> +				break;
> +
> +			msleep(1);
> +		}
> +	}
> +
> +	/* Read the Watchtime registers */
> +	for (i = 0; i < ARRAY_SIZE(time_regs); i++) {
> +		retval = ab8500_read(ab8500, time_regs[i]);
> +		if (retval < 0)
> +			return retval;
> +		buf[i] = retval;
> +	}
> +
> +	mins = (buf[0] << 16) | (buf[1] << 8) | buf[2];
> +
> +	secs =	(buf[3] << 8) | buf[4];
> +	secs =	secs / COUNTS_PER_SEC;
> +	secs =	secs + (mins * 60);
> +
> +	/* Add back the initially subtracted number of seconds */
> +	secs += get_elapsed_seconds(AB8500_RTC_EPOCH);
> +
> +	rtc_time_to_tm(secs, tm);
> +	return rtc_valid_tm(tm);
> +}
> +
> +static int ab8500_rtc_set_time(struct device *dev, struct rtc_time *tm)
> +{
> +	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
> +	int retval, i;
> +	unsigned char buf[5];
> +	unsigned long no_secs, no_mins, secs = 0;
> +	const unsigned long time_regs[] = {AB8500_RTC_WATCH_TMIN_HI_REG,
> +		AB8500_RTC_WATCH_TMIN_MID_REG,
> +		AB8500_RTC_WATCH_TMIN_LOW_REG, AB8500_RTC_WATCH_TSECHI_REG,
> +		AB8500_RTC_WATCH_TSECMID_REG};
> +
> +	if (tm->tm_year < (AB8500_RTC_EPOCH - 1900)) {
> +		dev_err(dev, "year should be equal to or more than %d\n",
> +				AB8500_RTC_EPOCH);

hm, is this really worth the console spam?

"equal to or greater than" would sound more mathematical ;)

> +		return -EINVAL;
> +	}
> +
> +	/* Get the number of seconds since 1970 */
> +	rtc_tm_to_time(tm, &secs);
> +
> +	/*
> +	 * Convert it to the number of seconds since 01-01-2000 00:00:00, since
> +	 * we only have a small counter in the RTC.
> +	 */
> +	secs -= get_elapsed_seconds(AB8500_RTC_EPOCH);
> +
> +	no_mins = secs / 60;
> +
> +	no_secs = secs % 60;
> +	/* Make the seconds count as per the RTC resolution */
> +	no_secs = no_secs * COUNTS_PER_SEC;
> +
> +	buf[4] = no_secs & 0xFF;
> +	buf[3] = (no_secs >> 8) & 0xFF;
> +
> +	buf[2] = no_mins & 0xFF;
> +	buf[1] = (no_mins >> 8) & 0xFF;
> +	buf[0] = (no_mins >> 16) & 0xFF;
> +
> +	for (i = 0; i < ARRAY_SIZE(time_regs); i++) {
> +		retval = ab8500_write(ab8500, time_regs[i], buf[i]);
> +		if (retval < 0)
> +			return retval;
> +	}
> +
> +	/* Request a data write */
> +	return ab8500_write(ab8500, AB8500_RTC_READ_REQ_REG, RTC_WRITE_REQUEST);
> +}
> +
>
> ...
>
> +static int __devexit ab8500_rtc_remove(struct platform_device *pdev)
> +{
> +	struct rtc_device *rtc = platform_get_drvdata(pdev);
> +	int irq = platform_get_irq_byname(pdev, "ALARM");

Seems a bit fragile.  I guess that platform_get_irq_byname("ALARM")
will always return the same value, but still.  Would it be better to
store the irq number in private storage?  Unsure..


> +	if (irq >= 0)
> +		free_irq(irq, rtc);
> +
> +	rtc_device_unregister(rtc);
> +	platform_set_drvdata(pdev, NULL);
> +
> +	return 0;
> +}
> +
>
> ...
>

