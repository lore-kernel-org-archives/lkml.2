Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154Ab2KZRXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:23:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48218 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934108Ab2KZRPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:15:15 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 246/270] USB: sierra: fix memory leak in attach error path
Date: Mon, 26 Nov 2012 14:58:56 -0200
Message-Id: <1353949160-26803-247-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 7e41f9bcdd2e813ea2a3c40db291d87ea06b559f upstream.

Make sure port private data is deallocated on errors in attach.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/sierra.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 7d7ab91..f72bbaa 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -910,7 +910,7 @@ static int sierra_startup(struct usb_serial *serial)
 			dev_dbg(&port->dev, "%s: kmalloc for "
 				"sierra_port_private (%d) failed!\n",
 				__func__, i);
-			return -ENOMEM;
+			goto err;
 		}
 		spin_lock_init(&portdata->lock);
 		init_usb_anchor(&portdata->active);
@@ -947,6 +947,13 @@ static int sierra_startup(struct usb_serial *serial)
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
-- 
1.7.9.5

