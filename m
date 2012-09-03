Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab2ICNwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 09:52:07 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65116 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117Ab2ICNvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 09:51:54 -0400
From: sjur.brandeland@stericsson.com
To: Amit Shah <amit.shah@redhat.com>
Cc: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [RFC 2/2] virtio_console: Add feature to disable console port
Date: Mon,  3 Sep 2012 15:51:17 +0200
Message-Id: <1346680277-5887-2-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346680277-5887-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1346680277-5887-1-git-send-email-sjur.brandeland@stericsson.com>
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
cc: virtualization@lists.linux-foundation.org
cc: Ohad Ben-Cohen <ohad@wizery.com>
cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/char/virtio_console.c  |    5 ++++-
 include/linux/virtio_console.h |    1 +
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 6bfbd09..81546e9 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1246,7 +1246,9 @@ static int add_port(struct ports_device *portdev, u32 id)
 	/*
 	 * If we're not using multiport support, this has to be a console port
 	 */
-	if (!use_multiport(port->portdev)) {
+	if (virtio_has_feature(port->portdev->vdev, VIRTIO_CONSOLE_F_NO_HVC))
+		port->host_connected = true;
+	else if (!use_multiport(port->portdev)) {
 		err = init_port_console(port);
 		if (err)
 			goto free_inbufs;
@@ -1882,6 +1884,7 @@ static unsigned int features[] = {
 	VIRTIO_CONSOLE_F_SIZE,
 	VIRTIO_CONSOLE_F_MULTIPORT,
 	VIRTIO_CONSOLE_F_DMA_MEM,
+	VIRTIO_CONSOLE_F_NO_HVC,
 };
 
 #ifdef CONFIG_PM
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
1.7.5.4

