Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab0CQWB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:01:29 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:19821 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0CQWB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:01:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BMJpc1Z62h5B5QVOR6Ow/ufmC54X2EdKMj6GKxh5pcabzVqLv9cCiTUAtPbRJBIobC
         eELgXlm68vGyqISW3ngM18x7t0jSbsnvOvCKOZw4Pi77NiTM2BBIUmSxB5SHvGljGMLJ
         FnPahdPjOqONYwMZSAFRUa8zgdF6xaYlJ8akU=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 9/9] USB: serial: refactor generic close
Date: Wed, 17 Mar 2010 23:00:45 +0100
Message-Id: <1268863245-17230-10-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
References: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export usb_serial_generic_close so that drivers can easily kill the read
and write urb and make sure that the write fifo is reset.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ark3116.c   |    7 ++-----
 drivers/usb/serial/belkin_sa.c |    4 +---
 drivers/usb/serial/ch341.c     |    5 +----
 drivers/usb/serial/cp210x.c    |    5 +----
 drivers/usb/serial/generic.c   |    1 +
 drivers/usb/serial/mct_u232.c  |    7 ++-----
 6 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
index 547c944..d655a3d 100644
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -354,14 +354,11 @@ static void ark3116_close(struct usb_serial_port *port)
 		/* deactivate interrupts */
 		ark3116_write_reg(serial, UART_IER, 0);
 
-		/* shutdown any bulk reads that might be going on */
-		if (serial->num_bulk_out)
-			usb_kill_urb(port->write_urb);
-		if (serial->num_bulk_in)
-			usb_kill_urb(port->read_urb);
+		usb_serial_generic_close(port);
 		if (serial->num_interrupt_in)
 			usb_kill_urb(port->interrupt_in_urb);
 	}
+
 }
 
 static int ark3116_open(struct tty_struct *tty, struct usb_serial_port *port)
diff --git a/drivers/usb/serial/belkin_sa.c b/drivers/usb/serial/belkin_sa.c
index 1295e44..bdab31a 100644
--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -246,9 +246,7 @@ static void belkin_sa_close(struct usb_serial_port *port)
 {
 	dbg("%s port %d", __func__, port->number);
 
-	/* shutdown our bulk reads and writes */
-	usb_kill_urb(port->write_urb);
-	usb_kill_urb(port->read_urb);
+	usb_serial_generic_close(port);
 	usb_kill_urb(port->interrupt_in_urb);
 } /* belkin_sa_close */
 
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 9f4fed1..1a85e35 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -304,10 +304,7 @@ static void ch341_close(struct usb_serial_port *port)
 {
 	dbg("%s - port %d", __func__, port->number);
 
-	/* shutdown our urbs */
-	dbg("%s - shutting down urbs", __func__);
-	usb_kill_urb(port->write_urb);
-	usb_kill_urb(port->read_urb);
+	usb_serial_generic_close(port);
 	usb_kill_urb(port->interrupt_in_urb);
 }
 
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 705a7e7..fa4fb5e 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -422,10 +422,7 @@ static void cp210x_close(struct usb_serial_port *port)
 {
 	dbg("%s - port %d", __func__, port->number);
 
-	/* shutdown our urbs */
-	dbg("%s - shutting down urbs", __func__);
-	usb_kill_urb(port->write_urb);
-	usb_kill_urb(port->read_urb);
+	usb_serial_generic_close(port);
 
 	mutex_lock(&port->serial->disc_mutex);
 	if (!port->serial->disconnected)
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index e0c7d53..0b4c7a6 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -178,6 +178,7 @@ void usb_serial_generic_close(struct usb_serial_port *port)
 	dbg("%s - port %d", __func__, port->number);
 	generic_cleanup(port);
 }
+EXPORT_SYMBOL_GPL(usb_serial_generic_close);
 
 static int usb_serial_multi_urb_write(struct tty_struct *tty,
 	struct usb_serial_port *port, const unsigned char *buf, int count)
diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index 2849f8c..7aa01b9 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -549,12 +549,9 @@ static void mct_u232_close(struct usb_serial_port *port)
 {
 	dbg("%s port %d", __func__, port->number);
 
-	if (port->serial->dev) {
-		/* shutdown our urbs */
-		usb_kill_urb(port->write_urb);
-		usb_kill_urb(port->read_urb);
+	usb_serial_generic_close(port);
+	if (port->serial->dev)
 		usb_kill_urb(port->interrupt_in_urb);
-	}
 } /* mct_u232_close */
 
 
-- 
1.7.0.2

