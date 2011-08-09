Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab1HIGYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 02:24:05 -0400
Received: from mail.ispras.ru ([83.149.199.43]:57111 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab1HIGYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 02:24:03 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, wfp5p@virginia.edu,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: serqt_usb2: fix sleeping with spinlock held
Date: Tue,  9 Aug 2011 10:23:42 +0400
Message-Id: <1312871022-14875-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110805151747.GB18527@suse.de>
References: <20110805151747.GB18527@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch replaces spinlock with mutex.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/serqt_usb2/serqt_usb2.c |   34 ++++++++++++------------------
 1 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 12f5eba..2ea82c1 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -190,7 +190,7 @@ struct quatech_port {
 
 	struct usb_serial_port *port;	/* owner of this object */
 	struct qt_get_device_data DeviceData;
-	spinlock_t lock;
+	struct mutex lock;
 	bool read_urb_busy;
 	int RxHolding;
 	int ReadBulkStopped;
@@ -745,7 +745,7 @@ static int qt_startup(struct usb_serial *serial)
 			}
 			return -ENOMEM;
 		}
-		spin_lock_init(&qt_port->lock);
+		mutex_init(&qt_port->lock);
 
 		usb_set_serial_port_data(port, qt_port);
 
@@ -1160,7 +1160,6 @@ static int qt_write_room(struct tty_struct *tty)
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial;
 	struct quatech_port *qt_port;
-	unsigned long flags;
 
 	int retval = -EINVAL;
 
@@ -1176,7 +1175,7 @@ static int qt_write_room(struct tty_struct *tty)
 
 	qt_port = qt_get_port_private(port);
 
-	spin_lock_irqsave(&qt_port->lock, flags);
+	mutex_lock(&qt_port->lock);
 
 	dbg("%s - port %d\n", __func__, port->number);
 
@@ -1185,7 +1184,7 @@ static int qt_write_room(struct tty_struct *tty)
 			retval = port->bulk_out_size;
 	}
 
-	spin_unlock_irqrestore(&qt_port->lock, flags);
+	mutex_unlock(&qt_port->lock);
 	return retval;
 
 }
@@ -1358,7 +1357,6 @@ static void qt_break(struct tty_struct *tty, int break_state)
 	struct quatech_port *qt_port;
 	u16 index, onoff;
 	unsigned int result;
-	unsigned long flags;
 
 	index = tty->index - serial->minor;
 
@@ -1369,7 +1367,7 @@ static void qt_break(struct tty_struct *tty, int break_state)
 	else
 		onoff = 0;
 
-	spin_lock_irqsave(&qt_port->lock, flags);
+	mutex_lock(&qt_port->lock);
 
 	dbg("%s - port %d\n", __func__, port->number);
 
@@ -1377,7 +1375,7 @@ static void qt_break(struct tty_struct *tty, int break_state)
 	    usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
 			    QT_BREAK_CONTROL, 0x40, onoff, index, NULL, 0, 300);
 
-	spin_unlock_irqrestore(&qt_port->lock, flags);
+	mutex_unlock(&qt_port->lock);
 }
 
 static inline int qt_real_tiocmget(struct tty_struct *tty,
@@ -1466,21 +1464,20 @@ static int qt_tiocmget(struct tty_struct *tty)
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 	struct quatech_port *qt_port = qt_get_port_private(port);
 	int retval = -ENODEV;
-	unsigned long flags;
 
 	dbg("In %s\n", __func__);
 
 	if (!serial)
 		return -ENODEV;
 
-	spin_lock_irqsave(&qt_port->lock, flags);
+	mutex_lock(&qt_port->lock);
 
 	dbg("%s - port %d\n", __func__, port->number);
 	dbg("%s - port->RxHolding = %d\n", __func__, qt_port->RxHolding);
 
 	retval = qt_real_tiocmget(tty, port, serial);
 
-	spin_unlock_irqrestore(&qt_port->lock, flags);
+	mutex_unlock(&qt_port->lock);
 	return retval;
 }
 
@@ -1491,7 +1488,6 @@ static int qt_tiocmset(struct tty_struct *tty,
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 	struct quatech_port *qt_port = qt_get_port_private(port);
-	unsigned long flags;
 	int retval = -ENODEV;
 
 	dbg("In %s\n", __func__);
@@ -1499,14 +1495,14 @@ static int qt_tiocmset(struct tty_struct *tty,
 	if (!serial)
 		return -ENODEV;
 
-	spin_lock_irqsave(&qt_port->lock, flags);
+	mutex_lock(&qt_port->lock);
 
 	dbg("%s - port %d\n", __func__, port->number);
 	dbg("%s - qt_port->RxHolding = %d\n", __func__, qt_port->RxHolding);
 
 	retval = qt_real_tiocmset(tty, port, serial, set);
 
-	spin_unlock_irqrestore(&qt_port->lock, flags);
+	mutex_unlock(&qt_port->lock);
 	return retval;
 }
 
@@ -1515,7 +1511,6 @@ static void qt_throttle(struct tty_struct *tty)
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 	struct quatech_port *qt_port;
-	unsigned long flags;
 
 	dbg("%s - port %d\n", __func__, port->number);
 
@@ -1524,13 +1519,13 @@ static void qt_throttle(struct tty_struct *tty)
 
 	qt_port = qt_get_port_private(port);
 
-	spin_lock_irqsave(&qt_port->lock, flags);
+	mutex_lock(&qt_port->lock);
 
 	/* pass on to the driver specific version of this function */
 	qt_port->RxHolding = 1;
 	dbg("%s - port->RxHolding = 1\n", __func__);
 
-	spin_unlock_irqrestore(&qt_port->lock, flags);
+	mutex_unlock(&qt_port->lock);
 	return;
 }
 
@@ -1539,7 +1534,6 @@ static void qt_unthrottle(struct tty_struct *tty)
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = get_usb_serial(port, __func__);
 	struct quatech_port *qt_port;
-	unsigned long flags;
 	unsigned int result;
 
 	if (!serial)
@@ -1547,7 +1541,7 @@ static void qt_unthrottle(struct tty_struct *tty)
 
 	qt_port = qt_get_port_private(port);
 
-	spin_lock_irqsave(&qt_port->lock, flags);
+	mutex_lock(&qt_port->lock);
 
 	dbg("%s - port %d\n", __func__, port->number);
 
@@ -1573,7 +1567,7 @@ static void qt_unthrottle(struct tty_struct *tty)
 				    __func__, result);
 		}
 	}
-	spin_unlock_irqrestore(&qt_port->lock, flags);
+	mutex_unlock(&qt_port->lock);
 	return;
 
 }
-- 
1.7.4.1

