Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab2ISJKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 05:10:15 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63118 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab2ISJKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 05:10:11 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.118.250]
In-Reply-To: <1347992952-4134-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1347992952-4134-1-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 19 Sep 2012 12:09:50 +0300
Message-ID: <CAK=Wgbat_oMZdE4DQvfOOeQz78hRjWvRzem1a5OCZDV-h7KPnA@mail.gmail.com>
Subject: Re: [RFCv2] remoteproc: Add STE modem driver for remoteproc
To: sjur.brandeland@stericsson.com
Cc: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Tue, Sep 18, 2012 at 9:29 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Add support for the STE modem shared memory driver.
> This driver hooks into the remoteproc framework
> in order to manage configuration and the virtio
> devices.
>
> This driver adds custom firmware handlers, because
> STE modem uses a custom firmware layout.

Very nice driver, thanks for all your work. I have some comments below.

> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> ---
...
>  drivers/remoteproc/Kconfig           |   12 +
>  drivers/remoteproc/Makefile          |    1 +
>  drivers/remoteproc/ste_modem_rproc.c |  408 ++++++++++++++++++++++++++++++++++
>  include/linux/modem_shm/ste_modem.h  |   71 ++++++

Why did you decide to create a separate folder for this header ? if
it's STE specific, maybe use an 'ste' prefix for it too ?

>  4 files changed, 492 insertions(+)
>  create mode 100644 drivers/remoteproc/ste_modem_rproc.c
>  create mode 100644 include/linux/modem_shm/ste_modem.h
>
> diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
> index e7d440c..14b70fd 100644
> --- a/drivers/remoteproc/Kconfig
> +++ b/drivers/remoteproc/Kconfig
> @@ -28,4 +28,16 @@ config OMAP_REMOTEPROC
>           It's safe to say n here if you're not interested in multimedia
>           offloading or just want a bare minimum kernel.
>
> +config STE_MODEM_RPROC
> +       tristate "STE-Modem remoteproc support"
> +       select REMOTEPROC
> +       select VIRTIO_CONSOLE

This is non-standard.

Usually we select libraries, which we don't want the user involved in
configuring, but here you select a complete driver.

If you must have it for the STE modem, then you should at least meet
its dependencies by selecting VIRTIO and VIRTIO_RING too.

> +++ b/drivers/remoteproc/ste_modem_rproc.c
> @@ -0,0 +1,408 @@
> +/*
> + * Copyright (C) ST-Ericsson AB 2012
> + * Author: Sjur Brændeland <sjur.brandeland@stericsson.com>
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +#include <linux/module.h>
> +#include <linux/remoteproc.h>
...
> +#include <linux/remoteproc.h>

redundant #include ?

> + * Loads the firmware to shared memory.
> + * The memory area to load fw into must be pre-allocated before
> + * this function is called (because remoteproc has already allocated
> + * device memory when this function is called)
> + */
> +static int sproc_load_segments(struct rproc *rproc, const struct firmware *fw)
> +{
> +       struct sproc *sproc = rproc->priv;
> +
> +       /* Convert to pages before checking if we have enough space for fw*/

Why do you have to convert to pages before checking ?

Btw - please put a 'space' before ending the comment.

> +       if (sproc->fw_addr == NULL ||
> +           PFN_DOWN(sproc->fw_size) < PFN_DOWN(fw->size)) {
> +               sproc_err(sproc, "Not sufficient space for firmware\n");
> +               return -EINVAL;
> +       }
> +
> +       memcpy(sproc->fw_addr, fw->data, fw->size);
> +       return 0;
> +}
> +
> +/* Find the entry for resource table in the Table of Content */
> +static struct ste_toc_entry *sproc_find_rsc_entry(const struct firmware *fw)
> +{
> +       int i;
> +       struct ste_toc *toc;
> +       int entries = ARRAY_SIZE(toc->table);

Using a local variable for this gives the impression that entries
might change, but really you just use it as a macro.

Maybe just #define something like TABLE_SIZE instead ?

> + * Find the resource table inside the remote processor's firmware.
> + * This function will allocate area used for firmware image in the memory
> + * region shared with the modem.
> + */
> +static struct resource_table *
> +sproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
> +                    int *tablesz)
> +{
...
> +       /*
> +        * STE-modem requires the firmware to be located
> +        * at the start of the shared memory region. So we need to
> +        * reserve space for firmware at the start.
> +        * This cannot be done in the function sproc_load_segments because
> +        * then dma_alloc_coherent is already called by Core and the
> +        * start of the share memory area would already have been occupied.
> +        */
> +       if (!sproc->fw_addr) {
> +               sproc->fw_addr = dma_alloc_coherent(rproc->dev.parent, fw->size,

This doesn't look good: this function should just find an offset
within the firmware and return it, and not do any memory allocations.

I understand the reason why you do that, but I think we had a nice
generic solution which shouldn't be too hard to implement (i.e. let
remoteproc maintain dedicated, purpose-specific, memory pools).
Moreover, if we implement it into the core, others could use it too.

Any chance you can look into it ? Ludovic started spinning some code
internally but was probably sucked away for other tasks meanwhile.

> +/* STE modem device is unregistered */
> +static int sproc_drv_remove(struct platform_device *pdev)
> +{
> +       struct ste_modem_device *mdev =
> +               container_of(pdev, struct ste_modem_device, pdev);
> +       struct sproc *sproc = mdev->drv_data;
> +
> +       sproc_dbg(sproc, "remove ste-modem\n");
> +
> +       /* Unregister as remoteproc device */
> +       rproc_del(sproc->rproc);

You also need to rproc_put() to unroll rproc_alloc().

> +/* Handle probe of a modem device */
> +static int sproc_probe(struct platform_device *pdev)
> +{
> +       struct ste_modem_device *mdev =
> +               container_of(pdev, struct ste_modem_device, pdev);
> +       dma_addr_t device_addr = 0;
> +       struct sproc *sproc;
> +       struct rproc *rproc;
> +       int err;
> +
> +       dev_dbg(&mdev->pdev.dev, "probe ste-modem\n");
> +       rproc = rproc_alloc(&mdev->pdev.dev,
> +                           mdev->pdev.name,
> +                           &sproc_ops,
> +                           SPROC_MODEM_FIRMWARE,

You're hardcoding the firmware name here, which is fine if all modem
devices always use the same file.

If not, but you're anyway expecting only a single modem device on any
given board, then please explicitly prevent this case (e.g. by
checking the pdev id and bailing out if it's different than zero).

> +                           sizeof(*sproc));
> +       if (!rproc)
> +               return -ENOMEM;
> +
> +       sproc = rproc->priv;
> +       sproc->mdev = mdev;
> +       sproc->rproc = rproc;
> +       mdev->drv_data = sproc;
> +       /*
> +        * Get the memory region shared with the modem
> +        * and declare it as dma memory.
> +        */
> +       sproc_dbg(sproc, "Shared memory region pa:0x%lx  sz:0x%zx\n",
> +                 (unsigned long) mdev->shm_pa,
> +                 (unsigned long) mdev->shm_size);
> +
> +       err = dma_declare_coherent_memory(&mdev->pdev.dev,
> +                                         (dma_addr_t) mdev->shm_pa,
> +                                         device_addr,
> +                                         mdev->shm_size,
> +                                        DMA_MEMORY_MAP |
> +                                        DMA_MEMORY_EXCLUSIVE |
> +                                        DMA_MEMORY_INCLUDES_CHILDREN);
> +       if (!err) {
> +               sproc_err(sproc,
> +                         "Cannot declare modem-shm memory region\n");
> +               err = -ENOMEM;
> +               goto free_rproc;
> +       }

This code should probably be part of the device creation - whoever
creates it, should probably attach the memory to it.

This way you don't couple the memory type with the driver itself, and
just let the driver work with whatever memory is attached to the
device.

Where do you create the device ? some platform code ? should probably
move this code up there.

> +/**
> + * register_ste_shm_modem() - Register a modem into the remoteproc framework.
> + * @mdev: Modem device to register with the remoteproc framework.
> + */
> +int register_ste_shm_modem(struct ste_modem_device *mdev)
> +{
> +       dev_dbg(&mdev->pdev.dev, "register ste-modem\n");
> +
> +       if (!mdev->ops.power || !mdev->ops.kick || !mdev->ops.kick_subscribe)
> +               return -EINVAL;
> +
> +       return platform_device_register(&mdev->pdev);
> +}
> +EXPORT_SYMBOL(register_ste_shm_modem);
> +
> +/**
> + * unregister_ste_shm_modem() - Unregister from the remoteproc framework.
> + * @mdev: Device to unregister from the remoteproc framework.
> + */
> +int unregister_ste_shm_modem(struct ste_modem_device *mdev)
> +{
> +       dev_dbg(&mdev->pdev.dev, "unregister ste-modem\n");
> +
> +       platform_device_unregister(&mdev->pdev);
> +       return 0;
> +}
> +EXPORT_SYMBOL(unregister_ste_shm_modem);

Who is going to call these functions ?

Usually drivers don't register their own devices - platform code does
(or device tree).

It's better to put these functions there (possibly while adding the
ops checks back to the driver's probe function, because that is indeed
the responsibility of the driver to check).

Moreover, these functions are really just wrappers around
platform_device_{un}register, so I I'd personally just drop them and
call the code directly. This way your code will be a bit more readable
for others.

> +static int __init sproc_init(void)
> +{
> +       return platform_driver_register(&sproc_driver.drv);
> +}
> +module_init(sproc_init);
> +
> +static void __exit sproc_exit(void)
> +{
> +       platform_driver_unregister(&sproc_driver.drv);
> +}
> +module_exit(sproc_exit);

Replace boilerplate code with module_platform_driver ?

> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("STE Modem driver using the Remote Processor Framework");
> diff --git a/include/linux/modem_shm/ste_modem.h b/include/linux/modem_shm/ste_modem.h
> new file mode 100644
> index 0000000..d4632d1
> --- /dev/null
> +++ b/include/linux/modem_shm/ste_modem.h
> @@ -0,0 +1,71 @@
> +/*
> + * Copyright (C) ST-Ericsson AB 2012
> + * Author: Sjur Brendeland / sjur.brandeland@stericsson.com
> + *
> + * License terms: GNU General Public License (GPL) version 2
> + */
> +
> +#ifndef __INC_MODEM_DEV_H
> +#define __INC_MODEM_DEV_H
> +#include <linux/types.h>
> +#include <linux/platform_device.h>
> +
> +struct ste_modem_device;
> +
> +/**
> + * struct ste_modem_dev_ops - Functions to control modem and modem interface.
> + *
> + * @power:     Main power switch, used for cold-start or complete power off.
> + * @kick:      Kick the modem.
> + * @kick_subscribe: Subscribe for notifications from the modem.
> + *
> + * This structure contains functions used by the ste remoteproc driver
> + * to manage the modem.
> + */
> +struct ste_modem_dev_ops {
> +       int (*power)(struct ste_modem_device *mdev, bool on);
> +       int (*kick)(struct ste_modem_device *mdev, int notify_id);
> +       int (*kick_subscribe)(struct ste_modem_device *mdev, int notify_id);
> +};
> +
> +/**
> + * struct ste_modem_drv_ops - Callbacks for modem initiated events.
> + * @kick: Called when the modem kicks the host.
> + *
> + * This structure contains callbacks for actions triggered by the modem.
> + */
> +struct ste_modem_drv_ops {
> +       void (*kick)(struct ste_modem_device *mdev, int notify_id);
> +};
> +
> +/**
> + * struct ste_modem_device - represent the STE modem device
> + * @pdev: Reference to platform device
> + * @ops: Operations used to manage the modem.
> + * @shm_pa: Physical address of the shared memory region.
> + * @shm_size: Size of the shared memory area.
> + * @drv_data: Driver private data.
> + *
> + */
> +struct ste_modem_device {
> +       struct platform_device pdev;
> +       struct ste_modem_dev_ops ops;
> +       unsigned long shm_pa;

phys_addr_t ?

> +       size_t shm_size;
> +       void *drv_data;
> +};
> +
> +/**
> + * struct ste_modem_driver - Modem driver structure.
> + * @drv: Reference to driver
> + * @ops: Notification and status callbacks functions from modem.
> +*/
> +struct ste_modem_driver {
> +       struct platform_driver drv;
> +       struct ste_modem_drv_ops ops;
> +};
> +
> +int register_ste_shm_modem(struct ste_modem_device *mdev);
> +int unregister_ste_shm_modem(struct ste_modem_device *mdev);
> +
> +#endif /*INC_MODEM_DEV_H*/
> --
> 1.7.9.5
>
