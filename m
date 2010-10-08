Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab0JHNme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:42:34 -0400
Received: from smtp.nokia.com ([192.100.122.233]:62345 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab0JHNma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:42:30 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, jic23@cam.ac.uk,
        alan@lxorguk.ukuu.org.uk
Subject: [PATCHv2 5/5] Documentation: Short descriptions for bhsfh and apds990x drivers
Date: Fri,  8 Oct 2010 16:42:04 +0300
Message-Id: <1286545324-18506-6-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1286545324-18506-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1286545324-18506-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 08 Oct 2010 13:42:18.0250 (UTC) FILETIME=[9FFB7EA0:01CB66EE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add short documentation for two ALS / proximity chip drivers.

bhsfh document update

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 Documentation/misc-devices/apds990x.txt |  152 +++++++++++++++++++++++++++++++
 Documentation/misc-devices/bhsfh.txt    |  148 ++++++++++++++++++++++++++++++
 2 files changed, 300 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/misc-devices/apds990x.txt
 create mode 100644 Documentation/misc-devices/bhsfh.txt

diff --git a/Documentation/misc-devices/apds990x.txt b/Documentation/misc-devices/apds990x.txt
new file mode 100644
index 0000000..7b61495
--- /dev/null
+++ b/Documentation/misc-devices/apds990x.txt
@@ -0,0 +1,152 @@
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
+values are known. Otherwise plain sensor default values are used.
+
+Proximity side is little bit simpler. There is no need for complex conversions.
+It produces directly usable values.
+
+Driver controls chip operational state using pm_runtime framework.
+Voltage regulators are controlled based on chip operational state.
+
+SYSFS
+-----
+
+
+chip_id
+	RO - shows detected chip type and version
+
+power_state
+	RW - enable / disable chip. Uses counting logic
+	     1 enables the chip
+	     0 disables the chip
+lux0_input
+	RO - measured LUX value
+	     sysfs_notify called when threshold interrupt occurs
+
+lux0_sensor_range
+	RO - lux0_input max value. Actually never reaches since sensor tends
+	     to saturate much before that. Real max value varies depending
+	     on the light spectrum etc.
+
+
+lux0_rate
+	RW - measurement rate in Hz
+
+lux0_rate_avail
+	RO - supported measurement rates
+
+lux0_calibscale
+	RW - calibration value. Set to neutral value by default.
+	     Output results are multiplied with calibscale / calibscale_default
+	     value.
+
+lux0_calibscale_default
+	RO - neutral calibration value
+
+lux0_thresh_above_value
+	RW - HI level threshold value. All results above the value
+	     trigs an interrupt. 65535 (i.e. sensor_range) disables the above
+	     interrupt.
+
+lux0_thresh_below_value
+	RW - LO level threshold value. All results below the value
+	     trigs an interrupt. 0 disables the below interrupt.
+
+prox0_raw
+	RO - measured proximity value
+	     sysfs_notify called when threshold interrupt occurs
+
+prox0_sensor_range
+	RO - prox0_raw max value (1023)
+
+prox0_raw_en
+	RW - enable / disable proximity - uses counting logic
+	     1 enables the proximity
+	     0 disables the proximity
+
+prox0_reporting_mode
+	RW - trigger / periodic. In "trigger" mode the driver tells two possible
+	     values: 0 or prox0_sensor_range value. 0 means no proximity,
+	     1023 means proximity. This causes minimal number of interrupts.
+	     In "periodic" mode the driver reports all values above
+	     prox0_thresh_above. This causes more interrupts, but it can give
+	     _rough_ estimate about the distance.
+
+prox0_reporting_mode_avail
+	RO - accepted values to prox0_reporting_mode (trigger, periodic)
+
+prox0_thresh_above_value
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
+	u8     ppcount;
+	int    (*setup_resources)(void);
+	int    (*release_resources)(void);
+};
+
+chip factors are specific to for example dark plastic window
+above the sensor. Driver uses plain (uncovered) sensor default values
+if the platform data contains zero ga factor.
+
+"pdrive" is the IR led driver current
+
+"ppcount" is the number of the IR pulses used for proximity detection.
+5 is for example quite good value.
+
+Proximity detection range and overall behaviour is heavily affected
+by cover window, IR led driving strength and ppcount.
+
+setup / release resources handles interrupt line configurations.
diff --git a/Documentation/misc-devices/bhsfh.txt b/Documentation/misc-devices/bhsfh.txt
new file mode 100644
index 0000000..84568fc
--- /dev/null
+++ b/Documentation/misc-devices/bhsfh.txt
@@ -0,0 +1,148 @@
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
+Chip state is controlled via runtime pm framework when enabled in config.
+
+Calibscale factor is used to hide differences between the chips. By default
+value set to neutral state meaning factor of 1.00. To get proper values,
+calibrated source of light is needed as a reference. Calibscale factor is set
+so that measurement produces about the expected lux value.
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
+	     sysfs_notify called when threshold interrupt occurs
+
+lux0_sensor_range
+	RO - lux0_input max value
+
+lux0_rate
+	RW - measurement rate in Hz
+
+lux0_rate_avail
+	RO - supported measurement rates
+
+lux0_thresh_above_value
+	RW - HI level threshold value. All results above the value
+	     trigs an interrupt. 65535 (i.e. sensor_range) disables the above
+	     interrupt.
+
+lux0_thresh_below_value
+	RW - LO level threshold value. All results below the value
+	     trigs an interrupt. 0 disables the below interrupt.
+
+lux0_calibscale
+	RW - calibration value. Set to neutral value by default.
+	     Output results are multiplied with calibscale / calibscale_default
+	     value.
+
+lux0_calibscale_default
+	RO - neutral calibration value
+
+prox0_raw
+	RO - measured proximity value
+	     sysfs_notify called when threshold interrupt occurs
+
+prox0_sensor_range
+	RO - prox0_raw max value
+
+prox0_raw_en
+	RW - enable / disable proximity - uses counting logic
+	     1 enables the proximity
+	     0 disables the proximity
+
+prox0_thresh_above_count
+	RW - number of proximity interrupts needed before triggering the event
+
+prox0_rate_above
+	RW - Measurement rate (in Hz) when the level is above threshold
+	     i.e. when proximity on has been reported.
+
+prox0_rate_below
+	RW - Measurement rate (in Hz) when the level is below threshold
+	     i.e. when proximity off has been reported.
+
+prox0_rate_avail
+	RO - Supported proxity measurement rates in Hz
+
+
+prox0_thresh_above0_value
+	RW - threshold level which trigs proximity events.
+	     Filtered by persistence filter (prox0_thresh_above_count)
+
+prox0_thresh_above1_value
+	RW - threshold level which trigs event immediately
+
+
+Platform data:
+--------------
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

