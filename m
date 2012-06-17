Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab2FQSgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:36:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50210 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758095Ab2FQSWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:38 -0400
Message-Id: <20120617175949.130460490@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 54/69] USB: option: fix port-data abuse
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 4273f9878b0a8271df055e3c8f2e7f08c6a4a2f4 upstream.

Commit 8b4c6a3ab596961b78465 ("USB: option: Use generic USB wwan code")
moved option port-data allocation to usb_wwan_startup but still cast the
port data to the old struct...

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/option.c |   34 +++-------------------------------
 1 file changed, 3 insertions(+), 31 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1273,35 +1273,6 @@
 
 static int debug;
 
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
 /* Functions used by new usb-serial code. */
 static int __init option_init(void)
 {
@@ -1404,7 +1375,8 @@
 	int err;
 	int status = urb->status;
 	struct usb_serial_port *port =  urb->context;
-	struct option_port_private *portdata = usb_get_serial_port_data(port);
+	struct usb_wwan_port_private *portdata =
+					usb_get_serial_port_data(port);
 
 	dbg("%s", __func__);
 	dbg("%s: urb %p port %p has data %p", __func__, urb, port, portdata);
@@ -1465,7 +1437,7 @@
 	struct usb_serial *serial = port->serial;
 	struct usb_wwan_intf_private *intfdata =
 		(struct usb_wwan_intf_private *) serial->private;
-	struct option_port_private *portdata;
+	struct usb_wwan_port_private *portdata;
 	int ifNum = serial->interface->cur_altsetting->desc.bInterfaceNumber;
 	int val = 0;
 	dbg("%s", __func__);


