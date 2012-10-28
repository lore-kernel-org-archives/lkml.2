Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab2J1X1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:27:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41893 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756537Ab2J1X1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:23 -0400
Message-Id: <20121028231603.046691837@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:17:00 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 084/105] USB: sierra: fix memory leak in attach error path
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 7e41f9bcdd2e813ea2a3c40db291d87ea06b559f upstream.

Make sure port private data is deallocated on errors in attach.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/sierra.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 76ef95b..2cb27e4 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -905,7 +905,7 @@ static int sierra_startup(struct usb_serial *serial)
 			dev_dbg(&port->dev, "%s: kmalloc for "
 				"sierra_port_private (%d) failed!\n",
 				__func__, i);
-			return -ENOMEM;
+			goto err;
 		}
 		spin_lock_init(&portdata->lock);
 		init_usb_anchor(&portdata->active);
@@ -942,6 +942,13 @@ static int sierra_startup(struct usb_serial *serial)
 	}
 
 	return 0;
+err:
+	for (--i; i >= 0; --i) {
+		portdata = usb_get_serial_port_data(serial->port[i]);
+		kfree(portdata);
+	}
+
+	return -ENOMEM;
 }
 
 static void sierra_release(struct usb_serial *serial)


