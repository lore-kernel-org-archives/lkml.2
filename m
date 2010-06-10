Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409Ab0FJP3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:29:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab0FJP3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:29:14 -0400
Date: Thu, 10 Jun 2010 18:22:52 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH for-2.6.35] virtio-pci: disable msi at startup
Message-ID: <20100610152252.GA3510@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio-pci resets the device at startup by writing to the status
register, but this does not clear the pci config space,
specifically msi enable status which affects register
layout.

This breaks things like kdump when they try to use e.g. virtio-blk.

Fix by forcing msi off at startup. Since pci.c already has
a routine to do this, we export and use it instead of duplicating code.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org
---

Jesse, could you ack adding the pci export please?
Rusty, please consider this patch for 2.6.35.

 drivers/pci/pci.c           |    1 +
 drivers/virtio/virtio_pci.c |    3 +++
 include/linux/pci.h         |    4 ++++
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 60f30e7..740fb4e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2292,6 +2292,7 @@ void pci_msi_off(struct pci_dev *dev)
 		pci_write_config_word(dev, pos + PCI_MSIX_FLAGS, control);
 	}
 }
+EXPORT_SYMBOL_GPL(pci_msi_off);
 
 #ifndef HAVE_ARCH_PCI_SET_DMA_MAX_SEGMENT_SIZE
 int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size)
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 95896f3..ef8d9d5 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -636,6 +636,9 @@ static int __devinit virtio_pci_probe(struct pci_dev *pci_dev,
 	INIT_LIST_HEAD(&vp_dev->virtqueues);
 	spin_lock_init(&vp_dev->lock);
 
+	/* Disable MSI/MSIX to bring device to a known good state. */
+	pci_msi_off(pci_dev);
+
 	/* enable the device */
 	err = pci_enable_device(pci_dev);
 	if (err)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7cb0084..31d8a12 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -780,7 +780,11 @@ int __must_check pci_set_mwi(struct pci_dev *dev);
 int pci_try_set_mwi(struct pci_dev *dev);
 void pci_clear_mwi(struct pci_dev *dev);
 void pci_intx(struct pci_dev *dev, int enable);
+#ifdef CONFIG_PCI_MSI
 void pci_msi_off(struct pci_dev *dev);
+#else
+static inline void pci_msi_off(struct pci_dev *dev) {}
+#endif
 int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
 int pci_set_dma_seg_boundary(struct pci_dev *dev, unsigned long mask);
 int pcix_get_max_mmrbc(struct pci_dev *dev);
-- 
1.7.1.12.g42b7f
