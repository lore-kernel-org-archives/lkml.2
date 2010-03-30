Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab0CaAMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:12:40 -0400
Received: from kroah.org ([198.145.64.141]:51927 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162Ab0C3XRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:52 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:21 2010
Message-Id: <20100330225621.431157496@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ping Cheng <pingc@wacom.com>, Dmitry Torokhov <dtor@mail.ru>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [036/116] Input: wacom - ensure the device is initialized properly upon resume
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ping Cheng <pingc@wacom.com>

commit 232f5693e5c9483e222528ef81979e42ea2f2908 upstream.

Call wacom_query_tablet_data() from wacom_resume() so the device will be
switched to Wacom mode upon resume. Devices that require this are: regular
tablets and two finger touch devices.

Signed-off-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/tablet/wacom.h     |    7 ++++---
 drivers/input/tablet/wacom_sys.c |    7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/input/tablet/wacom.h
+++ b/drivers/input/tablet/wacom.h
@@ -1,7 +1,7 @@
 /*
  * drivers/input/tablet/wacom.h
  *
- *  USB Wacom Graphire and Wacom Intuos tablet support
+ *  USB Wacom tablet support
  *
  *  Copyright (c) 2000-2004 Vojtech Pavlik	<vojtech@ucw.cz>
  *  Copyright (c) 2000 Andreas Bach Aaen	<abach@stofanet.dk>
@@ -69,6 +69,7 @@
  *      v1.49 (pc) - Added support for USB Tablet PC (0x90, 0x93, and 0x9A)
  *      v1.50 (pc) - Fixed a TabletPC touch bug in 2.6.28
  *      v1.51 (pc) - Added support for Intuos4
+ *      v1.52 (pc) - Query Wacom data upon system resume
  */
 
 /*
@@ -89,9 +90,9 @@
 /*
  * Version Information
  */
-#define DRIVER_VERSION "v1.51"
+#define DRIVER_VERSION "v1.52"
 #define DRIVER_AUTHOR "Vojtech Pavlik <vojtech@ucw.cz>"
-#define DRIVER_DESC "USB Wacom Graphire and Wacom Intuos tablet driver"
+#define DRIVER_DESC "USB Wacom tablet driver"
 #define DRIVER_LICENSE "GPL"
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -1,7 +1,7 @@
 /*
  * drivers/input/tablet/wacom_sys.c
  *
- *  USB Wacom Graphire and Wacom Intuos tablet support - system specific code
+ *  USB Wacom tablet support - system specific code
  */
 
 /*
@@ -562,9 +562,10 @@ static int wacom_resume(struct usb_inter
 	int rv;
 
 	mutex_lock(&wacom->lock);
-	if (wacom->open)
+	if (wacom->open) {
 		rv = usb_submit_urb(wacom->irq, GFP_NOIO);
-	else
+		wacom_query_tablet_data(intf);
+	} else
 		rv = 0;
 	mutex_unlock(&wacom->lock);
 


