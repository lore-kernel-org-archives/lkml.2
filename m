Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab0FYO3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 10:29:06 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:51082 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab0FYO2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 10:28:44 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 25 Jun 2010 16:29:26 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: gadget: f_mass_storage: fixed fs descriptors not being
 updated
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org,
       Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
Message-id: <195465048ef0e96371d42a9bc754a2f35a03bccd.1277461024.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The full speed descriptors were copied to the usb_function structure
in the fsg_bind_config function before call to the usb_ep_autoconfig.
The usb_ep_autoconfig was called in fsg_bind using the original
descriptors.  In effect copied descriptors were not updated.

This patch changes the copy full speed descriptors after the call to
usb_op_autoconfig is performed.  This way, copied full speed
descriptors have updated values.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Reported-by: Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
Tested-by: Dries Van Puymbroeck <Dries.VanPuymbroeck@dekimo.com>
---
Greg, as a bug fix I believe this should be included in 2.6.35 (even
more so since the bug was introduced in .35).

 drivers/usb/gadget/f_mass_storage.c |   34 ++++++++++++----------------------
 1 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index dc3cec7..b35f0ad 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2998,7 +2998,6 @@ static int fsg_bind(struct usb_configuration *c, struct usb_function *f)
 {
 	struct fsg_dev		*fsg = fsg_from_func(f);
 	struct usb_gadget	*gadget = c->cdev->gadget;
-	int			rc;
 	int			i;
 	struct usb_ep		*ep;
 
@@ -3024,6 +3023,11 @@ static int fsg_bind(struct usb_configuration *c, struct usb_function *f)
 	ep->driver_data = fsg->common;	/* claim the endpoint */
 	fsg->bulk_out = ep;
 
+	/* Copy descriptors */
+	f->descriptors = usb_copy_descriptors(fsg_fs_function);
+	if (unlikely(!f->descriptors))
+		return -ENOMEM;
+
 	if (gadget_is_dualspeed(gadget)) {
 		/* Assume endpoint addresses are the same for both speeds */
 		fsg_hs_bulk_in_desc.bEndpointAddress =
@@ -3031,16 +3035,17 @@ static int fsg_bind(struct usb_configuration *c, struct usb_function *f)
 		fsg_hs_bulk_out_desc.bEndpointAddress =
 			fsg_fs_bulk_out_desc.bEndpointAddress;
 		f->hs_descriptors = usb_copy_descriptors(fsg_hs_function);
-		if (unlikely(!f->hs_descriptors))
+		if (unlikely(!f->hs_descriptors)) {
+			usb_free_descriptors(f->descriptors);
 			return -ENOMEM;
+		}
 	}
 
 	return 0;
 
 autoconf_fail:
 	ERROR(fsg, "unable to autoconfigure all endpoints\n");
-	rc = -ENOTSUPP;
-	return rc;
+	return -ENOTSUPP;
 }
 
 
@@ -3064,11 +3069,6 @@ static int fsg_bind_config(struct usb_composite_dev *cdev,
 
 	fsg->function.name        = FSG_DRIVER_DESC;
 	fsg->function.strings     = fsg_strings_array;
-	fsg->function.descriptors = usb_copy_descriptors(fsg_fs_function);
-	if (unlikely(!fsg->function.descriptors)) {
-		rc = -ENOMEM;
-		goto error_free_fsg;
-	}
 	fsg->function.bind        = fsg_bind;
 	fsg->function.unbind      = fsg_unbind;
 	fsg->function.setup       = fsg_setup;
@@ -3084,19 +3084,9 @@ static int fsg_bind_config(struct usb_composite_dev *cdev,
 
 	rc = usb_add_function(c, &fsg->function);
 	if (unlikely(rc))
-		goto error_free_all;
-
-	fsg_common_get(fsg->common);
-	return 0;
-
-error_free_all:
-	usb_free_descriptors(fsg->function.descriptors);
-	/* fsg_bind() might have copied those; or maybe not? who cares
-	 * -- free it just in case. */
-	usb_free_descriptors(fsg->function.hs_descriptors);
-error_free_fsg:
-	kfree(fsg);
-
+		kfree(fsg);
+	else
+		fsg_common_get(fsg->common);
 	return rc;
 }
 
-- 
1.7.1

