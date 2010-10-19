Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865Ab0JSHKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 03:10:53 -0400
Received: from smtp.nokia.com ([147.243.1.47]:25502 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758081Ab0JSHKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 03:10:31 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: akpm@linux-foundation.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv4 5/5] Documentation: Short descriptions for bh1770glc and apds990x drivers
Date: Tue, 19 Oct 2010 10:09:48 +0300
Message-Id: <1287472188-10101-6-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287472188-10101-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1287472188-10101-1-git-send-email-samu.p.onkalo@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add short documentation for two ALS / proximity chip drivers.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 Documentation/misc-devices/apds990x.txt  |  111 ++++++++++++++++++++++++++++
 Documentation/misc-devices/bh1770glc.txt |  116 ++++++++++++++++++++++++++++++
 2 files changed, 227 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/misc-devices/apds990x.txt
 create mode 100644 Documentation/misc-devices/bh1770glc.txt

diff --git a/Documentation/misc-devices/apds990x.txt b/Documentation/misc-devices/apds990x.txt
new file mode 100644
index 0000000..d5408ca
--- /dev/null
+++ b/Documentation/misc-devices/apds990x.txt
@@ -0,0 +1,111 @@
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
+ALS produces raw measurement values for two channels: Clear channel
+(infrared + visible light) and IR only. However, threshold comparisons happen
+using clear channel only. Lux value and the threshold level on the HW
+might vary quite much depending the spectrum of the light source.
+
+Driver makes necessary conversions to both directions so that user handles
+only lux values. Lux value is calculated using information from the both
+channels. HW threshold level is calculated from the given lux value to match
+with current type of the lightning. Sometimes inaccuracy of the estimations
+lead to false interrupt, but that doesn't harm.
+
+ALS contains 4 different gain steps. Driver automatically
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
+	RO - measured lux value
+	     sysfs_notify called when threshold interrupt occurs
+
+lux0_sensor_range
+	RO - lux0_input max value. Actually never reaches since sensor tends
+	     to saturate much before that. Real max value varies depending
+	     on the light spectrum etc.
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
diff --git a/Documentation/misc-devices/bh1770glc.txt b/Documentation/misc-devices/bh1770glc.txt
new file mode 100644
index 0000000..7d64c01
--- /dev/null
+++ b/Documentation/misc-devices/bh1770glc.txt
@@ -0,0 +1,116 @@
+Kernel driver bh1770glc
+=======================
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
+BH1770GLC and SFH7770 are combined ambient light and proximity sensors.
+ALS and proximity parts operates on their own, but they shares common I2C
+interface and interrupt logic. In principle they can run on their own,
+but ALS side results are used to estimate reliability of the proximity sensor.
+
+ALS produces 16 bit lux values. The chip contains interrupt logic to produce
+low and high threshold interrupts.
+
+Proximity part contains IR-led driver up to 3 IR leds. The chip measures
+amount of reflected IR light and produces proximity result. Resolution is
+8 bit. Driver supports only one channel. Driver uses ALS results to estimate
+reliability of the proximity results. Thus ALS is always running while
+proximity detection is needed.
+
+Driver uses threshold interrupts to avoid need for polling the values.
+Proximity low interrupt doesn't exists in the chip. This is simulated
+by using a delayed work. As long as there is proximity threshold above
+interrupts the delayed work is pushed forward. So, when proximity level goes
+below the threshold value, there is no interrupt and the delayed work will
+finally run. This is handled as no proximity indication.
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
+	RO - measured lux value
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
+	RO - Supported proximity measurement rates in Hz
+
+prox0_thresh_above0_value
+	RW - threshold level which trigs proximity events.
+	     Filtered by persistence filter (prox0_thresh_above_count)
+
+prox0_thresh_above1_value
+	RW - threshold level which trigs event immediately
-- 
1.6.0.4

