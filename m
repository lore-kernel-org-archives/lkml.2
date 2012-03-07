Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab2CGEkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 23:40:36 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38498 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab2CGEke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 23:40:34 -0500
MIME-Version: 1.0
In-Reply-To: <1331018040-30725-19-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
	<1331018040-30725-19-git-send-email-yinghai@kernel.org>
Date: Tue, 6 Mar 2012 21:40:32 -0700
Message-ID: <CABhMZUWvsZ2fSp2nGqiFuP8QoZ0A0uEUY9LfcAB-HemiLaqbwA@mail.gmail.com>
Subject: Re: [PATCH 18/23] PCI, ACPI: add acpi_pci_root_rescan()
From: Bjorn Helgaas <bjorn.helgaas@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        mjg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 12:13 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> it will rescan all acpi pci root if related pci root bus get removed before.
>
> Signed-off-by: Yinghai <yinghai@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: linux-acpi@vger.kernel.org
> ---
>  drivers/acpi/pci_root.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 52 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index b38e347..e1814e0 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -679,3 +679,55 @@ static int __init acpi_pci_root_init(void)
>  }
>
>  subsys_initcall(acpi_pci_root_init);
> +
> +static acpi_status
> +rescan_root_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
> +{
> +       struct acpi_device *device, *pdevice;
> +       struct acpi_pci_root *root;
> +       acpi_handle phandle;
> +       int ret_val;
> +
> +       if (!acpi_is_root_bridge(handle))
> +               return AE_OK;
> +
> +       acpi_get_parent(handle, &phandle);
> +       if (acpi_bus_get_device(phandle, &pdevice)) {
> +               printk(KERN_DEBUG "no parent device, assuming NULL\n");

This printk (and the others below) does not have enough context.  A
user or developer will have no clue what it relates to.  Ideally they
would at least be dev_printk().

> +               pdevice = NULL;

Is a host bridge without a parent possible?  Seems dubious to me.

> +       }
> +
> +       if (!acpi_bus_get_device(handle, &device)) {
> +               /* check if  pci root_bus is removed */
> +               root = acpi_driver_data(device);
> +               if (pci_find_bus(root->segment, root->secondary.start))
> +                       return AE_OK;
> +
> +               printk(KERN_DEBUG "bus exists... trim\n");
> +               /* this shouldn't be in here, so remove
> +                * the bus then re-add it...
> +                */
> +               ret_val = acpi_bus_trim(device, 1);
> +               printk(KERN_DEBUG "acpi_bus_trim return %x\n", ret_val);
> +       }
> +
> +       ret_val = acpi_bus_add(&device, pdevice, handle, ACPI_BUS_TYPE_DEVICE);
> +       if (ret_val) {
> +               printk(KERN_ERR "error adding bus, %x\n", -ret_val);
> +               goto out;
> +       }
> +
> +       root = acpi_driver_data(device);
> +       pci_assign_unassigned_bus_resources(root->bus);
> +
> +       ret_val = acpi_bus_start(device);
> +
> +out:
> +       return ret_val;
> +}
> +
> +void acpi_pci_root_rescan(void)
> +{
> +       acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
> +               ACPI_UINT32_MAX, rescan_root_bridge, NULL, NULL, NULL);
> +}

Walking the ACPI namespace is rarely the right thing to do.  Why do we
need it here?

Is this because we don't handle hotplug of ACPI devices in general?
The ACPI core *should* be noticing device removal and addition and
calling the driver .remove() and .add() methods directly.  I don't
think that's completely implemented, but I wish somebody would put
some effort into that rather than adding more hacky workarounds.

+cc Matthew Garrett, because I think he cares about this area too.
