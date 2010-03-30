Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693Ab0CaA1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:27:41 -0400
Received: from kroah.org ([198.145.64.141]:48924 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445Ab0C3XMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:23 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:30 2010
Message-Id: <20100330225829.991965274@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johan Hovold <jhovold@gmail.com>, Greg KH <greg@kroah.com>,
       Jason Wessel <jason.wessel@windriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [35/89] usb: serial: fix memory leak in generic driver
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 2591530204a76fecc843529ade56afe865dd2657 upstream.

Fix a regression introduced by commit
715b1dc01fe44537e8fce9566e4bb48d6821d84b ("USB: usb_debug,
usb_generic_serial: implement multi urb write").

URB transfer buffer was never freed when using multi-urb writes.
Currently the only driver enabling multi-urb writes is usb_debug.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Cc: Greg KH <greg@kroah.com>
Acked-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/generic.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -480,6 +480,8 @@ void usb_serial_generic_write_bulk_callb
 	dbg("%s - port %d", __func__, port->number);
 
 	if (port->serial->type->max_in_flight_urbs) {
+		kfree(urb->transfer_buffer);
+
 		spin_lock_irqsave(&port->lock, flags);
 		--port->urbs_in_flight;
 		port->tx_bytes_flight -= urb->transfer_buffer_length;


