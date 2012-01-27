Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab2A0Iuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 03:50:40 -0500
Received: from mail2.nsc.com ([12.238.8.132]:35153 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750984Ab2A0Iuj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 03:50:39 -0500
X-WSS-ID: 0LYG8KA-0A-35Z-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Richard Purdie" <rpurdie@rpsys.net>, "Kim, Milo" <Milo.Kim@nsc.com>
Date: Fri, 27 Jan 2012 00:50:19 -0800
Subject: [PATCH v3 1/3] backlight: new backlight driver for LP855x
 devices
Thread-Topic: [PATCH v3 1/3] backlight: new backlight driver for LP855x
 devices
Thread-Index: Aczc0LJ3Swzsi1zyQz6aphAWUcA+Dw==
Message-ID: <B567DBAB974C0544994013492B949F8E3812D6EB8B@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633CBAD81LS9967020-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports TI LP8550/LP8551/LP8552/LP8553/LP8556 backlight driver.

The brightness can be controlled by the I2C or PWM input.
The lp855x driver provides both modes.
For the PWM control, pwm-specific functions can be defined in the platform data.
And some information can be read via the sysfs(lp855x device attributes).

For the details, please refer to 'Documentation/backlight/lp855x-driver.txt'.

* patch based on kernel 3.0.1

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 Documentation/backlight/lp855x-driver.txt |   81 +++++++++++++++++++++++++++++
 drivers/video/backlight/Kconfig           |    7 +++
 drivers/video/backlight/Makefile          |    1 +
 3 files changed, 89 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/backlight/lp855x-driver.txt

diff --git a/Documentation/backlight/lp855x-driver.txt b/Documentation/backlight/lp855x-driver.txt
new file mode 100644
index 0000000..321351e
--- /dev/null
+++ b/Documentation/backlight/lp855x-driver.txt
@@ -0,0 +1,81 @@
+Kernel driver lp855x
+====================
+
+Backlight driver for LP855x ICs
+
+Supported chips:
+	Texas Instruments LP8550, LP8551, LP8552, LP8553 and LP8556
+
+Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+
+Description
+-----------
+
+* Brightness control
+
+Brightness can be controlled by the pwm input or the i2c command.
+The lp855x driver supports both cases.
+
+* Device attributes
+
+1) bl_ctl_mode
+Backlight control mode.
+Value : pwm based or register based
+
+2) chip_id
+The lp855x chip id.
+Value : lp8550/lp8551/lp8552/lp8553/lp8556
+
+Platform data for lp855x
+------------------------
+
+For supporting platform specific data, the lp855x platform data can be used.
+
+* name : Backlight driver name. If it is not defined, default name is set.
+* mode : Brightness control mode. PWM or register based.
+* device_control : Value of DEVICE CONTROL register.
+* initial_brightness : Initial value of backlight brightness.
+* max_brightness : Maximum value of backlight brightness.
+* pwm_data : Platform specific pwm generation functions.
+	     Only valid when brightness is pwm input mode.
+	     Functions should be implemented by PWM driver.
+	     - pwm_set_intensity() : set duty of PWM
+	     - pwm_get_intensity() : get current duty of PWM
+* load_new_rom_data :
+	0 : use default configuration data
+	1 : update values of eeprom or eprom registers on loading driver
+* size_program : Total size of lp855x_rom_data.
+* rom_data : List of new eeprom/eprom registers.
+
+example 1) lp8552 platform data : i2c register mode with new eeprom data
+
+#define EEPROM_A5_ADDR	0xA5
+#define EEPROM_A5_VAL	0x4f	/* EN_VSYNC=0 */
+
+static struct lp855x_rom_data lp8552_eeprom_arr[] = {
+	{EEPROM_A5_ADDR, EEPROM_A5_VAL},
+};
+
+static struct lp855x_platform_data lp8552_pdata = {
+	.name = "lcd-bl",
+	.mode = REGISTER_BASED,
+	.device_control = I2C_CONFIG(LP8552),
+	.initial_brightness = INITIAL_BRT,
+	.max_brightness = MAX_BRT,
+	.load_new_rom_data = 1,
+	.size_program = ARRAY_SIZE(lp8552_eeprom_arr),
+	.rom_data = lp8552_eeprom_arr,
+};
+
+example 2) lp8556 platform data : pwm input mode with default rom data
+
+static struct lp855x_platform_data lp8556_pdata = {
+	.mode = PWM_BASED,
+	.device_control = PWM_CONFIG(LP8556),
+	.initial_brightness = INITIAL_BRT,
+	.max_brightness = MAX_BRT,
+	.pwm_data = {
+		     .pwm_set_intensity = platform_pwm_set_intensity,
+		     .pwm_get_intensity = platform_pwm_get_intensity,
+		     },
+};
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 2d93c8d..995088a 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -327,6 +327,13 @@ config BACKLIGHT_PCF50633
 	  If you have a backlight driven by a NXP PCF50633 MFD, say Y here to
 	  enable its driver.
 
+config BACKLIGHT_LP855X
+	tristate "Backlight driver for TI LP855X"
+	depends on BACKLIGHT_CLASS_DEVICE && I2C
+	help
+	  This supports TI LP8550, LP8551, LP8552, LP8553 and LP8556
+	  backlight driver.
+
 endif # BACKLIGHT_CLASS_DEVICE
 
 endif # BACKLIGHT_LCD_SUPPORT
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index ee72adb..27788c9 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -37,4 +37,5 @@ obj-$(CONFIG_BACKLIGHT_ADP8860)	+= adp8860_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP8870)	+= adp8870_bl.o
 obj-$(CONFIG_BACKLIGHT_88PM860X) += 88pm860x_bl.o
 obj-$(CONFIG_BACKLIGHT_PCF50633)	+= pcf50633-backlight.o
+obj-$(CONFIG_BACKLIGHT_LP855X)	+= lp855x_bl.o
 
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated




