Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225Ab2HQXWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 19:22:40 -0400
Received: from [12.239.217.82] ([12.239.217.82]:28612 "EHLO
	venom.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758921Ab2HQXVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 19:21:06 -0400
X-Greylist: delayed 3724 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Aug 2012 19:20:45 EDT
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [RFC PATCH 1/17] input: RMI4 public header file and documentation.
Date: Fri, 17 Aug 2012 15:17:41 -0700
Message-Id: <1345241877-16200-2-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

Acked-by: Jean Delvare <khali@linux-fr.org>

---

 Documentation/input/rmi4.txt     |   25 ++
 Documentation/input/rmidev.txt   |  144 +++++++++
 Documentation/input/rmisysfs.txt |  200 ++++++++++++
 include/linux/rmi.h              |  652 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 1021 insertions(+), 0 deletions(-)

diff --git a/Documentation/input/rmi4.txt b/Documentation/input/rmi4.txt
new file mode 100644
index 0000000..4e033ff
--- /dev/null
+++ b/Documentation/input/rmi4.txt
@@ -0,0 +1,25 @@
+RMI4 Touchscreen Driver
+=======================
+
+TBD
+
+Firmware Update Function
+========================
+
+The RMI4 driver uses the kernel's request_firmware() feature to obtain
+firmware for the touch sensor.  The firmware is expected to live in
+the file firmware/rmi4/<productid>.img, where <productid> is the Product ID
+found in the F01 query registers (F01_RMI_QUERY11 through F01_RMI_QUERY20).
+
+To prepare Synaptics provided .img file for reflashing, convert it to .ihex
+format using the following command:
+
+    objcopy -I binary -O ihex <productid>.img firmware/rmi4/<productid>.img.ihex
+
+Then make sure to add the image file name to the CONFIG_RMI4_FWLIB entry in
+firmware/Makefile.  If you don't do this, the image file won't be included, and
+the firmware loader class will delay for 60 seconds waiting for a non-existent
+userspace response to the firmware load request.
+
+Firmware updates for multichip solutions (aka LTS) are not supported.
+
diff --git a/Documentation/input/rmidev.txt b/Documentation/input/rmidev.txt
new file mode 100644
index 0000000..73473ee
--- /dev/null
+++ b/Documentation/input/rmidev.txt
@@ -0,0 +1,144 @@
+RMI4 devices are typically handled by kernel drivers attached to devices on
+/sys/bus/rmi.  However, user space programs can access the RMI4 devices
+through a /dev interface.
+
+Each registered RMI4 device is assigned a number, starting from 0.  The rmidev
+module (if present and loaded) creates a corresponding /dev/rmiX device.  This
+device is a flat binary character file that allows you to read, write, and seek
+within the register space of the corresponding RMI4 device.
+
+Opening the rmidev file is done just like opening any other file.  For example,
+in C you might do the following to open the device file for the first RMI4
+device:
+    int file;
+
+    file = open("/dev/rmi0", O_RDWR);
+    if (file < 0) {
+        /* ERROR HANDLING; you can check errno to see what went wrong */
+        exit(1);
+    }
+
+Once the file is open, you can use read() and write() to access registers in
+the RMI4 register map.  Use lseek() to specify the address at which the
+read() or write() operation will begin.
+
+
+NOTES ON ADDRESSING
+-------------------
+
+The RMI4 register space is 16 bits wide, supporting 65536 available 8-bit
+registers.  This means the range of valid positions within the file is 0
+through 65535 (0xFFFF).
+
+Attempting to lseek() to an address of 65536 or higher will return EINVAL.
+read() and write() operations that begin at 65536 or higher will return EINVAL.
+The result of read() and write() operations that begine at 65535 or below, and
+then extend beyond that boundary are undefined.
+
+Although the RMI4 register space supports 65536 registers, not all registers
+are defined or mapped on all products.  Undefined or unmapped registers will
+usually return zero, but you should not rely on this behavior.  The register
+map for a given device may contain 'holes' of unimplemented registers.
+
+If you're not sure what the register map for a given RMI4 device looks like,
+you can use the self describing features of RMI4 to determine the register
+map (this is what the RMI4 touchscreen driver does), or consult the product
+spec and documentation for your product.
+
+
+BUFFERED REGISTERS
+------------------
+
+The RMI4 specification also defines certain special registers, sometimes
+referred to as "buffered registers".  Buffered registers allow large amounts
+of data to be read or written at a single address in a single read or write
+operation.  Reads from (or writes to) buffered registers DO NOT increment the
+RMI4 device's internal register pointer.  When reading/writing a buffered
+register, you MUST follow these steps:
+    (1) lseek() to the buffered register's address
+    (2) read/write all data in a single read() or write() call
+    (3) lseek() to the address of the next register you wish to read/write
+
+The result of a read or write that extends across a buffered register is
+undefined.  It probably won't do what you expect.
+
+The result of trying to use multiple read() or write() calls to access the
+data in a buffered register is undefined.  It most certainly won't do what
+you expect.
+
+The result of failing to lseek() after reading or writing a buffered register
+is undefined.  It probably won't do what you expect.
+
+For more information on buffered registers, please refer to the RMI4
+specification.
+
+
+OPERATIONAL NOTE
+----------------
+
+It's important to remember that reading or writing the registers of an RMI4
+device using rmidev can change the state of the device.  For example, reading
+the F01 interrupt status register has the side effect of clearing the contents
+of that register.  If there was a pending interrupt (for example, a finger
+position report), information about that interrupt would be lost to the RMI4
+touchscreen driver.
+
+For this reason, it is required you disable the RMI4 device before accessing
+the sensor via rmidev.  To do this, write 0 to
+/sys/bus/rmi/devices/sensor00/enabled before you open the /dev/rmi0 file.
+After you close that file, you can write 1 to
+/sys/bus/rmi/devices/sensor00/enabled to return the RMI4 device to its enabled
+state.
+
+The results of using rmidev to access an RMI4 sensor via rmidev while the
+touchscreen driver is enabled are not defined, but it probably won't be pretty.
+
+
+HANDLING ATTENTION
+------------------
+
+RMI4 devices use the gpiolib framework to export their ATTN GPIO to userspace
+via sysfs (see Documentation/gpio.txt for more information about gpiolib).
+For a given RMI4 device, the gpiolib interfaces can be found in
+/sys/bus/rmi/devices/sensorNN/attn/ where NN is the number of the RMI4 sensor.
+
+Disabling the RMI4 device will also cause it to release the ATTN IRQ.  This
+will make it possible for a user space program to write to .../attn/edge file
+and then use poll() monitor the .../attn/value for changes in the state of
+the ATTN pin.
+
+Once you are done with ATTN, you MUST write 'none' to the .../attn/edge file
+in order to release the IRQ.  This MUST be done before you re-enable the RMI4
+device, otherwise the touchscreen driver will not be able to re-acquire the
+ATTN IRQ, and your device will be a brick.
+
+
+PUTTING IT ALL TOGETHER
+-----------------------
+
+Suppose you want to build a user space program to use rmidev to access an
+RMI4 device, and use changes in ATTN to determine when to read the F01
+interrupt status register.  Follow the steps below to disable the device
+and obtain access.
+
+    1) write 0 to /sys/bus/rmi/devices/sensor00/enabled
+    2) open /dev/rmi0
+    3) open /sys/bus/rmi/devices/sensor00/attn/value
+    4) write both to /sys/bus/rmi/devices/sensor00/attn/edge
+
+Then enter an operating mode like this.
+    1) poll() the /sys/bus/rmi/devices/sensor00/attn/value
+    2) lseek() to 0 and read() /sys/bus/rmi/devices/sensor00/attn/value
+       whenever gpiolib indicates there is a change in state
+    3) if ATTN is asserted (usually this will be value == 0) read the
+       interrupt status register(s)
+    4) perform appropriate actions
+    5) go back to (1)
+
+When you're all done, perform the following steps IN ORDER:
+
+    1) close /sys/bus/rmi/devices/sensor00/attn/value
+    2) close /dev/rmi0
+    3) write none to /sys/bus/rmi/devices/sensor00/attn/edge
+    4) write 1 to /sys/bus/rmi/devices/sensor00/enabled
+
diff --git a/Documentation/input/rmisysfs.txt b/Documentation/input/rmisysfs.txt
new file mode 100644
index 0000000..a40f417
--- /dev/null
+++ b/Documentation/input/rmisysfs.txt
@@ -0,0 +1,200 @@
+The RMI4 driver exposes an extensive set of informational and control
+parameters via sysfs.
+
+General parameters for a particular RMI4 device are found in
+/sys/bus/rmi/devices/sensorXX/, where XX is a the device's ID as a two digit
+number (padded with leading zeros).  Function specific parameters associated
+with a particular RMI sensor are found in /sys/bus/rmi/devices/sensorXX/fnYY/,
+where XX is a the device's ID as a two digit number (padded with leading zeros)
+and YY is the hexdecimal function number (for example, fn11 for RMI function
+F11).
+
+Although you could use this sysfs interface to configure an RMI4 device on
+system startup, that is not recommended.  Use the existing platform data and
+board file structures to specify the initial operating parameters, instead.
+
+
+General Parameters
+==================
+
+hasbsr (RO) - Reads back as 1 if the device supports the bus select register
+(see below), 0 otherwise.
+
+bsr (RW) - This contains the current value of the device's Bus Select Register
+(BSR), if it is present.  The Bus Select Register is of interest only when
+reflashing the device.  See the RMI4 Specification for details.
+
+enabled (RW) - Writing 1 to this enables the RMI4 driver, writing 0 to this
+disables it.  When disabled, the RMI4 driver completes any pending activities,
+suspends any current threads, stops polling (if applicable) and releases the
+ATTN IRQ (if applicable).  This can be useful when another driver, such as
+rmidev, wants to interact with the device.  The RMI4 driver is enabled by
+default at start up.
+
+phy (RO) - Presents information about the physical connection of this device.
+It has one line, with the format
+    prot tx_count tx_bytes tx_errors rx_count rx_bytes rx_errors attn
+Where
+    prot is one of i2c, spi1, or spi2
+    tx_count is the number of write operations
+    tx_bytes is the number of bytes written
+    tx_errors is the number of write operations that encountered errors
+    rx_count is the number of read operations
+    rx_bytes is the total number of bytes read
+    rx_errors is the number of read operations that encountered errors
+    attn is the number of times the ATTN line interrupt has been seen
+All counts are 64-bit unsigned values, and are set to zero when the physical
+layer driver is initialized.
+
+version(RO) - Displays RMI4 driver version info.
+
+
+
+F01 Device Control Parameters
+=============================
+
+chargerinput (RW) - User space programs can use this to tell the sensor that
+the system is plugged into an external power source (as opposed to running on
+batteries).  This allows the sensor firmware to make necessary adjustments
+for the current capacitence regime.  Write 1 to this when the system is using
+external power, write 0 to this when the system is running on batteries.
+
+configured (RO) - Shows the current state of the configured bit.  This will be
+1 most of the time (indicating the device has been appropriately configured),
+but will switch to 0 briefly if the sensor experiences a firmware or ASIC
+reset event.
+
+datecode (RO) - the date on which the module was manufactured.
+
+doze_holdoff (RW) - Controls how long the sensor will wait before entering the
+doze state when no fingers are present on the device. The time is in terms of
+10 milliseconds - a doze_holdoff value of 3 corresponds to a time period of 30
+milliseconds. 
+
+doze_interval (RW) - controls the time period that the device sleeps between
+finger-activity checks (F01_RMI_Ctrl3).  The time is in terms of 10 milli-
+seconds - a doze_interval value of 3 corresponds to a time period of 30
+milliseconds.  See also wakeup_threshold, below.
+
+flashprog (RO) - Defines the current device operating mode. The flashprog flag
+is set if the normal operation of the device is suspended because the device is
+in a flash programming enabled state.
+
+interruptEnable (RW) - This represents the current RMI4 interrupt mask
+(F01_RMI_Ctrl1 registers) as a space separated string of 0s and 1s.  Low order
+bits of the mask are presented first, highest order bits are at the end of
+the string.
+
+manufacturer (RO) - This is the identity of the manufacturer of the device,
+as obtained from F01_RMI_Query0.
+
+nosleep (RW) - Writing 1 to this parameter disables all normal firmware
+powersaving behaviors and forces the device to run at full power without
+sleeping.  The default state for this bit is 0.
+
+productinfo (RO) - the product info bytes, as determined from F01_RMI_Query2
+and F01_RMI_Query3 registers.
+
+productID (RO) - A string of up to 10 characters, identifying the product.
+
+reportrate (RW) - This is the current value of the RMI4 ReportRate bit
+(F01_RMI_Ctrl0, bit 6).  The meaning of this bit is very much device-dependent.
+Please see the RMI4 specification for details.
+
+reset (WO) - Writing a 1 to this write only register forces the device to reset.
+
+sleepmode (RW) - Controls power management on the device.  Writing 0 to this
+parameter puts the device into its normal operating mode.  Writing 1 to this
+parameter fully disables touch sensors and similar inputs - no touch data will
+be reported from the device in this mode.  Writing 2 or 3 to this device may
+or may not have an effect, depending on the particular device - see the product
+specification for your sensor for details.
+
+statuscode (RO) - Reports the most recent device status, such as invalid
+configuration, device reset, CRC failure, and so on.  Please se the RMI4
+specification for details.
+
+unconfigured (RO) - This is the opposite of the configured bit, described above.
+
+wakeup_threshold (RW) - This controls the change in capacitive signal needed
+to wake the device from the doze state.  Please see the RMI4 specification for
+the F01_RMI_Ctrl3 register for more details.
+
+
+F11 2D Sensing Parameters
+=========================
+
+swap (RW) - Writing 1 to this parameter swaps the X and Y axis as reported by
+the device, rotating the reported coordinates by 90 degrees.  This can be
+useful when installing a landscape sensor over a portrait display, for example.
+The default state for this parameter is 0.  If enabled, swap is applied before
+any other transformation.
+
+flip (RW) - This parameter is a pair of single binary digits (for example,
+"0 0" or "1 0"), corresponding to the X and Y axis.  Writing a 1 for a
+particular axis will invert the coordinates reported by the device along
+that axis.  For example writing "0 1" to this parameter will flip the Y axis
+top to bottom, but leave the X axis unchanged.  If enabled, flip is applied
+after swap and before offset.
+
+offset (RW) - This is a pair of values that will be SUBTRACTED from the X and
+Y coordinates, respectively.  If non-zero, offset will be applied after flip
+and before clip.  The default value for offset is 0 for both X and Y.
+
+clip (RW) - This is a set of four unsigned values in the range [0..65535],
+representing the lower bounds on X, the upper bounds on X, the lower bounds on
+Y, and the upper bounds on Y.  Coordinates will be clipped to these ranges.  If
+enabled, clip is the final transformation to be applied to the coordinates.
+The default upper and lower bounds for clip are 0 and 65535 respectively for
+both axes.
+
+maxPos (RW) - Contains two values specifying the the maximum reported
+coordinates for X and Y axes, respectively.
+
+relreport (RW) - Writing 1 to this parameter enables relative motion reporting.
+The default state for this parameter is 0.
+
+
+F19 Capacitive Button Parameters
+================================
+
+button_count (RO) - Tells you how many buttons this device supports.  Buttons
+are numbered from 0 through button_count-1.
+
+buttonMap (RW) - This consists of button_count entries, showing which keys each
+button is mapped to.  Writing to this parameter changes the button mappings.
+When writing, you must provide a mapping for each capacitive button.
+
+
+F34 Flash Memory Management Parameters
+======================================
+
+blocksize (RO) - The number of bytes in one data block. When programming the
+firmware, the data should be broken into blocks of this size and each block
+programmed individually.
+
+bootloaderid (RW) - Two ASCII characters identifying the particular bootloader
+version.
+
+cmd (RW) - Write to this parameter to send a flash control operation command.
+See rmi_f34.h for #defines of available commands, and the RMI4 specification
+for details on their meaning.
+
+configblockcount (RO) -  the number of blocks in a configuration image.
+blocksize * configblockcount == total number of bytes in a configuration image.
+
+data (RW) - Write blocks of image or configuration data to this during the
+reflash process.  You can also use this to read the configuration blocks.
+
+imageblockcount (RO) - The number of blocks in a firmware image. blocksize *
+imageblockcount == total number of bytes in a firmware image area.
+
+status (RO) - This parameter, at the completion of a flash operation, indicates
+the success or failure of the
+operation.
+
+
+F54 Diagnostic Reporting Parameters
+===================================
+
+TBD
diff --git a/include/linux/rmi.h b/include/linux/rmi.h
new file mode 100644
index 0000000..64054be
--- /dev/null
+++ b/include/linux/rmi.h
@@ -0,0 +1,652 @@
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
+#ifndef _RMI_H
+#define _RMI_H
+#include <linux/kernel.h>
+#include <linux/lockdep.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/cdev.h>
+#include <linux/mutex.h>
+#include <linux/stat.h>
+#include <linux/wait.h>
+#include <linux/list.h>
+#include <linux/interrupt.h>
+
+#ifdef CONFIG_RMI_DEBUG
+#include <linux/debugfs.h>
+#endif
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+#include <linux/earlysuspend.h>
+#endif
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
+
+#ifdef CONFIG_RMI4_DEBUG
+	struct dentry *debugfs_flip;
+	struct dentry *debugfs_clip;
+	struct dentry *debugfs_offset;
+	struct dentry *debugfs_swap;
+	u16 reg_debug_addr;
+	u8 reg_debug_size;
+#endif
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
+struct rmi_f01_power_management {
+	enum rmi_f01_nosleep nosleep;
+	u8 wakeup_threshold;
+	u8 doze_holdoff;
+	u8 doze_interval;
+};
+
+struct rmi_button_map {
+	u8 nbuttons;
+	unsigned char *map;
+};
+
+struct rmi_f30_gpioled_map {
+	unsigned char ngpioleds;
+	unsigned char *map;
+};
+
+struct virtualbutton_map {
+	u16 x;
+	u16 y;
+	u16 width;
+	u16 height;
+	u16 code;
+};
+
+struct rmi_f11_virtualbutton_map {
+	u8 buttons;
+	struct virtualbutton_map *map;
+};
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
+ * @firmware_name - if specified will override default firmware name,
+ * for reflashing.
+ *
+ * @f11_type_b - Force F11 to treat the sensor as a multitouch Type B sensor.
+ * This is useful for older Type B RMI4 sensors that can't be queried for this
+ * information, but will cause problems if you force a Type A sensor to be
+ * treated as type_b.
+ *
+ * @pre_suspend - this will be called before any other suspend operations are
+ * done.
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
+	struct rmi_f01_power_management power_management;
+	struct rmi_f11_2d_axis_alignment axis_align;
+	struct rmi_button_map *f19_button_map;
+	struct rmi_button_map *f1a_button_map;
+	struct rmi_f30_gpioled_map *gpioled_map;
+	struct rmi_f11_virtualbutton_map *f11_button_map;
+	struct rmi_button_map *f41_button_map;
+
+#ifdef CONFIG_RMI4_FWLIB
+	char *firmware_name;
+#endif
+#ifdef CONFIG_RMI4_F11_TYPEB
+	bool f11_type_b;
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
+ * struct rmi_function_handler - an RMI function handler
+ * @func: The RMI function number
+ * @init: Callback for RMI function init
+ * @attention: Callback for RMI function attention
+ * @suspend: Callback for function suspend, returns 0 for success.
+ * @resume: Callback for RMI function resume, returns 0 for success.
+ * @remove: Callback for RMI function removal
+ *
+ * This struct describes the interface of an RMI function. These are
+ * registered to the bus using the rmi_register_function_driver() call.
+ *
+ */
+struct rmi_function_handler {
+	int func;
+	int (*init)(struct rmi_function_container *fc);
+	int (*config)(struct rmi_function_container *fc);
+	int (*reset)(struct rmi_function_container *fc);
+	int (*attention)(struct rmi_function_container *fc, u8 *irq_bits);
+#ifdef CONFIG_PM
+	int (*suspend)(struct rmi_function_container *fc);
+	int (*resume)(struct rmi_function_container *fc);
+#if defined(CONFIG_HAS_EARLYSUSPEND) && \
+		!defined(CONFIG_RMI4_SPECIAL_EARLYSUSPEND)
+	int (*early_suspend)(struct rmi_function_container *fc);
+	int (*late_resume)(struct rmi_function_container *fc);
+#endif
+#endif
+	void (*remove)(struct rmi_function_container *fc);
+};
+
+/**
+ * struct rmi_function_container - an element in a function handler list
+ * @list: The list
+ * @fd: The function descriptor of the RMI function
+ * @rmi_dev: Pointer to the RMI device associated with this function container
+ * @fh: The callbacks connected to this function
+ * @num_of_irqs: The number of irqs needed by this function
+ * @irq_pos: The position in the irq bitfield this function holds
+ * @data: Private data pointer
+ *
+ */
+struct rmi_function_container {
+	struct list_head list;
+
+	struct rmi_function_descriptor fd;
+	struct rmi_device *rmi_dev;
+	struct rmi_function_handler *fh;
+	struct device dev;
+
+#ifdef CONFIG_RMI4_DEBUG
+	struct dentry *debugfs_root;
+#endif
+
+	int num_of_irqs;
+	int irq_pos;
+	u8 *irq_mask;
+
+	void *data;
+};
+#define to_rmi_function_container(d) \
+		container_of(d, struct rmi_function_container, dev);
+
+
+/**
+ * struct rmi_driver - represents an RMI driver
+ * @driver: Device driver model driver
+ * @probe: Callback for device probe
+ * @remove: Callback for device removal
+ * @shutdown: Callback for device shutdown
+ * @irq_handler: Callback for handling irqs
+ * @fh_add: Callback for function handler add
+ * @fh_remove: Callback for function handler remove
+ * @get_func_irq_mask: Callback for calculating interrupt mask
+ * @store_irq_mask: Callback for storing and replacing interrupt mask
+ * @restore_irq_mask: Callback for restoring previously stored interrupt mask
+ * @data: Private data pointer
+ *
+ * The RMI driver implements a driver on the RMI bus.
+ *
+ */
+struct rmi_driver {
+	struct device_driver driver;
+
+	int (*probe)(struct rmi_device *rmi_dev);
+	int (*remove)(struct rmi_device *rmi_dev);
+	void (*shutdown)(struct rmi_device *rmi_dev);
+	int (*irq_handler)(struct rmi_device *rmi_dev, int irq);
+	int (*reset_handler)(struct rmi_device *rmi_dev);
+	void (*fh_add)(struct rmi_device *rmi_dev,
+		       struct rmi_function_handler *fh);
+	void (*fh_remove)(struct rmi_device *rmi_dev,
+			  struct rmi_function_handler *fh);
+	u8* (*get_func_irq_mask)(struct rmi_device *rmi_dev,
+			    struct rmi_function_container *fc);
+	int (*store_irq_mask)(struct rmi_device *rmi_dev, u8* new_interupts);
+	int (*restore_irq_mask)(struct rmi_device *rmi_dev);
+	void *data;
+};
+#define to_rmi_driver(d) \
+	container_of(d, struct rmi_driver, driver);
+
+/** struct rmi_phys_info - diagnostic information about the RMI physical
+ * device, used in the phys sysfs file.
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
+	long attn_count;
+};
+
+/**
+ * struct rmi_phys_device - represent an RMI physical device
+ * @dev: Pointer to the communication device, e.g. i2c or spi
+ * @rmi_dev: Pointer to the RMI device
+ * @write: Callback for write
+ * @write_block: Callback for writing a block of data
+ * @read: Callback for read
+ * @read_block: Callback for reading a block of data
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
+	int (*write)(struct rmi_phys_device *phys, u16 addr, u8 data);
+	int (*write_block)(struct rmi_phys_device *phys, u16 addr, u8 *buf,
+			   int len);
+	int (*read)(struct rmi_phys_device *phys, u16 addr, u8 *buf);
+	int (*read_block)(struct rmi_phys_device *phys, u16 addr, u8 *buf,
+			  int len);
+
+	int (*enable_device) (struct rmi_phys_device *phys);
+	void (*disable_device) (struct rmi_phys_device *phys);
+
+	void *data;
+
+	struct rmi_phys_info info;
+};
+
+/**
+ * struct rmi_device - represents an RMI device
+ * @dev: The device created for the RMI bus
+ * @number: Unique number for the device on the bus.
+ * @driver: Pointer to associated driver
+ * @phys: Pointer to the physical interface
+ * @early_suspend_handler: Pointers to early_suspend and late_resume, if
+ * configured.
+ *
+ * This structs represent an RMI device.
+ *
+ */
+struct rmi_device {
+	struct device dev;
+	int number;
+
+	struct rmi_driver *driver;
+	struct rmi_phys_device *phys;
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+	struct early_suspend early_suspend_handler;
+#endif
+#ifdef CONFIG_RMI4_DEBUG
+	struct dentry *debugfs_root;
+#endif
+};
+#define to_rmi_device(d) container_of(d, struct rmi_device, dev);
+#define to_rmi_platform_data(d) ((d)->phys->dev->platform_data);
+
+static inline void rmi_set_driverdata(struct rmi_device *d, void *data)
+{
+	dev_set_drvdata(&d->dev, data);
+}
+
+static inline void *rmi_get_driverdata(struct rmi_device *d)
+{
+	return dev_get_drvdata(&d->dev);
+}
+
+/**
+ * rmi_read - RMI read byte
+ * @d: Pointer to an RMI device
+ * @addr: The address to read from
+ * @buf: The read buffer
+ *
+ * Reads a byte of data using the underlaying physical protocol in to buf. It
+ * returns zero or a negative error code.
+ */
+static inline int rmi_read(struct rmi_device *d, u16 addr, u8 *buf)
+{
+	return d->phys->read(d->phys, addr, buf);
+}
+
+/**
+ * rmi_read_block - RMI read block
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
+ * rmi_write - RMI write byte
+ * @d: Pointer to an RMI device
+ * @addr: The address to write to
+ * @data: The data to write
+ *
+ * Writes a byte from buf using the underlaying physical protocol. It
+ * returns zero or a negative error code.
+ */
+static inline int rmi_write(struct rmi_device *d, u16 addr, u8 data)
+{
+	return d->phys->write(d->phys, addr, data);
+}
+
+/**
+ * rmi_write_block - RMI write block
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
+ * rmi_register_driver - register rmi driver
+ * @driver: the driver to register
+ *
+ * This function registers an RMI driver to the RMI bus.
+ */
+int rmi_register_driver(struct rmi_driver *driver);
+
+/**
+ * rmi_unregister_driver - unregister rmi driver
+ * @driver: the driver to unregister
+ *
+ * This function unregisters an RMI driver to the RMI bus.
+ */
+void rmi_unregister_driver(struct rmi_driver *driver);
+
+/**
+ * rmi_register_phys_device - register a physical device connection
+ * @phys: the physical driver to register
+ *
+ * This function registers a physical driver to the RMI bus. These drivers
+ * provide a communication layer for the drivers connected to the bus, e.g.
+ * I2C, SPI and so on.
+ */
+int rmi_register_phys_device(struct rmi_phys_device *phys);
+
+/**
+ * rmi_unregister_phys_device - unregister a physical device connection
+ * @phys: the physical driver to unregister
+ *
+ * This function unregisters a physical driver from the RMI bus.
+ */
+void rmi_unregister_phys_device(struct rmi_phys_device *phys);
+
+/**
+ * rmi_register_function_driver - register an RMI function driver
+ * @fh: the function handler to register
+ *
+ * This function registers support for a new RMI function to the bus. All
+ * drivers on the bus will be notified of the presence of the new function
+ * driver.
+ */
+int rmi_register_function_driver(struct rmi_function_handler *fh);
+
+/**
+ * rmi_unregister_function_driver - unregister an RMI function driver
+ * @fh: the function handler to unregister
+ *
+ * This function unregisters a RMI function from the RMI bus. All drivers on
+ * the bus will be notified of the removal of a function driver.
+ */
+void rmi_unregister_function_driver(struct rmi_function_handler *fh);
+
+/**
+ * rmi_get_function_handler - get a pointer to specified RMI function
+ * @id: the RMI function id
+ *
+ * This function gets the specified RMI function handler from the list of
+ * supported functions.
+ */
+struct rmi_function_handler *rmi_get_function_handler(int id);
+
+
+struct rmi_char_device;
+
+/**
+ * rmi_char_driver - a general driver that doesn't handle specific functions,
+ * operating outside the bus::sensor::functions
+ * @match: returns 1 if the driver wants to talk to the specified rmi_dev.
+ *
+ * All of the above are optional except driver and init which are required.
+ *
+ */
+struct rmi_char_driver {
+	struct device_driver driver;
+
+	int (*match)(struct rmi_device *rmi_dev);
+	int (*init)(struct rmi_char_device *cd);
+	int (*attention)(struct rmi_char_device *cd, u8 *irq_bits);
+#ifdef CONFIG_PM
+	int (*suspend)(struct rmi_char_device *cd);
+	int (*resume)(struct rmi_char_device *cd);
+#if defined(CONFIG_HAS_EARLYSUSPEND) && \
+			!defined(CONFIG_RMI4_SPECIAL_EARLYSUSPEND)
+	int (*early_suspend)(struct rmi_char_device *cd);
+	int (*late_resume)(struct rmi_char_device *cd);
+#endif
+#endif
+	void (*remove)(struct rmi_char_device *cd);
+
+	struct list_head devices;
+};
+
+struct rmi_char_device {
+	struct list_head list;
+
+	struct rmi_device *rmi_dev;
+	struct rmi_char_driver *driver;
+	struct device dev;
+
+#ifdef CONFIG_RMI4_DEBUG
+	struct dentry *debugfs_root;
+#endif
+
+	void *data;
+};
+#define to_rmi_char_device(d) \
+		container_of(d, struct rmi_char_device, dev)
+
+int rmi_register_character_driver(struct rmi_char_driver *char_driver);
+int rmi_unregister_character_driver(struct rmi_char_driver *char_driver);
+
+
+/* Helper fn to convert a byte array representing a short in the RMI
+ * endian-ness to a short in the native processor's specific endianness.
+ * We don't use ntohs/htons here because, well, we're not dealing with
+ * a pair of shorts. And casting dest to short* wouldn't work, because
+ * that would imply knowing the byte order of short in the first place.
+ */
+static inline void batohs(unsigned short *dest, unsigned char *src)
+{
+	*dest = src[1] * 0x100 + src[0];
+}
+
+/* Helper function to convert a short (in host processor endianess) to
+ * a byte array in the RMI endianess for shorts.  See above comment for
+ * why we dont us htons or something like that.
+ */
+static inline void hstoba(unsigned char *dest, unsigned short src)
+{
+	dest[0] = src % 0x100;
+	dest[1] = src / 0x100;
+}
+
+/* Utility routine to handle writes to read-only attributes.  Hopefully
+ * this will never happen, but if the user does something stupid, we don't
+ * want to accept it quietly (which is what can happen if you just put NULL
+ * for the attribute's store function).
+ */
+static inline ssize_t rmi_store_error(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	dev_warn(dev,
+		 "RMI4 WARNING: Attempt to write %d characters to read-only "
+		 "attribute %s.", count, attr->attr.name);
+	return -EPERM;
+}
+
+/* Utility routine to handle reads of write-only attributes.  Hopefully
+ * this will never happen, but if the user does something stupid, we don't
+ * want to accept it quietly (which is what can happen if you just put NULL
+ * for the attribute's show function).
+ */
+static inline ssize_t rmi_show_error(struct device *dev,
+		       struct device_attribute *attr,
+		       char *buf)
+{
+	dev_warn(dev,
+		 "RMI4 WARNING: Attempt to read from write-only attribute %s.",
+		 attr->attr.name);
+	return -EPERM;
+}
+
+/* utility function for bit access of u8*'s */
+void u8_set_bit(u8 *target, int pos);
+void u8_clear_bit(u8 *target, int pos);
+bool u8_is_set(u8 *target, int pos);
+bool u8_is_any_set(u8 *target, int size);
+void u8_or(u8 *dest, u8* target1, u8* target2, int size);
+void u8_and(u8 *dest, u8* target1, u8* target2, int size);
+#endif
