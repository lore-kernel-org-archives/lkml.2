Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab2KHKny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 05:43:54 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:57720 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2KHKnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 05:43:53 -0500
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] virtio: Don't access index after unregister.
Date: Thu,  8 Nov 2012 11:43:47 +0100
Message-Id: <1352371427-32363-1-git-send-email-cornelia.huck@de.ibm.com>
X-Mailer: git-send-email 1.7.12.4
x-cbid: 12110810-4966-0000-0000-00000406F9A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Virtio wants to release used indices after the corresponding
virtio device has been unregistered. However, virtio does not
hold an extra reference, giving up its last reference with
device_unregister(), making accessing dev->index afterwards
invalid.

I actually saw problems when testing my (not-yet-merged)
virtio-ccw code:

- device_add virtio-net,id=xxx
-> creates device virtio<n> with n>0

- device_del xxx
-> deletes virtio<n>, but calls ida_simple_remove with an
   index of 0

- device_add virtio-net,id=xxx
-> tries to add virtio0, which is still in use...

So let's save the index we want to release before calling
device_unregister().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 drivers/virtio/virtio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 1e8659c..809b0de 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -225,8 +225,10 @@ EXPORT_SYMBOL_GPL(register_virtio_device);
 
 void unregister_virtio_device(struct virtio_device *dev)
 {
+	int index = dev->index; /* save for after device release */
+
 	device_unregister(&dev->dev);
-	ida_simple_remove(&virtio_index_ida, dev->index);
+	ida_simple_remove(&virtio_index_ida, index);
 }
 EXPORT_SYMBOL_GPL(unregister_virtio_device);
 
-- 
1.7.12.4

