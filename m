Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094Ab2J2Vu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:50:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:48678 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932978Ab2J2Vle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:41:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 28/54] USB: sierra: fix memory leak in attach error path
Date: Mon, 29 Oct 2012 14:40:29 -0700
Message-Id: <20121029213805.885742306@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 7e41f9bcdd2e813ea2a3c40db291d87ea06b559f upstream.

Make sure port private data is deallocated on errors in attach.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/sierra.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -936,7 +936,7 @@ static int sierra_startup(struct usb_ser
 			dev_dbg(&port->dev, "%s: kmalloc for "
 				"sierra_port_private (%d) failed!\n",
 				__func__, i);
-			return -ENOMEM;
+			goto err;
 		}
 		spin_lock_init(&portdata->lock);
 		init_usb_anchor(&portdata->active);
@@ -973,6 +973,13 @@ static int sierra_startup(struct usb_ser
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


