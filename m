Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2L1T0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:26:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55652 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932430Ab2L1TTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:42 -0500
Message-Id: <20121228190337.671243871@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 037/173] virtio: force vring descriptors to be allocated from lowmem
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit b92b1b89a33c172c075edccf6afb0edc41d851fd upstream.

Virtio devices may attempt to add descriptors to a virtqueue from atomic
context using GFP_ATOMIC allocation. This is problematic because such
allocations can fall outside of the lowmem mapping, causing virt_to_phys
to report bogus physical addresses which are subsequently passed to
userspace via the buffers for the virtual device.

This patch masks out __GFP_HIGH and __GFP_HIGHMEM from the requested
flags when allocating descriptors for a virtqueue. If an atomic
allocation is requested and later fails, we will return -ENOSPC which
will be handled by the driver.

Cc: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/virtio/virtio_ring.c |    7 +++++++
 1 file changed, 7 insertions(+)

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


