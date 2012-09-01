Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab2IATty (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 15:49:54 -0400
Received: from mail.ispras.ru ([83.149.199.43]:45229 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611Ab2IATtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 15:49:53 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Amit Shah <amit.shah@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] virtio: console: fix error handling in init() function
Date: Sat,  1 Sep 2012 23:49:37 +0400
Message-Id: <1346528977-23066-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If register_virtio_driver() fails, virtio-ports class is not destroyed.
The patch adds error handling of register_virtio_driver().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/char/virtio_console.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index cdf2f54..060a672 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1941,7 +1941,17 @@ static int __init init(void)
 	INIT_LIST_HEAD(&pdrvdata.consoles);
 	INIT_LIST_HEAD(&pdrvdata.portdevs);
 
-	return register_virtio_driver(&virtio_console);
+	err = register_virtio_driver(&virtio_console);
+	if (err < 0) {
+		pr_err("Error %d registering virtio driver\n", err);
+		goto free;
+	}
+	return 0;
+free:
+	if (pdrvdata.debugfs_dir)
+		debugfs_remove_recursive(pdrvdata.debugfs_dir);
+	class_destroy(pdrvdata.class);
+	return err;
 }
 
 static void __exit fini(void)
-- 
1.7.9.5

