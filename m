Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab2LMOFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:05:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44274 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309Ab2LMOEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:04:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 067/241] virtio: Don't access index after unregister.
Date: Thu, 13 Dec 2012 11:57:12 -0200
Message-Id: <1355407206-17100-68-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cornelia Huck <cornelia.huck@de.ibm.com>

commit 237242bddc99041e15a4ca51b8439657cadaff17 upstream.

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
Acked-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/virtio/virtio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index f355807..acc77a2 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -222,8 +222,10 @@ EXPORT_SYMBOL_GPL(register_virtio_device);
 
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
1.7.9.5

