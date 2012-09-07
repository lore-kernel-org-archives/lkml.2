Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab2IGG6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:58:06 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38062 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab2IGG6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:58:01 -0400
From: sjur.brandeland@stericsson.com
To: "Michael S . Tsirkin" <mst@redhat.com>
Cc: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        "Guzman Lugo, Fernadndo" <fernando.lugo@ti.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2] virtio: Don't access device data after unregistration.
Date: Fri,  7 Sep 2012 08:57:45 +0200
Message-Id: <1347001066-13521-2-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347001066-13521-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1347001066-13521-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Fix panic in virtio.c when CONFIG_DEBUG_SLAB is set.
device_unregister() drops reference to device so put_device()
could invoke release callback. In this case the release
callback will free the device. Make sure we don't access
device after unregister by fetching the device index
before calling unregister.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
cc: Guzman Lugo, Fernadndo <fernando.lugo@ti.com>
cc: Michael S. Tsirkin <mst@redhat.com>
cc: Rusty Russell <rusty@rustcorp.com.au>
cc: Ohad Ben-Cohen <ohad@wizery.com>
cc: virtualization@lists.linux-foundation.org
cc: linux-kernel@vger.kernel.org
---
 drivers/virtio/virtio.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index c3b3f7f..faee112 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -225,8 +225,15 @@ EXPORT_SYMBOL_GPL(register_virtio_device);
 
 void unregister_virtio_device(struct virtio_device *dev)
 {
+	/*
+	 * device_unregister() drops reference to device so put_device could
+	 * invoke release callback. In case that callback will free the device,
+	 * make sure we don't access device after this call.
+	 */
+
+	int index = dev->index;
 	device_unregister(&dev->dev);
-	ida_simple_remove(&virtio_index_ida, dev->index);
+	ida_simple_remove(&virtio_index_ida, index);
 }
 EXPORT_SYMBOL_GPL(unregister_virtio_device);
 
-- 
1.7.5.4

