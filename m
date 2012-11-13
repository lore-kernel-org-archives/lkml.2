Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab2KMI3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:29:08 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60716 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab2KMI3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:29:04 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/13] MFD: twl-core: Clean up and correct child registration
Date: Tue, 13 Nov 2012 09:28:46 +0100
Message-ID: <1352795334-7406-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
References: <1352795334-7406-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the twl child registration calls a bit more uniform by always using the
SUB_CHIP_ID* define instead of the mixed use of the define and magic number.

At the same time correct the following devices so they are registered for the
correct parent device (i2c slave):
twl4030_wdt is accessible on 0x4b address and not 0x48
twl4030_pwrbutton is accessible on 0x4b address and not 0x49
twl4030-audio is on 0x49 all the time

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index a55ab15..d666c9d 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -645,7 +645,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 
 	if (IS_ENABLED(CONFIG_TWL4030_MADC) && pdata->madc &&
 	    twl_class_is_4030()) {
-		child = add_child(2, "twl4030_madc",
+		child = add_child(SUB_CHIP_ID2, "twl4030_madc",
 				pdata->madc, sizeof(*pdata->madc),
 				true, irq_base + MADC_INTR_OFFSET, 0);
 		if (IS_ERR(child))
@@ -661,8 +661,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 		 * HW security concerns, and "least privilege".
 		 */
 		sub_chip_id = twl_map[TWL_MODULE_RTC].sid;
-		child = add_child(sub_chip_id, "twl_rtc",
-				NULL, 0,
+		child = add_child(sub_chip_id, "twl_rtc", NULL, 0,
 				true, irq_base + RTC_INTR_OFFSET, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
@@ -728,9 +727,8 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 
 		}
 
-		child = add_child(0, "twl4030_usb",
-				pdata->usb, sizeof(*pdata->usb),
-				true,
+		child = add_child(SUB_CHIP_ID0, "twl4030_usb",
+				pdata->usb, sizeof(*pdata->usb), true,
 				/* irq0 = USB_PRES, irq1 = USB */
 				irq_base + USB_PRES_INTR_OFFSET,
 				irq_base + USB_INTR_OFFSET);
@@ -778,9 +776,8 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 
 		pdata->usb->features = features;
 
-		child = add_child(0, "twl6030_usb",
-			pdata->usb, sizeof(*pdata->usb),
-			true,
+		child = add_child(SUB_CHIP_ID0, "twl6030_usb",
+			pdata->usb, sizeof(*pdata->usb), true,
 			/* irq1 = VBUS_PRES, irq0 = USB ID */
 			irq_base + USBOTG_INTR_OFFSET,
 			irq_base + USB_PRES_INTR_OFFSET);
@@ -804,22 +801,22 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 	}
 
 	if (IS_ENABLED(CONFIG_TWL4030_WATCHDOG) && twl_class_is_4030()) {
-		child = add_child(0, "twl4030_wdt", NULL, 0, false, 0, 0);
+		child = add_child(SUB_CHIP_ID3, "twl4030_wdt", NULL, 0,
+				  false, 0, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 	}
 
 	if (IS_ENABLED(CONFIG_INPUT_TWL4030_PWRBUTTON) && twl_class_is_4030()) {
-		child = add_child(1, "twl4030_pwrbutton",
-				NULL, 0, true, irq_base + 8 + 0, 0);
+		child = add_child(SUB_CHIP_ID3, "twl4030_pwrbutton", NULL, 0,
+				  true, irq_base + 8 + 0, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 	}
 
 	if (IS_ENABLED(CONFIG_MFD_TWL4030_AUDIO) && pdata->audio &&
 	    twl_class_is_4030()) {
-		sub_chip_id = twl_map[TWL_MODULE_AUDIO_VOICE].sid;
-		child = add_child(sub_chip_id, "twl4030-audio",
+		child = add_child(SUB_CHIP_ID1, "twl4030-audio",
 				pdata->audio, sizeof(*pdata->audio),
 				false, 0, 0);
 		if (IS_ERR(child))
@@ -1059,7 +1056,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 
 	if (IS_ENABLED(CONFIG_CHARGER_TWL4030) && pdata->bci &&
 			!(features & (TPS_SUBSET | TWL5031))) {
-		child = add_child(3, "twl4030_bci",
+		child = add_child(SUB_CHIP_ID3, "twl4030_bci",
 				pdata->bci, sizeof(*pdata->bci), false,
 				/* irq0 = CHG_PRES, irq1 = BCI */
 				irq_base + BCI_PRES_INTR_OFFSET,
-- 
1.8.0

