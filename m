Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab1DLXiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 19:38:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756180Ab1DLXiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 19:38:14 -0400
Date: Tue, 12 Apr 2011 16:37:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv1 3/11] RTC: RTC module of DA9052 PMIC driver
Message-Id: <20110412163743.1d7353c4.akpm@linux-foundation.org>
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B4AC209@KCINPUNHJCMS01.kpit.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B4AC209@KCINPUNHJCMS01.kpit.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Apr 2011 18:47:29 +0530
Ashish Jangam <Ashish.Jangam@kpitcummins.com> wrote:

> Hi Paul,
> 
> RTC Driver for Dialog Semiconductor DA9052 PMICs.
> 
> Changes made since last submission:
> . read and write operation moved to MFD
> 
> Linux Kernel Version: 2.6.37

The patch looks OK(ish) to me from a quick read.

> --- orig_linux-2.6.37/drivers/rtc/Kconfig	2011-01-05 05:50:19.000000000 +0500
> +++ linux-2.6.37/drivers/rtc/Kconfig	2011-03-31 21:07:39.000000000 +0500
> @@ -664,6 +664,13 @@
>  	help
>  	  If you say yes here you get support for the RTC subsystem of the
>  	  NUC910/NUC920 used in embedded systems.
> +
> +config RTC_DRV_DA9052
> +	tristate "Dialog DA9052 RTC"
> +	depends on PMIC_DA9052
> +	help
> +	  Say y here to support the RTC driver for
> +	  Dialog Semiconductor DA9052 PMIC.

But there's not much I can do with it because PMIC_DA9052 does not
exist in mainline or in linux-next.

What is a PMIC_DA9052, anyway?  What CPU architectures support it, etc?

Have you identified a maintainer who will be merging the main patch
which enables PMIC_DA9052?


Please feed all the patches through scritps/checkpatch.pl if you haven't
already done so, to clean up lots of trivial errors.

For example, "MFD: MFD module of DA9052 PMIC driver":

	total: 449 errors, 832 warnings, 2326 lines checked


A couple of minor comments:

> +static int da9052_rtc_enable_alarm(struct da9052 *da9052, unsigned char flag)
> +{
> +	int ret = 0;
> +	if (flag) {
> +		ret = da9052_set_bits(da9052, DA9052_ALARM_Y_REG,
> +					DA9052_ALARM_Y_ALARM_ON);
> +		if (ret != 0)
> +			dev_err(da9052->dev, "Failed to enable ALM: %d\n", ret);
> +	} else {
> +		ret = da9052_clear_bits(da9052, DA9052_ALARM_Y_REG,
> +					DA9052_ALARM_Y_ALARM_ON);
> +		if (ret != 0)
> +			dev_err(da9052->dev, "da9052_rtc_enable_alarm -> \
> +					da9052_clear_bits error %d\n", ret);
> +	}
> +	return ret;
> +}

"flag" is a poor identifier - it's largely meaningless.  Perhaps
"enable" would be a better choice in this case.  Making it have the
bool type wouild make sense also.

> +static irqreturn_t da9052_rtc_irq(int irq, void *data)
> +{
> +	struct da9052_rtc *rtc = (struct da9052_rtc *)data;

typecasting a void* like this is unneeded and is in fact undesirable,
as it will suppress possibly-useful warnings.


> +	int ret = 0;
> +
> +	ret = da9052_reg_read(rtc->da9052, DA9052_ALARM_MI_REG);
> +	if (ret < 0) {
> +		dev_err(rtc->da9052->dev, "da9052_rtc_notifier -> \
> +					da9052_reg_read error %d\n", ret);
> +		return IRQ_NONE;
> +	}
> +	if (ret & DA9052_ALARMMI_ALARMTYPE)
> +		da9052_rtc_enable_alarm(rtc->da9052, 0);
> +
> +	return IRQ_HANDLED;
> +}

