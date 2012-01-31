Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab2AaAIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 19:08:18 -0500
Received: from mail2.nsc.com ([12.238.8.132]:52896 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754419Ab2AaAIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 19:08:15 -0500
X-WSS-ID: 0LYMZ1O-0A-IC3-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Arun MURTHY" <arun.murthy@stericsson.com>,
        "srinidhi kasagar" <srinidhi.kasagar@stericsson.com>,
        "Richard Purdie" <rpurdie@rpsys.net>
Date: Mon, 30 Jan 2012 16:08:02 -0800
Subject: [PATCH v2 4/4] leds-lp5521: redefinition of register bits
Thread-Topic: [PATCH v2 4/4] leds-lp5521: redefinition of register bits
Thread-Index: AczfrGZBVd23mBRaQXOCHmd3x/A89Q==
Message-ID: <B567DBAB974C0544994013492B949F8E3812DEC6A7@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6339EF6E1LS10031883-04-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For better readability, values of LP5521_REG_ENABLE register were redefined.
Additional definitions: LP5521_ENABLE_DEFAULT and LP5521_ENABLE_RUN_PROGRAM.

Use definition rather than hard code value.
: 0x3F -> 'LP5521_CMD_DIRECT'

* PATCH v2 : Just 'Acked-by' and 'Cc' are added. Same source files as previous version.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
---
 drivers/leds/leds-lp5521.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 471cef1..8368ce4 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -81,6 +81,10 @@
 #define LP5521_MASTER_ENABLE		0x40	/* Chip master enable */
 #define LP5521_LOGARITHMIC_PWM		0x80	/* Logarithmic PWM adjustment */
 #define LP5521_EXEC_RUN			0x2A
+#define LP5521_ENABLE_DEFAULT	\
+	(LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM)
+#define LP5521_ENABLE_RUN_PROGRAM	\
+	(LP5521_ENABLE_DEFAULT | LP5521_EXEC_RUN)
 
 /* Status */
 #define LP5521_EXT_CLK_USED		0x08
@@ -234,7 +238,7 @@ static int lp5521_configure(struct i2c_client *client)
 	lp5521_init_engine(chip);
 
 	/* Set all PWMs to direct control mode */
-	ret = lp5521_write(client, LP5521_REG_OP_MODE, 0x3F);
+	ret = lp5521_write(client, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
 
 	cfg = chip->pdata->update_config ?
 		: (LP5521_PWRSAVE_EN | LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT);
@@ -247,8 +251,7 @@ static int lp5521_configure(struct i2c_client *client)
 
 	/* Set engines are set to run state when OP_MODE enables engines */
 	ret |= lp5521_write(client, LP5521_REG_ENABLE,
-			LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM |
-			LP5521_EXEC_RUN);
+			LP5521_ENABLE_RUN_PROGRAM);
 	/* enable takes 500us. 1 - 2 ms leaves some margin */
 	usleep_range(1000, 2000);
 
@@ -299,8 +302,7 @@ static int lp5521_detect(struct i2c_client *client)
 	int ret;
 	u8 buf;
 
-	ret = lp5521_write(client, LP5521_REG_ENABLE,
-			LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM);
+	ret = lp5521_write(client, LP5521_REG_ENABLE, LP5521_ENABLE_DEFAULT);
 	if (ret)
 		return ret;
 	/* enable takes 500us. 1 - 2 ms leaves some margin */
@@ -308,7 +310,7 @@ static int lp5521_detect(struct i2c_client *client)
 	ret = lp5521_read(client, LP5521_REG_ENABLE, &buf);
 	if (ret)
 		return ret;
-	if (buf != (LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM))
+	if (buf != LP5521_ENABLE_DEFAULT)
 		return -ENODEV;
 
 	return 0;
@@ -573,8 +575,7 @@ static void lp5521_run_led_pattern(int mode, struct lp5521_chip *chip)
 		return;
 
 	if (mode == PATTERN_OFF) {
-		lp5521_write(cl, LP5521_REG_ENABLE,
-			LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM);
+		lp5521_write(cl, LP5521_REG_ENABLE, LP5521_ENABLE_DEFAULT);
 		usleep_range(1000, 2000);
 		lp5521_write(cl, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
 	} else {
@@ -596,9 +597,7 @@ static void lp5521_run_led_pattern(int mode, struct lp5521_chip *chip)
 
 		lp5521_write(cl, LP5521_REG_OP_MODE, LP5521_CMD_RUN);
 		usleep_range(1000, 2000);
-		lp5521_write(cl, LP5521_REG_ENABLE,
-			LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM |
-			LP5521_EXEC_RUN);
+		lp5521_write(cl, LP5521_REG_ENABLE, LP5521_ENABLE_RUN_PROGRAM);
 	}
 }
 
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated




