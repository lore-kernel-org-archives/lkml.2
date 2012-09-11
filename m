Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab2IKWEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:04:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53998 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab2IKWEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:04:12 -0400
MIME-Version: 1.0
In-Reply-To: <1344355862-2726-4-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com> <1344355862-2726-4-git-send-email-jiang.liu@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 11 Sep 2012 16:03:50 -0600
Message-ID: <CAErSpo7C_-Yp6pNu0J9L3gMds9fuO2ZLRFvo28gVEGL0iM1JuQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 03/22] PCI: change PCI device management code to
 better follow device model
To: Jiang Liu <liuj97@gmail.com>
Cc: Don Dutile <ddutile@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 10:10 AM, Jiang Liu <liuj97@gmail.com> wrote:
> According to device model documentation, the way to add/remove device
> object should be symmetric.
>
> /**
>  * device_del - delete device from system.
>  * @dev: device.
>  *
>  * This is the first part of the device unregistration
>  * sequence. This removes the device from the lists we control
>  * from here, has it removed from the other driver model
>  * subsystems it was added to in device_add(), and removes it
>  * from the kobject hierarchy.
>  *
>  * NOTE: this should be called manually _iff_ device_add() was
>  * also called manually.
>  */
>
> The rule here is to either use
> 1) device_register()/device_unregister()
> or
> 2) device_initialize()/device_add()/device_del()/put_device().
>
> So change PCI core to follow the rule and get rid of the redundant
> pci_dev_get()/pci_dev_put() pair.

Seems OK to me.

> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> ---
>  drivers/pci/probe.c  |    1 -
>  drivers/pci/remove.c |    4 ++--
>  2 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 0840409..dacca26 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1294,7 +1294,6 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
>  {
>         device_initialize(&dev->dev);
>         dev->dev.release = pci_release_dev;
> -       pci_dev_get(dev);
>
>         dev->dev.dma_mask = &dev->dma_mask;
>         dev->dev.dma_parms = &dev->dma_parms;
> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> index 33b6318..b9ac765 100644
> --- a/drivers/pci/remove.c
> +++ b/drivers/pci/remove.c
> @@ -22,7 +22,7 @@ static void pci_stop_dev(struct pci_dev *dev)
>         if (dev->is_added) {
>                 pci_proc_detach_device(dev);
>                 pci_remove_sysfs_dev_files(dev);
> -               device_unregister(&dev->dev);
> +               device_del(&dev->dev);
>                 dev->is_added = 0;
>         }
>
> @@ -40,7 +40,7 @@ static void pci_destroy_dev(struct pci_dev *dev)
>         up_write(&pci_bus_sem);
>
>         pci_free_resources(dev);
> -       pci_dev_put(dev);
> +       put_device(&dev->dev);
>  }
>
>  /**
> --
> 1.7.9.5
>
