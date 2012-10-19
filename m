Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab2JSIMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:12:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60837 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab2JSIMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:12:12 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] lp855x_bl: use generic PWM functions
Thread-Topic: [PATCH 1/2] lp855x_bl: use generic PWM functions
Thread-Index: Ac2t0WMMFWO85huLQxOk73R4nJPZTQ==
Date: Fri, 19 Oct 2012 08:11:50 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6417916D@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The LP855x family devices support the PWM input for the backlight control.
 Period of the PWM is configurable in the platform side.
 Platform specific functions are unnecessary anymore because
 generic PWM functions are used inside the driver.

 (PWM input mode)
 To set the brightness, new lp855x_pwm_ctrl() is used.
 If a PWM device is not allocated, devm_pwm_get() is called.
 The PWM consumer name is from the chip name such as 'lp8550' and 'lp8556'.
 To get the brightness value, no additional handling is required.
 Just the value of 'props.brightness' is returned.

 If the PWM driver is not ready while initializing the LP855x driver, it's OK.
 The PWM device can be retrieved later, when the brightness value is changed.

 Documentation is updated with an example.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 Documentation/backlight/lp855x-driver.txt |   10 ++-------
 drivers/video/backlight/lp855x_bl.c       |   34 +++++++++++++++++++----------
 include/linux/platform_data/lp855x.h      |    9 ++------
 3 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/Documentation/backlight/lp855x-driver.txt b/Documentation/backlight/lp855x-driver.txt
index f5e4caa..1529394 100644
--- a/Documentation/backlight/lp855x-driver.txt
+++ b/Documentation/backlight/lp855x-driver.txt
@@ -35,11 +35,8 @@ For supporting platform specific data, the lp855x platform data can be used.
 * mode : Brightness control mode. PWM or register based.
 * device_control : Value of DEVICE CONTROL register.
 * initial_brightness : Initial value of backlight brightness.
-* pwm_data : Platform specific pwm generation functions.
+* period_ns : Platform specific PWM period value. unit is nano.
 	     Only valid when brightness is pwm input mode.
-	     Functions should be implemented by PWM driver.
-	     - pwm_set_intensity() : set duty of PWM
-	     - pwm_get_intensity() : get current duty of PWM
 * load_new_rom_data :
 	0 : use default configuration data
 	1 : update values of eeprom or eprom registers on loading driver
@@ -71,8 +68,5 @@ static struct lp855x_platform_data lp8556_pdata = {
 	.mode = PWM_BASED,
 	.device_control = PWM_CONFIG(LP8556),
 	.initial_brightness = INITIAL_BRT,
-	.pwm_data = {
-		     .pwm_set_intensity = platform_pwm_set_intensity,
-		     .pwm_get_intensity = platform_pwm_get_intensity,
-		     },
+	.period_ns = 1000000,
 };
diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index aa6d4f7..c4fd72f 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -15,6 +15,7 @@
 #include <linux/backlight.h>
 #include <linux/err.h>
 #include <linux/platform_data/lp855x.h>
+#include <linux/pwm.h>
 
 /* Registers */
 #define BRIGHTNESS_CTRL		0x00
@@ -36,6 +37,7 @@ struct lp855x {
 	struct device *dev;
 	struct mutex xfer_lock;
 	struct lp855x_platform_data *pdata;
+	struct pwm_device *pwm;
 };
 
 static int lp855x_read_byte(struct lp855x *lp, u8 reg, u8 *data)
@@ -121,6 +123,25 @@ static int lp855x_init_registers(struct lp855x *lp)
 	return ret;
 }
 
+static void lp855x_pwm_ctrl(struct lp855x *lp, int br, int max_br)
+{
+	unsigned int period = lp->pdata->period_ns;
+	unsigned int duty = br * period / max_br;
+	struct pwm_device *pwm;
+
+	/* request pwm device with the consumer name */
+	if (!lp->pwm) {
+		pwm = devm_pwm_get(lp->dev, lp->chipname);
+		if (IS_ERR(pwm))
+			return;
+
+		lp->pwm = pwm;
+	}
+
+	pwm_config(lp->pwm, duty, period);
+	duty == 0 ? pwm_disable(lp->pwm) : pwm_enable(lp->pwm);
+}
+
 static int lp855x_bl_update_status(struct backlight_device *bl)
 {
 	struct lp855x *lp = bl_get_data(bl);
@@ -130,12 +151,10 @@ static int lp855x_bl_update_status(struct backlight_device *bl)
 		bl->props.brightness = 0;
 
 	if (mode == PWM_BASED) {
-		struct lp855x_pwm_data *pd = &lp->pdata->pwm_data;
 		int br = bl->props.brightness;
 		int max_br = bl->props.max_brightness;
 
-		if (pd->pwm_set_intensity)
-			pd->pwm_set_intensity(br, max_br);
+		lp855x_pwm_ctrl(lp, br, max_br);
 
 	} else if (mode == REGISTER_BASED) {
 		u8 val = bl->props.brightness;
@@ -150,14 +169,7 @@ static int lp855x_bl_get_brightness(struct backlight_device *bl)
 	struct lp855x *lp = bl_get_data(bl);
 	enum lp855x_brightness_ctrl_mode mode = lp->pdata->mode;
 
-	if (mode == PWM_BASED) {
-		struct lp855x_pwm_data *pd = &lp->pdata->pwm_data;
-		int max_br = bl->props.max_brightness;
-
-		if (pd->pwm_get_intensity)
-			bl->props.brightness = pd->pwm_get_intensity(max_br);
-
-	} else if (mode == REGISTER_BASED) {
+	if (mode == REGISTER_BASED) {
 		u8 val = 0;
 
 		lp855x_read_byte(lp, BRIGHTNESS_CTRL, &val);
diff --git a/include/linux/platform_data/lp855x.h b/include/linux/platform_data/lp855x.h
index 761f317..e81f62d 100644
--- a/include/linux/platform_data/lp855x.h
+++ b/include/linux/platform_data/lp855x.h
@@ -89,11 +89,6 @@ enum lp8556_brightness_source {
 	LP8556_COMBINED2,	/* pwm + i2c after the shaper block */
 };
 
-struct lp855x_pwm_data {
-	void (*pwm_set_intensity) (int brightness, int max_brightness);
-	int (*pwm_get_intensity) (int max_brightness);
-};
-
 struct lp855x_rom_data {
 	u8 addr;
 	u8 val;
@@ -105,7 +100,7 @@ struct lp855x_rom_data {
  * @mode : brightness control by pwm or lp855x register
  * @device_control : value of DEVICE CONTROL register
  * @initial_brightness : initial value of backlight brightness
- * @pwm_data : platform specific pwm generation functions.
+ * @period_ns : platform specific pwm period value. unit is nano.
 		Only valid when mode is PWM_BASED.
  * @load_new_rom_data :
 	0 : use default configuration data
@@ -118,7 +113,7 @@ struct lp855x_platform_data {
 	enum lp855x_brightness_ctrl_mode mode;
 	u8 device_control;
 	int initial_brightness;
-	struct lp855x_pwm_data pwm_data;
+	unsigned int period_ns;
 	u8 load_new_rom_data;
 	int size_program;
 	struct lp855x_rom_data *rom_data;
-- 
1.7.9.5


Best Regards,
Milo


