Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab3AEChr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 21:37:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:26348 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568Ab3AECho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 21:37:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,413,1355126400"; 
   d="scan'208";a="267648951"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Cheng, Anton" <anton.cheng@intel.com>,
        "Palanisamy, Kanda K" <kanda.k.palanisamy@intel.com>,
        "Gough, Robert" <robert.gough@intel.com>,
        "Weyhing, Linda" <linda.weyhing@intel.com>,
        "Kalowsky, Daniel" <daniel.kalowsky@intel.com>
Subject: RE: [PATCH 1/6] ACPI / PM: Change the way power transitions to
 D3cold are carried out
Thread-Topic: [PATCH 1/6] ACPI / PM: Change the way power transitions to
 D3cold are carried out
Thread-Index: AQHN6sa5G6ENQZQ/aE+fdik3QFR785g5/YzQ
Date: Sat, 5 Jan 2013 02:37:35 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88BDD5F8@SHSMSX101.ccr.corp.intel.com>
References: <2311196.icSMDvAsYg@vostro.rjw.lan>
 <3421785.2lTFog1i8W@vostro.rjw.lan>
In-Reply-To: <3421785.2lTFog1i8W@vostro.rjw.lan>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r052bo69017187

Thanks for your patch, it might be useful as_PR3 off method of I2C hosts and targets might be different from their _PR0 off method, ACPI BIOS may implement protection in the _PR3 off method in order not to break the transactions during the powering off process:
As I2C is wired-AND logic bus, if a device will be LOW on SDA or SCL during the powering off process, it will pull the bus from HIGH to LOW which may break the current transaction on the bus that targeted to another slave device.

I just wonder one more thing which is not related to the ACPI BIOS.
If busses like I2C have such "non-hotpluggable" nature, we need to cut power of single target device only when there are not any transactions visible in the same segment.

How could an equivalent solution be implemented in the Linux kernel for I2C busses?
It could be useful for those platforms without such firmware deployed to protect the OS.

It seems we may need to redesign acpi_device_set_power/acpi_device_power_state to meet the following requirements:
1. suspend/resume -> One function can be used to switch device power state from 0 to 3 or 3 to 0.
2. poweroff -> One function can be used to cut device power currently applied.
And we may need new interface in the power core as "poweroff" (maybe also poweron) or likewise for platform_suspend/hibernate_ops.

Then I2C in the kernel can also implement a solution putting all of the devices (the masters and all of their slaves) in one segment (where there is wired-AND logic) into D3 (suspend all non-hotpluggable devices in one segment), and "poweroff" one of them when there are not any transactions visible on the bus.

Thanks and best regards
-Lv

> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> Sent: Saturday, January 05, 2013 6:00 AM
> To: ACPI Devel Maling List
> Cc: LKML; Len Brown; Zheng, Lv; Huang, Ying
> Subject: [PATCH 1/6] ACPI / PM: Change the way power transitions to D3cold
> are carried out
> 
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> During power transitions into D3cold from any shallower power states we are
> supposed to transition the device into D3hot and remove power from it
> afterward, but the current code in acpi_device_set_power() doesn't work this
> way.
> 
> At the same time, though, we need to be careful enough to preserve
> backwards compatibility for systems that don't distinguish between D3hot and
> D3cold (e.g. designed before ACPI 4).
> 
> Modify acpi_device_set_power() so that it works in accordance with the
> expectations in both cases.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/bus.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> Index: linux/drivers/acpi/bus.c
> ================================================================
> ===
> --- linux.orig/drivers/acpi/bus.c
> +++ linux/drivers/acpi/bus.c
> @@ -270,6 +270,7 @@ int acpi_device_set_power(struct acpi_de
>  	int result = 0;
>  	acpi_status status = AE_OK;
>  	char object_name[5] = { '_', 'P', 'S', '0' + state, '\0' };
> +	bool cut_power = false;
> 
>  	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
>  		return -EINVAL;
> @@ -294,9 +295,13 @@ int acpi_device_set_power(struct acpi_de
>  		return -ENODEV;
>  	}
> 
> -	/* For D3cold we should execute _PS3, not _PS4. */
> -	if (state == ACPI_STATE_D3_COLD)
> +	/* For D3cold we should first transition into D3hot. */
> +	if (state == ACPI_STATE_D3_COLD
> +	    &&
> device->power.states[ACPI_STATE_D3_COLD].flags.os_accessible) {
> +		state = ACPI_STATE_D3_HOT;
>  		object_name[3] = '3';
> +		cut_power = true;
> +	}
> 
>  	/*
>  	 * Transition Power
> @@ -341,6 +346,9 @@ int acpi_device_set_power(struct acpi_de
>  		}
>  	}
> 
> +	if (cut_power)
> +		result = acpi_power_transition(device, ACPI_STATE_D3_COLD);
> +
>        end:
>  	if (result)
>  		printk(KERN_WARNING PREFIX

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
