Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab1J0KnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 06:43:12 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:51483 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab1J0KnK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 06:43:10 -0400
MIME-Version: 1.0
In-Reply-To: <20111027080953.GB18360@opensource.wolfsonmicro.com>
References: <1319702185-16108-1-git-send-email-rnayak@ti.com>
	<1319702185-16108-2-git-send-email-rnayak@ti.com>
	<20111027080953.GB18360@opensource.wolfsonmicro.com>
Date: Thu, 27 Oct 2011 16:13:08 +0530
Message-ID: <CACYZBRG+_mm1O7Qg+ENCcLBX72iEWWyJohD_9EpAaT+Pb54cEA@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] regulator: helper routine to extract regulator_init_data
From: "Nayak, Rajendra" <rnayak@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, lrg@ti.com, b-cousson@ti.com, patches@linaro.org,
        linux-kernel@vger.kernel.org, shawn.guo@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If we have min_uV and max_uV we should also set REGULATOR_CHANGE_VOLTAGE
> (and similarly for the currents).
>
> We should also have a way to enable status changes - since there's an
> always_on property (which does make sense) I'd suggest that as a first
> pass we should enable status changes if always_on is not set (these two
> things are a bit redundant in the existing constrints).  This is
> slightly risky as you can get a situation where new device driver
> support for regulators starts unexpectedly turning off supplies but
> that's always going to be a risk with constraints disassociated from the
> kernel.

okay, here's an updated patch which does that. I also added a binding to
specify a descriptive name to the regulator outputs as you suggested in
the other thread.

>From a350de42446606abdc711a4acba39ae39b8f07bc Mon Sep 17 00:00:00 2001
From: Rajendra Nayak <rnayak@ti.com>
Date: Thu, 25 Aug 2011 20:31:49 +0530
Subject: [PATCH v4 1/4] regulator: helper routine to extract regulator_init_data

The helper routine is meant to be used by the regulator drivers
to extract the regulator_init_data structure from the data
that is passed from device tree.
'consumer_supplies' which is part of regulator_init_data is not extracted
as the regulator consumer mappings are passed through DT differently,
implemented in subsequent patches.
Similarly the regulator<-->parent/supply mapping is handled in
subsequent patches.

Also add documentation for regulator bindings to be used to pass
regulator_init_data struct information from device tree.

Some of the regulator properties which are linux and board specific,
are left out since its not clear if they can
be in someway embedded into the kernel or passed in from DT.
They will be revisited later.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
---
 .../devicetree/bindings/regulator/regulator.txt    |   33 ++++++++
 drivers/regulator/Kconfig                          |    7 ++
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/of_regulator.c                   |   81 ++++++++++++++++++++
 include/linux/regulator/of_regulator.h             |   20 +++++
 5 files changed, 142 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/regulator.txt
 create mode 100644 drivers/regulator/of_regulator.c
 create mode 100644 include/linux/regulator/of_regulator.h

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt
b/Documentation/devicetree/bindings/regulator/regulator.txt
new file mode 100644
index 0000000..c488bf3
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -0,0 +1,33 @@
+Voltage/Current Regulators
+
+Optional properties:
+- regulator-name: A string used as a descriptive name for regulator outputs
+- regulator-min-uV: smallest voltage consumers may set
+- regulator-max-uV: largest voltage consumers may set
+- regulator-uV-offset: Offset applied to voltages to compensate for
voltage drops
+- regulator-min-uA: smallest current consumers may set
+- regulator-max-uA: largest current consumers may set
+- regulator-always-on: boolean, regulator should never be disabled
+- regulator-boot-on: bootloader/firmware enabled regulator
+- <name>-supply: phandle to the parent supply/regulator node
+
+Example:
+
+	xyzreg: regulator@0 {
+		regulator-min-uV = <1000000>;
+		regulator-max-uV = <2500000>;
+		regulator-always-on;
+		vin-supply = <&vin>;
+	};
+
+The same binding used by a regulator to reference its
+supply can be used by any consumer to reference its
+regulator/supply
+
+Example of a device node referencing a regulator node,
+
+	devicenode: node@0x0 {
+		...
+		...
+		<name>-supply = <&xyzreg>;
+	};
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index c7fd2c0..8106958 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -64,6 +64,13 @@ config REGULATOR_USERSPACE_CONSUMER

           If unsure, say no.

+config OF_REGULATOR
+	bool
+	depends on OF
+	help
+	  OpenFirmware regulator framework helper routines that can
+	  used by regulator drivers to extract data from device tree.
+
 config REGULATOR_BQ24022
 	tristate "TI bq24022 Dual Input 1-Cell Li-Ion Charger IC"
 	help
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 040d5aa..e6bc009 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_REGULATOR) += core.o dummy.o
 obj-$(CONFIG_REGULATOR_FIXED_VOLTAGE) += fixed.o
 obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
+obj-$(CONFIG_OF_REGULATOR) += of_regulator.o

 obj-$(CONFIG_REGULATOR_AD5398) += ad5398.o
 obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
new file mode 100644
index 0000000..798faaa
--- /dev/null
+++ b/drivers/regulator/of_regulator.c
@@ -0,0 +1,81 @@
+/*
+ * OF helpers for regulator framework
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ * Rajendra Nayak <rnayak@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/regulator/machine.h>
+
+static void of_get_regulation_constraints(struct device_node *np,
+					struct regulator_init_data **init_data)
+{
+	const __be32 *min_uV, *max_uV, *uV_offset;
+	const __be32 *min_uA, *max_uA;
+	struct regulation_constraints *constraints = &(*init_data)->constraints;
+
+	constraints->name = of_get_property(np, "regulator-name", NULL);
+
+	min_uV = of_get_property(np, "regulator-min-uV", NULL);
+	if (min_uV)
+		constraints->min_uV = be32_to_cpu(*min_uV);
+	max_uV = of_get_property(np, "regulator-max-uV", NULL);
+	if (max_uV)
+		constraints->max_uV = be32_to_cpu(*max_uV);
+
+	/* Voltage change possible? */
+	if (constraints->min_uV != constraints->max_uV)
+		constraints->valid_ops_mask |= REGULATOR_CHANGE_VOLTAGE;
+
+	uV_offset = of_get_property(np, "regulator-uV-offset", NULL);
+	if (uV_offset)
+		constraints->uV_offset = be32_to_cpu(*uV_offset);
+	min_uA = of_get_property(np, "regulator-min-uA", NULL);
+	if (min_uA)
+		constraints->min_uA = be32_to_cpu(*min_uA);
+	max_uA = of_get_property(np, "regulator-max-uA", NULL);
+	if (max_uA)
+		constraints->max_uA = be32_to_cpu(*max_uA);
+
+	/* Current change possible? */
+	if (constraints->min_uA != constraints->max_uA)
+		constraints->valid_ops_mask |= REGULATOR_CHANGE_CURRENT;
+
+	if (of_find_property(np, "regulator-boot-on", NULL))
+		constraints->boot_on = true;
+
+	if (of_find_property(np, "regulator-always-on", NULL))
+		constraints->always_on = true;
+	else /* status change should be possible if not always on. */
+		constraints->valid_ops_mask |= REGULATOR_CHANGE_STATUS;
+}
+
+/**
+ * of_get_regulator_init_data - extract regulator_init_data structure info
+ * @dev: device requesting for regulator_init_data
+ *
+ * Populates regulator_init_data structure by extracting data from device
+ * tree node, returns a pointer to the populated struture or NULL if memory
+ * alloc fails.
+ */
+struct regulator_init_data *of_get_regulator_init_data(struct device *dev)
+{
+	struct regulator_init_data *init_data;
+
+	if (!dev->of_node)
+		return NULL;
+
+	init_data = devm_kzalloc(dev, sizeof(*init_data), GFP_KERNEL);
+	if (!init_data)
+		return NULL; /* Out of memory? */
+
+	of_get_regulation_constraints(dev->of_node, &init_data);
+	return init_data;
+}
diff --git a/include/linux/regulator/of_regulator.h
b/include/linux/regulator/of_regulator.h
new file mode 100644
index 0000000..621c071
--- /dev/null
+++ b/include/linux/regulator/of_regulator.h
@@ -0,0 +1,20 @@
+/*
+ * OpenFirmware regulator support routines
+ *
+ */
+
+#ifndef __LINUX_OF_REG_H
+#define __LINUX_OF_REG_H
+
+#if defined(CONFIG_OF_REGULATOR)
+extern struct regulator_init_data
+	*of_get_regulator_init_data(struct device *dev);
+#else
+static inline struct regulator_init_data
+	*of_get_regulator_init_data(struct device *dev)
+{
+	return NULL;
+}
+#endif /* CONFIG_OF_REGULATOR */
+
+#endif /* __LINUX_OF_REG_H */
-- 
1.7.1

>
