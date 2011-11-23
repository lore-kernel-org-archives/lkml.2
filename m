Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017Ab1KWAeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:34:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275Ab1KWAd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:33:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:22:09 2011
Message-Id: <20111123002209.231902935@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:21:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <greg@kroah.com>, Alan Cox <alan@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [24/25] tty: Make tiocgicount a handler
In-Reply-To: <20111123002222.GA2376@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 6894
Lines: 206

From: Alan Cox <alan@linux.intel.com>

commit d281da7ff6f70efca0553c288bb883e8605b3862 upstream

Dan Rosenberg noted that various drivers return the struct with uncleared
fields. Instead of spending forever trying to stomp all the drivers that
get it wrong (and every new driver) do the job in one place.

This first patch adds the needed operations and hooks them up, including
the needed USB midlayer and serial core plumbing.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/char/tty_io.c           |   21 +++++++++++++++++++++
 drivers/serial/serial_core.c    |   35 ++++++++++++++++-------------------
 drivers/usb/serial/usb-serial.c |   13 +++++++++++++
 include/linux/tty_driver.h      |    9 +++++++++
 include/linux/usb/serial.h      |    2 ++
 5 files changed, 61 insertions(+), 19 deletions(-)

--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -96,6 +96,7 @@
 #include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/seq_file.h>
+#include <linux/serial.h>
 
 #include <linux/uaccess.h>
 #include <asm/system.h>
@@ -2436,6 +2437,20 @@ static int tty_tiocmset(struct tty_struc
 	return tty->ops->tiocmset(tty, file, set, clear);
 }
 
+static int tty_tiocgicount(struct tty_struct *tty, void __user *arg)
+{
+	int retval = -EINVAL;
+	struct serial_icounter_struct icount;
+	memset(&icount, 0, sizeof(icount));
+	if (tty->ops->get_icount)
+		retval = tty->ops->get_icount(tty, &icount);
+	if (retval != 0)
+		return retval;
+	if (copy_to_user(arg, &icount, sizeof(icount)))
+		return -EFAULT;
+	return 0;
+}
+
 struct tty_struct *tty_pair_get_tty(struct tty_struct *tty)
 {
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
@@ -2556,6 +2571,12 @@ long tty_ioctl(struct file *file, unsign
 	case TIOCMBIC:
 	case TIOCMBIS:
 		return tty_tiocmset(tty, file, cmd, p);
+	case TIOCGICOUNT:
+		retval = tty_tiocgicount(tty, p);
+		/* For the moment allow fall through to the old method */
+        	if (retval != -EINVAL)
+			return retval;
+		break;
 	case TCFLSH:
 		switch (arg) {
 		case TCIFLUSH:
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1067,10 +1067,10 @@ uart_wait_modem_status(struct uart_state
  * NB: both 1->0 and 0->1 transitions are counted except for
  *     RI where only 0->1 is counted.
  */
-static int uart_get_count(struct uart_state *state,
-			  struct serial_icounter_struct __user *icnt)
+static int uart_get_icount(struct tty_struct *tty,
+			  struct serial_icounter_struct *icount)
 {
-	struct serial_icounter_struct icount;
+	struct uart_state *state = tty->driver_data;
 	struct uart_icount cnow;
 	struct uart_port *uport = state->uart_port;
 
@@ -1078,19 +1078,19 @@ static int uart_get_count(struct uart_st
 	memcpy(&cnow, &uport->icount, sizeof(struct uart_icount));
 	spin_unlock_irq(&uport->lock);
 
-	icount.cts         = cnow.cts;
-	icount.dsr         = cnow.dsr;
-	icount.rng         = cnow.rng;
-	icount.dcd         = cnow.dcd;
-	icount.rx          = cnow.rx;
-	icount.tx          = cnow.tx;
-	icount.frame       = cnow.frame;
-	icount.overrun     = cnow.overrun;
-	icount.parity      = cnow.parity;
-	icount.brk         = cnow.brk;
-	icount.buf_overrun = cnow.buf_overrun;
+	icount->cts         = cnow.cts;
+	icount->dsr         = cnow.dsr;
+	icount->rng         = cnow.rng;
+	icount->dcd         = cnow.dcd;
+	icount->rx          = cnow.rx;
+	icount->tx          = cnow.tx;
+	icount->frame       = cnow.frame;
+	icount->overrun     = cnow.overrun;
+	icount->parity      = cnow.parity;
+	icount->brk         = cnow.brk;
+	icount->buf_overrun = cnow.buf_overrun;
 
-	return copy_to_user(icnt, &icount, sizeof(icount)) ? -EFAULT : 0;
+	return 0;
 }
 
 /*
@@ -1143,10 +1143,6 @@ uart_ioctl(struct tty_struct *tty, struc
 	case TIOCMIWAIT:
 		ret = uart_wait_modem_status(state, arg);
 		break;
-
-	case TIOCGICOUNT:
-		ret = uart_get_count(state, uarg);
-		break;
 	}
 
 	if (ret != -ENOIOCTLCMD)
@@ -2322,6 +2318,7 @@ static const struct tty_operations uart_
 #endif
 	.tiocmget	= uart_tiocmget,
 	.tiocmset	= uart_tiocmset,
+	.get_icount	= uart_get_icount,
 #ifdef CONFIG_CONSOLE_POLL
 	.poll_init	= uart_poll_init,
 	.poll_get_char	= uart_poll_get_char,
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -562,6 +562,18 @@ static int serial_tiocmset(struct tty_st
 	return -EINVAL;
 }
 
+static int serial_get_icount(struct tty_struct *tty,
+				struct serial_icounter_struct *icount)
+{
+	struct usb_serial_port *port = tty->driver_data;
+
+	dbg("%s - port %d", __func__, port->number);
+
+	if (port->serial->type->get_icount)
+		return port->serial->type->get_icount(tty, icount);
+	return -EINVAL;
+}
+
 /*
  * We would be calling tty_wakeup here, but unfortunately some line
  * disciplines have an annoying habit of calling tty->write from
@@ -1214,6 +1226,7 @@ static const struct tty_operations seria
 	.chars_in_buffer =	serial_chars_in_buffer,
 	.tiocmget =		serial_tiocmget,
 	.tiocmset =		serial_tiocmset,
+	.get_icount = 		serial_get_icount,
 	.cleanup = 		serial_cleanup,
 	.install = 		serial_install,
 	.proc_fops =		&serial_proc_fops,
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -224,6 +224,12 @@
  *	unless the tty also has a valid tty->termiox pointer.
  *
  *	Optional: Called under the termios lock
+ *
+ * int (*get_icount)(struct tty_struct *tty, struct serial_icounter *icount);
+ *
+ *	Called when the device receives a TIOCGICOUNT ioctl. Passed a kernel
+ *	structure to complete. This method is optional and will only be called
+ *	if provided (otherwise EINVAL will be returned).
  */
 
 #include <linux/fs.h>
@@ -232,6 +238,7 @@
 
 struct tty_struct;
 struct tty_driver;
+struct serial_icounter_struct;
 
 struct tty_operations {
 	struct tty_struct * (*lookup)(struct tty_driver *driver,
@@ -268,6 +275,8 @@ struct tty_operations {
 			unsigned int set, unsigned int clear);
 	int (*resize)(struct tty_struct *tty, struct winsize *ws);
 	int (*set_termiox)(struct tty_struct *tty, struct termiox *tnew);
+	int (*get_icount)(struct tty_struct *tty,
+				struct serial_icounter_struct *icount);
 #ifdef CONFIG_CONSOLE_POLL
 	int (*poll_init)(struct tty_driver *driver, int line, char *options);
 	int (*poll_get_char)(struct tty_driver *driver, int line);
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -259,6 +259,8 @@ struct usb_serial_driver {
 	int  (*tiocmget)(struct tty_struct *tty, struct file *file);
 	int  (*tiocmset)(struct tty_struct *tty, struct file *file,
 			 unsigned int set, unsigned int clear);
+	int  (*get_icount)(struct tty_struct *tty,
+			struct serial_icounter_struct *icount);
 	/* Called by the tty layer for port level work. There may or may not
 	   be an attached tty at this point */
 	void (*dtr_rts)(struct usb_serial_port *port, int on);


