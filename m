Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab0HXU6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 16:58:07 -0400
Received: from smtp-good-out-2.t-2.net ([84.255.208.44]:47466 "EHLO
	smtp-good-out-2.t-2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab0HXU6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 16:58:05 -0400
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
From: Samo Pogacnik <samo_pogacnik@t-2.net>
To: linux kernel <linux-kernel@vger.kernel.org>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20100625120329.1303aa61@lxorguk.ukuu.org.uk>
References: <1273918658.2341.17.camel@itpsd6lap>
	 <1275171436.2122.29.camel@itpsd6lap>
	 <20100529235402.296406d9@lxorguk.ukuu.org.uk>
	 <1275175983.2122.42.camel@itpsd6lap> <1276123020.16010.97.camel@itpsd6lap>
	 <20100611134455.3fa7d563@lxorguk.ukuu.org.uk>
	 <1276291932.2154.45.camel@itpsd6lap>
	 <20100621153858.444695c0@lxorguk.ukuu.org.uk>
	 <1277244410.2195.47.camel@itpsd6lap>
	 <20100622232108.26752ff8@lxorguk.ukuu.org.uk>
	 <1277462596.2143.101.camel@itpsd6lap>
	 <20100625120329.1303aa61@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Tue, 24 Aug 2010 22:57:50 +0200
Message-Id: <1282683470.8020.66.camel@itpsd6lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.06.2010 (Fri) at 12:03 +0100 Alan Cox wrote: 
> With my devices.txt owner hat on I'll allocate the minor as you suggest
> (and double check this causes no problems), with my tty hat on can you
> send it to GregKH for merging into the tree.

Hi,

I hope that this TTY driver is ok for merging. It is very basic -
removed all flow control and rate limiting. Patch has been generated
against 2.6.34 kernel version.

Ttyprintk is a pseudo TTY driver, which allows users to make printk messages,
via output to ttyprintk device. It is possible to store "console" messages
inline with kernel messages for better analyses of the boot process, for
example.

regards, Samo
---
Signed-off-by: Samo Pogacnik <samo_pogacnik@t-2.net>
diff --git a_linux/Documentation/devices.txt b_linux/Documentation/devices.txt
index 53d64d3..71aef33 100644
--- a_linux/Documentation/devices.txt
+++ b_linux/Documentation/devices.txt
@@ -239,6 +239,7 @@ Your cooperation is appreciated.
 		  0 = /dev/tty		Current TTY device
 		  1 = /dev/console	System console
 		  2 = /dev/ptmx		PTY master multiplex
+		  3 = /dev/ttyprintk	User messages via printk TTY device
 		 64 = /dev/cua0		Callout device for ttyS0
 		    ...
 		255 = /dev/cua191	Callout device for ttyS191
diff --git a_linux/drivers/char/Kconfig b_linux/drivers/char/Kconfig
index 3141dd3..5c38a06 100644
--- a_linux/drivers/char/Kconfig
+++ b_linux/drivers/char/Kconfig
@@ -485,6 +485,20 @@ config LEGACY_PTY_COUNT
 	  When not in use, each legacy PTY occupies 12 bytes on 32-bit
 	  architectures and 24 bytes on 64-bit architectures.
 
+config TTY_PRINTK
+	bool "TTY driver to output user messages via printk"
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
diff --git a_linux/drivers/char/Makefile b_linux/drivers/char/Makefile
index f957edf..ed60f45 100644
--- a_linux/drivers/char/Makefile
+++ b_linux/drivers/char/Makefile
@@ -11,6 +11,7 @@ obj-y	 += mem.o random.o tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o tty_buffer.o t
 
 obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
 obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
+obj-$(CONFIG_TTY_PRINTK)	+= ttyprintk.o
 obj-y				+= misc.o
 obj-$(CONFIG_VT)		+= vt_ioctl.o vc_screen.o selection.o keyboard.o
 obj-$(CONFIG_BFIN_JTAG_COMM)	+= bfin_jtag_comm.o
diff --git a_linux/drivers/char/ttyprintk.c b_linux/drivers/char/ttyprintk.c
new file mode 100644
index 0000000..c40c161
--- /dev/null
+++ b_linux/drivers/char/ttyprintk.c
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


