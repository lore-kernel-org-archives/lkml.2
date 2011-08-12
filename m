Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1HLB64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 21:58:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab1HLB6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 21:58:54 -0400
Subject: [net-next RFC PATCH 6/7] Change virtqueue structure
To: mst@redhat.com, netdev@vger.kernel.org, jasowang@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, davem@davemloft.net
From: Jason Wang <jasowang@redhat.com>
Cc: krkumar2@in.ibm.com, rusty@rustcorp.com.au, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, mirq-linux@rere.qmqm.pl
Date: Fri, 12 Aug 2011 09:55:41 +0800
Message-ID: <20110812015541.31613.99230.stgit@intel-e5620-16-2.englab.nay.redhat.com>
In-Reply-To: <20110812015221.31613.95001.stgit@intel-e5620-16-2.englab.nay.redhat.com>
References: <20110812015221.31613.95001.stgit@intel-e5620-16-2.englab.nay.redhat.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krishna Kumar <krkumar2@in.ibm.com>

Move queue_index from virtio_pci_vq_info to virtqueue.  This
allows callback handlers to figure out the queue number for
the vq that needs attention.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
---
 drivers/virtio/virtio_pci.c |   10 +++-------
 include/linux/virtio.h      |    1 +
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 4bcc8b8..395af63 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -75,9 +75,6 @@ struct virtio_pci_vq_info
 	/* the number of entries in the queue */
 	int num;
 
-	/* the index of the queue */
-	int queue_index;
-
 	/* the virtual address of the ring queue */
 	void *queue;
 
@@ -180,11 +177,10 @@ static void vp_reset(struct virtio_device *vdev)
 static void vp_notify(struct virtqueue *vq)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
-	struct virtio_pci_vq_info *info = vq->priv;
 
 	/* we write the queue's selector into the notification register to
 	 * signal the other end */
-	iowrite16(info->queue_index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_NOTIFY);
+	iowrite16(vq->queue_index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_NOTIFY);
 }
 
 /* Handle a configuration change: Tell driver if it wants to know. */
@@ -380,7 +376,6 @@ static struct virtqueue *setup_vq(struct virtio_device *vdev, unsigned index,
 	if (!info)
 		return ERR_PTR(-ENOMEM);
 
-	info->queue_index = index;
 	info->num = num;
 	info->msix_vector = msix_vec;
 
@@ -403,6 +398,7 @@ static struct virtqueue *setup_vq(struct virtio_device *vdev, unsigned index,
 		goto out_activate_queue;
 	}
 
+	vq->queue_index = index;
 	vq->priv = info;
 	info->vq = vq;
 
@@ -441,7 +437,7 @@ static void vp_del_vq(struct virtqueue *vq)
 	list_del(&info->node);
 	spin_unlock_irqrestore(&vp_dev->lock, flags);
 
-	iowrite16(info->queue_index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
+	iowrite16(vq->queue_index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
 
 	if (vp_dev->msix_enabled) {
 		iowrite16(VIRTIO_MSI_NO_VECTOR,
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 7108857..ddfbce9 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -22,6 +22,7 @@ struct virtqueue {
 	void (*callback)(struct virtqueue *vq);
 	const char *name;
 	struct virtio_device *vdev;
+	int queue_index;	/* the index of the queue */
 	void *priv;
 };
 

