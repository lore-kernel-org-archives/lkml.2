Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab2KFSnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 13:43:50 -0500
Received: from mail.windriver.com ([147.11.1.11]:42532 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2KFSnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 13:43:49 -0500
Message-ID: <50995A37.1090703@windriver.com>
Date: Tue, 6 Nov 2012 13:43:03 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        <kernel@pengutronix.de>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v5 2/4] misc: Generic on-chip SRAM allocation driver
References: <1350570453-24546-1-git-send-email-p.zabel@pengutronix.de>  <1350570453-24546-3-git-send-email-p.zabel@pengutronix.de>  <CAP=VYLp50SkV=57why1ME2_hz3nFp6c-Cb_apYka5fF=PCDBQQ@mail.gmail.com> <1351513256.5872.103.camel@pizza.hi.pengutronix.de>
In-Reply-To: <1351513256.5872.103.camel@pizza.hi.pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-10-29 08:20 AM, Philipp Zabel wrote:
> Hi Paul,
> 
> thank you for your comments.
> 
> Am Freitag, den 26.10.2012, 12:07 -0400 schrieb Paul Gortmaker:
>> On Thu, Oct 18, 2012 at 10:27 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
>>> This driver requests and remaps a memory region as configured in the
>>> device tree. It serves memory from this region via the genalloc API.
>>>
>>> Other drivers can retrieve the genalloc pool from a phandle pointing
>>> to this drivers' device node in the device tree.
>>>
>>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
>>> Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
>>> ---
>>>  Documentation/devicetree/bindings/misc/sram.txt |   17 ++++
>>>  drivers/misc/Kconfig                            |    9 ++
>>>  drivers/misc/Makefile                           |    1 +
>>>  drivers/misc/sram.c                             |  111 +++++++++++++++++++++++
>>>  4 files changed, 138 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/misc/sram.txt
>>>  create mode 100644 drivers/misc/sram.c
>>>
>>> diff --git a/Documentation/devicetree/bindings/misc/sram.txt b/Documentation/devicetree/bindings/misc/sram.txt
>>> new file mode 100644
>>> index 0000000..b64136c
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/misc/sram.txt
>>> @@ -0,0 +1,17 @@
>>> +Generic on-chip SRAM
>>> +
>>> +Simple IO memory regions to be managed by the genalloc API.
>>> +
>>> +Required properties:
>>> +
>>> +- compatible : sram
>>> +
>>> +- reg : SRAM iomem address range
>>> +
>>> +Example:
>>> +
>>> +sram: sram@5c000000 {
>>> +       compatible = "sram";
>>> +       reg = <0x5c000000 0x40000>; /* 256 KiB SRAM at address 0x5c000000 */
>>> +};
>>> +
>>> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
>>> index b151b7c..c5bbd00 100644
>>> --- a/drivers/misc/Kconfig
>>> +++ b/drivers/misc/Kconfig
>>> @@ -499,6 +499,15 @@ config USB_SWITCH_FSA9480
>>>           stereo and mono audio, video, microphone and UART data to use
>>>           a common connector port.
>>>
>>> +config SRAM
>>> +       bool "Generic on-chip SRAM driver"
>>
>> If it is bool, then why bother with module.h and all the
>> MODULE_AUTHOR and similar stuff?
> 
> Yes. This driver was a module before I noticed that I then would have to
> keep track in genalloc to avoid module unloading while some SRAM is
> allocated. It seemed a bit too invasive.
> 
>>> +       depends on HAS_IOMEM
>>> +       select GENERIC_ALLOCATOR
>>> +       help
>>> +         This driver allows to declare a memory region to be managed
>>> +         by the genalloc API. It is supposed to be used for small
>>> +         on-chip SRAM areas found on many ARM SoCs.
>>
>> Probably no need to call out ARM specifically here.  I'm pretty sure
>> quite a few of the powerpc parts have SRAM too.
> 
> Sure, I'll just s/ARM // then.
> 
>>> +
>>>  source "drivers/misc/c2port/Kconfig"
>>>  source "drivers/misc/eeprom/Kconfig"
>>>  source "drivers/misc/cb710/Kconfig"
>>> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
>>> index 2129377..d845690 100644
>>> --- a/drivers/misc/Makefile
>>> +++ b/drivers/misc/Makefile
>>> @@ -49,3 +49,4 @@ obj-y                         += carma/
>>>  obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
>>>  obj-$(CONFIG_ALTERA_STAPL)     +=altera-stapl/
>>>  obj-$(CONFIG_INTEL_MEI)                += mei/
>>> +obj-$(CONFIG_SRAM)             += sram.o
>>> diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
>>> new file mode 100644
>>> index 0000000..7a363f2
>>> --- /dev/null
>>> +++ b/drivers/misc/sram.c
>>> @@ -0,0 +1,111 @@
>>> +/*
>>> + * Generic on-chip SRAM allocation driver
>>> + *
>>> + * Copyright (C) 2012 Philipp Zabel, Pengutronix
>>> + *
>>> + * This program is free software; you can redistribute it and/or
>>> + * modify it under the terms of the GNU General Public License
>>> + * as published by the Free Software Foundation; either version 2
>>> + * of the License, or (at your option) any later version.
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + *
>>> + * You should have received a copy of the GNU General Public License
>>> + * along with this program; if not, write to the Free Software
>>> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
>>> + * MA 02110-1301, USA.
>>> + */
>>> +
>>> +#include <linux/kernel.h>
>>> +#include <linux/module.h>
>>> +#include <linux/init.h>
>>> +#include <linux/io.h>
>>> +#include <linux/of.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/spinlock.h>
>>> +#include <linux/genalloc.h>
>>> +
>>> +struct sram_dev {
>>> +       struct gen_pool *pool;
>>> +};
>>
>> Assuming you don't ever intend adding more to the struct, then:
> 
> See the clock patch. I'm not sure if further functionality will be
> needed on any architecture.

Yes, the clock patch will make the above struct less lonely, once
it gets folded back into this patch.

> 
>> static struct gen_pool *sram_pool;
>>
>> instead?
> 
> No, a global variable would mean that only one instance of the SRAM
> driver can be used. What about chips that have separate SRAM regions?

True; moot point now that the clock patch gets folded in and
adds to the struct anyways...

> 
>> And you'll lose the needless indirections in the
>> remaining code below, and the kzalloc too (which you
>> currently leak, btw).
> 
> Memory allocated by devm_kzalloc should be freed by the devres
> framework. If I am missing something, could you please elaborate?

Right; my mind must have missed the devm_ prefix on the
kzalloc in my quick scan of it.

Paul.
--

> 
>> I'd also delete the "/* sentinel */"
>> comment too, since it is self evident. (The disease has
>> spread by copying from other drivers I see).
> 
> I can do that.
> 
>> P.
>> --
>>
>>> +
>>> +static int __devinit sram_probe(struct platform_device *pdev)
>>> +{
>>> +       void __iomem *virt_base;
>>> +       struct sram_dev *sram;
>>> +       struct resource *res;
>>> +       unsigned long size;
>>> +       int ret;
>>> +
>>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> +       if (!res)
>>> +               return -EINVAL;
>>> +
>>> +       size = resource_size(res);
>>> +
>>> +       virt_base = devm_request_and_ioremap(&pdev->dev, res);
>>> +       if (!virt_base)
>>> +               return -EADDRNOTAVAIL;
>>> +
>>> +       sram = devm_kzalloc(&pdev->dev, sizeof(*sram), GFP_KERNEL);
>>> +       if (!sram)
>>> +               return -ENOMEM;
>>> +
>>> +       sram->pool = gen_pool_create(PAGE_SHIFT, -1);
>>> +       if (!sram->pool)
>>> +               return -ENOMEM;
>>> +
>>> +       ret = gen_pool_add_virt(sram->pool, (unsigned long)virt_base,
>>> +                               res->start, size, -1);
>>> +       if (ret < 0) {
>>> +               gen_pool_destroy(sram->pool);
>>> +               return ret;
>>> +       }
>>> +
>>> +       platform_set_drvdata(pdev, sram);
>>> +
>>> +       dev_dbg(&pdev->dev, "SRAM pool: %ld KiB @ 0x%p\n", size / 1024, virt_base);
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +static int __devexit sram_remove(struct platform_device *pdev)
>>> +{
>>> +       struct sram_dev *sram = platform_get_drvdata(pdev);
>>> +
>>> +       if (gen_pool_avail(sram->pool) < gen_pool_size(sram->pool))
>>> +               dev_dbg(&pdev->dev, "removed while SRAM allocated\n");
>>> +
>>> +       gen_pool_destroy(sram->pool);
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +#ifdef CONFIG_OF
>>> +static struct of_device_id sram_dt_ids[] = {
>>> +       { .compatible = "sram" },
>>> +       { /* sentinel */ }
>>> +};
>>> +#endif
>>> +
>>> +static struct platform_driver sram_driver = {
>>> +       .driver = {
>>> +               .name = "sram",
>>> +               .of_match_table = of_match_ptr(sram_dt_ids),
>>> +       },
>>> +       .probe = sram_probe,
>>> +       .remove = __devexit_p(sram_remove),
>>> +};
>>> +
>>> +int __init sram_init(void)
>>> +{
>>> +       return platform_driver_register(&sram_driver);
>>> +}
>>> +
>>> +postcore_initcall(sram_init);
>>> +
>>> +MODULE_LICENSE("GPL");
>>> +MODULE_AUTHOR("Philipp Zabel, Pengutronix");
>>> +MODULE_DESCRIPTION("Generic SRAM allocator driver");
>>> --
>>> 1.7.10.4
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> regards
> Philipp
> 
