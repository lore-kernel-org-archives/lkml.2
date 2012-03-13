Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759736Ab2CMH6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:58:32 -0400
Received: from asix.com.tw ([113.196.140.82]:54260 "EHLO asix.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401Ab2CMH6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:58:31 -0400
From: "Donald" <donald@asix.com.tw>
To: "'Greg KH'" <gregkh@linuxfoundation.org>,
        "'open list:USB SUBSYSTEM'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] x86: Fixed MCS7820 device attach problem
Date: Tue, 13 Mar 2012 15:54:46 +0800
Message-ID: <009c01cd00ee$924eb2e0$b6ec18a0$@com.tw>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac0A7o60BTdSYFNJQbCJl3orm4JzWA==
Content-Language: zh-tw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A MCS7820 device supports two serial ports and a MCS7840 device supports
four serial ports. Both devices use the same driver, but the attach function
in driver was unable to correctly handle the port numbers for MCS7820
device. This problem has been fixed in this patch and this fix has been
verified on x86 Linux kernel 3.2.9 with both MCS7820 and MCS7840 devices.

Signed-off-by: Donald Lee <donald@asix.com.tw> 

--- 
 drivers/usb/serial/mos7840.c |   83
+++++++++++++++++++++++++++++------------- 
 1 files changed, 57 insertions(+), 26 deletions(-) 
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c 
index c72abd5..e4885b6 100644 
--- a/drivers/usb/serial/mos7840.c 
+++ b/drivers/usb/serial/mos7840.c 
@@ -174,6 +174,7 @@ 
  
 #define CLK_MULTI_REGISTER         ((__u16)(0x02)) 
 #define CLK_START_VALUE_REGISTER   ((__u16)(0x03)) 
+#define GPIO_REGISTER              ((__u16)(0x07)) 
  
 #define SERIAL_LCR_DLAB            ((__u16)(0x0080)) 
  
@@ -1103,14 +1104,25 @@ static int mos7840_open(struct tty_struct *tty,
struct usb_serial_port *port) 
        mos7840_port->read_urb = port->read_urb; 
  
        /* set up our bulk in urb */ 
- 
-       usb_fill_bulk_urb(mos7840_port->read_urb, 
-                         serial->dev, 
-                         usb_rcvbulkpipe(serial->dev, 
-                                         port->bulk_in_endpointAddress), 
-                         port->bulk_in_buffer, 
-                         mos7840_port->read_urb->transfer_buffer_length, 
-                         mos7840_bulk_in_callback, mos7840_port); 
+       if ((serial->num_ports == 2) 
+               && ((((__u16)port->number - 
+                       (__u16)(port->serial->minor)) % 2) != 0)) { 
+               usb_fill_bulk_urb(mos7840_port->read_urb, 
+                       serial->dev, 
+                       usb_rcvbulkpipe(serial->dev, 
+                               (port->bulk_in_endpointAddress) + 2), 
+                       port->bulk_in_buffer, 
+                       mos7840_port->read_urb->transfer_buffer_length, 
+                       mos7840_bulk_in_callback, mos7840_port); 
+       } else { 
+               usb_fill_bulk_urb(mos7840_port->read_urb, 
+                       serial->dev, 
+                       usb_rcvbulkpipe(serial->dev, 
+                               port->bulk_in_endpointAddress), 
+                       port->bulk_in_buffer, 
+                       mos7840_port->read_urb->transfer_buffer_length, 
+                       mos7840_bulk_in_callback, mos7840_port); 
+       } 
  
        dbg("mos7840_open: bulkin endpoint is %d", 
            port->bulk_in_endpointAddress); 
@@ -1521,13 +1533,25 @@ static int mos7840_write(struct tty_struct *tty,
struct usb_serial_port *port, 
        memcpy(urb->transfer_buffer, current_position, transfer_size); 
  
        /* fill urb with data and submit  */ 
-       usb_fill_bulk_urb(urb, 
-                         serial->dev, 
-                         usb_sndbulkpipe(serial->dev, 
-                                         port->bulk_out_endpointAddress), 
-                         urb->transfer_buffer, 
-                         transfer_size, 
-                         mos7840_bulk_out_data_callback, mos7840_port); 
+       if ((serial->num_ports == 2) 
+               && ((((__u16)port->number - 
+                       (__u16)(port->serial->minor)) % 2) != 0)) { 
+               usb_fill_bulk_urb(urb, 
+                       serial->dev, 
+                       usb_sndbulkpipe(serial->dev, 
+                               (port->bulk_out_endpointAddress) + 2), 
+                       urb->transfer_buffer, 
+                       transfer_size, 
+                       mos7840_bulk_out_data_callback, mos7840_port); 
+       } else { 
+               usb_fill_bulk_urb(urb, 
+                       serial->dev, 
+                       usb_sndbulkpipe(serial->dev, 
+                               port->bulk_out_endpointAddress), 
+                       urb->transfer_buffer, 
+                       transfer_size, 
+                       mos7840_bulk_out_data_callback, mos7840_port); 
+       } 
  
        data1 = urb->transfer_buffer; 
        dbg("bulkout endpoint is %d", port->bulk_out_endpointAddress); 
@@ -1840,7 +1864,7 @@ static int mos7840_send_cmd_write_baud_rate(struct
moschip_port *mos7840_port, 
  
        } else { 
 #ifdef HW_flow_control 
-               / *setting h/w flow control bit to 0 */ 
+               /* setting h/w flow control bit to 0 */ 
                Data = 0xb; 
                mos7840_port->shadowMCR = Data; 
                status = mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER, 
@@ -2309,19 +2333,26 @@ static int mos7840_ioctl(struct tty_struct *tty, 
  
 static int mos7840_calc_num_ports(struct usb_serial *serial) 
 { 
-       int mos7840_num_ports = 0; 
- 
-       dbg("numberofendpoints: cur %d, alt %d", 
-           (int)serial->interface->cur_altsetting->desc.bNumEndpoints, 
-           (int)serial->interface->altsetting->desc.bNumEndpoints); 
-       if (serial->interface->cur_altsetting->desc.bNumEndpoints == 5) { 
-               mos7840_num_ports = serial->num_ports = 2; 
-       } else if (serial->interface->cur_altsetting->desc.bNumEndpoints ==
9) { 
+       __u16 Data = 0x00; 
+       int ret = 0; 
+       int mos7840_num_ports; 
+ 
+       ret = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0), 
+               MCS_RDREQ, MCS_RD_RTYPE, 0, GPIO_REGISTER, &Data, 
+               VENDOR_READ_LENGTH, MOS_WDR_TIMEOUT); 
+ 
+       if ((Data&0x01) == 0) { 
+               mos7840_num_ports = 2; 
+               serial->num_bulk_in = 2; 
+               serial->num_bulk_out = 2; 
+               serial->num_ports = 2; 
+       } else { 
+               mos7840_num_ports = 4; 
                serial->num_bulk_in = 4; 
                serial->num_bulk_out = 4; 
-               mos7840_num_ports = serial->num_ports = 4; 
+               serial->num_ports = 4; 
        } 
-       dbg ("mos7840_num_ports = %d", mos7840_num_ports); 
+ 
        return mos7840_num_ports; 
 } 
  
-- 
1.7.7.6


