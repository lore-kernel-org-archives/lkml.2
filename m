Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab1DSNby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 09:31:54 -0400
Received: from smtp.nokia.com ([147.243.128.26]:62416 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab1DSNbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 09:31:34 -0400
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: stern@rowland.harvard.edu, mina86@mina86.com, m-sonasath@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] usb: gadget: f_mass_storage: Make us pass USBCV MSC Compliance tests
Date: Tue, 19 Apr 2011 16:33:53 +0300
Message-Id: <1303220033-5274-3-git-send-email-roger.quadros@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1303220033-5274-1-git-send-email-roger.quadros@nokia.com>
References: <1303220033-5274-1-git-send-email-roger.quadros@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We delay the SET_CONFIG and SET_INTERFACE setup transfers status phase
till we are ready to process new CBW from the host. This way we ensure
that we don't loose any CBW and cause lock up.

Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
---
 drivers/usb/gadget/f_mass_storage.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 6d8e533..a70468e 100644
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
@@ -3083,6 +3086,7 @@ static int fsg_bind_config(struct usb_composite_dev *cdev,
 	fsg->function.disable     = fsg_disable;
 
 	fsg->common               = common;
+	fsg->common->cdev	  = cdev;
 	/*
 	 * Our caller holds a reference to common structure so we
 	 * don't have to be worry about it being freed until we return
-- 
1.6.0.4

