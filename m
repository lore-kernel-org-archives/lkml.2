Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965190Ab2CEOE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:04:28 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34698 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402Ab2CENxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:14 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 03/68] TTY: let alloc_tty_driver deduce the owner automatically
Date: Mon,  5 Mar 2012 14:51:50 +0100
Message-Id: <1330955575-26641-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like the rest of the kernel, make a stub from alloc_tty_driver which
calls __alloc_tty_driver with proper owner. This will save us one more
assignment on the driver side.

Also this fixes some drivers which didn't set the owner. This allowed
user to remove the module from the system even though a tty from the
driver is still open.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_io.c       |    5 +++--
 include/linux/tty_driver.h |    5 ++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index f105ce5..bd95cea 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3049,7 +3049,7 @@ void tty_unregister_device(struct tty_driver *driver, unsigned index)
 }
 EXPORT_SYMBOL(tty_unregister_device);
 
-struct tty_driver *alloc_tty_driver(int lines)
+struct tty_driver *__alloc_tty_driver(int lines, struct module *owner)
 {
 	struct tty_driver *driver;
 
@@ -3058,11 +3058,12 @@ struct tty_driver *alloc_tty_driver(int lines)
 		kref_init(&driver->kref);
 		driver->magic = TTY_DRIVER_MAGIC;
 		driver->num = lines;
+		driver->owner = owner;
 		/* later we'll move allocation of tables here */
 	}
 	return driver;
 }
-EXPORT_SYMBOL(alloc_tty_driver);
+EXPORT_SYMBOL(__alloc_tty_driver);
 
 static void destruct_tty_driver(struct kref *kref)
 {
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 5cf6850..6e65493 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -234,6 +234,7 @@
  *	if provided (otherwise EINVAL will be returned).
  */
 
+#include <linux/export.h>
 #include <linux/fs.h>
 #include <linux/list.h>
 #include <linux/cdev.h>
@@ -324,7 +325,7 @@ struct tty_driver {
 
 extern struct list_head tty_drivers;
 
-extern struct tty_driver *alloc_tty_driver(int lines);
+extern struct tty_driver *__alloc_tty_driver(int lines, struct module *owner);
 extern void put_tty_driver(struct tty_driver *driver);
 extern void tty_set_operations(struct tty_driver *driver,
 			const struct tty_operations *op);
@@ -332,6 +333,8 @@ extern struct tty_driver *tty_find_polling_driver(char *name, int *line);
 
 extern void tty_driver_kref_put(struct tty_driver *driver);
 
+#define alloc_tty_driver(lines) __alloc_tty_driver(lines, THIS_MODULE)
+
 static inline struct tty_driver *tty_driver_kref_get(struct tty_driver *d)
 {
 	kref_get(&d->kref);
-- 
1.7.9.2


