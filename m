Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab1DMUiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:38:08 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37037 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab1DMUiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:38:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=K972SpGlPWOwRQx4nn+ERCAX1oD7/z3bRR7hRvne1KKj4dtf+Ovymcf/isQl39cmmP
         3epX3N3pNOUwiou5yVViy7Z+SImHnD6Oq3P08PY9qvC7cX5e6sfsMxoOud5G1yeEFXY3
         1ISNvSk/RQ4mJOP0XRYSmBmdcNiYoGkQ8OpII=
MIME-Version: 1.0
In-Reply-To: <BANLkTin-4HrJzNrLOxRy_-a98S3ZF4aSQw@mail.gmail.com>
References: <1302634375-2378-1-git-send-email-zajec5@gmail.com>
 <20110413163113.GA24015@kroah.com> <BANLkTin-4HrJzNrLOxRy_-a98S3ZF4aSQw@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 13 Apr 2011 22:37:44 +0200
Message-ID: <BANLkTimBZK8i3EgihB85HqTJ+wOz89uwTw@mail.gmail.com>
Subject: Re: [RFC][PATCH V4] axi: add AXI bus driver
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org,
        =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>,
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

On Wed, Apr 13, 2011 at 9:39 PM, Rafał Miłecki <zajec5@gmail.com> wrote:
> 2011/4/13 Greg KH <greg@kroah.com>:
>>> diff --git a/drivers/axi/axi_pci_bridge.c b/drivers/axi/axi_pci_bridge.c
>>> new file mode 100644
>>> index 0000000..17e882c
>>> --- /dev/null
>>> +++ b/drivers/axi/axi_pci_bridge.c
>>> @@ -0,0 +1,33 @@
>>> +/*
>>> + * AXI PCI bridge module
>>> + *
>>> + * Licensed under the GNU/GPL. See COPYING for details.
>>> + */
>>> +
>>> +#include "axi_private.h"
>>> +
>>> +#include <linux/axi/axi.h>
>>> +#include <linux/pci.h>
>>> +
>>> +static DEFINE_PCI_DEVICE_TABLE(axi_pci_bridge_tbl) = {
>>> +     { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4331) },
>>> +     { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) },
>>> +     { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
>>> +     { 0, },
>>> +};
>>> +MODULE_DEVICE_TABLE(pci, axi_pci_bridge_tbl);
>>> +
>>> +static struct pci_driver axi_pci_bridge_driver = {
>>> +     .name = "axi-pci-bridge",
>>> +     .id_table = axi_pci_bridge_tbl,
>>> +};
>>> +
>>> +int __init axi_pci_bridge_init(void)
>>> +{
>>> +     return axi_host_pci_register(&axi_pci_bridge_driver);
>>> +}
>>> +
>>> +void __exit axi_pci_bridge_exit(void)
>>> +{
>>> +     axi_host_pci_unregister(&axi_pci_bridge_driver);
>>> +}
>>
>> You register a pci driver that does nothing?  That's not right, you need
>> to then base your axi bus off of that pci device, so it is hooked up
>> correctly in the /sys/devices/ tree.  Otherwise you are somewhere up in
>> the virtual location for your axi bus, right?
>
> Please take a look at:
> driver->probe = axi_host_pci_probe;
> driver->remove = axi_host_pci_remove;
> return pci_register_driver(driver);
>
>
>>> +bool axi_core_is_enabled(struct axi_device *core)
>>> +{
>>> +     if ((axi_aread32(core, AXI_IOCTL) & (AXI_IOCTL_CLK | AXI_IOCTL_FGC))
>>> +         != AXI_IOCTL_CLK)
>>> +             return false;
>>> +     if (axi_aread32(core, AXI_RESET_CTL) & AXI_RESET_CTL_RESET)
>>> +             return false;
>>> +     return true;
>>> +}
>>> +EXPORT_SYMBOL(axi_core_is_enabled);
>>
>> EXPORT_SYMBOL_GPL()?
>>
>> What module uses this?  And why would it care?
>>
>>> +EXPORT_SYMBOL(axi_core_enable);
>>
>> EXPORT_SYMBOL_GPL()?
>>
>> Same goes for your other exports, just want you to be sure here.
>
> Hm, I'm not sure. Using EXPORT_SYMBOL_GPL will forbid closed source
> drivers from using our bus driver, right? I'm don't have preferences
> on this, if you prefer us to force GPL, I can.

Isn't EXPORT_SYMBOL_GPL for symbols that are considered to form a
tight coupling between the kernel and users of the symbol? Using _GPL
just because you are against proprietary drivers in general and want
to force GPL on HW vendors is wrong.

>
>
>>> +u32 xaxi_chipco_gpio_control(struct axi_drv_cc *cc, u32 mask, u32 value)
>>> +{
>>> +     return axi_cc_write32_masked(cc, AXI_CC_GPIOCTL, mask, value);
>>> +}
>>> +EXPORT_SYMBOL(xaxi_chipco_gpio_control);
>>
>> "xaxi"?  Shouldn't that be consistant with the other exports and start
>> with "axi"?
>
> Left from old tests/rewrites/splitting. Thanks.
>
>
>>> +static u8 axi_host_pci_read8(struct axi_device *core, u16 offset)
>>> +{
>>> +     if (unlikely(core->bus->mapped_core != core))
>>
>> Are you sure about the use of unlikely in this, and other functions?
>> The compiler almost always does a better job than we do for these types
>> of calls, just let it do it's job.
>>
>>> +             axi_host_pci_switch_core(core);
>>> +     return ioread8(core->bus->mmio + offset);
>>
>> I think because of that unlikely, you just slowed down all pci devices,
>> right?  That's not very nice :)
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
>
> --
> Rafał
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
