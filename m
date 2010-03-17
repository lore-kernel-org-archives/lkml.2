Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab0CQWBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:01:09 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:19821 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0CQWBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:01:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=O2koRomPTvtGab0bSRhJGkxUWR8KhKqOzJ2gucX2H0TfL98uHzqoBrqrEvB/VwghMf
         LoPFp/6dtn8Sye0FeKoNYB7HtvaWRu95tpA2PFh0lMYHGmyuRTp5WocAD1EJlru9gvv9
         0jJWrNJreAc/fBYqj3niMmB9Cz7Wf2M+6jhFg=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 1/9] USB: serial: allow drivers to define bulk buffer sizes
Date: Wed, 17 Mar 2010 23:00:37 +0100
Message-Id: <1268863245-17230-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
References: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow drivers to define custom bulk in/out buffer sizes in struct
usb_serial_driver. If not set, fall back to the default buffer size
which matches the endpoint size.

Three drivers are currently freeing the pre-allocated buffers and
allocating larger ones to achieve this at port probe (ftdi_sio) or even
at port open (ipaq and iuu_phoenix), which needless to say is suboptimal.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c    |   16 +---------------
 drivers/usb/serial/ipaq.c        |   28 ++--------------------------
 drivers/usb/serial/iuu_phoenix.c |   30 ++----------------------------
 drivers/usb/serial/usb-serial.c  |    8 ++++++--
 include/linux/usb/serial.h       |    5 +++++
 5 files changed, 16 insertions(+), 71 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 46a88ae..ab4ad18 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -768,9 +768,6 @@ static const char *ftdi_chip_name[] = {
 };
 
 
-/* Constants for read urb and write urb */
-#define BUFSZ 512
-
 /* Used for TIOCMIWAIT */
 #define FTDI_STATUS_B0_MASK	(FTDI_RS0_CTS | FTDI_RS0_DSR | FTDI_RS0_RI | FTDI_RS0_RLSD)
 #define FTDI_STATUS_B1_MASK	(FTDI_RS_BI)
@@ -821,6 +818,7 @@ static struct usb_serial_driver ftdi_sio_device = {
 	.usb_driver = 		&ftdi_driver,
 	.id_table =		id_table_combined,
 	.num_ports =		1,
+	.bulk_in_size =		512,
 	.probe =		ftdi_sio_probe,
 	.port_probe =		ftdi_sio_port_probe,
 	.port_remove =		ftdi_sio_port_remove,
@@ -1552,18 +1550,6 @@ static int ftdi_sio_port_probe(struct usb_serial_port *port)
 	if (quirk && quirk->port_probe)
 		quirk->port_probe(priv);
 
-	/* Increase the size of read buffers */
-	kfree(port->bulk_in_buffer);
-	port->bulk_in_buffer = kmalloc(BUFSZ, GFP_KERNEL);
-	if (!port->bulk_in_buffer) {
-		kfree(priv);
-		return -ENOMEM;
-	}
-	if (port->read_urb) {
-		port->read_urb->transfer_buffer = port->bulk_in_buffer;
-		port->read_urb->transfer_buffer_length = BUFSZ;
-	}
-
 	priv->port = port;
 
 	/* Free port's existing write urb and transfer buffer. */
diff --git a/drivers/usb/serial/ipaq.c b/drivers/usb/serial/ipaq.c
index 3fea929..87b1146 100644
--- a/drivers/usb/serial/ipaq.c
+++ b/drivers/usb/serial/ipaq.c
@@ -571,6 +571,8 @@ static struct usb_serial_driver ipaq_device = {
 	.description =		"PocketPC PDA",
 	.usb_driver = 		&ipaq_driver,
 	.id_table =		ipaq_id_table,
+	.bulk_in_size =		URBDATA_SIZE,
+	.bulk_out_size =	URBDATA_SIZE,
 	.open =			ipaq_open,
 	.close =		ipaq_close,
 	.attach =		ipaq_startup,
@@ -628,32 +630,6 @@ static int ipaq_open(struct tty_struct *tty,
 		priv->free_len += PACKET_SIZE;
 	}
 
-	/*
-	 * Lose the small buffers usbserial provides. Make larger ones.
-	 */
-
-	kfree(port->bulk_in_buffer);
-	kfree(port->bulk_out_buffer);
-	/* make sure the generic serial code knows */
-	port->bulk_out_buffer = NULL;
-
-	port->bulk_in_buffer = kmalloc(URBDATA_SIZE, GFP_KERNEL);
-	if (port->bulk_in_buffer == NULL)
-		goto enomem;
-
-	port->bulk_out_buffer = kmalloc(URBDATA_SIZE, GFP_KERNEL);
-	if (port->bulk_out_buffer == NULL) {
-		/* the buffer is useless, free it */
-		kfree(port->bulk_in_buffer);
-		port->bulk_in_buffer = NULL;
-		goto enomem;
-	}
-	port->read_urb->transfer_buffer = port->bulk_in_buffer;
-	port->write_urb->transfer_buffer = port->bulk_out_buffer;
-	port->read_urb->transfer_buffer_length = URBDATA_SIZE;
-	port->bulk_out_size = port->write_urb->transfer_buffer_length
-							= URBDATA_SIZE;
-
 	msleep(1000*initial_wait);
 
 	/*
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index 43f13cf..74551cb 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -1044,34 +1044,6 @@ static int iuu_open(struct tty_struct *tty, struct usb_serial_port *port)
 	if (buf == NULL)
 		return -ENOMEM;
 
-	/* fixup the endpoint buffer size */
-	kfree(port->bulk_out_buffer);
-	port->bulk_out_buffer = kmalloc(512, GFP_KERNEL);
-	port->bulk_out_size = 512;
-	kfree(port->bulk_in_buffer);
-	port->bulk_in_buffer = kmalloc(512, GFP_KERNEL);
-	port->bulk_in_size = 512;
-
-	if (!port->bulk_out_buffer || !port->bulk_in_buffer) {
-		kfree(port->bulk_out_buffer);
-		kfree(port->bulk_in_buffer);
-		kfree(buf);
-		return -ENOMEM;
-	}
-
-	usb_fill_bulk_urb(port->write_urb, port->serial->dev,
-			  usb_sndbulkpipe(port->serial->dev,
-					  port->bulk_out_endpointAddress),
-			  port->bulk_out_buffer, 512,
-			  NULL, NULL);
-
-
-	usb_fill_bulk_urb(port->read_urb, port->serial->dev,
-			  usb_rcvbulkpipe(port->serial->dev,
-					  port->bulk_in_endpointAddress),
-			  port->bulk_in_buffer, 512,
-			  NULL, NULL);
-
 	priv->poll = 0;
 
 	/* initialize writebuf */
@@ -1277,6 +1249,8 @@ static struct usb_serial_driver iuu_device = {
 		   },
 	.id_table = id_table,
 	.num_ports = 1,
+	.bulk_in_size = 512,
+	.bulk_out_size = 512,
 	.port_probe = iuu_create_sysfs_attrs,
 	.port_remove = iuu_remove_sysfs_attrs,
 	.open = iuu_open,
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index f3f6517..5389246 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -901,7 +901,9 @@ int usb_serial_probe(struct usb_interface *interface,
 			dev_err(&interface->dev, "No free urbs available\n");
 			goto probe_error;
 		}
-		buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
+		buffer_size = serial->type->bulk_in_size;
+		if (!buffer_size)
+			buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
 		port->bulk_in_size = buffer_size;
 		port->bulk_in_endpointAddress = endpoint->bEndpointAddress;
 		port->bulk_in_buffer = kmalloc(buffer_size, GFP_KERNEL);
@@ -927,7 +929,9 @@ int usb_serial_probe(struct usb_interface *interface,
 		}
 		if (kfifo_alloc(&port->write_fifo, PAGE_SIZE, GFP_KERNEL))
 			goto probe_error;
-		buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
+		buffer_size = serial->type->bulk_out_size;
+		if (!buffer_size)
+			buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
 		port->bulk_out_size = buffer_size;
 		port->bulk_out_endpointAddress = endpoint->bEndpointAddress;
 		port->bulk_out_buffer = kmalloc(buffer_size, GFP_KERNEL);
diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index b7682fe..ab311da 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -179,6 +179,8 @@ static inline void usb_set_serial_data(struct usb_serial *serial, void *data)
  * @id_table: pointer to a list of usb_device_id structures that define all
  *	of the devices this structure can support.
  * @num_ports: the number of different ports this device will have.
+ * @bulk_in_size: bytes to allocate for bulk-in buffer (0 = end-point size)
+ * @bulk_out_size: bytes to allocate for bulk-out buffer (0 = end-point size)
  * @calc_num_ports: pointer to a function to determine how many ports this
  *	device has dynamically.  It will be called after the probe()
  *	callback is called, but before attach()
@@ -223,6 +225,9 @@ struct usb_serial_driver {
 	struct usb_dynids	dynids;
 	int			max_in_flight_urbs;
 
+	size_t			bulk_in_size;
+	size_t			bulk_out_size;
+
 	int (*probe)(struct usb_serial *serial, const struct usb_device_id *id);
 	int (*attach)(struct usb_serial *serial);
 	int (*calc_num_ports) (struct usb_serial *serial);
-- 
1.7.0.2

