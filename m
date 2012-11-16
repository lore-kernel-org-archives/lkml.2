Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab2KPUTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 15:19:32 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63362 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab2KPUTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 15:19:31 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/serqt_usb2: Refactor qt_status_change_check() in serqt_usb2.c
Date: Sat, 17 Nov 2012 05:19:22 +0900
Message-Id: <1353097162-4479-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify qt_status_change_check() and delete qt_status_change().

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/serqt_usb2/serqt_usb2.c |   53 +++++++++++++------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index f68a855..1b3e995 100644
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
+						"Illegal escape seuences in received data\n");
+					break;
+				}
+
+				ProcessLineStatus(qt_port, data[i + 3]);
+
+				i += 3;
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
+						"Illegal escape seuences in received data\n");
+					break;
+				}
+
+				ProcessModemStatus(qt_port, data[i + 3]);
+
+				i += 3;
+				flag = 1;
 				break;
 
 			case 0xff:
-- 
1.7.9.5

