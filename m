Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab0JVSVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:21:48 -0400
Received: from kroah.org ([198.145.64.141]:41892 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758629Ab0JVSVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:21:45 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Samo Pogacnik <samo_pogacnik@t-2.net>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/49] add ttyprintk driver
Date: Fri, 22 Oct 2010 11:20:57 -0700
Message-Id: <1287771688-14805-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samo Pogacnik <samo_pogacnik@t-2.net>

Ttyprintk is a pseudo TTY driver, which allows users to make printk
messages, via output to ttyprintk device. It is possible to store
"console" messages inline with kernel messages for better analyses of
the boot process, for example.

Signed-off-by: Samo Pogacnik <samo_pogacnik@t-2.net>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/devices.txt |    1 +
 drivers/char/Kconfig      |   15 +++
 drivers/char/Makefile     |    1 +
 drivers/char/ttyprintk.c  |  225 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 242 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/ttyprintk.c

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index d0d1df6..6a08fd7 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -239,6 +239,7 @@ Your cooperation is appreciated.
 		  0 = /dev/tty		Current TTY device
 		  1 = /dev/console	System console
 		  2 = /dev/ptmx		PTY master multiplex
+		  3 = /dev/ttyprintk	User messages via printk TTY device
 		 64 = /dev/cua0		Callout device for ttyS0
 		    ...
 		255 = /dev/cua191	Callout device for ttyS191
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 3d44ec7..43d3395 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -493,6 +493,21 @@ config LEGACY_PTY_COUNT
 	  When not in use, each legacy PTY occupies 12 bytes on 32-bit
 	  architectures and 24 bytes on 64-bit architectures.
 
+config TTY_PRINTK
+	bool "TTY driver to output user messages via printk"
+	depends on EMBEDDED
+	default n
+	---help---
+	  If you say Y here, the support for writing user messages (i.e.
+	  console messages) via printk is available.
+
+	  The feature is useful to inline user messages with kernel
+	  messages.
+	  In order to use this feature, you should output user messages
+	  to /dev/ttyprintk or redirect console to this TTY.
+
+	  If unsure, say N.
+
 config BRIQ_PANEL
 	tristate 'Total Impact briQ front panel driver'
 	depends on PPC_CHRP
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index dc96416..3a9c014 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -12,6 +12,7 @@ obj-y	 += mem.o random.o tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o tty_buffer.o t
 obj-y				+= tty_mutex.o
 obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
 obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
+obj-$(CONFIG_TTY_PRINTK)	+= ttyprintk.o
 obj-y				+= misc.o
 obj-$(CONFIG_VT)		+= vt_ioctl.o vc_screen.o selection.o keyboard.o
 obj-$(CONFIG_BFIN_JTAG_COMM)	+= bfin_jtag_comm.o
diff --git a/drivers/char/ttyprintk.c b/drivers/char/ttyprintk.c
new file mode 100644
index 0000000..c40c161
--- /dev/null
+++ b/drivers/char/ttyprintk.c
@@ -0,0 +1,225 @@
+/*
+ *  linux/drivers/char/ttyprintk.c
+ *
+ *  Copyright (C) 2010  Samo Pogacnik
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the smems of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ */
+
+/*
+ * This pseudo device allows user to make printk messages. It is possible
+ * to store "console" messages inline with kernel messages for better analyses
+ * of the boot process, for example.
+ */
+
+#include <linux/device.h>
+#include <linux/serial.h>
+#include <linux/tty.h>
+
+struct ttyprintk_port {
+	struct tty_port port;
+	struct mutex port_write_mutex;
+};
+
+static struct ttyprintk_port tpk_port;
+
+/*
+ * Our simple preformatting supports transparent output of (time-stamped)
+ * printk messages (also suitable for logging service):
+ * - any cr is replaced by nl
+ * - adds a ttyprintk source tag in front of each line
+ * - too long message is fragmeted, with '\'nl between fragments
+ * - TPK_STR_SIZE isn't really the write_room limiting factor, bcause
+ *   it is emptied on the fly during preformatting.
+ */
+#define TPK_STR_SIZE 508 /* should be bigger then max expected line length */
+#define TPK_MAX_ROOM 4096 /* we could assume 4K for instance */
+static const char *tpk_tag = "[U] "; /* U for User */
+static int tpk_curr;
+
+static int tpk_printk(const unsigned char *buf, int count)
+{
+	static char tmp[TPK_STR_SIZE + 4];
+	int i = tpk_curr;
+
+	if (buf == NULL) {
+		/* flush tmp[] */
+		if (tpk_curr > 0) {
+			/* non nl or cr terminated message - add nl */
+			tmp[tpk_curr + 0] = '\n';
+			tmp[tpk_curr + 1] = '\0';
+			printk(KERN_INFO "%s%s", tpk_tag, tmp);
+			tpk_curr = 0;
+		}
+		return i;
+	}
+
+	for (i = 0; i < count; i++) {
+		tmp[tpk_curr] = buf[i];
+		if (tpk_curr < TPK_STR_SIZE) {
+			switch (buf[i]) {
+			case '\r':
+				/* replace cr with nl */
+				tmp[tpk_curr + 0] = '\n';
+				tmp[tpk_curr + 1] = '\0';
+				printk(KERN_INFO "%s%s", tpk_tag, tmp);
+				tpk_curr = 0;
+				if (buf[i + 1] == '\n')
+					i++;
+				break;
+			case '\n':
+				tmp[tpk_curr + 1] = '\0';
+				printk(KERN_INFO "%s%s", tpk_tag, tmp);
+				tpk_curr = 0;
+				break;
+			default:
+				tpk_curr++;
+			}
+		} else {
+			/* end of tmp buffer reached: cut the message in two */
+			tmp[tpk_curr + 1] = '\\';
+			tmp[tpk_curr + 2] = '\n';
+			tmp[tpk_curr + 3] = '\0';
+			printk(KERN_INFO "%s%s", tpk_tag, tmp);
+			tpk_curr = 0;
+		}
+	}
+
+	return count;
+}
+
+/*
+ * TTY operations open function.
+ */
+static int tpk_open(struct tty_struct *tty, struct file *filp)
+{
+	tty->driver_data = &tpk_port;
+
+	return tty_port_open(&tpk_port.port, tty, filp);
+}
+
+/*
+ * TTY operations close function.
+ */
+static void tpk_close(struct tty_struct *tty, struct file *filp)
+{
+	struct ttyprintk_port *tpkp = tty->driver_data;
+
+	mutex_lock(&tpkp->port_write_mutex);
+	/* flush tpk_printk buffer */
+	tpk_printk(NULL, 0);
+	mutex_unlock(&tpkp->port_write_mutex);
+
+	tty_port_close(&tpkp->port, tty, filp);
+}
+
+/*
+ * TTY operations write function.
+ */
+static int tpk_write(struct tty_struct *tty,
+		const unsigned char *buf, int count)
+{
+	struct ttyprintk_port *tpkp = tty->driver_data;
+	int ret;
+
+
+	/* exclusive use of tpk_printk within this tty */
+	mutex_lock(&tpkp->port_write_mutex);
+	ret = tpk_printk(buf, count);
+	mutex_unlock(&tpkp->port_write_mutex);
+
+	return ret;
+}
+
+/*
+ * TTY operations write_room function.
+ */
+static int tpk_write_room(struct tty_struct *tty)
+{
+	return TPK_MAX_ROOM;
+}
+
+/*
+ * TTY operations ioctl function.
+ */
+static int tpk_ioctl(struct tty_struct *tty, struct file *file,
+			unsigned int cmd, unsigned long arg)
+{
+	struct ttyprintk_port *tpkp = tty->driver_data;
+
+	if (!tpkp)
+		return -EINVAL;
+
+	switch (cmd) {
+	/* Stop TIOCCONS */
+	case TIOCCONS:
+		return -EOPNOTSUPP;
+	default:
+		return -ENOIOCTLCMD;
+	}
+	return 0;
+}
+
+static const struct tty_operations ttyprintk_ops = {
+	.open = tpk_open,
+	.close = tpk_close,
+	.write = tpk_write,
+	.write_room = tpk_write_room,
+	.ioctl = tpk_ioctl,
+};
+
+struct tty_port_operations null_ops = { };
+
+static struct tty_driver *ttyprintk_driver;
+
+static int __init ttyprintk_init(void)
+{
+	int ret = -ENOMEM;
+	void *rp;
+
+	ttyprintk_driver = alloc_tty_driver(1);
+	if (!ttyprintk_driver)
+		return ret;
+
+	ttyprintk_driver->owner = THIS_MODULE;
+	ttyprintk_driver->driver_name = "ttyprintk";
+	ttyprintk_driver->name = "ttyprintk";
+	ttyprintk_driver->major = TTYAUX_MAJOR;
+	ttyprintk_driver->minor_start = 3;
+	ttyprintk_driver->num = 1;
+	ttyprintk_driver->type = TTY_DRIVER_TYPE_CONSOLE;
+	ttyprintk_driver->init_termios = tty_std_termios;
+	ttyprintk_driver->init_termios.c_oflag = OPOST | OCRNL | ONOCR | ONLRET;
+	ttyprintk_driver->flags = TTY_DRIVER_RESET_TERMIOS |
+		TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+	tty_set_operations(ttyprintk_driver, &ttyprintk_ops);
+
+	ret = tty_register_driver(ttyprintk_driver);
+	if (ret < 0) {
+		printk(KERN_ERR "Couldn't register ttyprintk driver\n");
+		goto error;
+	}
+
+	/* create our unnumbered device */
+	rp = device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 3), NULL,
+				ttyprintk_driver->name);
+	if (IS_ERR(rp)) {
+		printk(KERN_ERR "Couldn't create ttyprintk device\n");
+		ret = PTR_ERR(rp);
+		goto error;
+	}
+
+	tty_port_init(&tpk_port.port);
+	tpk_port.port.ops = &null_ops;
+	mutex_init(&tpk_port.port_write_mutex);
+
+	return 0;
+
+error:
+	put_tty_driver(ttyprintk_driver);
+	ttyprintk_driver = NULL;
+	return ret;
+}
+module_init(ttyprintk_init);
-- 
1.7.2

