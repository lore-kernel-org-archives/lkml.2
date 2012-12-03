Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab2LCOhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:37:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43973 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932459Ab2LCOhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:37:05 -0500
Message-Id: <20121203143151.478673837@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:14 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Safrata <jan.nikitenko@gmail.com>,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 28/89] usb: use usb_serial_put in usb_serial_probe errors
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Safrata <jan.nikitenko@gmail.com>

commit 0658a3366db7e27fa32c12e886230bb58c414c92 upstream.

The use of kfree(serial) in error cases of usb_serial_probe
was invalid - usb_serial structure allocated in create_serial()
gets reference of usb_device that needs to be put, so we need
to use usb_serial_put() instead of simple kfree().

Signed-off-by: Jan Safrata <jan.nikitenko@gmail.com>
Acked-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/usb-serial.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 6e8c527..27483f9 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -757,7 +757,7 @@ static int usb_serial_probe(struct usb_interface *interface,
 
 		if (retval) {
 			dbg("sub driver rejected device");
-			kfree(serial);
+			usb_serial_put(serial);
 			module_put(type->driver.owner);
 			return retval;
 		}
@@ -829,7 +829,7 @@ static int usb_serial_probe(struct usb_interface *interface,
 		 */
 		if (num_bulk_in == 0 || num_bulk_out == 0) {
 			dev_info(&interface->dev, "PL-2303 hack: descriptors matched but endpoints did not\n");
-			kfree(serial);
+			usb_serial_put(serial);
 			module_put(type->driver.owner);
 			return -ENODEV;
 		}
@@ -843,7 +843,7 @@ static int usb_serial_probe(struct usb_interface *interface,
 		if (num_ports == 0) {
 			dev_err(&interface->dev,
 			    "Generic device with no bulk out, not allowed.\n");
-			kfree(serial);
+			usb_serial_put(serial);
 			module_put(type->driver.owner);
 			return -EIO;
 		}


