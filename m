Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab0GASu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:50:59 -0400
Received: from kroah.org ([198.145.64.141]:35411 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757663Ab0GASWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:22:54 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:09 2010
Message-Id: <20100701173209.087451484@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:30:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johan Hovold <jhovold@gmail.com>
Subject: [patch 027/149] USB: kobil: fix memory leak
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit c0f631d1948658b27349545b2cbcb4b32f010c7a upstream.

An urb transfer buffer is allocated at every open but was never freed.

This driver is a bit of a mess...

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/kobil_sct.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -345,7 +345,8 @@ static void kobil_close(struct usb_seria
 
 	/* FIXME: Add rts/dtr methods */
 	if (port->write_urb) {
-		usb_kill_urb(port->write_urb);
+		usb_poison_urb(port->write_urb);
+		kfree(port->write_urb->transfer_buffer);
 		usb_free_urb(port->write_urb);
 		port->write_urb = NULL;
 	}


