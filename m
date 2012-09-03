Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab2ICNvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 09:51:07 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33961 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab2ICNvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 09:51:02 -0400
From: sjur.brandeland@stericsson.com
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        "Guzman Lugo, Fernadndo" <fernando.lugo@ti.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] virtio: Don't access device data after unregistration.
Date: Mon,  3 Sep 2012 15:50:42 +0200
Message-Id: <1346680242-5717-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Fix panic in virtio.c when CONFIG_DEBUG_SLAB is set.
Use device_del() and put_device() instead of
device_unregister(), and access device data before
calling put_device().


Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
cc: Guzman Lugo, Fernadndo <fernando.lugo@ti.com>
cc: Michael S. Tsirkin <mst@redhat.com>
cc: virtualization@lists.linux-foundation.org
cc: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/virtio/virtio.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index c3b3f7f..71eacd1 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -225,8 +225,9 @@ EXPORT_SYMBOL_GPL(register_virtio_device);
 
 void unregister_virtio_device(struct virtio_device *dev)
 {
-	device_unregister(&dev->dev);
+	device_del(&dev->dev);
 	ida_simple_remove(&virtio_index_ida, dev->index);
+	put_device(&dev->dev);
 }
 EXPORT_SYMBOL_GPL(unregister_virtio_device);
 
-- 
1.7.5.4

