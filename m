Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab1CVTfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 15:35:12 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59720 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab1CVTfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 15:35:11 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] USB: sl811: add Kconfig option for ISOCHRONOUS mode
Date: Tue, 22 Mar 2011 15:35:39 -0400
Message-Id: <1300822539-19184-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bluetooth dongles want ISO mode, and the limited support that the
sl811 offers today is sufficient.  So add a Kconfig option for people
to optionally get access to the partial functionality.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/usb/host/Kconfig     |   10 ++++++++++
 drivers/usb/host/sl811-hcd.c |    8 +-------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 0e6afa2..e427e36 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -411,6 +411,16 @@ config USB_SL811_HCD
 	  To compile this driver as a module, choose M here: the
 	  module will be called sl811-hcd.
 
+config USB_SL811_HCD_ISO
+	bool "partial ISO support"
+	depends on USB_SL811_HCD
+	help
+	  The driver doesn't support iso_frame_desc (yet), but for some simple
+	  devices that just queue one ISO frame per URB, then ISO transfers
+	  "should" work using the normal urb status fields.
+
+	  If unsure, say N.
+
 config USB_SL811_CS
 	tristate "CF/PCMCIA support for SL811HS HCD"
 	depends on USB_SL811_HCD && PCMCIA
diff --git a/drivers/usb/host/sl811-hcd.c b/drivers/usb/host/sl811-hcd.c
index 2e9602a..4ed2629 100644
--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -71,12 +71,6 @@ MODULE_ALIAS("platform:sl811-hcd");
 /* for now, use only one transfer register bank */
 #undef	USE_B
 
-/* this doesn't understand urb->iso_frame_desc[], but if you had a driver
- * that just queued one ISO frame per URB then iso transfers "should" work
- * using the normal urb status fields.
- */
-#define	DISABLE_ISO
-
 // #define	QUIRK2
 #define	QUIRK3
 
@@ -807,7 +801,7 @@ static int sl811h_urb_enqueue(
 	int			retval;
 	struct usb_host_endpoint	*hep = urb->ep;
 
-#ifdef	DISABLE_ISO
+#ifndef CONFIG_USB_SL811_HCD_ISO
 	if (type == PIPE_ISOCHRONOUS)
 		return -ENOSPC;
 #endif
-- 
1.7.4.1

