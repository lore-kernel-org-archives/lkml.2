Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab0FIWhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:37:09 -0400
Received: from t23.t-2.net ([84.255.209.102]:41541 "EHLO t23.t-2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756513Ab0FIWhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:37:06 -0400
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
From: Samo Pogacnik <samo_pogacnik@t-2.net>
To: linux-embedded <linux-embedded@vger.kernel.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1275175983.2122.42.camel@itpsd6lap>
References: <1273918658.2341.17.camel@itpsd6lap>
	 <1275171436.2122.29.camel@itpsd6lap>
	 <20100529235402.296406d9@lxorguk.ukuu.org.uk>
	 <1275175983.2122.42.camel@itpsd6lap>
Content-Type: text/plain
Date: Thu, 10 Jun 2010 00:37:00 +0200
Message-Id: <1276123020.16010.97.camel@itpsd6lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SGG-UMAMSID: 20100609223702Z28841t23.t-2.net 1OMTtO-0007VB-Hq
X-SGG-RESULT: 20100609223702Z28841t23.t-2.net C1:OK E1:OK MX1:OK BL:OK SPF:off  CT:Unknown CM: SIP:84.255.254.67 SMF:samo_pogacnik@t-2.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is another version of former detour TTY driver, trying to follow
Alan's suggestions:
- renamed from detour to ttyprintk
- removed possibility for initial internal redirection of console to
this tty
- providing hopefully more proper open/close tty operations
- fixed initial termios settings
- added primitive write_room operation
- added ratelimting support (recursion check) and an ioctl trap to catch
ratelimiting being activated. i'd appreciate a suggestion on this ioctl
command naming/value and on location of its definition?
- additional error checking

I also have a question about the tioccons() function from the tty_io.c.
Should this function also check, if the redirection tty has been opened
for writing, since there are going to be implicit writes to this tty for
each console message? This would prevent users without write permissions
to successfully perform TIOCCONS ioctl. This would also prevent writing
capable users to successfully perform TIOCCONS with read-only opened
tty, but failing to write console messages to the redirection tty
afterwards. This seems to happen because the mode of opened tty at the
time of issuing TIOCCONS ioctl is remembered.

Alan, could you please give the patch bellow another look?

thanks, Samo

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
index 0000000..5e569e4
--- /dev/null
+++ b_linux/drivers/char/ttyprintk.c
@@ -0,0 +1,305 @@
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
+/*
+ * Ratelimiting support to handle to much output to this device,
+ * because of explicit writes or because of unintentional recursive
+ * setup (caught printks again sent to this device).
+ */
+static struct ratelimit_state ttyprintk_rs = {
+	.interval = DEFAULT_RATELIMIT_INTERVAL,
+	.burst = DEFAULT_RATELIMIT_BURST,
+};
+
+/*
+ * Ratelimiting action and notification support
+ */
+static DECLARE_WAIT_QUEUE_HEAD(ttyprintk_ratelimit_wq);
+static int ttyprintk_ratelimit_event;
+
+#define ttyprintk_ratelimited(fmt, ...) \
+{ \
+	if (__ratelimit(&ttyprintk_rs)) { \
+		ttyprintk_ratelimit_event = 0; \
+		printk(KERN_INFO fmt, ##__VA_ARGS__); \
+	} else { \
+		ttyprintk_ratelimit_event = 1; \
+		wake_up_all(&ttyprintk_ratelimit_wq); \
+	} \
+}
+
+/*
+ * Our simple preformatting supports transparent output of (time-stamped)
+ * printk messages (also suitable for logging service):
+ * - any cr is replaced by nl
+ * - adds a ttyprintk source tag in front of each line
+ * - too long message is fragmeted, with '\'nl between fragments
+ */
+static const char *tpk_tag = "[U] "; /* U for User */
+#define TTY_PRINTK_STR_SIZE 508
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
+				ttyprintk_ratelimited("%s%s", tpk_tag, tmp);
+				curr = 0;
+				if (buf[i + 1] == '\n')
+					i++;
+				break;
+			case '\n':
+				tmp[curr + 1] = '\0';
+				ttyprintk_ratelimited("%s%s", tpk_tag, tmp);
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
+			ttyprintk_ratelimited("%s%s", tpk_tag, tmp);
+			curr = 0;
+		}
+	}
+	if (curr > 0) {
+		/* non nl or cr terminated message - add nl */
+		tmp[curr + 0] = '\n';
+		tmp[curr + 1] = '\0';
+		ttyprintk_ratelimited("%s%s", tpk_tag, tmp);
+		curr = 0;
+	}
+
+	return count;
+}
+
+struct ttyprintk_port {
+	struct tty_port port;
+	struct mutex port_write_mutex;
+	spinlock_t lock;
+};
+
+static struct ttyprintk_port tpk_port;
+
+/*
+ * TTY operations open function.
+ */
+static int tpk_open(struct tty_struct *tty, struct file *filp)
+{
+	struct ttyprintk_port *port = &tpk_port;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+	port->port.count++;
+	tty->driver_data = port;
+	port->port.tty = tty;
+	clear_bit(TTY_IO_ERROR, &port->port.tty->flags);
+	mutex_init(&port->port_write_mutex);
+	port->port.flags |= ASYNC_INITIALIZED;
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	return 0;
+}
+
+/*
+ * TTY operations close function.
+ */
+static void tpk_close(struct tty_struct *tty, struct file *filp)
+{
+	struct ttyprintk_port *port = tty->driver_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	if (tty_hung_up_p(filp)) {
+		spin_unlock_irqrestore(&port->lock, flags);
+		return;
+	}
+
+	if (tty->count == 1 && port->port.count != 1) {
+		printk(KERN_ERR "tpk_close: bad port count;"
+			" tty->count is 1, port count is %d\n",
+			port->port.count);
+		port->port.count = 1;
+	}
+
+	if (port->port.count > 1) {
+		port->port.count--;
+
+		spin_unlock_irqrestore(&port->lock, flags);
+
+		return;
+	}
+	port->port.flags |= ASYNC_CLOSING;
+	/*
+	 * We have no HW to wait for its buffer to clear; and we notify
+	 * the line discipline to only process XON/XOFF characters.
+	 */
+	tty->closing = 1;
+	spin_unlock_irqrestore(&port->lock, flags);
+	/*
+	 * We have no HW to handle to stop accepting input.
+	 */
+	if (--port->port.count < 0) {
+		printk(KERN_ERR
+			"tpk_close: bad port usage count for ttyprintk: %d\n",
+			port->port.count);
+		port->port.count = 0;
+	}
+
+	tty_ldisc_flush(tty);
+	spin_lock_irqsave(&port->lock, flags);
+	tty->closing = 0;
+	port->port.tty = NULL;
+	spin_unlock_irqrestore(&port->lock, flags);
+	port->port.flags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
+}
+
+/*
+ * TTY operations write function.
+ */
+int tpk_write(struct tty_struct *tty,
+		const unsigned char *buf, int count)
+{
+	struct ttyprintk_port *port;
+	int ret;
+
+	port = tty->driver_data;
+
+	if (!port)
+		return 0;
+
+	if (!(port->port.flags & ASYNC_INITIALIZED))
+		return 0;
+
+	/* exclusive use of tpk_printk within this tty */
+	mutex_lock(&port->port_write_mutex);
+	ret = tpk_printk(buf, count);
+	mutex_unlock(&port->port_write_mutex);
+
+	return ret;
+}
+
+/*
+ * TTY operations write_room function.
+ */
+int tpk_write_room(struct tty_struct *tty)
+{
+	return TTY_PRINTK_STR_SIZE;
+}
+
+/*
+ * TTY operations ioctl function.
+ */
+#define	TPKRLEV	(('e'<<8) | 0) /* Wait for ttyprintk ratelimiting event*/
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
+	case TPKRLEV:
+		wait_event_interruptible(ttyprintk_ratelimit_wq,
+			(ttyprintk_ratelimit_event != 0));
+		break;
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
+	memset(&tpk_port, 0, sizeof(tpk_port));
+	tty_port_init(&tpk_port.port);
+	spin_lock_init(&tpk_port.lock);
+
+	return 0;
+
+error:
+	put_tty_driver(ttyprintk_driver);
+	ttyprintk_driver = NULL;
+	return ret;
+}
+module_init(ttyprintk_init);



