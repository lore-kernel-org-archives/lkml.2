Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2JRLND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:13:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:20418 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab2JRLMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:12:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="206020586"
From: Jenny TC <jenny.tc@intel.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
Cc: Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, myungjoo.ham@samsung.com,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCH 7/7] power_supply: Introduce PSE compliant algorithm
Date: Thu, 18 Oct 2012 22:14:06 +0530
Message-Id: <1350578646-3315-8-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350578646-3315-1-git-send-email-jenny.tc@intel.com>
References: <1350578646-3315-1-git-send-email-jenny.tc@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per PSE standard the battery characteristics and thereby the
charging rates can vary on different temperature zones. This
patch introduces a PSE compliant charging algorithm with
maintenance charging support. The algorithm can be selected by the
charging framework based on the type of the battery charging profile.

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 drivers/power/Kconfig             |   12 ++++++
 drivers/power/Makefile            |    1 +
 drivers/power/charging_algo_pse.c |   79 +++++++++++++++++++++++++++++++++++++
 include/linux/power/battery_id.h  |   47 ++++++++++++++++++++++
 4 files changed, 139 insertions(+)
 create mode 100644 drivers/power/charging_algo_pse.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 34850e4..e09be69 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -16,6 +16,18 @@ config POWER_SUPPLY_CHARGER
 	  drivers to keep the charging logic outside and the charger driver
 	  just need to abstract the charger hardware
 
+config POWER_SUPPLY_CHARGING_ALGO_PSE
+	bool "PSE compliant charging algorithm"
+	help
+	  Say Y here to select PSE compliant charging algorithm. As per PSE
+	  standard the battery characteristics and thereby the charging rates
+	  can vary on different temperature zones. This config will enable PSE
+	  compliant charging algorithm with maintenance charging support. The
+	  algorithm can be selected by the charging framework based on the type
+	  of the battery charging profile.
+
+	depends on POWER_SUPPLY_CHARGER
+
 config POWER_SUPPLY_BATTID
 	bool "Power Supply Battery Identification Framework"
 	help
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index ce8c230..8b250b2 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -8,6 +8,7 @@ power_supply-$(CONFIG_POWER_SUPPLY_BATTID) += battery_id.o
 
 obj-$(CONFIG_POWER_SUPPLY)	+= power_supply.o
 obj-$(CONFIG_GENERIC_ADC_BATTERY)	+= generic-adc-battery.o
+obj-$(CONFIG_POWER_SUPPLY_CHARGING_ALGO_PSE) += charging_algo_pse.o
 
 obj-$(CONFIG_PDA_POWER)		+= pda_power.o
 obj-$(CONFIG_APM_POWER)		+= apm_power.o
diff --git a/drivers/power/charging_algo_pse.c b/drivers/power/charging_algo_pse.c
new file mode 100644
index 0000000..66feff8
--- /dev/null
+++ b/drivers/power/charging_algo_pse.c
@@ -0,0 +1,79 @@
+#define DEBUG
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/power_supply.h>
+#include <linux/thermal.h>
+#include <linux/power/battery_id.h>
+#include "power_supply.h"
+#include "power_supply_charger.h"
+
+static int get_tempzone(struct ps_pse_mod_prof *pse_mod_bprof,
+			int temp)
+{
+
+	int i = 0;
+	int temp_range_cnt = pse_mod_bprof->temp_mon_ranges;
+
+	if (temp < pse_mod_bprof->temp_low_lim
+	    || temp >
+	    pse_mod_bprof->temp_mon_range[0].temp_up_lim)
+		return -EINVAL;
+
+	for (i = 0; i < temp_range_cnt; ++i)
+		if (temp <= pse_mod_bprof->temp_mon_range[i].temp_up_lim)
+			break;
+	return i;
+}
+
+static int pse_get_next_cc_cv(struct batt_props bat_prop,
+	struct ps_batt_chg_prof  bprof, unsigned long *cc, unsigned long *cv)
+{
+	int tzone;
+	struct ps_pse_mod_prof *pse_mod_bprof;
+
+
+	if (bprof.chrg_prof_type != PSE_MOD_CHRG_PROF)
+		return -EINVAL;
+
+	pse_mod_bprof = (struct ps_pse_mod_prof *) bprof.batt_prof;
+
+	if (!pse_mod_bprof)
+		return -EINVAL;
+
+	tzone = get_tempzone(pse_mod_bprof, bat_prop.temperature);
+
+	if (tzone < 0)
+		return -ENODATA;
+
+	/* read cc and cv based on temperature and battery status*/
+
+	*cc = pse_mod_bprof->temp_mon_range[tzone].full_chrg_cur;
+	if (bat_prop.status == POWER_SUPPLY_STATUS_FULL)
+		*cv = pse_mod_bprof->temp_mon_range[tzone].maint_chrg_vol_ul;
+	else
+		*cv = pse_mod_bprof->temp_mon_range[tzone].full_chrg_vol;
+
+	/* Software full detection: Set cc and cv to zero if FULL battery
+	*  condition is met
+	*/
+	if ((bat_prop.current_now <= pse_mod_bprof->chrg_term_mA) &&
+		(pse_mod_bprof->temp_mon_range[tzone].full_chrg_vol >= cv))
+			*cc = *cv = 0;
+	return 0;
+}
+
+static int __init pse_algo_init(void)
+{
+	struct charging_algo pse_algo;
+	pse_algo.chrg_prof_type = PSE_MOD_CHRG_PROF;
+	pse_algo.name = "pse_algo";
+	pse_algo.get_next_cc_cv = pse_get_next_cc_cv;
+	power_supply_register_charging_algo(&pse_algo);
+	return 0;
+}
+
+module_init(pse_algo_init);
diff --git a/include/linux/power/battery_id.h b/include/linux/power/battery_id.h
index 9a4832e..860a8b8 100644
--- a/include/linux/power/battery_id.h
+++ b/include/linux/power/battery_id.h
@@ -33,12 +33,59 @@ enum {
 	POWER_SUPPLY_BATTERY_INSERTED,
 };
 
+enum batt_chrg_prof_type {
+	PSE_MOD_CHRG_PROF = 0,
+};
+
 /* charging profile structure definition */
 struct ps_batt_chg_prof {
 	enum batt_chrg_prof_type chrg_prof_type;
 	void *batt_prof;
 };
 
+/* PSE Modified Algo Structure */
+/* Parameters defining the charging range */
+struct ps_temp_chg_table {
+	/* upper temperature limit for each zone */
+	short int temp_up_lim;
+	/* charge current and voltage */
+	short int full_chrg_vol;
+	short int full_chrg_cur;
+	/* maintenance thresholds */
+	/* maintenance lower threshold. Once battery hits full, charging
+	*  charging will be resumed when battery voltage <= this voltage
+	*/
+	short int maint_chrg_vol_ll;
+	/* Charge current and voltage in maintenance mode */
+	short int maint_chrg_vol_ul;
+	short int maint_chrg_cur;
+} __packed;
+
+
+#define BATTID_STR_LEN		8
+#define BATT_TEMP_NR_RNG	6
+/* Charging Profile */
+struct ps_pse_mod_prof {
+	/* battery id */
+	char batt_id[BATTID_STR_LEN];
+	/* type of battery */
+	u16 battery_type;
+	u16 capacity;
+	u16 voltage_max;
+	/* charge termination current */
+	u16 chrg_term_mA;
+	/* Low battery level voltage */
+	u16 low_batt_mV;
+	/* upper and lower temperature limits on discharging */
+	u8 disch_tmp_ul;
+	u8 disch_tmp_ll;
+	/* number of temperature monitoring ranges */
+	u8 temp_mon_ranges;
+	struct ps_temp_chg_table temp_mon_range[BATT_TEMP_NR_RNG];
+	/* Lowest temperature supported */
+	short int temp_low_lim;
+} __packed;
+
 /*For notification during battery change event*/
 extern struct atomic_notifier_head    batt_id_notifier;
 
-- 
1.7.9.5

