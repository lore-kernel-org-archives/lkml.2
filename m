Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442Ab2C2NaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 09:30:06 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:11725 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867Ab2C2N16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 09:27:58 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 06/12] USB: ohci-at91: change maximum number of ports
Date: Thu, 29 Mar 2012 15:27:17 +0200
Message-Id: <8072618d667d37cca7a0d8d3ce14e54919c013cc.1333026637.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <cover.1333026637.git.nicolas.ferre@atmel.com>
References: <cover.1333026637.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1333026637.git.nicolas.ferre@atmel.com>
References: <cover.1333026637.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change number of ports to 3 for newer SoCs. Modify pdata structure
and ohci-at91 code that was dealing with ports information and check
of port indexes.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 arch/arm/mach-at91/include/mach/board.h |   13 +++++++------
 drivers/usb/host/ohci-at91.c            |   22 +++++++++++++---------
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
index 544a5d5..49a8211 100644
--- a/arch/arm/mach-at91/include/mach/board.h
+++ b/arch/arm/mach-at91/include/mach/board.h
@@ -86,14 +86,15 @@ extern void __init at91_add_device_mci(short mmc_id, struct mci_platform_data *d
 extern void __init at91_add_device_eth(struct macb_platform_data *data);
 
  /* USB Host */
+#define AT91_MAX_USBH_PORTS	3
 struct at91_usbh_data {
-	u8		ports;		/* number of ports on root hub */
-	int		vbus_pin[2];	/* port power-control pin */
-	u8              vbus_pin_active_low[2];
+	int		vbus_pin[AT91_MAX_USBH_PORTS];	/* port power-control pin */
+	int             overcurrent_pin[AT91_MAX_USBH_PORTS];
+	u8		ports;				/* number of ports on root hub */
 	u8              overcurrent_supported;
-	int             overcurrent_pin[2];
-	u8              overcurrent_status[2];
-	u8              overcurrent_changed[2];
+	u8              vbus_pin_active_low[AT91_MAX_USBH_PORTS];
+	u8              overcurrent_status[AT91_MAX_USBH_PORTS];
+	u8              overcurrent_changed[AT91_MAX_USBH_PORTS];
 };
 extern void __init at91_add_device_usbh(struct at91_usbh_data *data);
 extern void __init at91_add_device_usbh_ohci(struct at91_usbh_data *data);
diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 1262532..cf9707d 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -240,7 +240,7 @@ ohci_at91_start (struct usb_hcd *hcd)
 
 static void ohci_at91_usb_set_power(struct at91_usbh_data *pdata, int port, int enable)
 {
-	if (port < 0 || port >= 2)
+	if (port < 0 || port >= ARRAY_SIZE(pdata->vbus_pin))
 		return;
 
 	if (!gpio_is_valid(pdata->vbus_pin[port]))
@@ -252,7 +252,7 @@ static void ohci_at91_usb_set_power(struct at91_usbh_data *pdata, int port, int
 
 static int ohci_at91_usb_get_power(struct at91_usbh_data *pdata, int port)
 {
-	if (port < 0 || port >= 2)
+	if (port < 0 || port >= ARRAY_SIZE(pdata->vbus_pin))
 		return -EINVAL;
 
 	if (!gpio_is_valid(pdata->vbus_pin[port]))
@@ -301,7 +301,11 @@ static int ohci_at91_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 	case SetPortFeature:
 		if (wValue == USB_PORT_FEAT_POWER) {
 			dev_dbg(hcd->self.controller, "SetPortFeat: POWER\n");
-			ohci_at91_usb_set_power(pdata, wIndex - 1, 1);
+			if (wIndex && wIndex <= ARRAY_SIZE(pdata->vbus_pin)) {
+				ohci_at91_usb_set_power(pdata, wIndex - 1, 1);
+				ret = 0;
+			}
+
 			goto out;
 		}
 		break;
@@ -312,7 +316,7 @@ static int ohci_at91_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			dev_dbg(hcd->self.controller,
 				"ClearPortFeature: C_OVER_CURRENT\n");
 
-			if (wIndex == 1 || wIndex == 2) {
+			if (wIndex && wIndex <= ARRAY_SIZE(pdata->vbus_pin)) {
 				pdata->overcurrent_changed[wIndex-1] = 0;
 				pdata->overcurrent_status[wIndex-1] = 0;
 			}
@@ -323,7 +327,7 @@ static int ohci_at91_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			dev_dbg(hcd->self.controller,
 				"ClearPortFeature: OVER_CURRENT\n");
 
-			if (wIndex == 1 || wIndex == 2) {
+			if (wIndex && wIndex <= ARRAY_SIZE(pdata->vbus_pin)) {
 				pdata->overcurrent_status[wIndex-1] = 0;
 			}
 
@@ -333,7 +337,7 @@ static int ohci_at91_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			dev_dbg(hcd->self.controller,
 				"ClearPortFeature: POWER\n");
 
-			if (wIndex == 1 || wIndex == 2) {
+			if (wIndex && wIndex <= ARRAY_SIZE(pdata->vbus_pin)) {
 				ohci_at91_usb_set_power(pdata, wIndex - 1, 0);
 				return 0;
 			}
@@ -377,7 +381,7 @@ static int ohci_at91_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 
 		dev_dbg(hcd->self.controller, "GetPortStatus(%d)\n", wIndex);
 
-		if (wIndex == 1 || wIndex == 2) {
+		if (wIndex && wIndex <= ARRAY_SIZE(pdata->vbus_pin)) {
 			if (! ohci_at91_usb_get_power(pdata, wIndex-1)) {
 				*data &= ~cpu_to_le32(RH_PS_PPS);
 			}
@@ -514,7 +518,7 @@ static int __devinit ohci_at91_of_init(struct platform_device *pdev)
 	if (!of_property_read_u32(np, "num-ports", &ports))
 		pdata->ports = ports;
 
-	for (i = 0; i < 2; i++) {
+	for (i = 0; i < ARRAY_SIZE(pdata->vbus_pin); i++) {
 		gpio = of_get_named_gpio_flags(np, "atmel,vbus-gpio", i, &flags);
 		pdata->vbus_pin[i] = gpio;
 		if (!gpio_is_valid(gpio))
@@ -522,7 +526,7 @@ static int __devinit ohci_at91_of_init(struct platform_device *pdev)
 		pdata->vbus_pin_active_low[i] = flags & OF_GPIO_ACTIVE_LOW;
 	}
 
-	for (i = 0; i < 2; i++)
+	for (i = 0; i < ARRAY_SIZE(pdata->overcurrent_pin); i++)
 		pdata->overcurrent_pin[i] =
 			of_get_named_gpio_flags(np, "atmel,oc-gpio", i, &flags);
 
-- 
1.7.9.4

