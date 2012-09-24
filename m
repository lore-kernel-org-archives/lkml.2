Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309Ab2IXWK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 18:10:28 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62083 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2IXWK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 18:10:26 -0400
MIME-Version: 1.0
In-Reply-To: <1345648605-7636-1-git-send-email-jiang.liu@huawei.com>
References: <CAErSpo7ZtHDQNBnreZXsqDqKbqc=O+BKHDM8H0w+QkFep9ydFg@mail.gmail.com>
 <1345648605-7636-1-git-send-email-jiang.liu@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 24 Sep 2012 16:10:04 -0600
Message-ID: <CAErSpo5gyZgxWxwTgXRMyZzDDbEBeXHtmhisPN2FqvvUarmTeg@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: allow acpiphp to handle PCIe ports w/o native
 PCIe hotplug capability
To: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 9:16 AM, Jiang Liu <liuj97@gmail.com> wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
>
> Commit 0d52f54e2ef64c189dedc332e680b2eb4a34590a (PCI / ACPI: Make acpiphp
> ignore root bridges using PCIe native hotplug) added code that made the
> acpiphp driver completely ignore PCIe root complexes for which the kernel
> had been granted control of the native PCIe hotplug feature by the BIOS
> through _OSC. Later commit 619a5182d1f38a3d629ee48e04fa182ef9170052
> "PCI hotplug: Always allow acpiphp to handle non-PCIe bridges" relaxed
> the constraints to allow acpiphp driver handle non-PCIe bridges under
> such a complex. The constraint needs to be relaxed further to allow
> acpiphp driver to hanlde PCIe ports without native PCIe hotplug capability.
>
> Some MR-IOV switch chipsets, such PLX8696, support multiple virtual PCIe
> switches and may migrate downstream ports among virtual switches.
> To migrate a downstream port from the source virtual switch to the target,
> the port needs to be hot-removed from the source and hot-added into the
> target. pciehp driver can't be used here because there's no slots within
> the virtual PCIe switch. So acpiphp driver is used to support downstream
> port migration. A typical configuration is as below:
> [Root w/o native PCIe HP]
>         [Upstream port of vswitch w/o native PCIe HP]
>                 [Downstream port of vswitch w/ native PCIe HP]
>                         [PCIe enpoint]
>
> Here acpiphp driver will be used to handle root ports and upstream port
> in the virtual switch, and pciehp driver will be used to handle downstream
> ports in the virtual switch.
>
> v1->v2: use PCIe capability accessors to read PCI_EXP_SLTCAP register
>
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: Jiang Liu <liuj97@gmail.com>

I tweaked the changelog (typos, indentation) and applied this to my
"pci/jiang-acpiphp" branch.  Kenji acked a previous version, but I
didn't add it here because this is slightly updated.

If the PLX8696 supports moving downstream ports between upstream
ports, it seems like a deficiency if the upstream port doesn't support
native hotplug.  If I understand correctly, this patch allows the use
of acpiphp for "hotplug" of the downstream ports, but that is only an
option if the PLX8696 is in the ACPI namespace.

It seems like the lack of PLX8696 native hotplug for upstream ports
mean this virtual switch migration can only be done if the PLX8696 is
soldered into the system -- for instance, we don't have any way to
deal with an 8696 on a plug-in card because ACPI won't know anything
about that device.

I'm not objecting to this patch; I'm just trying to understand the
situation better.

> ---
>  drivers/pci/hotplug/acpiphp_glue.c |   41 +++++++++++++++++++++++++++---------
>  1 file changed, 31 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index ad6fd66..e6da392 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -115,6 +115,35 @@ static const struct acpi_dock_ops acpiphp_dock_ops = {
>         .handler = handle_hotplug_event_func,
>  };
>
> +/* Check whether the PCI device is managed by native PCIe hotplug driver */
> +static bool device_is_managed_by_native_pciehp(struct pci_dev *pdev)
> +{
> +       u32 reg32;
> +       acpi_handle tmp;
> +       struct acpi_pci_root *root;
> +
> +       /* Check whether the PCIe port supports native PCIe hotplug */
> +       if (pcie_capability_read_dword(pdev, PCI_EXP_SLTCAP, &reg32))
> +               return false;
> +       if (!(reg32 & PCI_EXP_SLTCAP_HPC))
> +               return false;
> +
> +       /*
> +        * Check whether native PCIe hotplug has been enabled for
> +        * this PCIe hierarchy.
> +        */
> +       tmp = acpi_find_root_bridge_handle(pdev);
> +       if (!tmp)
> +               return false;
> +       root = acpi_pci_find_root(tmp);
> +       if (!root)
> +               return false;
> +       if (!(root->osc_control_set & OSC_PCI_EXPRESS_NATIVE_HP_CONTROL))
> +               return false;
> +
> +       return true;
> +}
> +
>  /* callback routine to register each ACPI PCI slot object */
>  static acpi_status
>  register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
> @@ -142,16 +171,8 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
>         function = adr & 0xffff;
>
>         pdev = pbus->self;
> -       if (pdev && pci_is_pcie(pdev)) {
> -               tmp = acpi_find_root_bridge_handle(pdev);
> -               if (tmp) {
> -                       struct acpi_pci_root *root = acpi_pci_find_root(tmp);
> -
> -                       if (root && (root->osc_control_set &
> -                                       OSC_PCI_EXPRESS_NATIVE_HP_CONTROL))
> -                               return AE_OK;
> -               }
> -       }
> +       if (pdev && device_is_managed_by_native_pciehp(pdev))
> +               return AE_OK;
>
>         newfunc = kzalloc(sizeof(struct acpiphp_func), GFP_KERNEL);
>         if (!newfunc)
> --
> 1.7.9.5
>
