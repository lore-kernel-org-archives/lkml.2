Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2HFFbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 01:31:11 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33489 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2HFFbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 01:31:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120804181445.6598.6505.stgit@bling.home>
References: <20120804181445.6598.6505.stgit@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sun, 5 Aug 2012 23:30:46 -0600
Message-ID: <CAErSpo42VMnfzDP6t5eCFfE-5=yPNmNGLs6a2D0KwGMhe71DbQ@mail.gmail.com>
Subject: Re: [PATCH] pci: Account for virtual buses in pci_acs_path_enabled
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dsahern@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 4, 2012 at 12:19 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> It's possible to have buses without an associated bridge
> (bus->self == NULL).  SR-IOV can generate such buses.  When
> we find these, skip to the parent bus to look for the next
> ACS test.

To make sure I understand the problem here, I think you're referring
to the situation where an SR-IOV device can span several bus numbers,
e.g., the "VFs Spanning Multiple Bus Numbers" implementation note in
the SR-IOV 1.1 spec, sec. 2.1.2.

It says "All PFs must be located on the Device's captured Bus Number"
-- I think that means every PF will be directly on a bridge's
secondary bus and hence will have a valid dev->bus->self pointer.

However, VFs need not be on the same bus number.  If a VF is on
(captured Bus Number plus 1), I think we allocate a new struct pci_bus
for it, but there's no P2P bridge that leads to that bus, so the
bus->self pointer is probably NULL.

This makes me quite nervous, because I bet there are many places that
assume every non-root bus has a valid bus->self pointer  -- I know I
certainly had that assumption.

I looked at callers of pci_is_root_bus(), and at first glance, it seems like
iommu_init_device(), intel_iommu_add_device(), pci_acs_path_enabled(),
pci_get_interrupt_pin(), pci_common_swizzle(),
pci_find_upstream_pcie_bridge(), and
pci_bus_release_bridge_resources() all might have similar problems.

> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>
> David Ahern reported an oops from iommu drivers passing NULL into
> this function for the same mistake.  Harden this function against
> assuming bus->self is valid as well.  David, please include this
> patch as well as the iommu patches in your testing.
>
>  drivers/pci/pci.c |   22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index f3ea977..e11a49c 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2486,18 +2486,30 @@ bool pci_acs_enabled(struct pci_dev *pdev, u16 acs_flags)
>  bool pci_acs_path_enabled(struct pci_dev *start,
>                           struct pci_dev *end, u16 acs_flags)
>  {
> -       struct pci_dev *pdev, *parent = start;
> +       struct pci_dev *pdev = start;
> +       struct pci_bus *bus;
>
>         do {
> -               pdev = parent;
> -
>                 if (!pci_acs_enabled(pdev, acs_flags))
>                         return false;
>
> -               if (pci_is_root_bus(pdev->bus))
> +               bus = pdev->bus;
> +
> +               if (pci_is_root_bus(bus))
>                         return (end == NULL);
>
> -               parent = pdev->bus->self;
> +               /*
> +                * Skip buses without an associated bridge.  In this
> +                * case move to the parent and continue.
> +                */
> +               while (!bus->self) {
> +                       if (!pci_is_root_bus(bus))
> +                               bus = bus->parent;
> +                       else
> +                               return (end == NULL);
> +               }
> +
> +               pdev = bus->self;
>         } while (pdev != end);
>
>         return true;
>
