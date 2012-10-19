Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865Ab2JSNDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:03:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49735 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758837Ab2JSNDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:03:48 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, levinsasha928@gmail.com, Marc.Zyngier@arm.com,
        virtualization@lists.linux-foundation.org, akpm@linux-foundation.org,
        ericvh@gmail.com, Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 3/3] virtio: force vring descriptors to be allocated from lowmem
Date: Fri, 19 Oct 2012 14:03:33 +0100
Message-Id: <1350651813-8694-3-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1350651813-8694-1-git-send-email-will.deacon@arm.com>
References: <1350651813-8694-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Virtio devices may attempt to add descriptors to a virtqueue from atomic
context using GFP_ATOMIC allocation. This is problematic because such
allocations can fall outside of the lowmem mapping, causing virt_to_phys
to report bogus physical addresses which are subsequently passed to
userspace via the buffers for the virtual device.

This patch masks out __GFP_HIGH and __GFP_HIGHMEM from the requested
flags when allocating descriptors for a virtqueue. If an atomic
allocation is requested and later fails, we will return -ENOSPC which
will be handled by the driver.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 drivers/virtio/virtio_ring.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index e639584..286c30c 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -135,6 +135,13 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
 	unsigned head;
 	int i;
 
+	/*
+	 * We require lowmem mappings for the descriptors because
+	 * otherwise virt_to_phys will give us bogus addresses in the
+	 * virtqueue.
+	 */
+	gfp &= ~(__GFP_HIGHMEM | __GFP_HIGH);
+
 	desc = kmalloc((out + in) * sizeof(struct vring_desc), gfp);
 	if (!desc)
 		return -ENOMEM;
-- 
1.7.4.1

