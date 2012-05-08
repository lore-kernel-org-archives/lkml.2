Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab2EHK4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 06:56:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab2EHK4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 06:56:53 -0400
Date: Tue, 8 May 2012 13:56:54 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH untested] virtio: allocate extra memory before the ring ( was
 Re: [RFC PATCH] virtio_console: link vq to port with a private) pointer in
 struct virtqueue
Message-ID: <20120508105654.GB15598@redhat.com>
References: <87397be80k.fsf@rustcorp.com.au>
 <1336470355-19257-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336470355-19257-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 11:45:55AM +0200, Paolo Bonzini wrote:
> > How bad would be it to get rid of the current ->priv and use
> > container_of() instead?  ie. have virtio_pci, virtio_mmio, lguest_bus
> > and s390's kvm_virtio embed the struct virtqueue?
> 
> Something like the following, compile-tested only...
> 
> The layout of vring_virtqueue gets a bit complex, with private vring
> data _before_ the struct virtqueue and private bus data after it.

If we want to do this, the right thing IMO is keeping the data inline
and at fixed offset and that means at the end.

And it's not a problem if virtqueue is exactly at start of
vring_virtqueue: we just need to allocate a bit more at start, and
offset when we free.  Here's how I would do this: first apply patch
below that adds the offset parameter, then update all transports, one
patch at a time to not use priv pointer, finally you can repurpose priv
pointer to let devices use it.
As a bonus we get small incremental patches.

Patch below is completely untested, just to give you the idea.
By the way, we need to document vring_new_virtqueue/vring_del_virtqueue.

----------------------------------------------->

virtio: allocate extra memory before the ring

This let transports put their data inline instead
of indirect acces through priv pointer.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
index 9e8388e..555b5d5 100644
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -296,7 +296,7 @@ static struct virtqueue *lg_find_vq(struct virtio_device *vdev,
 	 * to 'true': the host just a(nother) SMP CPU, so we only need inter-cpu
 	 * barriers.
 	 */
-	vq = vring_new_virtqueue(lvq->config.num, LGUEST_VRING_ALIGN, vdev,
+	vq = vring_new_virtqueue(0, lvq->config.num, LGUEST_VRING_ALIGN, vdev,
 				 true, lvq->pages, lg_notify, callback, name);
 	if (!vq) {
 		err = -ENOMEM;
@@ -331,7 +331,7 @@ static struct virtqueue *lg_find_vq(struct virtio_device *vdev,
 free_desc:
 	irq_free_desc(lvq->config.irq);
 destroy_vring:
-	vring_del_virtqueue(vq);
+	vring_del_virtqueue(vq, 0);
 unmap:
 	lguest_unmap(lvq->pages);
 free_lvq:
@@ -348,7 +348,7 @@ static void lg_del_vq(struct virtqueue *vq)
 	/* Release the interrupt */
 	free_irq(lvq->config.irq, vq);
 	/* Tell virtio_ring.c to free the virtqueue. */
-	vring_del_virtqueue(vq);
+	vring_del_virtqueue(vq, 0);
 	/* Unmap the pages containing the ring. */
 	lguest_unmap(lvq->pages);
 	/* Free our own queue information. */
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index ecf6121..cc714af 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -99,7 +99,7 @@ static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
 	 * Create the new vq, and tell virtio we're not interested in
 	 * the 'weak' smp barriers, since we're talking with a real device.
 	 */
-	vq = vring_new_virtqueue(len, rvring->align, vdev, false, addr,
+	vq = vring_new_virtqueue(0, len, rvring->align, vdev, false, addr,
 					rproc_virtio_notify, callback, name);
 	if (!vq) {
 		dev_err(rproc->dev, "vring_new_virtqueue %s failed\n", name);
@@ -124,7 +124,7 @@ static void rproc_virtio_del_vqs(struct virtio_device *vdev)
 	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
 		rvring = vq->priv;
 		rvring->vq = NULL;
-		vring_del_virtqueue(vq);
+		vring_del_virtqueue(vq, 0);
 	}
 }
 
diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
index d74e9ae..e51fcdf 100644
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -197,7 +197,7 @@ static struct virtqueue *kvm_find_vq(struct virtio_device *vdev,
 	if (err)
 		goto out;
 
-	vq = vring_new_virtqueue(config->num, KVM_S390_VIRTIO_RING_ALIGN,
+	vq = vring_new_virtqueue(0, config->num, KVM_S390_VIRTIO_RING_ALIGN,
 				 vdev, true, (void *) config->address,
 				 kvm_notify, callback, name);
 	if (!vq) {
@@ -225,7 +225,7 @@ static void kvm_del_vq(struct virtqueue *vq)
 {
 	struct kvm_vqconfig *config = vq->priv;
 
-	vring_del_virtqueue(vq);
+	vring_del_virtqueue(vq, 0);
 	vmem_remove_mapping(config->address,
 			    vring_size(config->num,
 				       KVM_S390_VIRTIO_RING_ALIGN));
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 01d6dc2..98e56dd 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -229,7 +229,7 @@ static void vm_del_vq(struct virtqueue *vq)
 	list_del(&info->node);
 	spin_unlock_irqrestore(&vm_dev->lock, flags);
 
-	vring_del_virtqueue(vq);
+	vring_del_virtqueue(vq, 0);
 
 	/* Select and deactivate the queue */
 	writel(info->queue_index, vm_dev->base + VIRTIO_MMIO_QUEUE_SEL);
@@ -310,7 +310,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned index,
 			vm_dev->base + VIRTIO_MMIO_QUEUE_PFN);
 
 	/* Create the vring */
-	vq = vring_new_virtqueue(info->num, VIRTIO_MMIO_VRING_ALIGN, vdev,
+	vq = vring_new_virtqueue(0, info->num, VIRTIO_MMIO_VRING_ALIGN, vdev,
 				 true, info->queue, vm_notify, callback, name);
 	if (!vq) {
 		err = -ENOMEM;
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 2e03d41..3c3eea9 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -418,7 +418,7 @@ static struct virtqueue *setup_vq(struct virtio_device *vdev, unsigned index,
 		  vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
 
 	/* create the vring */
-	vq = vring_new_virtqueue(info->num, VIRTIO_PCI_VRING_ALIGN, vdev,
+	vq = vring_new_virtqueue(0, info->num, VIRTIO_PCI_VRING_ALIGN, vdev,
 				 true, info->queue, vp_notify, callback, name);
 	if (!vq) {
 		err = -ENOMEM;
@@ -448,7 +448,7 @@ static struct virtqueue *setup_vq(struct virtio_device *vdev, unsigned index,
 	return vq;
 
 out_assign:
-	vring_del_virtqueue(vq);
+	vring_del_virtqueue(vq, 0);
 out_activate_queue:
 	iowrite32(0, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
 	free_pages_exact(info->queue, size);
@@ -476,7 +476,7 @@ static void vp_del_vq(struct virtqueue *vq)
 		ioread8(vp_dev->ioaddr + VIRTIO_PCI_ISR);
 	}
 
-	vring_del_virtqueue(vq);
+	vring_del_virtqueue(vq, 0);
 
 	/* Select and deactivate the queue */
 	iowrite32(0, vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 5aa43c3..688859b 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -616,7 +616,8 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
 }
 EXPORT_SYMBOL_GPL(vring_interrupt);
 
-struct virtqueue *vring_new_virtqueue(unsigned int num,
+struct virtqueue *vring_new_virtqueue(unsigned int offset,
+				      unsigned int num,
 				      unsigned int vring_align,
 				      struct virtio_device *vdev,
 				      bool weak_barriers,
@@ -627,6 +628,7 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
 {
 	struct vring_virtqueue *vq;
 	unsigned int i;
+	void *buf;
 
 	/* We assume num is a power of 2. */
 	if (num & (num - 1)) {
@@ -634,9 +636,11 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
 		return NULL;
 	}
 
-	vq = kmalloc(sizeof(*vq) + sizeof(void *)*num, GFP_KERNEL);
-	if (!vq)
+	buf = kmalloc(offset + sizeof(*vq) + sizeof(void *)*num, GFP_KERNEL);
+	if (!buf)
 		return NULL;
+	BUG_ON(offset % __alignof__(*vq));
+	vq = buf + offset;
 
 	vring_init(&vq->vring, num, pages, vring_align);
 	vq->vq.callback = callback;
@@ -669,14 +673,17 @@ struct virtqueue *vring_new_virtqueue(unsigned int num,
 	}
 	vq->data[i] = NULL;
 
+	/* Callers can overwrite off bytes before the returned pointer. */
+	BUILD_BUG_ON(offset_of(typeof(*vq), vq));
 	return &vq->vq;
 }
 EXPORT_SYMBOL_GPL(vring_new_virtqueue);
 
-void vring_del_virtqueue(struct virtqueue *vq)
+void vring_del_virtqueue(struct virtqueue *vq, unsigned int offset)
 {
+	void *buf = to_vvq(vq);
 	list_del(&vq->list);
-	kfree(to_vvq(vq));
+	kfree(buf - offset);
 }
 EXPORT_SYMBOL_GPL(vring_del_virtqueue);
 
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index e338730..b91b8c1 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -165,7 +165,8 @@ static inline int vring_need_event(__u16 event_idx, __u16 new_idx, __u16 old)
 struct virtio_device;
 struct virtqueue;
 
-struct virtqueue *vring_new_virtqueue(unsigned int num,
+struct virtqueue *vring_new_virtqueue(unsigned int offset,
+				      unsigned int num,
 				      unsigned int vring_align,
 				      struct virtio_device *vdev,
 				      bool weak_barriers,
diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index 6bf95f9..1a24799 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -92,7 +92,7 @@ static void vq_info_add(struct vdev_info *dev, int num)
 	assert(r >= 0);
 	memset(info->ring, 0, vring_size(num, 4096));
 	vring_init(&info->vring, num, info->ring, 4096);
-	info->vq = vring_new_virtqueue(info->vring.num, 4096, &dev->vdev,
+	info->vq = vring_new_virtqueue(0, info->vring.num, 4096, &dev->vdev,
 				       true, info->ring,
 				       vq_notify, vq_callback, "test");
 	assert(info->vq);
