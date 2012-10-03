Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474Ab2JCQPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:15:00 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56925 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab2JCQO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:14:58 -0400
From: Florian Fainelli <florian@openwrt.org>
To: Manuel Lauss <manuel.lauss@gmail.com>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Thomas Meyer <thomas@m3y3r.de>,
        "David S. Miller" <davem@davemloft.net>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/25] MIPS: Alchemy: use the OHCI platform driver
Date: Wed, 03 Oct 2012 18:13:52 +0200
Message-ID: <1552014.pCMX6Sqj22@flexo>
Organization: OpenWrt
User-Agent: KMail/4.8.5 (Linux/3.2.0-24-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAOLZvyEcFePtAhcX4r32VvemWqriuyVfkE8b-AAL=xWOww+=7g@mail.gmail.com>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org> <1349276601-8371-26-git-send-email-florian@openwrt.org> <CAOLZvyEcFePtAhcX4r32VvemWqriuyVfkE8b-AAL=xWOww+=7g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2012 18:07:28 Manuel Lauss wrote:
> On Wed, Oct 3, 2012 at 5:03 PM, Florian Fainelli <florian@openwrt.org> wrote:
> > This also greatly simplifies the power_{on,off} callbacks and make them
> > work on platform device id instead of checking the OHCI controller base
> > address like what was done in ohci-au1xxx.c.
> >
> > Signed-off-by: Florian Fainelli <florian@openwrt.org>
> > ---
> >  arch/mips/alchemy/common/platform.c |   31 
+++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> >
> > diff --git a/arch/mips/alchemy/common/platform.c 
b/arch/mips/alchemy/common/platform.c
> > index 57335a2..cd12458 100644
> > --- a/arch/mips/alchemy/common/platform.c
> > +++ b/arch/mips/alchemy/common/platform.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/serial_8250.h>
> >  #include <linux/slab.h>
> >  #include <linux/usb/ehci_pdriver.h>
> > +#include <linux/usb/ohci_pdriver.h>
> >
> >  #include <asm/mach-au1x00/au1000.h>
> >  #include <asm/mach-au1x00/au1xxx_dbdma.h>
> > @@ -142,6 +143,34 @@ static struct usb_ehci_pdata alchemy_ehci_pdata = {
> >         .power_suspend          = alchemy_ehci_power_off,
> >  };
> >
> > +/* Power on callback for the ohci platform driver */
> > +static int alchemy_ohci_power_on(struct platform_device *pdev)
> > +{
> > +       int unit;
> > +
> > +       unit = (pdev->id == 1) ?
> > +               ALCHEMY_USB_OHCI1 : ALCHEMY_USB_OHCI0;
> > +
> > +       return alchemy_usb_control(unit, 1);
> > +}
> > +
> > +/* Power off/suspend callback for the ohci platform driver */
> > +static void alchemy_ohci_power_off(struct platform_device *pdev)
> > +{
> > +       int unit;
> > +
> > +       unit = (pdev->id == 1) ?
> > +               ALCHEMY_USB_OHCI1 : ALCHEMY_USB_OHCI0;
> > +
> > +       alchemy_usb_control(unit, 0);
> > +}
> > +
> > +static struct usb_ohci_pdata alchemy_ohci_pdata = {
> > +       .power_on               = alchemy_ohci_power_on,
> > +       .power_off              = alchemy_ohci_power_off,
> > +       .power_suspend          = alchemy_ohci_power_off,
> > +};
> > +
> >  static unsigned long alchemy_ohci_data[][2] __initdata = {
> >         [ALCHEMY_CPU_AU1000] = { AU1000_USB_OHCI_PHYS_ADDR, 
AU1000_USB_HOST_INT },
> >         [ALCHEMY_CPU_AU1500] = { AU1000_USB_OHCI_PHYS_ADDR, 
AU1500_USB_HOST_INT },
> > @@ -192,6 +221,7 @@ static void __init alchemy_setup_usb(int ctype)
> >         pdev->name = "au1xxx-ohci";
> 
> Should be "ohci-platform" (2x).  With this change USB works on all my
> Alchemy boards.

Yes, Hauke Merthens just pointed this issue at me.

> I'd also suggest to move drivers/usb/host/alchemy-common.c to
> arch/mips/alchemy/common/usb.c.
> (same for octeon2-common.c)

Ok, sounds good.
--
Florian
