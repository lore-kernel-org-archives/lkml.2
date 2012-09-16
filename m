Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab2IPQtr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 12:49:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51551 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2IPQtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 12:49:45 -0400
MIME-Version: 1.0
In-Reply-To: <1347804577-23015-1-git-send-email-jiang.liu@huawei.com>
References: <CAE9FiQWBYmRj5--pg8eAwH_RKZsCWo+CVGN_KpeGXeE_3cSq9g@mail.gmail.com>
	<1347804577-23015-1-git-send-email-jiang.liu@huawei.com>
Date: Sun, 16 Sep 2012 09:49:43 -0700
X-Google-Sender-Auth: 4Q9aOou3zt8zd7wF8VEp1K62Sxk
Message-ID: <CAE9FiQUC9OyPQYDTC1xR45qd1an63H13LBKGaPueqihwq=yhSw@mail.gmail.com>
Subject: Re: [PATCH v3] ACPI/pci-bind: remove bind/unbind callbacks from acpi_device_ops
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2012 at 7:09 AM, Jiang Liu <liuj97@gmail.com> wrote:
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
> V2->V3:
>         Simplify implementation according to Yinghai's suggestion.
> ---
>  drivers/acpi/glue.c         |   15 ++++---
>  drivers/acpi/internal.h     |    3 +-
>  drivers/acpi/pci_bind.c     |  102 ++++++++++---------------------------------
>  drivers/acpi/pci_root.c     |    9 ----
>  drivers/acpi/scan.c         |   21 +--------
>  include/acpi/acpi_bus.h     |    4 --
>  include/acpi/acpi_drivers.h |    1 -
>  7 files changed, 36 insertions(+), 119 deletions(-)
>
> diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
> index 4904700..9779fb7 100644
> --- a/drivers/acpi/glue.c
> +++ b/drivers/acpi/glue.c
> @@ -160,10 +160,13 @@ static int acpi_bind_one(struct device *dev, acpi_handle handle)
>         }
>         dev->archdata.acpi_handle = handle;
>
> -       acpi_pci_bind_notify(dev->archdata.acpi_handle, dev, true);
> -
>         status = acpi_bus_get_device(handle, &acpi_dev);
> -       if (!ACPI_FAILURE(status)) {
> +       if (!ACPI_FAILURE(status))
> +               acpi_dev = NULL;
> +
> +       acpi_pci_bind_notify(dev->archdata.acpi_handle, acpi_dev, dev, true);

It seems you can do
    acpi_pci_bind_notify(acpi_dev, dev, true);
instead.

aka:
Do you have test case acpi_dev is not created before pci device?

Thanks

Yinghai
