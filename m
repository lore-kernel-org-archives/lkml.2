Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab2KMJfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:35:21 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:34459 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab2KMJfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:35:19 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH] gpio: twl4030: Use only TWL4030_MODULE_LED for LED configuration
Date: Tue, 13 Nov 2012 10:35:13 +0100
Message-ID: <1352799313-21019-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid using the TWL4030_MODULE_PWMA/B as module ID. The LEDEN, PWMA ON/OFF
and PWMB ON/OFF registers are in a continuous range starting from LED base.
This is going to be helpful for further cleanup in the twl stack.

No functional changes.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/gpio/gpio-twl4030.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/gpio/gpio-twl4030.c b/drivers/gpio/gpio-twl4030.c
index c5f8ca2..d2138b0 100644
--- a/drivers/gpio/gpio-twl4030.c
+++ b/drivers/gpio/gpio-twl4030.c
@@ -88,11 +88,15 @@ static inline int gpio_twl4030_write(u8 address, u8 data)
 /*----------------------------------------------------------------------*/
 
 /*
- * LED register offsets (use TWL4030_MODULE_{LED,PWMA,PWMB}))
+ * LED register offsets from TWL_MODULE_LED base
  * PWMs A and B are dedicated to LEDs A and B, respectively.
  */
 
-#define TWL4030_LED_LEDEN	0x0
+#define TWL4030_LED_LEDEN_REG	0x00
+#define TWL4030_PWMAON_REG	0x01
+#define TWL4030_PWMAOFF_REG	0x02
+#define TWL4030_PWMBON_REG	0x03
+#define TWL4030_PWMBOFF_REG	0x04
 
 /* LEDEN bits */
 #define LEDEN_LEDAON		BIT(0)
@@ -104,9 +108,6 @@ static inline int gpio_twl4030_write(u8 address, u8 data)
 #define LEDEN_PWM_LENGTHA	BIT(6)
 #define LEDEN_PWM_LENGTHB	BIT(7)
 
-#define TWL4030_PWMx_PWMxON	0x0
-#define TWL4030_PWMx_PWMxOFF	0x1
-
 #define PWMxON_LENGTH		BIT(7)
 
 /*----------------------------------------------------------------------*/
@@ -145,7 +146,7 @@ static void twl4030_led_set_value(int led, int value)
 	else
 		cached_leden |= mask;
 	status = twl_i2c_write_u8(TWL4030_MODULE_LED, cached_leden,
-			TWL4030_LED_LEDEN);
+				  TWL4030_LED_LEDEN_REG);
 	mutex_unlock(&gpio_lock);
 }
 
@@ -216,33 +217,33 @@ static int twl_request(struct gpio_chip *chip, unsigned offset)
 	if (offset >= TWL4030_GPIO_MAX) {
 		u8	ledclr_mask = LEDEN_LEDAON | LEDEN_LEDAEXT
 				| LEDEN_LEDAPWM | LEDEN_PWM_LENGTHA;
-		u8	module = TWL4030_MODULE_PWMA;
+		u8	reg = TWL4030_PWMAON_REG;
 
 		offset -= TWL4030_GPIO_MAX;
 		if (offset) {
 			ledclr_mask <<= 1;
-			module = TWL4030_MODULE_PWMB;
+			reg = TWL4030_PWMBON_REG;
 		}
 
 		/* initialize PWM to always-drive */
-		status = twl_i2c_write_u8(module, 0x7f,
-				TWL4030_PWMx_PWMxOFF);
+		/* Configure PWM OFF register first */
+		status = twl_i2c_write_u8(TWL4030_MODULE_LED, 0x7f, reg + 1);
 		if (status < 0)
 			goto done;
-		status = twl_i2c_write_u8(module, 0x7f,
-				TWL4030_PWMx_PWMxON);
+
+		/* Followed by PWM ON register */
+		status = twl_i2c_write_u8(TWL4030_MODULE_LED, 0x7f, reg);
 		if (status < 0)
 			goto done;
 
 		/* init LED to not-driven (high) */
-		module = TWL4030_MODULE_LED;
-		status = twl_i2c_read_u8(module, &cached_leden,
-				TWL4030_LED_LEDEN);
+		status = twl_i2c_read_u8(TWL4030_MODULE_LED, &cached_leden,
+					 TWL4030_LED_LEDEN_REG);
 		if (status < 0)
 			goto done;
 		cached_leden &= ~ledclr_mask;
-		status = twl_i2c_write_u8(module, cached_leden,
-				TWL4030_LED_LEDEN);
+		status = twl_i2c_write_u8(TWL4030_MODULE_LED, cached_leden,
+					  TWL4030_LED_LEDEN_REG);
 		if (status < 0)
 			goto done;
 
-- 
1.8.0

