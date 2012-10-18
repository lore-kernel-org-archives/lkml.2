Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab2JRLMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 07:12:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:20418 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab2JRLMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 07:12:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="206020556"
From: Jenny TC <jenny.tc@intel.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
Cc: Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, myungjoo.ham@samsung.com,
        Jenny TC <jenny.tc@intel.com>
Subject: [PATCH 5/7] power_supply: Introduce Power Supply charging framework
Date: Thu, 18 Oct 2012 22:14:04 +0530
Message-Id: <1350578646-3315-6-git-send-email-jenny.tc@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350578646-3315-1-git-send-email-jenny.tc@intel.com>
References: <1350578646-3315-1-git-send-email-jenny.tc@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Power Supply charging framework connects multiple subsystems
to do charging in a generic way. The subsystems involves power_supply,
extcon, and thermal. With this the charging is handled in a generic way.

The framework makes use of different new features - Battery Identification
framework, pluggable charging algorithms, charger cable arbitrations etc.

At present the charging is done based on the static battery characteristics.
This is done at the boot time by passing the battery properties (max_voltage,
capacity) etc. as platform data to the charger/battery driver.
But new generation high volt batteries needs to be identified dynamically
to do charging in a safe manner. The batteries are coming with different
communication protocols. It become necessary to communicate with battery and
identify it's charging profiles before setup charging

Also the charging algorithms can vary based on the battery characteristics
and the platform characteristics. To handle charging in a generic way it's
necessary to support pluggable charging algorithms. Charging framework uses
selected algorithms based on the type of battery charging profile.
This is a simple binding and can be improved later. This may be improved to
select the algorithms based on the platform requirements. Also we can extend
this framework to plug algorithms from the user space.

The framework also introduces the charger cable arbitration. A charger may
supports multiple cables, but it may not be able to charge with multiple
cables at a time. The arbitration logic inside the framework selects the cable
based on it's capabilities and the maximum charge current the platform can
support

Also this framework exposes features to control charging on different platform
states. One such feature is thermal. The framework register with the thermal
subsystem and control charging based on the thermal subsystem requirements.

Overall this framework removes the charging logic out of the charger driver and
the charger driver can just listen to the request from the framework to set
the charger properties. This can be implemented by exposing get_property and set
property callbacks.

Signed-off-by: Jenny TC <jenny.tc@intel.com>
---
 drivers/power/Kconfig                |    8 +
 drivers/power/Makefile               |    1 +
 drivers/power/power_supply_charger.c |  634 ++++++++++++++++++++++++++++++++++
 drivers/power/power_supply_charger.h |  165 +++++++++
 4 files changed, 808 insertions(+)
 create mode 100644 drivers/power/power_supply_charger.c
 create mode 100644 drivers/power/power_supply_charger.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 74b297d..34850e4 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -8,6 +8,14 @@ menuconfig POWER_SUPPLY
 
 if POWER_SUPPLY
 
+config POWER_SUPPLY_CHARGER
+	bool "Power Supply Charger"
+	help
+	  Say Y here to enable the power supply charger framework. Charger
+	  framework supports charging in a generic way. This allows the charger
+	  drivers to keep the charging logic outside and the charger driver
+	  just need to abstract the charger hardware
+
 config POWER_SUPPLY_BATTID
 	bool "Power Supply Battery Identification Framework"
 	help
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 6a63f45..ce8c230 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -3,6 +3,7 @@ ccflags-$(CONFIG_POWER_SUPPLY_DEBUG) := -DDEBUG
 power_supply-y				:= power_supply_core.o
 power_supply-$(CONFIG_SYSFS)		+= power_supply_sysfs.o
 power_supply-$(CONFIG_LEDS_TRIGGERS)	+= power_supply_leds.o
+power_supply-$(CONFIG_POWER_SUPPLY_CHARGER) += power_supply_charger.o
 power_supply-$(CONFIG_POWER_SUPPLY_BATTID) += battery_id.o
 
 obj-$(CONFIG_POWER_SUPPLY)	+= power_supply.o
diff --git a/drivers/power/power_supply_charger.c b/drivers/power/power_supply_charger.c
new file mode 100644
index 0000000..413a26c
--- /dev/null
+++ b/drivers/power/power_supply_charger.c
@@ -0,0 +1,634 @@
+#define DEBUG
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/power_supply.h>
+#include <linux/thermal.h>
+#include <linux/extcon.h>
+#include <linux/power/battery_id.h>
+#include "power_supply.h"
+#include "power_supply_charger.h"
+
+#define MAX_CHARGER_COUNT 5
+
+static LIST_HEAD(algo_list);
+
+struct power_supply_charger {
+	bool is_cable_evt_reg;
+	/*cache battery and charger properties */
+	struct list_head chrgr_cache_lst;
+	struct list_head batt_cache_lst;
+	struct list_head evt_queue;
+	spinlock_t evt_lock;
+};
+
+struct charger_cable {
+	struct work_struct work;
+	struct notifier_block nb;
+	struct extcon_chrgr_cbl_props cable_props;
+	enum extcon_cable_name extcon_cable_type;
+	enum power_supply_charger_cable_type psy_cable_type;
+	struct extcon_specific_cable_nb extcon_dev;
+	struct extcon_dev *edev;
+};
+
+static struct power_supply_charger psy_chrgr;
+
+static struct charger_cable cable_list[] = {
+	{
+	 .psy_cable_type = POWER_SUPPLY_CHARGER_TYPE_USB_SDP,
+	 .extcon_cable_type = EXTCON_SDP,
+	 },
+	{
+	 .psy_cable_type = POWER_SUPPLY_CHARGER_TYPE_USB_CDP,
+	 .extcon_cable_type = EXTCON_CDP,
+	 },
+	{
+	 .psy_cable_type = POWER_SUPPLY_CHARGER_TYPE_USB_DCP,
+	 .extcon_cable_type = EXTCON_DCP,
+	 },
+	{
+	 .psy_cable_type = POWER_SUPPLY_CHARGER_TYPE_USB_ACA,
+	 .extcon_cable_type = EXTCON_ACA,
+	 },
+	{
+	 .psy_cable_type = POWER_SUPPLY_CHARGER_TYPE_AC,
+	 .extcon_cable_type = EXTCON_AC,
+	 },
+};
+
+static int charger_cable_notifier(struct notifier_block *nb,
+				  unsigned long event, void *ptr);
+static void charger_cable_event_worker(struct work_struct *work);
+struct charging_algo *power_supply_get_charging_algo
+		(struct power_supply *, struct ps_batt_chg_prof *);
+
+static void init_charger_cables(struct charger_cable *cable_lst, int count)
+{
+	struct charger_cable *cable;
+	struct extcon_chrgr_cbl_props cable_props;
+	const char *cable_name;
+
+	while (--count) {
+		cable = cable_lst++;
+		/* initialize cable instance */
+		INIT_WORK(&cable->work, charger_cable_event_worker);
+		cable->nb.notifier_call = charger_cable_notifier;
+		cable->cable_props.cable_stat = EXTCON_CHRGR_CABLE_DISCONNECTED;
+		cable->cable_props.mA = 0;
+		cable_name = extcon_cable_name[cable->extcon_cable_type];
+
+		if (extcon_register_interest(&cable->extcon_dev,
+				NULL, cable_name, &cable->nb))
+				continue;
+
+		cable->edev = cable->extcon_dev.edev;
+
+		if (!cable->edev)
+			continue;
+
+		if (cable->edev->get_cable_properties(cable_name,
+						      (void *)&cable_props)) {
+			continue;
+
+		} else if (cable_props.cable_stat !=
+			   cable->cable_props.cable_stat) {
+			cable->cable_props.cable_stat = cable_props.cable_stat;
+			cable->cable_props.mA = cable_props.mA;
+		}
+	}
+}
+
+static inline void get_cur_chrgr_prop(struct power_supply *psy,
+				      struct charger_props *chrgr_prop)
+{
+	chrgr_prop->name = psy->name;
+	chrgr_prop->online = IS_ONLINE(psy);
+	chrgr_prop->present = IS_PRESENT(psy);
+	chrgr_prop->cable = CABLE_TYPE(psy);
+
+}
+
+static inline int get_chrgr_prop_cache(struct power_supply *psy,
+				       struct charger_props *chrgr_cache)
+{
+
+	struct charger_props *chrgr_prop;
+	int ret = -ENODEV;
+
+	list_for_each_entry(chrgr_prop, &psy_chrgr.chrgr_cache_lst, node) {
+		if (!strcmp(chrgr_prop->name, psy->name)) {
+			memcpy(chrgr_cache, chrgr_prop, sizeof(*chrgr_cache));
+			ret = 0;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static inline void cache_chrgr_prop(struct charger_props *chrgr_prop_new)
+{
+
+	struct charger_props *chrgr_cache;
+
+	list_for_each_entry(chrgr_cache, &psy_chrgr.chrgr_cache_lst, node) {
+		if (!strcmp(chrgr_cache->name, chrgr_prop_new->name))
+			goto update_props;
+	}
+
+	chrgr_cache = kzalloc(sizeof(*chrgr_cache), GFP_KERNEL);
+	if (IS_ERR(chrgr_cache)) {
+		pr_err("%s:%dError in allocating memory\n", __FILE__, __LINE__);
+		return;
+	}
+
+	INIT_LIST_HEAD(&chrgr_cache->node);
+	list_add_tail(&chrgr_cache->node, &psy_chrgr.chrgr_cache_lst);
+
+	chrgr_cache->name = chrgr_prop_new->name;
+
+update_props:
+	chrgr_cache->status = chrgr_prop_new->status;
+	chrgr_cache->present = chrgr_prop_new->present;
+	chrgr_cache->cable = chrgr_prop_new->cable;
+}
+
+
+static inline bool is_chrgr_prop_changed(struct power_supply *psy)
+{
+
+	struct charger_props chrgr_prop_cache, chrgr_prop;
+
+	get_cur_chrgr_prop(psy, &chrgr_prop);
+	/* Get cached battery property. If no cached property available
+	 *  then cache the new property and return true
+	 */
+	if (get_chrgr_prop_cache(psy, &chrgr_prop_cache)) {
+		cache_chrgr_prop(&chrgr_prop);
+		return true;
+	}
+
+	if (!IS_CHARGER_PROP_CHANGED(chrgr_prop, chrgr_prop_cache))
+		return false;
+
+	cache_chrgr_prop(&chrgr_prop);
+	return true;
+}
+
+static inline void cache_bat_prop(struct batt_props *bat_prop_new)
+{
+
+	struct batt_props *bat_cache;
+
+	/* Find entry in cache list. If an entry is located update
+	 * the existing entry else create new entry in the list */
+	list_for_each_entry(bat_cache, &psy_chrgr.batt_cache_lst, node) {
+		if (!strcmp(bat_cache->name, bat_prop_new->name))
+			goto update_props;
+	}
+
+	bat_cache = kzalloc(sizeof(*bat_cache), GFP_KERNEL);
+	if (IS_ERR(bat_cache)) {
+		pr_err("%s:%dError in allocating memory\n", __FILE__, __LINE__);
+		return;
+	}
+	INIT_LIST_HEAD(&bat_cache->node);
+	list_add_tail(&bat_cache->node, &psy_chrgr.batt_cache_lst);
+
+	bat_cache->name = bat_prop_new->name;
+
+update_props:
+	bat_cache->voltage_now = bat_prop_new->voltage_now;
+	bat_cache->current_now = bat_prop_new->current_now;
+	bat_cache->temperature = bat_prop_new->temperature;
+	bat_cache->status = bat_prop_new->status;
+}
+
+static inline int get_bat_prop_cache(struct power_supply *psy,
+				     struct batt_props *bat_cache)
+{
+
+	struct batt_props *bat_prop;
+	int ret = -ENODEV;
+
+	list_for_each_entry(bat_prop, &psy_chrgr.batt_cache_lst, node) {
+		if (!strcmp(bat_prop->name, psy->name)) {
+			memcpy(bat_cache, bat_prop, sizeof(*bat_cache));
+			ret = 0;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static inline void get_cur_bat_prop(struct power_supply *psy,
+				    struct batt_props *bat_prop)
+{
+	bat_prop->name = psy->name;
+	bat_prop->voltage_now = VOLTAGE_NOW(psy) / 1000;
+	bat_prop->current_now = CURRENT_NOW(psy) / 1000;
+	bat_prop->temperature = TEMPERATURE(psy) / 10;
+	bat_prop->status = STATUS(psy);
+
+}
+
+static inline bool is_batt_prop_changed(struct power_supply *psy)
+{
+
+	struct batt_props bat_prop_cache, bat_prop;
+
+	/* Get cached battery property. If no cached property available
+	 *  then cache the new property and return true
+	 */
+	get_cur_bat_prop(psy, &bat_prop);
+	if (get_bat_prop_cache(psy, &bat_prop_cache)) {
+		cache_bat_prop(&bat_prop);
+		return true;
+	}
+
+	if (!IS_BAT_PROP_CHANGED(bat_prop, bat_prop_cache))
+		return false;
+
+	cache_bat_prop(&bat_prop);
+	return true;
+}
+
+static inline bool is_trigger_charging_algo(struct power_supply *psy)
+{
+
+	/* trigger charging alorithm if battery or
+	 * charger properties are changed
+	 */
+
+	if ((IS_CHARGER(psy)) && is_chrgr_prop_changed(psy))
+		return true;
+
+	if ((IS_BATTERY(psy)) && is_batt_prop_changed(psy))
+		return true;
+
+	return false;
+}
+
+static int get_supplied_by_list(struct power_supply *psy,
+				struct power_supply *psy_lst[])
+{
+	struct class_dev_iter iter;
+	struct device *dev;
+	struct power_supply *pst;
+	int cnt = 0, i, j;
+
+	if (!IS_BATTERY(psy))
+		return 0;
+
+	/* Identify chargers which are supplying power to the battery */
+	class_dev_iter_init(&iter, power_supply_class, NULL, NULL);
+	while ((dev = class_dev_iter_next(&iter))) {
+		pst = (struct power_supply *)dev_get_drvdata(dev);
+		if (!IS_CHARGER(pst))
+			continue;
+		for (i = 0; i < pst->num_supplicants; i++) {
+			if ((!strcmp(pst->supplied_to[i], psy->name)) &&
+			    IS_ONLINE(pst))
+				psy_lst[cnt++] = pst;
+		}
+	}
+	class_dev_iter_exit(&iter);
+
+	if (cnt <= 1)
+		return cnt;
+
+	/*sort based on priority. 0 has the highest priority  */
+	for (i = 0; i < cnt; ++i)
+		for (j = 0; j < cnt; ++j)
+			if (PRIORITY(psy_lst[j]) > PRIORITY(psy_lst[i]))
+				swap(psy_lst[j], psy_lst[i]);
+
+	return cnt;
+}
+
+static int trigger_algo(struct power_supply *psy)
+{
+	unsigned long cc = 0, cv = 0, cc_min;
+	struct power_supply *chrgr_lst[MAX_CHARGER_COUNT];
+	struct batt_props bat_prop;
+	struct charging_algo *algo;
+	struct ps_batt_chg_prof chrg_profile;
+	int cnt;
+
+	if (psy->type != POWER_SUPPLY_TYPE_BATTERY)
+		return 0;
+
+	if (get_batt_prop(&chrg_profile)) {
+		pr_err("Error in getting charge profile:%s:%d\n", __FILE__,
+		       __LINE__);
+		return -EINVAL;
+	}
+
+	get_bat_prop_cache(psy, &bat_prop);
+
+	algo = power_supply_get_charging_algo(psy, &chrg_profile);
+	if (!algo)
+		return -EINVAL;
+
+	algo->get_next_cc_cv(bat_prop, chrg_profile, &cc, &cv);
+
+	if (!cc || !cv)
+		return -ENODATA;
+
+	/* CC needs to be updated for all chargers which are supplying
+	 *  power to this battery to ensure that the sum of CCs of all
+	 * chargers are never more than the CC selected by the algo.
+	 * The CC is set based on the charger priority.
+	 */
+	cnt = get_supplied_by_list(psy, chrgr_lst);
+
+	while (cnt--) {
+		cc_min = min_t(unsigned long, MAX_CC(chrgr_lst[cnt]), cc);
+		cc_min = min_t(unsigned long, INLMT(chrgr_lst[cnt]), cc_min);
+		if (cc_min < 0)
+			cc_min = 0;
+		cc -= cc_min;
+		set_cc(chrgr_lst[cnt], cc_min);
+		set_cv(chrgr_lst[cnt], cv);
+	}
+	return 0;
+}
+
+static inline void enable_supplied_by_charging
+		(struct power_supply *psy, bool is_enable)
+{
+	struct power_supply *chrgr_lst[MAX_CHARGER_COUNT];
+	int cnt;
+
+	if (psy->type != POWER_SUPPLY_TYPE_BATTERY)
+		return;
+	/* Get list of chargers supplying power to this battery and
+	 * disable charging for all chargers
+	 */
+	cnt = get_supplied_by_list(psy, chrgr_lst);
+	while (--cnt) {
+		if (is_enable && IS_CHARGING_CAN_BE_ENABLED(psy))
+			enable_charging(chrgr_lst[cnt]);
+		else
+			disable_charging(chrgr_lst[cnt]);
+	}
+}
+
+void power_supply_trigger_charging_handler(struct power_supply *psy)
+{
+	int i;
+	struct power_supply *psb = NULL;
+
+	if (!psy_chrgr.is_cable_evt_reg)
+		return;
+
+	if (is_trigger_charging_algo(psy)) {
+
+		if (IS_BATTERY(psy)) {
+			if (trigger_algo(psy))
+				enable_supplied_by_charging(psy, false);
+			else
+				enable_supplied_by_charging(psy, true);
+
+		} else if (IS_CHARGER(psy)) {
+			for (i = 0; i < psy->num_supplicants; i++) {
+				psb =
+				    power_supply_get_by_name(psy->
+							     supplied_to[i]);
+
+				if (psb && IS_BATTERY(psb) && IS_PRESENT(psb)) {
+					if (trigger_algo(psb)) {
+						disable_charging(psy);
+						break;
+					} else if (IS_CHARGING_CAN_BE_ENABLED
+								(psy)) {
+						enable_charging(psy);
+					}
+				}
+			}
+		}
+
+	}
+}
+EXPORT_SYMBOL(power_supply_trigger_charging_handler);
+
+
+static int select_chrgr_cable(struct device *dev, void *data)
+{
+	struct power_supply *psy = dev_get_drvdata(dev);
+	struct charger_cable *cable, *max_mA_cable = NULL;
+	struct charger_cable *cable_lst = (struct charger_cable *)data;
+	unsigned int max_mA = 0;
+	int i;
+
+	if (!IS_CHARGER(psy))
+		return 0;
+
+	/* get cable with maximum capability */
+	for (i = 0; i < ARRAY_SIZE(cable_list); ++i) {
+		cable = cable_lst + i;
+		if ((!IS_CABLE_ACTIVE(cable->cable_props.cable_stat)) ||
+		    (!IS_SUPPORTED_CABLE(psy, cable->psy_cable_type)))
+			continue;
+
+		if (cable->cable_props.mA > max_mA) {
+			max_mA_cable = cable;
+			max_mA = cable->cable_props.mA;
+		}
+	}
+
+	/* no cable connected. disable charging */
+	if (!max_mA_cable) {
+
+		if ((IS_CHARGER_ENABLED(psy) || IS_CHARGING_ENABLED(psy))) {
+			disable_charging(psy);
+			disable_charger(psy);
+		}
+		set_cc(psy, 0);
+		set_cv(psy, 0);
+		set_inlmt(psy, 0);
+		switch_cable(psy, POWER_SUPPLY_CHARGER_TYPE_NONE);
+		return 0;
+	}
+
+	/* cable type changed.New cable connected or existing cable
+	 * capabilities changed.switch cable and enable charger and charging
+	 */
+
+	if (CABLE_TYPE(psy) != max_mA_cable->psy_cable_type) {
+		switch_cable(psy, max_mA_cable->psy_cable_type);
+		set_inlmt(psy, max_mA_cable->cable_props.mA);
+	} else if (INLMT(psy) != max_mA_cable->cable_props.mA) {
+		set_inlmt(psy, max_mA_cable->cable_props.mA);
+	}
+
+	power_supply_trigger_charging_handler(psy);
+	/* Cable status is same as previous. No action to be taken */
+	return 0;
+
+}
+
+static void configure_chrgr_source(struct charger_cable *cable_lst)
+{
+
+	class_for_each_device(power_supply_class, NULL,
+			      cable_lst, select_chrgr_cable);
+
+}
+
+static void charger_cable_event_worker(struct work_struct *work)
+{
+	struct charger_cable *cable =
+	    container_of(work, struct charger_cable, work);
+	struct extcon_chrgr_cbl_props cable_props;
+
+	if (cable->edev->
+	    get_cable_properties(extcon_cable_name[cable->extcon_cable_type],
+				 (void *)&cable_props)) {
+		pr_err("Erron in getting cable(%s) properties from extcon device(%s):%s:%d",
+				extcon_cable_name[cable->extcon_cable_type],
+				cable->edev->name, __FILE__, __LINE__);
+		return;
+	} else {
+		if (cable_props.cable_stat != cable->cable_props.cable_stat) {
+			cable->cable_props.cable_stat = cable_props.cable_stat;
+			cable->cable_props.mA = cable_props.mA;
+			configure_chrgr_source(cable_list);
+		}
+	}
+
+}
+
+static int charger_cable_notifier(struct notifier_block *nb,
+				  unsigned long stat, void *ptr)
+{
+
+	struct charger_cable *cable =
+	    container_of(nb, struct charger_cable, nb);
+
+	schedule_work(&cable->work);
+
+	return NOTIFY_DONE | NOTIFY_STOP_MASK;
+}
+
+int psy_charger_throttle_charger(struct power_supply *psy,
+					unsigned long state)
+{
+
+	if (state < 0 || state > MAX_THROTTLE_STATE(psy))
+		return -EINVAL;
+
+	switch THROTTLE_ACTION(psy, state)
+	{
+
+		case PSY_THROTTLE_DISABLE_CHARGER:
+			disable_charger(psy);
+			break;
+		case PSY_THROTTLE_DISABLE_CHARGING:
+			disable_charging(psy);
+			break;
+		case PSY_THROTTLE_CC_LIMIT:
+			SET_MAX_CC(psy, THROTTLE_CC_VALUE(psy, state));
+			power_supply_trigger_charging_handler(psy);
+			break;
+		case PSY_THROTTLE_INPUT_LIMIT:
+			set_inlmt(psy, THROTTLE_CC_VALUE(psy, state));
+			power_supply_trigger_charging_handler(psy);
+			break;
+		default:
+			pr_err("Invalid throttle action for %s\n", psy->name);
+			return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(psy_charger_throttle_charger);
+
+int power_supply_register_charger(struct power_supply *psy)
+{
+	int ret = 0;
+
+	if (!psy_chrgr.is_cable_evt_reg) {
+		init_charger_cables(cable_list, ARRAY_SIZE(cable_list));
+		psy_chrgr.is_cable_evt_reg = true;
+		INIT_LIST_HEAD(&psy_chrgr.chrgr_cache_lst);
+		INIT_LIST_HEAD(&psy_chrgr.batt_cache_lst);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(power_supply_register_charger);
+
+int power_supply_unregister_charger(struct power_supply *psy)
+{
+ /*TBD*/
+	return 0;
+}
+EXPORT_SYMBOL(power_supply_unregister_charger);
+
+int power_supply_register_charging_algo(struct charging_algo *algo)
+{
+
+	struct charging_algo *algo_new;
+
+	algo_new = kzalloc(sizeof(*algo_new), GFP_KERNEL);
+	algo_new->get_next_cc_cv = algo->get_next_cc_cv;
+	algo_new->name = algo->name;
+	algo_new->chrg_prof_type = algo->chrg_prof_type;
+
+	list_add_tail(&algo_new->node, &algo_list);
+	return 0;
+}
+EXPORT_SYMBOL(power_supply_register_charging_algo);
+
+int power_supply_unregister_charging_algo(struct charging_algo *algo)
+{
+	struct charging_algo *algo_l, *tmp;
+
+	list_for_each_entry_safe(algo_l, tmp, &algo_list, node) {
+		if (!strcmp(algo_l->name, algo->name)) {
+			list_del(&algo_l->node);
+			kfree(algo_l);
+		}
+	}
+	return 0;
+
+}
+EXPORT_SYMBOL(power_supply_unregister_charging_algo);
+
+static struct charging_algo *get_charging_algo_byname(char *algo_name)
+{
+	struct charging_algo *algo;
+
+	list_for_each_entry(algo, &algo_list, node) {
+		if (!strcmp(algo->name, algo_name))
+			return algo;
+	}
+
+	return NULL;
+}
+
+static struct charging_algo *get_charging_algo_by_type
+		(enum batt_chrg_prof_type chrg_prof_type)
+{
+	struct charging_algo *algo;
+
+	list_for_each_entry(algo, &algo_list, node) {
+		if (algo->chrg_prof_type == chrg_prof_type)
+			return algo;
+	}
+
+	return NULL;
+}
+
+struct charging_algo *power_supply_get_charging_algo
+	(struct power_supply *psy, struct ps_batt_chg_prof *batt_prof)
+{
+
+	return get_charging_algo_by_type(batt_prof->chrg_prof_type);
+
+}
+EXPORT_SYMBOL_GPL(power_supply_get_charging_algo);
diff --git a/drivers/power/power_supply_charger.h b/drivers/power/power_supply_charger.h
new file mode 100644
index 0000000..cb17581
--- /dev/null
+++ b/drivers/power/power_supply_charger.h
@@ -0,0 +1,165 @@
+#include <linux/power_supply.h>
+
+#ifndef __POWER_SUPPLY_CHARGER_H__
+
+#define __POWER_SUPPLY_CHARGER_H__
+
+struct batt_props {
+	struct list_head node;
+	const char *name;
+	unsigned long voltage_now;
+	long current_now;
+	int temperature;
+	long status;
+};
+
+struct charger_props {
+	struct list_head node;
+	const char *name;
+	bool present;
+	bool status;
+	bool online;
+	unsigned long cable;
+};
+
+struct charging_algo {
+	struct list_head node;
+	unsigned int chrg_prof_type;
+	char *name;
+	int (*get_next_cc_cv)(struct batt_props, struct ps_batt_chg_prof,
+				unsigned long *cc, unsigned long *cv);
+};
+
+extern int power_supply_register_charging_algo(struct charging_algo *);
+extern int power_supply_unregister_charging_algo(struct charging_algo *);
+
+static inline int set_ps_int_property(struct power_supply *psy,
+				      enum power_supply_property psp,
+				      int prop_val)
+{
+
+	union power_supply_propval val;
+
+	val.intval = prop_val;
+	return psy->set_property(psy, psp, &val);
+}
+
+static inline int get_ps_int_property(struct power_supply *psy,
+				      enum power_supply_property psp)
+{
+	union power_supply_propval val;
+
+	psy->get_property(psy, psp, &val);
+	return val.intval;
+}
+
+#define enable_charging(psy) \
+		({if ((CABLE_TYPE(psy) != POWER_SUPPLY_CHARGER_TYPE_NONE) &&\
+			!IS_CHARGING_ENABLED(psy)) \
+		set_ps_int_property(psy, POWER_SUPPLY_PROP_ENABLE_CHARGING,\
+					true);\
+		enable_charger(psy); })
+#define disable_charging(psy) \
+		({if ((CABLE_TYPE(psy) != POWER_SUPPLY_CHARGER_TYPE_NONE) &&\
+				IS_CHARGING_ENABLED(psy)) \
+		set_ps_int_property(psy,\
+				POWER_SUPPLY_PROP_ENABLE_CHARGING, false); })
+
+#define enable_charger(psy) \
+		set_ps_int_property(psy, POWER_SUPPLY_PROP_ENABLE_CHARGER, true)
+#define disable_charger(psy) \
+		set_ps_int_property(psy,\
+				POWER_SUPPLY_PROP_ENABLE_CHARGER, false)
+
+#define set_cc(psy, cc) \
+		set_ps_int_property(psy, POWER_SUPPLY_PROP_CHARGE_CURRENT, cc)
+
+#define set_cv(psy, cv) \
+		set_ps_int_property(psy, POWER_SUPPLY_PROP_CHARGE_VOLTAGE, cv)
+
+#define set_inlmt(psy, inlmt) \
+		set_ps_int_property(psy, POWER_SUPPLY_PROP_INLMT, inlmt)
+#define SET_MAX_CC(psy, max_cc) \
+		set_ps_int_property(psy,\
+				POWER_SUPPLY_PROP_MAX_CHARGE_CURRENT, max_cc)
+#define switch_cable(psy, new_cable) \
+		set_ps_int_property(psy,\
+				POWER_SUPPLY_PROP_CABLE_TYPE, new_cable)
+
+#define CV(psy) \
+		get_ps_int_property(psy, POWER_SUPPLY_PROP_CHARGE_VOLTAGE)
+#define CC(psy) \
+		get_ps_int_property(psy, POWER_SUPPLY_PROP_CHARGE_CURRENT)
+#define INLMT(psy) \
+		get_ps_int_property(psy, POWER_SUPPLY_PROP_INLMT)
+#define MAX_CC(psy) \
+		get_ps_int_property(psy, POWER_SUPPLY_PROP_MAX_CHARGE_CURRENT)
+#define MAX_CV(psy) \
+		get_ps_int_property(psy, POWER_SUPPLY_PROP_MAX_CHARGE_VOLTAGE)
+#define VOLTAGE_NOW(psy) \
+		get_ps_int_property(psy, POWER_SUPPLY_PROP_VOLTAGE_NOW)
+#define CURRENT_NOW(psy) \
+		get_ps_int_property(psy, POWER_SUPPLY_PROP_CURRENT_NOW)
+#define STATUS(psy) \
+		get_ps_int_property(psy, POWER_SUPPLY_PROP_STATUS)
+#define TEMPERATURE(psy) \
+		get_ps_int_property(psy, POWER_SUPPLY_PROP_TEMP)
+#define BATTERY_TYPE(psy) \
+		get_ps_int_property(psy, POWER_SUPPLY_PROP_TECHNOLOGY)
+#define PRIORITY(psy) \
+		get_ps_int_property(psy, POWER_SUPPLY_PROP_PRIORITY)
+#define CABLE_TYPE(psy) \
+		get_ps_int_property(psy, POWER_SUPPLY_PROP_CABLE_TYPE)
+
+#define IS_CHARGING_ENABLED(psy) \
+		get_ps_int_property(psy, POWER_SUPPLY_PROP_ENABLE_CHARGING)
+#define IS_CHARGER_ENABLED(psy) \
+		get_ps_int_property(psy, POWER_SUPPLY_PROP_ENABLE_CHARGER)
+#define IS_BATTERY(psy) (psy->type == POWER_SUPPLY_TYPE_BATTERY)
+#define IS_CHARGER(psy) (psy->type == POWER_SUPPLY_TYPE_USB ||\
+				psy->type == POWER_SUPPLY_TYPE_USB_CDP || \
+			psy->type == POWER_SUPPLY_TYPE_USB_DCP ||\
+			psy->type == POWER_SUPPLY_TYPE_USB_ACA)
+#define IS_ONLINE(psy) \
+		(get_ps_int_property(psy, POWER_SUPPLY_PROP_ONLINE) == 1)
+#define IS_PRESENT(psy) \
+		(get_ps_int_property(psy, POWER_SUPPLY_PROP_PRESENT) == 1)
+#define IS_SUPPORTED_CABLE(psy, cable_type) \
+		(psy->supported_cables & cable_type)
+#define IS_CABLE_ACTIVE(status) \
+	((status != EXTCON_CHRGR_CABLE_DISCONNECTED) ||\
+			(status != EXTCON_CHRGR_CABLE_SUSPENDED))
+
+#define IS_CHARGER_PROP_CHANGED(prop, cache_prop)\
+	((cache_prop.online != prop.online) || \
+	(cache_prop.present != prop.present))
+
+#define IS_BAT_PROP_CHANGED(bat_prop, bat_cache)\
+	((bat_cache.voltage_now != bat_prop.voltage_now) || \
+	(bat_cache.current_now != bat_prop.current_now) || \
+	(bat_cache.temperature != bat_prop.temperature))
+
+#define THROTTLE_ACTION(psy, state)\
+		(((psy->throttle_states)+state)->throttle_action)
+
+#define MAX_THROTTLE_STATE(psy)\
+		(get_ps_int_property(psy,\
+			POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX))
+
+#define CURRENT_THROTTLE_STATE(psy)\
+		(get_ps_int_property(psy,\
+			POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT))
+
+#define CURRENT_THROTTLE_ACTION(psy)\
+		THROTTLE_ACTION(psy, CURRENT_THROTTLE_STATE(psy))
+
+#define THROTTLE_CC_VALUE(psy, state)\
+		(((psy->throttle_states)+state)->throttle_val)
+
+#define IS_CHARGING_CAN_BE_ENABLED(psy) \
+	((CURRENT_THROTTLE_ACTION(psy) != PSY_THROTTLE_DISABLE_CHARGER)  &&\
+	(CURRENT_THROTTLE_ACTION(psy) != PSY_THROTTLE_DISABLE_CHARGING))
+#define IS_CHARGER_CAN_BE_ENABLED(psy) \
+	(CURRENT_THROTTLE_ACTION(psy) != PSY_THROTTLE_DISABLE_CHARGER)
+
+#endif
-- 
1.7.9.5

