Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab2BTKM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 05:12:59 -0500
Received: from mail2.nsc.com ([12.238.8.132]:44091 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751568Ab2BTKM6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 05:12:58 -0500
X-WSS-ID: 0LZOSDG-0A-4QJ-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Axel Lin" <axel.lin@gmail.com>, "Richard Purdie" <rpurdie@rpsys.net>
Date: Mon, 20 Feb 2012 02:12:46 -0800
Subject: [PATCH 1/2] lp855x-bl: remove unnecessary platform data
Thread-Topic: [PATCH 1/2] lp855x-bl: remove unnecessary platform data
Thread-Index: AczvuDEy3k3ge8oFQXKpaEpq0fnAIg==
Message-ID: <B567DBAB974C0544994013492B949F8E3813076551@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 635CC3281LS10491312-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All lp855x devices have 8-bits brightness contorl register.
The value of max_brightness is set to 255.
So the max_brightness in the platform data is unnecessary.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Axel Lin <axel.lin@gmail.com>
---
 Documentation/backlight/lp855x-driver.txt |    3 ---
 drivers/video/backlight/lp855x_bl.c       |   11 +++++++----
 include/linux/lp855x.h                    |    2 --
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/Documentation/backlight/lp855x-driver.txt b/Documentation/backlight/lp855x-driver.txt
index 321351e..f5e4caa 100755
--- a/Documentation/backlight/lp855x-driver.txt
+++ b/Documentation/backlight/lp855x-driver.txt
@@ -35,7 +35,6 @@ For supporting platform specific data, the lp855x platform data can be used.
 * mode : Brightness control mode. PWM or register based.
 * device_control : Value of DEVICE CONTROL register.
 * initial_brightness : Initial value of backlight brightness.
-* max_brightness : Maximum value of backlight brightness.
 * pwm_data : Platform specific pwm generation functions.
 	     Only valid when brightness is pwm input mode.
 	     Functions should be implemented by PWM driver.
@@ -61,7 +60,6 @@ static struct lp855x_platform_data lp8552_pdata = {
 	.mode = REGISTER_BASED,
 	.device_control = I2C_CONFIG(LP8552),
 	.initial_brightness = INITIAL_BRT,
-	.max_brightness = MAX_BRT,
 	.load_new_rom_data = 1,
 	.size_program = ARRAY_SIZE(lp8552_eeprom_arr),
 	.rom_data = lp8552_eeprom_arr,
@@ -73,7 +71,6 @@ static struct lp855x_platform_data lp8556_pdata = {
 	.mode = PWM_BASED,
 	.device_control = PWM_CONFIG(LP8556),
 	.initial_brightness = INITIAL_BRT,
-	.max_brightness = MAX_BRT,
 	.pwm_data = {
 		     .pwm_set_intensity = platform_pwm_set_intensity,
 		     .pwm_get_intensity = platform_pwm_get_intensity,
diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 8d2d10c..640624b 100755
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -22,8 +22,9 @@
 #define BRIGHTNESS_CTRL		(0x00)
 #define DEVICE_CTRL		(0x01)
 
-#define BUF_SIZE		(20)
+#define BUF_SIZE		20
 #define DEFAULT_BL_NAME		"lcd-backlight"
+#define MAX_BRIGHTNESS		255
 
 struct lp855x {
 	const char *chipid;
@@ -171,10 +172,12 @@ static int lp855x_backlight_register(struct lp855x *lp)
 	char *name = pdata->name ? : DEFAULT_BL_NAME;
 
 	props.type = BACKLIGHT_PLATFORM;
+	props.max_brightness = MAX_BRIGHTNESS;
+
+	if (pdata->initial_brightness > props.max_brightness)
+		pdata->initial_brightness = props.max_brightness;
+
 	props.brightness = pdata->initial_brightness;
-	props.max_brightness =
-		(pdata->max_brightness < pdata->initial_brightness) ?
-		255 : pdata->max_brightness;
 
 	bl = backlight_device_register(name, lp->dev, lp,
 				       &lp855x_bl_ops, &props);
diff --git a/include/linux/lp855x.h b/include/linux/lp855x.h
index 4b124c1..781a490 100755
--- a/include/linux/lp855x.h
+++ b/include/linux/lp855x.h
@@ -109,7 +109,6 @@ struct lp855x_rom_data {
  * @mode : brightness control by pwm or lp855x register
  * @device_control : value of DEVICE CONTROL register
  * @initial_brightness : initial value of backlight brightness
- * @max_brightness : maximum value of backlight brightness
  * @pwm_data : platform specific pwm generation functions.
 		Only valid when mode is PWM_BASED.
  * @load_new_rom_data :
@@ -123,7 +122,6 @@ struct lp855x_platform_data {
 	enum lp855x_brightness_ctrl_mode mode;
 	u8 device_control;
 	int initial_brightness;
-	int max_brightness;
 	struct lp855x_pwm_data pwm_data;
 	u8 load_new_rom_data;
 	int size_program;
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated



