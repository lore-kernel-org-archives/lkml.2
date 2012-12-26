Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab2LZWk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 17:40:28 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:52610 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2LZWk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 17:40:26 -0500
MIME-Version: 1.0
In-Reply-To: <50D6039D.4000001@linux.vnet.ibm.com>
References: <50CA5EE2.30206@linux.vnet.ibm.com> <CAErSpo6BfWGYH+=ygS6qWT-YFKPuywooVgLWm+g_eB2dMw3iKQ@mail.gmail.com>
 <50D60349.7080400@linux.vnet.ibm.com> <50D6039D.4000001@linux.vnet.ibm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 26 Dec 2012 15:40:04 -0700
Message-ID: <CAErSpo5s8ZEk2Lkdj4J2T4pFvSxqxsou0d5efX+7+ecL_wYYMg@mail.gmail.com>
Subject: Re: [PATCH] drm: fixed access to PCI host bridges
To: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        brking@linux.vnet.ibm.com, benh@au1.ibm.com,
        Betty Dall <betty.dall@hp.com>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 12:01 PM, Lucas Kannebley Tavares
<lucaskt@linux.vnet.ibm.com> wrote:
> During the process of obtaining the speed cap for the device, it
> attempts go get the PCI Host bus. However on architectures such as PPC
> or IA64, those do not appear as devices.
>
> Signed-off-by: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
> ---
>  drivers/gpu/drm/drm_pci.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
> index 754bc96..ea41234 100644
> --- a/drivers/gpu/drm/drm_pci.c
> +++ b/drivers/gpu/drm/drm_pci.c
> @@ -479,8 +479,13 @@ int drm_pcie_get_speed_cap_mask(struct drm_device *dev,
> u32 *mask)
>         if (!pci_is_pcie(dev->pdev))
>                 return -EINVAL;
>
> +       // find PCI device for capabilities
>         root = dev->pdev->bus->self;
>
> +       // some architectures might not have host bridges as PCI devices
> +       if (root == NULL)
> +               root = dev->pdev;

You didn't address my question about this.  Obviously this will avoid
a null pointer dereference.  But you have to also explain why this
change is correct.

If it's good enough to just look at the capabilities of the DRM device
(not the upstream bridge) on PPC and ia64, why not do that everywhere
and forget about the bridge completely?

>         pos = pci_pcie_cap(root);
>         if (!pos)
>                 return -EINVAL;
>
> --
> Lucas Kannebley Tavares
> Software Engineer
> IBM Linux Technology Center
>
