Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab0IESca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:32:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46186 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab0IESc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:32:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZooMD5SrZV/2Bsy10Zi0Kk0N180RQnRJVG7nFXIO/91Bu81PtdqCrqK4KdG9kt/Bb6
         rSKT/DmGQcyVAPGkhFX0WVdpHF04KFK7VdF5HQrDTCX4a5tH7nYZ1plmZMnqmWGRgWmM
         nLBPacLueK2ORq9avwIvaZeOh63NnqEIryars=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] char: tty_io: check return code of tty_register_device
Date: Sun,  5 Sep 2010 22:32:22 +0400
Message-Id: <1283711542-7164-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

Function tty_register_device may return ERR_PTR(...). Check for it.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Probably we need another resource deallocation in err.
 Compile tested.

 drivers/char/tty_io.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index d6c659f..e185db3 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3004,6 +3004,7 @@ int tty_register_driver(struct tty_driver *driver)
 	int i;
 	dev_t dev;
 	void **p = NULL;
+	struct device *d;
 
 	if (!(driver->flags & TTY_DRIVER_DEVPTS_MEM) && driver->num) {
 		p = kzalloc(driver->num * 2 * sizeof(void *), GFP_KERNEL);
@@ -3051,12 +3052,31 @@ int tty_register_driver(struct tty_driver *driver)
 	mutex_unlock(&tty_mutex);
 
 	if (!(driver->flags & TTY_DRIVER_DYNAMIC_DEV)) {
-		for (i = 0; i < driver->num; i++)
-		    tty_register_device(driver, i, NULL);
+		for (i = 0; i < driver->num; i++) {
+			d = tty_register_device(driver, i, NULL);
+			if (IS_ERR(d)) {
+				error = PTR_ERR(d);
+				goto err;
+			}
+		}
 	}
 	proc_tty_register_driver(driver);
 	driver->flags |= TTY_DRIVER_INSTALLED;
 	return 0;
+
+err:
+	for (i--; i >= 0; i--)
+		tty_unregister_device(driver, i);
+
+	mutex_lock(&tty_mutex);
+	list_del(&driver->tty_drivers);
+	mutex_unlock(&tty_mutex);
+
+	unregister_chrdev_region(dev, driver->num);
+	driver->ttys = NULL;
+	driver->termios = NULL;
+	kfree(p);
+	return error;
 }
 
 EXPORT_SYMBOL(tty_register_driver);
-- 
1.7.0.4

