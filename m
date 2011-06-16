Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab1FPNcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:32:09 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7142 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab1FPNby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:31:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6378"; a="98075546"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH/RFC 2/5] usb:dummy_hcd: connect/disconnect test support
Date: Thu, 16 Jun 2011 16:31:04 +0300
Message-Id: <1308231068-24038-3-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org>
References: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implementation adds a new proprietary device control requests (to be
handled by the dummy_hcd) that initiates a connect/disconnect sequence.
The bRequest value of the new control request is 0x52.
It is used by the user-space Unit testing application.

Signed-off-by: Tatyana Linder <tlinder@codeaurora.org>

---
 drivers/usb/gadget/dummy_hcd.c |   48 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 74b7655..7d0a6fe 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -179,6 +179,7 @@ struct dummy_hcd {
 	unsigned			active:1;
 	unsigned			old_active:1;
 	unsigned			resuming:1;
+	struct work_struct		conn_disc_work;
 };
 
 struct dummy {
@@ -1362,6 +1363,43 @@ static struct dummy_ep *find_endpoint (struct dummy *dum, u8 address)
 #define Ep_Request	(USB_TYPE_STANDARD | USB_RECIP_ENDPOINT)
 #define Ep_InRequest	(Ep_Request | USB_DIR_IN)
 
+/**
+ * dummy_hcd_conn_disc_work() - performs a disconnect/connect sequence.
+ * @data: pointer to the sceduled work_struct
+ */
+static void dummy_hcd_conn_disc_work(struct work_struct *data)
+{
+	struct dummy_hcd *dum_hcd =
+		container_of(data, struct dummy_hcd, conn_disc_work);
+	int ret_val;
+
+	if (!dum_hcd->dum->driver) {
+		dev_err(dummy_dev(dum_hcd),
+			"dummy_hcd_conn_disc_work called without connected "
+			"device\n");
+		return;
+	}
+
+	dev_info(dummy_dev(dum_hcd), "disconnecting device...\n");
+	ret_val = dummy_pullup(&dum_hcd->dum->gadget, 0);
+	if (ret_val) {
+		dev_err(dummy_dev(dum_hcd), "dummy_hcd_conn_disc_work:"
+					    " couldn't disconnect device:"
+					    " ret_val=%d\n",
+				ret_val);
+		return;
+	}
+
+	dev_info(dummy_dev(dum_hcd), "re-connecting device...\n");
+	/* We have to let the hub task to update the device disconnect state */
+	msleep_interruptible(1000);
+	ret_val = dummy_pullup(&dum_hcd->dum->gadget, 1);
+	if (ret_val)
+		dev_err(dummy_dev(dum_hcd), "dummy_hcd_conn_disc_work:"
+					    " couldn't re-connect device:"
+					    " ret_val=%d\n",
+				ret_val);
+}
 
 /**
  * handle_control_request() - handles all control transfers
@@ -1534,6 +1572,10 @@ static int handle_control_request(struct dummy_hcd *dum_hcd, struct urb *urb,
 			*status = 0;
 		}
 		break;
+	case 0x52:	/* UT: Connect/disconnect the device */
+		schedule_work(&dum_hcd->conn_disc_work);
+		ret_val = 0;
+		break;
 	}
 	return ret_val;
 }
@@ -2249,6 +2291,8 @@ static int dummy_setup(struct usb_hcd *hcd)
 	if (usb_hcd_is_primary_hcd(hcd)) {
 		the_controller.hs_hcd = hcd_to_dummy_hcd(hcd);
 		the_controller.hs_hcd->dum = &the_controller;
+		INIT_WORK(&the_controller.hs_hcd->conn_disc_work,
+			  dummy_hcd_conn_disc_work);
 		/*
 		 * Mark the first roothub as being USB 2.0.
 		 * The USB 3.0 roothub will be registered later by
@@ -2259,6 +2303,8 @@ static int dummy_setup(struct usb_hcd *hcd)
 	} else {
 		the_controller.ss_hcd = hcd_to_dummy_hcd(hcd);
 		the_controller.ss_hcd->dum = &the_controller;
+		INIT_WORK(&the_controller.ss_hcd->conn_disc_work,
+			  dummy_hcd_conn_disc_work);
 		hcd->speed = HCD_USB3;
 		hcd->self.root_hub->speed = USB_SPEED_SUPER;
 	}
@@ -2364,9 +2410,11 @@ static int dummy_hcd_remove (struct platform_device *pdev)
 	if (dum->ss_hcd) {
 		usb_remove_hcd(dummy_hcd_to_hcd(dum->ss_hcd));
 		usb_put_hcd(dummy_hcd_to_hcd(dum->ss_hcd));
+		cancel_work_sync(&dum->ss_hcd->conn_disc_work);
 	}
 	usb_remove_hcd(dummy_hcd_to_hcd(dum->hs_hcd));
 	usb_put_hcd(dummy_hcd_to_hcd(dum->hs_hcd));
+	cancel_work_sync(&dum->hs_hcd->conn_disc_work);
 	the_controller.ss_hcd = the_controller.hs_hcd = NULL;
 	return 0;
 }
-- 
1.7.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
