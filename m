Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab1HNOxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 10:53:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38693 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab1HNOxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 10:53:16 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>, Amit Shah <amit.shah@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 1/3] virtio-console: Use virtio_config_val() for retrieving config
Date: Sun, 14 Aug 2011 17:52:31 +0300
Message-Id: <1313333553-23086-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies virtio-console to use virtio_config_val() instead
of a 'if(virtio_has_feature()) vdev->config->get()' construct to retrieve
optional values from the config space.

Cc: Amit Shah <amit.shah@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/char/virtio_console.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index fb68b12..ed99f3b 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1675,13 +1675,11 @@ static int __devinit virtcons_probe(struct virtio_device *vdev)
 
 	multiport = false;
 	portdev->config.max_nr_ports = 1;
-	if (virtio_has_feature(vdev, VIRTIO_CONSOLE_F_MULTIPORT)) {
+	if (virtio_config_val(vdev, VIRTIO_CONSOLE_F_MULTIPORT,
+			      offsetof(struct virtio_console_config,
+				       max_nr_ports),
+			      &portdev->config.max_nr_ports) == 0)
 		multiport = true;
-		vdev->config->get(vdev, offsetof(struct virtio_console_config,
-						 max_nr_ports),
-				  &portdev->config.max_nr_ports,
-				  sizeof(portdev->config.max_nr_ports));
-	}
 
 	err = init_vqs(portdev);
 	if (err < 0) {
-- 
1.7.6

