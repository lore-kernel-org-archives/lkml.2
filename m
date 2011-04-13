Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab1DMTj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:39:57 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45881 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab1DMTjz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:39:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ey8/ceWUWKVqu6pBRAjL3W3vSjJm1gFRem+5oObCOj9tJf+tFixhjXXOVjZtCz1y2j
         AJeDZaofluwrrJa1g2Y7lhyGPimFcA7YHTv7ve37cyw+vBd53OW/jtIKRY9C7oc8WfiX
         D1alciF3wJY/R+nYp3Pv/stzMiFqpihoTAkB4=
MIME-Version: 1.0
In-Reply-To: <20110413163113.GA24015@kroah.com>
References: <1302634375-2378-1-git-send-email-zajec5@gmail.com>
	<20110413163113.GA24015@kroah.com>
Date: Wed, 13 Apr 2011 21:39:54 +0200
Message-ID: <BANLkTin-4HrJzNrLOxRy_-a98S3ZF4aSQw@mail.gmail.com>
Subject: Re: [RFC][PATCH V4] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/13 Greg KH <greg@kroah.com>:
>> diff --git a/drivers/axi/axi_pci_bridge.c b/drivers/axi/axi_pci_bridge.c
>> new file mode 100644
>> index 0000000..17e882c
>> --- /dev/null
>> +++ b/drivers/axi/axi_pci_bridge.c
>> @@ -0,0 +1,33 @@
>> +/*
>> + * AXI PCI bridge module
>> + *
>> + * Licensed under the GNU/GPL. See COPYING for details.
>> + */
>> +
>> +#include "axi_private.h"
>> +
>> +#include <linux/axi/axi.h>
>> +#include <linux/pci.h>
>> +
>> +static DEFINE_PCI_DEVICE_TABLE(axi_pci_bridge_tbl) = {
>> +     { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4331) },
>> +     { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) },
>> +     { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
>> +     { 0, },
>> +};
>> +MODULE_DEVICE_TABLE(pci, axi_pci_bridge_tbl);
>> +
>> +static struct pci_driver axi_pci_bridge_driver = {
>> +     .name = "axi-pci-bridge",
>> +     .id_table = axi_pci_bridge_tbl,
>> +};
>> +
>> +int __init axi_pci_bridge_init(void)
>> +{
>> +     return axi_host_pci_register(&axi_pci_bridge_driver);
>> +}
>> +
>> +void __exit axi_pci_bridge_exit(void)
>> +{
>> +     axi_host_pci_unregister(&axi_pci_bridge_driver);
>> +}
>
> You register a pci driver that does nothing?  That's not right, you need
> to then base your axi bus off of that pci device, so it is hooked up
> correctly in the /sys/devices/ tree.  Otherwise you are somewhere up in
> the virtual location for your axi bus, right?

Please take a look at:
driver->probe = axi_host_pci_probe;
driver->remove = axi_host_pci_remove;
return pci_register_driver(driver);


>> +bool axi_core_is_enabled(struct axi_device *core)
>> +{
>> +     if ((axi_aread32(core, AXI_IOCTL) & (AXI_IOCTL_CLK | AXI_IOCTL_FGC))
>> +         != AXI_IOCTL_CLK)
>> +             return false;
>> +     if (axi_aread32(core, AXI_RESET_CTL) & AXI_RESET_CTL_RESET)
>> +             return false;
>> +     return true;
>> +}
>> +EXPORT_SYMBOL(axi_core_is_enabled);
>
> EXPORT_SYMBOL_GPL()?
>
> What module uses this?  And why would it care?
>
>> +EXPORT_SYMBOL(axi_core_enable);
>
> EXPORT_SYMBOL_GPL()?
>
> Same goes for your other exports, just want you to be sure here.

Hm, I'm not sure. Using EXPORT_SYMBOL_GPL will forbid closed source
drivers from using our bus driver, right? I'm don't have preferences
on this, if you prefer us to force GPL, I can.


>> +u32 xaxi_chipco_gpio_control(struct axi_drv_cc *cc, u32 mask, u32 value)
>> +{
>> +     return axi_cc_write32_masked(cc, AXI_CC_GPIOCTL, mask, value);
>> +}
>> +EXPORT_SYMBOL(xaxi_chipco_gpio_control);
>
> "xaxi"?  Shouldn't that be consistant with the other exports and start
> with "axi"?

Left from old tests/rewrites/splitting. Thanks.


>> +static u8 axi_host_pci_read8(struct axi_device *core, u16 offset)
>> +{
>> +     if (unlikely(core->bus->mapped_core != core))
>
> Are you sure about the use of unlikely in this, and other functions?
> The compiler almost always does a better job than we do for these types
> of calls, just let it do it's job.
>
>> +             axi_host_pci_switch_core(core);
>> +     return ioread8(core->bus->mmio + offset);
>
> I think because of that unlikely, you just slowed down all pci devices,
> right?  That's not very nice :)

Hm, my logic suggests it is alright, but please consider this once
more with me ;)

For the most of the time mapped_core (active core) do not change. We
perform few hundreds of operations on one core in a row. This way
mapped_core points to passed core for most of the time. Condition
(mapped_core != core) is unlikely to happen.

Is there anything wrong in my logic?

-- 
Rafał
