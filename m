Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231Ab3AIVmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:42:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:41863 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933142Ab3AIUiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 19/80] virtio: force vring descriptors to be allocated from lowmem
Date: Wed,  9 Jan 2013 12:35:11 -0800
Message-Id: <20130109201502.845189749@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/virtio/virtio_ring.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -132,6 +132,13 @@ static int vring_add_indirect(struct vri
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


