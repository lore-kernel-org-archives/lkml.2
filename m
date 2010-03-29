Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab0C2KUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 06:20:18 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9877 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab0C2KUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 06:20:15 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 29 Mar 2010 12:18:43 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: gadget: f_mass_storage: per function descriptors copy
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Peter Korsgaard <jacmet@sunsite.dk>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>
Message-id: <01616584180153ae03d983b6971f5a1b8097419e.1269631274.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mass Storage Function (MSF) used the same descriptors for each
usb_function instance (meaning usb_function::descriptors of different
functions pointed to the same static area (the same was true for
usb_function::hs_descriptors)).

This would leads to problems if MSF were used in several USB
configurations with different interface and/or endpoint numbers.
Descriptors for all configurations would have interface/endpoint
numbers overwritten by the values valid for the last configuration.

This patch adds code that copies the descriptors each time MSF is
added to USB configuration (that is for each usb_function).

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/f_mass_storage.c |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index f4911c0..9fccdc3 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2906,6 +2906,8 @@ static void fsg_unbind(struct usb_configuration *c, struct usb_function *f)
 
 	DBG(fsg, "unbind\n");
 	fsg_common_put(fsg->common);
+	usb_free_descriptors(fsg->function.descriptors);
+	usb_free_descriptors(fsg->function.hs_descriptors);
 	kfree(fsg);
 }
 
@@ -2946,7 +2948,13 @@ static int __init fsg_bind(struct usb_configuration *c, struct usb_function *f)
 			fsg_fs_bulk_in_desc.bEndpointAddress;
 		fsg_hs_bulk_out_desc.bEndpointAddress =
 			fsg_fs_bulk_out_desc.bEndpointAddress;
-		f->hs_descriptors = fsg_hs_function;
+		f->hs_descriptors = usb_copy_descriptors(fsg_hs_function);
+		/* We don't care if we could not copy the high speed
+		 * descriptor.  If we are out of memory we'll stick to
+		 * full speed only.  Ie. it is an error that we cannot
+		 * copy hs descriptors but not a fatal one. */
+		/* if (unlikely(!f->hs_descriptors))
+			return -ENOMEM; */
 	}
 
 	return 0;
@@ -2978,7 +2986,11 @@ static int fsg_add(struct usb_composite_dev *cdev,
 
 	fsg->function.name        = FSG_DRIVER_DESC;
 	fsg->function.strings     = fsg_strings_array;
-	fsg->function.descriptors = fsg_fs_function;
+	fsg->function.descriptors = usb_copy_descriptors(fsg_fs_function);
+	if (unlikely(!fsg->function.descriptors)) {
+		rc = -ENOMEM;
+		goto error_free_fsg;
+	}
 	fsg->function.bind        = fsg_bind;
 	fsg->function.unbind      = fsg_unbind;
 	fsg->function.setup       = fsg_setup;
@@ -2993,11 +3005,19 @@ static int fsg_add(struct usb_composite_dev *cdev,
 	 * call to usb_add_function() was successful. */
 
 	rc = usb_add_function(c, &fsg->function);
+	if (unlikely(rc))
+		goto error_free_all;
 
-	if (likely(rc == 0))
-		fsg_common_get(fsg->common);
-	else
-		kfree(fsg);
+	fsg_common_get(fsg->common);
+	return 0;
+
+error_free_all:
+	usb_free_descriptors(fsg->function.descriptors);
+	/* fsg_bind() might have copied those; or maybe not? who cares
+	 * -- free it just in case. */
+	usb_free_descriptors(fsg->function.hs_descriptors);
+error_free_fsg:
+	kfree(fsg);
 
 	return rc;
 }
-- 
1.7.0

