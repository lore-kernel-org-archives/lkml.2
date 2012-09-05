Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059Ab2IESqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:46:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab2IESqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:46:47 -0400
Date: Wed, 5 Sep 2012 21:47:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Ohad Ben-Cohen <ohad@wizery.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Stratos Psomadakis <psomas@cslab.ece.ntua.gr>,
        "David S. Miller" <davem@davemloft.net>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH] virtio: support reserved vqs
Message-ID: <20120905184745.GA15861@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio network device multiqueue support reserves
vq 3 for future use (useful both for future extensions and to make it
pretty - this way receive vqs have even and transmit - odd numbers).
Make it possible to skip initialization for
specific vq numbers by specifying NULL for name.
Document this usage as well as (existing) NULL callback.

Drivers using this not coded up yet, so I simply tested
with virtio-pci and verified that this patch does
not break existing drivers.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/lguest/lguest_device.c         | 3 +++
 drivers/remoteproc/remoteproc_virtio.c | 3 +++
 drivers/s390/kvm/kvm_virtio.c          | 3 +++
 drivers/virtio/virtio_mmio.c           | 3 +++
 drivers/virtio/virtio_pci.c            | 5 ++++-
 include/linux/virtio_config.h          | 2 ++
 6 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
index 9e8388e..e849e12 100644
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -263,6 +263,9 @@ static struct virtqueue *lg_find_vq(struct virtio_device *vdev,
 	struct virtqueue *vq;
 	int err;
 
+	if (!name)
+		return NULL;
+
 	/* We must have this many virtqueues. */
 	if (index >= ldev->desc->num_vq)
 		return ERR_PTR(-ENOENT);
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 3541b44..bda6750 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -84,6 +84,9 @@ static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
 	if (id >= ARRAY_SIZE(rvdev->vring))
 		return ERR_PTR(-EINVAL);
 
+	if (!name)
+		return NULL;
+
 	ret = rproc_alloc_vring(rvdev, id);
 	if (ret)
 		return ERR_PTR(ret);
diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
index 47cccd5..6e842d1 100644
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -190,6 +190,9 @@ static struct virtqueue *kvm_find_vq(struct virtio_device *vdev,
 	if (index >= kdev->desc->num_vq)
 		return ERR_PTR(-ENOENT);
 
+	if (!name)
+		return NULL;
+
 	config = kvm_vq_config(kdev->desc)+index;
 
 	err = vmem_add_mapping(config->address,
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 453db0c..b1f342e 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -309,6 +309,9 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned index,
 	unsigned long flags, size;
 	int err;
 
+	if (!name)
+		return NULL;
+
 	/* Select the queue we're interested in */
 	writel(index, vm_dev->base + VIRTIO_MMIO_QUEUE_SEL);
 
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 2e03d41..92809ba 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -542,7 +542,10 @@ static int vp_try_to_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	vp_dev->per_vq_vectors = per_vq_vectors;
 	allocated_vectors = vp_dev->msix_used_vectors;
 	for (i = 0; i < nvqs; ++i) {
-		if (!callbacks[i] || !vp_dev->msix_enabled)
+		if (!names[i]) {
+			vqs[i] = NULL;
+			continue;
+		} else if (!callbacks[i] || !vp_dev->msix_enabled)
 			msix_vec = VIRTIO_MSI_NO_VECTOR;
 		else if (vp_dev->per_vq_vectors)
 			msix_vec = allocated_vectors++;
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index fc457f4..07c0c69 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -84,7 +84,9 @@
  *	nvqs: the number of virtqueues to find
  *	vqs: on success, includes new virtqueues
  *	callbacks: array of callbacks, for each virtqueue
+ *		include a NULL entry for vqs that do not need a callback
  *	names: array of virtqueue names (mainly for debugging)
+ *		include a NULL entry for vqs unused by driver
  *	Returns 0 on success or error status
  * @del_vqs: free virtqueues found by find_vqs().
  * @get_features: get the array of feature bits for this device.
-- 
MST
