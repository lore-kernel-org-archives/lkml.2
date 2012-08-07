Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab2HGT7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:59:46 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:36545 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab2HGT7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:59:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 20/41] TTY: add support for unnumbered device nodes
Date: Tue,  7 Aug 2012 21:47:45 +0200
Message-Id: <1344368886-24033-21-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows drivers like ttyprintk to avoid hacks to create an
unnumbered node in /dev. It used to set TTY_DRIVER_DYNAMIC_DEV in
flags and call device_create on its own. That is incorrect, because
TTY_DRIVER_DYNAMIC_DEV may be set only if tty_register_device is
called explicitly.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/char/ttyprintk.c   |   17 ++++-------------
 drivers/tty/tty_io.c       |    7 +++++--
 include/linux/tty_driver.h |    6 ++++++
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/char/ttyprintk.c b/drivers/char/ttyprintk.c
index be1c3fb..9e6272f 100644
--- a/drivers/char/ttyprintk.c
+++ b/drivers/char/ttyprintk.c
@@ -178,13 +178,15 @@ static struct tty_driver *ttyprintk_driver;
 static int __init ttyprintk_init(void)
 {
 	int ret = -ENOMEM;
-	void *rp;
 
 	tty_port_init(&tpk_port.port);
 	tpk_port.port.ops = &null_ops;
 	mutex_init(&tpk_port.port_write_mutex);
 
-	ttyprintk_driver = alloc_tty_driver(1);
+	ttyprintk_driver = tty_alloc_driver(1,
+			TTY_DRIVER_RESET_TERMIOS |
+			TTY_DRIVER_REAL_RAW |
+			TTY_DRIVER_UNNUMBERED_NODE);
 	if (!ttyprintk_driver)
 		return ret;
 
@@ -195,8 +197,6 @@ static int __init ttyprintk_init(void)
 	ttyprintk_driver->type = TTY_DRIVER_TYPE_CONSOLE;
 	ttyprintk_driver->init_termios = tty_std_termios;
 	ttyprintk_driver->init_termios.c_oflag = OPOST | OCRNL | ONOCR | ONLRET;
-	ttyprintk_driver->flags = TTY_DRIVER_RESET_TERMIOS |
-		TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
 	tty_set_operations(ttyprintk_driver, &ttyprintk_ops);
 
 	ret = tty_register_driver(ttyprintk_driver);
@@ -205,15 +205,6 @@ static int __init ttyprintk_init(void)
 		goto error;
 	}
 
-	/* create our unnumbered device */
-	rp = device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 3), NULL,
-				ttyprintk_driver->name);
-	if (IS_ERR(rp)) {
-		printk(KERN_ERR "Couldn't create ttyprintk device\n");
-		ret = PTR_ERR(rp);
-		goto error;
-	}
-
 	return 0;
 
 error:
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 8181cb5..135e0e4 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1213,7 +1213,10 @@ static void pty_line_name(struct tty_driver *driver, int index, char *p)
  */
 static void tty_line_name(struct tty_driver *driver, int index, char *p)
 {
-	sprintf(p, "%s%d", driver->name, index + driver->name_base);
+	if (driver->flags & TTY_DRIVER_UNNUMBERED_NODE)
+		strcpy(p, driver->name);
+	else
+		sprintf(p, "%s%d", driver->name, index + driver->name_base);
 }
 
 /**
@@ -3061,7 +3064,7 @@ struct tty_driver *__tty_alloc_driver(unsigned int lines, struct module *owner,
 	struct tty_driver *driver;
 	int err;
 
-	if (!lines)
+	if (!lines || (flags & TTY_DRIVER_UNNUMBERED_NODE && lines > 1))
 		return ERR_PTR(-EINVAL);
 
 	driver = kzalloc(sizeof(struct tty_driver), GFP_KERNEL);
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index bea95ca..ca8eb54 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -394,6 +394,11 @@ static inline struct tty_driver *tty_driver_kref_get(struct tty_driver *d)
  * TTY_DRIVER_EXCESSIVE_LINES -- do not allocate structures which are
  *	needed per line for this driver as it would waste memory.
  *	Applicable only to pty.
+ *
+ * TTY_DRIVER_UNNUMBERED_NODE -- do not create numbered /dev nodes. In
+ *	other words create /dev/ttyprintk and not /dev/ttyprintk0.
+ *	Applicable only when a driver for a single tty device is
+ *	being allocated.
  */
 #define TTY_DRIVER_INSTALLED		0x0001
 #define TTY_DRIVER_RESET_TERMIOS	0x0002
@@ -402,6 +407,7 @@ static inline struct tty_driver *tty_driver_kref_get(struct tty_driver *d)
 #define TTY_DRIVER_DEVPTS_MEM		0x0010
 #define TTY_DRIVER_HARDWARE_BREAK	0x0020
 #define TTY_DRIVER_EXCESSIVE_LINES	0x0040
+#define TTY_DRIVER_UNNUMBERED_NODE	0x0080
 
 /* tty driver types */
 #define TTY_DRIVER_TYPE_SYSTEM		0x0001
-- 
1.7.10.4


