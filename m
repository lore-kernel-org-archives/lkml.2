Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab2JFBzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 21:55:37 -0400
Received: from 173-160-178-141-Washington.hfc.comcastbusiness.net ([173.160.178.141]:46004
	"EHLO relay" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751608Ab2JFBzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 21:55:04 -0400
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
To: andrey.smrinov@convergeddevices.net
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] Add chip properties handling code for SI476X MFD
Date: Fri,  5 Oct 2012 18:55:00 -0700
Message-Id: <1349488502-11293-5-git-send-email-andrey.smirnov@convergeddevices.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349488502-11293-1-git-send-email-andrey.smirnov@convergeddevices.net>
References: <1349488502-11293-1-git-send-email-andrey.smirnov@convergeddevices.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code related to manipulation of the properties of
SI476X chips.

Signed-off-by: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
---
 drivers/mfd/si476x-prop.c |  477 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 477 insertions(+)
 create mode 100644 drivers/mfd/si476x-prop.c

diff --git a/drivers/mfd/si476x-prop.c b/drivers/mfd/si476x-prop.c
new file mode 100644
index 0000000..d633c08
--- /dev/null
+++ b/drivers/mfd/si476x-prop.c
@@ -0,0 +1,477 @@
+/*
+ * include/media/si476x-prop.c -- Subroutines to manipulate with
+ * properties of si476x chips
+ *
+ * Copyright (C) 2012 Innovative Converged Devices(ICD)
+ *
+ * Author: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <linux/module.h>
+
+#include <media/si476x.h>
+#include <linux/mfd/si476x-core.h>
+
+
+enum si476x_common_receiver_properties {
+	SI476X_PROP_INT_CTL_ENABLE			= 0x0000,
+	SI476X_PROP_DIGITAL_IO_INPUT_SAMPLE_RATE	= 0x0200,
+	SI476X_PROP_DIGITAL_IO_INPUT_FORMAT		= 0x0201,
+	SI476X_PROP_DIGITAL_IO_OUTPUT_SAMPLE_RATE	= 0x0202,
+	SI476X_PROP_DIGITAL_IO_OUTPUT_FORMAT		= 0x0203,
+
+	SI476X_PROP_AUDIO_ANALOG_VOLUME			= 0x0300,
+	SI476X_PROP_AUDIO_MUTE				= 0x0301,
+
+	SI476X_PROP_ZIF_OUTPUT_CFG			= 0x0600,
+
+	SI476X_PROP_SEEK_BAND_BOTTOM			= 0x1100,
+	SI476X_PROP_SEEK_BAND_TOP			= 0x1101,
+	SI476X_PROP_SEEK_FREQUENCY_SPACING		= 0x1102,
+
+	SI476X_PROP_VALID_MAX_TUNE_ERROR		= 0x2000,
+	SI476X_PROP_VALID_SNR_THRESHOLD			= 0x2003,
+
+	SI476X_PROP_VALID_RSSI_THRESHOLD		= 0x2004,
+};
+
+enum si476x_am_receiver_properties {
+	SI476X_PROP_AUDIO_PWR_LINE_FILTER		= 0x0303,
+};
+
+enum si476x_fm_receiver_properties {
+	SI476X_PROP_AUDIO_DEEMPHASIS				= 0x0302,
+
+	SI476X_PROP_FM_VALID_RSSI_TIME				= 0x2001,
+	SI476X_PROP_FM_VALID_SNR_TIME				= 0x2002,
+	SI476X_PROP_FM_VALID_AF_TIME				= 0x2007,
+
+	SI476X_PROP_FM_RDS_INTERRUPT_SOURCE			= 0x4000,
+	SI476X_PROP_FM_RDS_INTERRUPT_FIFO_COUNT			= 0x4001,
+	SI476X_PROP_FM_RDS_CONFIG				= 0x4002,
+};
+
+struct si476x_property_range {
+	u16 low, high;
+};
+
+static bool __element_is_in_array(u16 element, const u16 array[], size_t size)
+{
+	int i;
+
+	for (i = 0; i < size; i++)
+		if (element == array[i])
+			return true;
+
+	return false;
+}
+
+static bool __element_is_in_range(u16 element,
+				  const struct si476x_property_range range[],
+				  size_t size)
+{
+	int i;
+
+	for (i = 0; i < size; i++)
+		if (element <= range[i].high && element >= range[i].low)
+			return true;
+
+	return false;
+}
+
+static bool si476x_core_is_valid_property_a10(struct si476x_core *core,
+					      u16 property)
+{
+	static const u16 valid_properties[] = {
+		0x0000,
+		0x0500, 0x0501,
+		0x0600,
+		0x0709, 0x070C, 0x070D, 0x70E, 0x710,
+		0x718,		/* FIXME: Magic property */
+		0x1207, 0x1208,
+		0x2007,
+		0x2300,
+	};
+
+	static const struct si476x_property_range valid_ranges[] = {
+		{ 0x0200, 0x0203 },
+		{ 0x0300, 0x0303 },
+		{ 0x0400, 0x0404 },
+		{ 0x0700, 0x0707 },
+		{ 0x1100, 0x1102 },
+		{ 0x1200, 0x1204 },
+		{ 0x1300, 0x1306 },
+		{ 0x2000, 0x2005 },
+		{ 0x2100, 0x2104 },
+		{ 0x2106, 0x2106 },
+		{ 0x2200, 0x220E },
+		{ 0x3100, 0x3104 },
+		{ 0x3207, 0x320F },
+		{ 0x3300, 0x3304 },
+		{ 0x3500, 0x3517 },
+		{ 0x3600, 0x3617 },
+		{ 0x3700, 0x3717 },
+		{ 0x4000, 0x4003 },
+	};
+
+	return	__element_is_in_range(property, valid_ranges,
+				     ARRAY_SIZE(valid_ranges)) ||
+		__element_is_in_array(property, valid_properties,
+				      ARRAY_SIZE(valid_properties));
+}
+
+static bool si476x_core_is_valid_property_a20(struct si476x_core *core,
+					      u16 property)
+{
+	static const u16 valid_properties[] = {
+		0x071B,
+		0x1006,
+		0x2210,
+		0x3401,
+	};
+
+	static const struct si476x_property_range valid_ranges[] = {
+		{ 0x2215, 0x2219 },
+	};
+
+	return	si476x_core_is_valid_property_a10(core, property) ||
+		__element_is_in_range(property, valid_ranges,
+				      ARRAY_SIZE(valid_ranges))  ||
+		__element_is_in_array(property, valid_properties,
+				      ARRAY_SIZE(valid_properties));
+}
+
+static bool si476x_core_is_valid_property_a30(struct si476x_core *core,
+					      u16 property)
+{
+	static const u16 valid_properties[] = {
+		0x071C, 0x071D,
+		0x1007, 0x1008,
+		0x220F, 0x2214,
+		0x2301,
+		0x3105, 0x3106,
+		0x3402,
+	};
+
+	static const struct si476x_property_range valid_ranges[] = {
+		{ 0x0405, 0x0411 },
+		{ 0x2008, 0x200B },
+		{ 0x2220, 0x2223 },
+		{ 0x3100, 0x3106 },
+	};
+
+	return	si476x_core_is_valid_property_a20(core, property) ||
+		__element_is_in_range(property, valid_ranges,
+				      ARRAY_SIZE(valid_ranges)) ||
+		__element_is_in_array(property, valid_properties,
+				      ARRAY_SIZE(valid_properties));
+}
+
+typedef bool (*valid_property_pred_t) (struct si476x_core *, u16);
+
+bool si476x_core_is_valid_property(struct si476x_core *core, u16 property)
+{
+	static const valid_property_pred_t is_valid_property[] = {
+		[SI476X_REVISION_A10] = si476x_core_is_valid_property_a10,
+		[SI476X_REVISION_A20] = si476x_core_is_valid_property_a20,
+		[SI476X_REVISION_A30] = si476x_core_is_valid_property_a30,
+	};
+
+	BUG_ON(core->revision > SI476X_REVISION_A30 ||
+	       core->revision == -1);
+	return is_valid_property[core->revision](core, property);
+}
+EXPORT_SYMBOL_GPL(si476x_core_is_valid_property);
+
+bool si476x_core_is_readonly_property(struct si476x_core *core, u16 property)
+{
+	BUG_ON(core->revision > SI476X_REVISION_A30 ||
+	       core->revision == -1);
+
+	switch (core->revision) {
+	case SI476X_REVISION_A10:
+		return (property == 0x3200);
+	case SI476X_REVISION_A20:
+		return (property == 0x1006 ||
+			property == 0x2210 ||
+			property == 0x3200);
+	case SI476X_REVISION_A30:
+		return false;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(si476x_core_is_readonly_property);
+
+int si476x_core_set_int_ctl_enable(struct si476x_core *core,
+				   enum si476x_interrupt_flags flags)
+{
+	return si476x_core_cmd_set_property(core,
+					    SI476X_PROP_INT_CTL_ENABLE, flags);
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_int_ctl_enable);
+
+
+int si476x_core_set_audio_pwr_line_filter(struct si476x_core *core,
+					bool enable,
+					enum si476x_power_grid_type power_grid,
+					int harmonics_count)
+{
+	const u16 value = (enable << 9) | (power_grid << 8) | harmonics_count;
+
+	return si476x_core_cmd_set_property(core,
+					    SI476X_PROP_AUDIO_PWR_LINE_FILTER,
+					    value);
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_audio_pwr_line_filter);
+
+int si476x_core_get_audio_pwr_line_filter(struct si476x_core *core)
+{
+	return si476x_core_cmd_get_property(core,
+					    SI476X_PROP_AUDIO_PWR_LINE_FILTER);
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_audio_pwr_line_filter);
+
+int si476x_core_set_frequency_spacing(struct si476x_core *core, int spacing)
+{
+	/* FIXME: Magic numbers */
+	if (0 < spacing && spacing <= 310000)
+		return si476x_core_cmd_set_property(core,
+					SI476X_PROP_SEEK_FREQUENCY_SPACING,
+					hz_to_si476x(core, spacing));
+	else
+		return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_frequency_spacing);
+
+int si476x_core_get_frequency_spacing(struct si476x_core *core)
+{
+	int value;
+	value = si476x_core_cmd_get_property(core,
+					SI476X_PROP_SEEK_FREQUENCY_SPACING);
+	if (value >= 0)
+		value = si476x_to_hz(core, value);
+
+	return value;
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_frequency_spacing);
+
+int si476x_core_set_seek_band_top(struct si476x_core *core,
+				  int top)
+{
+	return si476x_core_cmd_set_property(core,
+					    SI476X_PROP_SEEK_BAND_TOP,
+					    hz_to_si476x(core, top));
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_seek_band_top);
+
+int si476x_core_get_seek_band_top(struct si476x_core *core)
+{
+	int value;
+	value = si476x_core_cmd_get_property(core,
+					     SI476X_PROP_SEEK_BAND_TOP);
+	if (value >= 0)
+		value = si476x_to_hz(core, value);
+
+	return value;
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_seek_band_top);
+
+int si476x_core_set_seek_band_bottom(struct si476x_core *core,
+				     int bottom)
+{
+	return si476x_core_cmd_set_property(core,
+					   SI476X_PROP_SEEK_BAND_BOTTOM,
+					    hz_to_si476x(core, bottom));
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_seek_band_bottom);
+
+int si476x_core_get_seek_band_bottom(struct si476x_core *core)
+{
+	int value;
+	value = si476x_core_cmd_get_property(core,
+					     SI476X_PROP_SEEK_BAND_BOTTOM);
+	if (value >= 0)
+		value = si476x_to_hz(core, value);
+
+	return value;
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_seek_band_bottom);
+
+int si476x_core_set_audio_deemphasis(struct si476x_core *core,
+				     int deemphasis)
+{
+	return si476x_core_cmd_set_property(core,
+					    SI476X_PROP_AUDIO_DEEMPHASIS,
+					    deemphasis);
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_audio_deemphasis);
+
+int si476x_core_get_audio_deemphasis(struct si476x_core *core)
+{
+	int value;
+	value = si476x_core_cmd_get_property(core,
+					     SI476X_PROP_AUDIO_DEEMPHASIS);
+	if (value >= 0)
+		value = si476x_to_hz(core, value);
+
+	return value;
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_audio_deemphasis);
+
+int si476x_core_set_fm_rds_interrupt_fifo_count(struct si476x_core *core,
+						int count)
+{
+	return si476x_core_cmd_set_property(core,
+				       SI476X_PROP_FM_RDS_INTERRUPT_FIFO_COUNT,
+				       count);
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_fm_rds_interrupt_fifo_count);
+
+int si476x_core_set_rds_interrupt_source(struct si476x_core *core,
+				    enum si476x_rdsint_sources sources)
+{
+	return si476x_core_cmd_set_property(core,
+				       SI476X_PROP_FM_RDS_INTERRUPT_SOURCE,
+				       sources);
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_rds_interrupt_source);
+
+int si476x_core_set_digital_io_input_sample_rate(struct si476x_core *core,
+					    u16 rate)
+{
+	return si476x_core_cmd_set_property(core,
+				SI476X_PROP_DIGITAL_IO_INPUT_SAMPLE_RATE,
+				rate);
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_digital_io_input_sample_rate);
+
+int si476x_core_disable_digital_audio(struct si476x_core *core)
+{
+	return si476x_core_set_digital_io_input_sample_rate(core, 0);
+}
+EXPORT_SYMBOL_GPL(si476x_core_disable_digital_audio);
+
+int si476x_core_set_valid_snr_threshold(struct si476x_core *core, int threshold)
+{
+	return si476x_core_cmd_set_property(core,
+					    SI476X_PROP_VALID_SNR_THRESHOLD,
+					    threshold);
+
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_valid_snr_threshold);
+
+int si476x_core_get_valid_snr_threshold(struct si476x_core *core)
+{
+	return si476x_core_cmd_get_property(core,
+					    SI476X_PROP_VALID_SNR_THRESHOLD);
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_valid_snr_threshold);
+
+int si476x_core_set_valid_rssi_threshold(struct si476x_core *core,
+					 int threshold)
+{
+	return si476x_core_cmd_set_property(core,
+					    SI476X_PROP_VALID_RSSI_THRESHOLD,
+					    threshold);
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_valid_rssi_threshold);
+
+int si476x_core_get_valid_rssi_threshold(struct si476x_core *core)
+{
+	return si476x_core_cmd_get_property(core,
+					    SI476X_PROP_VALID_RSSI_THRESHOLD);
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_valid_rssi_threshold);
+
+int si476x_core_set_valid_max_tune_error(struct si476x_core *core, int value)
+{
+	return si476x_core_cmd_set_property(core,
+					    SI476X_PROP_VALID_MAX_TUNE_ERROR,
+					    value);
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_valid_max_tune_error);
+
+int si476x_core_get_valid_max_tune_error(struct si476x_core *core)
+{
+	return si476x_core_cmd_get_property(core,
+					    SI476X_PROP_VALID_MAX_TUNE_ERROR);
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_valid_max_tune_error);
+
+
+#define SI476X_RDSEN 0x1
+
+int si476x_core_get_rds_reception(struct si476x_core *core)
+{
+	int property = si476x_core_cmd_get_property(core,
+						    SI476X_PROP_FM_RDS_CONFIG);
+
+	return (property < 0) ? property : (property & SI476X_RDSEN);
+}
+EXPORT_SYMBOL_GPL(si476x_core_get_rds_reception);
+
+static int __set_rdsen(struct si476x_core *core, bool rdsen)
+{
+	int property = si476x_core_cmd_get_property(core,
+					   SI476X_PROP_FM_RDS_CONFIG);
+	if (property >= 0) {
+		property = (rdsen) ?
+			(property | SI476X_RDSEN) :
+			(property & ~SI476X_RDSEN);
+
+		return si476x_core_cmd_set_property(core,
+						    SI476X_PROP_FM_RDS_CONFIG,
+						    property);
+	} else {
+		return property;
+	}
+}
+
+int si476x_core_set_rds_reception(struct si476x_core *core, int enable)
+{
+	int err;
+
+	if (enable) {
+		err = si476x_core_set_fm_rds_interrupt_fifo_count(core,
+							core->rds_fifo_depth);
+		if (err < 0) {
+			dev_err(&core->client->dev, "Failed to set RDS FIFO " \
+				"count\n");
+			goto exit;
+		}
+
+		err = si476x_core_set_rds_interrupt_source(core,
+							   SI476X_RDSRECV);
+		if (err < 0) {
+			dev_err(&core->client->dev,
+				"Failed to set RDS interrupt sources\n");
+			goto exit;
+		}
+
+		/* Drain RDS FIFO befor enabling RDS processing */
+		err = si476x_core_cmd_fm_rds_status(core, false,
+						    true, true, NULL);
+		if (err < 0) {
+			dev_err(&core->client->dev,
+				"Failed to drain RDS queue\n");
+			goto exit;
+		}
+
+		err = __set_rdsen(core, true);
+	} else {
+		err = __set_rdsen(core, false);
+	}
+
+exit:
+	return err;
+}
+EXPORT_SYMBOL_GPL(si476x_core_set_rds_reception);
-- 
1.7.9.5

