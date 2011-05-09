Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab1EIKGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 06:06:05 -0400
Received: from smtp.nokia.com ([147.243.128.24]:65507 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab1EIKFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 06:05:34 -0400
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: stern@rowland.harvard.edu, mina86@mina86.com, m-sonasath@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] usb: gadget: f_mass_storage: Make us pass USBCV MSC Compliance tests
Date: Mon,  9 May 2011 13:08:07 +0300
Message-Id: <1304935687-5428-3-git-send-email-roger.quadros@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1304935687-5428-1-git-send-email-roger.quadros@nokia.com>
References: <1304935687-5428-1-git-send-email-roger.quadros@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defer the SET_CONFIG and SET_INTERFACE control transfer's data/status
stages till we are ready to process new CBW from the host. This way we
ensure that we don't loose any CBW during MSC compliance tests and cause
lock up.

Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
---
 drivers/usb/gadget/f_mass_storage.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 6d8e533..0d1deee 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -347,6 +347,7 @@ struct fsg_operations {
 /* Data shared by all the FSG instances. */
 struct fsg_common {
 	struct usb_gadget	*gadget;
+	struct usb_composite_dev *cdev;
 	struct fsg_dev		*fsg, *new_fsg;
 	wait_queue_head_t	fsg_wait;
 
@@ -2468,7 +2469,7 @@ static int fsg_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 	struct fsg_dev *fsg = fsg_from_func(f);
 	fsg->common->new_fsg = fsg;
 	raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
-	return 0;
+	return USB_GADGET_DELAYED_STATUS;
 }
 
 static void fsg_disable(struct usb_function *f)
@@ -2604,6 +2605,8 @@ static void handle_exception(struct fsg_common *common)
 
 	case FSG_STATE_CONFIG_CHANGE:
 		do_set_interface(common, common->new_fsg);
+		if (common->new_fsg)
+			usb_composite_setup_continue(common->cdev);
 		break;
 
 	case FSG_STATE_EXIT:
@@ -2774,6 +2777,7 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 	common->gadget = gadget;
 	common->ep0 = gadget->ep0;
 	common->ep0req = cdev->req;
+	common->cdev = cdev;
 
 	/* Maybe allocate device-global string IDs, and patch descriptors */
 	if (fsg_strings[FSG_STRING_INTERFACE].id == 0) {
-- 
1.6.0.4

