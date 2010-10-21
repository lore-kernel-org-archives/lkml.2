Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab0JUIGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:06:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64954 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0JUIFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:05:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: vt8500-wm8505-linux-kernel@googlegroups.com
Subject: Re: [PATCH 1/6] ARM: Add basic architecture support for VIA/WonderMedia 85xx SoC's
Date: Thu, 21 Oct 2010 10:05:42 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-19-generic; KDE/4.5.1; x86_64; ; )
Cc: Alexey Charkov <alchark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
References: <1287608139-21354-1-git-send-email-alchark@gmail.com>
In-Reply-To: <1287608139-21354-1-git-send-email-alchark@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010211005.42866.arnd@arndb.de>
X-Provags-ID: V02:K0:IvB9Lo1aosZXIhsejrdy/OIzQrW+qvxgdFnFocknBcs
 fzqdli+agsMnws/iZVlFj5YIKbDjWnTOJHB1eqhyN8PfOvn5kl
 ZQ3/HCHff0ZZ5/v8gLqaqx4Uw/noa0WmuHVOlOM8B2okiVgVfm
 DIchNPLIjfTzaTyonsp0nj02oG3lqnLpX1adFHFKIRTLJ/lDlz
 EKhvZsN4wLA/F4QanxRpQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 October 2010 22:55:33 Alexey Charkov wrote:

> Please review and state whether this could be acceptable for a merge
> to mainline in the coming 2.6.37 window. If possible, I would deeply
> appreciate a merge to a relevant git tree for integration prior to
> asking Linus to pull the changes. I could rebase the code if needed,
> currently this is against Linus' master branch.

As Greg mentioned for his review of the serial drivers, it's too late
for 2.6.37. Fortunately that means you're really early for 2.6.38
and getting it in there should be easy.

The code does look very good though overall.

> +
> +choice
> +	prompt "LCD panel size"
> +	depends on (FB_VT8500 || FB_WM8505)
> +	default WMT_PANEL_800X480
> +
> +config WMT_PANEL_800X480
> +	bool "7-inch with 800x480 resolution"
> +	help
> +	  These are found in most of the netbooks in generic cases, as
> +	  well as in Eken M001 tablets and possibly elsewhere.
> +
> +config WMT_PANEL_800X600
> +	bool "8-inch with 800x600 resolution"
> +	help
> +	  These are found in Eken M003 tablets and possibly elsewhere.
> +
> +config WMT_PANEL_1024X600
> +	bool "10-inch with 1024x600 resolution"
> +	help
> +	  These are found in Eken M006 tablets and possibly elsewhere.
> +
> +endchoice

This should really be a run-time or at least boot-time option. If you
set the frame buffer size at compile time, I guess you can no longer
boot on a machine that uses a different size.

> +#include <mach/vt8500.h>
> +#include "devices.h"
> +
> +static struct platform_device *devices[] __initdata = {
> +	&vt8500_device_uart0,
> +#ifdef CONFIG_FB_VT8500
> +	&vt8500_device_lcdc,
> +#endif
> +#ifdef CONFIG_USB_EHCI_HCD
> +	&vt8500_device_ehci,
> +#endif
> +#ifdef CONFIG_FB_WMT_GE_ROPS
> +	&vt8500_device_ge_rops,
> +#endif
> +#ifdef CONFIG_HAVE_PWM
> +	&vt8500_device_pwm,
> +#endif
> +#ifdef CONFIG_BACKLIGHT_PWM
> +	&vt8500_device_pwmbl,
> +#endif
> +#ifdef CONFIG_RTC_DRV_VT8500
> +	&vt8500_device_rtc,
> +#endif
> +};

This doesn't work if the drivers are built as loadable modules, right?
I wouldn't even make the definitions of the devices configuration dependent.
The idea of the device model is that you describe what you have in one
place and use that information to load the drivers for it.

> +#ifdef CONFIG_VTWM_VERSION_WM8505
> +extern struct platform_device vt8500_device_uart4;
> +extern struct platform_device vt8500_device_uart5;
> +#endif
> +
> +#ifdef CONFIG_FB_VT8500
> +extern struct platform_device vt8500_device_lcdc;
> +#endif
> +#ifdef CONFIG_FB_WM8505
> +extern struct platform_device vt8500_device_wm8505_fb;
> +#endif
> +
> +#ifdef CONFIG_USB_EHCI_HCD
> +extern struct platform_device vt8500_device_ehci;
> +#endif
> +
> +#ifdef CONFIG_FB_WMT_GE_ROPS
> +extern struct platform_device vt8500_device_ge_rops;
> +#endif
> +#ifdef CONFIG_HAVE_PWM
> +extern struct platform_device vt8500_device_pwm;
> +#endif
> +#ifdef CONFIG_BACKLIGHT_PWM
> +extern struct platform_device vt8500_device_pwmbl;
> +#endif
> +#ifdef CONFIG_RTC_DRV_VT8500
> +extern struct platform_device vt8500_device_rtc;
> +#endif

The declarations never belong in an #ifdef, just make them
unconditional.

> +#ifndef __ASM_ARM_ARCH_IO_H
> +#define __ASM_ARM_ARCH_IO_H
> +
> +#define IO_SPACE_LIMIT 0xffffffff
> +
> +#define __io(a)		__typesafe_io(a)
> +#define __mem_pci(a)	(a)
> +
> +#endif


This won't work if you ever want to use the PCI on vt8505 with devices
that have I/O space mapping.

You need to define IO_SPACE_LIMIT to the size of your I/O space and
make the __io macro offset the address with the start of that window.

	Arnd
