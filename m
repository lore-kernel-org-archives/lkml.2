Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852Ab0IPSG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 14:06:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:19929 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788Ab0IPSG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 14:06:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,377,1280732400"; 
   d="scan'208";a="555175632"
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/3] tty: Convert the USB drivers to the new icount interface
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com,
        drosenberg@vsecurity.com
Date: Thu, 16 Sep 2010 18:21:40 +0100
Message-ID: <20100916172131.25987.39706.stgit@localhost.localdomain>
In-Reply-To: <20100916171747.25987.33573.stgit@localhost.localdomain>
References: <20100916171747.25987.33573.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple pasting job using the new ops function. Also fix a couple of devices
directly returning the internal struct (which happens at this point to match
for the fields that matter but isn't correct or futureproof)

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/net/usb/hso.c                 |   35 +++++++++++------------
 drivers/usb/serial/ark3116.c          |   40 ++++++++++++++------------
 drivers/usb/serial/ftdi_sio.c         |    1 +
 drivers/usb/serial/io_edgeport.c      |   49 ++++++++++++++++++--------------
 drivers/usb/serial/io_tables.h        |    4 +++
 drivers/usb/serial/io_ti.c            |   29 +++++++++++++++----
 drivers/usb/serial/mos7720.c          |   50 +++++++++++++++++++--------------
 drivers/usb/serial/mos7840.c          |   50 +++++++++++++++++++--------------
 drivers/usb/serial/ssu100.c           |   46 +++++++++++++++++-------------
 drivers/usb/serial/ti_usb_3410_5052.c |   37 +++++++++++++++++++-----
 10 files changed, 203 insertions(+), 138 deletions(-)


diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 4f123f8..e18ef9d 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1636,11 +1636,11 @@ hso_wait_modem_status(struct hso_serial *serial, unsigned long arg)
  * NB: both 1->0 and 0->1 transitions are counted except for
  *     RI where only 0->1 is counted.
  */
-static int hso_get_count(struct hso_serial *serial,
-			  struct serial_icounter_struct __user *icnt)
+static int hso_get_count(struct tty_struct *tty,
+		  struct serial_icounter_struct *icount)
 {
-	struct serial_icounter_struct icount;
 	struct uart_icount cnow;
+	struct hso_serial *serial = get_serial_by_tty(tty);
 	struct hso_tiocmget  *tiocmget = serial->tiocmget;
 
 	if (!tiocmget)
@@ -1649,19 +1649,19 @@ static int hso_get_count(struct hso_serial *serial,
 	memcpy(&cnow, &tiocmget->icount, sizeof(struct uart_icount));
 	spin_unlock_irq(&serial->serial_lock);
 
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
 
 
@@ -1753,10 +1753,6 @@ static int hso_serial_ioctl(struct tty_struct *tty, struct file *file,
 	case TIOCMIWAIT:
 		ret = hso_wait_modem_status(serial, arg);
 		break;
-
-	case TIOCGICOUNT:
-		ret = hso_get_count(serial, uarg);
-		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
@@ -3289,6 +3285,7 @@ static const struct tty_operations hso_serial_ops = {
 	.chars_in_buffer = hso_serial_chars_in_buffer,
 	.tiocmget = hso_serial_tiocmget,
 	.tiocmset = hso_serial_tiocmset,
+	.get_icount = hso_get_count,
 	.unthrottle = hso_unthrottle
 };
 
diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
index 4e41a2a..8f1d4fb 100644
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -411,6 +411,26 @@ err_out:
 	return result;
 }
 
+static int ark3116_get_icount(struct tty_struct *tty,
+					struct serial_icounter_struct *icount)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct ark3116_private *priv = usb_get_serial_port_data(port);
+	struct async_icount cnow = priv->icount;
+	icount->cts = cnow.cts;
+	icount->dsr = cnow.dsr;
+	icount->rng = cnow.rng;
+	icount->dcd = cnow.dcd;
+	icount->rx = cnow.rx;
+	icount->tx = cnow.tx;
+	icount->frame = cnow.frame;
+	icount->overrun = cnow.overrun;
+	icount->parity = cnow.parity;
+	icount->brk = cnow.brk;
+	icount->buf_overrun = cnow.buf_overrun;
+	return 0;
+}
+
 static int ark3116_ioctl(struct tty_struct *tty, struct file *file,
 			 unsigned int cmd, unsigned long arg)
 {
@@ -460,25 +480,6 @@ static int ark3116_ioctl(struct tty_struct *tty, struct file *file,
 				return 0;
 		}
 		break;
-	case TIOCGICOUNT: {
-		struct serial_icounter_struct icount;
-		struct async_icount cnow = priv->icount;
-		memset(&icount, 0, sizeof(icount));
-		icount.cts = cnow.cts;
-		icount.dsr = cnow.dsr;
-		icount.rng = cnow.rng;
-		icount.dcd = cnow.dcd;
-		icount.rx = cnow.rx;
-		icount.tx = cnow.tx;
-		icount.frame = cnow.frame;
-		icount.overrun = cnow.overrun;
-		icount.parity = cnow.parity;
-		icount.brk = cnow.brk;
-		icount.buf_overrun = cnow.buf_overrun;
-		if (copy_to_user(user_arg, &icount, sizeof(icount)))
-			return -EFAULT;
-		return 0;
-	}
 	}
 
 	return -ENOIOCTLCMD;
@@ -736,6 +737,7 @@ static struct usb_serial_driver ark3116_device = {
 	.ioctl =		ark3116_ioctl,
 	.tiocmget =		ark3116_tiocmget,
 	.tiocmset =		ark3116_tiocmset,
+	.get_icount =		ark3116_get_icount,
 	.open =			ark3116_open,
 	.close =		ark3116_close,
 	.break_ctl = 		ark3116_break_ctl,
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 1f30a01..5002f1f 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2167,6 +2167,7 @@ static int ftdi_ioctl(struct tty_struct *tty, struct file *file,
 	 * - mask passed in arg for lines of interest
 	 *   (use |'ed TIOCM_RNG/DSR/CD/CTS for masking)
 	 * Caller should use TIOCGICOUNT to see which one it was.
+	 * (except that the driver doesn't support it !)
 	 *
 	 * This code is borrowed from linux/drivers/char/serial.c
 	 */
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 892e916..cd769ef 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -222,6 +222,8 @@ static void edge_break(struct tty_struct *tty, int break_state);
 static int  edge_tiocmget(struct tty_struct *tty, struct file *file);
 static int  edge_tiocmset(struct tty_struct *tty, struct file *file,
 					unsigned int set, unsigned int clear);
+static int  edge_get_icount(struct tty_struct *tty,
+				struct serial_icounter_struct *icount);
 static int  edge_startup(struct usb_serial *serial);
 static void edge_disconnect(struct usb_serial *serial);
 static void edge_release(struct usb_serial *serial);
@@ -1622,6 +1624,31 @@ static int edge_tiocmget(struct tty_struct *tty, struct file *file)
 	return result;
 }
 
+static int edge_get_icount(struct tty_struct *tty,
+				struct serial_icounter_struct *icount)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
+	struct async_icount cnow;
+	cnow = edge_port->icount;
+
+	icount->cts = cnow.cts;
+	icount->dsr = cnow.dsr;
+	icount->rng = cnow.rng;
+	icount->dcd = cnow.dcd;
+	icount->rx = cnow.rx;
+	icount->tx = cnow.tx;
+	icount->frame = cnow.frame;
+	icount->overrun = cnow.overrun;
+	icount->parity = cnow.parity;
+	icount->brk = cnow.brk;
+	icount->buf_overrun = cnow.buf_overrun;
+
+	dbg("%s (%d) TIOCGICOUNT RX=%d, TX=%d",
+			__func__,  port->number, icount->rx, icount->tx);
+	return 0;
+}
+
 static int get_serial_info(struct edgeport_port *edge_port,
 				struct serial_struct __user *retinfo)
 {
@@ -1648,7 +1675,6 @@ static int get_serial_info(struct edgeport_port *edge_port,
 }
 
 
-
 /*****************************************************************************
  * SerialIoctl
  *	this function handles any ioctl calls to the driver
@@ -1661,7 +1687,6 @@ static int edge_ioctl(struct tty_struct *tty, struct file *file,
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	struct async_icount cnow;
 	struct async_icount cprev;
-	struct serial_icounter_struct icount;
 
 	dbg("%s - port %d, cmd = 0x%x", __func__, port->number, cmd);
 
@@ -1700,26 +1725,6 @@ static int edge_ioctl(struct tty_struct *tty, struct file *file,
 		/* NOTREACHED */
 		break;
 
-	case TIOCGICOUNT:
-		cnow = edge_port->icount;
-		memset(&icount, 0, sizeof(icount));
-		icount.cts = cnow.cts;
-		icount.dsr = cnow.dsr;
-		icount.rng = cnow.rng;
-		icount.dcd = cnow.dcd;
-		icount.rx = cnow.rx;
-		icount.tx = cnow.tx;
-		icount.frame = cnow.frame;
-		icount.overrun = cnow.overrun;
-		icount.parity = cnow.parity;
-		icount.brk = cnow.brk;
-		icount.buf_overrun = cnow.buf_overrun;
-
-		dbg("%s (%d) TIOCGICOUNT RX=%d, TX=%d",
-				__func__,  port->number, icount.rx, icount.tx);
-		if (copy_to_user((void __user *)arg, &icount, sizeof(icount)))
-			return -EFAULT;
-		return 0;
 	}
 	return -ENOIOCTLCMD;
 }
diff --git a/drivers/usb/serial/io_tables.h b/drivers/usb/serial/io_tables.h
index feb56a4..6ab2a3f 100644
--- a/drivers/usb/serial/io_tables.h
+++ b/drivers/usb/serial/io_tables.h
@@ -123,6 +123,7 @@ static struct usb_serial_driver edgeport_2port_device = {
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,
 	.tiocmset		= edge_tiocmset,
+	.get_icount		= edge_get_icount,
 	.write			= edge_write,
 	.write_room		= edge_write_room,
 	.chars_in_buffer	= edge_chars_in_buffer,
@@ -152,6 +153,7 @@ static struct usb_serial_driver edgeport_4port_device = {
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,
 	.tiocmset		= edge_tiocmset,
+	.get_icount		= edge_get_icount,
 	.write			= edge_write,
 	.write_room		= edge_write_room,
 	.chars_in_buffer	= edge_chars_in_buffer,
@@ -181,6 +183,7 @@ static struct usb_serial_driver edgeport_8port_device = {
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,
 	.tiocmset		= edge_tiocmset,
+	.get_icount		= edge_get_icount,
 	.write			= edge_write,
 	.write_room		= edge_write_room,
 	.chars_in_buffer	= edge_chars_in_buffer,
@@ -209,6 +212,7 @@ static struct usb_serial_driver epic_device = {
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,
 	.tiocmset		= edge_tiocmset,
+	.get_icount		= edge_get_icount,
 	.write			= edge_write,
 	.write_room		= edge_write_room,
 	.chars_in_buffer	= edge_chars_in_buffer,
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index baf7037..22506b0 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2506,6 +2506,27 @@ static int edge_tiocmget(struct tty_struct *tty, struct file *file)
 	return result;
 }
 
+static int edge_get_icount(struct tty_struct *tty,
+				struct serial_icounter_struct *icount)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
+	struct async_icount *ic = &edge_port->icount;
+
+	icount->cts = ic->cts;
+	icount->dsr = ic->dsr;
+	icount->rng = ic->rng;
+	icount->dcd = ic->dcd;
+	icount->tx = ic->tx;
+        icount->rx = ic->rx;
+        icount->frame = ic->frame;
+        icount->parity = ic->parity;
+        icount->overrun = ic->overrun;
+        icount->brk = ic->brk;
+        icount->buf_overrun = ic->buf_overrun;
+	return 0;
+}
+
 static int get_serial_info(struct edgeport_port *edge_port,
 				struct serial_struct __user *retinfo)
 {
@@ -2568,13 +2589,6 @@ static int edge_ioctl(struct tty_struct *tty, struct file *file,
 		}
 		/* not reached */
 		break;
-	case TIOCGICOUNT:
-		dbg("%s - (%d) TIOCGICOUNT RX=%d, TX=%d", __func__,
-		     port->number, edge_port->icount.rx, edge_port->icount.tx);
-		if (copy_to_user((void __user *)arg, &edge_port->icount,
-				sizeof(edge_port->icount)))
-			return -EFAULT;
-		return 0;
 	}
 	return -ENOIOCTLCMD;
 }
@@ -2754,6 +2768,7 @@ static struct usb_serial_driver edgeport_1port_device = {
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,
 	.tiocmset		= edge_tiocmset,
+	.get_icount		= edge_get_icount,
 	.write			= edge_write,
 	.write_room		= edge_write_room,
 	.chars_in_buffer	= edge_chars_in_buffer,
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index f442333..fb60bfb 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -1890,10 +1890,37 @@ static int mos7720_tiocmset(struct tty_struct *tty, struct file *file,
 	return 0;
 }
 
+static int mos7720_get_icount(struct tty_struct *tty,
+				struct serial_icounter_struct *icount)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct moschip_port *mos7720_port;
+	struct async_icount cnow;
+
+	mos7720_port = usb_get_serial_port_data(port);
+	cnow = mos7720_port->icount;
+
+	icount->cts = cnow.cts;
+	icount->dsr = cnow.dsr;
+	icount->rng = cnow.rng;
+	icount->dcd = cnow.dcd;
+	icount->rx = cnow.rx;
+	icount->tx = cnow.tx;
+	icount->frame = cnow.frame;
+	icount->overrun = cnow.overrun;
+	icount->parity = cnow.parity;
+	icount->brk = cnow.brk;
+	icount->buf_overrun = cnow.buf_overrun;
+
+	dbg("%s (%d) TIOCGICOUNT RX=%d, TX=%d", __func__,
+		port->number, icount->rx, icount->tx);
+	return 0;
+}
+
 static int set_modem_info(struct moschip_port *mos7720_port, unsigned int cmd,
 			  unsigned int __user *value)
 {
-	unsigned int mcr ;
+	unsigned int mcr;
 	unsigned int arg;
 
 	struct usb_serial_port *port;
@@ -1967,7 +1994,6 @@ static int mos7720_ioctl(struct tty_struct *tty, struct file *file,
 	struct moschip_port *mos7720_port;
 	struct async_icount cnow;
 	struct async_icount cprev;
-	struct serial_icounter_struct icount;
 
 	mos7720_port = usb_get_serial_port_data(port);
 	if (mos7720_port == NULL)
@@ -2016,25 +2042,6 @@ static int mos7720_ioctl(struct tty_struct *tty, struct file *file,
 		/* NOTREACHED */
 		break;
 
-	case TIOCGICOUNT:
-		cnow = mos7720_port->icount;
-		icount.cts = cnow.cts;
-		icount.dsr = cnow.dsr;
-		icount.rng = cnow.rng;
-		icount.dcd = cnow.dcd;
-		icount.rx = cnow.rx;
-		icount.tx = cnow.tx;
-		icount.frame = cnow.frame;
-		icount.overrun = cnow.overrun;
-		icount.parity = cnow.parity;
-		icount.brk = cnow.brk;
-		icount.buf_overrun = cnow.buf_overrun;
-
-		dbg("%s (%d) TIOCGICOUNT RX=%d, TX=%d", __func__,
-		    port->number, icount.rx, icount.tx);
-		if (copy_to_user((void __user *)arg, &icount, sizeof(icount)))
-			return -EFAULT;
-		return 0;
 	}
 
 	return -ENOIOCTLCMD;
@@ -2203,6 +2210,7 @@ static struct usb_serial_driver moschip7720_2port_driver = {
 	.ioctl			= mos7720_ioctl,
 	.tiocmget		= mos7720_tiocmget,
 	.tiocmset		= mos7720_tiocmset,
+	.get_icount		= mos7720_get_icount,
 	.set_termios		= mos7720_set_termios,
 	.write			= mos7720_write,
 	.write_room		= mos7720_write_room,
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 01b3614..5627993 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2202,6 +2202,34 @@ static int mos7840_get_serial_info(struct moschip_port *mos7840_port,
 	return 0;
 }
 
+static int mos7840_get_icount(struct tty_struct *tty,
+			struct serial_icounter_struct *icount)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct moschip_port *mos7840_port;
+	struct async_icount cnow;
+
+	mos7840_port = mos7840_get_port_private(port);
+	cnow = mos7840_port->icount;
+
+	smp_rmb();
+	icount->cts = cnow.cts;
+	icount->dsr = cnow.dsr;
+	icount->rng = cnow.rng;
+	icount->dcd = cnow.dcd;
+	icount->rx = cnow.rx;
+	icount->tx = cnow.tx;
+	icount->frame = cnow.frame;
+	icount->overrun = cnow.overrun;
+	icount->parity = cnow.parity;
+	icount->brk = cnow.brk;
+	icount->buf_overrun = cnow.buf_overrun;
+
+	dbg("%s (%d) TIOCGICOUNT RX=%d, TX=%d", __func__,
+		port->number, icount->rx, icount->tx);
+	return 0;
+}
+
 /*****************************************************************************
  * SerialIoctl
  *	this function handles any ioctl calls to the driver
@@ -2216,7 +2244,6 @@ static int mos7840_ioctl(struct tty_struct *tty, struct file *file,
 
 	struct async_icount cnow;
 	struct async_icount cprev;
-	struct serial_icounter_struct icount;
 
 	if (mos7840_port_paranoia_check(port, __func__)) {
 		dbg("%s", "Invalid port");
@@ -2275,26 +2302,6 @@ static int mos7840_ioctl(struct tty_struct *tty, struct file *file,
 		/* NOTREACHED */
 		break;
 
-	case TIOCGICOUNT:
-		cnow = mos7840_port->icount;
-		smp_rmb();
-		icount.cts = cnow.cts;
-		icount.dsr = cnow.dsr;
-		icount.rng = cnow.rng;
-		icount.dcd = cnow.dcd;
-		icount.rx = cnow.rx;
-		icount.tx = cnow.tx;
-		icount.frame = cnow.frame;
-		icount.overrun = cnow.overrun;
-		icount.parity = cnow.parity;
-		icount.brk = cnow.brk;
-		icount.buf_overrun = cnow.buf_overrun;
-
-		dbg("%s (%d) TIOCGICOUNT RX=%d, TX=%d", __func__,
-		    port->number, icount.rx, icount.tx);
-		if (copy_to_user(argp, &icount, sizeof(icount)))
-			return -EFAULT;
-		return 0;
 	default:
 		break;
 	}
@@ -2664,6 +2671,7 @@ static struct usb_serial_driver moschip7840_4port_device = {
 	.break_ctl = mos7840_break,
 	.tiocmget = mos7840_tiocmget,
 	.tiocmset = mos7840_tiocmset,
+	.get_icount = mos7840_get_icount,
 	.attach = mos7840_startup,
 	.disconnect = mos7840_disconnect,
 	.release = mos7840_release,
diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
index e986002..8bd60e3 100644
--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -416,6 +416,30 @@ static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
 	return 0;
 }
 
+static int ssu100_get_icount(struct tty_struct *tty,
+			struct serial_icounter_struct *icount)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct ssu100_port_private *priv = usb_get_serial_port_data(port);
+	struct async_icount cnow = priv->icount;
+
+	icount->cts = cnow.cts;
+	icount->dsr = cnow.dsr;
+	icount->rng = cnow.rng;
+	icount->dcd = cnow.dcd;
+	icount->rx = cnow.rx;
+	icount->tx = cnow.tx;
+	icount->frame = cnow.frame;
+	icount->overrun = cnow.overrun;
+	icount->parity = cnow.parity;
+	icount->brk = cnow.brk;
+	icount->buf_overrun = cnow.buf_overrun;
+
+	return 0;
+}
+
+
+
 static int ssu100_ioctl(struct tty_struct *tty, struct file *file,
 		    unsigned int cmd, unsigned long arg)
 {
@@ -433,27 +457,6 @@ static int ssu100_ioctl(struct tty_struct *tty, struct file *file,
 	case TIOCMIWAIT:
 		return wait_modem_info(port, arg);
 
-	case TIOCGICOUNT:
-	{
-		struct serial_icounter_struct icount;
-		struct async_icount cnow = priv->icount;
-		memset(&icount, 0, sizeof(icount));
-		icount.cts = cnow.cts;
-		icount.dsr = cnow.dsr;
-		icount.rng = cnow.rng;
-		icount.dcd = cnow.dcd;
-		icount.rx = cnow.rx;
-		icount.tx = cnow.tx;
-		icount.frame = cnow.frame;
-		icount.overrun = cnow.overrun;
-		icount.parity = cnow.parity;
-		icount.brk = cnow.brk;
-		icount.buf_overrun = cnow.buf_overrun;
-		if (copy_to_user(user_arg, &icount, sizeof(icount)))
-			return -EFAULT;
-		return 0;
-	}
-
 	default:
 		break;
 	}
@@ -726,6 +729,7 @@ static struct usb_serial_driver ssu100_device = {
 	.process_read_urb    = ssu100_process_read_urb,
 	.tiocmget            = ssu100_tiocmget,
 	.tiocmset            = ssu100_tiocmset,
+	.get_icount	     = ssu100_get_icount,
 	.ioctl               = ssu100_ioctl,
 	.set_termios         = ssu100_set_termios,
 	.disconnect          = usb_serial_generic_disconnect,
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index 90979a1..a5b3684 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -108,6 +108,8 @@ static void ti_throttle(struct tty_struct *tty);
 static void ti_unthrottle(struct tty_struct *tty);
 static int ti_ioctl(struct tty_struct *tty, struct file *file,
 		unsigned int cmd, unsigned long arg);
+static int ti_get_icount(struct tty_struct *tty,
+		struct serial_icounter_struct *icount);
 static void ti_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios);
 static int ti_tiocmget(struct tty_struct *tty, struct file *file);
@@ -237,6 +239,7 @@ static struct usb_serial_driver ti_1port_device = {
 	.set_termios		= ti_set_termios,
 	.tiocmget		= ti_tiocmget,
 	.tiocmset		= ti_tiocmset,
+	.get_icount		= ti_get_icount,
 	.break_ctl		= ti_break,
 	.read_int_callback	= ti_interrupt_callback,
 	.read_bulk_callback	= ti_bulk_in_callback,
@@ -265,6 +268,7 @@ static struct usb_serial_driver ti_2port_device = {
 	.set_termios		= ti_set_termios,
 	.tiocmget		= ti_tiocmget,
 	.tiocmset		= ti_tiocmset,
+	.get_icount		= ti_get_icount,
 	.break_ctl		= ti_break,
 	.read_int_callback	= ti_interrupt_callback,
 	.read_bulk_callback	= ti_bulk_in_callback,
@@ -788,6 +792,31 @@ static void ti_unthrottle(struct tty_struct *tty)
 	}
 }
 
+static int ti_get_icount(struct tty_struct *tty,
+		struct serial_icounter_struct *icount)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct ti_port *tport = usb_get_serial_port_data(port);
+	struct async_icount cnow = tport->tp_icount;
+	
+	dbg("%s - (%d) TIOCGICOUNT RX=%d, TX=%d",
+		__func__, port->number,
+		cnow.rx, cnow.tx);
+
+	icount->cts = cnow.cts;
+	icount->dsr = cnow.dsr;
+	icount->rng = cnow.rng;
+	icount->dcd = cnow.dcd;
+	icount->rx = cnow.rx;
+	icount->tx = cnow.tx;
+	icount->frame = cnow.frame;
+	icount->overrun = cnow.overrun;
+	icount->parity = cnow.parity;
+	icount->brk = cnow.brk;
+	icount->buf_overrun = cnow.buf_overrun;
+
+	return 0;
+}
 
 static int ti_ioctl(struct tty_struct *tty, struct file *file,
 	unsigned int cmd, unsigned long arg)
@@ -830,14 +859,6 @@ static int ti_ioctl(struct tty_struct *tty, struct file *file,
 			cprev = cnow;
 		}
 		break;
-	case TIOCGICOUNT:
-		dbg("%s - (%d) TIOCGICOUNT RX=%d, TX=%d",
-				__func__, port->number,
-				tport->tp_icount.rx, tport->tp_icount.tx);
-		if (copy_to_user((void __user *)arg, &tport->tp_icount,
-					sizeof(tport->tp_icount)))
-			return -EFAULT;
-		return 0;
 	}
 	return -ENOIOCTLCMD;
 }

