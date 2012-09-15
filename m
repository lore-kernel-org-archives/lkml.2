Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2IOX12 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 19:27:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52917 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2IOX1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 19:27:24 -0400
MIME-Version: 1.0
In-Reply-To: <1347678312-11124-6-git-send-email-jiang.liu@huawei.com>
References: <1347678312-11124-1-git-send-email-jiang.liu@huawei.com>
	<1347678312-11124-6-git-send-email-jiang.liu@huawei.com>
Date: Sat, 15 Sep 2012 16:27:22 -0700
X-Google-Sender-Auth: uiskAnJUbXmbUeGCAM1sirZeOgs
Message-ID: <CAE9FiQWk_2gPyVUiLgvRQ=qrFNby_R7Qh-QNruobQnhVFTn21w@mail.gmail.com>
Subject: Re: [PATCH v2 5/9] ACPI/pci-bind: remove bind/unbind callbacks from acpi_device_ops
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Jiang Liu <jiang.liu@huawei.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 8:05 PM, Jiang Liu <liuj97@gmail.com> wrote:
>  From: Jiang Liu <jiang.liu@huawei.com>
>
> Now ACPI devices are created before/destroyed after corresponding PCI
> devices, and acpi_platform_notify/acpi_platform_notify_remove will
> update PCI<->ACPI binding relationship when creating/destroying PCI
> devices, there's no need to invoke bind/unbind callbacks from ACPI
> device probe/destroy routines anymore. So remove bind/unbind callbacks
> from acpi_device_ops.
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/acpi/pci_bind.c     |  100 +++++++++----------------------------------
>  drivers/acpi/pci_root.c     |    9 ----
>  drivers/acpi/scan.c         |   21 +--------
>  include/acpi/acpi_bus.h     |    4 --
>  include/acpi/acpi_drivers.h |    1 -
>  5 files changed, 23 insertions(+), 112 deletions(-)
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index d1ecca2..f31cb2f 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -1232,17 +1232,8 @@ static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
>         dev->removal_type = ACPI_BUS_REMOVAL_EJECT;
>         device_release_driver(&dev->dev);
>
> -       if (!rmdevice)
> -               return 0;
> -
> -       /*
> -        * unbind _ADR-Based Devices when hot removal
> -        */
> -       if (dev->flags.bus_address) {
> -               if ((dev->parent) && (dev->parent->ops.unbind))
> -                       dev->parent->ops.unbind(dev);
> -       }
> -       acpi_device_unregister(dev, ACPI_BUS_REMOVAL_EJECT);
> +       if (rmdevice)
> +               acpi_device_unregister(dev, ACPI_BUS_REMOVAL_EJECT);
>
>         return 0;
>  }

for pci root bus, acpi_bus_trim() is used to remove acpi_device.

and later in acpi_pci_root_remove to stop pci drivers/ioapic driver,
iommu driver then remove pci devices.

if call back is removed there, then could some functions in
acpi_pci_unbind() will be skipped.

I really do not want to add pci_stop_bus_devices() in
pci_root_hp.c::handle_root_bridge_removal before
calling acpi_bus_trim...

Thanks

Yinghai
