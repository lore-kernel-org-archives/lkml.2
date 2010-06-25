Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab0FYKnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 06:43:31 -0400
Received: from md2.t-2.net ([84.255.209.81]:8757 "EHLO md2.t-2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885Ab0FYKn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 06:43:28 -0400
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
From: Samo Pogacnik <samo_pogacnik@t-2.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100622232108.26752ff8@lxorguk.ukuu.org.uk>
References: <1273918658.2341.17.camel@itpsd6lap>
	 <1275171436.2122.29.camel@itpsd6lap>
	 <20100529235402.296406d9@lxorguk.ukuu.org.uk>
	 <1275175983.2122.42.camel@itpsd6lap> <1276123020.16010.97.camel@itpsd6lap>
	 <20100611134455.3fa7d563@lxorguk.ukuu.org.uk>
	 <1276291932.2154.45.camel@itpsd6lap>
	 <20100621153858.444695c0@lxorguk.ukuu.org.uk>
	 <1277244410.2195.47.camel@itpsd6lap>
	 <20100622232108.26752ff8@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Fri, 25 Jun 2010 12:43:16 +0200
Message-Id: <1277462596.2143.101.camel@itpsd6lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Junkmail-Status: score=10/150, host=md2.t-2.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A0B0209.4C248847.03F4,ss=1,fgs=0,
	ip=192.168.1.20,
	so=2010-02-10 22:08:04,
	dmn=5.4.3/2007-10-18,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > in some logical manner. And the other would be to use ratelimit support
> > to switch between max and zero in write_room answer and remove other
> > retelimit response?
> 
> Yes - except that a driver isn't permitted to reduce the write room space
> by more than bytes written. That is if you offer 512 bytes you can't
> offer 0 until 512 bytes have been written - hence the design of the pseudo
> code I posted in the previous message.

Now flow control is provided in a way that each write ratelimit false
detection shrinks available space for its output lenth. On the other
hand write returns available space back to maximum on true ratelimit
detection result. Additionaly each next write_room returns at least one
character space under high load, if zero space is reached. 

Additionally a private ttyprintk_ratelimit function is provided to
suppress "missed callbacks" printks, because we do not really miss
anything.

regards, Samo
----
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
index 0000000..344f2d3
--- /dev/null
+++ b_linux/drivers/char/ttyprintk.c
@@ -0,0 +1,264 @@
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
+#include <linux/sched.h>
+#include <linux/ratelimit.h>
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
+ * Ratelimiting support to handle to much output to this device,
+ * because of explicit writes or because of unintentional loop
+ * setup (caught printks again sent to this device).
+ */
+static struct ratelimit_state ttyprintk_rs = {
+	.interval = DEFAULT_RATELIMIT_INTERVAL,
+	.burst = DEFAULT_RATELIMIT_BURST,
+};
+
+#define ttyprintk_printk(fmt, ...) \
+{ \
+	printk(KERN_INFO fmt, ##__VA_ARGS__); \
+}
+
+/*
+ * Our private ratelimit function, to suppress its printk warnings about
+ * missed callbacks, which are irrelevant in a flow control mechanism.
+ */
+static int ttyprintk_ratelimit(struct ratelimit_state *rs,
+				struct ttyprintk_port *tpkp)
+{
+	int ret;
+
+	/* exclusive call of ttyprintk_ratelimit within this tty */
+	mutex_lock(&tpkp->port_write_mutex);
+	/* clear ratelimit missed callbacks counter */
+	rs->missed = 0;
+	ret = __ratelimit(rs);
+	mutex_unlock(&tpkp->port_write_mutex);
+	return ret;
+}
+
+/*
+ * Our simple preformatting supports transparent output of (time-stamped)
+ * printk messages (also suitable for logging service):
+ * - any cr is replaced by nl
+ * - adds a ttyprintk source tag in front of each line
+ * - too long message is fragmeted, with '\'nl between fragments
+ */
+#define TTY_PRINTK_STR_SIZE 508
+static int tpk_space = TTY_PRINTK_STR_SIZE;
+static const char *tpk_tag = "[U] "; /* U for User */
+
+static int tpk_printk(const unsigned char *buf, int count)
+{
+	static char tmp[TTY_PRINTK_STR_SIZE + 4];
+	static int curr;
+	int i;
+
+	for (i = 0; i < count; i++) {
+		tmp[curr] = buf[i];
+		if (curr < TTY_PRINTK_STR_SIZE) {
+			switch (buf[i]) {
+			case '\r':
+				/* replace cr with nl */
+				tmp[curr + 0] = '\n';
+				tmp[curr + 1] = '\0';
+				ttyprintk_printk("%s%s", tpk_tag, tmp);
+				curr = 0;
+				if (buf[i + 1] == '\n')
+					i++;
+				break;
+			case '\n':
+				tmp[curr + 1] = '\0';
+				ttyprintk_printk("%s%s", tpk_tag, tmp);
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
+			ttyprintk_printk("%s%s", tpk_tag, tmp);
+			curr = 0;
+		}
+	}
+	if ((tpk_space == TTY_PRINTK_STR_SIZE) && (curr > 0)) {
+		/* non nl or cr terminated message - add nl */
+		tmp[curr + 0] = '\n';
+		tmp[curr + 1] = '\0';
+		ttyprintk_printk("%s%s", tpk_tag, tmp);
+		curr = 0;
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
+	if (ttyprintk_ratelimit(&ttyprintk_rs, tpkp))
+		tpk_space = TTY_PRINTK_STR_SIZE;
+	else {
+		if (tpk_space > count)
+			tpk_space -= count;
+		else
+			tpk_space = 0;
+	}
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
+	int ret = tpk_space;
+
+	/* allow char by char under max pressure */
+	if (tpk_space == 0)
+		tpk_space = 1;
+
+	return ret;
+}
+
+/*
+ * TTY operations ioctl function.
+ */
+static int tpk_ioctl(struct tty_struct *tty, struct file *file,
+			unsigned int cmd, unsigned long arg)
+{
+	struct ttyprintk_port *port;
+
+	port = tty->driver_data;
+
+	if (!port)
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


