Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab0G3RRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:17:44 -0400
Received: from kroah.org ([198.145.64.141]:46143 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab0G3RRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:17:37 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:14:59 2010
Message-Id: <20100730171459.775901915@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:13:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [001/165] virtio-pci: disable msi at startup
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

commit b03214d559471359e2a85ae256686381d0672f29 upstream.

virtio-pci resets the device at startup by writing to the status
register, but this does not clear the pci config space,
specifically msi enable status which affects register
layout.

This breaks things like kdump when they try to use e.g. virtio-blk.

Fix by forcing msi off at startup. Since pci.c already has
a routine to do this, we export and use it instead of duplicating code.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci.c           |    1 +
 drivers/virtio/virtio_pci.c |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2046,6 +2046,7 @@ void pci_msi_off(struct pci_dev *dev)
 		pci_write_config_word(dev, pos + PCI_MSIX_FLAGS, control);
 	}
 }
+EXPORT_SYMBOL_GPL(pci_msi_off);
 
 #ifndef HAVE_ARCH_PCI_SET_DMA_MASK
 /*
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -635,6 +635,9 @@ static int __devinit virtio_pci_probe(st
 	INIT_LIST_HEAD(&vp_dev->virtqueues);
 	spin_lock_init(&vp_dev->lock);
 
+	/* Disable MSI/MSIX to bring device to a known good state. */
+	pci_msi_off(pci_dev);
+
 	/* enable the device */
 	err = pci_enable_device(pci_dev);
 	if (err)


