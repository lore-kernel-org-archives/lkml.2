Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935174Ab2JaItu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:49:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:62940 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935123Ab2JaItm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:49:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,687,1344236400"; 
   d="scan'208";a="213391200"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "jonghwa3.lee@samsung.com" <jonghwa3.lee@samsung.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Amit Dinel Kachhap <amit.kachhap@linaro.org>
Subject: RE: [PATCH v2] Thermal: exynos: Add sysfs node supporting exynos's
 emulation mode.
Thread-Topic: [PATCH v2] Thermal: exynos: Add sysfs node supporting exynos's
 emulation mode.
Thread-Index: AQHNtx7n+YMSf3Woz0ObGln8lMi8pJfS7v4Q//+9zYCAAG0cQA==
Date: Wed, 31 Oct 2012 08:49:36 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB591FDF82@BGSMSX101.gar.corp.intel.com>
References: <1351657147-26092-1-git-send-email-jonghwa3.lee@samsung.com>
 <4D68720C2E767A4AA6A8796D42C8EB591FDE36@BGSMSX101.gar.corp.intel.com>
 <5090D6F7.5040401@samsung.com>
In-Reply-To: <5090D6F7.5040401@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9V8nsEE017255

Hi,

[A big cut.]
> >> +
> >> +	mutex_lock(&data->lock);
> >> +	clk_enable(data->clk);
> >> +
> >> +	reg = readl(data->base + EXYNOS_EMUL_CON);
> >> +	enable = reg & EXYNOS_EMUL_ENABLE;
> >> +	if (!enable && !temp)
> >> +		goto out;
> > I think you what you are trying to do here is this:
> > If the emulation is already disabled, and 'this' write tries to
> > disable it again, you jump to 'out' as an optimization.
> > Please correct me if I am wrong.
> Yes, you're right. If we try to disable the emulation mode despite it already is
> disabled,
> then emulation mode will be failed and we can't use it. Because emulation
> mode has some
> strange characteristic.
> Let me explain more detail. Emulation mode requires synchronous of any
> value changing and
> enabling. It means you can't change any value (next target temperature,
> sensing time delay)
> without enabling. In this code, disabling overlapping makes problem at initial
> state. At the initial,
> there is no next target temperature and only value 1 for delay time. But if
> you try to write 0 again
> to sysfs node, temp, then it write delay time with 938us and next
> temperature with minimum
> temperature automatically. Value is changed but enable bit is still disabled.
> This is what the
> problem is happened.

Thanks for the detailed Explanation.

> >>  	}
> >> +#ifdef CONFIG_EXYNOS_THERMAL_EMUL
> >> +	device_create_file(&pdev->dev, &dev_attr_emulation);
> > Don't we want to capture the return value here ?
> > Also, if we conditionally create this, we should remove this conditionally
> also.
> > I did not see a corresponding device_remove_file for this attr.
> Sorry, It's my mistake. I'll fix it.
> >> +#endif
> > Can we club all the code inside CONFIG_*_EMUL at one place ?
> > This will make it neat, and not spread the #ifdefs all over the driver.
> I'd like to do either. But I just couldn't find a way.
> Could you give me any idea how to do it ?

I was thinking something like below:

inside #ifdef CONFIG_*_EMUL
	int register_emulation_mode(...) { device_create_file(...) };
	int unregister_emulation_mode(...) { device_remove_file(...) };
#else
	static inline int register..(...) { return 0; }
	static inline int unregister..(...) { return 0; }
#endif

Then the rest of the driver can just use register/unregister,
without worrying about #ifdef.

Thanks,
Durga
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
