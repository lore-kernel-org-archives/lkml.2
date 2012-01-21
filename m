Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab2AUSKB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:10:01 -0500
Received: from mail2.nsc.com ([12.238.8.132]:54017 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751294Ab2AUSJo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:09:44 -0500
X-WSS-ID: 0LY5UG1-0A-3OZ-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Date: Sat, 21 Jan 2012 10:09:31 -0800
Subject: [PATCH 2/4] leds-lp5521: add 'update_config' in the
 lp5521_platform_data
Thread-Topic: [PATCH 2/4] leds-lp5521: add 'update_config' in the
 lp5521_platform_data
Thread-Index: AczYZ9LHrvHWLbKwTyaqeFikntXMDQ==
Message-ID: <B567DBAB974C0544994013492B949F8E3812CD3807@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 630420DE1LS9843276-03-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value of CONFIG register(Addr 08h) is configurable.
For supporting this feature, update_config is added in the platform data.
If 'update_config' is not defined, the default value is
'LP5521_PWRSAVE_EN | LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT'.

To define CONFIG register in the platform data, the bit definitions were moved
to the header file.

Documentation updated : description about 'update_config' and example.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 Documentation/leds/leds-lp5521.txt |   19 +++++++++++++++++++
 drivers/leds/leds-lp5521.c         |   19 ++++---------------
 include/linux/leds-lp5521.h        |   13 +++++++++++++
 3 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/Documentation/leds/leds-lp5521.txt b/Documentation/leds/leds-lp5521.txt
index f48ab75..e3c66c6 100644
--- a/Documentation/leds/leds-lp5521.txt
+++ b/Documentation/leds/leds-lp5521.txt
@@ -92,3 +92,22 @@ static struct lp5521_platform_data lp5521_platform_data = {
 
 If the current is set to 0 in the platform data, that channel is
 disabled and it is not visible in the sysfs.
+
+The 'update_config' : CONFIG register (ADDR 08h)
+This value is platform-specific data.
+If update_config is not defined, the CONFIG register is set with
+'LP5521_PWRSAVE_EN | LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT'.
+(Enable auto-powersave, set charge pump to auto, red to battery)
+
+example of update_config :
+
+#define LP5521_CONFIGS	(LP5521_PWM_HF | LP5521_PWRSAVE_EN | \
+			LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT | \
+			LP5521_CLK_INT)
+
+static struct lp5521_platform_data lp5521_pdata = {
+	.led_config = lp5521_led_config,
+	.num_channels = ARRAY_SIZE(lp5521_led_config),
+	.clock_mode = LP5521_CLOCK_INT,
+	.update_config = LP5521_CONFIGS,
+};
diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index c0e7c10..4fa792d 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -82,18 +82,6 @@
 #define LP5521_LOGARITHMIC_PWM		0x80	/* Logarithmic PWM adjustment */
 #define LP5521_EXEC_RUN			0x2A
 
-/* Bits in CONFIG register */
-#define LP5521_PWM_HF			0x40	/* PWM: 0 = 256Hz, 1 = 558Hz */
-#define LP5521_PWRSAVE_EN		0x20	/* 1 = Power save mode */
-#define LP5521_CP_MODE_OFF		0	/* Charge pump (CP) off */
-#define LP5521_CP_MODE_BYPASS		8	/* CP forced to bypass mode */
-#define LP5521_CP_MODE_1X5		0x10	/* CP forced to 1.5x mode */
-#define LP5521_CP_MODE_AUTO		0x18	/* Automatic mode selection */
-#define LP5521_R_TO_BATT		4	/* R out: 0 = CP, 1 = Vbat */
-#define LP5521_CLK_SRC_EXT		0	/* Ext-clk source (CLK_32K) */
-#define LP5521_CLK_INT			1	/* Internal clock */
-#define LP5521_CLK_AUTO			2	/* Automatic clock selection */
-
 /* Status */
 #define LP5521_EXT_CLK_USED		0x08
 
@@ -238,15 +226,16 @@ static int lp5521_configure(struct i2c_client *client)
 {
 	struct lp5521_chip *chip = i2c_get_clientdata(client);
 	int ret;
+	u8 cfg;
 
 	lp5521_init_engine(chip);
 
 	/* Set all PWMs to direct control mode */
 	ret = lp5521_write(client, LP5521_REG_OP_MODE, 0x3F);
 
-	/* Enable auto-powersave, set charge pump to auto, red to battery */
-	ret |= lp5521_write(client, LP5521_REG_CONFIG,
-		LP5521_PWRSAVE_EN | LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT);
+	cfg = chip->pdata->update_config ?
+		: (LP5521_PWRSAVE_EN | LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT);
+	ret |= lp5521_write(client, LP5521_REG_CONFIG, cfg);
 
 	/* Initialize all channels PWM to zero -> leds off */
 	ret |= lp5521_write(client, LP5521_REG_R_PWM, 0);
diff --git a/include/linux/leds-lp5521.h b/include/linux/leds-lp5521.h
index e675b8d..e9ab583 100644
--- a/include/linux/leds-lp5521.h
+++ b/include/linux/leds-lp5521.h
@@ -36,6 +36,18 @@ struct lp5521_led_config {
 #define LP5521_CLOCK_INT	1
 #define LP5521_CLOCK_EXT	2
 
+/* Bits in CONFIG register */
+#define LP5521_PWM_HF			0x40	/* PWM: 0 = 256Hz, 1 = 558Hz */
+#define LP5521_PWRSAVE_EN		0x20	/* 1 = Power save mode */
+#define LP5521_CP_MODE_OFF		0	/* Charge pump (CP) off */
+#define LP5521_CP_MODE_BYPASS		8	/* CP forced to bypass mode */
+#define LP5521_CP_MODE_1X5		0x10	/* CP forced to 1.5x mode */
+#define LP5521_CP_MODE_AUTO		0x18	/* Automatic mode selection */
+#define LP5521_R_TO_BATT		4	/* R out: 0 = CP, 1 = Vbat */
+#define LP5521_CLK_SRC_EXT		0	/* Ext-clk source (CLK_32K) */
+#define LP5521_CLK_INT			1	/* Internal clock */
+#define LP5521_CLK_AUTO			2	/* Automatic clock selection */
+
 struct lp5521_platform_data {
 	struct lp5521_led_config *led_config;
 	u8	num_channels;
@@ -44,6 +56,7 @@ struct lp5521_platform_data {
 	void	(*release_resources)(void);
 	void	(*enable)(bool state);
 	const char *label;
+	u8	update_config;
 };
 
 #endif /* __LINUX_LP5521_H */
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated


