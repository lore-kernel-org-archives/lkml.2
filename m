Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab2FTFaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 01:30:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43407 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab2FTFaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 01:30:04 -0400
From: "G.Shark Jeong" <gshark.jeong@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        milo kim <milo.kim@ti.com>, <linux-doc@vger.kernel.org>,
        "G.Shark Jeong" <gshark.jeong@gmail.com>
Subject: [PATCH] Document : Add LED driver for lm3556 chip
Date: Wed, 20 Jun 2012 14:27:22 +0900
Message-Id: <1340170042-4537-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "G.Shark Jeong" <gshark.jeong@gmail.com>

LM3556 :
The LM3556 is a 4 MHz fixed-frequency synchronous boost
converter plus 1.5A constant current driver for a high-current white LED.
Datasheet: www.national.com/ds/LM/LM3556.pdf

Signed-off-by: G.Shark Jeong <gshark.jeong@gmail.com>
---
 Documentation/leds/00-INDEX        |    2 +
 Documentation/leds/leds-lm3556.txt |   86 ++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/leds/leds-lm3556.txt

diff --git a/Documentation/leds/00-INDEX b/Documentation/leds/00-INDEX
index 29f481d..5fefe37 100644
--- a/Documentation/leds/00-INDEX
+++ b/Documentation/leds/00-INDEX
@@ -6,3 +6,5 @@ leds-lp5521.txt
 	- notes on how to use the leds-lp5521 driver.
 leds-lp5523.txt
 	- notes on how to use the leds-lp5523 driver.
+leds-lm3556.txt
+	- notes on how to use the leds-lm3556 driver.
diff --git a/Documentation/leds/leds-lm3556.txt b/Documentation/leds/leds-lm3556.txt
new file mode 100644
index 0000000..debdf87
--- /dev/null
+++ b/Documentation/leds/leds-lm3556.txt
@@ -0,0 +1,86 @@
+Kernel driver for lm3556 
+======================== 
+
+*Texas Instrument:
+ 1.5 A Synchronous Boost LED Flash Driver w/ High-Side Current Source 
+* Datasheet: http://www.national.com/ds/LM/LM3556.pdf
+
+Authors: 
+	Daniel Jeong 
+	Contact:Daniel Jeong(daniel.jeong-at-ti.com, gshark.jeong-at-gmail.com)
+
+Description
+-----------
+There are 3 functions in LM3556, Flash, Torch and Indicator.
+
+FLASH MODE 
+In Flash Mode, the LED current source(LED) provides 16 target current levels 
+from 93.75 mA to 1500 mA.The Flash currents are adjusted via the CURRENT 
+CONTROL REGISTER(0x09).Flash mode is activated by the ENABLE REGISTER(0x0A),
+or by pulling the STROBE pin HIGH.
+LM3556 Flash can be controlled through sys/class/leds/flash/brightness file 
+* if STROBE pin is enabled, below example control brightness only, and 
+ON / OFF will be controlled by STROBE pin.
+
+Flash Example:
+OFF     : #echo 0 > sys/class/leds/flash/brightness
+93.75 mA: #echo 1 > sys/class/leds/flash/brightness
+... .....
+1500  mA: #echo 16 > sys/class/leds/flash/brightness
+
+TORCH MODE
+In Torch Mode, the current source(LED) is programmed via the CURRENT CONTROL 
+REGISTER(0x09).Torch Mode is activated by the ENABLE REGISTER(0x0A) or by the 
+hardware TORCH input.
+LM3556 torch can be controlled through sys/class/leds/torch/brightness file. 
+* if TORCH pin is enabled, below example control brightness only,
+and ON / OFF will be controlled by TORCH pin.
+
+Torch Example:
+OFF     : #echo 0 > sys/class/leds/torch/brightness
+46.88 mA: #echo 1 > sys/class/leds/torch/brightness
+... .....
+375 mA  : #echo 8 > sys/class/leds/torch/brightness
+
+INDICATOR MODE
+Indicater pattern can be set through sys/class/leds/indicator/pattern file,
+and 4 patterns are pre-defined in indicator_pattern array.
+According to N-lank, Pulse time and N Period values, different pattern wiill 
+be generated.If you want new patterns for your own device, change 
+indicator_pattern array with your own values and INDIC_PATTERN_SIZE.
+Please refer datasheet for more detail about N-Blank, Pulse time and N Period.
+
+Indicator pattern example:
+pattern 0: #echo 0 > sys/class/leds/indicator/pattern
+....
+pattern 3: #echo 3 > sys/class/leds/indicator/pattern
+
+Indicater brightness can be controlled through 
+sys/class/leds/indicator/brightness file.
+
+Example:
+OFF      : #echo 0 > sys/class/leds/indicator/brightness
+5.86 mA  : #echo 1 > sys/class/leds/indicator/brightness
+........
+46.875mA : #echo 8 > sys/class/leds/indicator/brightness
+
+Notes
+-----
+Driver expects it is registered using the i2c_board_info mechanism.
+Toregister the chip at address 0x63 on specific adapter, set the platform data
+ according to include/linux/platform_data/leds-lm3556.h, set the i2c board info: 
+
+Example: 
+	static struct i2c_board_info __initdata board_i2c_ch4[]	= {
+		{
+			 I2C_BOARD_INFO(LM3556_NAME, 0x63),
+			 .platform_data = &lm3556_pdata,
+		 },
+	};
+
+and register it in the platform init function
+
+Example:
+	board_register_i2c_bus(4, 400, 
+				board_i2c_ch4, ARRAY_SIZE(board_i2c_ch4));
+
-- 
1.7.5.4

