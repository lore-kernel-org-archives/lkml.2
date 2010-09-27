Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204Ab0I0Ulf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 16:41:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab0I0Uld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 16:41:33 -0400
Subject: Re: [PATCH 3/3] VFIO V4: VFIO driver: Non-privileged user level
 PCI drivers
From: Alex Williamson <alex.williamson@redhat.com>
To: Tom Lyon <pugs@cisco.com>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        randy.dunlap@oracle.com, arnd@arndb.de, joro@8bytes.org,
        hjk@linutronix.de, avi@redhat.com, gregkh@suse.de, chrisw@sous-sol.org,
        mst@redhat.com
In-Reply-To: <4c9a72a0.u2cnjUB7QZ91tLeo%pugs@cisco.com>
References: <4c9a72a0.u2cnjUB7QZ91tLeo%pugs@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 14:41:13 -0600
Message-ID: <1285620073.4951.44.camel@x201>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 14:18 -0700, Tom Lyon wrote:
> +/*
> + * Pretend we're hardware and tweak the values
> + * of the *virtual* pci BARs to reflect the hardware
> + * capabilities
> + */
> +static void vfio_bar_fixup(struct vfio_dev *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	int bar;
> +	u32 *lp;
> +	u64 mask;
> +
> +	for (bar = 0; bar <= 5; bar++) {
> +		if (pci_resource_start(pdev, bar))
> +			mask = ~(pci_resource_len(pdev, bar) - 1);
> +		else
> +			mask = 0;
> +		lp = (u32 *)vdev->vconfig + PCI_BASE_ADDRESS_0 + 4*bar;
> +		*lp &= (u32)mask;
> +
> +		if (pci_resource_flags(pdev, bar) & IORESOURCE_IO)
> +			*lp |= PCI_BASE_ADDRESS_SPACE_IO;
> +		else if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
> +			*lp |= PCI_BASE_ADDRESS_SPACE_MEMORY;
> +			if (pci_resource_flags(pdev, bar) & IORESOURCE_PREFETCH)
> +				*lp |= PCI_BASE_ADDRESS_MEM_PREFETCH;
> +			if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM_64) {
> +				*lp |= PCI_BASE_ADDRESS_MEM_TYPE_64;
> +				lp++;
> +				*lp &= (u32)(mask >> 32);
> +				bar++;
> +			}
> +		}
> +	}
> +
> +	if (pci_resource_start(pdev, PCI_ROM_RESOURCE))
> +		mask = ~(pci_resource_len(pdev, PCI_ROM_RESOURCE) - 1);
> +	else
> +		mask = 0;
> +	lp = (u32 *)vdev->vconfig + PCI_ROM_ADDRESS;
> +	*lp &= (u32)mask;
> +
> +	vdev->bardirty = 0;
> +}

Hey Tom,

A couple bugs have snuck into the above.  The (u32 *) cast needs to be
done after the vconfig index, and for some reason we're no longer
preserving the ROM enable bit.  I think we need something like this:


diff --git a/drivers/vfio/vfio_pci_config.c b/drivers/vfio/vfio_pci_config.c
index b7de0bf..b1ee352 100644
--- a/drivers/vfio/vfio_pci_config.c
+++ b/drivers/vfio/vfio_pci_config.c
@@ -402,7 +402,7 @@ static void vfio_bar_fixup(struct vfio_dev *vdev)
 			mask = ~(pci_resource_len(pdev, bar) - 1);
 		else
 			mask = 0;
-		lp = (u32 *)vdev->vconfig + PCI_BASE_ADDRESS_0 + 4*bar;
+		lp = (u32 *)(vdev->vconfig + PCI_BASE_ADDRESS_0 + 4*bar);
 		*lp &= (u32)mask;
 
 		if (pci_resource_flags(pdev, bar) & IORESOURCE_IO)
@@ -420,11 +420,12 @@ static void vfio_bar_fixup(struct vfio_dev *vdev)
 		}
 	}
 
-	if (pci_resource_start(pdev, PCI_ROM_RESOURCE))
+	if (pci_resource_start(pdev, PCI_ROM_RESOURCE)) {
 		mask = ~(pci_resource_len(pdev, PCI_ROM_RESOURCE) - 1);
-	else
+		mask |= PCI_ROM_ADDRESS_ENABLE;
+	} else
 		mask = 0;
-	lp = (u32 *)vdev->vconfig + PCI_ROM_ADDRESS;
+	lp = (u32 *)(vdev->vconfig + PCI_ROM_ADDRESS);
 	*lp &= (u32)mask;
 
 	vdev->bardirty = 0;


