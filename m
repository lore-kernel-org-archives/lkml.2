Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab2JQKOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:14:53 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33230 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756571Ab2JQKOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:14:51 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Sasha Levin <levinsasha928@gmail.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] virtio: 9p: correctly pass physical address to userspace for high pages
Date: Wed, 17 Oct 2012 11:14:37 +0100
Message-Id: <1350468877-7677-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using a virtio transport, the 9p net device allocates pages to back
the descriptors inserted into the virtqueue. These allocations may be
performed from atomic context (under the channel lock) and can therefore
return high mappings which aren't suitable for virt_to_phys.

This patch ensures that virtual addresses for virtio queue descriptors
are converted to physical addresses using kmap_to_page, which handles
high memory correctly.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 drivers/virtio/virtio_ring.c |    4 +++-
 net/9p/trans_virtio.c        |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index e639584..be93946 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -22,6 +22,7 @@
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/highmem.h>
 #include <linux/hrtimer.h>
 
 /* virtio guest is communicating with a virtual "device" that actually runs on
@@ -165,7 +166,8 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
 	/* Use a single buffer which doesn't continue */
 	head = vq->free_head;
 	vq->vring.desc[head].flags = VRING_DESC_F_INDIRECT;
-	vq->vring.desc[head].addr = virt_to_phys(desc);
+	vq->vring.desc[head].addr = page_to_phys(kmap_to_page(desc)) +
+				    ((unsigned long)desc & ~PAGE_MASK);
 	vq->vring.desc[head].len = i * sizeof(struct vring_desc);
 
 	/* Update free pointer */
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 35b8911..fd05c81 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -39,6 +39,7 @@
 #include <linux/inet.h>
 #include <linux/idr.h>
 #include <linux/file.h>
+#include <linux/highmem.h>
 #include <linux/slab.h>
 #include <net/9p/9p.h>
 #include <linux/parser.h>
@@ -325,7 +326,7 @@ static int p9_get_mapped_pages(struct virtio_chan *chan,
 		int count = nr_pages;
 		while (nr_pages) {
 			s = rest_of_page(data);
-			pages[index++] = virt_to_page(data);
+			pages[index++] = kmap_to_page(data);
 			data += s;
 			nr_pages--;
 		}
-- 
1.7.4.1

