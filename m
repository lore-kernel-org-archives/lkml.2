Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab0JUMBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 08:01:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63840 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab0JUMB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 08:01:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Charkov <alchark@gmail.com>
Subject: Re: [PATCH 1/6] ARM: Add basic architecture support for VIA/WonderMedia 85xx SoC's
Date: Thu, 21 Oct 2010 14:01:52 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
References: <1287608139-21354-1-git-send-email-alchark@gmail.com> <201010211005.42866.arnd@arndb.de> <AANLkTin+BOEJUjaUB-fTXY+iTAa4wDthd+QhE-VuFGFW@mail.gmail.com>
In-Reply-To: <AANLkTin+BOEJUjaUB-fTXY+iTAa4wDthd+QhE-VuFGFW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010211401.53001.arnd@arndb.de>
X-Provags-ID: V02:K0:PWkCZG2/buN+WgpFS6YtdDqsk+9IJ8EHXtLVc2YvF6N
 22AnSX6XzoCvtmuwuHYzmtlz6nGWjaVMRifj/SPw09x28AXzh5
 W8tam8jNos2KRKfbHihDJj4PB5eD8XyghKNamnW6RdihcOHKOi
 tezY0q3B9X4SCGp+VFUi9O1MxD+RJwairTl0wBIASgMBIFcRV7
 C8e96VeqqQMpxMWWhQItQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 October 2010, Alexey Charkov wrote:

> >> +
> >> +choice
> >> +     prompt "LCD panel size"
> >> +     depends on (FB_VT8500 || FB_WM8505)
> >> +     default WMT_PANEL_800X480
> >> +
> >> +config WMT_PANEL_800X480
> >> +     bool "7-inch with 800x480 resolution"
> >> +     help
> >> +       These are found in most of the netbooks in generic cases, as
> >> +       well as in Eken M001 tablets and possibly elsewhere.
> >> +
> >> +config WMT_PANEL_800X600
> >> +     bool "8-inch with 800x600 resolution"
> >> +     help
> >> +       These are found in Eken M003 tablets and possibly elsewhere.
> >> +
> >> +config WMT_PANEL_1024X600
> >> +     bool "10-inch with 1024x600 resolution"
> >> +     help
> >> +       These are found in Eken M006 tablets and possibly elsewhere.
> >> +
> >> +endchoice
> >
> > This should really be a run-time or at least boot-time option. If you
> > set the frame buffer size at compile time, I guess you can no longer
> > boot on a machine that uses a different size.
> >
> 
> It could be, but then I'd have to parse kernel command line at the
> map_io stage. Is that fine? If yes, I could rework it to e.g. accept a
> default value via Kconfig and allow it to be overriden via a boot
> argument.

Parsing complex options in general is not ok, but something simpler
probably is.

Having a Kconfig selected default is probably a good idea. The most
simple way to select this at boot time would be to have a list of
possible resolutions and pass a table index.

Would a __setup() call work for you?
 
> And due to the fact that the framebuffer size calculation is tied to
> panel specification, it will boot in any case. The only problem that
> one could encounter would be suboptimal display (for example,
> offscreen pixmaps to become actually visible on screen if the panel is
> taller
> than expected, or some corruption in case it is wider).

Another option might be to have a submenu with the possible resolutions
you want to allow and size the frame buffer for the largest of those,
but allow overriding the actual one at boot time.
 
> >> +#include <mach/vt8500.h>
> >> +#include "devices.h"
> >> +
> >> +static struct platform_device *devices[] __initdata = {
> >> +     &vt8500_device_uart0,
> >> +#ifdef CONFIG_FB_VT8500
> >> +     &vt8500_device_lcdc,
> >> +#endif
> >> +#ifdef CONFIG_USB_EHCI_HCD
> >> +     &vt8500_device_ehci,
> >> +#endif
> >> +#ifdef CONFIG_FB_WMT_GE_ROPS
> >> +     &vt8500_device_ge_rops,
> >> +#endif
> >> +#ifdef CONFIG_HAVE_PWM
> >> +     &vt8500_device_pwm,
> >> +#endif
> >> +#ifdef CONFIG_BACKLIGHT_PWM
> >> +     &vt8500_device_pwmbl,
> >> +#endif
> >> +#ifdef CONFIG_RTC_DRV_VT8500
> >> +     &vt8500_device_rtc,
> >> +#endif
> >> +};
> >
> > This doesn't work if the drivers are built as loadable modules, right?
> > I wouldn't even make the definitions of the devices configuration dependent.
> > The idea of the device model is that you describe what you have in one
> > place and use that information to load the drivers for it.
> >
> 
> But with loadable modules those symbols should still be defined as 'm'
> or something, shouldn't they? Anyway, I'll drop those conditions,
> thanks for pointing out.

If you configure an option as a module you get e.g. CONFIG_USB_EHCI_HCD_MODULE=1,
but CONFIG_USB_EHCI_HCD remains unset. It would be possible to check for
both of them, but IMHO it's cleaner to just leave the code in unconditionally.

> >> +#ifndef __ASM_ARM_ARCH_IO_H
> >> +#define __ASM_ARM_ARCH_IO_H
> >> +
> >> +#define IO_SPACE_LIMIT 0xffffffff
> >> +
> >> +#define __io(a)              __typesafe_io(a)
> >> +#define __mem_pci(a) (a)
> >> +
> >> +#endif
> >
> >
> > This won't work if you ever want to use the PCI on vt8505 with devices
> > that have I/O space mapping.
> >
> > You need to define IO_SPACE_LIMIT to the size of your I/O space and
> > make the __io macro offset the address with the start of that window.
> >
> 
> The problem is that there is no documentation available for the PCI
> bus in these systems (if it is even implemented there).
> Vendor-provided sources do not really clarify it either, which you
> have commented about at:
> http://groups.google.com/group/vt8500-wm8505-linux-kernel/msg/97bf44bc5ea5d46a?
> 
> With no possibilities to test this (as I don't know any of these
> devices to really use PCI with enumeration rather than just static
> platform-like definitions as in the vendor's kernel), I just can't
> imagine how this could be done any better.

I can have a look again. It shouldn't be hard to do an almost correct
implementation based on the source code we have, but I only own a wm8505
based device, so I also have no way of testing and it would very likely
have some subtle bugs.

	Arnd
