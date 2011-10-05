Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab1JEFjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 01:39:44 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:51412 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860Ab1JEFjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 01:39:43 -0400
From: Krishna Kumar <krkumar2@in.ibm.com>
To: rusty@rustcorp.com.au, mst@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        virtualization@lists.linux-foundation.org
Date: Wed, 05 Oct 2011 11:08:59 +0530
Message-Id: <20111005053859.5825.1089.sendpatchset@krkumar2.in.ibm.com>
Subject: [RFC] [PATCH] virtio: Dont add "config" to list for !per_vq_vector
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the MSI but non-per_vq_vector case, the config/change vq
also gets added to the list of vqs that need to process the
MSI interrupt. This is not needed as config has it's own
handler (vp_config_changed). In any case, vring_interrupt()
finds nothing needs to be done on this vq.

I tested this patch by testing the "Fallback:" and "Finally
fall back" cases in vp_find_vqs(). Please review.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
---
 drivers/virtio/virtio_pci.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -ruNp org/drivers/virtio/virtio_pci.c new/drivers/virtio/virtio_pci.c
--- org/drivers/virtio/virtio_pci.c	2011-10-03 09:10:11.000000000 +0530
+++ new/drivers/virtio/virtio_pci.c	2011-10-04 19:16:34.000000000 +0530
@@ -415,9 +415,13 @@ static struct virtqueue *setup_vq(struct
 		}
 	}
 
-	spin_lock_irqsave(&vp_dev->lock, flags);
-	list_add(&info->node, &vp_dev->virtqueues);
-	spin_unlock_irqrestore(&vp_dev->lock, flags);
+	if (callback) {
+		spin_lock_irqsave(&vp_dev->lock, flags);
+		list_add(&info->node, &vp_dev->virtqueues);
+		spin_unlock_irqrestore(&vp_dev->lock, flags);
+	} else {
+		INIT_LIST_HEAD(&info->node);
+	}
 
 	return vq;

