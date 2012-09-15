Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab2IOIDs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 04:03:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63629 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2IOIDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 04:03:42 -0400
MIME-Version: 1.0
In-Reply-To: <1347678312-11124-3-git-send-email-jiang.liu@huawei.com>
References: <1347678312-11124-1-git-send-email-jiang.liu@huawei.com>
	<1347678312-11124-3-git-send-email-jiang.liu@huawei.com>
Date: Sat, 15 Sep 2012 01:03:40 -0700
X-Google-Sender-Auth: y6r_WjxxRPQfgcdcGn000RROmwY
Message-ID: <CAE9FiQVyEskBfBxM90fD2BFVNGTYa75QCtkZp+5n8cLh3y395Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/9] PCI: split registration of PCI bus devices into
 two stages
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 8:05 PM, Jiang Liu <liuj97@gmail.com> wrote:
> When handling BUS_NOTIFY_ADD_DEVICE event for a PCI bridge device,
> the notification handler can't hold reference count to the new PCI bus
> because the device object for the new bus (pci_dev->subordinate->dev)
> hasn't been initialized yet.
>
> Split the registration of PCI bus device into two stages as below,
> so that the event handler could hold reference count to the new PCI bus
> when handling BUS_NOTIFY_ADD_DEVICE event.
>
> 1) device_initialize(&pci_dev->dev)
> 2) device_initialize(&pci_dev->subordinate->dev)
> 3) notify BUS_NOTIFY_ADD_DEVICE event for pci_dev
> 4) device_add(&pci_dev->dev)
> 5) device_add(&pci_dev->subordinate->dev)
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  drivers/pci/bus.c    |    2 +-
>  drivers/pci/probe.c  |    3 ++-
>  drivers/pci/remove.c |   10 +++++-----
>  3 files changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index 4b0970b..11a5c28 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -189,7 +189,7 @@ int pci_bus_add_child(struct pci_bus *bus)
>         if (bus->bridge)
>                 bus->dev.parent = bus->bridge;
>
> -       retval = device_register(&bus->dev);
> +       retval = device_add(&bus->dev);
>         if (retval)
>                 return retval;
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 5dbad03..ddc8f7f 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -464,6 +464,7 @@ static struct pci_bus * pci_alloc_bus(void)
>                 INIT_LIST_HEAD(&b->resources);
>                 b->max_bus_speed = PCI_SPEED_UNKNOWN;
>                 b->cur_bus_speed = PCI_SPEED_UNKNOWN;
> +               device_initialize(&b->dev);
>         }
>         return b;
>  }
> @@ -1672,7 +1673,7 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>         b->dev.class = &pcibus_class;
>         b->dev.parent = b->bridge;
>         dev_set_name(&b->dev, "%04x:%02x", pci_domain_nr(b), bus);
> -       error = device_register(&b->dev);
> +       error = device_add(&b->dev);
>         if (error)
>                 goto class_dev_reg_err;

failing path in pci_create_root_bus is not handled.

you could try to move

     device_initialize(&b->dev);

to
     pci_add_new_bus and pci_create_root_bus instead.


>
> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> index 37b9407..86a4636 100644
> --- a/drivers/pci/remove.c
> +++ b/drivers/pci/remove.c
> @@ -48,11 +48,11 @@ void pci_remove_bus(struct pci_bus *bus)
>         list_del(&bus->node);
>         pci_bus_release_busn_res(bus);
>         up_write(&pci_bus_sem);
> -       if (!bus->is_added)
> -               return;
> -
> -       pci_remove_legacy_files(bus);
> -       device_unregister(&bus->dev);
> +       if (bus->is_added) {
> +               pci_remove_legacy_files(bus);
> +               device_del(&bus->dev);
> +       }
> +       put_device(&bus->dev);
>  }
>  EXPORT_SYMBOL(pci_remove_bus);
>
> --
> 1.7.9.5
>
