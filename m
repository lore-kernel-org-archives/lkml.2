Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab0CQWHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:07:19 -0400
Received: from mail-ew0-f221.google.com ([209.85.219.221]:36574 "EHLO
	mail-ew0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab0CQWHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:07:15 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Mar 2010 18:06:09 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=c/F1+udSZAbWI8NK5KAq/4Io2BFsDAk/A4m59mTdVSj574ZUvii4ca+x4Gfy1T0swl
         Kdzx50AdxvLtjkWdw7QGeWXPYHbzWN+ZLhQjCKJxIXKq8Id5DvmmfgHfv8LnQQkOH29G
         OG+c4rNpt0GdvnFHE+/eLncwqcuFZgEOIX5T4=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 7/9] USB: serial: fix missing locking on fifo in write callback
Date: Wed, 17 Mar 2010 23:00:43 +0100
Message-Id: <1268863245-17230-8-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
References: <1268863245-17230-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On errors the fifo was reset without any locking. This could race with
write which do kfifo_put and perhaps also chars_in_buffer and write_room.

Every other access to the fifo is protected using the port lock so
better add it to the error path as well.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/generic.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 8d6d790..d3ef69f 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -518,10 +518,13 @@ void usb_serial_generic_write_bulk_callback(struct urb *urb)
 		port->write_urb_busy = 0;
 		spin_unlock_irqrestore(&port->lock, flags);
 
-		if (status)
+		if (status) {
+			spin_lock_irqsave(&port->lock, flags);
 			kfifo_reset_out(&port->write_fifo);
-		else
+			spin_unlock_irqrestore(&port->lock, flags);
+		} else {
 			usb_serial_generic_write_start(port);
+		}
 	}
 
 	if (status)
-- 
1.7.0.2

