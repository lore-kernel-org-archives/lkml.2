Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2K0FZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 00:25:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:33461 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab2K0FZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 00:25:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,325,1352102400"; 
   d="scan'208";a="247593332"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>, "Svahn, Kai" <kai.svahn@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>, "Lu, Aaron" <aaron.lu@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: RE: [PATCH 2/2] platform / ACPI: Attach/detach ACPI PM during
 probe/remove/shutdown
Thread-Topic: [PATCH 2/2] platform / ACPI: Attach/detach ACPI PM during
 probe/remove/shutdown
Thread-Index: AQHNyxzFNlZlS05PxESF9c/RB1aMn5f9KEcQ
Date: Tue, 27 Nov 2012 05:24:46 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88BD379D@SHSMSX101.ccr.corp.intel.com>
References: <1672179.qgDUs0YdYu@vostro.rjw.lan>
 <6227446.8xPtqi6yHi@vostro.rjw.lan>
In-Reply-To: <6227446.8xPtqi6yHi@vostro.rjw.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAR5PEfV031023

It looks cleanest unless more abstractions are introduced for other power management providers.

Best regards/Lv Zheng

> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Sunday, November 25, 2012 10:58 PM
> To: LKML
> Cc: Greg Kroah-Hartman; Linux PM list; ACPI Devel Maling List; Zhang, Rui;
> Svahn, Kai; Mika Westerberg; Huang, Ying; Lan, Tianyu; Zheng, Lv; Lu, Aaron;
> Grant Likely
> Subject: [PATCH 2/2] platform / ACPI: Attach/detach ACPI PM during
> probe/remove/shutdown
> 
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Drivers usually expect that the devices they are supposed to handle will be
> operational when their .probe() routines are called, but that need not be the
> case on some ACPI-based systems with ACPI-based device enumeration where
> the BIOSes don't put devices into D0 by default.  To work around this problem
> it is sufficient to change bus type .probe() routines to ensure that devices will
> be powered on before the drivers' .probe() routines run (and their .remove()
> and .shutdown() routines accordingly).
> 
> Modify platform_drv_probe() to run acpi_dev_pm_attach() for devices whose
> ACPI handles are present, so that ACPI power management is used to change
> their power states and change their power states to D0 before driver probing.
> Analogously, modify platform_drv_remove() and
> platform_drv_shutdown() to call acpi_dev_pm_detach() for those devices, so
> that they are not subject to ACPI PM any more.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/base/platform.c |   19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> Index: linux/drivers/base/platform.c
> ================================================================
> ===
> --- linux.orig/drivers/base/platform.c
> +++ linux/drivers/base/platform.c
> @@ -484,8 +484,16 @@ static int platform_drv_probe(struct dev  {
>  	struct platform_driver *drv = to_platform_driver(_dev->driver);
>  	struct platform_device *dev = to_platform_device(_dev);
> +	int ret;
> 
> -	return drv->probe(dev);
> +	if (ACPI_HANDLE(_dev))
> +		acpi_dev_pm_attach(_dev, true);
> +
> +	ret = drv->probe(dev);
> +	if (ret && ACPI_HANDLE(_dev))
> +		acpi_dev_pm_detach(_dev, true);
> +
> +	return ret;
>  }
> 
>  static int platform_drv_probe_fail(struct device *_dev) @@ -497,8 +505,13
> @@ static int platform_drv_remove(struct de  {
>  	struct platform_driver *drv = to_platform_driver(_dev->driver);
>  	struct platform_device *dev = to_platform_device(_dev);
> +	int ret;
> +
> +	ret = drv->remove(dev);
> +	if (ACPI_HANDLE(_dev))
> +		acpi_dev_pm_detach(_dev, true);
> 
> -	return drv->remove(dev);
> +	return ret;
>  }
> 
>  static void platform_drv_shutdown(struct device *_dev) @@ -507,6 +520,8
> @@ static void platform_drv_shutdown(struct
>  	struct platform_device *dev = to_platform_device(_dev);
> 
>  	drv->shutdown(dev);
> +	if (ACPI_HANDLE(_dev))
> +		acpi_dev_pm_detach(_dev, true);
>  }
> 
>  /**

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
