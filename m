Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab2LMXcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 18:32:06 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:60021 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab2LMXcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 18:32:03 -0500
MIME-Version: 1.0
In-Reply-To: <50CA5EE2.30206@linux.vnet.ibm.com>
References: <50CA5EE2.30206@linux.vnet.ibm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 13 Dec 2012 16:31:40 -0700
Message-ID: <CAErSpo6BfWGYH+=ygS6qWT-YFKPuywooVgLWm+g_eB2dMw3iKQ@mail.gmail.com>
Subject: Re: drm: Added ppc64 root device getter
To: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        brking@linux.vnet.ibm.com, benh@au1.ibm.com,
        Betty Dall <betty.dall@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Betty]

On Thu, Dec 13, 2012 at 4:04 PM, Lucas Kannebley Tavares
<lucaskt@linux.vnet.ibm.com> wrote:
> On architectures such as ppc64, there is no root bus device (it belongs
> to the hypervisor). DRM attempted to get one, causing a null-pointer
> dereference.

In addition to ppc64, at least ia64 and parisc have the same situation
of the PCI host bridge not appearing as a  PCI device itself.

> Signed-off-by: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
>
> --
> diff --git a/arch/powerpc/platforms/pseries/Makefile
> b/arch/powerpc/platforms/pseries/Makefile
> index 890622b..ddfdda8 100644
> --- a/arch/powerpc/platforms/pseries/Makefile
> +++ b/arch/powerpc/platforms/pseries/Makefile
> @@ -1,6 +1,8 @@
>  ccflags-$(CONFIG_PPC64)                        := -mno-minimal-toc
>  ccflags-$(CONFIG_PPC_PSERIES_DEBUG)    += -DDEBUG
>
> +drm-y                  += drm_pci.o
> +
>  obj-y                  := lpar.o hvCall.o nvram.o reconfig.o \
>                            setup.o iommu.o event_sources.o ras.o \
>                            firmware.o power.o dlpar.o mobility.o
> diff --git a/arch/powerpc/platforms/pseries/drm_pci.c
> b/arch/powerpc/platforms/pseries/drm_pci.c
> new file mode 100644
> index 0000000..da6675e
> --- /dev/null
> +++ b/arch/powerpc/platforms/pseries/drm_pci.c
> @@ -0,0 +1,24 @@
> +/*
> + * Copyright (C) 2012 Lucas Kannebley Tavares, IBM Corporation
> + *
> + * pSeries specific routines for DRM.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
> + */
> +
> +inline struct pci_device *drm_get_parent_device(struct drm_device *dev) {
> +       return (dev->pdev->bus->self == NULL) ? dev->pdev :
> dev->pdev->bus->self;

So for DRM devices on a root bus, the parent is the DRM device itself,
while for DRM devices deeper in the hierarchy, the parent is the
upstream P2P bridge?  That doesn't really make sense to me.  If the
caller operates on the DRM device in some cases and on the bridge in
other cases, it's going to need to know the difference, so hiding the
difference in this wrapper seems counterproductive.

> +}
> +
> diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
> index eb37466..5a8a4f5 100644
> --- a/drivers/gpu/drm/drm_pci.c
> +++ b/drivers/gpu/drm/drm_pci.c
> @@ -466,6 +466,10 @@ void drm_pci_exit(struct drm_driver *driver, struct
> pci_driver *pdriver)
>  }
>  EXPORT_SYMBOL(drm_pci_exit);
>
> +inline __weak struct pci_device *drm_get_parent_device(struct drm_device
> *dev) {
> +       return dev->pdev->bus->self;
> +}
> +
>  int drm_pcie_get_speed_cap_mask(struct drm_device *dev, u32 *mask)
>  {
>         struct pci_dev *root;
> @@ -479,7 +483,7 @@ int drm_pcie_get_speed_cap_mask(struct drm_device *dev,
> u32 *mask)
>                 return -EINVAL;
>
>         // find PCI device for capabilities
> -       root = dev->pdev->bus->self;
> +       root = drm_get_parent_device(dev);
>
>         // some architectures might not have host bridges as PCI devices
>         if (root == NULL)

What tree does this apply to?  Upstream doesn't have the "if (root ==
NULL)" check yet.  That check looks like the sort of thing you'd need
to avoid the null pointer dereference.  So maybe adding that check and
the associated code is enough to fix the problem, even without adding
drm_get_parent_device().

With the code in the tree, it looks like you'd dereference a null
pointer in pci_pcie_cap(root), so I assume that's what you tripped
over.

I'm not really sure that code outside the PCI core should be looking
at capabilities of upstream devices like this.  It seems like the sort
of thing where the core might need to provide better interfaces.

Bjorn
