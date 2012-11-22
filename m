Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab2KVVv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:51:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:49649 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972Ab2KVSkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jan Safrata <jan.nikitenko@gmail.com>,
        Johan Hovold <jhovold@gmail.com>,
        Richard Retanubun <richardretanubun@ruggedcom.com>
Subject: [ 044/171] usb: use usb_serial_put in usb_serial_probe errors
Date: Wed, 21 Nov 2012 16:39:50 -0800
Message-Id: <20121122004037.788788000@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Safrata <jan.nikitenko@gmail.com>

commit 0658a3366db7e27fa32c12e886230bb58c414c92 upstream.

The use of kfree(serial) in error cases of usb_serial_probe
was invalid - usb_serial structure allocated in create_serial()
gets reference of usb_device that needs to be put, so we need
to use usb_serial_put() instead of simple kfree().

Signed-off-by: Jan Safrata <jan.nikitenko@gmail.com>
Acked-by: Johan Hovold <jhovold@gmail.com>
Cc: Richard Retanubun <richardretanubun@ruggedcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/usb-serial.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -768,7 +768,7 @@ int usb_serial_probe(struct usb_interfac
 
 		if (retval) {
 			dbg("sub driver rejected device");
-			kfree(serial);
+			usb_serial_put(serial);
 			module_put(type->driver.owner);
 			return retval;
 		}
@@ -840,7 +840,7 @@ int usb_serial_probe(struct usb_interfac
 		 */
 		if (num_bulk_in == 0 || num_bulk_out == 0) {
 			dev_info(&interface->dev, "PL-2303 hack: descriptors matched but endpoints did not\n");
-			kfree(serial);
+			usb_serial_put(serial);
 			module_put(type->driver.owner);
 			return -ENODEV;
 		}
@@ -854,7 +854,7 @@ int usb_serial_probe(struct usb_interfac
 		if (num_ports == 0) {
 			dev_err(&interface->dev,
 			    "Generic device with no bulk out, not allowed.\n");
-			kfree(serial);
+			usb_serial_put(serial);
 			module_put(type->driver.owner);
 			return -EIO;
 		}


