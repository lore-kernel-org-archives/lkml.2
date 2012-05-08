Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab2EHLeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 07:34:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288Ab2EHLeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 07:34:03 -0400
Date: Tue, 8 May 2012 14:34:01 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH untested] virtio: allocate extra memory before the ring (
 was Re: [RFC PATCH] virtio_console: link vq to port with a private) pointer
 in struct virtqueue
Message-ID: <20120508113401.GA16741@redhat.com>
References: <87397be80k.fsf@rustcorp.com.au>
 <1336470355-19257-1-git-send-email-pbonzini@redhat.com>
 <20120508105654.GB15598@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120508105654.GB15598@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> virtio: allocate extra memory before the ring
> 
> This let transports put their data inline instead
> of indirect acces through priv pointer.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

And transports would do something like the below to avoid
using priv.  Warning: completely untested.

------------------------------>
    virtio_pci: put vq info structure inline
    
    vq->priv is now unused by virtio_pci.
    
    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 3c3eea9..4092006 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -73,9 +73,6 @@ enum {
 
 struct virtio_pci_vq_info
 {
-	/* the actual virtqueue */
-	struct virtqueue *vq;
-
 	/* the number of entries in the queue */
 	int num;
 
@@ -90,8 +87,15 @@ struct virtio_pci_vq_info
 
 	/* MSI-X vector (or none) */
 	unsigned msix_vector;
+
+	/* the actual virtqueue. Note: must be the last field */
+	struct virtqueue vq;
 };
 
+#define to_vpinfo(vq) container_of(info, struct virtio_pci_vq_info, vq)
+/* How much space we need to reserve before struct virtqueue */
+#define VPINFO_PRIV offsetof(struct virtio_pci_vq_info, vq)
+
 /* Qumranet donated their vendor ID for devices 0x1000 thru 0x10FF. */
 static struct pci_device_id virtio_pci_id_table[] = {
 	{ 0x1af4, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
@@ -202,7 +206,7 @@ static void vp_reset(struct virtio_device *vdev)
 static void vp_notify(struct virtqueue *vq)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
-	struct virtio_pci_vq_info *info = vq->priv;
+	struct virtio_pci_vq_info *info = to_vpinfo(vq);
 
 	/* we write the queue's selector into the notification register to
 	 * signal the other end */
@@ -232,7 +236,7 @@ static irqreturn_t vp_vring_interrupt(int irq, void *opaque)
 
 	spin_lock_irqsave(&vp_dev->lock, flags);
 	list_for_each_entry(info, &vp_dev->virtqueues, node) {
-		if (vring_interrupt(irq, info->vq) == IRQ_HANDLED)
+		if (vring_interrupt(irq, &info->vq) == IRQ_HANDLED)
 			ret = IRQ_HANDLED;
 	}
 	spin_unlock_irqrestore(&vp_dev->lock, flags);
@@ -385,6 +389,7 @@ static struct virtqueue *setup_vq(struct virtio_device *vdev, unsigned index,
 	struct virtio_pci_vq_info *info;
 	struct virtqueue *vq;
 	unsigned long flags, size;
+	void *queue;
 	u16 num;
 	int err;
 
@@ -398,35 +403,34 @@ static struct virtqueue *setup_vq(struct virtio_device *vdev, unsigned index,
 
 	/* allocate and fill out our structure the represents an active
 	 * queue */
-	info = kmalloc(sizeof(struct virtio_pci_vq_info), GFP_KERNEL);
-	if (!info)
-		return ERR_PTR(-ENOMEM);
-
-	info->queue_index = index;
-	info->num = num;
-	info->msix_vector = msix_vec;
 
 	size = PAGE_ALIGN(vring_size(num, VIRTIO_PCI_VRING_ALIGN));
-	info->queue = alloc_pages_exact(size, GFP_KERNEL|__GFP_ZERO);
-	if (info->queue == NULL) {
+	queue = alloc_pages_exact(size, GFP_KERNEL|__GFP_ZERO);
+	if (queue == NULL) {
 		err = -ENOMEM;
 		goto out_info;
 	}
 
 	/* activate the queue */
-	iowrite32(virt_to_phys(info->queue) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT,
+	iowrite32(virt_to_phys(queue) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT,
 		  vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
 
-	/* create the vring */
-	vq = vring_new_virtqueue(0, info->num, VIRTIO_PCI_VRING_ALIGN, vdev,
-				 true, info->queue, vp_notify, callback, name);
+	/* We can store transport specific data before the vq field.
+	 * Make sure we don't have any fields after it. */
+	BUILD_BUG_ON(VPINFO_PRIV + sizeof info->vq != sizeof *info);
+
+	vq = vring_new_virtqueue(VPINFO_PRIV, num, VIRTIO_PCI_VRING_ALIGN, vdev,
+				 true, queue, vp_notify, callback, name);
 	if (!vq) {
 		err = -ENOMEM;
 		goto out_activate_queue;
 	}
 
-	vq->priv = info;
-	info->vq = vq;
+	info = to_vpinfo(vq);
+
+	info->queue_index = index;
+	info->num = num;
+	info->msix_vector = msix_vec;
 
 	if (msix_vec != VIRTIO_MSI_NO_VECTOR) {
 		iowrite16(msix_vec, vp_dev->ioaddr + VIRTIO_MSI_QUEUE_VECTOR);
@@ -448,20 +452,21 @@ static struct virtqueue *setup_vq(struct virtio_device *vdev, unsigned index,
 	return vq;
 
 out_assign:
-	vring_del_virtqueue(vq, 0);
+	vring_del_virtqueue(vq, VPINFO_PRIV);
 out_activate_queue:
 	iowrite32(0, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
 	free_pages_exact(info->queue, size);
 out_info:
-	kfree(info);
 	return ERR_PTR(err);
 }
 
 static void vp_del_vq(struct virtqueue *vq)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
-	struct virtio_pci_vq_info *info = vq->priv;
+	struct virtio_pci_vq_info *info = to_vpinfo(vq);
 	unsigned long flags, size;
+	void *queue = info->queue;
+	u16 num = info->num;
 
 	spin_lock_irqsave(&vp_dev->lock, flags);
 	list_del(&info->node);
@@ -476,14 +481,13 @@ static void vp_del_vq(struct virtqueue *vq)
 		ioread8(vp_dev->ioaddr + VIRTIO_PCI_ISR);
 	}
 
-	vring_del_virtqueue(vq, 0);
+	vring_del_virtqueue(vq, VPINFO_PRIV);
 
 	/* Select and deactivate the queue */
 	iowrite32(0, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
 
 	size = PAGE_ALIGN(vring_size(info->num, VIRTIO_PCI_VRING_ALIGN));
-	free_pages_exact(info->queue, size);
-	kfree(info);
+	free_pages_exact(queue, size);
 }
 
 /* the config->del_vqs() implementation */
@@ -494,7 +498,7 @@ static void vp_del_vqs(struct virtio_device *vdev)
 	struct virtio_pci_vq_info *info;
 
 	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
-		info = vq->priv;
+		info = to_vpinfo(vq);
 		if (vp_dev->per_vq_vectors &&
 			info->msix_vector != VIRTIO_MSI_NO_VECTOR)
 			free_irq(vp_dev->msix_entries[info->msix_vector].vector,
