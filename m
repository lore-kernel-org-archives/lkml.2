Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161951Ab1FAIQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:16:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161945Ab1FAIQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:16:06 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:04:19 2011
Message-Id: <20110601080418.059590021@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:45 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Erik Slagter <erik@slagter.name>,
        "Maxin B. John" <maxin.john@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [109/146] USB: cdc_acm: Fix oops when Droids MuIn LCD is connected
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Erik Slagter <erik@slagter.name>

commit fd5054c169d29747a44b4e1419ff47f57ae82dbc upstream.

The Droids MuIn LCD operates like a serial remote terminal.
Data received are displayed directly on the LCD. This patch
fixes the kernel null pointer oops when it is plugged in.

Add NO_DATA_INTERFACE quirk to tell the driver that "control"
and "data" interfaces are not separated for this device, which
prevents dereferencing a null pointer in the device probe code.

Signed-off-by: Erik Slagter <erik@slagter.name>
Signed-off-by: Maxin B. John <maxin.john@gmail.com>
Tested-by: Erik Slagter <erik@slagter.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |   13 +++++++++++--
 drivers/usb/class/cdc-acm.h |    1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -946,7 +946,7 @@ static int acm_probe(struct usb_interfac
 	u8 ac_management_function = 0;
 	u8 call_management_function = 0;
 	int call_interface_num = -1;
-	int data_interface_num;
+	int data_interface_num = -1;
 	unsigned long quirks;
 	int num_rx_buf;
 	int i;
@@ -1030,7 +1030,11 @@ next_desc:
 	if (!union_header) {
 		if (call_interface_num > 0) {
 			dev_dbg(&intf->dev, "No union descriptor, using call management descriptor\n");
-			data_interface = usb_ifnum_to_if(usb_dev, (data_interface_num = call_interface_num));
+			/* quirks for Droids MuIn LCD */
+			if (quirks & NO_DATA_INTERFACE)
+				data_interface = usb_ifnum_to_if(usb_dev, 0);
+			else
+				data_interface = usb_ifnum_to_if(usb_dev, (data_interface_num = call_interface_num));
 			control_interface = intf;
 		} else {
 			if (intf->cur_altsetting->desc.bNumEndpoints != 3) {
@@ -1622,6 +1626,11 @@ static const struct usb_device_id acm_id
 	.driver_info = NOT_A_MODEM,
 	},
 
+	/* Support for Droids MuIn LCD */
+	{ USB_DEVICE(0x04d8, 0x000b),
+	.driver_info = NO_DATA_INTERFACE,
+	},
+
 	/* control interfaces without any protocol set */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,
 		USB_CDC_PROTO_NONE) },
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -137,3 +137,4 @@ struct acm {
 #define SINGLE_RX_URB			2
 #define NO_CAP_LINE			4
 #define NOT_A_MODEM			8
+#define NO_DATA_INTERFACE		16


