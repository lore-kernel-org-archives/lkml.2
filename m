Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab2KQGsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 01:48:47 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47959 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab2KQGsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 01:48:45 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH v2] staging/serqt_usb2: Refactor qt_status_change_check() in  serqt_usb2.c
Date: Sat, 17 Nov 2012 15:48:35 +0900
Message-Id: <1353134915-11265-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353115941.6139.10.camel@joe-AO722>
References: <1353115941.6139.10.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify qt_status_change_check() and delete qt_status_change().

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/serqt_usb2/serqt_usb2.c |   53 +++++++++++++------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index f68a855..13722b2 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -291,33 +291,6 @@ static void qt_interrupt_callback(struct urb *urb)
 	/* FIXME */
 }
 
-static int qt_status_change(unsigned int limit,
-			    unsigned char *data,
-			    int i,
-			    struct quatech_port *qt_port,
-			    struct usb_serial_port *port)
-{
-	void (*fn)(struct quatech_port *, unsigned char);
-
-	if (0x00 == data[i + 2]) {
-		dev_dbg(&port->dev, "Line status status.\n");
-		fn = ProcessLineStatus;
-	} else {
-		dev_dbg(&port->dev, "Modem status status.\n");
-		fn = ProcessModemStatus;
-	}
-
-	if (i > limit) {
-		dev_dbg(&port->dev,
-			"Illegal escape seuences in received data\n");
-		return 0;
-	}
-
-	(*fn)(qt_port, data[i + 3]);
-
-	return 1;
-}
-
 static void qt_status_change_check(struct tty_struct *tty,
 				   struct urb *urb,
 				   struct quatech_port *qt_port,
@@ -334,11 +307,29 @@ static void qt_status_change_check(struct tty_struct *tty,
 			flag = 0;
 			switch (data[i + 2]) {
 			case 0x00:
+				if (i > (RxCount - 4)) {
+					dev_dbg(&port->dev,
+						"Illegal escape sequences in received data\n");
+					break;
+				}
+
+				i += 3;
+				ProcessLineStatus(qt_port, data[i]);
+
+				flag = 1;
+				break;
+
 			case 0x01:
-				flag = qt_status_change((RxCount - 4), data, i,
-							qt_port, port);
-				if (flag == 1)
-					i += 3;
+				if (i > (RxCount - 4)) {
+					dev_dbg(&port->dev,
+						"Illegal escape sequences in received data\n");
+					break;
+				}
+
+				i += 3;
+				ProcessModemStatus(qt_port, data[i]);
+
+				flag = 1;
 				break;
 
 			case 0xff:
-- 
1.7.9.5

