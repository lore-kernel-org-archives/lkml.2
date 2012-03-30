Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965668Ab2C3VTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:19:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965758Ab2C3VTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:19:11 -0400
Message-Id: <20120330194832.154072106@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Donald Lee <donald@asix.com.tw>
Subject: [ 041/175] USB: serial: mos7840: Fixed MCS7820 device attach problem
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donald Lee <donald@asix.com.tw>

commit 093ea2d3a766cb8a4c4de57efec6c0a127a58792 upstream.

A MCS7820 device supports two serial ports and a MCS7840 device supports
four serial ports. Both devices use the same driver, but the attach function
in driver was unable to correctly handle the port numbers for MCS7820
device. This problem has been fixed in this patch and this fix has been
verified on x86 Linux kernel 3.2.9 with both MCS7820 and MCS7840 devices.

Signed-off-by: Donald Lee <donald@asix.com.tw>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |   81 +++++++++++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 25 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -174,6 +174,7 @@
 
 #define CLK_MULTI_REGISTER         ((__u16)(0x02))
 #define CLK_START_VALUE_REGISTER   ((__u16)(0x03))
+#define GPIO_REGISTER              ((__u16)(0x07))
 
 #define SERIAL_LCR_DLAB            ((__u16)(0x0080))
 
@@ -1101,14 +1102,25 @@ static int mos7840_open(struct tty_struc
 	mos7840_port->read_urb = port->read_urb;
 
 	/* set up our bulk in urb */
-
-	usb_fill_bulk_urb(mos7840_port->read_urb,
-			  serial->dev,
-			  usb_rcvbulkpipe(serial->dev,
-					  port->bulk_in_endpointAddress),
-			  port->bulk_in_buffer,
-			  mos7840_port->read_urb->transfer_buffer_length,
-			  mos7840_bulk_in_callback, mos7840_port);
+	if ((serial->num_ports == 2)
+		&& ((((__u16)port->number -
+			(__u16)(port->serial->minor)) % 2) != 0)) {
+		usb_fill_bulk_urb(mos7840_port->read_urb,
+			serial->dev,
+			usb_rcvbulkpipe(serial->dev,
+				(port->bulk_in_endpointAddress) + 2),
+			port->bulk_in_buffer,
+			mos7840_port->read_urb->transfer_buffer_length,
+			mos7840_bulk_in_callback, mos7840_port);
+	} else {
+		usb_fill_bulk_urb(mos7840_port->read_urb,
+			serial->dev,
+			usb_rcvbulkpipe(serial->dev,
+				port->bulk_in_endpointAddress),
+			port->bulk_in_buffer,
+			mos7840_port->read_urb->transfer_buffer_length,
+			mos7840_bulk_in_callback, mos7840_port);
+	}
 
 	dbg("mos7840_open: bulkin endpoint is %d",
 	    port->bulk_in_endpointAddress);
@@ -1519,13 +1531,25 @@ static int mos7840_write(struct tty_stru
 	memcpy(urb->transfer_buffer, current_position, transfer_size);
 
 	/* fill urb with data and submit  */
-	usb_fill_bulk_urb(urb,
-			  serial->dev,
-			  usb_sndbulkpipe(serial->dev,
-					  port->bulk_out_endpointAddress),
-			  urb->transfer_buffer,
-			  transfer_size,
-			  mos7840_bulk_out_data_callback, mos7840_port);
+	if ((serial->num_ports == 2)
+		&& ((((__u16)port->number -
+			(__u16)(port->serial->minor)) % 2) != 0)) {
+		usb_fill_bulk_urb(urb,
+			serial->dev,
+			usb_sndbulkpipe(serial->dev,
+				(port->bulk_out_endpointAddress) + 2),
+			urb->transfer_buffer,
+			transfer_size,
+			mos7840_bulk_out_data_callback, mos7840_port);
+	} else {
+		usb_fill_bulk_urb(urb,
+			serial->dev,
+			usb_sndbulkpipe(serial->dev,
+				port->bulk_out_endpointAddress),
+			urb->transfer_buffer,
+			transfer_size,
+			mos7840_bulk_out_data_callback, mos7840_port);
+	}
 
 	data1 = urb->transfer_buffer;
 	dbg("bulkout endpoint is %d", port->bulk_out_endpointAddress);
@@ -1838,7 +1862,7 @@ static int mos7840_send_cmd_write_baud_r
 
 	} else {
 #ifdef HW_flow_control
-		/ *setting h/w flow control bit to 0 */
+		/* setting h/w flow control bit to 0 */
 		Data = 0xb;
 		mos7840_port->shadowMCR = Data;
 		status = mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER,
@@ -2305,19 +2329,26 @@ static int mos7840_ioctl(struct tty_stru
 
 static int mos7840_calc_num_ports(struct usb_serial *serial)
 {
-	int mos7840_num_ports = 0;
+	__u16 Data = 0x00;
+	int ret = 0;
+	int mos7840_num_ports;
 
-	dbg("numberofendpoints: cur %d, alt %d",
-	    (int)serial->interface->cur_altsetting->desc.bNumEndpoints,
-	    (int)serial->interface->altsetting->desc.bNumEndpoints);
-	if (serial->interface->cur_altsetting->desc.bNumEndpoints == 5) {
-		mos7840_num_ports = serial->num_ports = 2;
-	} else if (serial->interface->cur_altsetting->desc.bNumEndpoints == 9) {
+	ret = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+		MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, &Data,
+		VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT);
+
+	if ((Data & 0x01) == 0) {
+		mos7840_num_ports = 2;
+		serial->num_bulk_in = 2;
+		serial->num_bulk_out = 2;
+		serial->num_ports = 2;
+	} else {
+		mos7840_num_ports = 4;
 		serial->num_bulk_in = 4;
 		serial->num_bulk_out = 4;
-		mos7840_num_ports = serial->num_ports = 4;
+		serial->num_ports = 4;
 	}
-	dbg ("mos7840_num_ports = %d", mos7840_num_ports);
+
 	return mos7840_num_ports;
 }
 


