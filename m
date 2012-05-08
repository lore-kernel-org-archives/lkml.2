Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab2EHJxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:53:30 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56211 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab2EHJx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:53:28 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org,
        Amit Shah <amit.shah@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC PATCH] virtio_console: link vq to port with a private pointer in struct virtqueue
Date: Tue,  8 May 2012 11:45:55 +0200
Message-Id: <1336470355-19257-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.1
In-reply-to: <87397be80k.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How bad would be it to get rid of the current ->priv and use
> container_of() instead?  ie. have virtio_pci, virtio_mmio, lguest_bus
> and s390's kvm_virtio embed the struct virtqueue?

Something like the following, compile-tested only...

The layout of vring_virtqueue gets a bit complex, with private vring
data _before_ the struct virtqueue and private bus data after it.

The alternative is to make vring_virtqueue public.  It has some
appeal (for example many backends duplicate the num and pages members
in their private data) but overall I think I prefer this.

Anyhow, it is doable, the patches aren't too small but they are easily
split and quite boring.  Shall I pursue this instead?

Paolo

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 2e03d41..047ce01 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -71,10 +71,10 @@ enum {
 	VP_MSIX_VQ_VECTOR = 1,
 };
 
-struct virtio_pci_vq_info
+struct virtio_pci_vq
 {
 	/* the actual virtqueue */
-	struct virtqueue *vq;
+	struct virtqueue vq;
 
 	/* the number of entries in the queue */
 	int num;
@@ -106,6 +106,12 @@ static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
 	return container_of(vdev, struct virtio_pci_device, vdev);
 }
 
+/* Convert a generic virtio virtqueue to our structure */
+static struct virtio_pci_vq *to_vp_queue(struct virtqueue *vq)
+{
+	return container_of(vq, struct virtio_pci_vq, vq);
+}
+
 /* virtio config->get_features() implementation */
 static u32 vp_get_features(struct virtio_device *vdev)
 {
@@ -202,11 +208,11 @@ static void vp_reset(struct virtio_device *vdev)
 static void vp_notify(struct virtqueue *vq)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
-	struct virtio_pci_vq_info *info = vq->priv;
+	struct virtio_pci_vq *vp_queue = to_vp_queue(vq);
 
 	/* we write the queue's selector into the notification register to
 	 * signal the other end */
-	iowrite16(info->queue_index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_NOTIFY);
+	iowrite16(vp_queue->queue_index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_NOTIFY);
 }
 
 /* Handle a configuration change: Tell driver if it wants to know. */
@@ -226,13 +232,13 @@ static irqreturn_t vp_config_changed(int irq, void *opaque)
 static irqreturn_t vp_vring_interrupt(int irq, void *opaque)
 {
 	struct virtio_pci_device *vp_dev = opaque;
-	struct virtio_pci_vq_info *info;
+	struct virtio_pci_vq *vp_queue;
 	irqreturn_t ret = IRQ_NONE;
 	unsigned long flags;
 
 	spin_lock_irqsave(&vp_dev->lock, flags);
-	list_for_each_entry(info, &vp_dev->virtqueues, node) {
-		if (vring_interrupt(irq, info->vq) == IRQ_HANDLED)
+	list_for_each_entry(vp_queue, &vp_dev->virtqueues, node) {
+		if (vring_interrupt(irq, &vp_queue->vq) == IRQ_HANDLED)
 			ret = IRQ_HANDLED;
 	}
 	spin_unlock_irqrestore(&vp_dev->lock, flags);
@@ -382,9 +388,10 @@ static struct virtqueue *setup_vq(struct virtio_device *vdev, unsigned index,
 				  u16 msix_vec)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-	struct virtio_pci_vq_info *info;
+	struct virtio_pci_vq *vp_queue;
 	struct virtqueue *vq;
 	unsigned long flags, size;
+	void *queue;
 	u16 num;
 	int err;
 
@@ -398,35 +405,32 @@ static struct virtqueue *setup_vq(struct virtio_device *vdev, unsigned index,
 
 	/* allocate and fill out our structure the represents an active
 	 * queue */
-	info = kmalloc(sizeof(struct virtio_pci_vq_info), GFP_KERNEL);
-	if (!info)
-		return ERR_PTR(-ENOMEM);
-
-	info->queue_index = index;
-	info->num = num;
-	info->msix_vector = msix_vec;
-
 	size = PAGE_ALIGN(vring_size(num, VIRTIO_PCI_VRING_ALIGN));
-	info->queue = alloc_pages_exact(size, GFP_KERNEL|__GFP_ZERO);
-	if (info->queue == NULL) {
+	queue = alloc_pages_exact(size, GFP_KERNEL|__GFP_ZERO);
+	if (queue == NULL) {
 		err = -ENOMEM;
-		goto out_info;
+		goto out;
 	}
 
 	/* activate the queue */
-	iowrite32(virt_to_phys(info->queue) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT,
+	iowrite32(virt_to_phys(queue) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT,
 		  vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
 
 	/* create the vring */
-	vq = vring_new_virtqueue(info->num, VIRTIO_PCI_VRING_ALIGN, vdev,
-				 true, info->queue, vp_notify, callback, name);
+	vq = vring_new_virtqueue(sizeof(struct virtio_pci_vq),
+				 num, VIRTIO_PCI_VRING_ALIGN, vdev,
+				 true, queue, vp_notify, callback, name);
 	if (!vq) {
 		err = -ENOMEM;
 		goto out_activate_queue;
 	}
 
-	vq->priv = info;
-	info->vq = vq;
+	/* fill out our structure */
+	vp_queue = to_vp_queue(vq);
+	vp_queue->queue_index = index;
+	vp_queue->num = num;
+	vp_queue->msix_vector = msix_vec;
+	vp_queue->queue = queue;
 
 	if (msix_vec != VIRTIO_MSI_NO_VECTOR) {
 		iowrite16(msix_vec, vp_dev->ioaddr + VIRTIO_MSI_QUEUE_VECTOR);
@@ -439,10 +443,10 @@ static struct virtqueue *setup_vq(struct virtio_device *vdev, unsigned index,
 
 	if (callback) {
 		spin_lock_irqsave(&vp_dev->lock, flags);
-		list_add(&info->node, &vp_dev->virtqueues);
+		list_add(&vp_queue->node, &vp_dev->virtqueues);
 		spin_unlock_irqrestore(&vp_dev->lock, flags);
 	} else {
-		INIT_LIST_HEAD(&info->node);
+		INIT_LIST_HEAD(&vp_queue->node);
 	}
 
 	return vq;
@@ -451,23 +455,22 @@ out_assign:
 	vring_del_virtqueue(vq);
 out_activate_queue:
 	iowrite32(0, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
-	free_pages_exact(info->queue, size);
-out_info:
-	kfree(info);
+	free_pages_exact(queue, size);
+out:
 	return ERR_PTR(err);
 }
 
 static void vp_del_vq(struct virtqueue *vq)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
-	struct virtio_pci_vq_info *info = vq->priv;
+	struct virtio_pci_vq *vp_queue = to_vp_queue(vq);
 	unsigned long flags, size;
 
 	spin_lock_irqsave(&vp_dev->lock, flags);
-	list_del(&info->node);
+	list_del(&vp_queue->node);
 	spin_unlock_irqrestore(&vp_dev->lock, flags);
 
-	iowrite16(info->queue_index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
+	iowrite16(vp_queue->queue_index, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_SEL);
 
 	if (vp_dev->msix_enabled) {
 		iowrite16(VIRTIO_MSI_NO_VECTOR,
@@ -481,9 +484,8 @@ static void vp_del_vq(struct virtqueue *vq)
 	/* Select and deactivate the queue */
 	iowrite32(0, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
 
-	size = PAGE_ALIGN(vring_size(info->num, VIRTIO_PCI_VRING_ALIGN));
-	free_pages_exact(info->queue, size);
-	kfree(info);
+	size = PAGE_ALIGN(vring_size(vp_queue->num, VIRTIO_PCI_VRING_ALIGN));
+	free_pages_exact(vp_queue->queue, size);
 }
 
 /* the config->del_vqs() implementation */
@@ -491,13 +493,13 @@ static void vp_del_vqs(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	struct virtqueue *vq, *n;
-	struct virtio_pci_vq_info *info;
+	struct virtio_pci_vq *vp_queue;
 
 	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
-		info = vq->priv;
+		vp_queue = to_vp_queue(vq);
 		if (vp_dev->per_vq_vectors &&
-			info->msix_vector != VIRTIO_MSI_NO_VECTOR)
-			free_irq(vp_dev->msix_entries[info->msix_vector].vector,
+			vp_queue->msix_vector != VIRTIO_MSI_NO_VECTOR)
+			free_irq(vp_dev->msix_entries[vp_queue->msix_vector].vector,
 				 vq);
 		vp_del_vq(vq);
 	}
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 5aa43c3..8feee6b 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -76,8 +76,6 @@
 
 struct vring_virtqueue
 {
-	struct virtqueue vq;
-
 	/* Actual memory layout for this queue */
 	struct vring vring;
 
@@ -106,6 +104,9 @@ struct vring_virtqueue
 	/* How to notify other side. FIXME: commonalize hcalls! */
 	void (*notify)(struct virtqueue *vq);
 
+	/* Tokens for callbacks. */
+	void **data;
+
 #ifdef DEBUG
 	/* They're supposed to lock for us. */
 	unsigned int in_use;
@@ -115,8 +116,9 @@ struct vring_virtqueue
 	ktime_t last_add_time;
 #endif
 
-	/* Tokens for callbacks. */
-	void *data[];
+	struct virtqueue vq;
+
+	/* Bus-specific virtqueue data goes here.  */
 };
 
 #define to_vvq(_vq) container_of(_vq, struct vring_virtqueue, vq)
@@ -616,7 +618,8 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
 }
 EXPORT_SYMBOL_GPL(vring_interrupt);
 
-struct virtqueue *vring_new_virtqueue(unsigned int num,
+struct virtqueue *vring_new_virtqueue(size_t sz,
+				      unsigned int num,
 				      unsigned int vring_align,
 				      struct virtio_device *vdev,
 				      bool weak_barriers,
@@ -634,7 +637,23 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
 		return NULL;
 	}
 
-	vq = kmalloc(sizeof(*vq) + sizeof(void *)*num, GFP_KERNEL);
+	BUG_ON(sz < sizeof(vq->vq));
+
+	/* Add room for our own bits, which go before what we return.  */
+	sz += offsetof(struct vring_virtqueue, vq);
+
+	/* Make sure vq->data is properly aligned, since we carve it from
+	 * the same memory block.
+	 */
+	sz = round_up(sz, __alignof__(void *));
+
+	/* Now allocate the whole memory block:
+	 * 1) first goes the vring-specific parts;
+	 * 2) then the generic virtqueue data;
+	 * 3) then the bus-specific parts;
+	 * 4) then the callback tokens, pointed to by vq->data.
+	 */
+	vq = kmalloc(sz + sizeof(void *)*num, GFP_KERNEL);
 	if (!vq)
 		return NULL;
 
@@ -642,6 +661,7 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
 	vq->vq.callback = callback;
 	vq->vq.vdev = vdev;
 	vq->vq.name = name;
+	vq->data = (void **) ((char *)vq + sz);
 	vq->notify = notify;
 	vq->weak_barriers = weak_barriers;
 	vq->broken = false;
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 8efd28a..7e61e2e 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -15,7 +15,7 @@
  * @callback: the function to call when buffers are consumed (can be NULL).
  * @name: the name of this virtqueue (mainly for debugging)
  * @vdev: the virtio device this queue was created for.
- * @priv: a pointer for the virtqueue implementation to use.
+ * @priv: a pointer for the virtio device driver to use.
  */
 struct virtqueue {
 	struct list_head list;
