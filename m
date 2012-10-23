Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403Ab2JWSpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:45:34 -0400
Received: from 173-160-178-141-Washington.hfc.comcastbusiness.net ([173.160.178.141]:46288
	"EHLO relay" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932656Ab2JWSoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:44:30 -0400
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
To: andrey.smirnov@convergeddevices.net
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/6] Add chip properties handling code for SI476X MFD
Date: Tue, 23 Oct 2012 11:44:30 -0700
Message-Id: <1351017872-32488-5-git-send-email-andrey.smirnov@convergeddevices.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1351017872-32488-1-git-send-email-andrey.smirnov@convergeddevices.net>
References: <1351017872-32488-1-git-send-email-andrey.smirnov@convergeddevices.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code related to manipulation of the properties of
SI476X chips.

Signed-off-by: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
---
 drivers/mfd/si476x-prop.c |  257 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 257 insertions(+)
 create mode 100644 drivers/mfd/si476x-prop.c

diff --git a/drivers/mfd/si476x-prop.c b/drivers/mfd/si476x-prop.c
new file mode 100644
index 0000000..3811eec
--- /dev/null
+++ b/drivers/mfd/si476x-prop.c
@@ -0,0 +1,257 @@
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
+struct si476x_property_range {
+	u16 low, high;
+};
+
+
+
+static bool si476x_core_element_is_in_array(u16 element, const u16 array[], size_t size)
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
+static bool si476x_core_element_is_in_range(u16 element,
+					    const struct si476x_property_range range[],
+					    size_t size)
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
+		0x0718,
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
+	return	si476x_core_element_is_in_range(property, valid_ranges,
+						ARRAY_SIZE(valid_ranges)) ||
+		si476x_core_element_is_in_array(property, valid_properties,
+						ARRAY_SIZE(valid_properties));
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
+		si476x_core_element_is_in_range(property, valid_ranges,
+						ARRAY_SIZE(valid_ranges))  ||
+		si476x_core_element_is_in_array(property, valid_properties,
+						ARRAY_SIZE(valid_properties));
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
+		si476x_core_element_is_in_range(property, valid_ranges,
+						ARRAY_SIZE(valid_ranges)) ||
+		si476x_core_element_is_in_array(property, valid_properties,
+						ARRAY_SIZE(valid_properties));
+}
+
+typedef bool (*valid_property_pred_t) (struct si476x_core *, u16);
+
+static bool si476x_core_is_valid_property(struct si476x_core *core, u16 property)
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
+
+
+static bool si476x_core_is_readonly_property(struct si476x_core *core, u16 property)
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
+
+static bool si476x_core_regmap_readable_register(struct device *dev, unsigned int reg)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct si476x_core *core = i2c_get_clientdata(client);
+
+	return si476x_core_is_valid_property(core, (u16) reg);
+
+}
+
+static bool si476x_core_regmap_writable_register(struct device *dev, unsigned int reg)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct si476x_core *core = i2c_get_clientdata(client);
+
+	return si476x_core_is_valid_property(core, (u16) reg) &&
+		!si476x_core_is_readonly_property(core, (u16) reg);
+}
+
+static const struct regmap_config si476x_regmap_config = {
+	.reg_bits = 16,
+	.val_bits = 16,
+
+	.max_register = 0x4003,
+
+	.writeable_reg = si476x_core_regmap_writable_register,
+	.readable_reg = si476x_core_regmap_readable_register,
+
+	.cache_type = REGCACHE_RBTREE,
+};
+
+static int si476x_core_regmap_write(void *context, const void *data, size_t count)
+{
+	struct si476x_core *core = context;
+	u16 prop, val;
+
+	if (count != sizeof(prop) + sizeof(val))
+		return -EINVAL;
+
+	prop = be16_to_cpup(data);
+	val = be16_to_cpup(data + 2);
+
+	return si476x_core_cmd_set_property(core, prop, val);
+}
+
+static int si476x_core_regmap_read(void *context,
+				   const void *reg, size_t reg_size,
+				   void *val, size_t val_size)
+{
+	struct si476x_core *core = context;
+	u16 prop;
+	int err;
+
+	if (reg_size != sizeof(u16) ||
+	    val_size != sizeof(u16))
+		return -EINVAL;
+
+	prop = be16_to_cpup(reg);
+
+	err = si476x_core_cmd_get_property(core, prop);
+	if (err < 0) {
+		if (prop == 0x4002)
+			WARN(1, "{XXXX} Failed to read property: %x, %d",
+			     prop, core->power_up_parameters.func);
+		return err;
+	}
+
+	*(u16 *)val = cpu_to_be16(0xFFFF & err);
+
+	return 0;
+}
+
+static struct regmap_bus si476x_regmap_bus = {
+	.write = si476x_core_regmap_write,
+	.read  = si476x_core_regmap_read,
+};
+
+struct regmap *devm_regmap_init_si476x(struct si476x_core *core)
+{
+	return devm_regmap_init(&core->client->dev, &si476x_regmap_bus,
+				core, &si476x_regmap_config);
+}
+EXPORT_SYMBOL_GPL(devm_regmap_init_si476x);
-- 
1.7.10.4

