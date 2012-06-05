Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419Ab2FEKcC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:32:02 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38414 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab2FEKb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:31:58 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-input@vger.kernel.org>,
        <dtor@mail.ru>, <sourav.poddar@ti.com>, <DMurphy@ti.com>
CC: <linux-kernel@vger.kernel.org>, Benoit Cousson <b-cousson@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Alan Cox <alan@linux.intel.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Anirudh Ghayal <aghayal@codeaurora.org>
Subject: [PATCH] Input: tsl2771: ambient light and proximity driver
Date: Tue, 5 Jun 2012 16:01:42 +0530
Message-ID: <1338892302-2477-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Murphy <DMurphy@ti.com>

Add tsl2771 ambient light and proximity driver.

Tested on 3.4-rc6 custom kernel having omap5
evm device tree support.

Will post the device tree data once the dts files for omap5
will be available in mainline.

Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Anirudh Ghayal <aghayal@codeaurora.org>
Signed-off-by: Dan Murphy <DMurphy@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
[Sourav Poddar: - Adapted to device tree]
---
 .../devicetree/bindings/input/tsl2771.txt          |   86 ++
 drivers/input/misc/Kconfig                         |   10 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/tsl2771.c                       |  973 ++++++++++++++++++++
 include/linux/i2c/tsl2771.h                        |   71 ++
 5 files changed, 1141 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/tsl2771.txt
 create mode 100644 drivers/input/misc/tsl2771.c
 create mode 100644 include/linux/i2c/tsl2771.h

diff --git a/Documentation/devicetree/bindings/input/tsl2771.txt b/Documentation/devicetree/bindings/input/tsl2771.txt
new file mode 100644
index 0000000..f298475
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/tsl2771.txt
@@ -0,0 +1,86 @@
+* TAOS's ambient light and proximity Controller device tree bindings
+
+The TSL2771 family of devices, an i2c based device, provides both ambient
+light sensing (ALS) and proximity detection (when coupled with an external IR LED).
+The ALS approximates human eye response to light intensity under a variety
+of lighting conditions and through a variety of attenuation materials.
+The proximity detection feature allows a large dynamic range of operation
+for use in short distance detection behind dark glass such as in a cell phone.
+
+Required SoC Specific Properties:
+- compatible: should be one of the following
+- "tsl2771,alps": For controllers compatible with
+	taos tsl2771 controller.
+
+Required Board Specific Properties:
+- tsl2771,gpio : gpio used to signal an interrupt
+- tsl2771,irq_flags : Flags used to configure the irq type
+	(Edge triggered/Level Triggerred)
+- tsl2771,def_enable : Used to power the device on/off, enable
+	functions and interrupts.
+- tsl2771,als_adc_time : Ambient light internal integration time of the
+	ALS clear and IR channel ADCs.
+- tsl2771,prox_adc_time : Controls the integration time of the proximity
+	ADC
+- tsl2771,wait_time : Wait time required between state transition.
+- tsl2771,als_low_thresh_low_byte :
+- tsl2771,als_low_thresh_high_byte :
+	Value to be used as a low trigger points for the comparison function
+	for interrupt generation for ambient light sensor.
+- tsl2771,als_high_thresh_low_byte :
+- tsl2771,als_high_thresh_high_byte :
+	Value to be used as a high trigger points for the comparison function
+	for interrupt generation for ambient light sensor.
+- tsl2771,prox_low_thresh_low_byte :
+- tsl2771,prox_low_thresh_high_byte :
+	Value to be used as a low trigger points for the comparison function
+	for interrupt generation for proximity sensor.
+- tsl2771,prox_high_thresh_low_byte :
+- tsl2771,prox_high_thresh_high_byte :
+	Value to be used as a high trigger points for the comparison function
+	for interrupt generationi for proximity sensor.
+
+- tsl2771,interrupt_persistence : Controls the filtering interrupt capabilities
+	of the device.
+- tsl2771,config : Sets the wait long time
+- tsl2771,prox_pulse_count : Sets the number of proximity pulses that will be transmitted.
+- tsl2771,gain_control : Control functions such as gain settings and diode selection.
+- tsl2771,glass_attn :
+- tsl2771,device_factor :
+	Properties depending on which the calculation of
+	"counts per linux(cpl)" depends.
+- tsl2771,prox_enable_flag : signifies that proximity sensor is to be enabled
+- tsl2771,als_enable_flag : Signifies that ambient light sensor is to be enabled.
+
+Example:
+
+&i2c2 {
+	clock-frequency = <400000>;
+
+	tsl2771@39 {
+		compatible = "tsl2771,alps";
+		reg = <0x39>;
+		tsl2771,gpio = <149>;
+		tsl2771,irq_flags = <0x0000200a>;
+		tsl2771,def_enable = <0x0>;
+		tsl2771,als_adc_time = <0xdb>;
+		tsl2771,prox_adc_time = <0xff>;
+		tsl2771,wait_time = <0x00>;
+		tsl2771,als_low_thresh_low_byte = <0x0>;
+		tsl2771,als_low_thresh_high_byte = <0x0>;
+		tsl2771,als_high_thresh_low_byte = <0x0>;
+		tsl2771,als_high_thresh_high_byte = <0x0>;
+		tsl2771,prox_low_thresh_low_byte = <0x0>;
+		tsl2771,prox_low_thresh_high_byte = <0x0>;
+		tsl2771,prox_high_thresh_low_byte = <0x0>;
+		tsl2771,prox_high_thresh_high_byte = <0x0>;
+		tsl2771,interrupt_persistence = <0xf6>;
+		tsl2771,config = <0x00>;
+		tsl2771,prox_pulse_count = <0x03>;
+		tsl2771,gain_control = <0xe0>;
+		tsl2771,glass_attn = <0x01>;
+		tsl2771,device_factor = <0x34>;
+		tsl2771,prox_enable_flag;
+		tsl2771,als_enable_flag;
+       };
+};
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 7faf4a7..cc85b22 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -177,6 +177,16 @@ config INPUT_MPU3050
 	  To compile this driver as a module, choose M here: the
 	  module will be called mpu3050.
 
+config INPUT_TSL2771
+	tristate "TSL2771 ALS/Proximity Sensor Driver"
+	depends on I2C && SYSFS
+	help
+	  Say Y here if you want to use TSL2771 ALS/Proximity Sensor Driver
+	  through I2C interface.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tsl2771.
+
 config INPUT_APANEL
 	tristate "Fujitsu Lifebook Application Panel buttons"
 	depends on X86 && I2C && LEDS_CLASS
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index f55cdf4..2f72aaf 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_INPUT_MAX8997_HAPTIC)	+= max8997_haptic.o
 obj-$(CONFIG_INPUT_MC13783_PWRBUTTON)	+= mc13783-pwrbutton.o
 obj-$(CONFIG_INPUT_MMA8450)		+= mma8450.o
 obj-$(CONFIG_INPUT_MPU3050)		+= mpu3050.o
+obj-$(CONFIG_INPUT_TSL2771)             += tsl2771.o
 obj-$(CONFIG_INPUT_PCAP)		+= pcap_keys.o
 obj-$(CONFIG_INPUT_PCF50633_PMU)	+= pcf50633-input.o
 obj-$(CONFIG_INPUT_PCF8574)		+= pcf8574_keypad.o
diff --git a/drivers/input/misc/tsl2771.c b/drivers/input/misc/tsl2771.c
new file mode 100644
index 0000000..ec96493
--- /dev/null
+++ b/drivers/input/misc/tsl2771.c
@@ -0,0 +1,973 @@
+/**
+ * tsl2771.c - ALS and Proximity sensor driver
+ *
+ * Copyright (C) 2011 Texas Instruments
+ * Author: Dan Murphy <DMurphy@ti.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file "COPYING" in the main directory of this
+ * archive for more details.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/pm.h>
+#include <linux/platform_device.h>
+#include <linux/workqueue.h>
+#include <linux/i2c.h>
+#include <linux/i2c/tsl2771.h>
+#include <linux/gpio.h>
+
+#define TSL2771_DEBUG 1
+
+#define TSL2771_ALLOWED_R_BYTES	25
+#define TSL2771_ALLOWED_W_BYTES	2
+#define TSL2771_MAX_RW_RETRIES	5
+#define TSL2771_I2C_RETRY_DELAY 10
+
+#define TSL2771_I2C_WRITE	0x80
+#define TSL2771_I2C_READ	0xa0
+
+#define TSL2771_PROX_INT_CLR	0x65
+#define TSL2771_ALS_INT_CLR	0x66
+#define TSL2771_ALL_INT_CLR	0x67
+
+/* TSL2771 Read only registers */
+#define TSL2771_REV	0x11
+#define TSL2771_ID	0x12
+#define TSL2771_STATUS	0x13
+#define TSL2771_CDATAL	0x14
+#define TSL2771_CDATAH	0x15
+#define TSL2771_IRDATAL	0x16
+#define TSL2771_IRDATAH	0x17
+#define TSL2771_PDATAL	0x18
+#define TSL2771_PDATAH	0x19
+
+/* Enable register mask */
+#define TSL2771_PWR_ON		(1 << 0)
+#define TSL2771_ADC_EN		(1 << 1)
+#define TSL2771_PROX_EN		(1 << 2)
+#define TSL2771_WAIT_EN		(1 << 3)
+#define TSL2771_ALS_INT_EN	(1 << 4)
+#define TSL2771_PROX_INT_EN	(1 << 5)
+
+#define TSL2771_ALS_INT		(1 << 4)
+#define TSL2771_PROX_INT	(1 << 5)
+
+#define TSL2771_ALS_EN_FLAG	0x01
+#define TSL2771_PROX_EN_FLAG	0x02
+
+struct tsl2771_data {
+	struct i2c_client *client;
+	struct input_dev *prox_input_dev;
+	struct input_dev *als_input_dev;
+	struct mutex enable_mutex;
+
+	int lux;
+	int prox_distance;
+	int power_state;
+	int power_context;
+	int als_gain;
+	int glass_attn;
+	int device_factor;
+	int irq_flags;
+	int flags;
+	int gpio;
+
+	uint32_t def_enable;
+	uint32_t als_adc_time;
+	uint32_t prox_adc_time;
+	uint32_t wait_time;
+	uint32_t als_ltlb;
+	uint32_t als_lthb;
+	uint32_t als_htlb;
+	uint32_t als_hthb;
+	uint32_t prox_ltlb;
+	uint32_t prox_lthb;
+	uint32_t prox_htlb;
+	uint32_t prox_hthb;
+	uint32_t interrupt_persistence;
+	uint32_t config;
+	uint32_t prox_pulse_count;
+	uint32_t gain_control;
+};
+
+static int als_gain_table[4] = {
+	1, 8, 16, 120
+};
+
+static uint32_t als_prox_debug;
+module_param_named(tsl2771_debug, als_prox_debug, uint, 0664);
+
+#ifdef TSL2771_DEBUG
+struct tsl2771_reg {
+	const char *name;
+	uint8_t reg;
+	int writeable;
+} tsl2771_regs[] = {
+	{ "REV",		TSL2771_REV, 0 },
+	{ "CHIP_ID",		TSL2771_ID, 0 },
+	{ "STATUS",		TSL2771_STATUS, 0 },
+	{ "ADC_LOW",		TSL2771_CDATAL, 0 },
+	{ "ADC_HI",		TSL2771_CDATAH, 0 },
+	{ "IR_LOW_DATA",	TSL2771_IRDATAL, 0 },
+	{ "IR_HI_DATA",		TSL2771_IRDATAH, 0 },
+	{ "P_LOW_DATA",		TSL2771_PDATAL, 0 },
+	{ "P_HI_DATA",		TSL2771_PDATAH, 0 },
+	{ "ENABLE",		TSL2771_ENABLE, 1 },
+	{ "A_ADC_TIME",		TSL2771_ATIME, 1 },
+	{ "P_ADC_TIME",		TSL2771_PTIME, 1 },
+	{ "WAIT_TIME",		TSL2771_WTIME, 1 },
+	{ "A_LOW_TH_LOW",	TSL2771_AILTL, 1 },
+	{ "A_LOW_TH_HI",	TSL2771_AILTH, 1 },
+	{ "A_HI_TH_LOW",	TSL2771_AIHTL, 1 },
+	{ "A_HI_TH_HI",		TSL2771_AIHTH, 1 },
+	{ "P_LOW_TH_LOW",	TSL2771_PILTL, 1 },
+	{ "P_LOW_TH_HI",	TSL2771_PILTH, 1 },
+	{ "P_HI_TH_LOW",	TSL2771_PIHTL, 1 },
+	{ "P_HI_TH_HI",	TSL2771_PIHTH, 1 },
+	{ "INT_PERSIT",		TSL2771_PERS, 1 },
+	{ "PROX_PULSE_CNT",	TSL2771_PPCOUNT, 1 },
+	{ "CONTROL",		TSL2771_CONTROL, 1 },
+};
+#endif
+
+static int tsl2771_write_reg(struct tsl2771_data *data, u8 reg,
+					u8 val, int len)
+{
+	int err;
+	int tries = 0;
+	u8 buf[TSL2771_ALLOWED_W_BYTES];
+
+	struct i2c_msg msgs[] = {
+		{
+		 .addr = data->client->addr,
+		 .flags = data->client->flags,
+		 .len = len + 1,
+		 },
+	};
+
+	buf[0] = (TSL2771_I2C_WRITE | reg);
+	buf[1] = val;
+
+	msgs->buf = buf;
+
+	do {
+		err = i2c_transfer(data->client->adapter, msgs, 1);
+		if (err != 1)
+			msleep_interruptible(TSL2771_I2C_RETRY_DELAY);
+	} while ((err != 1) && (++tries < TSL2771_MAX_RW_RETRIES));
+
+	if (err != 1) {
+		dev_err(&data->client->dev, "write transfer error\n");
+		err = -EIO;
+	} else {
+		err = 0;
+	}
+
+	return err;
+}
+
+static int tsl2771_read_reg(struct tsl2771_data *data, u8 reg, u8 *buf, int len)
+{
+	int err;
+	int tries = 0;
+	u8 reg_buf[TSL2771_ALLOWED_R_BYTES];
+
+	struct i2c_msg msgs[] = {
+		{
+		 .addr = data->client->addr,
+		 .flags = data->client->flags,
+		 .len = 1,
+		 },
+		{
+		 .addr = data->client->addr,
+		 .flags = (data->client->flags | I2C_M_RD),
+		 .len = len,
+		 .buf = buf,
+		 },
+	};
+	reg_buf[0] = (TSL2771_I2C_READ | reg);
+	msgs->buf = reg_buf;
+
+	do {
+		err = i2c_transfer(data->client->adapter, msgs, 2);
+		if (err != 2)
+			msleep_interruptible(TSL2771_I2C_RETRY_DELAY);
+	} while ((err != 2) && (++tries < TSL2771_MAX_RW_RETRIES));
+
+	if (err != 2) {
+		dev_err(&data->client->dev, "read transfer error\n");
+		err = -EIO;
+	} else {
+		err = 0;
+	}
+
+	return err;
+}
+
+static int tsl2771_init_device(struct tsl2771_data *data)
+{
+	int error = 0;
+
+	error = tsl2771_write_reg(data, TSL2771_CONFIG, data->config, 1);
+	if (error)
+		goto init_error;
+
+	error = tsl2771_write_reg(data, TSL2771_ENABLE,
+			data->def_enable, 1);
+	if (error)
+		goto init_error;
+
+	error = tsl2771_write_reg(data, TSL2771_ATIME,
+			data->als_adc_time, 1);
+	if (error)
+		goto init_error;
+
+	error = tsl2771_write_reg(data, TSL2771_PTIME,
+			data->prox_adc_time, 1);
+	if (error)
+		goto init_error;
+
+	error = tsl2771_write_reg(data, TSL2771_WTIME,
+			data->wait_time, 1);
+	if (error)
+		goto init_error;
+
+	error = tsl2771_write_reg(data, TSL2771_AILTL,
+			data->als_ltlb, 1);
+	if (error)
+		goto init_error;
+
+	error = tsl2771_write_reg(data, TSL2771_AILTH,
+			data->als_lthb, 1);
+	if (error)
+		goto init_error;
+
+	error = tsl2771_write_reg(data, TSL2771_AIHTL,
+			data->als_htlb, 1);
+	if (error)
+		goto init_error;
+
+	error = tsl2771_write_reg(data, TSL2771_AIHTH,
+			data->als_hthb, 1);
+	if (error)
+		goto init_error;
+
+	error = tsl2771_write_reg(data, TSL2771_PILTL,
+			data->prox_ltlb, 1);
+	if (error)
+		goto init_error;
+
+	error = tsl2771_write_reg(data, TSL2771_PILTH,
+			data->prox_lthb, 1);
+	if (error)
+		goto init_error;
+
+	error = tsl2771_write_reg(data, TSL2771_PIHTL,
+			data->prox_htlb, 1);
+	if (error)
+		goto init_error;
+
+	error = tsl2771_write_reg(data, TSL2771_PIHTH,
+			data->prox_hthb, 1);
+	if (error)
+		goto init_error;
+
+	error = tsl2771_write_reg(data, TSL2771_PERS,
+			data->interrupt_persistence, 1);
+	if (error)
+		goto init_error;
+
+	error = tsl2771_write_reg(data, TSL2771_PPCOUNT,
+			data->prox_pulse_count, 1);
+	if (error)
+		goto init_error;
+
+	error = tsl2771_write_reg(data, TSL2771_CONTROL,
+			data->gain_control, 1);
+	if (error)
+		goto init_error;
+
+	return 0;
+
+init_error:
+	pr_err("%s:Failed initializing the device\n", __func__);
+	return -1;
+
+}
+
+static int tsl2771_read_prox(struct tsl2771_data *data)
+{
+	u8 data_buffer[4];
+	int prox_data = 0;
+	tsl2771_read_reg(data, TSL2771_PDATAL, data_buffer, 2);
+
+	prox_data = (data_buffer[1] << 8);
+	prox_data |= data_buffer[0];
+
+	if (als_prox_debug & 0x2)
+		pr_info("%s:Prox Data 0x%X\n", __func__, prox_data);
+
+	data->prox_distance = prox_data;
+
+	return prox_data;
+}
+
+static int tsl2771_read_als(struct tsl2771_data *data)
+{
+	int cdata_data = 0;
+	int irdata_data = 0;
+	int ratio = 0;
+	int iac = 0;
+	int cpl = 0;
+	int integration_time = 0;
+	u8 data_buffer[4];
+
+	tsl2771_read_reg(data, TSL2771_CDATAL, data_buffer, 4);
+
+	cdata_data = (data_buffer[1] << 8);
+	cdata_data |= data_buffer[0];
+	irdata_data = (data_buffer[3] << 8);
+	irdata_data |= data_buffer[2];
+	if (als_prox_debug & 0x1)
+		pr_info("%s: IR Data 0x%X CData 0x%X\n", __func__,
+				irdata_data, cdata_data);
+	if (!cdata_data) {
+		pr_err("%s:cdata is NULL\n", __func__);
+		data->lux = 0;
+		goto out;
+	}
+
+	ratio = (irdata_data * 100) / cdata_data;
+	if (als_prox_debug & 0x1)
+		pr_info("%s: Ratio is %i\n", __func__, ratio);
+
+	if ((ratio >= 0) && (ratio <= 30))
+		iac = ((1000 * cdata_data) - (1846 * irdata_data));
+	else if ((ratio >= 30) && (ratio <= 38))
+		iac = ((1268 * cdata_data) - (2740 * irdata_data));
+	else if ((ratio >= 38) && (ratio <= 45))
+		iac = ((749 * cdata_data) - (1374 * irdata_data));
+	else if ((ratio >= 45) && (ratio <= 54))
+		iac = ((477 * cdata_data) - (769 * irdata_data));
+
+	if (als_prox_debug & 0x1)
+		pr_info("%s: IAC %i\n", __func__, iac);
+
+	integration_time = (272 * (256 - data->als_adc_time));
+	data->als_gain = als_gain_table[data->gain_control & 0x3];
+	if (data->glass_attn && data->device_factor)
+		cpl = ((integration_time * data->als_gain) /
+			(data->glass_attn * data->device_factor));
+	else
+		pr_err("%s: Device factor or glass attenuation is NULL\n",
+			__func__);
+
+	if (als_prox_debug & 0x1)
+		pr_info("%s: CPL %i\n", __func__, cpl);
+
+	if (cpl)
+		data->lux = iac / cpl;
+	else
+		pr_err("%s: Count per lux is zero\n", __func__);
+
+	if (als_prox_debug & 0x1)
+		pr_info("%s:Current lux is %i\n", __func__, data->lux);
+
+out:
+	return data->lux;
+}
+static int tsl2771_als_enable(struct tsl2771_data *data, int val)
+{
+	u8 enable_buf[2];
+	u8 write_buf;
+
+	tsl2771_read_reg(data, TSL2771_ENABLE, enable_buf, 1);
+	if (val) {
+		write_buf = (TSL2771_ALS_INT_EN | TSL2771_ADC_EN |
+				TSL2771_PWR_ON | enable_buf[0]);
+		data->power_state |= TSL2771_ALS_EN_FLAG;
+	} else {
+		write_buf = (~TSL2771_ALS_INT_EN & ~TSL2771_ADC_EN &
+				enable_buf[0]);
+
+		if (!(data->power_state & ~TSL2771_PROX_EN_FLAG))
+			write_buf &= ~TSL2771_PWR_ON;
+
+		data->power_state &= ~TSL2771_ALS_EN_FLAG;
+	}
+
+	return tsl2771_write_reg(data, TSL2771_ENABLE, write_buf, 1);
+
+}
+
+static int tsl2771_prox_enable(struct tsl2771_data *data, int val)
+{
+	u8 enable_buf[2];
+	u8 write_buf;
+
+	tsl2771_read_reg(data, TSL2771_ENABLE, enable_buf, 1);
+	if (val) {
+		write_buf = (TSL2771_PROX_INT_EN | TSL2771_PROX_EN |
+				TSL2771_PWR_ON | enable_buf[0]);
+		data->power_state |= TSL2771_PROX_EN_FLAG;
+	} else {
+		write_buf = (~TSL2771_PROX_INT_EN & ~TSL2771_PROX_EN &
+				enable_buf[0]);
+
+		if (!(data->power_state & ~TSL2771_ALS_EN_FLAG))
+			write_buf &= ~TSL2771_PWR_ON;
+
+		data->power_state &= ~TSL2771_PROX_EN_FLAG;
+	}
+	return tsl2771_write_reg(data, TSL2771_ENABLE, write_buf, 1);
+
+}
+
+static void tsl2771_report_prox_input(struct tsl2771_data *data)
+{
+	input_report_abs(data->prox_input_dev, ABS_DISTANCE,
+				data->prox_distance);
+	input_sync(data->prox_input_dev);
+}
+
+static void tsl2771_report_als_input(struct tsl2771_data *data)
+{
+	input_event(data->als_input_dev, EV_LED, LED_MISC, data->lux);
+	input_sync(data->als_input_dev);
+}
+
+static irqreturn_t tsl2771_work_queue(int irq, void *dev_id)
+{
+	struct tsl2771_data *data = dev_id;
+	int err = 0;
+	u8 enable_buf[2];
+
+	mutex_lock(&data->enable_mutex);
+	tsl2771_read_reg(data, TSL2771_STATUS, enable_buf, 1);
+	if (enable_buf[0] & TSL2771_ALS_INT) {
+		err = tsl2771_read_als(data);
+		if (err < 0) {
+			pr_err("%s: Not going to report ALS\n", __func__);
+			goto prox_check;
+		}
+		tsl2771_report_als_input(data);
+	}
+
+prox_check:
+	if (enable_buf[0] & TSL2771_PROX_INT) {
+		err = tsl2771_read_prox(data);
+		if (err < 0) {
+			pr_err("%s: Not going to report prox\n", __func__);
+			goto done;
+		}
+		tsl2771_report_prox_input(data);
+	}
+
+done:
+	tsl2771_write_reg(data, TSL2771_ALL_INT_CLR, 0, 0);
+	mutex_unlock(&data->enable_mutex);
+	return IRQ_HANDLED;
+}
+
+static ssize_t tsl2771_show_attr_enable(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct tsl2771_data *data = i2c_get_clientdata(client);
+
+	return sprintf(buf, "%d\n", (data->power_state & 0x3));
+}
+
+static ssize_t tsl2771_store_attr_prox_enable(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct tsl2771_data *data = platform_get_drvdata(pdev);
+	unsigned long val;
+	int error = 0;
+
+	error = kstrtoul(buf, 0, &val);
+	if (error)
+		return error;
+
+	if (!(data->flags & TSL2771_USE_PROX)) {
+		pr_err("%s: PROX is not supported by kernel\n", __func__);
+		return -ENODEV;
+	}
+
+	mutex_lock(&data->enable_mutex);
+
+	error = tsl2771_prox_enable(data, val);
+	if (error) {
+		pr_err("%s:Failed to turn prox %s\n",
+			__func__, (val ? "on" : "off"));
+		goto error;
+	}
+
+	error = tsl2771_read_prox(data);
+	tsl2771_report_prox_input(data);
+error:
+	mutex_unlock(&data->enable_mutex);
+	return count;
+}
+
+static ssize_t tsl2771_store_attr_als_enable(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct tsl2771_data *data = platform_get_drvdata(pdev);
+	unsigned long val;
+	int error = 0;
+
+	error = kstrtoul(buf, 0, &val);
+	if (error)
+		return error;
+
+	if (!(data->flags & TSL2771_USE_ALS)) {
+		pr_err("%s: ALS is not supported by kernel\n", __func__);
+		return -ENODEV;
+	}
+
+	mutex_lock(&data->enable_mutex);
+
+	error = tsl2771_als_enable(data, val);
+	if (error) {
+		pr_err("%s:Failed to turn prox %s\n",
+			__func__, (val ? "on" : "off"));
+		goto error;
+	}
+
+	error = tsl2771_read_als(data);
+	tsl2771_report_als_input(data);
+error:
+	mutex_unlock(&data->enable_mutex);
+	return count;
+}
+
+static ssize_t tsl2771_show_attr_delay(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	return sprintf(buf, "%d\n", 1);
+}
+
+static ssize_t tsl2771_store_attr_delay(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	unsigned long interval;
+	int error = 0;
+
+	error = kstrtoul(buf, 0, &interval);
+	if (error)
+		return error;
+
+	return count;
+}
+
+#ifdef TSL2771_DEBUG
+static ssize_t tsl2771_registers_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct tsl2771_data *data = platform_get_drvdata(pdev);
+	unsigned i, n, reg_count;
+	u8 read_buf[2];
+
+	reg_count = sizeof(tsl2771_regs) / sizeof(tsl2771_regs[0]);
+	for (i = 0, n = 0; i < reg_count; i++) {
+		tsl2771_read_reg(data, tsl2771_regs[i].reg, read_buf, 1);
+		n += scnprintf(buf + n, PAGE_SIZE - n,
+			       "%-20s = 0x%02X\n",
+			       tsl2771_regs[i].name,
+			       read_buf[0]);
+	}
+
+	return n;
+}
+
+static ssize_t tsl2771_registers_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct tsl2771_data *data = platform_get_drvdata(pdev);
+	unsigned i, reg_count, value;
+	int error = 0;
+	char name[30];
+
+	if (count >= 30) {
+		pr_err("%s:input too long\n", __func__);
+		return -1;
+	}
+
+	if (sscanf(buf, "%s %x", name, &value) != 2) {
+		pr_err("%s:unable to parse input\n", __func__);
+		return -1;
+	}
+
+	reg_count = sizeof(tsl2771_regs) / sizeof(tsl2771_regs[0]);
+	for (i = 0; i < reg_count; i++) {
+		if (!strcmp(name, tsl2771_regs[i].name)) {
+			if (tsl2771_regs[i].writeable) {
+				error = tsl2771_write_reg(data,
+						tsl2771_regs[i].reg, value, 1);
+				if (error) {
+					pr_err("%s:Failed to write %s\n",
+						__func__, name);
+					return -1;
+				}
+			} else {
+				pr_err("%s:Register %s is not writeable\n",
+						__func__, name);
+					return -1;
+			}
+			return count;
+		}
+	}
+
+	pr_err("%s:no such register %s\n", __func__, name);
+	return -1;
+}
+static ssize_t tsl2771_lux_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct tsl2771_data *data = platform_get_drvdata(pdev);
+
+	tsl2771_read_als(data);
+	return sprintf(buf, "%d\n", data->lux);
+}
+static DEVICE_ATTR(registers, S_IWUSR | S_IRUGO,
+		tsl2771_registers_show, tsl2771_registers_store);
+
+static DEVICE_ATTR(lux, S_IWUSR | S_IRUGO,
+		tsl2771_lux_show, NULL);
+#endif
+static DEVICE_ATTR(als_enable, S_IWUSR | S_IRUGO,
+		tsl2771_show_attr_enable, tsl2771_store_attr_als_enable);
+
+static DEVICE_ATTR(prox_enable, S_IWUSR | S_IRUGO,
+		tsl2771_show_attr_enable, tsl2771_store_attr_prox_enable);
+
+static DEVICE_ATTR(delay, S_IWUSR | S_IRUGO,
+		tsl2771_show_attr_delay, tsl2771_store_attr_delay);
+
+static struct attribute *tsl2771_attrs[] = {
+	&dev_attr_als_enable.attr,
+	&dev_attr_prox_enable.attr,
+	&dev_attr_delay.attr,
+#ifdef TSL2771_DEBUG
+	&dev_attr_registers.attr,
+	&dev_attr_lux.attr,
+#endif
+	NULL
+};
+
+static const struct attribute_group tsl2771_attr_group = {
+	.attrs = tsl2771_attrs,
+};
+
+static struct  tsl2771_data *tsl2771_parse_dt(struct i2c_client *client)
+{
+	struct device_node *np = client->dev.of_node;
+	struct  tsl2771_data *data = i2c_get_clientdata(client);
+
+	if (of_get_property(np, "tsl2771,als_enable_flag", NULL))
+		data->flags = TSL2771_USE_ALS;
+
+	if (of_get_property(np, "tsl2771,prox_enable_flag", NULL))
+		data->flags |= TSL2771_USE_PROX;
+
+	of_property_read_u32(np, "tsl2771,irq_flags", &data->irq_flags);
+	of_property_read_u32(np, "tsl2771,gpio", &data->gpio);
+	of_property_read_u32(np, "tsl2771,def_enable", &data->def_enable);
+	of_property_read_u32(np, "tsl2771,als_adc_time", &data->als_adc_time);
+	of_property_read_u32(np, "tsl2771,prox_adc_time", &data->prox_adc_time);
+	of_property_read_u32(np, "tsl2771,wait_time", &data->wait_time);
+	of_property_read_u32(np, "tsl2771,als_low_thresh_low_byte",
+					&data->als_ltlb);
+	of_property_read_u32(np, "tsl2771,als_low_thresh_high_byte",
+					&data->als_lthb);
+	of_property_read_u32(np, "tsl2771,als_high_thresh_low_byte",
+					&data->als_htlb);
+	of_property_read_u32(np, "tsl2771,als_high_thresh_high_byte",
+					&data->als_hthb);
+	of_property_read_u32(np, "tsl2771,prox_low_thresh_low_byte",
+					&data->prox_ltlb);
+	of_property_read_u32(np, "tsl2771,prox_low_thresh_high_byte",
+					&data->prox_lthb);
+	of_property_read_u32(np, "tsl2771,prox_high_thresh_low_byte",
+					&data->prox_htlb);
+	of_property_read_u32(np, "tsl2771,prox_high_thresh_high_byte",
+					&data->prox_hthb);
+	of_property_read_u32(np, "tsl2771,interrupt_persistence",
+					&data->interrupt_persistence);
+	of_property_read_u32(np, "tsl2771,config",
+					&data->config);
+	of_property_read_u32(np, "tsl2771,prox_pulse_count",
+					&data->prox_pulse_count);
+	of_property_read_u32(np, "tsl2771,gain_control",
+					&data->gain_control);
+	of_property_read_u32(np, "tsl2771,glass_attn",
+					&data->glass_attn);
+	of_property_read_u32(np, "tsl2771,device_factor",
+					&data->device_factor);
+
+	return data;
+}
+
+static int __devinit tsl2771_driver_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	struct tsl2771_data *data;
+	int ret = 0;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		pr_err("%s: need I2C_FUNC_I2C\n", __func__);
+		return -ENODEV;
+	}
+
+	data = devm_kzalloc(&client->dev,
+			sizeof(struct tsl2771_data), GFP_KERNEL);
+	if (!data) {
+		ret = -ENOMEM;
+		goto error;
+	}
+	data->client = client;
+	i2c_set_clientdata(client, data);
+	mutex_init(&data->enable_mutex);
+
+	data = tsl2771_parse_dt(client);
+
+	if (data->flags & TSL2771_USE_PROX) {
+		data->prox_input_dev = input_allocate_device();
+		if (data->prox_input_dev == NULL) {
+			ret = -ENOMEM;
+			pr_err("%s:Failed to allocate proximity input device\n",
+					__func__);
+			goto prox_input_error;
+		}
+
+		data->prox_input_dev->name = "tsl2771_prox";
+		data->prox_input_dev->id.bustype = BUS_I2C;
+		data->prox_input_dev->dev.parent = &data->client->dev;
+		input_set_capability(data->prox_input_dev,
+					EV_ABS, ABS_DISTANCE);
+		input_set_drvdata(data->prox_input_dev, data);
+
+		__set_bit(EV_ABS, data->prox_input_dev->evbit);
+		input_set_abs_params(data->prox_input_dev,
+					ABS_DISTANCE, 0, 1, 0, 0);
+
+		ret = input_register_device(data->prox_input_dev);
+		if (ret) {
+			pr_err("%s:Unable to register prox device\n", __func__);
+			goto prox_register_fail;
+		}
+	}
+
+	if (data->flags & TSL2771_USE_ALS) {
+		data->als_input_dev = input_allocate_device();
+		if (data->als_input_dev == NULL) {
+			ret = -ENOMEM;
+			pr_err("%s:Failed to allocate als input device\n",
+					__func__);
+			goto als_input_error;
+		}
+		data->als_input_dev->name = "tsl2771_als";
+		data->als_input_dev->id.bustype = BUS_I2C;
+		data->als_input_dev->dev.parent = &data->client->dev;
+		input_set_capability(data->als_input_dev, EV_MSC, MSC_RAW);
+		input_set_capability(data->als_input_dev, EV_LED, LED_MISC);
+		input_set_drvdata(data->als_input_dev, data);
+		ret = input_register_device(data->als_input_dev);
+		if (ret) {
+			pr_err("%s:Unable to register als device\n", __func__);
+			goto als_register_fail;
+		}
+	}
+
+	ret = gpio_request_one(data->gpio, GPIOF_IN, "sensor");
+	if (ret) {
+		dev_err(&data->client->dev, "sensor: gpio request failure\n");
+		return ret;
+	}
+
+	if (data->gpio) {
+		ret = request_threaded_irq(gpio_to_irq(data->gpio), NULL,
+					tsl2771_work_queue,
+					data->irq_flags,
+					data->client->name, data);
+		if (ret < 0) {
+			dev_err(&data->client->dev,
+				"request_threaded_irq failed\n");
+			goto irq_request_fail;
+		}
+	} else {
+		pr_err("%s: No IRQ defined therefore failing\n", __func__);
+		goto irq_request_fail;
+	}
+
+	ret = tsl2771_init_device(data);
+	if (ret) {
+		pr_err("%s:TSL2771 device init failed\n", __func__);
+		goto device_init_fail;
+	}
+
+	data->power_state = 0;
+
+	ret = sysfs_create_group(&client->dev.kobj, &tsl2771_attr_group);
+	if (ret) {
+		pr_err("%s:Cannot create sysfs group\n", __func__);
+		goto sysfs_create_fail;
+	}
+
+	return 0;
+
+sysfs_create_fail:
+	kfree(data);
+device_init_fail:
+	if (data->gpio)
+		free_irq(gpio_to_irq(data->gpio), data);
+irq_request_fail:
+als_register_fail:
+	if (data->flags & TSL2771_USE_ALS)
+		input_free_device(data->als_input_dev);
+als_input_error:
+prox_register_fail:
+	if (data->flags & TSL2771_USE_PROX)
+		input_free_device(data->prox_input_dev);
+prox_input_error:
+	mutex_destroy(&data->enable_mutex);
+	kfree(data);
+error:
+	return ret;
+}
+
+static int __devexit tsl2771_driver_remove(struct i2c_client *client)
+{
+	struct tsl2771_data *data = i2c_get_clientdata(client);
+	int ret = 0;
+
+	sysfs_remove_group(&client->dev.kobj, &tsl2771_attr_group);
+
+	if (data->gpio)
+		free_irq(gpio_to_irq(data->gpio), data);
+
+	if (data->prox_input_dev)
+		input_free_device(data->prox_input_dev);
+
+	if (data->als_input_dev)
+		input_free_device(data->als_input_dev);
+
+	i2c_set_clientdata(client, NULL);
+	mutex_destroy(&data->enable_mutex);
+	kfree(data);
+
+	return ret;
+}
+
+#ifdef CONFIG_PM
+static int tsl2771_driver_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct tsl2771_data *data = platform_get_drvdata(pdev);
+
+	data->power_context = data->power_state;
+	if (data->power_state & 0x2) {
+		if (als_prox_debug & 0x4)
+			pr_info("%s:Prox was enabled into suspend\n", __func__);
+	} else
+		tsl2771_prox_enable(data, 0);
+
+	tsl2771_als_enable(data, 0);
+
+	return 0;
+}
+
+static int tsl2771_driver_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct tsl2771_data *data = platform_get_drvdata(pdev);
+
+	if (data->power_context & 0x2) {
+		if (als_prox_debug & 0x4)
+			pr_info("%s:Prox was enabled into suspend\n", __func__);
+	} else
+		tsl2771_prox_enable(data, 1);
+
+	if (data->power_context & 0x1) {
+		if (als_prox_debug & 0x4)
+			pr_info("%s:ALS was enabled\n", __func__);
+		tsl2771_als_enable(data, 1);
+	}
+
+	return 0;
+}
+
+static const struct dev_pm_ops tsl2771_pm_ops = {
+	.suspend = tsl2771_driver_suspend,
+	.resume = tsl2771_driver_resume,
+};
+#endif
+
+static const struct i2c_device_id tsl2771_idtable[] = {
+	{ TSL2771_NAME, 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, tsl2771_idtable);
+
+static const struct of_device_id tsl2771_dt_match[] = {
+	{ .compatible = "tsl2771,alps"},
+	{},
+};
+MODULE_DEVICE_TABLE(of, tsl2771_dt_match);
+
+static struct i2c_driver tsl2771_driver = {
+	.probe		= tsl2771_driver_probe,
+	.remove		= tsl2771_driver_remove,
+	.id_table	= tsl2771_idtable,
+	.driver = {
+		.name = TSL2771_NAME,
+#ifdef CONFIG_PM
+		.pm = &tsl2771_pm_ops,
+#endif
+		.of_match_table = of_match_ptr(tsl2771_dt_match),
+	},
+};
+
+static int __init tsl2771_driver_init(void)
+{
+	return i2c_add_driver(&tsl2771_driver);
+}
+
+static void __exit tsl2771_driver_exit(void)
+{
+	i2c_del_driver(&tsl2771_driver);
+}
+
+module_init(tsl2771_driver_init);
+module_exit(tsl2771_driver_exit);
+
+MODULE_DESCRIPTION("TSL2771 ALS/Prox Driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Dan Murphy <DMurphy@ti.com>");
diff --git a/include/linux/i2c/tsl2771.h b/include/linux/i2c/tsl2771.h
new file mode 100644
index 0000000..79e4328
--- /dev/null
+++ b/include/linux/i2c/tsl2771.h
@@ -0,0 +1,71 @@
+/*
+ * tsl2771.h
+ * TSL2771 ALS and Proximity driver
+ *
+ * Copyright (C) 2011 Texas Instruments
+ * Author: Dan Murphy <DMurphy@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _LINUX_TSL2771_I2C_H
+#define _LINUX_TSL2771_I2C_H
+
+#define TSL2771_NAME	"tsl2771"
+
+/* TSL2771 Read/Write registers */
+#define TSL2771_ENABLE	0x00
+#define TSL2771_ATIME	0x01
+#define TSL2771_PTIME	0x02
+#define TSL2771_WTIME	0x03
+#define TSL2771_AILTL	0x04
+#define TSL2771_AILTH	0x05
+#define TSL2771_AIHTL	0x06
+#define TSL2771_AIHTH	0x07
+#define TSL2771_PILTL	0x08
+#define TSL2771_PILTH	0x09
+#define TSL2771_PIHTL	0x0a
+#define TSL2771_PIHTH	0x0b
+#define TSL2771_PERS	0x0c
+#define TSL2771_CONFIG	0x0d
+#define TSL2771_PPCOUNT	0x0e
+#define TSL2771_CONTROL	0x0f
+
+#define TSL2771_USE_ALS		(1 << 0)
+#define TSL2771_USE_PROX	(1 << 1)
+
+struct tsl2771_platform_data {
+	int irq_flags;
+	int flags;
+        int glass_attn;
+        int device_factor;
+
+	uint8_t def_enable;
+	uint8_t als_adc_time;
+	uint8_t prox_adc_time;
+	uint8_t wait_time;
+	uint8_t als_low_thresh_low_byte;
+	uint8_t als_low_thresh_high_byte;
+	uint8_t als_high_thresh_low_byte;
+	uint8_t als_high_thresh_high_byte;
+	uint8_t prox_low_thresh_low_byte;
+	uint8_t prox_low_thresh_high_byte;
+	uint8_t prox_high_thresh_low_byte;
+	uint8_t prox_high_thresh_high_byte;
+	uint8_t interrupt_persistence;
+	uint8_t config;
+	uint8_t prox_pulse_count;
+	uint8_t gain_control;
+};
+
+#endif
-- 
1.7.1

