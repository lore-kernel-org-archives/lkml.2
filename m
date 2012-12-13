Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab2LMVjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 16:39:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab2LMVjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 16:39:41 -0500
Date: Thu, 13 Dec 2012 13:39:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <p_gortmaker@yahoo.com>, <dchen@diasemi.com>,
        <rtc-linux@googlegroups.com>, Alessandro Zummo <a.zummo@towertech.it>,
        shubhro <omaplinuxkernel@gmail.com>
Subject: Re: [Patch v3 3/7] rtc: DA9055 RTC driver
Message-Id: <20121213133940.18b6d7d4.akpm@linux-foundation.org>
In-Reply-To: <1355403860.2353.4.camel@dhruva>
References: <1349952025.9228.3.camel@dhruva>
	<1350986593.23353.3.camel@dhruva>
	<1353665463.1760.3000.camel@dhruva>
	<20121127142358.9a4bc20d.akpm@linux-foundation.org>
	<1354094680.10949.1.camel@dhruva>
	<1355118149.4272.1.camel@dhruva>
	<20121212131108.1e158ae2.akpm@linux-foundation.org>
	<1355403860.2353.4.camel@dhruva>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2012 18:34:20 +0530
Ashish Jangam <ashish.jangam@kpitcummins.com> wrote:

> (This rtc patch is resend for merge)
> ---
> This is the RTC patch for the DA9055 PMIC. This patch has got dependency on
> the DA9055 MFD core.
> 
> This patch is functionally tested on Samsung SMDKV6410.
> 
> ...
>
> +static int __init da9055_rtc_device_init(struct da9055 *da9055,
> +					struct da9055_pdata *pdata)
> +{
> +	int ret;
> +
> +	/* Enable RTC and the internal Crystal */
> +	ret = da9055_reg_update(da9055, DA9055_REG_CONTROL_B,
> +				DA9055_RTC_EN, DA9055_RTC_EN);
> +	if (ret < 0)
> +		return ret;
> +	ret = da9055_reg_update(da9055, DA9055_REG_EN_32K,
> +				DA9055_CRYSTAL_EN, DA9055_CRYSTAL_EN);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Enable RTC in Power Down mode */
> +	ret = da9055_reg_update(da9055, DA9055_REG_CONTROL_B,
> +				DA9055_RTC_MODE_PD, DA9055_RTC_MODE_PD);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Enable RTC in Reset mode */
> +	if (pdata && pdata->reset_enable) {
> +		ret = da9055_reg_update(da9055, DA9055_REG_CONTROL_B,
> +					DA9055_RTC_MODE_SD,
> +					DA9055_RTC_MODE_SD <<
> +					DA9055_RTC_MODE_SD_SHIFT);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	/* Disable the RTC TICK ALM */
> +	ret = da9055_reg_update(da9055, DA9055_REG_ALARM_MO,
> +				DA9055_RTC_TICK_WAKE_MASK, 0);
> +	if (ret < 0)
> +		return ret;

If one of these failure paths is taken, the hardware will be left in a
part-initialised state.  Is this wise?

> +	return 0;
> +}

