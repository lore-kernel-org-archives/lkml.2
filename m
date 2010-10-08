Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab0JHNmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:42:35 -0400
Received: from smtp.nokia.com ([192.100.122.233]:62344 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539Ab0JHNma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:42:30 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, jic23@cam.ac.uk,
        alan@lxorguk.ukuu.org.uk
Subject: [PATCHv2 1/5] misc: Driver for bh1770glc / sfh7770 ALS and proximity sensor
Date: Fri,  8 Oct 2010 16:42:00 +0300
Message-Id: <1286545324-18506-2-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1286545324-18506-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1286545324-18506-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 08 Oct 2010 13:42:11.0640 (UTC) FILETIME=[9C0AE380:01CB66EE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a driver for ROHM BH1770GLC and OSRAM SFH7770 combined
ALS and proximity sensor.

Interface is sysfs based. The driver uses interrupts to provide new data.
The driver supports pm_runtime and regulator frameworks.

See Documentation/misc-devices/bhsfh.txt for details

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/misc/bhsfh.c      | 1443 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/bhsfh.h |   42 ++
 2 files changed, 1485 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/bhsfh.c
 create mode 100644 include/linux/i2c/bhsfh.h

diff --git a/drivers/misc/bhsfh.c b/drivers/misc/bhsfh.c
new file mode 100644
index 0000000..e82fadb
--- /dev/null
+++ b/drivers/misc/bhsfh.c
@@ -0,0 +1,1443 @@
+/*
+ * This file is part of the ROHM BH1770GLC / OSRAM SFH7770 sensor driver.
+ * Chip is combined proximity and ambient light sensor.
+ *
+ * Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
+ *
+ * Contact: Samu Onkalo <samu.p.onkalo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/mutex.h>
+#include <linux/i2c/bhsfh.h>
+#include <linux/regulator/consumer.h>
+#include <linux/pm_runtime.h>
+#include <linux/workqueue.h>
+#include <linux/delay.h>
+#include <linux/wait.h>
+#include <linux/slab.h>
+
+#define BHSFH_ALS_CONTROL	0x80 /* ALS operation mode control */
+#define BHSFH_PS_CONTROL	0x81 /* PS operation mode control */
+#define BHSFH_I_LED		0x82 /* active LED and LED1, LED2 current */
+#define BHSFH_I_LED3		0x83 /* LED3 current setting */
+#define BHSFH_ALS_PS_MEAS	0x84 /* Forced mode trigger */
+#define BHSFH_PS_MEAS_RATE	0x85 /* PS meas. rate at stand alone mode */
+#define BHSFH_ALS_MEAS_RATE	0x86 /* ALS meas. rate at stand alone mode */
+#define BHSFH_PART_ID		0x8a /* Part number and revision ID */
+#define BHSFH_MANUFACT_ID	0x8b /* Manufacturerer ID */
+#define BHSFH_ALS_DATA_0	0x8c /* ALS DATA low byte */
+#define BHSFH_ALS_DATA_1	0x8d /* ALS DATA high byte */
+#define BHSFH_ALS_PS_STATUS	0x8e /* Measurement data and int status */
+#define BHSFH_PS_DATA_LED1	0x8f /* PS data from LED1 */
+#define BHSFH_PS_DATA_LED2	0x90 /* PS data from LED2 */
+#define BHSFH_PS_DATA_LED3	0x91 /* PS data from LED3 */
+#define BHSFH_INTERRUPT		0x92 /* Interrupt setting */
+#define BHSFH_PS_TH_LED1	0x93 /* PS interrupt threshold for LED1 */
+#define BHSFH_PS_TH_LED2	0x94 /* PS interrupt threshold for LED2 */
+#define BHSFH_PS_TH_LED3	0x95 /* PS interrupt threshold for LED3 */
+#define BHSFH_ALS_TH_UP_0	0x96 /* ALS upper threshold low byte */
+#define BHSFH_ALS_TH_UP_1	0x97 /* ALS upper threshold high byte */
+#define BHSFH_ALS_TH_LOW_0	0x98 /* ALS lower threshold low byte */
+#define BHSFH_ALS_TH_LOW_1	0x99 /* ALS lower threshold high byte */
+
+/* MANUFACT_ID */
+#define BHSFH_MANUFACT_ROHM	0x01
+#define BHSFH_MANUFACT_OSRAM	0x03
+
+/* PART_ID */
+#define BHSFH_PART		0x90
+#define BHSFH_PART_MASK	0xf0
+#define BHSFH_REV_MASK		0x0f
+#define BHSFH_REV_SHIFT	0
+#define BHSFH_REV_0		0x00
+#define BHSFH_REV_1		0x01
+
+/* ALS_MEAS_RATE */
+#define BHSFH_ALS_MAX_RATE	9
+
+/* PS_MEAS_RATE */
+#define BHSFH_PS_MAX_RATE	4
+
+/* Operating modes for both */
+#define BHSFH_STANDBY		0x00
+#define BHSFH_FORCED		0x02
+#define BHSFH_STANDALONE	0x03
+#define BHSFH_SWRESET		(0x01 << 2)
+
+#define BHSFH_PS_TRIG_MEAS	(1 << 0)
+#define BHSFH_ALS_TRIG_MEAS	(1 << 1)
+
+/* Interrupt control */
+#define BHSFH_INT_OUTPUT_MODE	(1 << 3) /* 0 = latched */
+#define BHSFH_INT_POLARITY	(1 << 2) /* 1 = active high */
+#define BHSFH_INT_ALS_ENA	(1 << 1)
+#define BHSFH_INT_PS_ENA	(1 << 0)
+
+/* Interrupt status */
+#define BHSFH_INT_LED1_DATA	(1 << 0)
+#define BHSFH_INT_LED1_INT	(1 << 1)
+#define BHSFH_INT_LED2_DATA	(1 << 2)
+#define BHSFH_INT_LED2_INT	(1 << 3)
+#define BHSFH_INT_LED3_DATA	(1 << 4)
+#define BHSFH_INT_LED3_INT	(1 << 5)
+#define BHSFH_INT_LEDS_INT	((1 << 1) | (1 << 3) | (1 << 5))
+#define BHSFH_INT_ALS_DATA	(1 << 6)
+#define BHSFH_INT_ALS_INT	(1 << 7)
+
+/* Led channels */
+#define BHSFH_LED1		0x00
+
+#define BHSFH_DISABLE		0
+#define BHSFH_ENABLE		1
+#define BHSFH_PROX_CHANNELS	1
+
+#define BHSFH_LUX_DEFAULT_RATE	1 /* Index to lux rate table */
+#define BHSFH_PROX_DEFAULT_RATE	 50 /* in Hz */
+#define BHSFH_PROX_DEF_RATE_THRESH 5 /* in Hz */
+#define BHSFH_STARTUP_DELAY	50
+#define BHSFH_RESET_TIME	10
+#define BHSFH_TIMEOUT		2100 /* Timeout in 2.1 seconds */
+
+#define BHSFH_LUX_RANGE		65535
+#define BHSFH_PROX_RANGE	255
+#define BHSFH_COEF_SCALER	1024
+#define BHSFH_CALIB_SCALER	8192
+#define BHSFH_LUX_NEUTRAL_CALIB_VALUE (1 * BHSFH_CALIB_SCALER)
+#define BHSFH_LUX_DEF_THRES	1000
+#define BHSFH_PROX_DEF_THRES	70
+#define BHSFH_PROX_DEF_ABS_THRES   100
+#define BHSFH_DEFAULT_PERSISTENCE  10
+#define BHSFH_PROX_MAX_PERSISTENCE 50
+#define BHSFH_LUX_GA_SCALE	16384
+#define BHSFH_LUX_CF_SCALE	2048 /* CF ChipFactor */
+#define BHSFH_NEUTRAL_CF	BHSFH_LUX_CF_SCALE
+#define BHSFH_LUX_CORR_SCALE	4096
+
+#define PROX_ABOVE_THRESHOLD	1
+#define PROX_BELOW_THRESHOLD	0
+
+#define PROX_IGNORE_LUX_LIMIT	500
+
+struct bhsfh_chip {
+	struct bhsfh_platform_data	*pdata;
+	char				chipname[10];
+	u8				revision;
+	struct i2c_client		*client;
+	struct regulator_bulk_data	regs[2];
+	struct mutex			mutex; /* avoid parallel access */
+	wait_queue_head_t		wait;
+
+	bool			int_mode_prox;
+	bool			int_mode_lux;
+	struct delayed_work	prox_work;
+	u32	lux_cf; /* Chip specific factor */
+	u32	lux_ga;
+	u32	lux_calib;
+	int	lux_rate_index;
+	u32	lux_corr;
+	u16	lux_data_raw;
+	u16	lux_threshold_hi;
+	u16	lux_threshold_lo;
+	u16	lux_thres_hi_onchip;
+	u16	lux_thres_lo_onchip;
+	bool	lux_wait_result;
+
+	int	prox_enable_count;
+	u16	prox_coef;
+	u16	prox_const;
+	int	prox_rate;
+	int	prox_rate_threshold;
+	u8	prox_persistence;
+	u8	prox_persistence_counter;
+	u8	prox_data;
+	u8	prox_threshold;
+	u8	prox_threshold_hw;
+	bool	prox_force_update;
+	u8	prox_abs_thres;
+	u8	prox_led;
+	u8	prox_channels; /* nbr of leds */
+};
+
+static const char reg_vcc[] = "Vcc";
+static const char reg_vleds[] = "Vleds";
+
+/*
+ * Supported stand alone rates in ms from chip data sheet
+ * {10, 20, 30, 40, 70, 100, 200, 500, 1000, 2000};
+ */
+static const s16 prox_rates_hz[] = {100, 50, 33, 25, 14, 10, 5, 2};
+static const s16 prox_rates_ms[] = {10, 20, 30, 40, 70, 100, 200, 500};
+
+/* Supported IR-led currents in mA */
+static const u8 prox_curr_ma[] = {5, 10, 20, 50, 100, 150, 200};
+
+/*
+ * Supported stand alone rates in ms from chip data sheet
+ * {100, 200, 500, 1000, 2000};
+ */
+static const s16 lux_rates_hz[] = {10, 5, 2, 1, 0};
+
+/*
+ * interrupt control functions are called while keeping chip->mutex
+ * excluding module probe / remove
+ */
+static inline int bhsfh_lux_interrupt_control(struct bhsfh_chip *chip,
+					int lux)
+{
+	chip->int_mode_lux = lux;
+	/* Set interrupt modes, interrupt active low, latched */
+	return i2c_smbus_write_byte_data(chip->client,
+					BHSFH_INTERRUPT,
+					(lux << 1) | chip->int_mode_prox);
+}
+
+static inline int bhsfh_prox_interrupt_control(struct bhsfh_chip *chip,
+					int ps)
+{
+	chip->int_mode_prox = ps;
+	return i2c_smbus_write_byte_data(chip->client,
+					BHSFH_INTERRUPT,
+					(chip->int_mode_lux << 1) | (ps << 0));
+}
+
+/* chip->mutex is always kept here */
+static int bhsfh_lux_rate(struct bhsfh_chip *chip, int rate_index)
+{
+	/* sysfs may call this when the chip is powered off */
+	if (pm_runtime_suspended(&chip->client->dev))
+		return 0;
+
+	/* Proper proximity response needs fastest lux rate (100ms) */
+	if (chip->prox_enable_count)
+		rate_index = 0;
+
+	return i2c_smbus_write_byte_data(chip->client,
+					BHSFH_ALS_MEAS_RATE,
+					rate_index);
+}
+
+static int bhsfh_prox_rate(struct bhsfh_chip *chip, int mode)
+{
+	int rate;
+
+	rate = (mode == PROX_ABOVE_THRESHOLD) ?
+		chip->prox_rate_threshold : chip->prox_rate;
+
+	return i2c_smbus_write_byte_data(chip->client,
+					BHSFH_PS_MEAS_RATE,
+					rate);
+}
+
+/* InfraredLED is controlled by the chip during proximity scanning */
+static inline int bhsfh_led_cfg(struct bhsfh_chip *chip)
+{
+	/* LED cfg, current for leds 1 and 2 */
+	return i2c_smbus_write_byte_data(chip->client,
+					BHSFH_I_LED,
+					(BHSFH_LED1 << 6) |
+					(BHSFH_LED_5mA << 3) |
+					chip->prox_led);
+}
+
+/*
+ * Following two functions converts raw ps values from HW to normalized
+ * values. Purpose is to compensate differences between different sensor
+ * versions and variants so that result means about the same between
+ * versions.
+ */
+static inline u8 bhsfh_psraw_to_adjusted(struct bhsfh_chip *chip, u8 psraw)
+{
+	u16 adjusted;
+	adjusted = (u16)(((u32)(psraw + chip->prox_const) * chip->prox_coef) /
+		BHSFH_COEF_SCALER);
+	if (adjusted > BHSFH_PROX_RANGE)
+		adjusted = BHSFH_PROX_RANGE;
+	return adjusted;
+}
+
+static inline u8 bhsfh_psadjusted_to_raw(struct bhsfh_chip *chip, u8 ps)
+{
+	u16 raw;
+
+	raw = (((u32)ps * BHSFH_COEF_SCALER) / chip->prox_coef);
+	if (raw > chip->prox_const)
+		raw = raw - chip->prox_const;
+	else
+		raw = 0;
+	return raw;
+}
+
+/*
+ * Following two functions converts raw lux values from HW to normalized
+ * values. Purpose is to compensate differences between different sensor
+ * versions and variants so that result means about the same between
+ * versions. Chip->mutex is kept when this is called.
+ */
+static int bhsfh_prox_set_threshold(struct bhsfh_chip *chip)
+{
+	u8 tmp = 0;
+
+	/* sysfs may call this when the chip is powered off */
+	if (pm_runtime_suspended(&chip->client->dev))
+		return 0;
+
+	tmp = bhsfh_psadjusted_to_raw(chip, chip->prox_threshold);
+	chip->prox_threshold_hw = tmp;
+
+	return	i2c_smbus_write_byte_data(chip->client, BHSFH_PS_TH_LED1,
+					tmp);
+}
+
+static inline u16 bhsfh_lux_raw_to_adjusted(struct bhsfh_chip *chip, u16 raw)
+{
+	u32 lux;
+	lux = ((u32)raw * chip->lux_corr) / BHSFH_LUX_CORR_SCALE;
+	return min(lux, (u32)BHSFH_LUX_RANGE);
+}
+
+static inline u16 bhsfh_lux_adjusted_to_raw(struct bhsfh_chip *chip,
+					u16 adjusted)
+{
+	return (u32)adjusted * BHSFH_LUX_CORR_SCALE / chip->lux_corr;
+}
+
+/* chip->mutex is kept when this is called */
+static int bhsfh_lux_update_thresholds(struct bhsfh_chip *chip,
+					u16 threshold_hi, u16 threshold_lo)
+{
+	u8 data[4];
+	int ret;
+
+	/* sysfs may call this when the chip is powered off */
+	if (pm_runtime_suspended(&chip->client->dev))
+		return 0;
+
+	/*
+	 * Compensate threshold values with the correction factors if not
+	 * set to minimum or maximum.
+	 * Min & max values disables interrupts.
+	 */
+	if (threshold_hi != BHSFH_LUX_RANGE && threshold_hi != 0)
+		threshold_hi = bhsfh_lux_adjusted_to_raw(chip, threshold_hi);
+
+	if (threshold_lo != BHSFH_LUX_RANGE && threshold_lo != 0)
+		threshold_lo = bhsfh_lux_adjusted_to_raw(chip, threshold_lo);
+
+	if (chip->lux_thres_hi_onchip == threshold_hi &&
+	    chip->lux_thres_lo_onchip == threshold_lo)
+		return 0;
+
+	chip->lux_thres_hi_onchip = threshold_hi;
+	chip->lux_thres_lo_onchip = threshold_lo;
+
+	data[0] = threshold_hi;
+	data[1] = threshold_hi >> 8;
+	data[2] = threshold_lo;
+	data[3] = threshold_lo >> 8;
+
+	ret = i2c_smbus_write_i2c_block_data(chip->client,
+					BHSFH_ALS_TH_UP_0,
+					ARRAY_SIZE(data),
+					data);
+	return ret;
+}
+
+static int bhsfh_lux_get_result(struct bhsfh_chip *chip)
+{
+	u16 data;
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(chip->client, BHSFH_ALS_DATA_0);
+	if (ret < 0)
+		return ret;
+
+	data = ret & 0xff;
+	ret = i2c_smbus_read_byte_data(chip->client, BHSFH_ALS_DATA_1);
+	if (ret < 0)
+		return ret;
+
+	chip->lux_data_raw = data | ((ret & 0xff) << 8);
+
+	return 0;
+}
+
+/* Calculate correction value which contains chip and device specific parts */
+static u32 bhsfh_get_corr_value(struct bhsfh_chip *chip)
+{
+	u32 tmp;
+	/* Impact of glass attenuation correction */
+	tmp = (BHSFH_LUX_CORR_SCALE * chip->lux_ga) / BHSFH_LUX_GA_SCALE;
+	/* Impact of chip factor correction */
+	tmp = (tmp * chip->lux_cf) / BHSFH_LUX_CF_SCALE;
+	/* Impact of Device specific calibration correction */
+	tmp = (tmp * chip->lux_calib) / BHSFH_CALIB_SCALER;
+	return tmp;
+}
+
+static int bhsfh_lux_read_result(struct bhsfh_chip *chip)
+{
+	bhsfh_lux_get_result(chip);
+	return bhsfh_lux_raw_to_adjusted(chip, chip->lux_data_raw);
+}
+
+/*
+ * Chip on / off functions are called while keeping mutex except probe
+ * or remove phase
+ */
+static int bhsfh_chip_on(struct bhsfh_chip *chip)
+{
+	int ret = regulator_bulk_enable(ARRAY_SIZE(chip->regs),
+					chip->regs);
+	if (ret < 0)
+		return ret;
+
+	usleep_range(BHSFH_STARTUP_DELAY, BHSFH_STARTUP_DELAY * 2);
+
+	/* Reset the chip */
+	i2c_smbus_write_byte_data(chip->client, BHSFH_ALS_CONTROL,
+				BHSFH_SWRESET);
+	usleep_range(BHSFH_RESET_TIME, BHSFH_RESET_TIME * 2);
+
+	/*
+	 * ALS is started always since proximity needs als results
+	 * for realibility estimation.
+	 * Let's assume dark until the first ALS measurement is ready.
+	 */
+	chip->lux_data_raw = 0;
+	ret = i2c_smbus_write_byte_data(chip->client,
+					BHSFH_ALS_CONTROL, BHSFH_STANDALONE);
+
+	/* Assume reset defaults */
+	chip->lux_thres_hi_onchip = BHSFH_LUX_RANGE;
+	chip->lux_thres_lo_onchip = 0;
+
+	return ret;
+}
+
+static void bhsfh_chip_off(struct bhsfh_chip *chip)
+{
+	i2c_smbus_write_byte_data(chip->client,
+					BHSFH_INTERRUPT, BHSFH_DISABLE);
+	i2c_smbus_write_byte_data(chip->client,
+				BHSFH_ALS_CONTROL, BHSFH_STANDBY);
+	i2c_smbus_write_byte_data(chip->client,
+				BHSFH_PS_CONTROL, BHSFH_STANDBY);
+	regulator_bulk_disable(ARRAY_SIZE(chip->regs), chip->regs);
+}
+
+/* chip->mutex is kept when this is called */
+static int bhsfh_prox_mode_control(struct bhsfh_chip *chip)
+{
+	if (chip->prox_enable_count) {
+		chip->prox_force_update = true; /* Force immediate update */
+
+		bhsfh_lux_rate(chip, chip->lux_rate_index);
+		bhsfh_prox_set_threshold(chip);
+		bhsfh_led_cfg(chip);
+		bhsfh_prox_rate(chip, PROX_BELOW_THRESHOLD);
+		bhsfh_prox_interrupt_control(chip, BHSFH_ENABLE);
+		i2c_smbus_write_byte_data(chip->client,
+					BHSFH_PS_CONTROL, BHSFH_STANDALONE);
+	} else {
+		chip->prox_data = 0;
+		bhsfh_lux_rate(chip, chip->lux_rate_index);
+		bhsfh_prox_interrupt_control(chip, BHSFH_DISABLE);
+		i2c_smbus_write_byte_data(chip->client,
+					BHSFH_PS_CONTROL, BHSFH_STANDBY);
+	}
+	return 0;
+}
+
+static void bhsfh_prox_rate_above(struct bhsfh_chip *chip, int rate)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(prox_rates_hz); i++)
+		if (rate >= prox_rates_hz[i])
+			break;
+
+	if (i > BHSFH_PS_MAX_RATE)
+		i = BHSFH_PS_MAX_RATE;
+
+	chip->prox_rate_threshold = i;
+}
+
+static void bhsfh_prox_rate_below(struct bhsfh_chip *chip, int rate)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(prox_rates_hz); i++)
+		if (rate >= prox_rates_hz[i])
+			break;
+
+	if (i > BHSFH_PS_MAX_RATE)
+		i = BHSFH_PS_MAX_RATE;
+
+	chip->prox_rate = i;
+}
+
+/* chip->mutex is kept when this is called */
+static int bhsfh_prox_read_result(struct bhsfh_chip *chip)
+{
+	int ret;
+	bool above;
+	u8 mode;
+
+	ret = i2c_smbus_read_byte_data(chip->client, BHSFH_PS_DATA_LED1);
+	if (ret < 0)
+		goto out;
+
+	if (ret > chip->prox_threshold_hw)
+		above = true;
+	else
+		above = false;
+
+	/*
+	 * when ALS levels goes above limit, proximity result may be
+	 * false proximity. Thus ignore the result. With real proximity
+	 * there is a shadow causing low als levels.
+	 */
+	if (chip->lux_data_raw > PROX_IGNORE_LUX_LIMIT)
+		ret = 0;
+
+	chip->prox_data = bhsfh_psraw_to_adjusted(chip, ret);
+
+	/* Strong proximity level or force mode requires immediate response */
+	if (chip->prox_data >= chip->prox_abs_thres ||
+	    chip->prox_force_update)
+		chip->prox_persistence_counter = chip->prox_persistence;
+
+	chip->prox_force_update = false;
+
+	/* Persistence filttering to reduce false proximity events */
+	if (likely(above)) {
+		if (chip->prox_persistence_counter < chip->prox_persistence) {
+			chip->prox_persistence_counter++;
+			ret = -ENODATA;
+		} else {
+			mode = PROX_ABOVE_THRESHOLD;
+			ret = 0;
+		}
+	} else {
+		chip->prox_persistence_counter = 0;
+		mode = PROX_BELOW_THRESHOLD;
+		chip->prox_data = 0;
+		ret = 0;
+	}
+
+	/* Set proximity detection rate based on above or below value */
+	if (ret == 0) {
+		bhsfh_prox_rate(chip, mode);
+		sysfs_notify(&chip->client->dev.kobj, NULL, "prox0_raw");
+	}
+out:
+	return ret;
+}
+
+static int bhsfh_detect(struct bhsfh_chip *chip)
+{
+	struct i2c_client *client = chip->client;
+	s32 ret;
+	u8 manu, part;
+
+	ret = i2c_smbus_read_byte_data(client, BHSFH_MANUFACT_ID);
+	if (ret < 0)
+		goto error;
+	manu = (u8)ret;
+
+	ret = i2c_smbus_read_byte_data(client, BHSFH_PART_ID);
+	if (ret < 0)
+		goto error;
+	part = (u8)ret;
+
+	chip->revision = (part & BHSFH_REV_MASK) >> BHSFH_REV_SHIFT;
+	chip->prox_coef = BHSFH_COEF_SCALER;
+	chip->prox_const = 0;
+	chip->lux_cf = BHSFH_NEUTRAL_CF;
+
+	if ((manu == BHSFH_MANUFACT_ROHM) &&
+	    ((part & BHSFH_PART_MASK) == BHSFH_PART)) {
+		snprintf(chip->chipname, sizeof(chip->chipname), "BH1770GLC");
+		return 0;
+	}
+
+	if ((manu == BHSFH_MANUFACT_OSRAM) &&
+	    ((part & BHSFH_PART_MASK) == BHSFH_PART)) {
+		snprintf(chip->chipname, sizeof(chip->chipname), "SFH7770");
+		/* Values selected by comparing different versions */
+		chip->prox_coef = 819; /* 0.8 * BHSFH_COEF_SCALER */
+		chip->prox_const = 40;
+		return 0;
+	}
+
+	ret = -ENODEV;
+error:
+	dev_dbg(&client->dev, "BHSFH or SFH7770 not found\n");
+
+	return ret;
+}
+
+/*
+ * This work is re-scheduled at every proximity interrupt.
+ * If this work is running, it means that there hasn't been any
+ * proximity interrupt in time. Situation is handled as no-proximity.
+ * It would be nice to have low-threshold interrupt or interrupt
+ * when measurement and hi-threshold are both 0. But neither of those exists.
+ * This is a workaroud for missing HW feature.
+ */
+
+static void bhsfh_prox_work(struct work_struct *work)
+{
+	struct bhsfh_chip *chip =
+		container_of(work, struct bhsfh_chip, prox_work.work);
+
+	mutex_lock(&chip->mutex);
+	bhsfh_prox_read_result(chip);
+	mutex_unlock(&chip->mutex);
+}
+
+/* This is threaded irq handler */
+static irqreturn_t bhsfh_irq(int irq, void *data)
+{
+	struct bhsfh_chip *chip = data;
+	int status;
+	int rate = 0;
+
+	mutex_lock(&chip->mutex);
+	status = i2c_smbus_read_byte_data(chip->client, BHSFH_ALS_PS_STATUS);
+
+	/* Acknowledge interrupt by reading this register */
+	i2c_smbus_read_byte_data(chip->client, BHSFH_INTERRUPT);
+
+	/*
+	 * Check if there is fresh data available for als.
+	 * If this is the very first data, update thresholds after that.
+	 */
+	if (status & BHSFH_INT_ALS_DATA) {
+		bhsfh_lux_get_result(chip);
+		if (unlikely(chip->lux_wait_result)) {
+			chip->lux_wait_result = false;
+			wake_up(&chip->wait);
+			bhsfh_lux_update_thresholds(chip,
+						chip->lux_threshold_hi,
+						chip->lux_threshold_lo);
+		}
+	}
+
+	/* Disable interrupt logic to guarantee acknowledgement */
+	i2c_smbus_write_byte_data(chip->client, BHSFH_INTERRUPT,
+				  (0 << 1) | (0 << 0));
+
+	if ((status & BHSFH_INT_ALS_INT))
+		sysfs_notify(&chip->client->dev.kobj, NULL, "lux0_input");
+
+	if (chip->int_mode_prox)
+		if (status & BHSFH_INT_LEDS_INT) {
+			rate = prox_rates_ms[chip->prox_rate_threshold];
+			bhsfh_prox_read_result(chip);
+		}
+
+	/* Re-enable interrupt logic */
+	i2c_smbus_write_byte_data(chip->client, BHSFH_INTERRUPT,
+				  (chip->int_mode_lux << 1) |
+				  (chip->int_mode_prox << 0));
+	mutex_unlock(&chip->mutex);
+
+	/*
+	 * Can't cancel work while keeping mutex since the work uses the
+	 * same mutex.
+	 */
+	if (rate) {
+		/*
+		 * Simulate missing no-proximity interrupt 50ms after the
+		 * next expected interrupt time.
+		 */
+		cancel_delayed_work_sync(&chip->prox_work);
+		schedule_delayed_work(&chip->prox_work,
+				msecs_to_jiffies(rate + 50));
+	}
+	return IRQ_HANDLED;
+}
+
+static ssize_t bhsfh_power_state_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	unsigned long value;
+	size_t ret;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	mutex_lock(&chip->mutex);
+	if (value) {
+		pm_runtime_get_sync(dev);
+
+		ret = bhsfh_lux_rate(chip, chip->lux_rate_index);
+		ret |= bhsfh_lux_interrupt_control(chip, BHSFH_ENABLE);
+
+		if (ret < 0) {
+			pm_runtime_put(dev);
+			goto leave;
+		}
+
+		/* This causes interrupt after the next measurement cycle */
+		bhsfh_lux_update_thresholds(chip, BHSFH_LUX_DEF_THRES,
+					BHSFH_LUX_DEF_THRES);
+		/* Inform that we are waiting for a result from ALS */
+		chip->lux_wait_result = true;
+	} else {
+		if (!pm_runtime_suspended(dev))
+			pm_runtime_put(dev);
+	}
+	bhsfh_prox_mode_control(chip);
+	ret = count;
+leave:
+	mutex_unlock(&chip->mutex);
+	return ret;
+}
+
+static ssize_t bhsfh_power_state_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", !pm_runtime_suspended(dev));
+}
+
+static ssize_t bhsfh_lux_result_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	ssize_t ret;
+	long timeout;
+
+	if (pm_runtime_suspended(dev))
+		return -EIO; /* Chip is not enabled at all */
+
+	timeout = wait_event_interruptible_timeout(chip->wait,
+					!chip->lux_wait_result,
+					msecs_to_jiffies(BHSFH_TIMEOUT));
+	if (!timeout)
+		return -EIO;
+
+	mutex_lock(&chip->mutex);
+	ret = sprintf(buf, "%d\n", bhsfh_lux_read_result(chip));
+	mutex_unlock(&chip->mutex);
+
+	return ret;
+}
+
+static ssize_t bhsfh_lux_range_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", BHSFH_LUX_RANGE);
+}
+
+static ssize_t bhsfh_prox_enable_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	mutex_lock(&chip->mutex);
+	if (value) {
+		/* Assume no proximity. Sensor will tell real state soon */
+		if (!chip->prox_enable_count)
+			chip->prox_data = 0;
+		chip->prox_enable_count++;
+	} else if (chip->prox_enable_count > 0) {
+		chip->prox_enable_count--;
+	} else {
+		goto leave;
+	}
+	/* Run control only when chip is power on */
+	if (!pm_runtime_suspended(dev))
+		bhsfh_prox_mode_control(chip);
+leave:
+	mutex_unlock(&chip->mutex);
+	return count;
+}
+
+static ssize_t bhsfh_prox_enable_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	ssize_t len;
+
+	mutex_lock(&chip->mutex);
+	len = sprintf(buf, "%d\n", chip->prox_enable_count);
+	mutex_unlock(&chip->mutex);
+	return len;
+}
+
+static ssize_t bhsfh_prox_result_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	ssize_t ret;
+
+	mutex_lock(&chip->mutex);
+	if (chip->prox_enable_count && !pm_runtime_suspended(dev))
+		ret = sprintf(buf, "%d\n", chip->prox_data);
+	else
+		ret = -EIO;
+	mutex_unlock(&chip->mutex);
+	return ret;
+}
+
+static ssize_t bhsfh_prox_range_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", BHSFH_PROX_RANGE);
+}
+
+static ssize_t bhsfh_get_prox_rate_avail(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	int i;
+	int pos = 0;
+	for (i = 0; i < ARRAY_SIZE(prox_rates_hz); i++)
+		pos += sprintf(buf + pos, "%d ", prox_rates_hz[i]);
+	sprintf(buf + pos - 1, "\n");
+	return pos;
+}
+
+static ssize_t bhsfh_get_prox_rate_above(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", prox_rates_hz[chip->prox_rate_threshold]);
+}
+
+static ssize_t bhsfh_get_prox_rate_below(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", prox_rates_hz[chip->prox_rate]);
+}
+
+static ssize_t bhsfh_set_prox_rate_above(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	mutex_lock(&chip->mutex);
+	bhsfh_prox_rate_above(chip, value);
+	mutex_unlock(&chip->mutex);
+	return count;
+}
+
+static ssize_t bhsfh_set_prox_rate_below(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	mutex_lock(&chip->mutex);
+	bhsfh_prox_rate_below(chip, value);
+	mutex_unlock(&chip->mutex);
+	return count;
+}
+
+static ssize_t bhsfh_get_prox_thres(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", chip->prox_threshold);
+}
+
+static ssize_t bhsfh_set_prox_thres(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	unsigned long value;
+	int ret;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+	if (value > BHSFH_PROX_RANGE)
+		return -EINVAL;
+
+	mutex_lock(&chip->mutex);
+	chip->prox_threshold = value;
+	ret = bhsfh_prox_set_threshold(chip);
+	mutex_unlock(&chip->mutex);
+	if (ret < 0)
+		return ret;
+	return count;
+}
+
+static ssize_t bhsfh_prox_persistence_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct bhsfh_chip *chip = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", chip->prox_persistence);
+}
+
+static ssize_t bhsfh_prox_persistence_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t len)
+{
+	struct bhsfh_chip *chip = dev_get_drvdata(dev);
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if (value > BHSFH_PROX_MAX_PERSISTENCE)
+		return -EINVAL;
+
+	chip->prox_persistence = value;
+
+	return len;
+}
+
+static ssize_t bhsfh_prox_abs_thres_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct bhsfh_chip *chip = dev_get_drvdata(dev);
+	return snprintf(buf, PAGE_SIZE, "%u\n", chip->prox_abs_thres);
+}
+
+static ssize_t bhsfh_prox_abs_thres_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t len)
+{
+	struct bhsfh_chip *chip = dev_get_drvdata(dev);
+	unsigned long value;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if (value > BHSFH_PROX_RANGE)
+		return -EINVAL;
+
+	chip->prox_abs_thres = value;
+
+	return len;
+}
+
+static ssize_t bhsfh_chip_id_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	return sprintf(buf, "%s rev %d\n", chip->chipname, chip->revision);
+}
+
+static ssize_t bhsfh_lux_calib_default_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%u\n", BHSFH_CALIB_SCALER);
+}
+
+static ssize_t bhsfh_lux_calib_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct bhsfh_chip *chip = dev_get_drvdata(dev);
+	ssize_t len;
+
+	mutex_lock(&chip->mutex);
+	len = snprintf(buf, PAGE_SIZE, "%u\n", chip->lux_calib);
+	mutex_unlock(&chip->mutex);
+	return len;
+}
+
+static ssize_t bhsfh_lux_calib_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t len)
+{
+	struct bhsfh_chip *chip = dev_get_drvdata(dev);
+	unsigned long value;
+	u32 old_calib;
+	u32 new_corr;
+
+	if (strict_strtoul(buf, 0, &value))
+		return -EINVAL;
+
+	mutex_lock(&chip->mutex);
+	old_calib = chip->lux_calib;
+	chip->lux_calib = value;
+	new_corr = bhsfh_get_corr_value(chip);
+	if (new_corr == 0) {
+		chip->lux_calib = old_calib;
+		mutex_unlock(&chip->mutex);
+		return -EINVAL;
+	}
+	chip->lux_corr = new_corr;
+	/* Refresh thresholds on HW after changing correction value */
+	bhsfh_lux_update_thresholds(chip, chip->lux_threshold_hi,
+				chip->lux_threshold_lo);
+
+	mutex_unlock(&chip->mutex);
+
+	return len;
+}
+
+static ssize_t bhsfh_get_lux_rate_avail(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	int i;
+	int pos = 0;
+	for (i = 0; i < ARRAY_SIZE(lux_rates_hz); i++)
+		pos += sprintf(buf + pos, "%d ", lux_rates_hz[i]);
+	sprintf(buf + pos - 1, "\n");
+	return pos;
+}
+
+static ssize_t bhsfh_get_lux_rate(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", lux_rates_hz[chip->lux_rate_index]);
+}
+
+static ssize_t bhsfh_set_lux_rate(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	unsigned long rate_hz;
+	int ret, i;
+
+	if (strict_strtoul(buf, 0, &rate_hz))
+		return -EINVAL;
+
+	mutex_lock(&chip->mutex);
+
+	for (i = 0; i < ARRAY_SIZE(lux_rates_hz); i++)
+		if (rate_hz >= lux_rates_hz[i])
+			break;
+
+	if (i > BHSFH_ALS_MAX_RATE)
+		i = BHSFH_ALS_MAX_RATE;
+
+	chip->lux_rate_index = i;
+	ret = bhsfh_lux_rate(chip, i);
+	mutex_unlock(&chip->mutex);
+
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static ssize_t bhsfh_get_lux_thresh_above(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", chip->lux_threshold_hi);
+}
+
+static ssize_t bhsfh_get_lux_thresh_below(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", chip->lux_threshold_lo);
+}
+
+static ssize_t bhsfh_set_lux_thresh(struct bhsfh_chip *chip, u16 *target,
+				const char *buf)
+{
+	int ret = 0;
+	unsigned long thresh;
+
+	if (strict_strtoul(buf, 0, &thresh))
+		return -EINVAL;
+
+	if (thresh > BHSFH_LUX_RANGE)
+		return -EINVAL;
+
+	mutex_lock(&chip->mutex);
+	*target = thresh;
+	/*
+	 * Don't update values in HW if we are still waiting for
+	 * first interrupt to come after device handle open call.
+	 */
+	if (!chip->lux_wait_result)
+		ret = bhsfh_lux_update_thresholds(chip,	chip->lux_threshold_hi,
+						chip->lux_threshold_lo);
+	mutex_unlock(&chip->mutex);
+	return ret;
+
+}
+
+static ssize_t bhsfh_set_lux_thresh_above(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t len)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	int ret = bhsfh_set_lux_thresh(chip, &chip->lux_threshold_hi, buf);
+	if (ret < 0)
+		return ret;
+	return len;
+}
+
+static ssize_t bhsfh_set_lux_thresh_below(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t len)
+{
+	struct bhsfh_chip *chip =  dev_get_drvdata(dev);
+	int ret = bhsfh_set_lux_thresh(chip, &chip->lux_threshold_lo, buf);
+	if (ret < 0)
+		return ret;
+	return len;
+}
+
+static DEVICE_ATTR(prox0_raw_en, S_IRUGO | S_IWUSR, bhsfh_prox_enable_show,
+						bhsfh_prox_enable_store);
+static DEVICE_ATTR(prox0_thresh_above1_value, S_IRUGO | S_IWUSR,
+						bhsfh_prox_abs_thres_show,
+						bhsfh_prox_abs_thres_store);
+static DEVICE_ATTR(prox0_thresh_above0_value, S_IRUGO | S_IWUSR,
+						bhsfh_get_prox_thres,
+						bhsfh_set_prox_thres);
+static DEVICE_ATTR(prox0_raw, S_IRUGO, bhsfh_prox_result_show, NULL);
+static DEVICE_ATTR(prox0_sensor_range, S_IRUGO, bhsfh_prox_range_show, NULL);
+static DEVICE_ATTR(prox0_thresh_above_count, S_IRUGO | S_IWUSR,
+						bhsfh_prox_persistence_show,
+						bhsfh_prox_persistence_store);
+static DEVICE_ATTR(prox0_rate_above, S_IRUGO | S_IWUSR,
+						bhsfh_get_prox_rate_above,
+						bhsfh_set_prox_rate_above);
+static DEVICE_ATTR(prox0_rate_below, S_IRUGO | S_IWUSR,
+						bhsfh_get_prox_rate_below,
+						bhsfh_set_prox_rate_below);
+static DEVICE_ATTR(prox0_rate_avail, S_IRUGO, bhsfh_get_prox_rate_avail, NULL);
+
+static DEVICE_ATTR(lux0_calibscale, S_IRUGO | S_IWUSR, bhsfh_lux_calib_show,
+						bhsfh_lux_calib_store);
+static DEVICE_ATTR(lux0_calibscale_default, S_IRUGO,
+						bhsfh_lux_calib_default_show,
+						NULL);
+static DEVICE_ATTR(lux0_input, S_IRUGO, bhsfh_lux_result_show, NULL);
+static DEVICE_ATTR(lux0_sensor_range, S_IRUGO, bhsfh_lux_range_show, NULL);
+static DEVICE_ATTR(lux0_rate, S_IRUGO | S_IWUSR, bhsfh_get_lux_rate,
+						bhsfh_set_lux_rate);
+static DEVICE_ATTR(lux0_rate_avail, S_IRUGO, bhsfh_get_lux_rate_avail, NULL);
+static DEVICE_ATTR(lux0_thresh_above_value, S_IRUGO | S_IWUSR,
+						bhsfh_get_lux_thresh_above,
+						bhsfh_set_lux_thresh_above);
+static DEVICE_ATTR(lux0_thresh_below_value, S_IRUGO | S_IWUSR,
+						bhsfh_get_lux_thresh_below,
+						bhsfh_set_lux_thresh_below);
+static DEVICE_ATTR(chip_id, S_IRUGO, bhsfh_chip_id_show, NULL);
+static DEVICE_ATTR(power_state, S_IRUGO | S_IWUSR, bhsfh_power_state_show,
+						 bhsfh_power_state_store);
+
+
+static struct attribute *sysfs_attrs[] = {
+	&dev_attr_lux0_calibscale.attr,
+	&dev_attr_lux0_calibscale_default.attr,
+	&dev_attr_lux0_input.attr,
+	&dev_attr_lux0_sensor_range.attr,
+	&dev_attr_lux0_rate.attr,
+	&dev_attr_lux0_rate_avail.attr,
+	&dev_attr_lux0_thresh_above_value.attr,
+	&dev_attr_lux0_thresh_below_value.attr,
+	&dev_attr_prox0_raw.attr,
+	&dev_attr_prox0_sensor_range.attr,
+	&dev_attr_prox0_raw_en.attr,
+	&dev_attr_prox0_thresh_above_count.attr,
+	&dev_attr_prox0_rate_above.attr,
+	&dev_attr_prox0_rate_below.attr,
+	&dev_attr_prox0_rate_avail.attr,
+	&dev_attr_prox0_thresh_above0_value.attr,
+	&dev_attr_prox0_thresh_above1_value.attr,
+	&dev_attr_chip_id.attr,
+	&dev_attr_power_state.attr,
+	NULL
+};
+
+static struct attribute_group bhsfh_attribute_group = {
+	.attrs = sysfs_attrs
+};
+
+static int __devinit bhsfh_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct bhsfh_chip *chip;
+	int err;
+
+	chip = kzalloc(sizeof *chip, GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, chip);
+	chip->client  = client;
+
+	mutex_init(&chip->mutex);
+	init_waitqueue_head(&chip->wait);
+	INIT_DELAYED_WORK(&chip->prox_work, bhsfh_prox_work);
+
+	if (client->dev.platform_data == NULL) {
+		dev_err(&client->dev, "platform data is mandatory\n");
+		err = -EINVAL;
+		goto fail1;
+	}
+
+	chip->pdata		= client->dev.platform_data;
+	chip->lux_calib		= BHSFH_LUX_NEUTRAL_CALIB_VALUE;
+	chip->lux_rate_index	= BHSFH_LUX_DEFAULT_RATE;
+	chip->lux_threshold_lo	= BHSFH_LUX_DEF_THRES;
+	chip->lux_threshold_hi	= BHSFH_LUX_DEF_THRES;
+
+	if (chip->pdata->glass_attenuation == 0)
+		chip->lux_ga = BHFSH_NEUTRAL_GA;
+	else
+		chip->lux_ga = chip->pdata->glass_attenuation;
+
+	chip->prox_threshold	= BHSFH_PROX_DEF_THRES;
+	chip->prox_led		= chip->pdata->led_def_curr;
+	chip->prox_abs_thres	= BHSFH_PROX_DEF_ABS_THRES;
+	chip->prox_persistence	= BHSFH_DEFAULT_PERSISTENCE;
+	chip->prox_data		= 0;
+
+
+	bhsfh_prox_rate_below(chip, BHSFH_PROX_DEFAULT_RATE);
+	bhsfh_prox_rate_above(chip, BHSFH_PROX_DEF_RATE_THRESH);
+
+	chip->regs[0].supply = reg_vcc;
+	chip->regs[1].supply = reg_vleds;
+
+	err = regulator_bulk_get(&client->dev,
+				 ARRAY_SIZE(chip->regs), chip->regs);
+	if (err < 0) {
+		dev_err(&client->dev, "Cannot get regulators\n");
+		goto fail1;
+	}
+
+	err = regulator_bulk_enable(ARRAY_SIZE(chip->regs),
+				chip->regs);
+	if (err < 0) {
+		dev_err(&client->dev, "Cannot enable regulators\n");
+		goto fail2;
+	}
+
+	usleep_range(BHSFH_STARTUP_DELAY, BHSFH_STARTUP_DELAY * 2);
+	err = bhsfh_detect(chip);
+	if (err < 0)
+		goto fail3;
+
+	/* Start chip */
+	bhsfh_chip_on(chip);
+	pm_runtime_set_active(&client->dev);
+	pm_runtime_enable(&client->dev);
+
+	chip->lux_corr = bhsfh_get_corr_value(chip);
+	if (chip->lux_corr == 0) {
+		dev_err(&client->dev, "Improper correction values\n");
+		err = -EINVAL;
+		goto fail3;
+	}
+
+	if (chip->pdata->setup_resources) {
+		err = chip->pdata->setup_resources();
+		if (err) {
+			err = -EINVAL;
+			goto fail3;
+		}
+	}
+
+	err = sysfs_create_group(&chip->client->dev.kobj,
+				&bhsfh_attribute_group);
+	if (err < 0) {
+		dev_err(&chip->client->dev, "Sysfs registration failed\n");
+		goto fail4;
+	}
+
+	/*
+	 * Chip needs level triggered interrupt to work. However,
+	 * level triggering doesn't work always correctly with power
+	 * management. Select both
+	 */
+	err = request_threaded_irq(client->irq, NULL,
+				bhsfh_irq,
+				IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
+				IRQF_TRIGGER_LOW,
+				"bhsfh", chip);
+	if (err) {
+		dev_err(&client->dev, "could not get IRQ %d\n",
+			client->irq);
+		goto fail5;
+	}
+	regulator_bulk_disable(ARRAY_SIZE(chip->regs), chip->regs);
+	return err;
+fail5:
+	sysfs_remove_group(&chip->client->dev.kobj,
+			&bhsfh_attribute_group);
+fail4:
+	if (chip->pdata->release_resources)
+		chip->pdata->release_resources();
+fail3:
+	regulator_bulk_disable(ARRAY_SIZE(chip->regs), chip->regs);
+fail2:
+	regulator_bulk_free(ARRAY_SIZE(chip->regs), chip->regs);
+fail1:
+	kfree(chip);
+	return err;
+}
+
+static int __devexit bhsfh_remove(struct i2c_client *client)
+{
+	struct bhsfh_chip *chip = i2c_get_clientdata(client);
+
+	free_irq(client->irq, chip);
+
+	sysfs_remove_group(&chip->client->dev.kobj,
+			&bhsfh_attribute_group);
+
+	if (chip->pdata->release_resources)
+		chip->pdata->release_resources();
+
+	cancel_delayed_work_sync(&chip->prox_work);
+
+	if (!pm_runtime_suspended(&client->dev))
+		bhsfh_chip_off(chip);
+
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
+
+	regulator_bulk_free(ARRAY_SIZE(chip->regs), chip->regs);
+	kfree(chip);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int bhsfh_suspend(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct bhsfh_chip *chip = i2c_get_clientdata(client);
+
+	bhsfh_chip_off(chip);
+
+	return 0;
+}
+
+static int bhsfh_resume(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct bhsfh_chip *chip = i2c_get_clientdata(client);
+	int ret = 0;
+
+	bhsfh_chip_on(chip);
+
+	if (!pm_runtime_suspended(dev)) {
+		/*
+		 * If we were enabled at suspend time, it is expected
+		 * everything works nice and smoothly
+		 */
+		ret = bhsfh_lux_rate(chip, chip->lux_rate_index);
+		ret |= bhsfh_lux_interrupt_control(chip, BHSFH_ENABLE);
+
+		/* This causes interrupt after the next measurement cycle */
+		bhsfh_lux_update_thresholds(chip, BHSFH_LUX_DEF_THRES,
+					BHSFH_LUX_DEF_THRES);
+		/* Inform that we are waiting for a result from ALS */
+		chip->lux_wait_result = true;
+		bhsfh_prox_mode_control(chip);
+	}
+	return ret;
+}
+
+#else
+#define bhsfh_suspend  NULL
+#define bhsfh_shutdown NULL
+#define bhsfh_resume   NULL
+#endif
+
+#ifdef CONFIG_PM_RUNTIME
+static int bhsfh_runtime_suspend(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct bhsfh_chip *chip = i2c_get_clientdata(client);
+
+	bhsfh_chip_off(chip);
+
+	return 0;
+}
+
+static int bhsfh_runtime_resume(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct bhsfh_chip *chip = i2c_get_clientdata(client);
+
+	bhsfh_chip_on(chip);
+
+	return 0;
+}
+#endif
+
+static const struct i2c_device_id bhsfh_id[] = {
+	{"bh1770glc", 0 },
+	{"sfh7770", 0 },
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, bhsfh_id);
+
+static const struct dev_pm_ops bhsfh_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(bhsfh_suspend, bhsfh_resume)
+	SET_RUNTIME_PM_OPS(bhsfh_runtime_suspend, bhsfh_runtime_resume, NULL)
+};
+
+static struct i2c_driver bhsfh_driver = {
+	.driver	 = {
+		.name	= "bhsfh",
+		.owner	= THIS_MODULE,
+		.pm	= &bhsfh_pm_ops,
+	},
+	.probe	  = bhsfh_probe,
+	.remove	  = __devexit_p(bhsfh_remove),
+	.id_table = bhsfh_id,
+};
+
+static int __init bhsfh_init(void)
+{
+	return i2c_add_driver(&bhsfh_driver);
+}
+
+static void __exit bhsfh_exit(void)
+{
+	i2c_del_driver(&bhsfh_driver);
+}
+
+MODULE_DESCRIPTION("BH1770GLC / SFH7770 combined ALS and proximity sensor");
+MODULE_AUTHOR("Samu Onkalo, Nokia Corporation");
+MODULE_LICENSE("GPL v2");
+
+module_init(bhsfh_init);
+module_exit(bhsfh_exit);
diff --git a/include/linux/i2c/bhsfh.h b/include/linux/i2c/bhsfh.h
new file mode 100644
index 0000000..a19e791
--- /dev/null
+++ b/include/linux/i2c/bhsfh.h
@@ -0,0 +1,42 @@
+/*
+ * This file is part of the ROHM BH1770GLC / OSRAM SFH7770 sensor driver.
+ * Chip is combined proximity and ambient light sensor.
+ *
+ * Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
+ *
+ * Contact: Samu Onkalo <samu.p.onkalo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __BHSFH_H__
+#define __BHSFH_H__
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
+#endif
-- 
1.6.0.4

