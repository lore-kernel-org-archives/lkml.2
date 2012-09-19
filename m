Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab2ISKJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 06:09:30 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:32862 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756055Ab2ISKJ3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 06:09:29 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 19 Sep 2012 12:08:54 +0200
Subject: RE: [RFCv2] remoteproc: Add STE modem driver for remoteproc
Thread-Topic: [RFCv2] remoteproc: Add STE modem driver for remoteproc
Thread-Index: Ac2WRrg+LEqv8u9qSGS+/O/zRJPuXgAACwVg
Message-ID: <81C3A93C17462B4BBD7E272753C1057923BD6DED30@EXDCVYMBSTM005.EQ1STM.local>
References: <1347992952-4134-1-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=Wgbat_oMZdE4DQvfOOeQz78hRjWvRzem1a5OCZDV-h7KPnA@mail.gmail.com>
In-Reply-To: <CAK=Wgbat_oMZdE4DQvfOOeQz78hRjWvRzem1a5OCZDV-h7KPnA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,
> Very nice driver, thanks for all your work. I have some comments below.

Thank you :-). I'll try to make a new spin asap.

> >  include/linux/modem_shm/ste_modem.h  |   71 ++++++
> 
> Why did you decide to create a separate folder for this header ? if
> it's STE specific, maybe use an 'ste' prefix for it too ?

There has been some attempt to upstream a shm driver for another modem
vendor as well, see https://lkml.org/lkml/2012/8/27/15.

This driver used  .../driver/modem_shm, and
.../include/linux/modem_shm/. I feel that this driver belongs in the same
family. This other driver did not include any vendor prefix though.

What about .../include/linux/modem_shm/ste/modem.h or maybe just
.../include/linux/modem_shm/modem.h?

> > +config STE_MODEM_RPROC
> > +       tristate "STE-Modem remoteproc support"
> > +       select REMOTEPROC
> > +       select VIRTIO_CONSOLE
> 
> This is non-standard.
> 
> Usually we select libraries, which we don't want the user involved in
> configuring, but here you select a complete driver.
> 
> If you must have it for the STE modem, then you should at least meet
> its dependencies by selecting VIRTIO and VIRTIO_RING too.

OK, I just skip these select statements.

> > +#include <linux/remoteproc.h>
> 
> redundant #include ?

I'll fix.

> > +static int sproc_load_segments(struct rproc *rproc, const struct firmware
> *fw)
> > +{
> > +       struct sproc *sproc = rproc->priv;
> > +
> > +       /* Convert to pages before checking if we have enough space for fw*/
> 
> Why do you have to convert to pages before checking ?
> 
> Btw - please put a 'space' before ending the comment.

It's because dma_alloc_coherent gives me whole pages (?) and 
I don't want to do unnecessary reallocation. 
But the code is simpler if I remove this, so I might just do that.

...
> > +/* Find the entry for resource table in the Table of Content */
> > +static struct ste_toc_entry *sproc_find_rsc_entry(const struct firmware
> *fw)
> > +{
> > +       int i;
> > +       struct ste_toc *toc;
> > +       int entries = ARRAY_SIZE(toc->table);
> 
> Using a local variable for this gives the impression that entries
> might change, but really you just use it as a macro.
> 
> Maybe just #define something like TABLE_SIZE instead ?

OK, I'll fix.

> 
> > + * Find the resource table inside the remote processor's firmware.
> > + * This function will allocate area used for firmware image in the memory
> > + * region shared with the modem.
> > + */
> > +static struct resource_table *
> > +sproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
> > +                    int *tablesz)
> > +{
> ...
> > +       /*
> > +        * STE-modem requires the firmware to be located
> > +        * at the start of the shared memory region. So we need to
> > +        * reserve space for firmware at the start.
> > +        * This cannot be done in the function sproc_load_segments because
> > +        * then dma_alloc_coherent is already called by Core and the
> > +        * start of the share memory area would already have been occupied.
> > +        */
> > +       if (!sproc->fw_addr) {
> > +               sproc->fw_addr = dma_alloc_coherent(rproc->dev.parent, fw-
> >size,
> 
> This doesn't look good: this function should just find an offset
> within the firmware and return it, and not do any memory allocations.
> 
> I understand the reason why you do that, ...

I am afraid I *must* put the TOC at the start of memory. There is no way
around this. But I can pre-allocate space for firmware and just bail out if
it is not enough room. This is a much simpler approach.

> but I think we had a nice
> generic solution which shouldn't be too hard to implement (i.e. let
> remoteproc maintain dedicated, purpose-specific, memory pools).
> Moreover, if we implement it into the core, others could use it too.
> Any chance you can look into it ? Ludovic started spinning some code
> internally but was probably sucked away for other tasks meanwhile.

I propose we pre-allocate some memory for now, but look into at a more
generic solution when 3.7 merge window has closed.

> > +/* STE modem device is unregistered */
> > +static int sproc_drv_remove(struct platform_device *pdev)
> > +{
> > +       struct ste_modem_device *mdev =
> > +               container_of(pdev, struct ste_modem_device, pdev);
> > +       struct sproc *sproc = mdev->drv_data;
> > +
> > +       sproc_dbg(sproc, "remove ste-modem\n");
> > +
> > +       /* Unregister as remoteproc device */
> > +       rproc_del(sproc->rproc);
> 
> You also need to rproc_put() to unroll rproc_alloc().

OK, Thanks.

> 
> > +/* Handle probe of a modem device */
> > +static int sproc_probe(struct platform_device *pdev)
> > +{
> > +       struct ste_modem_device *mdev =
> > +               container_of(pdev, struct ste_modem_device, pdev);
> > +       dma_addr_t device_addr = 0;
> > +       struct sproc *sproc;
> > +       struct rproc *rproc;
> > +       int err;
> > +
> > +       dev_dbg(&mdev->pdev.dev, "probe ste-modem\n");
> > +       rproc = rproc_alloc(&mdev->pdev.dev,
> > +                           mdev->pdev.name,
> > +                           &sproc_ops,
> > +                           SPROC_MODEM_FIRMWARE,
> 
> You're hardcoding the firmware name here, which is fine if all modem
> devices always use the same file.

Yes, we will always use just one file.

> 
> If not, but you're anyway expecting only a single modem device on any
> given board, then please explicitly prevent this case (e.g. by
> checking the pdev id and bailing out if it's different than zero).
> 
...
> > +       err = dma_declare_coherent_memory(&mdev->pdev.dev,
> > +                                         (dma_addr_t) mdev->shm_pa,
> > +                                         device_addr,
> > +                                         mdev->shm_size,
> > +                                        DMA_MEMORY_MAP |
> > +                                        DMA_MEMORY_EXCLUSIVE |
> > +                                        DMA_MEMORY_INCLUDES_CHILDREN);
> 
> This code should probably be part of the device creation - whoever
> creates it, should probably attach the memory to it.
> 
> This way you don't couple the memory type with the driver itself, and
> just let the driver work with whatever memory is attached to the
> device.
> 
> Where do you create the device ? some platform code ? should probably
> move this code up there.

Yes, I wasn't sure about this, I did have it in the driver below at one point.
I'll just move this to the underlying device.

> > +/**
> > + * register_ste_shm_modem() - Register a modem into the remoteproc
> framework.
> > + * @mdev: Modem device to register with the remoteproc framework.
> > + */
> > +int register_ste_shm_modem(struct ste_modem_device *mdev)
> > +{
> > +       dev_dbg(&mdev->pdev.dev, "register ste-modem\n");
> > +
> > +       if (!mdev->ops.power || !mdev->ops.kick || !mdev-
> >ops.kick_subscribe)
> > +               return -EINVAL;
> > +
> > +       return platform_device_register(&mdev->pdev);
> > +}
> > +EXPORT_SYMBOL(register_ste_shm_modem);
> > +
> > +/**
> > + * unregister_ste_shm_modem() - Unregister from the remoteproc
> framework.
> > + * @mdev: Device to unregister from the remoteproc framework.
> > + */
> > +int unregister_ste_shm_modem(struct ste_modem_device *mdev)
> > +{
> > +       dev_dbg(&mdev->pdev.dev, "unregister ste-modem\n");
> > +
> > +       platform_device_unregister(&mdev->pdev);
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL(unregister_ste_shm_modem);
> 
> Who is going to call these functions ?
> 
> Usually drivers don't register their own devices - platform code does
> (or device tree).
> 
> It's better to put these functions there (possibly while adding the
> ops checks back to the driver's probe function, because that is indeed
> the responsibility of the driver to check).
> 
> Moreover, these functions are really just wrappers around
> platform_device_{un}register, so I I'd personally just drop them and
> call the code directly. This way your code will be a bit more readable
> for others.


OK,  will remove these register/unregister functions.

The reason I did include them was to be able to move away from the
platform bus, i.e. by just simply hooking the device up under remoteproc
without a driver. But currently this does not work because rproc_boot()
requires the device to have a driver due to the call
 try_module_get(dev->parent->driver->owner).

> > +static int __init sproc_init(void)
> > +{
> > +       return platform_driver_register(&sproc_driver.drv);
> > +}
> > +module_init(sproc_init);
> > +
> > +static void __exit sproc_exit(void)
> > +{
> > +       platform_driver_unregister(&sproc_driver.drv);
> > +}
> > +module_exit(sproc_exit);
> 
> Replace boilerplate code with module_platform_driver ?

I tried, but the macros cannot handle the sproc_driver.drv as argument.

> > +++ b/include/linux/modem_shm/ste_modem.h
> > @@ -0,0 +1,71 @@
> > +/*
> > + * Copyright (C) ST-Ericsson AB 2012
> > + * Author: Sjur Brendeland / sjur.brandeland@stericsson.com
> > + *
> > + * License terms: GNU General Public License (GPL) version 2
> > + */
> > +
...
> > +/**
> > + * struct ste_modem_device - represent the STE modem device
> > + * @pdev: Reference to platform device
> > + * @ops: Operations used to manage the modem.
> > + * @shm_pa: Physical address of the shared memory region.
> > + * @shm_size: Size of the shared memory area.
> > + * @drv_data: Driver private data.
> > + *
> > + */
> > +struct ste_modem_device {
> > +       struct platform_device pdev;
> > +       struct ste_modem_dev_ops ops;
> > +       unsigned long shm_pa;
> 
> phys_addr_t ?

Yes.

Thanks,
Sjur
