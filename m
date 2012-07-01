Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab2GALcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 07:32:31 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55472 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab2GALca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 07:32:30 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.43.174]
In-Reply-To: <1340375470-13097-5-git-send-email-sjur.brandeland@stericsson.com>
References: <1340375470-13097-1-git-send-email-sjur.brandeland@stericsson.com> <1340375470-13097-5-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 1 Jul 2012 14:32:09 +0300
Message-ID: <CAK=WgbbG2nHH7+rm6CoR=VhiXVQT3-2VqJYLswmg9EshWu_=EA@mail.gmail.com>
Subject: Re: [RFC 4/4] remoteproc: Add driver for STE Modem
To: sjur.brandeland@stericsson.com
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Fri, Jun 22, 2012 at 5:31 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Introduce the platform driver for ste-modems.
> This driver uses the remoteproc framework for managing the
> modem and for creating virtio devices used for communicating
> with the modem.

Cool, thanks for posting this.

> diff --git a/drivers/remoteproc/Makefile b/drivers/remoteproc/Makefile
> index b91ecb0b..aec7470 100644
> --- a/drivers/remoteproc/Makefile
> +++ b/drivers/remoteproc/Makefile
> @@ -9,4 +9,5 @@ remoteproc-y                            += remoteproc_virtio.o
>  remoteproc-y                           += remoteproc_elf_loader.o
>  obj-$(CONFIG_OMAP_REMOTEPROC)          += omap_remoteproc.o
>  obj-$(CONFIG_STE_MODEM_RPROC)          += ste_modem_remoteproc.o
> +ste_modem_remoteproc-y                         += ste_modem_rproc.o
>  ste_modem_remoteproc-y                         += remoteproc_ste_modem_loader.o

Just wondering - do we need the loader ops to be a separate file ? is
it only going to be used by this module or do you foresee additional
users in the future ?

> +/* Maxium number of "channels" */
> +#define MAX_VQS 14

Can you explain a bit the background behind this number, and how vqs
and vqids are generally handled by the ste modem?

> +/* Setup the kick API for notification subscriptions */
> +static int ste_rproc_subscribe_to_kicks(struct rproc *rproc)
> +{
> +       int i, err;
> +       u32 txmask = 0, rxmask = 0;
> +       int (*kick_subscribe)(int notifyid,
> +                      void (*notify_cb)(int notifyid, void *data), void *data);
> +       int (*notifyid_alloc)(u32 setter_mask, u32 getter_mask);
> +
> +       /*
> +        * We need to declare for the HW what notification IDs
> +        * we're going to use.

Can you explain why is this needed ? what happens when we call
notifyid_alloc(rxmask, txmask) ?

> +        * notification IDs used for RX and TX by iterating over
> +        * the notification IDs.
> +        */
> +       idr_for_each(&rproc->notifyids, ste_rproc_set_vqid, &rxmask);

If this really is needed, we might want some help from the remoteproc
framework to do this, because it already has all the required info.

It'd be better if we don't fiddle with its internal structures,
because doing say may make it harder for it to evolve.

> +       notifyid_alloc = symbol_get(stemod_kick_notifyid_alloc);

This module is using dynamic symbol lookup quite a lot. This really
stands out because it's quite uncommon.

Why is it necessary ? Can we use static symbols instead ?

Can you share the code for those symbols as well ?

> +/* Get ste_rproc given platform device */
> +static struct sproc *ste_rproc_get_by_dev(const struct device *dev)
> +{
> +       struct platform_device *pdev;
> +       struct rproc *rproc;
> +       pdev = container_of(dev, struct platform_device, dev);
> +       rproc = platform_get_drvdata(pdev);
> +       if (rproc == NULL)
> +               return NULL;
> +       return rproc->priv;

Might be nicer to just

    return rproc ? rproc->priv : NULL;

> +/* Write sysfs entry 'powered' */
> +static ssize_t ste_rproc_powered_store(struct device *dev,
> +                                       struct device_attribute *attr,
> +                                       const char *buf, size_t count)
> +{
> +       unsigned long val;
> +       int ret = -EINVAL;
> +       struct sproc *sproc = ste_rproc_get_by_dev(dev);
> +
> +       if (sproc == NULL)
> +               return -EINVAL;
> +
> +       if (kstrtoul(buf, 10, &val) < 0)
> +               goto err;
> +
> +       if (sproc->powered && val == 0) {
> +               rproc_shutdown(sproc->rproc);
> +               sproc->powered = false;
> +       } else if (!sproc->powered && val == 1) {
> +
> +               if (rproc_boot(sproc->rproc))
> +                       goto err;
> +               sproc->powered = true;
> +       } else {
> +               dev_err(dev, "invalid sysfs state entered\n");
> +               goto err;
> +       }
> +       ret = count;
> +err:
> +       return ret;
> +}
> +
> +/* Declare sysfs entry powered */
> +static DEVICE_ATTR(powered, S_IRUGO | S_IWUSR | S_IWGRP ,
> +                       ste_rproc_powered_show, ste_rproc_powered_store);

There's three issues that bother me here:

1. It feels like this kind of functionality isn't limited to the STE
modem, so we better have it implemented in the remoteproc framework.

2. I'm not convinced that sysfs is an appropriate interface for
controlling the remote processor:

- if the remote processor crashes, the user isn't informed about it,
so it won't refresh its state even if a successful recovery took place
- if the user space crashes, we don't get informed about it, and the
remote processor can erroneously stay powered on indefinitely

It seems to me that a char device will solve these issues: we can use
ioctl to control the power, if the user crashes we'll know about it
via the release handler, and if the remote processor crashes we can
let the user know by sending it a notification for it to read via the
fd.

3. I'm not sure we want to let the user space directly control the
power of the remote processor: what if it decides to power off the
rproc while other kernel users utilize it?

We might want to change the semantics of the interface to just allow
the user to increase/decrease a power reference count instead of
directly booting/shutting it down.

> +struct device_attribute *remoteproc_attrs[] = { &dev_attr_powered };
> +
> +/* Platform device for STE modem is registered */
> +static int __devinit ste_rproc_probe(struct platform_device *pdev)
> +{
> +       struct sproc *ste_proc;
> +       struct rproc *rproc;
> +       int ret;
> +       void *reserved;
> +       dma_addr_t dma;
> +
> +       /*
> +        * Prerequisite: The platform device must declare the shared
> +        * memory region to be used by STE-modem and make memory
> +        * available for rproc by using  dma_declare_coherent_memory
> +        * (or CMA).
> +        */
> +       rproc = rproc_alloc(&pdev->dev,
> +                           pdev->name,
> +                           &ste_rproc_ops,
> +                           "ste-modem-fw",
> +                           sizeof(*ste_proc));
> +       if (!rproc)
> +               return -ENOMEM;
> +
> +       ste_proc = rproc->priv;
> +       ste_proc->rproc = rproc;
> +       platform_set_drvdata(pdev, rproc);
> +
> +       /* Inject the STE-modem specific firmware handler */
> +       rproc->fw_ops = &rproc_ste_modem_fw_ops;
> +
> +       /*
> +        * We're dynamically looking up the symbols for the API used
> +        * for generating kicks to and from the modem.
> +        */
> +       ste_proc->kick_modem = symbol_get(stemod_kick_notifyid);
> +       if (ste_proc->kick_modem == NULL) {
> +               ret =  -EINVAL;
> +               dev_err(rproc->dev, "cannot load stemod_kick API\n");
> +               goto free_rproc;
> +       }
> +
> +       /*
> +        * Registration of the ste_modem_rproc will cause firmware to
> +        * to be fetched and the virtio resource entries to be allocated
> +        * in memory. However STE-modem requires the firmware to be located
> +        * at the start of the shared memory region. So we need to
> +        * reserve space for firmware at the start of the shared memory
> +        * region.
> +        */
> +       reserved = dma_alloc_coherent(&pdev->dev, STEMOD_FW_SIZE,
> +                                     &dma, GFP_KERNEL);

This assumes a certain order of allocations which takes place inside
the remoteproc framework, and may break if things change (e.g.
https://lkml.org/lkml/2012/5/20/35)

Instead, we might want the remoteproc framework to help here. The best
suggestion I have is to "teach" remoteproc about different
purpose-specific memory regions, and ask it to allocate memory only
from the relevant region (if one exists). This will prevent different
order of allocations from using memory we must reserve for certain
purposes.

Ludovic is working on such patch, you might want to take its latest
version from him.

Thanks!
Ohad.
