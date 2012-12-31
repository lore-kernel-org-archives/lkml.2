Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab2LaLJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 06:09:45 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48376 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab2LaLJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 06:09:38 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 03/10] mfd: twl-core: Use the lookup table to find the correct subchip for the modules
Date: Mon, 31 Dec 2012 12:09:24 +0100
Message-ID: <1356952171-6109-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
References: <1356952171-6109-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using SUB_CHIP_ID* or magic numbers use the twl_mapping table to
look for the subchip ID.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl-core.c | 56 ++++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 29 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index fa1a5a0..f07317b 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -68,11 +68,6 @@
 
 #define TWL_NUM_SLAVES		4
 
-#define SUB_CHIP_ID0 0
-#define SUB_CHIP_ID1 1
-#define SUB_CHIP_ID2 2
-#define SUB_CHIP_ID3 3
-
 /* Base Address defns for twl4030_map[] */
 
 /* subchip/slave 0 - USB ID */
@@ -493,13 +488,20 @@ int twl_get_hfclk_rate(void)
 EXPORT_SYMBOL_GPL(twl_get_hfclk_rate);
 
 static struct device *
-add_numbered_child(unsigned chip, const char *name, int num,
+add_numbered_child(unsigned mod_no, const char *name, int num,
 		void *pdata, unsigned pdata_len,
 		bool can_wakeup, int irq0, int irq1)
 {
 	struct platform_device	*pdev;
-	struct twl_client	*twl = &twl_modules[chip];
-	int			status;
+	struct twl_client	*twl;
+	int			status, sid;
+
+	if (unlikely(mod_no >= twl_get_last_module())) {
+		pr_err("%s: invalid module number %d\n", DRIVER_NAME, mod_no);
+		return ERR_PTR(-EPERM);
+	}
+	sid = twl_map[mod_no].sid;
+	twl = &twl_modules[sid];
 
 	pdev = platform_device_alloc(name, num);
 	if (!pdev) {
@@ -544,11 +546,11 @@ err:
 	return &pdev->dev;
 }
 
-static inline struct device *add_child(unsigned chip, const char *name,
+static inline struct device *add_child(unsigned mod_no, const char *name,
 		void *pdata, unsigned pdata_len,
 		bool can_wakeup, int irq0, int irq1)
 {
-	return add_numbered_child(chip, name, -1, pdata, pdata_len,
+	return add_numbered_child(mod_no, name, -1, pdata, pdata_len,
 		can_wakeup, irq0, irq1);
 }
 
@@ -557,7 +559,6 @@ add_regulator_linked(int num, struct regulator_init_data *pdata,
 		struct regulator_consumer_supply *consumers,
 		unsigned num_consumers, unsigned long features)
 {
-	unsigned sub_chip_id;
 	struct twl_regulator_driver_data drv_data;
 
 	/* regulator framework demands init_data ... */
@@ -584,8 +585,7 @@ add_regulator_linked(int num, struct regulator_init_data *pdata,
 	}
 
 	/* NOTE:  we currently ignore regulator IRQs, e.g. for short circuits */
-	sub_chip_id = twl_map[TWL_MODULE_PM_MASTER].sid;
-	return add_numbered_child(sub_chip_id, "twl_reg", num,
+	return add_numbered_child(TWL_MODULE_PM_MASTER, "twl_reg", num,
 		pdata, sizeof(*pdata), false, 0, 0);
 }
 
@@ -607,10 +607,9 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 		unsigned long features)
 {
 	struct device	*child;
-	unsigned sub_chip_id;
 
 	if (IS_ENABLED(CONFIG_GPIO_TWL4030) && pdata->gpio) {
-		child = add_child(SUB_CHIP_ID1, "twl4030_gpio",
+		child = add_child(TWL4030_MODULE_GPIO, "twl4030_gpio",
 				pdata->gpio, sizeof(*pdata->gpio),
 				false, irq_base + GPIO_INTR_OFFSET, 0);
 		if (IS_ERR(child))
@@ -618,7 +617,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 	}
 
 	if (IS_ENABLED(CONFIG_KEYBOARD_TWL4030) && pdata->keypad) {
-		child = add_child(SUB_CHIP_ID2, "twl4030_keypad",
+		child = add_child(TWL4030_MODULE_KEYPAD, "twl4030_keypad",
 				pdata->keypad, sizeof(*pdata->keypad),
 				true, irq_base + KEYPAD_INTR_OFFSET, 0);
 		if (IS_ERR(child))
@@ -627,7 +626,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 
 	if (IS_ENABLED(CONFIG_TWL4030_MADC) && pdata->madc &&
 	    twl_class_is_4030()) {
-		child = add_child(SUB_CHIP_ID2, "twl4030_madc",
+		child = add_child(TWL4030_MODULE_MADC, "twl4030_madc",
 				pdata->madc, sizeof(*pdata->madc),
 				true, irq_base + MADC_INTR_OFFSET, 0);
 		if (IS_ERR(child))
@@ -642,22 +641,21 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 		 * Eventually, Linux might become more aware of such
 		 * HW security concerns, and "least privilege".
 		 */
-		sub_chip_id = twl_map[TWL_MODULE_RTC].sid;
-		child = add_child(sub_chip_id, "twl_rtc", NULL, 0,
+		child = add_child(TWL_MODULE_RTC, "twl_rtc", NULL, 0,
 				true, irq_base + RTC_INTR_OFFSET, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 	}
 
 	if (IS_ENABLED(CONFIG_PWM_TWL)) {
-		child = add_child(SUB_CHIP_ID1, "twl-pwm", NULL, 0,
+		child = add_child(TWL_MODULE_PWM, "twl-pwm", NULL, 0,
 				  false, 0, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 	}
 
 	if (IS_ENABLED(CONFIG_PWM_TWL_LED)) {
-		child = add_child(SUB_CHIP_ID1, "twl-pwmled", NULL, 0,
+		child = add_child(TWL_MODULE_LED, "twl-pwmled", NULL, 0,
 				  false, 0, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
@@ -709,7 +707,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 
 		}
 
-		child = add_child(SUB_CHIP_ID0, "twl4030_usb",
+		child = add_child(TWL_MODULE_USB, "twl4030_usb",
 				pdata->usb, sizeof(*pdata->usb), true,
 				/* irq0 = USB_PRES, irq1 = USB */
 				irq_base + USB_PRES_INTR_OFFSET,
@@ -758,7 +756,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 
 		pdata->usb->features = features;
 
-		child = add_child(SUB_CHIP_ID0, "twl6030_usb",
+		child = add_child(TWL_MODULE_USB, "twl6030_usb",
 			pdata->usb, sizeof(*pdata->usb), true,
 			/* irq1 = VBUS_PRES, irq0 = USB ID */
 			irq_base + USBOTG_INTR_OFFSET,
@@ -783,22 +781,22 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 	}
 
 	if (IS_ENABLED(CONFIG_TWL4030_WATCHDOG) && twl_class_is_4030()) {
-		child = add_child(SUB_CHIP_ID3, "twl4030_wdt", NULL, 0,
-				  false, 0, 0);
+		child = add_child(TWL_MODULE_PM_RECEIVER, "twl4030_wdt", NULL,
+				  0, false, 0, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 	}
 
 	if (IS_ENABLED(CONFIG_INPUT_TWL4030_PWRBUTTON) && twl_class_is_4030()) {
-		child = add_child(SUB_CHIP_ID3, "twl4030_pwrbutton", NULL, 0,
-				  true, irq_base + 8 + 0, 0);
+		child = add_child(TWL_MODULE_PM_MASTER, "twl4030_pwrbutton",
+				  NULL, 0, true, irq_base + 8 + 0, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 	}
 
 	if (IS_ENABLED(CONFIG_MFD_TWL4030_AUDIO) && pdata->audio &&
 	    twl_class_is_4030()) {
-		child = add_child(SUB_CHIP_ID1, "twl4030-audio",
+		child = add_child(TWL4030_MODULE_AUDIO_VOICE, "twl4030-audio",
 				pdata->audio, sizeof(*pdata->audio),
 				false, 0, 0);
 		if (IS_ERR(child))
@@ -1038,7 +1036,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
 
 	if (IS_ENABLED(CONFIG_CHARGER_TWL4030) && pdata->bci &&
 			!(features & (TPS_SUBSET | TWL5031))) {
-		child = add_child(SUB_CHIP_ID3, "twl4030_bci",
+		child = add_child(TWL_MODULE_MAIN_CHARGE, "twl4030_bci",
 				pdata->bci, sizeof(*pdata->bci), false,
 				/* irq0 = CHG_PRES, irq1 = BCI */
 				irq_base + BCI_PRES_INTR_OFFSET,
-- 
1.8.0.2

