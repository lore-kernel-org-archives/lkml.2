Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026Ab2IGG6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:58:33 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42739 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab2IGG6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:58:03 -0400
From: sjur.brandeland@stericsson.com
To: "Michael S . Tsirkin" <mst@redhat.com>
Cc: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Amit Shah <amit.shah@redhat.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [RFCv2 2/2] virtio_console: Add feature to disable console port
Date: Fri,  7 Sep 2012 08:57:46 +0200
Message-Id: <1347001066-13521-3-git-send-email-sjur.brandeland@stericsson.com>
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

Add the feature VIRTIO_CONSOLE_F_NO_HVC. With this bit set
only port-devices are created. The console port and
port control virtio-queues are not created.

The console port is not suited for communicating
to a remote processor because of it's blocking behavior.
But the port-device supports efficient non-blocking IO
to a remote processor.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
cc: Rusty Russell <rusty@rustcorp.com.au>
cc: Michael S. Tsirkin <mst@redhat.com>
cc: Amit Shah <amit.shah@redhat.com>
cc: Ohad Ben-Cohen <ohad@wizery.com>
cc: Linus Walleij <linus.walleij@linaro.org>
cc: virtualization@lists.linux-foundation.org
cc: linux-kernel@vger.kernel.org
---
 drivers/char/virtio_console.c  |    6 +++++-
 include/linux/virtio_console.h |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 469c05f..7408c00 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1244,10 +1244,13 @@ static int add_port(struct ports_device *portdev, u32 id)
 		goto free_device;
 	}
 
+	/* Don't initialize the port_console if F_NO_HVC is set*/
+	if (virtio_has_feature(port->portdev->vdev, VIRTIO_CONSOLE_F_NO_HVC))
+		port->host_connected = true;
 	/*
 	 * If we're not using multiport support, this has to be a console port
 	 */
-	if (!use_multiport(port->portdev)) {
+	else if (!use_multiport(port->portdev)) {
 		err = init_port_console(port);
 		if (err)
 			goto free_inbufs;
@@ -1896,6 +1899,7 @@ static unsigned int features[] = {
 #if VIRTIO_CONSOLE_HAS_DMA
 	VIRTIO_CONSOLE_F_DMA_MEM,
 #endif
+	VIRTIO_CONSOLE_F_NO_HVC,
 
 };
 
diff --git a/include/linux/virtio_console.h b/include/linux/virtio_console.h
index b27f7fa..a7c8974 100644
--- a/include/linux/virtio_console.h
+++ b/include/linux/virtio_console.h
@@ -39,6 +39,7 @@
 #define VIRTIO_CONSOLE_F_SIZE	0	/* Does host provide console size? */
 #define VIRTIO_CONSOLE_F_MULTIPORT 1	/* Does host provide multiple ports? */
 #define VIRTIO_CONSOLE_F_DMA_MEM 2	/* Use DMA memory in vrings */
+#define VIRTIO_CONSOLE_F_NO_HVC 3	/* Disable use of HVC */
 
 #define VIRTIO_CONSOLE_BAD_ID		(~(u32)0)
 
-- 
1.7.9.5

