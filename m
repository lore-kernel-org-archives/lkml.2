Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab0KSWEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:04:24 -0500
Received: from kroah.org ([198.145.64.141]:52934 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758065Ab0KSWEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:16 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:24 2010
Message-Id: <20101119220124.389582020@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:00:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [27/66] USB: mct_u232: fix broken close
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 92ca0dc5ee022e4c0e488177e1d8865a0778c6c2 upstream.

Fix regression introduced by commit
f26788da3b342099d2b02d99ba1cb7f154d6ef7b (USB: serial: refactor generic
close) which broke driver close().

This driver uses non-standard semantics for the read urb which makes the
generic close function fail to kill it (the read urb is actually an
interrupt urb and therefore bulk_in size is zero).

Reported-by: Eric Shattow "Eprecocious" <lucent@gmail.com>
Tested-by: Eric Shattow "Eprecocious" <lucent@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/mct_u232.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -549,9 +549,12 @@ static void mct_u232_close(struct usb_se
 {
 	dbg("%s port %d", __func__, port->number);
 
-	usb_serial_generic_close(port);
-	if (port->serial->dev)
+	if (port->serial->dev) {
+		/* shutdown our urbs */
+		usb_kill_urb(port->write_urb);
+		usb_kill_urb(port->read_urb);
 		usb_kill_urb(port->interrupt_in_urb);
+	}
 } /* mct_u232_close */
 
 


