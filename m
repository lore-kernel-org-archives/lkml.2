Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab0EOKRp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 06:17:45 -0400
Received: from t21.t-2.net ([84.255.209.100]:40052 "EHLO t21.t-2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab0EOKRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 06:17:43 -0400
Subject: [PATCH] detour TTY driver
From: Samo Pogacnik <samo_pogacnik@t-2.net>
To: linux-embedded <linux-embedded@vger.kernel.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 15 May 2010 12:17:38 +0200
Message-Id: <1273918658.2341.17.camel@itpsd6lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SGG-UMAMSID: 20100515101740Z31785t21.t-2.net 1ODERA-0008Gf-ME
X-SGG-RESULT: 20100515101740Z31785t21.t-2.net C1:OK E1:OK MX1:OK BL:OK SPF:off  CT:Unknown CM: SIP:84.255.254.67 SMF:samo_pogacnik@t-2.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the initial suggestion for a simple detour TTY driver, which
provides the ability to write user messages through printk. This allows
user output to be inlined with kernel output. Together with printk
time-stamping enabled, a detailed boot sequence analyses is possible.
Additionally, console logs could have been stored through the same
mechanism as kernel messages and does not require the system logger to
be started very/too soon.

regards, Samo

---
Signed-off-by: Samo Pogacnik <samo_pogacnik@t-2.net>
diff --git a_linux-2.6.33.3/Documentation/devices.txt b_linux-2.6.33.3/Documentation/devices.txt
index 53d64d3..f889097 100644
--- a_linux-2.6.33.3/Documentation/devices.txt
+++ b_linux-2.6.33.3/Documentation/devices.txt
@@ -239,6 +239,7 @@ Your cooperation is appreciated.
 		  0 = /dev/tty		Current TTY device
 		  1 = /dev/console	System console
 		  2 = /dev/ptmx		PTY master multiplex
+		  3 = /dev/detour	Detour via printk TTY device
 		 64 = /dev/cua0		Callout device for ttyS0
 		    ...
 		255 = /dev/cua191	Callout device for ttyS191
diff --git a_linux-2.6.33.3/drivers/char/Kconfig b_linux-2.6.33.3/drivers/char/Kconfig
index e023682..4d21e2d 100644
--- a_linux-2.6.33.3/drivers/char/Kconfig
+++ b_linux-2.6.33.3/drivers/char/Kconfig
@@ -485,6 +485,20 @@ config LEGACY_PTY_COUNT
 	  When not in use, each legacy PTY occupies 12 bytes on 32-bit
 	  architectures and 24 bytes on 64-bit architectures.
 
+config DETOUR_TTY
+	bool "TTY driver to detour user output via printk"
+	default n
+	---help---
+	  If you say Y here, the support for writing user messages (i.e.
+	  console messages) via printk is available.
+
+	  The feature is useful to inline user messages with kernel
+	  messages.
+	  In order to use this feature, you should output user messages
+	  to /dev/detour.
+
+	  If unsure, say N.
+
 config BRIQ_PANEL
 	tristate 'Total Impact briQ front panel driver'
 	depends on PPC_CHRP
diff --git a_linux-2.6.33.3/drivers/char/Makefile b_linux-2.6.33.3/drivers/char/Makefile
index f957edf..b84db55 100644
--- a_linux-2.6.33.3/drivers/char/Makefile
+++ b_linux-2.6.33.3/drivers/char/Makefile
@@ -11,6 +11,7 @@ obj-y	 += mem.o random.o tty_io.o n_tty.o tty_ioctl.o tty_ldisc.o tty_buffer.o t
 
 obj-$(CONFIG_LEGACY_PTYS)	+= pty.o
 obj-$(CONFIG_UNIX98_PTYS)	+= pty.o
+obj-$(CONFIG_DETOUR_TTY)	+= dty.o
 obj-y				+= misc.o
 obj-$(CONFIG_VT)		+= vt_ioctl.o vc_screen.o selection.o keyboard.o
 obj-$(CONFIG_BFIN_JTAG_COMM)	+= bfin_jtag_comm.o
diff --git a_linux-2.6.33.3/drivers/char/dty.c b_linux-2.6.33.3/drivers/char/dty.c
new file mode 100644
index 0000000..3ffe248
--- /dev/null
+++ b_linux-2.6.33.3/drivers/char/dty.c
@@ -0,0 +1,137 @@
+/*
+ *  linux/drivers/char/detour.c
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
+#include <linux/tty.h>
+
+static struct tty_driver *dty_driver;
+
+static const char *detour_tag = "[D] ";
+#define DETOUR_STR_SIZE 508
+
+/*
+ *	Our simple preformatting:
+ *	- every cr is replaced by '^'nl combination
+ *	- every non cr or nl ended write is padded with '\'nl combination
+ *	- adds a detour source tag in front of each line
+ *
+ * 	This is useful for logging purposes (kind of a logging ldisc?).
+ */
+static void detour_printk(const unsigned char *buf, int count)
+{
+	static char tmp[DETOUR_STR_SIZE + 4];
+	static int curr;
+	int i;
+
+	for (i = 0; i < count; i++) {
+		tmp[curr] = buf[i];
+		if (curr < DETOUR_STR_SIZE) {
+			switch (buf[i]) {
+			case '\r':
+				tmp[curr] = '^';
+				tmp[curr + 1] = '\n';
+				tmp[curr + 2] = '\0';
+				printk(KERN_INFO "%s%s", detour_tag, tmp);
+				curr = 0;
+				if (buf[i + 1] == '\n')
+					i++;
+				break;
+			case '\n':
+				tmp[curr + 1] = '\0';
+				printk(KERN_INFO "%s%s", detour_tag, tmp);
+				curr = 0;
+				break;
+			default:
+				curr++;
+			}
+		} else {
+			/* end of tmp buffer reached: cut the message in two */
+			tmp[curr + 1] = '\\';
+			tmp[curr + 2] = '\n';
+			tmp[curr + 3] = '\0';
+			printk(KERN_INFO "%s%s", detour_tag, tmp);
+			curr = 0;
+		}
+	}
+	if (curr > 0) {
+		/* non nl or cr terminated message */
+		tmp[curr + 0] = '\\';
+		tmp[curr + 1] = '\n';
+		tmp[curr + 2] = '\0';
+		printk(KERN_INFO "%s%s", detour_tag, tmp);
+		curr = 0;
+	}
+}
+
+/*
+ *	Dummy tty ops open for succesfull terminal device open.
+ */
+static int dty_open(struct tty_struct *tty, struct file *filp)
+{
+	return 0;
+}
+
+/*
+ *	File ops (not tty ops) write avoids ldisc inserting additional CRs.
+ *	We simply throw this to our preformatter, which calls printk.
+ */
+static ssize_t detour_write(struct file *file, const char __user *buf,
+	size_t count, loff_t *ppos)
+{
+	detour_printk(buf, count);
+	return count;
+}
+
+static const struct tty_operations dty_ops = {
+	.open = dty_open,
+};
+
+static struct file_operations detour_fops;
+
+static int __init dty_init(void)
+{
+	dty_driver = alloc_tty_driver(1);
+	if (!dty_driver)
+		panic("Couldn't allocate pty driver");
+
+	dty_driver->owner = THIS_MODULE;
+	dty_driver->driver_name = "dty";
+	dty_driver->name = "detour";
+	dty_driver->major = TTYAUX_MAJOR;
+	dty_driver->minor_start = 3;
+	dty_driver->num = 1;
+	dty_driver->type = TTY_DRIVER_TYPE_CONSOLE;
+	dty_driver->init_termios = tty_std_termios;
+	dty_driver->flags = TTY_DRIVER_RESET_TERMIOS | TTY_DRIVER_REAL_RAW |
+		TTY_DRIVER_DYNAMIC_DEV;
+	tty_set_operations(dty_driver, &dty_ops);
+
+	if (tty_register_driver(dty_driver))
+		panic("Couldn't register dty driver");
+
+	/* register our fops write function */
+	tty_default_fops(&detour_fops);
+	detour_fops.write = detour_write;
+
+	cdev_init(&dty_driver->cdev, &detour_fops);
+
+	/* create our unnumbered device */
+	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 3), NULL,
+		dty_driver->name);
+
+	return 0;
+}
+module_init(dty_init);
 

