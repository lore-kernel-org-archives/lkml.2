Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab2DCPaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 11:30:55 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:45731 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2DCPay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 11:30:54 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: stern@rowland.harvard.edu, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v3 06/12] USB: ohci-at91: change maximum number of ports
Date: Tue,  3 Apr 2012 17:30:33 +0200
Message-Id: <1333467033-29124-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <Pine.LNX.4.44L0.1204031125060.1537-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1204031125060.1537-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change number of ports to 3 for newer SoCs. Modify pdata structure
and ohci-at91 code that was dealing with ports information and check
of port indexes.
Several coding style errors have been addresses as the patch was touching
affected lines of code and was producing errors while run through
checkpatch.pl.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
v3: - address all style errors in this patch (to prevent carrying them)
    - merge following patch about one-line ifs

v2: - use of AT91_MAX_USBH_PORTS instead of ARRAY_SIZE()
    - modify wIndex ohci_at91_hub_control() for simpler code

 arch/arm/mach-at91/include/mach/board.h |   13 +++---
 drivers/usb/host/ohci-at91.c            |   66 +++++++++++++++++--------------
 2 files changed, 43 insertions(+), 36 deletions(-)

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
index c30da6a..7cf4797 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -27,6 +27,10 @@
 #error "CONFIG_ARCH_AT91 must be defined."
 #endif
 
+#define valid_port(index)	((index) >= 0 && (index) < AT91_MAX_USBH_PORTS)
+#define at91_for_each_port(index)	\
+		for ((index) = 0; (index) < AT91_MAX_USBH_PORTS; (index)++)
+
 /* interface and function clocks; sometimes also an AHB clock */
 static struct clk *iclk, *fclk, *hclk;
 static int clocked;
@@ -240,7 +244,7 @@ ohci_at91_start (struct usb_hcd *hcd)
 
 static void ohci_at91_usb_set_power(struct at91_usbh_data *pdata, int port, int enable)
 {
-	if (port < 0 || port >= 2)
+	if (!valid_port(port))
 		return;
 
 	if (!gpio_is_valid(pdata->vbus_pin[port]))
@@ -252,7 +256,7 @@ static void ohci_at91_usb_set_power(struct at91_usbh_data *pdata, int port, int
 
 static int ohci_at91_usb_get_power(struct at91_usbh_data *pdata, int port)
 {
-	if (port < 0 || port >= 2)
+	if (!valid_port(port))
 		return -EINVAL;
 
 	if (!gpio_is_valid(pdata->vbus_pin[port]))
@@ -271,9 +275,9 @@ static int ohci_at91_hub_status_data(struct usb_hcd *hcd, char *buf)
 	int length = ohci_hub_status_data(hcd, buf);
 	int port;
 
-	for (port = 0; port < ARRAY_SIZE(pdata->overcurrent_pin); port++) {
+	at91_for_each_port(port) {
 		if (pdata->overcurrent_changed[port]) {
-			if (! length)
+			if (!length)
 				length = 1;
 			buf[0] |= 1 << (port + 1);
 		}
@@ -297,11 +301,17 @@ static int ohci_at91_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		"ohci_at91_hub_control(%p,0x%04x,0x%04x,0x%04x,%p,%04x)\n",
 		hcd, typeReq, wValue, wIndex, buf, wLength);
 
+	wIndex--;
+
 	switch (typeReq) {
 	case SetPortFeature:
 		if (wValue == USB_PORT_FEAT_POWER) {
 			dev_dbg(hcd->self.controller, "SetPortFeat: POWER\n");
-			ohci_at91_usb_set_power(pdata, wIndex - 1, 1);
+			if (valid_port(wIndex)) {
+				ohci_at91_usb_set_power(pdata, wIndex, 1);
+				ret = 0;
+			}
+
 			goto out;
 		}
 		break;
@@ -312,9 +322,9 @@ static int ohci_at91_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			dev_dbg(hcd->self.controller,
 				"ClearPortFeature: C_OVER_CURRENT\n");
 
-			if (wIndex == 1 || wIndex == 2) {
-				pdata->overcurrent_changed[wIndex-1] = 0;
-				pdata->overcurrent_status[wIndex-1] = 0;
+			if (valid_port(wIndex)) {
+				pdata->overcurrent_changed[wIndex] = 0;
+				pdata->overcurrent_status[wIndex] = 0;
 			}
 
 			goto out;
@@ -323,9 +333,8 @@ static int ohci_at91_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			dev_dbg(hcd->self.controller,
 				"ClearPortFeature: OVER_CURRENT\n");
 
-			if (wIndex == 1 || wIndex == 2) {
-				pdata->overcurrent_status[wIndex-1] = 0;
-			}
+			if (valid_port(wIndex))
+				pdata->overcurrent_status[wIndex] = 0;
 
 			goto out;
 
@@ -333,15 +342,15 @@ static int ohci_at91_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 			dev_dbg(hcd->self.controller,
 				"ClearPortFeature: POWER\n");
 
-			if (wIndex == 1 || wIndex == 2) {
-				ohci_at91_usb_set_power(pdata, wIndex - 1, 0);
+			if (valid_port(wIndex)) {
+				ohci_at91_usb_set_power(pdata, wIndex, 0);
 				return 0;
 			}
 		}
 		break;
 	}
 
-	ret = ohci_hub_control(hcd, typeReq, wValue, wIndex, buf, wLength);
+	ret = ohci_hub_control(hcd, typeReq, wValue, wIndex + 1, buf, wLength);
 	if (ret)
 		goto out;
 
@@ -377,18 +386,15 @@ static int ohci_at91_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 
 		dev_dbg(hcd->self.controller, "GetPortStatus(%d)\n", wIndex);
 
-		if (wIndex == 1 || wIndex == 2) {
-			if (! ohci_at91_usb_get_power(pdata, wIndex-1)) {
+		if (valid_port(wIndex)) {
+			if (!ohci_at91_usb_get_power(pdata, wIndex))
 				*data &= ~cpu_to_le32(RH_PS_PPS);
-			}
 
-			if (pdata->overcurrent_changed[wIndex-1]) {
+			if (pdata->overcurrent_changed[wIndex])
 				*data |= cpu_to_le32(RH_PS_OCIC);
-			}
 
-			if (pdata->overcurrent_status[wIndex-1]) {
+			if (pdata->overcurrent_status[wIndex])
 				*data |= cpu_to_le32(RH_PS_POCI);
-			}
 		}
 	}
 
@@ -450,14 +456,14 @@ static irqreturn_t ohci_hcd_at91_overcurrent_irq(int irq, void *data)
 
 	/* From the GPIO notifying the over-current situation, find
 	 * out the corresponding port */
-	for (port = 0; port < ARRAY_SIZE(pdata->overcurrent_pin); port++) {
+	at91_for_each_port(port) {
 		if (gpio_to_irq(pdata->overcurrent_pin[port]) == irq) {
 			gpio = pdata->overcurrent_pin[port];
 			break;
 		}
 	}
 
-	if (port == ARRAY_SIZE(pdata->overcurrent_pin)) {
+	if (port == AT91_MAX_USBH_PORTS) {
 		dev_err(& pdev->dev, "overcurrent interrupt from unknown GPIO\n");
 		return IRQ_HANDLED;
 	}
@@ -467,7 +473,7 @@ static irqreturn_t ohci_hcd_at91_overcurrent_irq(int irq, void *data)
 	/* When notified of an over-current situation, disable power
 	   on the corresponding port, and mark this port in
 	   over-current. */
-	if (! val) {
+	if (!val) {
 		ohci_at91_usb_set_power(pdata, port, 0);
 		pdata->overcurrent_status[port]  = 1;
 		pdata->overcurrent_changed[port] = 1;
@@ -514,7 +520,7 @@ static int __devinit ohci_at91_of_init(struct platform_device *pdev)
 	if (!of_property_read_u32(np, "num-ports", &ports))
 		pdata->ports = ports;
 
-	for (i = 0; i < 2; i++) {
+	at91_for_each_port(i) {
 		gpio = of_get_named_gpio_flags(np, "atmel,vbus-gpio", i, &flags);
 		pdata->vbus_pin[i] = gpio;
 		if (!gpio_is_valid(gpio))
@@ -522,7 +528,7 @@ static int __devinit ohci_at91_of_init(struct platform_device *pdev)
 		pdata->vbus_pin_active_low[i] = flags & OF_GPIO_ACTIVE_LOW;
 	}
 
-	for (i = 0; i < 2; i++)
+	at91_for_each_port(i)
 		pdata->overcurrent_pin[i] =
 			of_get_named_gpio_flags(np, "atmel,oc-gpio", i, &flags);
 
@@ -554,7 +560,7 @@ static int ohci_hcd_at91_drv_probe(struct platform_device *pdev)
 	pdata = pdev->dev.platform_data;
 
 	if (pdata) {
-		for (i = 0; i < ARRAY_SIZE(pdata->vbus_pin); i++) {
+		at91_for_each_port(i) {
 			if (!gpio_is_valid(pdata->vbus_pin[i]))
 				continue;
 			gpio = pdata->vbus_pin[i];
@@ -578,7 +584,7 @@ static int ohci_hcd_at91_drv_probe(struct platform_device *pdev)
 			ohci_at91_usb_set_power(pdata, i, 1);
 		}
 
-		for (i = 0; i < ARRAY_SIZE(pdata->overcurrent_pin); i++) {
+		at91_for_each_port(i) {
 			if (!gpio_is_valid(pdata->overcurrent_pin[i]))
 				continue;
 			gpio = pdata->overcurrent_pin[i];
@@ -621,14 +627,14 @@ static int ohci_hcd_at91_drv_remove(struct platform_device *pdev)
 	int			i;
 
 	if (pdata) {
-		for (i = 0; i < ARRAY_SIZE(pdata->vbus_pin); i++) {
+		at91_for_each_port(i) {
 			if (!gpio_is_valid(pdata->vbus_pin[i]))
 				continue;
 			ohci_at91_usb_set_power(pdata, i, 0);
 			gpio_free(pdata->vbus_pin[i]);
 		}
 
-		for (i = 0; i < ARRAY_SIZE(pdata->overcurrent_pin); i++) {
+		at91_for_each_port(i) {
 			if (!gpio_is_valid(pdata->overcurrent_pin[i]))
 				continue;
 			free_irq(gpio_to_irq(pdata->overcurrent_pin[i]), pdev);
-- 
1.7.9.4

