Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab0JEJnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 05:43:50 -0400
Received: from smtp.nokia.com ([192.100.105.134]:21267 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003Ab0JEJns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 05:43:48 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] Documentation: Short descriptions for bhsfh and apds990x drivers
Date: Tue,  5 Oct 2010 12:42:59 +0300
Message-Id: <1286271779-19819-6-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1286271779-19819-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1286271779-19819-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 05 Oct 2010 09:43:08.0917 (UTC) FILETIME=[B7DFCA50:01CB6471]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add short documentation for two ALS / proximity chip drivers.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 Documentation/misc-devices/apds990x.txt |  126 +++++++++++++++++++++++++++++++
 Documentation/misc-devices/bhsfh.txt    |  125 ++++++++++++++++++++++++++++++
 2 files changed, 251 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/misc-devices/apds990x.txt
 create mode 100644 Documentation/misc-devices/bhsfh.txt

diff --git a/Documentation/misc-devices/apds990x.txt b/Documentation/misc-devices/apds990x.txt
new file mode 100644
index 0000000..edffbea
--- /dev/null
+++ b/Documentation/misc-devices/apds990x.txt
@@ -0,0 +1,126 @@
+Kernel driver apds990x
+======================
+
+Supported chips:
+Avago APDS990X
+
+Data sheet:
+Not freely available
+
+Author:
+Samu Onkalo <samu.p.onkalo@nokia.com>
+
+Description
+-----------
+
+APDS990x is a combined ambient light and proximity sensor. ALS and proximity
+functionality are highly connected. ALS measurement path must be running
+while the proximity functionality is enabled.
+
+ALS produces only raw measurement values. Further processing is needed
+to get sensible LUX values. Vice versa, HW threshold control has nothing
+to do with LUX values. Threshold detection triggs to raw conversion values.
+Driver makes necessary conversions to both directions so that user handles
+only LUX values. ALS contains 4 different gain steps. Driver automatically
+selects suitable gain step. After each measurement, reliability of the results
+is estimated and new measurement is trigged if necessary.
+
+Platform data can provide tuned values to the conversion formulas if
+values are known. Othervise plain sensor default values are used.
+
+Proximity side is little bit simpler. It produces directly usable values.
+
+Driver controls chip operational state using pm_runtime framework.
+Voltage regulators are controlled based on chip operational state.
+
+SYSFS
+-----
+chip_id
+	RO - shows detected chip type and version
+
+power_state
+	RW - enable / disable chip. Uses counting logic
+	     1 enables the chip
+	     0 disables the chip
+lux0_input
+	RO - measured LUX value
+	     range: 0 .. 65535
+	     sysfs_notify called when threshold interrupt occurs
+
+lux0_input10x
+	RO - Same as lux0_input but values are 10x larger so accuracy
+	     is 0.1 lux
+	     range: 0 .. 655350
+lux0_rate
+	RW - measurement period in milliseconds
+
+lux0_rate_avail
+	RO - supported measurement periods
+
+lux0_calib
+	RW - calibration value. Set to neutral value by default
+
+lux0_calib_format
+	RO - neutral calibration value
+
+lux0_threshold_range
+	RW - lo and hi threshold values like "100 1000"
+	     range: 0 .. 65535
+
+prox0_enable
+	RW - enable / disable proximity - counting logic
+	     1 enables the proximity
+	     0 disables the proximity
+
+prox0_input
+	RO - measured proximity value
+	     range 0 .. 1023
+	     sysfs_notify called when threshold interrupt occurs
+
+prox0_continuous_mode
+	RW - When set, results above threshold are reported periodically.
+	     In this mode rough distance estimation is possible.
+	     Values: 0 and 1
+
+prox0_threshold
+	RW - threshold level which trigs proximity events.
+
+Platform data
+-------------
+
+
+#define APDS_IRLED_CURR_12mA	0x3
+#define APDS_IRLED_CURR_25mA	0x2
+#define APDS_IRLED_CURR_50mA	0x1
+#define APDS_IRLED_CURR_100mA	0x0
+
+/*
+ * Structure for tuning ALS calculation to match with environment.
+ * There depends on the material above the sensor and the sensor
+ * itself. If the GA is zero, driver will use uncovered sensor default values
+ * format: decimal value * APDS_PARAM_SCALE
+ */
+#define APDS_PARAM_SCALE 4096
+struct apds990x_chip_factors {
+	int ga;		/* Glass attenuation */
+	int cf1;	/* Clear channel factor 1 */
+	int irf1;	/* Ir channel factor 1 */
+	int cf2;	/* Clear channel factor 2 */
+	int irf2;	/* Ir channel factor 2 */
+	int df;		/* Device factor. Decimal number */
+};
+
+struct apds990x_platform_data {
+	struct apds990x_chip_factors cf;
+	u8     pdrive;
+	int    (*setup_resources)(void);
+	int    (*release_resources)(void);
+};
+
+chip factors are specific to for example dark plastic window
+above the sensor. Driver uses plain (uncovered) sensor default values
+if the platform data contains zero ga factor.
+
+pdrive is the IR led driver current
+
+setup / release resources handles interrupt line configurations.
diff --git a/Documentation/misc-devices/bhsfh.txt b/Documentation/misc-devices/bhsfh.txt
new file mode 100644
index 0000000..7f72f84
--- /dev/null
+++ b/Documentation/misc-devices/bhsfh.txt
@@ -0,0 +1,125 @@
+Kernel driver bhsfh
+===================
+
+Supported chips:
+ROHM BH1770GLC
+OSRAM SFH7770
+
+Data sheet:
+Not freely available
+
+Author:
+Samu Onkalo <samu.p.onkalo@nokia.com>
+
+Description
+-----------
+BH1770GLC and SFH7770 (I'm calling them as bhsfh) are combined ambient
+light and proximity sensors. ALS and proximity parts operates on their own,
+but they shares common I2C interface and interrupt logic.
+
+ALS produces 16 bit LUX values. The chip contains interrupt logic to produce
+low and high threshold interrupts.
+
+Proximity part contains IR-led driver up to 3 IR leds. The chip measures
+amount of reflected IR light and produces proximity result. Resolution is
+8 bit. Driver supports only one channel. Driver uses ALS results to estimate
+realibility of the proximity results. Thus ALS is always running while
+proximity detection is needed.
+
+Driver uses threshold interrupts to avoid need for polling the values.
+Proximity low interrupt doesn't exists in the chip. This is simulated
+by using a delayed work.
+
+SYSFS
+-----
+
+chip_id
+	RO - shows detected chip type and version
+
+power_state
+	RW - enable / disable chip. Uses counting logic
+	     1 enables the chip
+	     0 disables the chip
+
+lux0_input
+	RO - measured LUX value
+	     range: 0 .. 65535
+	     sysfs_notify called when threshold interrupt occurs
+
+lux0_rate
+	RW - measurement period in milliseconds
+
+lux0_rate_avail
+	RO - supported measurement periods
+
+lux0_threshold_range
+	RW - lo and hi threshold values like "100 1000"
+	     range: 0 .. 65535
+
+lux0_calib
+	RW - calibration value. Set to neutral value by default
+
+lux0_calib_format
+	RO - neutral calibration value
+
+prox0_input
+	RO - measured proximity value
+	     range 0 .. 255
+	     sysfs_notify called when threshold interrupt occurs
+
+prox0_enable
+	RW - enable / disable proximity - uses counting logic
+	     1 enables the proximity
+	     0 disables the proximity
+
+prox0_persistence
+	RW - number of proximity interrupts needed before triggering the event
+
+prox0_rate
+	RW - supported measurement periods. There are two values in this entry:
+	     First one is used when waiting for proximity event and the second
+	     one is used when waiting proximity reason to go away.
+
+prox0_rate
+	RO - available measurement periods
+
+prox0_threshold
+	RW - threshold level which trigs proximity events.
+	     Filtered by persistence filter
+
+prox0_abs_thres
+	RW - threshold level which trigs event immediately
+
+
+Platform data:
+
+struct bhsfh_platform_data {
+#define BHSFH_LED_5mA	0
+#define BHSFH_LED_10mA	1
+#define BHSFH_LED_20mA	2
+#define BHSFH_LED_50mA	3
+#define BHSFH_LED_100mA 4
+#define BHSFH_LED_150mA 5
+#define BHSFH_LED_200mA 6
+	__u8 led_def_curr;
+#define BHFSH_NEUTRAL_GA 16384 /* 16384 / 16384 = 1 */
+	__u32 glass_attenuation;
+	int (*setup_resources)(void);
+	int (*release_resources)(void);
+};
+
+led_def_curr controls IR led driving current
+glass_attenuation tells darkness of the covering window
+setup / release resources are call back functions for controlling
+interrupt line.
+
+Example:
+static struct bhsfh_platform_data rm680_bhsfh_data = {
+	.led_def_curr	   = BHSFH_LED_50mA,
+	.glass_attenuation = (16384 * 385) / 100,
+	.setup_resources   = bhsfh_setup,
+	.release_resources = bhsfh_release,
+};
+
+glass_attenuation: 385 in above formula means 3.85 in decimal.
+light_above_sensors = light_above_cover_window / 3.85
-- 
1.6.0.4

