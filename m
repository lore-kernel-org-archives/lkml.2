Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab1CUXSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:18:04 -0400
Received: from kroah.org ([198.145.64.141]:52587 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697Ab1CUXRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:17:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:24 2011
Message-Id: <20110321230324.266545551@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:01:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [25/78] USB: serial drivers need to use larger bulk-in buffers
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 969e3033ae7733a0af8f7742ca74cd16c0857e71 upstream.

When a driver doesn't know how much data a device is going to send,
the buffer size should be at least as big as the endpoint's maxpacket
value.  The serial drivers don't follow this rule; many of them
request only 256-byte bulk-in buffers.  As a result, they suffer
overflow errors if a high-speed device wants to send a lot of data,
because high-speed bulk endpoints are required to have a maxpacket
size of 512.

This patch (as1450) fixes the problem by using the driver's
bulk_in_size value as a minimum, always allocating buffers no smaller
than the endpoint's maxpacket size.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Flynn Marquardt <flynn@flynnux.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb-serial.c |    5 ++---
 include/linux/usb/serial.h      |    3 ++-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -911,9 +911,8 @@ int usb_serial_probe(struct usb_interfac
 			dev_err(&interface->dev, "No free urbs available\n");
 			goto probe_error;
 		}
-		buffer_size = serial->type->bulk_in_size;
-		if (!buffer_size)
-			buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
+		buffer_size = max_t(int, serial->type->bulk_in_size,
+				le16_to_cpu(endpoint->wMaxPacketSize));
 		port->bulk_in_size = buffer_size;
 		port->bulk_in_endpointAddress = endpoint->bEndpointAddress;
 		port->bulk_in_buffer = kmalloc(buffer_size, GFP_KERNEL);
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -191,7 +191,8 @@ static inline void usb_set_serial_data(s
  * @id_table: pointer to a list of usb_device_id structures that define all
  *	of the devices this structure can support.
  * @num_ports: the number of different ports this device will have.
- * @bulk_in_size: bytes to allocate for bulk-in buffer (0 = end-point size)
+ * @bulk_in_size: minimum number of bytes to allocate for bulk-in buffer
+ *	(0 = end-point size)
  * @bulk_out_size: bytes to allocate for bulk-out buffer (0 = end-point size)
  * @calc_num_ports: pointer to a function to determine how many ports this
  *	device has dynamically.  It will be called after the probe()


