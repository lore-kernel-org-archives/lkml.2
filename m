Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131Ab2KZRPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:15:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48224 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061Ab2KZRPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:15:20 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 247/270] USB: sierra: fix memory leak in probe error path
Date: Mon, 26 Nov 2012 14:58:57 -0200
Message-Id: <1353949160-26803-248-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 084817d79399ab5ccab2f90a148b0369912a8369 upstream.

Move interface data allocation to attach so that it is deallocated on
errors in usb-serial probe.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/serial/sierra.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index f72bbaa..6aeddcd 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -162,7 +162,6 @@ static int sierra_probe(struct usb_serial *serial,
 {
 	int result = 0;
 	struct usb_device *udev;
-	struct sierra_intf_private *data;
 	u8 ifnum;
 
 	udev = serial->dev;
@@ -189,11 +188,6 @@ static int sierra_probe(struct usb_serial *serial,
 		return -ENODEV;
 	}
 
-	data = serial->private = kzalloc(sizeof(struct sierra_intf_private), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-	spin_lock_init(&data->susp_lock);
-
 	return result;
 }
 
@@ -890,11 +884,20 @@ static void sierra_dtr_rts(struct usb_serial_port *port, int on)
 static int sierra_startup(struct usb_serial *serial)
 {
 	struct usb_serial_port *port;
+	struct sierra_intf_private *intfdata;
 	struct sierra_port_private *portdata;
 	struct sierra_iface_info *himemoryp = NULL;
 	int i;
 	u8 ifnum;
 
+	intfdata = kzalloc(sizeof(*intfdata), GFP_KERNEL);
+	if (!intfdata)
+		return -ENOMEM;
+
+	spin_lock_init(&intfdata->susp_lock);
+
+	usb_set_serial_data(serial, intfdata);
+
 	/* Set Device mode to D0 */
 	sierra_set_power_state(serial->dev, 0x0000);
 
@@ -952,6 +955,7 @@ err:
 		portdata = usb_get_serial_port_data(serial->port[i]);
 		kfree(portdata);
 	}
+	kfree(intfdata);
 
 	return -ENOMEM;
 }
-- 
1.7.9.5

