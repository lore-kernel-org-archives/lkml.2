Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761122Ab2JaWsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 18:48:03 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52934 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760987Ab2JaWrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 18:47:04 -0400
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        sjur@brendeland.net, dmitry.tarnyagin@stericsson.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFC virtio-next 3/4] virtio_ring: Call callback function even when used ring is empty
Date: Wed, 31 Oct 2012 23:46:53 +0100
Message-Id: <1351723614-4145-4-git-send-email-sjur@brendeland.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351723614-4145-1-git-send-email-sjur@brendeland.net>
References: <1351723614-4145-1-git-send-email-sjur@brendeland.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Enable option to force call of callback function even if
used ring is empty. This is needed for reversed vring.
Add a helper function  __vring_interrupt and add extra
boolean argument for forcing callback when interrupt is called.
The original vring_interrupt semantic and signature is
perserved.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_virtio.c |    2 +-
 drivers/virtio/virtio_ring.c           |    6 +++---
 include/linux/virtio_ring.h            |    8 +++++++-
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index e7a4780..ddde863 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -63,7 +63,7 @@ irqreturn_t rproc_vq_interrupt(struct rproc *rproc, int notifyid)
 	if (!rvring || !rvring->vq)
 		return IRQ_NONE;
 
-	return vring_interrupt(0, rvring->vq);
+	return __vring_interrupt(0, rvring->vq, true);
 }
 EXPORT_SYMBOL(rproc_vq_interrupt);
 
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 9027af6..af85034 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -504,11 +504,11 @@ void *virtqueue_detach_unused_buf(struct virtqueue *_vq)
 }
 EXPORT_SYMBOL_GPL(virtqueue_detach_unused_buf);
 
-irqreturn_t vring_interrupt(int irq, void *_vq)
+irqreturn_t __vring_interrupt(int irq, void *_vq, bool force)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	if (!more_used(vq)) {
+	if (!force && !more_used(vq)) {
 		pr_debug("virtqueue interrupt with no work for %p\n", vq);
 		return IRQ_NONE;
 	}
@@ -522,7 +522,7 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
 
 	return IRQ_HANDLED;
 }
-EXPORT_SYMBOL_GPL(vring_interrupt);
+EXPORT_SYMBOL_GPL(__vring_interrupt);
 
 struct virtqueue *vring_new_virtqueue(unsigned int index,
 				      unsigned int num,
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 63c6ea1..ccb7915 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -20,5 +20,11 @@ void vring_del_virtqueue(struct virtqueue *vq);
 /* Filter out transport-specific feature bits. */
 void vring_transport_features(struct virtio_device *vdev);
 
-irqreturn_t vring_interrupt(int irq, void *_vq);
+irqreturn_t __vring_interrupt(int irq, void *_vq, bool force);
+
+static inline irqreturn_t vring_interrupt(int irq, void *_vq)
+{
+	return __vring_interrupt(irq, _vq, false);
+}
+
 #endif /* _LINUX_VIRTIO_RING_H */
-- 
1.7.9.5

