Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab2FTSiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:38:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45916 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757691Ab2FTSWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:22:06 -0400
Message-Id: <20120620173023.015928307@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johan Hovold <jhovold@gmail.com>
Subject: [ 24/61] USB: option: fix port-data abuse
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 4273f9878b0a8271df055e3c8f2e7f08c6a4a2f4 upstream.

Commit 8b4c6a3ab596961b78465 ("USB: option: Use generic USB wwan code")
moved option port-data allocation to usb_wwan_startup but still cast the
port data to the old struct...

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |   34 +++-------------------------------
 1 file changed, 3 insertions(+), 31 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1288,35 +1288,6 @@ static struct usb_serial_driver * const
 
 static bool debug;
 
-/* per port private data */
-
-#define N_IN_URB 4
-#define N_OUT_URB 4
-#define IN_BUFLEN 4096
-#define OUT_BUFLEN 4096
-
-struct option_port_private {
-	/* Input endpoints and buffer for this port */
-	struct urb *in_urbs[N_IN_URB];
-	u8 *in_buffer[N_IN_URB];
-	/* Output endpoints and buffer for this port */
-	struct urb *out_urbs[N_OUT_URB];
-	u8 *out_buffer[N_OUT_URB];
-	unsigned long out_busy;		/* Bit vector of URBs in use */
-	int opened;
-	struct usb_anchor delayed;
-
-	/* Settings for the port */
-	int rts_state;	/* Handshaking pins (outputs) */
-	int dtr_state;
-	int cts_state;	/* Handshaking pins (inputs) */
-	int dsr_state;
-	int dcd_state;
-	int ri_state;
-
-	unsigned long tx_start_time[N_OUT_URB];
-};
-
 module_usb_serial_driver(option_driver, serial_drivers);
 
 static bool is_blacklisted(const u8 ifnum, enum option_blacklist_reason reason,
@@ -1399,7 +1370,8 @@ static void option_instat_callback(struc
 	int err;
 	int status = urb->status;
 	struct usb_serial_port *port =  urb->context;
-	struct option_port_private *portdata = usb_get_serial_port_data(port);
+	struct usb_wwan_port_private *portdata =
+					usb_get_serial_port_data(port);
 
 	dbg("%s", __func__);
 	dbg("%s: urb %p port %p has data %p", __func__, urb, port, portdata);
@@ -1460,7 +1432,7 @@ static int option_send_setup(struct usb_
 	struct usb_serial *serial = port->serial;
 	struct usb_wwan_intf_private *intfdata =
 		(struct usb_wwan_intf_private *) serial->private;
-	struct option_port_private *portdata;
+	struct usb_wwan_port_private *portdata;
 	int ifNum = serial->interface->cur_altsetting->desc.bInterfaceNumber;
 	int val = 0;
 	dbg("%s", __func__);


