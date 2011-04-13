Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970Ab1DMVDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:03:17 -0400
Received: from kroah.org ([198.145.64.141]:59884 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935Ab1DMVDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:03:15 -0400
Date: Wed, 13 Apr 2011 14:02:38 -0700
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org,
        Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH V4] axi: add AXI bus driver
Message-ID: <20110413210238.GB7523@kroah.com>
References: <1302634375-2378-1-git-send-email-zajec5@gmail.com>
 <20110413163113.GA24015@kroah.com>
 <BANLkTin-4HrJzNrLOxRy_-a98S3ZF4aSQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTin-4HrJzNrLOxRy_-a98S3ZF4aSQw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 09:39:54PM +0200, Rafał Miłecki wrote:
> 2011/4/13 Greg KH <greg@kroah.com>:
> >> diff --git a/drivers/axi/axi_pci_bridge.c b/drivers/axi/axi_pci_bridge.c
> >> new file mode 100644
> >> index 0000000..17e882c
> >> --- /dev/null
> >> +++ b/drivers/axi/axi_pci_bridge.c
> >> @@ -0,0 +1,33 @@
> >> +/*
> >> + * AXI PCI bridge module
> >> + *
> >> + * Licensed under the GNU/GPL. See COPYING for details.
> >> + */
> >> +
> >> +#include "axi_private.h"
> >> +
> >> +#include <linux/axi/axi.h>
> >> +#include <linux/pci.h>
> >> +
> >> +static DEFINE_PCI_DEVICE_TABLE(axi_pci_bridge_tbl) = {
> >> +     { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4331) },
> >> +     { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) },
> >> +     { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
> >> +     { 0, },
> >> +};
> >> +MODULE_DEVICE_TABLE(pci, axi_pci_bridge_tbl);
> >> +
> >> +static struct pci_driver axi_pci_bridge_driver = {
> >> +     .name = "axi-pci-bridge",
> >> +     .id_table = axi_pci_bridge_tbl,
> >> +};
> >> +
> >> +int __init axi_pci_bridge_init(void)
> >> +{
> >> +     return axi_host_pci_register(&axi_pci_bridge_driver);
> >> +}
> >> +
> >> +void __exit axi_pci_bridge_exit(void)
> >> +{
> >> +     axi_host_pci_unregister(&axi_pci_bridge_driver);
> >> +}
> >
> > You register a pci driver that does nothing?  That's not right, you need
> > to then base your axi bus off of that pci device, so it is hooked up
> > correctly in the /sys/devices/ tree.  Otherwise you are somewhere up in
> > the virtual location for your axi bus, right?
> 
> Please take a look at:
> driver->probe = axi_host_pci_probe;
> driver->remove = axi_host_pci_remove;
> return pci_register_driver(driver);

Odd, why not just set up those functions in that file?  Or move all of
this to that file and do it there?  This seems like a very small file :)

> >> +bool axi_core_is_enabled(struct axi_device *core)
> >> +{
> >> +     if ((axi_aread32(core, AXI_IOCTL) & (AXI_IOCTL_CLK | AXI_IOCTL_FGC))
> >> +         != AXI_IOCTL_CLK)
> >> +             return false;
> >> +     if (axi_aread32(core, AXI_RESET_CTL) & AXI_RESET_CTL_RESET)
> >> +             return false;
> >> +     return true;
> >> +}
> >> +EXPORT_SYMBOL(axi_core_is_enabled);
> >
> > EXPORT_SYMBOL_GPL()?
> >
> > What module uses this?  And why would it care?
> >
> >> +EXPORT_SYMBOL(axi_core_enable);
> >
> > EXPORT_SYMBOL_GPL()?
> >
> > Same goes for your other exports, just want you to be sure here.
> 
> Hm, I'm not sure. Using EXPORT_SYMBOL_GPL will forbid closed source
> drivers from using our bus driver, right? I'm don't have preferences
> on this, if you prefer us to force GPL, I can.

It's totally up to you, it's your code, not mine.  Just wanted to remind
you of the option.

> >> +u32 xaxi_chipco_gpio_control(struct axi_drv_cc *cc, u32 mask, u32 value)
> >> +{
> >> +     return axi_cc_write32_masked(cc, AXI_CC_GPIOCTL, mask, value);
> >> +}
> >> +EXPORT_SYMBOL(xaxi_chipco_gpio_control);
> >
> > "xaxi"?  Shouldn't that be consistant with the other exports and start
> > with "axi"?
> 
> Left from old tests/rewrites/splitting. Thanks.
> 
> 
> >> +static u8 axi_host_pci_read8(struct axi_device *core, u16 offset)
> >> +{
> >> +     if (unlikely(core->bus->mapped_core != core))
> >
> > Are you sure about the use of unlikely in this, and other functions?
> > The compiler almost always does a better job than we do for these types
> > of calls, just let it do it's job.
> >
> >> +             axi_host_pci_switch_core(core);
> >> +     return ioread8(core->bus->mmio + offset);
> >
> > I think because of that unlikely, you just slowed down all pci devices,
> > right?  That's not very nice :)
> 
> Hm, my logic suggests it is alright, but please consider this once
> more with me ;)
> 
> For the most of the time mapped_core (active core) do not change. We
> perform few hundreds of operations on one core in a row. This way
> mapped_core points to passed core for most of the time. Condition
> (mapped_core != core) is unlikely to happen.
> 
> Is there anything wrong in my logic?

Drivers almost _never_ need to use likely or unlikely in their code.
The CPU can schedule things better and so can the compiler, so I would
just drop them, _unless_ you can show a benchmark where it matters.

thanks,

greg k-h
