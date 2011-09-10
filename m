Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab1IJAS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 20:18:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308Ab1IJAS0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 20:18:26 -0400
MIME-Version: 1.0
In-Reply-To: <1315518078-30619-2-git-send-email-mason@myri.com>
References: <1315518078-30619-2-git-send-email-mason@myri.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 9 Sep 2011 17:18:01 -0700
Message-ID: <CA+55aFxhb1f6X4GO=+ZK1AUtmApPnLSP=JYGktQe1jsL7onX7A@mail.gmail.com>
Subject: Re: [PATCH 1/2] Fix pointer dereference before call to pcie_bus_configure_settings
To: Jon Mason <mason@myri.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Shyam Iyer <shyam.iyer.t@gmail.com>,
        Shyam Iyer <shyam_iyer@dell.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Mason,
 I just noticed that you had just an "Acked-by:" on this one. It
really should be a "Signed-off-by:" since it's passing through you.
Can I get that?

Also, the commit message is a bit unclear. "introduces a few issues"?
Can you guys elaborate on details? Oopses? Not being able to find
devices? What?

                       Linus

On Thu, Sep 8, 2011 at 2:41 PM, Jon Mason <mason@myri.com> wrote:
> From: Shyam Iyer <shyam.iyer.t@gmail.com>
>
> Commit b03e7495a862b028294f59fc87286d6d78ee7fa1 introduces a few issues by dereferencing bus->self in the call to pcie_bus_configure_settings.
>
> This fixes it by checking existence of bus->self before dereferencing it.
>
> Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Signed-off-by: Shyam Iyer <shyam_iyer@dell.com>
> Acked-by: Jon Mason <mason@myri.com>
> ---
>  arch/x86/pci/acpi.c              |    9 +++++++--
>  drivers/pci/hotplug/pcihp_slot.c |    4 +++-
>  drivers/pci/probe.c              |    3 ---
>  3 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> index c953302..039d913 100644
> --- a/arch/x86/pci/acpi.c
> +++ b/arch/x86/pci/acpi.c
> @@ -365,8 +365,13 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
>         */
>        if (bus) {
>                struct pci_bus *child;
> -               list_for_each_entry(child, &bus->children, node)
> -                       pcie_bus_configure_settings(child, child->self->pcie_mpss);
> +               list_for_each_entry(child, &bus->children, node) {
> +                       struct pci_dev *self = child->self;
> +                       if (!self)
> +                               continue;
> +
> +                       pcie_bus_configure_settings(child, self->pcie_mpss);
> +               }
>        }
>
>        if (!bus)
> diff --git a/drivers/pci/hotplug/pcihp_slot.c b/drivers/pci/hotplug/pcihp_slot.c
> index 753b21a..3ffd9c1 100644
> --- a/drivers/pci/hotplug/pcihp_slot.c
> +++ b/drivers/pci/hotplug/pcihp_slot.c
> @@ -169,7 +169,9 @@ void pci_configure_slot(struct pci_dev *dev)
>                        (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI)))
>                return;
>
> -       pcie_bus_configure_settings(dev->bus, dev->bus->self->pcie_mpss);
> +       if (dev->bus && dev->bus->self)
> +               pcie_bus_configure_settings(dev->bus,
> +                                           dev->bus->self->pcie_mpss);
>
>        memset(&hpp, 0, sizeof(hpp));
>        ret = pci_get_hp_params(dev, &hpp);
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 8473727..0820fc1 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1456,9 +1456,6 @@ void pcie_bus_configure_settings(struct pci_bus *bus, u8 mpss)
>  {
>        u8 smpss = mpss;
>
> -       if (!bus->self)
> -               return;
> -
>        if (!pci_is_pcie(bus->self))
>                return;
>
> --
> 1.7.6
>
>
