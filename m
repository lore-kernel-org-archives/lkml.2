Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab0GVOIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 10:08:04 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9969 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759443Ab0GVOH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 10:07:59 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 22 Jul 2010 16:09:10 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: core: Choose configuration with lowest bConfigurationValue
In-reply-to: <op.vf8lmjow7p4s8u@pikus>
To: linux-usb@vger.kernel.org
Cc: Adam Kropelin <akropel1@rochester.rr.com>,
        Xiaofan Chen <xiaofanc@gmail.com>, linux-kernel@vger.kernel.org
Message-id: <ed7910dcd6f62c058938f30aceb0fa5cd7c3f385.1279807231.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <op.vf8lmjow7p4s8u@pikus>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes code from usb_choose_configuration()
responsible for ignoring the first USB device configuration if
its first interface is RNDIS.  Instead,
usb_choose_configuration() chooses configuration with lowest
bConfigurationValue.  Linux' Ethernet gadget uses a lower
bConfigurationValue for the second configuration which is
a CDC configuration so this code should choose configuration
that suits Linux better.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
---
Just what I had in mind if anyone interested...  Not that I have any
strong opinion about it.  Also, not tested.

 drivers/usb/core/generic.c |   47 +++++++++++++++++++++----------------------
 1 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/core/generic.c b/drivers/usb/core/generic.c
index 9a34ccb..5b411af 100644
--- a/drivers/usb/core/generic.c
+++ b/drivers/usb/core/generic.c
@@ -46,6 +46,7 @@ int usb_choose_configuration(struct usb_device *udev)
 	int num_configs;
 	int insufficient_power = 0;
 	struct usb_host_config *c, *best;
+	int best_is_not_class = 1;
 
 	best = NULL;
 	c = udev->config;
@@ -102,33 +103,31 @@ int usb_choose_configuration(struct usb_device *udev)
 			continue;
 		}
 
-		/* When the first config's first interface is one of Microsoft's
-		 * pet nonstandard Ethernet-over-USB protocols, ignore it unless
-		 * this kernel has enabled the necessary host side driver.
-		 */
-		if (i == 0 && desc && (is_rndis(desc) || is_activesync(desc))) {
-#if !defined(CONFIG_USB_NET_RNDIS_HOST) && !defined(CONFIG_USB_NET_RNDIS_HOST_MODULE)
+		/* From the remaining configs, choose one whose first
+		 * interface is for a non-vendor-specific class and
+		 * has lowest bConfigurationValue.  Reason for the
+		 * former: Linux is more likely to have a class driver
+		 * than a vendor-specific driver.  Reason for the
+		 * latter: Ethernet gadget use lower
+		 * bConfigurationValue for configuration with CDC ECM
+		 * which is preferred by Linux even though it's second
+		 * configuration. */
+		if (udev->descriptor.bDeviceClass !=
+			 USB_CLASS_VENDOR_SPEC &&
+			 (desc && desc->bInterfaceClass !=
+			  USB_CLASS_VENDOR_SPEC)) {
+			if (best_is_not_class ||
+			    c->desc.bConfigurationValue <
+			    best->desc.bConfigurationValue) {
+				best_is_not_class = 0;
+				best = c;
+			}
 			continue;
-#else
-			best = c;
-#endif
-		}
-
-		/* From the remaining configs, choose the first one whose
-		 * first interface is for a non-vendor-specific class.
-		 * Reason: Linux is more likely to have a class driver
-		 * than a vendor-specific driver. */
-		else if (udev->descriptor.bDeviceClass !=
-						USB_CLASS_VENDOR_SPEC &&
-				(desc && desc->bInterfaceClass !=
-						USB_CLASS_VENDOR_SPEC)) {
-			best = c;
-			break;
 		}
 
 		/* If all the remaining configs are vendor-specific,
 		 * choose the first one. */
-		else if (!best)
+		if (!best)
 			best = c;
 	}
 
-- 
1.7.1

