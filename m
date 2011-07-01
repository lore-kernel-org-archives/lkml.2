Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab1GACTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 22:19:21 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:52535 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754458Ab1GACTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 22:19:13 -0400
From: Nathan Royer <nroyer@invensense.com>
To: Nathan Royer <nroyer@invensense.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Alan Cox <alan@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 01/11] misc: inv_mpu primary header file and README file.
Date: Thu, 30 Jun 2011 19:18:17 -0700
Message-Id: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This files defines the userspace interface and how to integrate it into a
platform.

Signed-off-by: Nathan Royer <nroyer@invensense.com>
---

This is the first of many patch files for the inv_mpu driver in its current
state.  This is our first time submitting this driver, so I expect there to be
a lot wrong with it, and expect to need to fix many things.

The inv_mpu driver attepts to implement a Motion Processing Unit interface.  As
a unit, an accelerometer, magnetometer, gyroscope, and/or altimiter data is
fused together to produce calibrated data and a quaternion.

The inv_mpu driver interface is currently implemented as a misc device, but may
need to change to include both sysfs attributes and input devices.  I think
that we will continue to need the ioctl interface, but many of the ioctls can
be replace by attributes and/or input devices.

The mpu3050 has an i2c master interface designed to control an accelerometer
and a Digital Motion Processor (DMP) used to perform sensor fusion on the
gyroscope and accelerometer.  This data is then read out of the mpu3050 fifo
and sent to userspace for distribution and optional propritary processing, such
as fusion with a compass to produce a 9 axis quaternion.

Some question I have at the start are:
1) Is there a master design or standard interface for Motion Processing
devices, specifically ones that do calibration, sensor fusion, and or have a
micro-controller to do some of this work.
2) Is there a standard way to integrate user space components with kernel side
components.
3) Should data be pushed back to the driver from userspace, and made available
as an input device or should it remain as a character device.
4) Can a 4 element quaternion be added to input.h:
ABS_QUATERNION_1 ABS_QUATERNION_I ABS_QUATERNION_J ABS_QUATERNION_K
for <1, i, j, k>
5) Should we instead use a rotation vector as defined in the Android sensor:
http://developer.android.com/reference/android/hardware/SensorEvent.html
6) Are there any other major design concerns?
7) Can an input device also have a character device interface for proprietary
customization.

 drivers/misc/inv_mpu/README |  104 ++++++++++++
 include/linux/mpu.h         |  365 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 469 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/inv_mpu/README
 create mode 100644 include/linux/mpu.h

diff --git a/drivers/misc/inv_mpu/README b/drivers/misc/inv_mpu/README
new file mode 100644
index 0000000..ce592c8
--- /dev/null
+++ b/drivers/misc/inv_mpu/README
@@ -0,0 +1,104 @@
+Kernel driver mpu
+=====================
+
+Supported chips:
+  * InvenSense IMU3050
+    Prefix: 'mpu3050'
+    Datasheet:
+        PS-MPU-3000A-00.2.4b.pdf
+
+Author: InvenSense <http://invensense.com>
+
+Description
+-----------
+The mpu is a motion processor unit that controls the mpu3050 gyroscope, a slave
+accelerometer, a compass and a pressure sensor.  This document describes how to
+install the driver into a Linux kernel.
+
+Sysfs entries
+-------------
+/dev/mpu
+/dev/mpuirq
+/dev/accelirq
+/dev/compassirq
+/dev/pressureirq
+
+General Remarks MPU3050
+-----------------------
+* Valid addresses for the MPU3050 is 0x68.
+* Accelerometer must be on the secondary I2C bus for MPU3050, the
+  magnetometer must be on the primary bus and pressure sensor must
+  be on the primary bus.
+
+Programming the chip using /dev/mpu
+----------------------------------
+Programming of MPU3050 is done by first opening the /dev/mpu file and
+then performing a series of IOCTLS on the handle returned.  The IOCTL codes can
+be found in mpu.h.  Typically this is done by the mllite library in user
+space.
+
+Board and Platform Data
+-----------------------
+
+In order for the driver to work, board and platform data specific to the device
+needs to be added to the board file.  A mpu_platform_data structure must
+be created and populated and set in the i2c_board_info_structure.  For details
+of each structure member see mpu.h.  All values below are simply an example and
+should be modified for your platform.
+
+#include <linux/mpu.h>
+
+static struct mpu_platform_data mpu3050_data = {
+	.int_config  = 0x10,
+	.orientation = {  -1,  0,  0,
+			   0,  1,  0,
+			   0,  0, -1 },
+};
+
+/* accel */
+static struct ext_slave_platform_data inv_mpu_kxtf9_data = {
+	.bus         = EXT_SLAVE_BUS_SECONDARY,
+	.orientation = {  -1,  0,  0,
+			  0,  1,  0,
+			  0,  0, -1 },
+};
+/* compass */
+static struct ext_slave_platform_data inv_mpu_ak8975_data = {
+	.bus         = EXT_SLAVE_BUS_PRIMARY,
+	.orientation = { 1, 0, 0,
+			 0, 1, 0,
+			 0, 0, 1 },
+};
+
+static struct i2c_board_info __initdata panda_inv_mpu_i2c4_boardinfo[] = {
+	{
+		I2C_BOARD_INFO("mpu3050", 0x68),
+		.irq = (IH_GPIO_BASE + MPUIRQ_GPIO),
+		.platform_data = &mpu3050_data,
+	},
+	{
+		I2C_BOARD_INFO("kxtf9", 0x0F),
+		.irq = (IH_GPIO_BASE + ACCEL_IRQ_GPIO),
+		.platform_data = &inv_mpu_kxtf9_data
+	},
+	{
+		I2C_BOARD_INFO("ak8975", 0x0E),
+		.irq = (IH_GPIO_BASE + COMPASS_IRQ_GPIO),
+		.platform_data = &inv_mpu_ak8975_data,
+	},
+};
+
+Typically the IRQ is a GPIO input pin and needs to be configured properly.  If
+in the above example GPIO 168 corresponds to IRQ 299, the following should be
+done as well:
+
+#define MPU_GPIO_IRQ 168
+
+    gpio_request(MPU_GPIO_IRQ,"MPUIRQ");
+    gpio_direction_input(MPU_GPIO_IRQ)
+
+Dynamic Debug
+=============
+
+The mpu3050 makes use of dynamic debug.  For details on how to use this
+refer to Documentation/dynamic-debug-howto.txt
diff --git a/include/linux/mpu.h b/include/linux/mpu.h
new file mode 100644
index 0000000..18d2da0
--- /dev/null
+++ b/include/linux/mpu.h
@@ -0,0 +1,365 @@
+/*
+	$License:
+	Copyright (C) 2011 InvenSense Corporation, All Rights Reserved.
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program.  If not, see <http://www.gnu.org/licenses/>.
+	$
+ */
+
+#ifndef __MPU_H_
+#define __MPU_H_
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+/* Number of axes on each sensor */
+#define GYRO_NUM_AXES               (3)
+#define ACCEL_NUM_AXES              (3)
+#define COMPASS_NUM_AXES            (3)
+
+struct mpu_read_write {
+	/* Memory address or register address depending on ioctl */
+	__u16 address;
+	__u16 length;
+	__u8 *data;
+};
+
+enum mpuirq_data_type {
+	MPUIRQ_DATA_TYPE_MPU_IRQ,
+	MPUIRQ_DATA_TYPE_SLAVE_IRQ,
+	MPUIRQ_DATA_TYPE_PM_EVENT,
+	MPUIRQ_DATA_TYPE_NUM_TYPES,
+};
+
+/* User space PM event notification */
+#define MPU_PM_EVENT_SUSPEND_PREPARE (3)
+#define MPU_PM_EVENT_POST_SUSPEND    (4)
+
+struct mpuirq_data {
+	__u32 interruptcount;
+	__u64 irqtime;
+	__u32 data_type;
+	__s32 data;
+};
+
+enum ext_slave_config_key {
+	MPU_SLAVE_CONFIG_ODR_SUSPEND,
+	MPU_SLAVE_CONFIG_ODR_RESUME,
+	MPU_SLAVE_CONFIG_FSR_SUSPEND,
+	MPU_SLAVE_CONFIG_FSR_RESUME,
+	MPU_SLAVE_CONFIG_MOT_THS,
+	MPU_SLAVE_CONFIG_NMOT_THS,
+	MPU_SLAVE_CONFIG_MOT_DUR,
+	MPU_SLAVE_CONFIG_NMOT_DUR,
+	MPU_SLAVE_CONFIG_IRQ_SUSPEND,
+	MPU_SLAVE_CONFIG_IRQ_RESUME,
+	MPU_SLAVE_WRITE_REGISTERS,
+	MPU_SLAVE_READ_REGISTERS,
+	MPU_SLAVE_CONFIG_INTERNAL_REFERENCE,
+	/* AMI 306 specific config keys */
+	MPU_SLAVE_PARAM,
+	MPU_SLAVE_WINDOW,
+	MPU_SLAVE_READWINPARAMS,
+	MPU_SLAVE_SEARCHOFFSET,
+	/* AKM specific config keys */
+	MPU_SLAVE_READ_SCALE,
+	/* MPU3050 and MPU6050 Keys */
+	MPU_SLAVE_INT_CONFIG,
+	MPU_SLAVE_EXT_SYNC,
+	MPU_SLAVE_FULL_SCALE,
+	MPU_SLAVE_LPF,
+	MPU_SLAVE_CLK_SRC,
+	MPU_SLAVE_DIVIDER,
+	MPU_SLAVE_DMP_ENABLE,
+	MPU_SLAVE_FIFO_ENABLE,
+	MPU_SLAVE_DMP_CFG1,
+	MPU_SLAVE_DMP_CFG2,
+	MPU_SLAVE_TC,
+	MPU_SLAVE_GYRO,
+	MPU_SLAVE_ADDR,
+	MPU_SLAVE_PRODUCT_REVISION,
+	MPU_SLAVE_SILICON_REVISION,
+	MPU_SLAVE_PRODUCT_ID,
+	MPU_SLAVE_GYRO_SENS_TRIM,
+	MPU_SLAVE_ACCEL_SENS_TRIM,
+	MPU_SLAVE_RAM,
+	/* -------------------------- */
+	MPU_SLAVE_CONFIG_NUM_CONFIG_KEYS
+};
+
+/* For the MPU_SLAVE_CONFIG_IRQ_SUSPEND and MPU_SLAVE_CONFIG_IRQ_RESUME */
+enum ext_slave_config_irq_type {
+	MPU_SLAVE_IRQ_TYPE_NONE,
+	MPU_SLAVE_IRQ_TYPE_MOTION,
+	MPU_SLAVE_IRQ_TYPE_DATA_READY,
+};
+
+/* Structure for the following IOCTS's
+ * MPU_CONFIG_GYRO
+ * MPU_CONFIG_ACCEL
+ * MPU_CONFIG_COMPASS
+ * MPU_CONFIG_PRESSURE
+ * MPU_GET_CONFIG_GYRO
+ * MPU_GET_CONFIG_ACCEL
+ * MPU_GET_CONFIG_COMPASS
+ * MPU_GET_CONFIG_PRESSURE
+ *
+ * @key one of enum ext_slave_config_key
+ * @len length of data pointed to by data
+ * @apply zero if communication with the chip is not necessary, false otherwise
+ *        This flag can be used to select cached data or to refresh cashed data
+ *        cache data to be pushed later or push immediately.  If true and the
+ *        slave is on the secondary bus the MPU will first enger bypass mode
+ *        before calling the slaves .config or .get_config funcion
+ * @data pointer to the data to confgure or get
+ */
+struct ext_slave_config {
+	__u8 key;
+	__u16 len;
+	__u8 apply;
+	void *data;
+};
+
+enum ext_slave_type {
+	EXT_SLAVE_TYPE_GYROSCOPE,
+	EXT_SLAVE_TYPE_ACCEL,
+	EXT_SLAVE_TYPE_COMPASS,
+	EXT_SLAVE_TYPE_PRESSURE,
+	/*EXT_SLAVE_TYPE_TEMPERATURE */
+
+	EXT_SLAVE_NUM_TYPES
+};
+
+enum ext_slave_id {
+	ID_INVALID = 0,
+
+	ACCEL_ID_LIS331,
+	ACCEL_ID_LSM303A,
+	ACCEL_ID_LIS3DH,
+	ACCEL_ID_KXSD9,
+	ACCEL_ID_KXTF9,
+	ACCEL_ID_BMA150,
+	ACCEL_ID_BMA222,
+	ACCEL_ID_BMA250,
+	ACCEL_ID_ADXL34X,
+	ACCEL_ID_MMA8450,
+	ACCEL_ID_MMA845X,
+	ACCEL_ID_MPU6050,
+
+	COMPASS_ID_AK8975,
+	COMPASS_ID_AK8972,
+	COMPASS_ID_AMI30X,
+	COMPASS_ID_AMI306,
+	COMPASS_ID_YAS529,
+	COMPASS_ID_YAS530,
+	COMPASS_ID_HMC5883,
+	COMPASS_ID_LSM303M,
+	COMPASS_ID_MMC314X,
+	COMPASS_ID_HSCDTD002B,
+	COMPASS_ID_HSCDTD004A,
+
+	PRESSURE_ID_BMA085,
+};
+
+enum ext_slave_endian {
+	EXT_SLAVE_BIG_ENDIAN,
+	EXT_SLAVE_LITTLE_ENDIAN,
+	EXT_SLAVE_FS8_BIG_ENDIAN,
+	EXT_SLAVE_FS16_BIG_ENDIAN,
+};
+
+enum ext_slave_bus {
+	EXT_SLAVE_BUS_INVALID = -1,
+	EXT_SLAVE_BUS_PRIMARY = 0,
+	EXT_SLAVE_BUS_SECONDARY = 1
+};
+
+
+/**
+ *  struct ext_slave_platform_data - Platform data for mpu3050 and mpu6050
+ *  slave devices
+ *
+ *  @get_slave_descr: Function pointer to retrieve the struct ext_slave_descr
+ *                    for this slave
+ *  @irq: the irq number attached to the slave if any.
+ *  @adapt_num: the I2C adapter number.
+ *  @bus: the bus the slave is attached to: enum ext_slave_bus
+ *  @address: the I2C slave address of the slave device.
+ *  @orientation: the mounting matrix of the device relative to MPU.
+ *  @irq_data: private data for the slave irq handler
+ *  @private_data: additional data, user customizable.  Not touched by the MPU
+ *                 driver.
+ *
+ * The orientation matricies are 3x3 rotation matricies
+ * that are applied to the data to rotate from the mounting orientation to the
+ * platform orientation.  The values must be one of 0, 1, or -1 and each row and
+ * column should have exactly 1 non-zero value.
+ */
+struct ext_slave_platform_data {
+	__u8 type;
+	__u32 irq;
+	__u32 adapt_num;
+	__u32 bus;
+	__u8 address;
+	__s8 orientation[9];
+	void *irq_data;
+	void *private_data;
+};
+
+struct fix_pnt_range {
+	__s32 mantissa;
+	__s32 fraction;
+};
+
+static inline long range_fixedpoint_to_long_mg(struct fix_pnt_range rng)
+{
+	return (long)(rng.mantissa * 1000 + rng.fraction / 10);
+}
+
+struct ext_slave_read_trigger {
+	__u8 reg;
+	__u8 value;
+};
+
+/**
+ *  struct ext_slave_descr - Description of the slave device for programming.
+ *
+ *  @suspend:	function pointer to put the device in suspended state
+ *  @resume:	function pointer to put the device in running state
+ *  @read:	function that reads the device data
+ *  @init:	function used to preallocate memory used by the driver
+ *  @exit:	function used to free memory allocated for the driver
+ *  @config:	function used to configure the device
+ *  @get_config:function used to get the device's configuration
+ *
+ *  @name:	text name of the device
+ *  @type:	device type. enum ext_slave_type
+ *  @id:	enum ext_slave_id
+ *  @read_reg:	starting register address to retrieve data.
+ *  @read_len:	length in bytes of the sensor data.  Typically  6.
+ *  @endian:	byte order of the data. enum ext_slave_endian
+ *  @range:	full scale range of the slave ouput: struct fix_pnt_range
+ *  @trigger:	If reading data first requires writing a register this is the
+ *		data to write.
+ *
+ *  Defines the functions and information about the slave the mpu3050 and
+ *  mpu6050 needs to use the slave device.
+ */
+struct ext_slave_descr {
+	int (*init) (void *mlsl_handle,
+		     struct ext_slave_descr *slave,
+		     struct ext_slave_platform_data *pdata);
+	int (*exit) (void *mlsl_handle,
+		     struct ext_slave_descr *slave,
+		     struct ext_slave_platform_data *pdata);
+	int (*suspend) (void *mlsl_handle,
+			struct ext_slave_descr *slave,
+			struct ext_slave_platform_data *pdata);
+	int (*resume) (void *mlsl_handle,
+		       struct ext_slave_descr *slave,
+		       struct ext_slave_platform_data *pdata);
+	int (*read) (void *mlsl_handle,
+		     struct ext_slave_descr *slave,
+		     struct ext_slave_platform_data *pdata,
+		     __u8 *data);
+	int (*config) (void *mlsl_handle,
+		       struct ext_slave_descr *slave,
+		       struct ext_slave_platform_data *pdata,
+		       struct ext_slave_config *config);
+	int (*get_config) (void *mlsl_handle,
+			   struct ext_slave_descr *slave,
+			   struct ext_slave_platform_data *pdata,
+			   struct ext_slave_config *config);
+
+	char *name;
+	__u8 type;
+	__u8 id;
+	__u8 read_reg;
+	__u8 read_len;
+	__u8 endian;
+	struct fix_pnt_range range;
+	struct ext_slave_read_trigger *trigger;
+};
+
+/**
+ * struct mpu_platform_data - Platform data for the mpu driver
+ * @int_config:		Bits [7:3] of the int config register.
+ * @level_shifter:	0: VLogic, 1: VDD
+ * @orientation:	Orientation matrix of the gyroscope
+ *
+ * Contains platform specific information on how to configure the MPU3050 to
+ * work on this platform.  The orientation matricies are 3x3 rotation matricies
+ * that are applied to the data to rotate from the mounting orientation to the
+ * platform orientation.  The values must be one of 0, 1, or -1 and each row and
+ * column should have exactly 1 non-zero value.
+ */
+struct mpu_platform_data {
+	__u8 int_config;
+	__u8 level_shifter;
+	__s8 orientation[GYRO_NUM_AXES * GYRO_NUM_AXES];
+};
+
+#define MPU_IOCTL (0x81) /* Magic number for MPU Iocts */
+/* IOCTL commands for /dev/mpu */
+
+/*--------------------------------------------------------------------------
+ * Deprecated, debugging only
+ */
+#define MPU_SET_MPU_PLATFORM_DATA	\
+	_IOWR(MPU_IOCTL, 0x01, struct mpu_platform_data)
+#define MPU_SET_EXT_SLAVE_PLATFORM_DATA	\
+	_IOWR(MPU_IOCTL, 0x01, struct ext_slave_platform_data)
+/*--------------------------------------------------------------------------*/
+#define MPU_GET_EXT_SLAVE_PLATFORM_DATA	\
+	_IOWR(MPU_IOCTL, 0x02, struct ext_slave_platform_data)
+#define MPU_GET_MPU_PLATFORM_DATA	\
+	_IOWR(MPU_IOCTL, 0x02, struct mpu_platform_data)
+#define MPU_GET_EXT_SLAVE_DESCR	\
+	_IOWR(MPU_IOCTL, 0x02, struct ext_slave_descr)
+
+#define MPU_READ		_IOWR(MPU_IOCTL, 0x10, struct mpu_read_write)
+#define MPU_WRITE		_IOW(MPU_IOCTL,  0x10, struct mpu_read_write)
+#define MPU_READ_MEM		_IOWR(MPU_IOCTL, 0x11, struct mpu_read_write)
+#define MPU_WRITE_MEM		_IOW(MPU_IOCTL,  0x11, struct mpu_read_write)
+#define MPU_READ_FIFO		_IOWR(MPU_IOCTL, 0x12, struct mpu_read_write)
+#define MPU_WRITE_FIFO		_IOW(MPU_IOCTL,  0x12, struct mpu_read_write)
+
+#define MPU_READ_COMPASS	_IOR(MPU_IOCTL, 0x12, __u8)
+#define MPU_READ_ACCEL		_IOR(MPU_IOCTL, 0x13, __u8)
+#define MPU_READ_PRESSURE	_IOR(MPU_IOCTL, 0x14, __u8)
+
+#define MPU_CONFIG_GYRO		_IOW(MPU_IOCTL, 0x20, struct ext_slave_config)
+#define MPU_CONFIG_ACCEL	_IOW(MPU_IOCTL, 0x21, struct ext_slave_config)
+#define MPU_CONFIG_COMPASS	_IOW(MPU_IOCTL, 0x22, struct ext_slave_config)
+#define MPU_CONFIG_PRESSURE	_IOW(MPU_IOCTL, 0x23, struct ext_slave_config)
+
+#define MPU_GET_CONFIG_GYRO	_IOWR(MPU_IOCTL, 0x20, struct ext_slave_config)
+#define MPU_GET_CONFIG_ACCEL	_IOWR(MPU_IOCTL, 0x21, struct ext_slave_config)
+#define MPU_GET_CONFIG_COMPASS	_IOWR(MPU_IOCTL, 0x22, struct ext_slave_config)
+#define MPU_GET_CONFIG_PRESSURE	_IOWR(MPU_IOCTL, 0x23, struct ext_slave_config)
+
+#define MPU_SUSPEND		_IOW(MPU_IOCTL, 0x30, __u32)
+#define MPU_RESUME		_IOW(MPU_IOCTL, 0x31, __u32)
+/* Userspace PM Event response */
+#define MPU_PM_EVENT_HANDLED	_IO(MPU_IOCTL, 0x32)
+
+#define MPU_GET_REQUESTED_SENSORS	_IOR(MPU_IOCTL, 0x40, __u8)
+#define MPU_SET_REQUESTED_SENSORS	_IOW(MPU_IOCTL, 0x40, __u8)
+#define MPU_GET_IGNORE_SYSTEM_SUSPEND	_IOR(MPU_IOCTL, 0x41, __u8)
+#define MPU_SET_IGNORE_SYSTEM_SUSPEND	_IOW(MPU_IOCTL, 0x41, __u8)
+#define MPU_GET_MLDL_STATUS		_IOR(MPU_IOCTL, 0x42, __u8)
+#define MPU_GET_I2C_SLAVES_ENABLED	_IOR(MPU_IOCTL, 0x43, __u8)
+
+
+#endif				/* __MPU_H_ */
-- 
1.7.4.1

