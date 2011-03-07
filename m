Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab1CGHk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 02:40:56 -0500
Received: from smtp-out-189.synserver.de ([212.40.185.189]:1132 "HELO
	smtp-out-189.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755191Ab1CGHks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 02:40:48 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 20568
From: Lars-Peter Clausen <lars@metafoo.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/2] USB: s3c2410_udc: Add common implementation for GPIO controlled pullups
Date: Mon,  7 Mar 2011 08:41:59 +0100
Message-Id: <1299483720-18175-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all boards using the s3c2410_udc driver use a GPIO to control the
state of the pullup, as a result the same code is reimplemented in each board
file.
This patch adds support for using a GPIO to control the pullup state to the udc
driver, so the boards can use a common implementation.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/arm/plat-s3c24xx/include/plat/udc.h |    4 ++
 drivers/usb/gadget/s3c2410_udc.c         |   60 +++++++++++++++++++++++++----
 2 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/arch/arm/plat-s3c24xx/include/plat/udc.h b/arch/arm/plat-s3c24xx/include/plat/udc.h
index 546bb40..80457c6 100644
--- a/arch/arm/plat-s3c24xx/include/plat/udc.h
+++ b/arch/arm/plat-s3c24xx/include/plat/udc.h
@@ -27,6 +27,10 @@ enum s3c2410_udc_cmd_e {
 struct s3c2410_udc_mach_info {
 	void	(*udc_command)(enum s3c2410_udc_cmd_e);
  	void	(*vbus_draw)(unsigned int ma);
+
+	unsigned int pullup_pin;
+	unsigned int pullup_pin_inverted;
+
 	unsigned int vbus_pin;
 	unsigned char vbus_pin_inverted;
 };
diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index 2b02520..6d8b040 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -1481,7 +1481,9 @@ static int s3c2410_udc_set_pullup(struct s3c2410_udc *udc, int is_on)
 {
 	dprintk(DEBUG_NORMAL, "%s()\n", __func__);
 
-	if (udc_info && udc_info->udc_command) {
+	if (udc_info && (udc_info->udc_command ||
+		gpio_is_valid(udc_info->pullup_pin))) {
+
 		if (is_on)
 			s3c2410_udc_enable(udc);
 		else {
@@ -1558,6 +1560,32 @@ static const struct usb_gadget_ops s3c2410_ops = {
 	.vbus_draw		= s3c2410_vbus_draw,
 };
 
+static void s3c2410_udc_command(enum s3c2410_udc_cmd_e cmd)
+{
+	if (!udc_info)
+		return;
+
+	if (udc_info->udc_command) {
+		udc_info->udc_command(S3C2410_UDC_P_DISABLE);
+	} else if (gpio_is_valid(udc_info->pullup_pin)) {
+		int value;
+
+		switch (cmd) {
+		case S3C2410_UDC_P_ENABLE:
+			value = 1;
+			break;
+		case S3C2410_UDC_P_DISABLE:
+			value = 0;
+			break;
+		default:
+			return;
+		}
+		value ^= udc_info->pullup_pin_inverted;
+
+		gpio_set_value(udc_info->pullup_pin, value);
+	}
+}
+
 /*------------------------- gadget driver handling---------------------------*/
 /*
  * s3c2410_udc_disable
@@ -1579,8 +1607,7 @@ static void s3c2410_udc_disable(struct s3c2410_udc *dev)
 	udc_write(0x1F, S3C2410_UDC_EP_INT_REG);
 
 	/* Good bye, cruel world */
-	if (udc_info && udc_info->udc_command)
-		udc_info->udc_command(S3C2410_UDC_P_DISABLE);
+	s3c2410_udc_command(S3C2410_UDC_P_DISABLE);
 
 	/* Set speed to unknown */
 	dev->gadget.speed = USB_SPEED_UNKNOWN;
@@ -1641,8 +1668,7 @@ static void s3c2410_udc_enable(struct s3c2410_udc *dev)
 	udc_write(S3C2410_UDC_INT_EP0, S3C2410_UDC_EP_INT_EN_REG);
 
 	/* time to say "hello, world" */
-	if (udc_info && udc_info->udc_command)
-		udc_info->udc_command(S3C2410_UDC_P_ENABLE);
+	s3c2410_udc_command(S3C2410_UDC_P_ENABLE);
 }
 
 /*
@@ -1917,6 +1943,17 @@ static int s3c2410_udc_probe(struct platform_device *pdev)
 		udc->vbus = 1;
 	}
 
+	if (udc_info && !udc_info->udc_command &&
+		gpio_is_valid(udc_info->pullup_pin)) {
+
+		retval = gpio_request_one(udc_info->pullup_pin,
+				udc_info->vbus_pin_inverted ?
+				GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW,
+				"udc pullup");
+		if (retval)
+			goto err_vbus_irq;
+	}
+
 	if (s3c2410_udc_debugfs_root) {
 		udc->regs_info = debugfs_create_file("registers", S_IRUGO,
 				s3c2410_udc_debugfs_root,
@@ -1929,6 +1966,9 @@ static int s3c2410_udc_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_vbus_irq:
+	if (udc_info && udc_info->vbus_pin > 0)
+		free_irq(gpio_to_irq(udc_info->vbus_pin), udc);
 err_gpio_claim:
 	if (udc_info && udc_info->vbus_pin > 0)
 		gpio_free(udc_info->vbus_pin);
@@ -1956,6 +1996,10 @@ static int s3c2410_udc_remove(struct platform_device *pdev)
 
 	debugfs_remove(udc->regs_info);
 
+	if (udc_info && !udc_info->udc_command &&
+		gpio_is_valid(udc_info->pullup_pin))
+		gpio_free(udc_info->pullup_pin);
+
 	if (udc_info && udc_info->vbus_pin > 0) {
 		irq = gpio_to_irq(udc_info->vbus_pin);
 		free_irq(irq, udc);
@@ -1987,16 +2031,14 @@ static int s3c2410_udc_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int s3c2410_udc_suspend(struct platform_device *pdev, pm_message_t message)
 {
-	if (udc_info && udc_info->udc_command)
-		udc_info->udc_command(S3C2410_UDC_P_DISABLE);
+	s3c2410_udc_command(S3C2410_UDC_P_DISABLE);
 
 	return 0;
 }
 
 static int s3c2410_udc_resume(struct platform_device *pdev)
 {
-	if (udc_info && udc_info->udc_command)
-		udc_info->udc_command(S3C2410_UDC_P_ENABLE);
+	s3c2410_udc_command(S3C2410_UDC_P_ENABLE);
 
 	return 0;
 }
-- 
1.7.2.3

