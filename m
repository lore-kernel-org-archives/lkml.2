Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2K2JH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 04:07:57 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18668 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab2K2JHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 04:07:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 29 Nov 2012 01:07:32 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "Kim, Milo" <Milo.Kim@ti.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Sivaram Nair <sivaramn@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 29 Nov 2012 14:37:37 +0530
Subject: RE: [PATCH 2/2] rtc-tps65910: enable RTC power domain on
 initialization
Thread-Topic: [PATCH 2/2] rtc-tps65910: enable RTC power domain on
 initialization
Thread-Index: Ac3ODj+EBtR5lNOFQkugojWkudbjXgAASILg
Message-ID: <D958900912E20642BCBC71664EFECE3E6E17CF0A07@BGMAIL02.nvidia.com>
References: <A874F61F95741C4A9BA573A70FE3998F6418F1B3@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F6418F1B3@DQHE02.ent.ti.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Kim, Milo [mailto:Milo.Kim@ti.com]
> Sent: Thursday, November 29, 2012 2:18 PM
> To: Andrew Morton
> Cc: Samuel Ortiz; a.zummo@towertech.it; swarren@wwwdotorg.org; Venu
> Byravarasu; Sivaram Nair; linux-kernel@vger.kernel.org
> Subject: [PATCH 2/2] rtc-tps65910: enable RTC power domain on initialization
> 
>  Enabling RTC HW block depends on the default value of TPS65910 register.
>  In some mode, RTC block is disabled by default.(eg. AM3517 Craneboard)
>  In this case, RTC_PWDN(RTC power down) bit should be cleared to enable
>  the RTC HW block.

>From the description of RTC_PWDN bit of DEVCTRL_REG in TPS65910 data sheet
it is very evident that the default value of RTC_PWDN is 0.

Probably on "AM3517 Craneboard", some code is running prior to the RTC driver
which might be writing 1 on to this bit. IMO you must disable that write operation
instead of just writing default value into a register.

> 
>  This patch also works in case that RTC block is active by default,
>  because there is no side effect even if the bit is updated again.
> 
>  Tested on AM3517 Craneboard.
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/rtc/rtc-tps65910.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
> index e8d44bc..b4d9f02 100644
> --- a/drivers/rtc/rtc-tps65910.c
> +++ b/drivers/rtc/rtc-tps65910.c
> @@ -247,6 +247,13 @@ static int __devinit tps65910_rtc_probe(struct
> platform_device *pdev)
>  		return ret;
> 
>  	dev_dbg(&pdev->dev, "Enabling rtc-tps65910.\n");
> +
> +	/* Enable RTC digital power domain */
> +	ret = regmap_update_bits(tps65910->regmap, TPS65910_DEVCTRL,
> +		DEVCTRL_RTC_PWDN_MASK, 0 <<
> DEVCTRL_RTC_PWDN_SHIFT);
> +	if (ret < 0)
> +		return ret;
> +
>  	rtc_reg = TPS65910_RTC_CTRL_STOP_RTC;
>  	ret = regmap_write(tps65910->regmap, TPS65910_RTC_CTRL,
> rtc_reg);
>  	if (ret < 0)
> --
> 1.7.9.5
> 
> 
> Best Regards,
> Milo
> 

