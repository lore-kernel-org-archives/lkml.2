Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab0F3Qbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 12:31:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59926 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab0F3Qbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 12:31:34 -0400
Date: Wed, 30 Jun 2010 17:31:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Dajun Chen <Dajun.Chen@diasemi.com>
Cc: p_gortmaker@yahoo.com, linux-kernel@vger.kernel.org,
       Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Subject: Re: [PATCHv1 3/11] RTC: Removal of redundant comments, printk
Message-ID: <20100630163130.GD5832@sirena.org.uk>
References: <3495EC08FA53E94AAA00CC4743D5BA7E013FA7ED@pandora.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3495EC08FA53E94AAA00CC4743D5BA7E013FA7ED@pandora.diasemi.com>
X-Cookie: Slow day.  Practice crawling.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 02:16:55PM +0100, David Dajun Chen wrote:
> RTC module of the device driver for DA9052 PMIC device from Dialog
> Semiconductor.

Adding Alessandro and the RTC list.  As you have been reminded
repeatedly you should CC all the relevant maintainers and lists on
patches.

> +config RTC_DRV_DA9052
> +	tristate "Support RTC on Dialog Semiconductor DA9052 PMIC"
> +	depends on PMIC_DA9052
> +	help
> +	  Say y here to support the RTC found on
> +	  Dialog Semiconductor DA9052 PMIC.

Kconfig and Makefile entries should be sorted.

> +	if (msg.data & DA9052_ALARMMI_ALARMTYPE)
> +		printk(KERN_INFO "RTC: TIMER ALARM\n");
> +	else
> +		printk(KERN_INFO "RTC: TICK ALARM\n");

This logging seems inappropriate - you should be notifying the RTC
subsystem of the events rather than logging them (loudly).

> +static int da9052_rtc_validate_parameters(struct rtc_time *rtc_tm)
> +{
> +
> +	if (rtc_tm->tm_sec > DA9052_RTC_SECONDS_LIMIT)
> +		return DA9052_RTC_INVALID_SECONDS;

Are these limits different to those enforced by rtc_valid_tm()?
If there are any additional restrictions it'd be better to call that and
only implement the additional checks that are required by the specific
chip.  If checks apply to all times then adding them to rtc_valid_tm()
would be better.

> +	if (ENABLE == flag)
> +		msg.data = msg.data | DA9052_ALARMY_ALARMON;
> +	else if (DISABLE == flag)
> +		msg.data = msg.data & ~(DA9052_ALARMY_ALARMON);

This can just be written as

	if (flag)
		...
	else
		...

which is much more idiomatic.

> +	da9052_lock(da9052);
> +	ret = da9052->read(da9052, &ssc_msg);
> +	if (ret) {
> +		da9052_unlock(da9052);
> +		return ret;
> +	}
> +	da9052_unlock(da9052);
> +
> +	data = ret;
> +
> +	ssc_msg.data = data &= ~DA9052_IRQMASKA_MALRAM;
> +
> +	da9052_lock(da9052);
> +	ret = da9052->write(da9052, &ssc_msg);
> +	da9052_unlock(da9052);

This has the locking problem with read/modify/write sequences I
mentioned in reply to the regulator driver.

> +static int da9052_rtc_class_ops_settime(struct device *dev, struct
> rtc_time *tm)
> +{
> +	int ret;
> +	struct da9052_rtc *priv = dev_get_drvdata(dev);
> +
> +	ret = da9052_rtc_settime(priv->da9052, tm);
> +
> +	return ret;
> +}

Separating the class operations and the actual implementations like this
looks a bit odd - what does it add?

> +/* Months */
> +#define FEBRUARY					(2)
> +#define APRIL						(4)
> +#define JUNE						(6)
> +#define	SEPTEMBER					(9)
> +#define NOVEMBER					(11)

These are *very* generic things to be defining in a driver specific
header with no namespacing, and it seems odd that you'd need them at
all.

> +/* RTC error codes */
> +#define DA9052_RTC_INVALID_SECONDS			(3)
> +#define DA9052_RTC_INVALID_MINUTES			(4)
> +#define DA9052_RTC_INVALID_HOURS			(5)
> +#define DA9052_RTC_INVALID_DAYS				(6)
> +#define DA9052_RTC_INVALID_MONTHS			(7)
> +#define DA9052_RTC_INVALID_YEARS			(8)
> +#define DA9052_RTC_INVALID_EVENT			(9)
> +#define DA9052_RTC_INVALID_IOCTL			(10)
> +#define DA9052_RTC_INVALID_SETTING			(11)
> +#define DA9052_RTC_EVENT_ALREADY_REGISTERED		(12)
> +#define DA9052_RTC_EVENT_UNREGISTERED			(13)
> +#define DA9052_RTC_EVENT_REGISTRATION_FAILED		(14)
> +#define DA9052_RTC_EVENT_UNREGISTRATION_FAILED		(15)

Rather than defining custom error codes you should use standard Linux
error codes.  These also overlap with the standard Linux codes.
