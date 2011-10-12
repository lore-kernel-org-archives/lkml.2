Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab1JLDjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 23:39:15 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57361 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab1JLDjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 23:39:14 -0400
Message-ID: <4E950BDA.2040408@ozlabs.ru>
Date: Wed, 12 Oct 2011 14:39:06 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: rusty@rustcorp.com.au
Subject: [PATCH] virtio-pci: Use PCI MMIO instead of PIO when available
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently virtio-pci is specced so that configuration of the device is
done through a PCI IO space (via BAR 0 of the virtual PCI device).
However, use of PCI IO space (aka PIO) is long deprecated, and can be
awkward to use on some systems (for example IBM pSeries machines
typically have many PCI domains, and not all firmware/hypervisor
versions necessarily support PCI PIO access on all domains).

Therefore, it would be preferable for the virtio virtual PCI device to
advertise a PCI memory space (aka MMIO) BAR and have configuration
done through this interface instead.  This can be done backwards
compatibly by advertising the MMIO BAR in addition to the existing PIO
BAR so that the guest driver can choose whichever interface.

In anticipation of adding such an MMIO BAR to virtio host-side
implementations (e.g. qemu), this patch updates the Linux virtio-pci
driver to attempt to use BAR 2 (which will be MMIO) in preference to
the existing PIO BAR 0.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Acked-by: David Gibson <david@gibson.dropbear.id.au>


diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 4fb5b2b..ddad409 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -643,9 +643,13 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
        if (err)
                goto out_enable_device;

-       vp_dev->ioaddr = pci_iomap(pci_dev, 0, 0);
-       if (vp_dev->ioaddr == NULL)
-               goto out_req_regions;
+       vp_dev->ioaddr = pci_iomap(pci_dev, 2, 0);
+       if (vp_dev->ioaddr == NULL) {
+               printk(KERN_INFO "virtio_pci: no memory BAR, falling back to IO\n");
+               vp_dev->ioaddr = pci_iomap(pci_dev, 0, 0);
+               if (vp_dev->ioaddr == NULL)
+                       goto out_req_regions;
+       }

        pci_set_drvdata(pci_dev, vp_dev);
        pci_set_master(pci_dev);


-- 
Alexey
