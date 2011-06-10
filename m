Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab1FJKxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 06:53:46 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15978 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab1FJKxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 06:53:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6372"; a="96850361"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3] usb:dummy_hcd: Force FS device connection according to module parameter
Date: Fri, 10 Jun 2011 13:53:22 +0300
Message-Id: <1307703207-14087-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new module parameter to dummy_hcd: is_high_speed
When set to false the connected device will be forced to operate in FS
mode. The default of this parameter is true.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 drivers/usb/gadget/dummy_hcd.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index f0cdd13..8077811 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -72,13 +72,17 @@ MODULE_LICENSE ("GPL");
 
 struct dummy_hcd_module_parameters {
 	bool is_super_speed;
+	bool is_high_speed;
 };
 
 static struct dummy_hcd_module_parameters mod_data = {
-	.is_super_speed = false
+	.is_super_speed = false,
+	.is_high_speed = true,
 };
 module_param_named(is_super_speed, mod_data.is_super_speed, bool, S_IRUGO);
 MODULE_PARM_DESC(is_super_speed, "true to simulate SuperSpeed connection");
+module_param_named(is_high_speed, mod_data.is_high_speed, bool, S_IRUGO);
+MODULE_PARM_DESC(is_high_speed, "true to simulate HighSpeed connection");
 /*-------------------------------------------------------------------------*/
 
 /* gadget side driver data structres */
@@ -904,12 +908,15 @@ usb_gadget_probe_driver(struct usb_gadget_driver *driver,
 	dum->gadget.ep0 = &dum->ep [0].ep;
 	if (mod_data.is_super_speed)
 		dum->gadget.speed = driver->speed;
+	else if (mod_data.is_high_speed)
+		dum->gadget.speed = min_t(u8, USB_SPEED_HIGH, driver->speed);
 	else
-		dum->gadget.speed = min((u8)USB_SPEED_HIGH, (u8)driver->speed);
+		dum->gadget.speed = USB_SPEED_FULL;
 	if (dum->gadget.speed < driver->speed)
-		dev_dbg(udc_dev(dum), "This device can perform faster if"
-				      " you connect it to a "
-				      "SupeSpeed port...\n");
+		dev_dbg(udc_dev(dum), "This device can perform faster"
+				" if you connect it to a %s port...\n",
+			(driver->speed == USB_SPEED_SUPER ?
+			 "SuperSpeed" : "HighSpeed"));
 
 	if (dum->gadget.speed == USB_SPEED_SUPER) {
 		for (i = 0; i < DUMMY_ENDPOINTS; i++)
@@ -2417,6 +2424,9 @@ static int __init init (void)
 	if (usb_disabled ())
 		return -ENODEV;
 
+	if (!mod_data.is_high_speed && mod_data.is_super_speed)
+		return -EINVAL;
+
 	the_hcd_pdev = platform_device_alloc(driver_name, -1);
 	if (!the_hcd_pdev)
 		return retval;
-- 
1.7.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
