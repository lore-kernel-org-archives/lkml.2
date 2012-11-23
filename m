Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab2KWLKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:10:52 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11335 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab2KWLKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:10:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 23 Nov 2012 03:09:47 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "p_gortmaker@yahoo.com" <p_gortmaker@yahoo.com>,
        "dchen@diasemi.com" <dchen@diasemi.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Date: Fri, 23 Nov 2012 16:39:43 +0530
Subject: RE: [Patch v3 3/7] rtc: DA9055 RTC driver
Thread-Topic: [Patch v3 3/7] rtc: DA9055 RTC driver
Thread-Index: Ac3JaIzVDc4tOlSwSFyAaOt9m28jrQAAQ1IA
Message-ID: <D958900912E20642BCBC71664EFECE3E6E1702F4A9@BGMAIL02.nvidia.com>
References: <1349952025.9228.3.camel@dhruva>
	 <1350986593.23353.3.camel@dhruva> <1353665463.1760.3000.camel@dhruva>
In-Reply-To: <1353665463.1760.3000.camel@dhruva>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qANBAuUK012589

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Ashish Jangam
> Sent: Friday, November 23, 2012 3:41 PM
> To: akpm@linux-foundation.org
> Cc: linux-kernel@vger.kernel.org; sameo@linux.intel.com;
> p_gortmaker@yahoo.com; dchen@diasemi.com; rtc-
> linux@googlegroups.com; Alessandro Zummo
> Subject: Re: [Patch v3 3/7] rtc: DA9055 RTC driver
> 
> Any comments on this patch.
> On Tue, 2012-10-23 at 15:33 +0530, Ashish Jangam wrote:
> > Does this patch looks good?
> > On Thu, 2012-10-11 at 16:10 +0530, Ashish Jangam wrote:
> > > This is the RTC patch for the DA9055 PMIC. This patch has got
> dependency on
> > > the DA9055 MFD core.
> > >
> > > This patch is functionally tested on Samsung SMDKV6410.
> > >
> > > Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> > > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> > > ---
> > > changes since version v3:
> > > - use of module_platform_driver macro
> > > - add the regmap virtual irq map API.
> > > changes since version v2:
> > > - Use of devm_request_threaded_irq API
> > > ---
> > >  drivers/rtc/Kconfig      |   10 +
> > >  drivers/rtc/Makefile     |    1 +
> > >  drivers/rtc/rtc-da9055.c |  413
> ++++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 424 insertions(+), 0 deletions(-)
> > >  mode change 100644 => 100755 drivers/rtc/Kconfig
> > >  create mode 100644 drivers/rtc/rtc-da9055.c
> > >

> > > +static int da9055_set_alarm(struct da9055 *da9055, struct rtc_time
> *rtc_tm)
> > > +{
> > > +	int ret;
> > > +	uint8_t v[2];
> > > +
> > > +	rtc_tm->tm_year -= 100;
> > > +	rtc_tm->tm_mon += 1;
> > > +
> > > +	ret = da9055_reg_update(da9055, DA9055_REG_ALARM_MI,
> > > +				DA9055_RTC_ALM_MIN, rtc_tm->tm_min);
> > > +	if (ret != 0) {
> > > +		dev_err(da9055->dev, "Failed to write ALRM MIN: %d\n",
> ret);
> > > +		return ret;
> > > +	}
> > > +
> > > +	v[0] = rtc_tm->tm_hour;
> > > +	v[1] = rtc_tm->tm_mday;
> > > +
> > > +	ret = da9055_group_write(da9055, DA9055_REG_ALARM_H, 2, v);

Why don't you write all registers at once using single multi byte
write command as you already used in da9055_rtc_set_time() ?

> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	ret = da9055_reg_update(da9055, DA9055_REG_ALARM_MO,
> > > +				DA9055_RTC_ALM_MONTH, rtc_tm-
> >tm_mon);
> > > +	if (ret < 0)
> > > +		dev_err(da9055->dev, "Failed to write ALM Month:%d\n",
> ret);

> > > +
> > > +static int da9055_rtc_set_time(struct device *dev, struct rtc_time *tm)
> > > +{
> > > +	struct da9055_rtc *rtc;
> > > +	uint8_t v[6];
> > > +
> > > +	rtc = dev_get_drvdata(dev);
> > > +
> > > +	v[0] = tm->tm_sec;
> > > +	v[1] = tm->tm_min;
> > > +	v[2] = tm->tm_hour;
> > > +	v[3] = tm->tm_mday;
> > > +	v[4] = tm->tm_mon + 1;
> > > +	v[5] = tm->tm_year - 100;
> > > +
> > > +	return da9055_group_write(rtc->da9055, DA9055_REG_COUNT_S, 6,
> v);
> > > +}
> > > +
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
