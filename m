Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab1HBEn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 00:43:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60273 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab1HBEnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 00:43:52 -0400
Message-ID: <4E378043.3080801@cn.fujitsu.com>
Date: Tue, 02 Aug 2011 12:42:43 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: Anirudh Ghayal <aghayal@codeaurora.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Amy Maloche <amaloche@codeaurora.org>
Subject: Re: [PATCH] input: misc: Add support for pm8xxx based vibrator driver
References: <1312258397-11039-1-git-send-email-aghayal@codeaurora.org>
In-Reply-To: <1312258397-11039-1-git-send-email-aghayal@codeaurora.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-02 12:42:44,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-02 12:42:47,
	Serialize complete at 2011-08-02 12:42:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 12:13 PM, Anirudh Ghayal wrote:
> From: Amy Maloche<amaloche@codeaurora.org>
>
> Add support for pm8xx based vibrator to facilitate haptics.
> This module uses the ff-memless framework.
>
> Cc: Dmitry Torokhov<dmitry.torokhov@gmail.com>
> Signed-off-by: Amy Maloche<amaloche@codeaurora.org>
> Signed-off-by: Anirudh Ghayal<aghayal@codeaurora.org>
> ---
> Changes:
>     Addressed Dmitry's comments from the previous RFC submission.
>     lkml.org/lkml/2011/2/2/53
>
>   drivers/input/misc/Kconfig           |   12 ++
>   drivers/input/misc/Makefile          |    1 +
>   drivers/input/misc/pm8xxx-vibrator.c |  309 ++++++++++++++++++++++++++++++++++
>   3 files changed, 322 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/input/misc/pm8xxx-vibrator.c
>
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index c9104bb..50b9e1b 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -74,6 +74,18 @@ config INPUT_PCSPKR
>   	  To compile this driver as a module, choose M here: the
>   	  module will be called pcspkr.
>
> +config INPUT_PM8XXX_VIBRATOR
> +	tristate "Qualcomm PM8XXX vibrator support"
> +	depends on MFD_PM8XXX
> +	select INPUT_FF_MEMLESS
> +	help
> +	  This option enables device driver support for the vibrator
> +	  on Qualcomm PM8xxx chip. This driver supports ff-memless interface
> +	  from input framework.
> +
> +	  To compile this driver as module, choose M here: the
> +	  module will be called pm8xxx-vibrator.
> +
>   config INPUT_SPARCSPKR
>   	tristate "SPARC Speaker support"
>   	depends on PCI&&  SPARC64
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index 299ad5e..40ebe2b 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -34,6 +34,7 @@ obj-$(CONFIG_INPUT_PCAP)		+= pcap_keys.o
>   obj-$(CONFIG_INPUT_PCF50633_PMU)	+= pcf50633-input.o
>   obj-$(CONFIG_INPUT_PCF8574)		+= pcf8574_keypad.o
>   obj-$(CONFIG_INPUT_PCSPKR)		+= pcspkr.o
> +obj-$(CONFIG_INPUT_PM8XXX_VIBRATOR)	+= pm8xxx-vibrator.o
>   obj-$(CONFIG_INPUT_POWERMATE)		+= powermate.o
>   obj-$(CONFIG_INPUT_PWM_BEEPER)		+= pwm-beeper.o
>   obj-$(CONFIG_INPUT_PMIC8XXX_PWRKEY)	+= pmic8xxx-pwrkey.o
> diff --git a/drivers/input/misc/pm8xxx-vibrator.c b/drivers/input/misc/pm8xxx-vibrator.c
> new file mode 100644
> index 0000000..cb2d3ad
> --- /dev/null
> +++ b/drivers/input/misc/pm8xxx-vibrator.c
> @@ -0,0 +1,309 @@
> +/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include<linux/module.h>
> +#include<linux/init.h>
> +#include<linux/kernel.h>
> +#include<linux/errno.h>
> +#include<linux/platform_device.h>
> +#include<linux/input.h>
> +#include<linux/slab.h>
> +#include<linux/mfd/pm8xxx/core.h>
> +
> +#define VIB_DRV			0x4A
> +
> +#define VIB_DRV_SEL_MASK	0xf8
> +#define VIB_DRV_SEL_SHIFT	0x03
> +#define VIB_DRV_EN_MANUAL_MASK	0xfc
> +
> +#define VIB_MAX_LEVEL_mV	(3100)
> +#define VIB_MIN_LEVEL_mV	(1200)
> +#define VIB_MAX_LEVELS		(VIB_MAX_LEVEL_mV - VIB_MIN_LEVEL_mV)
> +
> +#define MAX_FF_SPEED		0xff
> +
> +/*
> + * struct pm8xxx_vib - structure to hold vibrator data
> + * @vib_input_dev: input device supporting force feedback
> + * @vwork: work structure to set the vibration parameters
Anirudh,  It's should be @work?
> + * @dev: device supporting force feedback
> + * @speed: speed of vibration set from userland
> + * @state: state of vibrator
> + * @level: level of vibration to set in the chip
> + * @reg_vib_drv: VIB_DRV register value
> + *
> + */

Thanks
Best Regards
Wanlong Gao
