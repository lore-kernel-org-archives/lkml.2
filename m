Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab1FVIja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 04:39:30 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49888 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab1FVIj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 04:39:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6384"; a="99283456"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: balbi@ti.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH v2 1/2] usb:dummy_hcd: connect/disconnect test support
Date: Wed, 22 Jun 2011 11:39:00 +0300
Message-Id: <1308731945-7601-2-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1308731945-7601-1-git-send-email-tlinder@codeaurora.org>
References: <1308731945-7601-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implementation adds a new proprietary device control requests (to be
handled by the dummy_hcd) that initiates a connect/disconnect sequence.
The bRequest value of the new control request is 0x52.
It is used by the user-space Unit testing application.

Signed-off-by: Tatyana Linder <tlinder@codeaurora.org>

---
 drivers/usb/gadget/dummy_hcd.c |   53 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 1916360..5925fe6 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -61,6 +61,10 @@
 
 #define POWER_BUDGET	500	/* in mA; use 8 for low-power port testing */
 
+/* Proprietary requests: values for the bRequest field of a SETUP packet. */
+/* TESTING: Connect/disconnect the device */
+#define USB_TEST_REQ_CONN_DISCON	0x52
+
 static const char	driver_name [] = "dummy_hcd";
 static const char	driver_desc [] = "USB Host+Gadget Emulator";
 
@@ -179,6 +183,7 @@ struct dummy_hcd {
 	unsigned			active:1;
 	unsigned			old_active:1;
 	unsigned			resuming:1;
+	struct work_struct		conn_disc_work;
 };
 
 struct dummy {
@@ -1337,6 +1342,42 @@ static struct dummy_ep *find_endpoint (struct dummy *dum, u8 address)
 #define Ep_Request	(USB_TYPE_STANDARD | USB_RECIP_ENDPOINT)
 #define Ep_InRequest	(Ep_Request | USB_DIR_IN)
 
+#define Dev_Test_Request	(USB_TYPE_VENDOR | USB_RECIP_DEVICE)
+#define Dev_Test_OutRequest	(Dev_Test_Request | USB_DIR_OUT)
+
+/**
+ * dummy_hcd_conn_disc_work() - performs a disconnect/connect sequence.
+ * @data: pointer to the scheduled work_struct
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
+		dev_err(dummy_dev(dum_hcd), "%s: couldn't disconnect --> %d\n",
+			__func__, ret_val);
+		return;
+	}
+
+	/* We have to let the hub task to update the device disconnect state */
+	msleep_interruptible(1000);
+	dev_info(dummy_dev(dum_hcd), "re-connecting device...\n");
+	ret_val = dummy_pullup(&dum_hcd->dum->gadget, 1);
+	if (ret_val)
+		dev_err(dummy_dev(dum_hcd), "%s: couldn't re-connect --> %d\n",
+			__func__, ret_val);
+}
 
 /**
  * handle_control_request() - handles all control transfers
@@ -1509,6 +1550,12 @@ static int handle_control_request(struct dummy_hcd *dum_hcd, struct urb *urb,
 			*status = 0;
 		}
 		break;
+	case USB_TEST_REQ_CONN_DISCON:
+		if (setup->bRequestType == Dev_Test_OutRequest) {
+			schedule_work(&dum_hcd->conn_disc_work);
+			ret_val = 0;
+		}
+		break;
 	}
 	return ret_val;
 }
@@ -2224,6 +2271,8 @@ static int dummy_setup(struct usb_hcd *hcd)
 	if (usb_hcd_is_primary_hcd(hcd)) {
 		the_controller.hs_hcd = hcd_to_dummy_hcd(hcd);
 		the_controller.hs_hcd->dum = &the_controller;
+		INIT_WORK(&the_controller.hs_hcd->conn_disc_work,
+			  dummy_hcd_conn_disc_work);
 		/*
 		 * Mark the first roothub as being USB 2.0.
 		 * The USB 3.0 roothub will be registered later by
@@ -2234,6 +2283,8 @@ static int dummy_setup(struct usb_hcd *hcd)
 	} else {
 		the_controller.ss_hcd = hcd_to_dummy_hcd(hcd);
 		the_controller.ss_hcd->dum = &the_controller;
+		INIT_WORK(&the_controller.ss_hcd->conn_disc_work,
+			  dummy_hcd_conn_disc_work);
 		hcd->speed = HCD_USB3;
 		hcd->self.root_hub->speed = USB_SPEED_SUPER;
 	}
@@ -2341,10 +2392,12 @@ static int dummy_hcd_remove(struct platform_device *pdev)
 	if (dum->ss_hcd) {
 		usb_remove_hcd(dummy_hcd_to_hcd(dum->ss_hcd));
 		usb_put_hcd(dummy_hcd_to_hcd(dum->ss_hcd));
+		cancel_work_sync(&dum->ss_hcd->conn_disc_work);
 	}
 
 	usb_remove_hcd(dummy_hcd_to_hcd(dum->hs_hcd));
 	usb_put_hcd(dummy_hcd_to_hcd(dum->hs_hcd));
+	cancel_work_sync(&dum->hs_hcd->conn_disc_work);
 
 	the_controller.hs_hcd = NULL;
 	the_controller.ss_hcd = NULL;
-- 
1.7.0.4

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
