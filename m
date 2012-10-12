Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab2JLLLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:11:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:41303 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab2JLLLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:11:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,576,1344236400"; 
   d="scan'208";a="226030320"
From: Jenny TC <jenny.tc@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Cc: Jenny TC <jenny.tc@intel.com>, ajay.thomas.david.rajamanickam@intel.com,
        ramakrishna.pallala@intel.com
Subject: [PATCH V2] power_supply : Introduce battery identification framework
Date: Fri, 12 Oct 2012 22:13:08 +0530
Message-Id: <1350060188-23936-1-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces generic battid framework. Different battid
drivers sitting on different linux kernel subsystem (1wire,
I2C, SFI etc) can interface with the power supply susbsytem using
the APIs exposed in the power supply usbsystem. The consumers (charger
driver/battery driver/power management drivers) can register
for notification from the battery id drivers using the APIs from this
framework

Signed-off-by: Jenny TC <jenny.tc@intel.com>
Signed-off-by: adavidra <ajay.thomas.david.rajamanickam@intel.com>
---
V1: Submitted the initialcode
V2:
   Added file headers

 drivers/power/Kconfig            |    8 ++++
 drivers/power/Makefile           |    1 +
 drivers/power/battery_id.c       |   94 ++++++++++++++++++++++++++++++++++++++
 include/linux/power/battery_id.h |   50 ++++++++++++++++++++
 4 files changed, 153 insertions(+)
 create mode 100644 drivers/power/battery_id.c
 create mode 100644 include/linux/power/battery_id.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 49a8939..74b297d 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -8,6 +8,14 @@ menuconfig POWER_SUPPLY
 
 if POWER_SUPPLY
 
+config POWER_SUPPLY_BATTID
+	bool "Power Supply Battery Identification Framework"
+	help
+	 Say Y here to enable the power supply battery idnetification
+	 framework. The framework would allow different battery identification
+	 drivers to interface with power supply subsystem. Also it allows consumer
+	 drivers to register for notification from the power_supply subsystem.
+
 config POWER_SUPPLY_DEBUG
 	bool "Power supply debug"
 	help
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index b949cf8..6a63f45 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -3,6 +3,7 @@ ccflags-$(CONFIG_POWER_SUPPLY_DEBUG) := -DDEBUG
 power_supply-y				:= power_supply_core.o
 power_supply-$(CONFIG_SYSFS)		+= power_supply_sysfs.o
 power_supply-$(CONFIG_LEDS_TRIGGERS)	+= power_supply_leds.o
+power_supply-$(CONFIG_POWER_SUPPLY_BATTID) += battery_id.o
 
 obj-$(CONFIG_POWER_SUPPLY)	+= power_supply.o
 obj-$(CONFIG_GENERIC_ADC_BATTERY)	+= generic-adc-battery.o
diff --git a/drivers/power/battery_id.c b/drivers/power/battery_id.c
new file mode 100644
index 0000000..f6160b6
--- /dev/null
+++ b/drivers/power/battery_id.c
@@ -0,0 +1,94 @@
+/*
+ * battery_id.c - Power supply battery identification framework
+ *
+ * Copyright (C) 2012 Intel Corporation
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * Author: Jenny TC <jenny.tc@intel.com>
+ * Author: David Rajamanickam, Ajay Thomas
+ *		<ajay.thomas.david.rajamanickam@intel.com>
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/notifier.h>
+#include <linux/power/battery_id.h>
+
+ATOMIC_NOTIFIER_HEAD(batt_id_notifier);
+
+static struct ps_batt_chg_prof *batt_property;
+static int batt_status;
+
+int batt_id_reg_notifier(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&batt_id_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(batt_id_reg_notifier);
+
+void batt_id_unreg_notifier(struct notifier_block *nb)
+{
+	atomic_notifier_chain_unregister(&batt_id_notifier, nb);
+}
+EXPORT_SYMBOL_GPL(batt_id_unreg_notifier);
+
+
+/**
+ * battery_prop_changed - Update properties when  battery connection status
+ *                        changes
+ * @battery_conn_stat : The current connection status of battery
+ * @batt_prop : Address of the ps_batt_chg_prof structure with the updated
+ *              values passed from the calling function
+ *
+ * Whenever the battery connection status changes this function will be called
+ * to indicate a change in the status and to update the status and value of
+ * properties
+ */
+void battery_prop_changed(int battery_conn_stat,
+			struct ps_batt_chg_prof *batt_prop)
+{
+	if (batt_status != battery_conn_stat) {
+		if (battery_conn_stat == POWER_SUPPLY_BATTERY_INSERTED)
+			batt_property = batt_prop;
+		else
+			batt_property = NULL;
+
+		batt_status = battery_conn_stat;
+	}
+
+	atomic_notifier_call_chain(&batt_id_notifier,
+			0, &(batt_property));
+
+}
+EXPORT_SYMBOL_GPL(battery_prop_changed);
+
+/**
+ * get_batt_prop - Get the battery connection status and updated properties
+ * @batt_prop : battery properties structure copied to this address
+ */
+int get_batt_prop(struct ps_batt_chg_prof *batt_prop)
+{
+	if (batt_property)
+		memcpy(batt_prop, batt_property,
+			sizeof(struct ps_batt_chg_prof));
+	else
+		return -ENOMEM;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(get_batt_prop);
diff --git a/include/linux/power/battery_id.h b/include/linux/power/battery_id.h
new file mode 100644
index 0000000..9a4832e
--- /dev/null
+++ b/include/linux/power/battery_id.h
@@ -0,0 +1,50 @@
+/*
+ * battery_id.h - Power supply battery identification framework header file
+ *
+ * Copyright (C) 2012 Intel Corporation
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * Author: Jenny TC <jenny.tc@intel.com>
+ * Author: David Rajamanickam, Ajay Thomas
+ *		<ajay.thomas.david.rajamanickam@intel.com>
+ */
+
+#ifndef __BATTERY_ID_H__
+
+#define __BATTERY_ID_H__
+
+enum {
+	POWER_SUPPLY_BATTERY_REMOVED = 0,
+	POWER_SUPPLY_BATTERY_INSERTED,
+};
+
+/* charging profile structure definition */
+struct ps_batt_chg_prof {
+	enum batt_chrg_prof_type chrg_prof_type;
+	void *batt_prof;
+};
+
+/*For notification during battery change event*/
+extern struct atomic_notifier_head    batt_id_notifier;
+
+extern void battery_prop_changed(int battery_conn_stat,
+				struct ps_batt_chg_prof *batt_prop);
+extern int get_batt_prop(struct ps_batt_chg_prof *batt_prop);
+extern int batt_id_reg_notifier(struct notifier_block *nb);
+extern void batt_id_unreg_notifier(struct notifier_block *nb);
+#endif
-- 
1.7.9.5

