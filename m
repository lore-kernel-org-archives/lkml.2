Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab0IPKNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 06:13:24 -0400
Received: from smtp.nokia.com ([192.100.105.134]:27611 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab0IPKNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 06:13:21 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: rpurdie@linux.intel.com
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Documentation: led drivers lp5521 and lp5523
Date: Thu, 16 Sep 2010 13:12:26 +0300
Message-Id: <1284631946-5350-5-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1284631946-5350-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1284631946-5350-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 16 Sep 2010 10:12:37.0239 (UTC) FILETIME=[B0071070:01CB5587]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create sub directory Documentation/leds and
add short documentation for LP5521 and LP5523 drivers.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 Documentation/leds/leds-lp5521.txt |   85 ++++++++++++++++++++++++++++++++++++
 Documentation/leds/leds-lp5523.txt |   81 ++++++++++++++++++++++++++++++++++
 2 files changed, 166 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/leds/leds-lp5521.txt
 create mode 100644 Documentation/leds/leds-lp5523.txt

diff --git a/Documentation/leds/leds-lp5521.txt b/Documentation/leds/leds-lp5521.txt
new file mode 100644
index 0000000..62a8066
--- /dev/null
+++ b/Documentation/leds/leds-lp5521.txt
@@ -0,0 +1,85 @@
+Kernel driver for lp5521
+========================
+
+* National Semiconductor LP5521 led driver chip
+* Datasheet: http://www.national.com/pf/LP/LP5521.html
+
+Authors: Mathias Nyman, Yuri Zaporozhets, Samu Onkalo
+Contact: Samu Onkalo (samu.p.onkalo-at-nokia.com)
+
+Description
+-----------
+
+LP5521 can drive up to 3 channels. Leds can be controlled directly via
+led class control interface. Channels have a generic names:
+lp5521:channelx, where x is 0 .. 2
+
+All three channels can be also controlled using engine micro programs.
+More details of the instructions can be found from public data sheet.
+
+Control interface for engines:
+x is 1 .. 3
+enginex_mode : disabled, load, run
+enginex_load : store program (visible only in engine load mode)
+
+Example (start to blink the channel 2 led):
+cd   /sys/class/leds/lp5521:channel2/device
+echo "load" > engine3_mode
+echo "037f4d0003ff6000" > engine3_load
+echo "run" > engine3_mode
+
+stop the engine:
+echo "disabled" > engine3_mode
+
+sysfs contains also selftest entry.
+It communicates with the chip and checks that
+clock mode is automatically set to requested one.
+
+Each channel contains led current settings.
+/sys/class/leds/lp5521:channel0/led_current - RW
+/sys/class/leds/lp5521:channel0/max_current - RO
+Format: 10x mA i.e 10 means 1.0 mA
+
+example platform data:
+static struct lp5521_led_config lp5521_led_config[] = {
+        {
+                .chan_nr        = 0,
+                .led_current    = 50,
+		.max_current    = 130,
+        }, {
+                .chan_nr        = 1,
+                .led_current    = 0,
+		.max_current    = 130,
+        }, {
+                .chan_nr        = 2,
+                .led_current    = 0,
+		.max_current    = 130,
+        }
+};
+
+static int lp5521_setup(void)
+{
+	/* setup HW resources */
+}
+
+static void lp5521_release(void)
+{
+	/* Release HW resources */
+}
+
+static void lp5521_enable(bool state)
+{
+	/* Control of chip enable signal */
+}
+
+static struct lp5521_platform_data lp5521_platform_data = {
+        .led_config     = lp5521_led_config,
+        .num_channels   = ARRAY_SIZE(lp5521_led_config),
+        .clock_mode     = LP5521_CLOCK_EXT,
+        .setup_resources   = lp5521_setup,
+        .release_resources = lp5521_release,
+        .enable            = lp5521_enable,
+};
+
+If the current is set to 0 in the platform data, that channel is
+disabled and it is not visible in the sysfs.
diff --git a/Documentation/leds/leds-lp5523.txt b/Documentation/leds/leds-lp5523.txt
new file mode 100644
index 0000000..915298d
--- /dev/null
+++ b/Documentation/leds/leds-lp5523.txt
@@ -0,0 +1,81 @@
+Kernel driver for lp5523
+========================
+
+* National Semiconductor LP5523 led driver chip
+* Datasheet: http://www.national.com/pf/LP/LP5523.html
+
+Authors: Mathias Nyman, Yuri Zaporozhets, Samu Onkalo
+Contact: Samu Onkalo (samu.p.onkalo-at-nokia.com)
+
+Description
+-----------
+LP5523 can drive up to 9 channels. Leds can be controlled directly via
+led class control interface. Channels have a generic names:
+lp5523:channelx where x is 0...8
+
+Chip provides 3 engines which can be control channels without main CPU
+interaction. Details of the micro engine code can be found from the
+public data sheet. Leds can be muxed to different channels.
+
+Control interface for engines:
+x is 1 .. 3
+enginex_mode : disabled, load, run
+enginex_load : microcode load (visible only in load mode)
+enginex_leds : led mux control (visible only in load mode)
+
+cd /sys/class/leds/lp5523:channel2/device
+echo "load" > engine3_mode
+echo "9d80400004ff05ff437f0000" > engine3_load
+echo "111111111" > engine3_leds
+echo "run" > engine3_mode
+
+sysfs contains also selftest entry. It measures each channel
+voltage level and checks if it looks reasonable. Too high
+level means missing led and to low value means short circuit.
+Selftest uses always current from platform data.
+
+Each channel contains led current settings.
+/sys/class/leds/lp5523:channel2/led_current - RW
+/sys/class/leds/lp5523:channel2/max_current - RO
+Format: 10x mA i.e 10 means 1.0 mA
+
+Example platform data:
+
+static struct lp5523_led_config lp5523_led_config[] = {
+        {
+                .chan_nr        = 0,
+                .led_current    = 50,
+		.max_current    = 130,
+        },
+...
+        }, {
+                .chan_nr        = 8,
+                .led_current    = 50,
+		.max_current    = 130,
+        }
+};
+
+static int lp5523_setup(void)
+{
+	/* Setup HW resources */
+}
+
+static void lp5523_release(void)
+{
+	/* Release HW resources */
+}
+
+static void lp5523_enable(bool state)
+{
+	/* Control chip enable signal */
+}
+
+static struct lp5523_platform_data lp5523_platform_data = {
+        .led_config     = lp5523_led_config,
+        .num_channels   = ARRAY_SIZE(lp5523_led_config),
+        .clock_mode     = LP5523_CLOCK_EXT,
+        .setup_resources   = lp5523_setup,
+        .release_resources = lp5523_release,
+        .enable            = lp5523_enable,
+};
+
-- 
1.6.0.4

