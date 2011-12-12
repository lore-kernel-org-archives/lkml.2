Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090Ab1LLFN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:13:56 -0500
Received: from ozlabs.org ([203.10.76.45]:46732 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab1LLFNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:13:53 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amos Kong <akong@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
In-Reply-To: <4EE56FCD.9030609@redhat.com>
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>  <1322867384.11728.20.camel@pasglop> <87hb1iqls3.fsf@rustcorp.com.au>  <20111211122544.GC11504@redhat.com> <1323642447.19891.8.camel@pasglop> <4EE56FCD.9030609@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 12 Dec 2011 15:42:09 +1030
Message-ID: <87wra2tlue.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011 11:06:53 +0800, Amos Kong <akong@redhat.com> wrote:
> On 12/12/11 06:27, Benjamin Herrenschmidt wrote:
> > On Sun, 2011-12-11 at 14:25 +0200, Michael S. Tsirkin wrote:
> >
> >> Forwarding some results by Amos, who run multiple netperf streams in
> >> parallel, from an external box to the guest.  TCP_STREAM results were
> >> noisy.  This could be due to buffering done by TCP, where packet size
> >> varies even as message size is constant.
> >>
> >> TCP_RR results were consistent. In this benchmark, after switching
> >> to mandatory barriers, CPU utilization increased by up to 35% while
> >> throughput went down by up to 14%. the normalized throughput/cpu
> >> regressed consistently, between 7 and 35%
> >>
> >> The "fix" applied was simply this:
> >
> > What machine&  processor was this  ?
> 
> pined guest memory to numa node 1

Please try this patch.  How much does the branch cost us?

(Compiles, untested).

Thanks,
Rusty.

From: Rusty Russell <rusty@rustcorp.com.au>
Subject: virtio: harsher barriers for virtio-mmio.

We were cheating with our barriers; using the smp ones rather than the
real device ones.  That was fine, until virtio-mmio came along, which
could be talking to a real device (a non-SMP CPU).

Unfortunately, just putting back the real barriers (reverting
d57ed95d) causes a performance regression on virtio-pci.  In
particular, Amos reports netbench's TCP_RR over virtio_net CPU
utilization increased up to 35% while throughput went down by up to
14%.

By comparison, this branch costs us???

Reference: https://lkml.org/lkml/2011/12/11/22

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/lguest_device.c |   10 ++++++----
 drivers/s390/kvm/kvm_virtio.c  |    2 +-
 drivers/virtio/virtio_mmio.c   |    7 ++++---
 drivers/virtio/virtio_pci.c    |    4 ++--
 drivers/virtio/virtio_ring.c   |   34 +++++++++++++++++++++-------------
 include/linux/virtio_ring.h    |    1 +
 tools/virtio/linux/virtio.h    |    1 +
 tools/virtio/virtio_test.c     |    3 ++-
 8 files changed, 38 insertions(+), 24 deletions(-)

diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -291,11 +291,13 @@ static struct virtqueue *lg_find_vq(stru
 	}
 
 	/*
-	 * OK, tell virtio_ring.c to set up a virtqueue now we know its size
-	 * and we've got a pointer to its pages.
+	 * OK, tell virtio_ring.c to set up a virtqueue now we know its size
+	 * and we've got a pointer to its pages.  Note that we set weak_barriers
+	 * to 'true': the host just a(nother) SMP CPU, so we only need inter-cpu
+	 * barriers.
 	 */
-	vq = vring_new_virtqueue(lvq->config.num, LGUEST_VRING_ALIGN,
-				 vdev, lvq->pages, lg_notify, callback, name);
+	vq = vring_new_virtqueue(lvq->config.num, LGUEST_VRING_ALIGN, vdev,
+				 true, lvq->pages, lg_notify, callback, name);
 	if (!vq) {
 		err = -ENOMEM;
 		goto unmap;
diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -198,7 +198,7 @@ static struct virtqueue *kvm_find_vq(str
 		goto out;
 
 	vq = vring_new_virtqueue(config->num, KVM_S390_VIRTIO_RING_ALIGN,
-				 vdev, (void *) config->address,
+				 vdev, true, (void *) config->address,
 				 kvm_notify, callback, name);
 	if (!vq) {
 		err = -ENOMEM;
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -309,9 +309,10 @@ static struct virtqueue *vm_setup_vq(str
 	writel(virt_to_phys(info->queue) >> PAGE_SHIFT,
 			vm_dev->base + VIRTIO_MMIO_QUEUE_PFN);
 
-	/* Create the vring */
-	vq = vring_new_virtqueue(info->num, VIRTIO_MMIO_VRING_ALIGN,
-				 vdev, info->queue, vm_notify, callback, name);
+	/* Create the vring: no weak barriers, the other side is could
+	 * be an independent "device". */
+	vq = vring_new_virtqueue(info->num, VIRTIO_MMIO_VRING_ALIGN, vdev,
+				 false, info->queue, vm_notify, callback, name);
 	if (!vq) {
 		err = -ENOMEM;
 		goto error_new_virtqueue;
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -414,8 +414,8 @@ static struct virtqueue *setup_vq(struct
 		  vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
 
 	/* create the vring */
-	vq = vring_new_virtqueue(info->num, VIRTIO_PCI_VRING_ALIGN,
-				 vdev, info->queue, vp_notify, callback, name);
+	vq = vring_new_virtqueue(info->num, VIRTIO_PCI_VRING_ALIGN, vdev,
+				 true, info->queue, vp_notify, callback, name);
 	if (!vq) {
 		err = -ENOMEM;
 		goto out_activate_queue;
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -28,17 +28,20 @@
 #ifdef CONFIG_SMP
 /* Where possible, use SMP barriers which are more lightweight than mandatory
  * barriers, because mandatory barriers control MMIO effects on accesses
- * through relaxed memory I/O windows (which virtio does not use). */
-#define virtio_mb() smp_mb()
-#define virtio_rmb() smp_rmb()
-#define virtio_wmb() smp_wmb()
+ * through relaxed memory I/O windows (which virtio-pci does not use). */
+#define virtio_mb(vq) \
+	do { if ((vq)->weak_barriers) smp_mb(); else mb(); } while(0)
+#define virtio_rmb(vq) \
+	do { if ((vq)->weak_barriers) smp_rmb(); else rmb(); } while(0)
+#define virtio_wmb(vq) \
+	do { if ((vq)->weak_barriers) smp_rmb(); else rmb(); } while(0)
 #else
 /* We must force memory ordering even if guest is UP since host could be
  * running on another CPU, but SMP barriers are defined to barrier() in that
  * configuration. So fall back to mandatory barriers instead. */
-#define virtio_mb() mb()
-#define virtio_rmb() rmb()
-#define virtio_wmb() wmb()
+#define virtio_mb(vq) mb()
+#define virtio_rmb(vq) rmb()
+#define virtio_wmb(vq) wmb()
 #endif
 
 #ifdef DEBUG
@@ -77,6 +80,9 @@ struct vring_virtqueue
 	/* Actual memory layout for this queue */
 	struct vring vring;
 
+	/* Can we use weak barriers? */
+	bool weak_barriers;
+
 	/* Other side has made a mess, don't try any more. */
 	bool broken;
 
@@ -245,14 +251,14 @@ void virtqueue_kick(struct virtqueue *_v
 	START_USE(vq);
 	/* Descriptors and available array need to be set before we expose the
 	 * new available array entries. */
-	virtio_wmb();
+	virtio_wmb(vq);
 
 	old = vq->vring.avail->idx;
 	new = vq->vring.avail->idx = old + vq->num_added;
 	vq->num_added = 0;
 
 	/* Need to update avail index before checking if we should notify */
-	virtio_mb();
+	virtio_mb(vq);
 
 	if (vq->event ?
 	    vring_need_event(vring_avail_event(&vq->vring), new, old) :
@@ -314,7 +320,7 @@ void *virtqueue_get_buf(struct virtqueue
 	}
 
 	/* Only get used array entries after they have been exposed by host. */
-	virtio_rmb();
+	virtio_rmb(vq);
 
 	i = vq->vring.used->ring[vq->last_used_idx%vq->vring.num].id;
 	*len = vq->vring.used->ring[vq->last_used_idx%vq->vring.num].len;
@@ -337,7 +343,7 @@ void *virtqueue_get_buf(struct virtqueue
 	 * the read in the next get_buf call. */
 	if (!(vq->vring.avail->flags & VRING_AVAIL_F_NO_INTERRUPT)) {
 		vring_used_event(&vq->vring) = vq->last_used_idx;
-		virtio_mb();
+		virtio_mb(vq);
 	}
 
 	END_USE(vq);
@@ -366,7 +372,7 @@ bool virtqueue_enable_cb(struct virtqueu
 	 * entry. Always do both to keep code simple. */
 	vq->vring.avail->flags &= ~VRING_AVAIL_F_NO_INTERRUPT;
 	vring_used_event(&vq->vring) = vq->last_used_idx;
-	virtio_mb();
+	virtio_mb(vq);
 	if (unlikely(more_used(vq))) {
 		END_USE(vq);
 		return false;
@@ -393,7 +399,7 @@ bool virtqueue_enable_cb_delayed(struct 
 	/* TODO: tune this threshold */
 	bufs = (u16)(vq->vring.avail->idx - vq->last_used_idx) * 3 / 4;
 	vring_used_event(&vq->vring) = vq->last_used_idx + bufs;
-	virtio_mb();
+	virtio_mb(vq);
 	if (unlikely((u16)(vq->vring.used->idx - vq->last_used_idx) > bufs)) {
 		END_USE(vq);
 		return false;
@@ -453,6 +459,7 @@ EXPORT_SYMBOL_GPL(vring_interrupt);
 struct virtqueue *vring_new_virtqueue(unsigned int num,
 				      unsigned int vring_align,
 				      struct virtio_device *vdev,
+				      bool weak_barriers,
 				      void *pages,
 				      void (*notify)(struct virtqueue *),
 				      void (*callback)(struct virtqueue *),
@@ -476,6 +483,7 @@ struct virtqueue *vring_new_virtqueue(un
 	vq->vq.vdev = vdev;
 	vq->vq.name = name;
 	vq->notify = notify;
+	vq->weak_barriers = weak_barriers;
 	vq->broken = false;
 	vq->last_used_idx = 0;
 	vq->num_added = 0;
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -168,6 +168,7 @@ struct virtqueue;
 struct virtqueue *vring_new_virtqueue(unsigned int num,
 				      unsigned int vring_align,
 				      struct virtio_device *vdev,
+				      bool weak_barriers,
 				      void *pages,
 				      void (*notify)(struct virtqueue *vq),
 				      void (*callback)(struct virtqueue *vq),
diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
--- a/tools/virtio/linux/virtio.h
+++ b/tools/virtio/linux/virtio.h
@@ -214,6 +214,7 @@ void *virtqueue_detach_unused_buf(struct
 struct virtqueue *vring_new_virtqueue(unsigned int num,
 				      unsigned int vring_align,
 				      struct virtio_device *vdev,
+				      bool weak_barriers,
 				      void *pages,
 				      void (*notify)(struct virtqueue *vq),
 				      void (*callback)(struct virtqueue *vq),
diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -92,7 +92,8 @@ static void vq_info_add(struct vdev_info
 	assert(r >= 0);
 	memset(info->ring, 0, vring_size(num, 4096));
 	vring_init(&info->vring, num, info->ring, 4096);
-	info->vq = vring_new_virtqueue(info->vring.num, 4096, &dev->vdev, info->ring,
+	info->vq = vring_new_virtqueue(info->vring.num, 4096, &dev->vdev,
+				       true, info->ring,
 				       vq_notify, vq_callback, "test");
 	assert(info->vq);
 	info->vq->priv = info;
