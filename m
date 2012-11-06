Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab2KFADR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 19:03:17 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64257 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2KFADO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 19:03:14 -0500
MIME-Version: 1.0
In-Reply-To: <1348667971-30876-1-git-send-email-ying.huang@intel.com>
References: <1348667971-30876-1-git-send-email-ying.huang@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 5 Nov 2012 17:02:52 -0700
Message-ID: <CAErSpo5zZdxeUFtsKjfb+FcLvAWD-MBorSwTppge9HQ5GCL7_g@mail.gmail.com>
Subject: Re: [PATCH RESEND] ACPI/PCI: Make PCI devices notified when its power
 resource turned on
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 7:59 AM, Huang Ying <ying.huang@intel.com> wrote:
> Sorry for bothering.  It appears that this patch should go through ACPI
> tree because code changed are under drivers/acpi.
>
> A set of power resources may be shared by multiple devices.  When all
> devices share one set of power resources is put into D3_COLD state,
> the power resources will be turned off.  When one of the device is
> waked, the power resource will be turned on and all devices share it
> will be powered on to D0uninitialized state.  These devices should be
> resumed, so that they can get opportunity to go to low power state
> later.
>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Bjorn Helgaas <bhelgaas@google.com>

I had applied this to my for-linus branch, headed for v3.7, but had to
drop it because it introduced these warnings:

drivers/acpi/pci_bind.c: In function 'acpi_pci_unbind':
drivers/acpi/pci_bind.c:48:2: warning: passing argument 1 of
'acpi_power_resource_unregister_device' from incompatible pointer type
[enabled by default]
include/acpi/acpi_bus.h:346:6: note: expected 'struct device *' but
argument is of type 'struct pci_dev *'
drivers/acpi/pci_bind.c: In function 'acpi_pci_bind':
drivers/acpi/pci_bind.c:75:2: warning: passing argument 1 of
'acpi_power_resource_register_device' from incompatible pointer type
[enabled by default]
include/acpi/acpi_bus.h:345:5: note: expected 'struct device *' but
argument is of type 'struct pci_dev *'

Apparently this wasn't tested :-(


> ---
>  drivers/acpi/pci_bind.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- a/drivers/acpi/pci_bind.c
> +++ b/drivers/acpi/pci_bind.c
> @@ -45,6 +45,7 @@ static int acpi_pci_unbind(struct acpi_d
>
>         device_set_run_wake(&dev->dev, false);
>         pci_acpi_remove_pm_notifier(device);
> +       acpi_power_resource_unregister_device(dev, device->handle);
>
>         if (!dev->subordinate)
>                 goto out;
> @@ -71,6 +72,7 @@ static int acpi_pci_bind(struct acpi_dev
>                 return 0;
>
>         pci_acpi_add_pm_notifier(device, dev);
> +       acpi_power_resource_register_device(dev, device->handle);
>         if (device->wakeup.flags.run_wake)
>                 device_set_run_wake(&dev->dev, true);
>
