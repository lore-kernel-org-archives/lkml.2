Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0DNG6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:58:17 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56020 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab0DNG6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:58:15 -0400
Message-ID: <4BC5677C.6010507@canonical.com>
Date: Tue, 13 Apr 2010 23:58:04 -0700
From: Bryan Wu <bryan.wu@canonical.com>
Reply-To: bryan.wu@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100404 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dinh.Nguyen@freescale.com
CC: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
       linux@arm.linux.org.uk, s.hauer@pengutronix.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
       valentin.longchamp@epfl.ch
Subject: Re: [PATCH 2.6.34-rc4 4/8] mx5: Add USB OTG port registration
References: <1271175030-3635-1-git-send-email-Dinh.Nguyen@freescale.com>	<1271175030-3635-2-git-send-email-Dinh.Nguyen@freescale.com>	<1271175030-3635-3-git-send-email-Dinh.Nguyen@freescale.com> <1271175030-3635-4-git-send-email-Dinh.Nguyen@freescale.com>
In-Reply-To: <1271175030-3635-4-git-send-email-Dinh.Nguyen@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2010 09:10 AM, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen<Dinh.Nguyen@freescale.com>
>
> This patch adds the device platform registration for enabling USB
> host functionality on the OTG port on Freescale MX51 Babbage HW. This
> file makes platform specific calls to initialize the USB HW.
>
> This patch applies to 2.6.34-rc4.
>
> Signed-off-by: Dinh Nguyen<Dinh.Nguyen@freescale.com>
> ---
>   arch/arm/mach-mx5/Makefile             |    2 +-
>   arch/arm/mach-mx5/board-mx51_babbage.c |    4 ++

Agree with Daniel here, this patch should be split into 2 parts, a) for usb_dr.c 
and Makefile, b) for board-mx51_babbage.c change.

And one more suggestion is merge usb_dr.c and usb_h1.c as one file usb.c. It is 
more simple to maintain and review.

-Bryan

>   arch/arm/mach-mx5/usb_dr.c             |   57 ++++++++++++++++++++++++++++++++
>   3 files changed, 62 insertions(+), 1 deletions(-)
>   create mode 100644 arch/arm/mach-mx5/usb_dr.c
>
> diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
> index bf23f86..3fca1f1 100644
> --- a/arch/arm/mach-mx5/Makefile
> +++ b/arch/arm/mach-mx5/Makefile
> @@ -3,7 +3,7 @@
>   #
>
>   # Object file lists.
> -obj-y   := cpu.o mm.o clock-mx51.o devices.o
> +obj-y   := cpu.o mm.o clock-mx51.o devices.o usb_dr.o
>
>   obj-$(CONFIG_MACH_MX51_BABBAGE) += board-mx51_babbage.o
>
> diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
> index afbe400..4e196d7 100644
> --- a/arch/arm/mach-mx5/board-mx51_babbage.c
> +++ b/arch/arm/mach-mx5/board-mx51_babbage.c
> @@ -27,6 +27,8 @@
>
>   #include "devices.h"
>
> +extern void __init mx5_usb_dr_init(void);
> +
>   static struct platform_device *devices[] __initdata = {
>   	&mxc_fec_device,
>   };
> @@ -78,6 +80,8 @@ static void __init mxc_board_init(void)
>   	platform_add_devices(devices, ARRAY_SIZE(devices));
>
>   	mxc_register_gpios();
> +
> +	mx5_usb_dr_init();
>   }
>
>   static void __init mx51_babbage_timer_init(void)
> diff --git a/arch/arm/mach-mx5/usb_dr.c b/arch/arm/mach-mx5/usb_dr.c
> new file mode 100644
> index 0000000..52273ea
> --- /dev/null
> +++ b/arch/arm/mach-mx5/usb_dr.c
> @@ -0,0 +1,57 @@
> +/*
> + * Copyright (C) 2010 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
> + * MA 02110-1301, USA.
> + */
> +
> +#include<linux/platform_device.h>
> +#include<mach/mxc_ehci.h>
> +#include<mach/common.h>
> +#include "devices.h"
> +
> +extern int usbotg_init(struct platform_device *pdev);
> +extern int usbotg_uninit(struct platform_device *pdev);
> +
> +static int usbotg_init_ext(struct platform_device *pdev);
> +static int usbotg_uninit_ext(struct platform_device *pdev);
> +
> +/*
> + * platform data structs
> + * 	- Which one to use is determined by CONFIG options in usb.h
> + * 	- operating_mode plugged at run time
> + */
> +static struct mxc_usbh_platform_data dr_utmi_config = {
> +	.init	= usbotg_init_ext,
> +	.exit	= usbotg_uninit_ext,
> +	.portsc	= MXC_EHCI_UTMI_16BIT,
> +	.flags	= MXC_EHCI_INTERNAL_PHY,
> +};
> +
> +/* Notes: configure USB clock*/
> +static int usbotg_init_ext(struct platform_device *pdev)
> +{
> +	return usbotg_init(pdev);
> +}
> +
> +static int usbotg_uninit_ext(struct platform_device *pdev)
> +{
> +	return usbotg_uninit(pdev);
> +}
> +
> +void __init mx5_usb_dr_init(void)
> +{
> +	mxc_register_device(&mxc_usbdr_host_device,&dr_utmi_config);
> +}

