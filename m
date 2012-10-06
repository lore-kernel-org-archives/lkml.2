Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab2JFELL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 00:11:11 -0400
Received: from [12.239.217.82] ([12.239.217.82]:59240 "EHLO
	brontomerus.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751296Ab2JFEKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 00:10:49 -0400
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chen <alexandra.chen@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [RFC PATCH 01/06] input/rmi4: Public header and documentation
Date: Fri,  5 Oct 2012 21:09:58 -0700
Message-Id: <1349496603-20775-2-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As requested in the feedback from the previous patch, we've documented the
debugfs and sysfs attributes in files in Documentation/ABI/testing.  There's
two files, one for debugfs and one for sysfs.


Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

---

 Documentation/ABI/testing/debugfs-rmi4 |   99 +++++
 Documentation/ABI/testing/sysfs-rmi4   |  103 +++++
 include/linux/rmi.h                    |  696 ++++++++++++++++++++++++++++++++
 3 files changed, 898 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/debugfs-rmi4 b/Documentation/ABI/testing/debugfs-rmi4
new file mode 100644
index 0000000..cf1aa2d
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-rmi4
@@ -0,0 +1,99 @@
+What:		/sys/kernel/debug/rmi/devices
+Date:		October 2012
+KernelVersion:	3.x
+Contact:	Christopher Heiny <cheiny@synaptics.com>
+Description:
+
+  The RMI4 driver implementation exposes a set of informational and control
+  parameters via debugs.  These parameters are those that typically are only
+  viewed or adjusted during product development, tuning, and debug.
+  For parameters that are  referenced and/or adjusted during normal operation,
+  please see sysfs-rmi4 in this directory.
+
+  General debugging parameters for a particular RMI4 sensor are found in
+  /sys/kernel/debug/rmi/sensorXX/, where XX is a the device's ID as a two
+  digit number (padded with leading zeros).  Function specific parameters
+  for an RMI4 sensor are found in /sys/kernel/debug/rmi/devices/FYY/, where
+  XX is a the device's ID as a two digit number (padded with leading zeros)
+  and YY is the hexdecimal function number (for example, F11 for RMI function
+  F11).
+
+  For RMI4 functions that support multiple sensor instances (such as F11),
+  the parameters for individual sensors have .Z appended to them, where Z is
+  the index of the sensor instance (for example, clip.0, clip.1, clip.2, and
+  so on).
+
+  Some of the parameters exposed here are described in detail in the
+  RMI4 Specification, which is found here:
+    http://www.synaptics.com/sites/default/files/511-000136-01_revD.pdf
+  For such parameters, we'll reference you to that document, rather than
+  copying the contents here.
+
+  /sys/kernel/debug/rmi/
+      /sensorXX/
+          attn_count - (ro) Shows the number of ATTN interrupts handled so far.
+          comms_debug - (rw) Write 1 to this dump information about register
+                  reads and writes to the console.  Write 0 to this to turn
+                  this feature off.  WARNING: Imposes a major performance
+                  penalty when turned on.
+          irq_debug - (rw) Write 1 to this dump information about interrupts
+                  to the console.  Write 0 to this to turn this feature off.
+                  WARNIG: Imposes a major performance penalty when turned on.
+          phys - (ro) Presents information about the physical connection of
+                  this device.  It has one line, with the format:
+
+                       prot tx_count tx_bytes tx_errors rx_count rx_bytes rx_errors attn
+
+                  Where
+                       prot is one of i2c, spi1, or spi2
+                       tx_count is the number of write operations
+                       tx_bytes is the number of bytes written
+                       tx_errors is the number of write operations that encountered errors
+                       rx_count is the number of read operations
+                       rx_bytes is the total number of bytes read
+                       rx_errors is the number of read operations that encountered errors
+
+                  All counts are 64-bit unsigned values, and are set to zero
+                  when the physical layer driver is initialized.
+
+      /sensorXX/F01/
+          interrupt_enable - (rw) allows you to read or modify the F01
+                  interrupt enable mask (the F01_RMI_Ctrl1 register(s)).
+
+      /sensorXX/F11/
+          clip.Z - (rw) Controls in-driver coordinate clipping for the 2D
+                  sensor Z.  This is a set of four unsigned values in the
+                  range [0..65535], representing the lower bounds on X, the
+                  upper bounds on X, the lower bounds on Y, and the upper
+                  bounds on Y.  Coordinates will be clipped to these ranges.
+                  If enabled, clip is the final transformation to be applied
+                  to the coordinates. The default upper and lower bounds for
+                  clip are 0 and 65535 respectively for both axes.
+          delta_threshold.Z - (rw) Controls the F11 distance thresholds. This
+                  contains two values, corresponding to F11_2D_Ctrl2 and
+                  F11_2D_Ctrl3.  Se the spec for more details.
+          flip.Z - (rw) This parameter is a pair of single binary digits (for
+                  example, "0 0" or "1 0"), corresponding to the X and Y axis.
+                  Writing a 1 for a particular axis will invert the coordinates
+                  reported by the device along that axis.  For example writing
+                  "0 1" to this parameter will flip the Y axis top to bottom,
+                  but leave the X axis unchanged.  If enabled, flip is applied
+                  after swap and before offset.
+          offset.Z - (rw) This is a pair of values that will be SUBTRACTED
+                  from the X and Y coordinates, respectively.  If non-zero,
+                  offset will be applied after flip and before clip.  The
+                  default value for offset is 0 for both X and Y.
+          rezero_wait - (rw) If non-zero, F11 will wait this many milliseconds
+                  after exiting suspend mode before recalibrating the sensor(s).
+                  This is useful in systems were there may be unusual
+                  electrical conditions during the resume process, allowing
+                  you to delay recalibration until the electrical environment
+                  has stabilized.
+          swap.Z - (rw) Writing 1 to this parameter swaps the X and Y axis as
+                  reported by the sensor instance Z, rotating the reported
+                  coordinates by 90 degrees.  This can be useful when
+                  installing a landscape sensor over a portrait display, for
+                  example. The default state for this parameter is 0.  If
+                  enabled, swap is applied before any other transformation.
+          type_a - (rw) Most RMI4 F11 implementations support MT-B reporting.
+                  You can write 1 to this parameter to force MT-A reporting.
diff --git a/Documentation/ABI/testing/sysfs-rmi4 b/Documentation/ABI/testing/sysfs-rmi4
new file mode 100644
index 0000000..3354d10
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-rmi4
@@ -0,0 +1,103 @@
+What:		/sys/bus/rmi/devices
+Date:		October 2012
+KernelVersion:	3.x
+Contact:	Christopher Heiny <cheiny@synaptics.com>
+Description:
+
+  The RMI4 driver implementation exposes a set of informational and control
+  parameters via sysfs.  These parameters are those that typically will be
+  referenced and/or adjusted during normal operation of products containing
+  RMI sensors.  For paramters that are only viewed or adjusted during product
+  development and debug, please see debugfs-rmi4 in this directory.
+
+  General parameters for a particular RMI4 sensor are found in
+  /sys/bus/rmi/devices/sensorXX/, where XX is a the device's ID as a two
+  digit number (padded with leading zeros).  Function specific parameters
+  for an RMI4 sensor are found in /sys/bus/rmi/devices/sensorXX.fnYY/, where
+  XX is a the device's ID as a two digit number (padded with leading zeros)
+  and YY is the hexdecimal function number (for example, fn11 for RMI function
+  F11).
+
+  Many of the parameters exposed here are described in detail in the
+  RMI4 Specification, which is found here:
+    http://www.synaptics.com/sites/default/files/511-000136-01_revD.pdf
+  For such parameters, we'll reference you to that document, rather than
+  copying the contents here.
+
+  /sys/bus/rmi/devices
+      /sensorXX/
+          bsr ... (rw) bus select register, if supported (see spec)
+          enabled ... (rw) enable/disable interrupt management [deprecated]
+
+      /sensor00.fn01/
+          chargerinput ... (rw) User space programs can use this to tell the
+                  sensor that the system is plugged into an external power
+                  source (as opposed to running on batteries).  This allows
+                  the sensor firmware to make necessary adjustments for the
+                  current capacitence regime.  Write 1 to this when the
+                  system is using external power, write 0 to this when the
+                  system is running on batteries.  See spec for full details.
+          configured ... (ro) Shows the current state of the configured bit.
+                  This will be 1 most of the time (indicating the device has
+                  been appropriately configured), but will switch to 0 briefly
+                  if the sensor experiences a firmware or ASIC reset event.
+                  See spec for full details.
+          datecode ... (ro) The date on which the module was manufactured.
+                  See spec for full details.
+          doze_holdoff ... (rw) Controls how long the sensor will wait before
+                  entering the doze state when no fingers are present on the
+                  device. The time is in terms of 10 milliseconds - a
+                  doze_holdoff value of 3 corresponds to a time period of 30
+                  milliseconds.  See spec for full details.
+          flashprog ... (ro) Defines the current device operating mode. The
+                  flashprog flag is set if the normal operation of the device
+                  is suspended because the device is in a flash programming
+                  enabled state.  See spec for full details.
+          interrupt_enable ... (ro) This represents the current RMI4 interrupt
+                  mask (F01_RMI_Ctrl1 registers).  See spec for full details.
+          manufacturer ... (ro) This is the identity of the manufacturer of
+                  the device, as obtained from F01_RMI_Query0.  See spec for
+                  full details.
+          nosleep ... (rw) Writing 1 to this parameter disables all normal
+                  firmware powersaving behaviors and forces the device to run
+                  at full power without sleeping.  See spec for full details.
+          productid ... (ro) The product info bytes, as determined from
+                  F01_RMI_Query2 and F01_RMI_Query3 registers.  See spec for
+                  full details.
+          productinfo ... (ro) A string of up to 10 characters, identifying
+                  the product.  See spec for full details.
+          reportrate ... (rw) This is the current value of the RMI4 ReportRate
+                  bit (F01_RMI_Ctrl0, bit 6).  The meaning of this bit is very
+                  much device-dependent. Please see both the RMI4 spec and the
+                  sensor spec sheet for details.
+          reset ... (wo)  Writing a 1 to this write only register forces the
+                  device to reset.
+          sleepmode ... (rw) Controls power management on the device.  Writing
+                  0 to this parameter puts the device into its normal operating
+                  mode.  Writing 1 to this parameter fully disables touch
+                  sensors and similar inputs - no touch data will be reported
+                  from the device in this mode.  Writing 2 or 3 to this device
+                  may or may not have an effect, depending on the particular
+                  device - see the product specification for your sensor for
+                  details.
+          statuscode ... (ro) Reports the most recent device status, such as
+                  invalid configuration, device reset, CRC failure, and so on.
+                  Please se the RMI4 specification for details.
+          unconfigured ... (ro) This is the opposite of the configured bit,
+                  described above.
+          wakeup_threshold ... (rw) This controls the change in capacitive
+                  signal needed to wake the device from the doze state.  Please
+                  see the RMI4 specification for the F01_RMI_Ctrl3 register
+                  for more details.
+
+      /sensor00.fn11/
+          abs_pos_filt ... (rw) Enables or disables the absolute position
+                  filter feature.  See spec for full details.
+          maxPos ... (rw) Adjusts the  maximum X and Y position control
+                  registers (F11_2D_Ctrl6 through F11_2D_Ctrl9).  See spec for
+                  full details.
+          relreport ... (rw) Enables or disabled relative finger motion
+                  reporting.  See spec for full details.
+          rezero ... (wo) Force recalibration of the F11 2D sensor(s).  See
+                  spec for full details.
+
diff --git a/include/linux/rmi.h b/include/linux/rmi.h
new file mode 100644
index 0000000..1bdedc0
--- /dev/null
+++ b/include/linux/rmi.h
@@ -0,0 +1,696 @@
+/*
+ * Copyright (c) 2011, 2012 Synaptics Incorporated
+ * Copyright (c) 2011 Unixphere
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _RMI_H
+#define _RMI_H
+#include <linux/kernel.h>
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/list.h>
+#include <linux/lockdep.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/stat.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+
+#ifdef CONFIG_RMI4_DEBUG
+#include <linux/debugfs.h>
+#endif
+
+extern struct bus_type rmi_bus_type;
+
+extern struct device_type rmi_function_type;
+extern struct device_type rmi_sensor_type;
+
+
+/* Permissions for sysfs attributes.  Since the permissions policy will change
+ * on a global basis in the future, rather than edit all sysfs attrs everywhere
+ * in the driver (and risk screwing that up in the process), we use this handy
+ * set of #defines.  That way when we change the policy for sysfs permissions,
+ * we only need to change them here.
+ */
+#define RMI_RO_ATTR S_IRUGO
+#define RMI_RW_ATTR (S_IRUGO | S_IWUGO)
+#define RMI_WO_ATTR S_IWUGO
+
+enum rmi_attn_polarity {
+	RMI_ATTN_ACTIVE_LOW = 0,
+	RMI_ATTN_ACTIVE_HIGH = 1
+};
+
+/**
+ * struct rmi_f11_axis_alignment - target axis alignment
+ * @swap_axes: set to TRUE if desired to swap x- and y-axis
+ * @flip_x: set to TRUE if desired to flip direction on x-axis
+ * @flip_y: set to TRUE if desired to flip direction on y-axis
+ * @clip_X_low - reported X coordinates below this setting will be clipped to
+ *               the specified value
+ * @clip_X_high - reported X coordinates above this setting will be clipped to
+ *               the specified value
+ * @clip_Y_low - reported Y coordinates below this setting will be clipped to
+ *               the specified value
+ * @clip_Y_high - reported Y coordinates above this setting will be clipped to
+ *               the specified value
+ * @offset_X - this value will be added to all reported X coordinates
+ * @offset_Y - this value will be added to all reported Y coordinates
+ * @rel_report_enabled - if set to true, the relative reporting will be
+ *               automatically enabled for this sensor.
+ */
+struct rmi_f11_2d_axis_alignment {
+	bool swap_axes;
+	bool flip_x;
+	bool flip_y;
+	int clip_X_low;
+	int clip_Y_low;
+	int clip_X_high;
+	int clip_Y_high;
+	int offset_X;
+	int offset_Y;
+	int rel_report_enabled;
+	u8 delta_x_threshold;
+	u8 delta_y_threshold;
+};
+
+/**
+ * struct virtualbutton_map - describes rectangular areas of a 2D sensor that
+ * will be used by the driver to generate button events.
+ *
+ * @x - the x position of the low order corner of the rectangle, in RMI4
+ * position units.
+ * @y - the y position of the low order corner of the rectangle, in RMI4
+ * position units.
+ * @width - the width of the rectangle, in RMI4 position units.
+ * @height - the height of the rectangle, in RMI4 position units.
+ * @code - the input subsystem key event code that will be generated when a
+ * tap occurs within the rectangle.
+ */
+struct virtualbutton_map {
+	u16 x;
+	u16 y;
+	u16 width;
+	u16 height;
+	u16 code;
+};
+
+/**
+ * struct rmi_f11_virtualbutton_map - provides a list of virtual buttons for
+ * a 2D sensor.
+ *
+ * @buttons - the number of entries in the map.
+ * @map - an array of virtual button descriptions.
+ */
+struct rmi_f11_virtualbutton_map {
+	u8 buttons;
+	struct virtualbutton_map *map;
+};
+
+/**
+ * struct rmi_f11_sensor_data - overrides defaults for a single F11 2D sensor.
+ * @axis_align - provides axis alignment overrides (see above).
+ * @virtual_buttons - describes areas of the touch sensor that will be treated
+ *                    as buttons.
+ * @type_a - all modern RMI F11 firmwares implement Multifinger Type B
+ * protocol.  Set this to true to force MF Type A behavior, in case you find
+ * an older sensor.
+ */
+struct rmi_f11_sensor_data {
+	struct rmi_f11_2d_axis_alignment axis_align;
+	struct rmi_f11_virtualbutton_map virtual_buttons;
+	bool type_a;
+};
+
+/**
+ * struct rmi_f01_power - override default power management settings.
+ *
+ */
+enum rmi_f01_nosleep {
+	RMI_F01_NOSLEEP_DEFAULT = 0,
+	RMI_F01_NOSLEEP_OFF = 1,
+	RMI_F01_NOSLEEP_ON = 2
+};
+
+/**
+ * struct rmi_f01_power_management -When non-zero, these values will be written
+ * to the touch sensor to override the default firmware settigns.  For a
+ * detailed explanation of what each field does, see the corresponding
+ * documention in the RMI4 specification.
+ *
+ * @nosleep - specifies whether the device is permitted to sleep or doze (that
+ * is, enter a temporary low power state) when no fingers are touching the
+ * sensor.
+ * @wakeup_threshold - controls the capacitance threshold at which the touch
+ * sensor will decide to wake up from that low power state.
+ * @doze_holdoff - controls how long the touch sensor waits after the last
+ * finger lifts before entering the doze state, in units of 100ms.
+ * @doze_interval - controls the interval between checks for finger presence
+ * when the touch sensor is in doze mode, in units of 10ms.
+ */
+struct rmi_f01_power_management {
+	enum rmi_f01_nosleep nosleep;
+	u8 wakeup_threshold;
+	u8 doze_holdoff;
+	u8 doze_interval;
+};
+
+/**
+ * struct rmi_button_map - used to specify the initial input subsystem key
+ * event codes to be generated by buttons (or button like entities) on the
+ * touch sensor.
+ * @nbuttons - length of the button map.
+ * @map - the key event codes for the corresponding buttons on the touch
+ * sensor.
+ */
+struct rmi_button_map {
+	u8 nbuttons;
+	u8 *map;
+};
+
+struct rmi_f30_gpioled_map {
+	u8 ngpioleds;
+	u8 *map;
+};
+
+/**
+ * struct rmi_device_platform_data_spi - provides paramters used in SPI
+ * communitcations.  All Synaptics SPI products support a standard SPI
+ * interface; some also support what is called SPI V2 mode, depending on
+ * firmware and/or ASIC limitations.  In V2 mode, the touch sensor can
+ * support shorter delays during certain operations, and these are specified
+ * separately from the standard mode delays.
+ *
+ * @block_delay - for standard SPI transactions consisting of both a read and
+ * write operation, the delay (in microseconds) between the read and write
+ * operations.
+ * @split_read_block_delay_us - for V2 SPI transactions consisting of both a
+ * read and write operation, the delay (in microseconds) between the read and
+ * write operations.
+ * @read_delay_us - the delay between each byte of a read operation in normal
+ * SPI mode.
+ * @write_delay_us - the delay between each byte of a write operation in normal
+ * SPI mode.
+ * @split_read_byte_delay_us - the delay between each byte of a read operation
+ * in V2 mode.
+ * @pre_delay_us - the delay before the start of a SPI transaction.  This is
+ * typically useful in conjunction with custom chip select assertions (see
+ * below).
+ * @post_delay_us - the delay after the completion of an SPI transaction.  This is
+ * typically useful in conjunction with custom chip select assertions (see
+ * below).
+ * @cs_assert - For systems where the SPI subsystem does not control the CS/SSB
+ * line, or where such control is broken, you can provide a custom routine to
+ * handle a GPIO as CS/SSB.  This routine will be called at the beginning and
+ * end of each SPI transaction.  The RMI SPI implementation will wait
+ * pre_delay_us after this routine returns before starting the SPI transfer;
+ * and post_delay_us after completion of the SPI transfer(s) before calling it
+ * with assert==FALSE.
+ */
+struct rmi_device_platform_data_spi {
+	int block_delay_us;
+	int split_read_block_delay_us;
+	int read_delay_us;
+	int write_delay_us;
+	int split_read_byte_delay_us;
+	int pre_delay_us;
+	int post_delay_us;
+
+	void *cs_assert_data;
+	int (*cs_assert) (const void *cs_assert_data, const bool assert);
+};
+
+/**
+ * struct rmi_device_platform_data - system specific configuration info.
+ *
+ * @driver_name
+ * @sensor_name - this is used for various diagnostic messages.
+ *
+ * @firmware_name - if specified will override default firmware name,
+ * for reflashing.
+ *
+ * @attn_gpio - the index of a GPIO that will be used to provide the ATTN
+ * interrupt from the touch sensor.
+ * @attn_polarity - indicates whether ATTN is active high or low.
+ * @level_triggered - by default, the driver uses edge triggered interrupts.
+ * However, this can cause problems with suspend/resume on some platforms.  In
+ * that case, set this to 1 to use level triggered interrupts.
+ * @gpio_config - a routine that will be called when the driver is loaded to
+ * perform any platform specific GPIO configuration, and when it is unloaded
+ * for GPIO de-configuration.  This is typically used to configure the ATTN
+ * GPIO and the I2C or SPI pins, if necessary.
+ * @gpio_data - platform specific data to be passed to the GPIO configuration
+ * function.
+ *
+ * @reset_delay_ms - after issuing a reset command to the touch sensor, the
+ * driver waits a few milliseconds to give the firmware a chance to
+ * to re-initialize.  You can override the default wait period here.
+ *
+ * @spi_data - override default settings for SPI delays and SSB management (see
+ * above).
+ *
+ * @f11_sensor_data - an array of platform data for individual F11 2D sensors.
+ * @f11_sensor_count - the length of f11_sensor_data array.  Extra entries will
+ * be ignored; if there are too few entries, all settings for the additional
+ * sensors will be defaulted.
+ * @f11_rezero_wait - if non-zero, this is how may milliseconds the F11 2D
+ * sensor(s) will wait before being be rezeroed on exit from suspend.  If
+ * this value is zero, the F11 2D sensor(s) will not be rezeroed on resume.
+ * @pre_suspend - this will be called before any other suspend operations are
+ * done.
+ * @power_management - overrides default touch sensor doze mode settings (see
+ * above)
+ * @f19_button_map - provide initial input subsystem key mappings for F19.
+ * @f1a_button_map - provide initial input subsystem key mappings for F1A.
+ * @gpioled_map - provides initial settings for GPIOs and LEDs controlled by
+ * F30.
+ * @f41_button_map - provide initial input subsystem key mappings for F41.
+ *
+ * @post_suspend - this will be called after all suspend operations are
+ * completed.  This is the ONLY safe place to power off an RMI sensor
+ * during the suspend process.
+ * @pre_resume - this is called before any other resume operations.  If you
+ * powered off the RMI4 sensor in post_suspend(), then you MUST power it back
+ * here, and you MUST wait an appropriate time for the ASIC to come up
+ * (100ms to 200ms, depending on the sensor) before returning.
+ * @pm_data - this will be passed to the various (pre|post)_(suspend/resume)
+ * functions.
+ */
+struct rmi_device_platform_data {
+	char *driver_name;
+	char *sensor_name;	/* Used for diagnostics. */
+
+	int attn_gpio;
+	enum rmi_attn_polarity attn_polarity;
+	bool level_triggered;
+	void *gpio_data;
+	int (*gpio_config)(void *gpio_data, bool configure);
+
+	int reset_delay_ms;
+
+	struct rmi_device_platform_data_spi spi_data;
+
+	/* function handler pdata */
+	struct rmi_f11_sensor_data *f11_sensor_data;
+	u8 f11_sensor_count;
+	u16 f11_rezero_wait;
+	struct rmi_f01_power_management power_management;
+	struct rmi_button_map *f19_button_map;
+	struct rmi_button_map *f1a_button_map;
+	struct rmi_f30_gpioled_map *gpioled_map;
+	struct rmi_button_map *f41_button_map;
+
+#ifdef CONFIG_RMI4_FWLIB
+	char *firmware_name;
+#endif
+
+#ifdef	CONFIG_PM
+	void *pm_data;
+	int (*pre_suspend) (const void *pm_data);
+	int (*post_suspend) (const void *pm_data);
+	int (*pre_resume) (const void *pm_data);
+	int (*post_resume) (const void *pm_data);
+#endif
+};
+
+/**
+ * struct rmi_function_descriptor - RMI function base addresses
+ *
+ * @query_base_addr: The RMI Query base address
+ * @command_base_addr: The RMI Command base address
+ * @control_base_addr: The RMI Control base address
+ * @data_base_addr: The RMI Data base address
+ * @interrupt_source_count: The number of irqs this RMI function needs
+ * @function_number: The RMI function number
+ *
+ * This struct is used when iterating the Page Description Table. The addresses
+ * are 16-bit values to include the current page address.
+ *
+ */
+struct rmi_function_descriptor {
+	u16 query_base_addr;
+	u16 command_base_addr;
+	u16 control_base_addr;
+	u16 data_base_addr;
+	u8 interrupt_source_count;
+	u8 function_number;
+	u8 function_version;
+};
+
+struct rmi_function_container;
+struct rmi_device;
+
+/**
+ * struct rmi_function_handler - driver routines for a particular RMI function.
+ *
+ * This struct describes the interface of an RMI function. These are
+ * registered to the bus using the rmi_register_function_driver() call.
+ *
+ * @func: The RMI function number
+ * @reset: Called when a reset of the touch sensor is detected.  The routine
+ * should perform any out-of-the-ordinary reset handling that might be
+ * necessary.  Restoring of touch sensor configuration registers should be
+ * handled in the config() callback, below.
+ * @config: Called when the function container is first initialized, and
+ * after a reset is detected.  This routine should write any necessary
+ * configuration settings to the device.
+ * @attention: Called when the IRQ(s) for the function are set by the touch
+ * sensor.
+ * @suspend: Should perform any required operations to suspend the particular
+ * function.
+ * @resume: Should perform any required operations to resume the particular
+ * function.
+ *
+ * All callbacks are expected to return 0 on success, error code on failure.
+ */
+struct rmi_function_handler {
+	struct device_driver driver;
+
+	u8 func;
+	int (*config)(struct rmi_function_container *fc);
+	int (*reset)(struct rmi_function_container *fc);
+	int (*attention)(struct rmi_function_container *fc, u8 *irq_bits);
+#ifdef CONFIG_PM
+	int (*suspend)(struct rmi_function_container *fc);
+	int (*resume)(struct rmi_function_container *fc);
+#endif
+};
+
+#define to_rmi_function_handler(d) \
+		container_of(d, struct rmi_function_handler, driver);
+
+/**
+ * struct rmi_function_container - represents the implementation of an RMI4
+ * function for a particular device (basically, a driver for that RMI4 function)
+ *
+ * @fd: The function descriptor of the RMI function
+ * @rmi_dev: Pointer to the RMI device associated with this function container
+ * @dev: The device associated with this particular function.
+ *
+ * @num_of_irqs: The number of irqs needed by this function
+ * @irq_pos: The position in the irq bitfield this function holds
+ * @irq_mask: For convience, can be used to mask IRQ bits off during ATTN
+ * interrupt handling.
+ * @data: Private data pointer
+ *
+ * @list: Used to create a list of function containers.
+ * @debugfs_root: used during debugging
+ *
+ */
+struct rmi_function_container {
+
+	struct rmi_function_descriptor fd;
+	struct rmi_device *rmi_dev;
+	struct device dev;
+
+	int num_of_irqs;
+	int irq_pos;
+	u8 *irq_mask;
+
+	void *data;
+
+	struct list_head list;
+
+#ifdef CONFIG_RMI4_DEBUG
+	struct dentry *debugfs_root;
+#endif
+};
+
+#define to_rmi_function_container(d) \
+		container_of(d, struct rmi_function_container, dev);
+
+/**
+ * struct rmi_driver - driver for an RMI4 sensor on the RMI bus.
+ *
+ * @driver: Device driver model driver
+ * @irq_handler: Callback for handling irqs
+ * @reset_handler: Called when a reset is detected.
+ * @get_func_irq_mask: Callback for calculating interrupt mask
+ * @store_irq_mask: Callback for storing and replacing interrupt mask
+ * @restore_irq_mask: Callback for restoring previously stored interrupt mask
+ * @data: Private data pointer
+ *
+ */
+struct rmi_driver {
+	struct device_driver driver;
+
+	int (*irq_handler)(struct rmi_device *rmi_dev, int irq);
+	int (*reset_handler)(struct rmi_device *rmi_dev);
+	u8* (*get_func_irq_mask)(struct rmi_device *rmi_dev,
+			    struct rmi_function_container *fc);
+	int (*store_irq_mask)(struct rmi_device *rmi_dev, u8* new_interupts);
+	int (*restore_irq_mask)(struct rmi_device *rmi_dev);
+	void *data;
+};
+
+#define to_rmi_driver(d) \
+	container_of(d, struct rmi_driver, driver);
+
+/** struct rmi_phys_info - diagnostic information about the RMI physical
+ * device, used in the phys debugfs file.
+ *
+ * @proto String indicating the protocol being used.
+ * @tx_count Number of transmit operations.
+ * @tx_bytes Number of bytes transmitted.
+ * @tx_errs  Number of errors encountered during transmit operations.
+ * @rx_count Number of receive operations.
+ * @rx_bytes Number of bytes received.
+ * @rx_errs  Number of errors encountered during receive operations.
+ * @att_count Number of times ATTN assertions have been handled.
+ */
+struct rmi_phys_info {
+	char *proto;
+	long tx_count;
+	long tx_bytes;
+	long tx_errs;
+	long rx_count;
+	long rx_bytes;
+	long rx_errs;
+};
+
+/**
+ * struct rmi_phys_device - represent an RMI physical device
+ *
+ * @dev: Pointer to the communication device, e.g. i2c or spi
+ * @rmi_dev: Pointer to the RMI device
+ * @write_block: Writing a block of data to the specified address
+ * @read_block: Read a block of data from the specified address.
+ * @irq_thread: if not NULL, the sensor driver will use this instead of the
+ * default irq_thread implementation.
+ * @hard_irq: if not NULL, the sensor driver will use this for the hard IRQ
+ * handling
+ * @data: Private data pointer
+ *
+ * The RMI physical device implements the glue between different communication
+ * buses such as I2C and SPI.
+ *
+ */
+struct rmi_phys_device {
+	struct device *dev;
+	struct rmi_device *rmi_dev;
+
+	int (*write_block)(struct rmi_phys_device *phys, u16 addr, u8 *buf,
+			   int len);
+	int (*read_block)(struct rmi_phys_device *phys, u16 addr, u8 *buf,
+			  int len);
+
+	int (*enable_device) (struct rmi_phys_device *phys);
+	void (*disable_device) (struct rmi_phys_device *phys);
+
+	irqreturn_t (*irq_thread)(int irq, void *p);
+	irqreturn_t (*hard_irq)(int irq, void *p);
+
+
+	void *data;
+
+	struct rmi_phys_info info;
+};
+
+/**
+ * struct rmi_device - represents an RMI4 sensor device on the RMI bus.
+ *
+ * @dev: The device created for the RMI bus
+ * @number: Unique number for the device on the bus.
+ * @driver: Pointer to associated driver
+ * @phys: Pointer to the physical interface
+ * @debugfs_root: base for this particular sensor device.
+ *
+ */
+struct rmi_device {
+	struct device dev;
+	int number;
+
+	struct rmi_driver *driver;
+	struct rmi_phys_device *phys;
+
+#ifdef CONFIG_RMI4_DEBUG
+	struct dentry *debugfs_root;
+#endif
+};
+
+#define to_rmi_device(d) container_of(d, struct rmi_device, dev);
+#define to_rmi_platform_data(d) ((d)->phys->dev->platform_data);
+
+/**
+ * rmi_read - read a single byte
+ * @d: Pointer to an RMI device
+ * @addr: The address to read from
+ * @buf: The read buffer
+ *
+ * Reads a byte of data using the underlaying physical protocol in to buf. It
+ * returns zero or a negative error code.
+ */
+static inline int rmi_read(struct rmi_device *d, u16 addr, u8 *buf)
+{
+	return d->phys->read_block(d->phys, addr, buf, 1);
+}
+
+/**
+ * rmi_read_block - read a block of bytes
+ * @d: Pointer to an RMI device
+ * @addr: The start address to read from
+ * @buf: The read buffer
+ * @len: Length of the read buffer
+ *
+ * Reads a block of byte data using the underlaying physical protocol in to buf.
+ * It returns the amount of bytes read or a negative error code.
+ */
+static inline int rmi_read_block(struct rmi_device *d, u16 addr, u8 *buf,
+				 int len)
+{
+	return d->phys->read_block(d->phys, addr, buf, len);
+}
+
+/**
+ * rmi_write - write a single byte
+ * @d: Pointer to an RMI device
+ * @addr: The address to write to
+ * @data: The data to write
+ *
+ * Writes a byte from buf using the underlaying physical protocol. It
+ * returns zero or a negative error code.
+ */
+static inline int rmi_write(struct rmi_device *d, u16 addr, u8 data)
+{
+	return d->phys->write_block(d->phys, addr, &data, 1);
+}
+
+/**
+ * rmi_write_block - write a block of bytes
+ * @d: Pointer to an RMI device
+ * @addr: The start address to write to
+ * @buf: The write buffer
+ * @len: Length of the write buffer
+ *
+ * Writes a block of byte data from buf using the underlaying physical protocol.
+ * It returns the amount of bytes written or a negative error code.
+ */
+static inline int rmi_write_block(struct rmi_device *d, u16 addr, u8 *buf,
+				  int len)
+{
+	return d->phys->write_block(d->phys, addr, buf, len);
+}
+
+/**
+ * rmi_register_phys_device - register a physical device connection on the RMI
+ * bus.  Physical drivers provide communication from the devices on the bus to
+ * the RMI4 sensor on a bus such as SPI, I2C, and so on.
+ *
+ * @phys: the physical device to register
+ */
+int rmi_register_phys_device(struct rmi_phys_device *phys);
+
+/**
+ * rmi_unregister_phys_device - unregister a physical device connection
+ * @phys: the physical driver to unregister
+ *
+ */
+void rmi_unregister_phys_device(struct rmi_phys_device *phys);
+
+
+/**
+ * rmi_for_each_dev - provides a way for other parts of the system to enumerate
+ * the devices on the RMI bus.
+ *
+ * @data - will be passed into the callback function.
+ * @func - will be called for each device.
+ */
+int rmi_for_each_dev(void *data, int (*func)(struct device *dev, void *data));
+
+
+/**
+ * Helper fn to convert a byte array representing a 16 bit value in the RMI
+ * endian-ness to a 16-bit value in the native processor's specific endianness.
+ * We don't use ntohs/htons here because, well, we're not dealing with
+ * a pair of 16 bit values. Casting dest to u16* wouldn't work, because
+ * that would imply knowing the byte order of u16 in the first place.  The
+ * same applies for using shifts and masks.
+ */
+static inline u16 batohs(u8 *src)
+{
+	return src[1] * 0x100 + src[0];
+}
+
+/**
+ * Helper function to convert a 16 bit value (in host processor endianess) to
+ * a byte array in the RMI endianess for u16s.  See above comment for
+ * why we dont us htons or something like that.
+ */
+static inline void hstoba(u8 *dest, u16 src)
+{
+	dest[0] = src % 0x100;
+	dest[1] = src / 0x100;
+}
+
+#ifdef	CONFIG_RMI4_DEBUG
+/**
+ * Utility routine to handle writes to read-only attributes.  Hopefully
+ * this will never happen, but if the user does something stupid, we don't
+ * want to accept it quietly (which is what can happen if you just put NULL
+ * for the attribute's store function).
+ */
+static inline ssize_t rmi_store_error(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	dev_warn(dev,
+		 "WARNING: Attempt to write %d characters to read-only attribute %s.",
+		count, attr->attr.name);
+	return -EPERM;
+}
+
+/**
+ * Utility routine to handle reads of write-only attributes.  Hopefully
+ * this will never happen, but if the user does something stupid, we don't
+ * want to accept it quietly (which is what can happen if you just put NULL
+ * for the attribute's show function).
+ */
+static inline ssize_t rmi_show_error(struct device *dev,
+		       struct device_attribute *attr, char *buf)
+{
+	dev_warn(dev,
+		 "WARNING: Attempt to read from write-only attribute %s.",
+		 attr->attr.name);
+	return -EPERM;
+}
+#else
+#define rmi_store_error NULL
+#define rmi_show_error NULL
+#endif
+
+#endif
