Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab0CQWHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:07:50 -0400
Received: from mail-ew0-f221.google.com ([209.85.219.221]:36574 "EHLO
	mail-ew0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab0CQWHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:07:46 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Mar 2010 18:06:09 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fOccKFk9u8RIzhcJeUJ/4NgckpXk8Idmmv3DcIE8lovyF56ASifEjznkd9LTv6Hyb1
         IkO+f0O+wDo0IokFQqkewtEsBMTTMSn85Jnfu0NVgKwhsQJHKG9sDS4vjTHR6JaGE/01
         t/x+YJHAT4aFyB/XmHpYpxp5NgjIJINfEyx7A=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 8/9] USB: serial: clear fifo on close
Date: Wed, 17 Mar 2010 23:00:44 +0100
Message-Id: <1268863245-17230-9-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
References: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure fifo is emptied on close.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/generic.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index d3ef69f..e0c7d53 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -155,13 +155,19 @@ EXPORT_SYMBOL_GPL(usb_serial_generic_open);
 static void generic_cleanup(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
+	unsigned long flags;
 
 	dbg("%s - port %d", __func__, port->number);
 
 	if (serial->dev) {
 		/* shutdown any bulk transfers that might be going on */
-		if (port->bulk_out_size)
+		if (port->bulk_out_size) {
 			usb_kill_urb(port->write_urb);
+
+			spin_lock_irqsave(&port->lock, flags);
+			kfifo_reset_out(&port->write_fifo);
+			spin_unlock_irqrestore(&port->lock, flags);
+		}
 		if (port->bulk_in_size)
 			usb_kill_urb(port->read_urb);
 	}
-- 
1.7.0.2

