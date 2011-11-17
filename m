Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab1KQPjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:39:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198Ab1KQPjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:39:48 -0500
Date: Thu, 17 Nov 2011 17:41:15 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] virtio-pci: make reset operation safer
Message-ID: <20111117154114.GA31281@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio pci device reset actually just does an I/O
write, which in PCI is really posted, that is it
can complete on CPU before the device has received it.

Further, interrupts might have been pending on
another CPU, so device callback might get invoked after reset.

This conflicts with how drivers use reset, which is typically:
	reset
	unregister
a callback running after reset completed can race with
unregister, potentially leading to use after free bugs.

Fix by flushing out the write, and flushing pending interrupts.

This assumes that device is never reset from
its vq/config callbacks, or in parallel with being
added/removed, document this assumption.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Tested with virtio-net only.
Rusty, a bugfix, so 3.2 material?

 drivers/virtio/virtio_pci.c   |   18 ++++++++++++++++++
 include/linux/virtio_config.h |    2 ++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index d242fcc..cb1090e 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -321,11 +321,29 @@ static void vp_set_status(struct virtio_device *vdev, u8 status)
 	iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
 }
 
+/* wait for pending irq handlers */
+static void vp_synchronize_vectors(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	int i;
+
+	if (vp_dev->intx_enabled)
+		synchronize_irq(vp_dev->pci_dev->irq);
+
+	for (i = 0; i < vp_dev->msix_vectors; ++i)
+		synchronize_irq(vp_dev->msix_entries[i].vector);
+}
+
 static void vp_reset(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	/* 0 status means a reset. */
 	iowrite8(0, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
+	/* Flush out the status write, and flush in device writes,
+	 * including MSi-X interrupts, if any. */
+	ioread8(vp_dev->ioaddr + VIRTIO_PCI_STATUS);
+	/* Flush pending VQ/configuration callbacks. */
+	vp_synchronize_vectors(vdev);
 }
 
 /* the notify function used when creating a virt queue */
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index add4790..e9e72bd 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -85,6 +85,8 @@
  * @reset: reset the device
  *	vdev: the virtio device
  *	After this, status and feature negotiation must be done again
+ *	Device must not be reset from its vq/config callbacks, or in
+ *	parallel with being added/removed.
  * @find_vqs: find virtqueues and instantiate them.
  *	vdev: the virtio_device
  *	nvqs: the number of virtqueues to find
-- 
1.7.5.53.gc233e
