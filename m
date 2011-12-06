Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab1LFKBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:01:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:33360 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab1LFKBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:01:04 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-c3-4edde7dd5a86
From: Donggeun Kim <dg77.kim@samsung.com>
To: linux-pm@vger.kernel.org
Cc: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, rdunlap@xenotime.net,
        cbouatmailru@gmail.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 1/2] power: Charger-Manager: add initial Charger-Manager
 driver
Date: Tue, 06 Dec 2011 19:00:41 +0900
Message-id: <1323165642-12214-2-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1323165642-12214-1-git-send-email-dg77.kim@samsung.com>
References: <1323165642-12214-1-git-send-email-dg77.kim@samsung.com>
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because battery health monitoring should be done even when suspended,
it needs to wake up and suspend periodically. Thus, userspace battery
monitoring may incur too much overhead; every device and task is woken
up periodically. Charger Manager uses suspend-again to provide
in-suspend monitoring.

This patch allows to monitor battery health in-suspend state.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/power/charger-manager.txt |  150 ++++++
 drivers/power/Kconfig                   |    9 +
 drivers/power/Makefile                  |    1 +
 drivers/power/charger-manager.c         |  771 +++++++++++++++++++++++++++++++
 include/linux/power/charger-manager.h   |  131 ++++++
 5 files changed, 1062 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/power/charger-manager.txt
 create mode 100644 drivers/power/charger-manager.c
 create mode 100644 include/linux/power/charger-manager.h

diff --git a/Documentation/power/charger-manager.txt b/Documentation/power/charger-manager.txt
new file mode 100644
index 0000000..99630e5
--- /dev/null
+++ b/Documentation/power/charger-manager.txt
@@ -0,0 +1,150 @@
+Charger Manager
+	(C) 2011 MyungJoo Ham <myungjoo.ham@samsung.com>, GPL
+
+Charger Manager provides in-kernel battery charger management that
+requires temperature monitoring during suspend-to-RAM state
+and where each battery may have multiple chargers attached and the userland
+wants to look at the aggregated information of the multiple chargers.
+
+Charger Manager is a platform_driver with power-supply-class entries.
+An instance of Charger Manager (a platform-device created with Charger-Manager)
+represents an independent battery with chargers. If there are multiple
+batteries with their own chargers acting independently in a system,
+the system may need multiple instances of Charger Manager.
+
+1. Introduction
+===============
+
+Charger Manager supports the following:
+
+* Support for multiple chargers (e.g., a device with USB, AC, and solar panels)
+	A system may have multiple chargers (or power sources) and some of
+	they may be activated at the same time. Each charger may have its
+	own power-supply-class and each power-supply-class can provide
+	different information about the battery status. This framework
+	aggregates charger-related information from multiple sources and
+	shows combined information as a single power-supply-class.
+
+* Support for in suspend-to-RAM polling (with suspend_again callback)
+	While the battery is being charged and the system is in suspend-to-RAM,
+	we may need to monitor the battery health by looking at the ambient or
+	battery temperature. We can accomplish this by waking up the system
+	periodically. However, such a method wakes up devices unncessary for
+	monitoring the battery health and tasks, and user processes that are
+	supposed to be kept suspended. That, in turn, incurs unnecessary power
+	consumption and slow down charging process. Or even, such peak power
+	consumption can stop chargers in the middle of charging
+	(external power input < device power consumption), which not
+	only affects the charging time, but the lifespan of the battery.
+
+	Charger Manager provides a function "cm_suspend_again" that can be
+	used as suspend_again callback of platform_suspend_ops. If the platform
+	requires tasks other than cm_suspend_again, it may implement its own
+	suspend_again callback that calls cm_suspend_again in the middle.
+	Normally, the platform will need to resume and suspend some devices
+	that are used by Charger Manager.
+
+2. Global Charger-Manager Data related with suspend_again
+========================================================
+In order to setup Charger Manager with suspend-again feature
+(in-suspend monitoring), the user should provide charger_global_desc
+with setup_charger_manager(struct charger_global_desc *).
+This charger_global_desc data for in-suspend monitoring is global
+as the name suggests. Thus, the user needs to provide only once even
+if there are multiple batteries. If there are multiple batteries, the
+multiple instances of Charger Manager share the same charger_global_desc
+and it will manage in-suspend monitoring for all instances of Charger Manager.
+
+The user needs to provide all the three entries properly in order to activate
+in-suspend monitoring:
+
+struct charger_global_desc {
+
+char *rtc;
+	: The name of rtc (e.g., "rtc0") used to wakeup the system from
+	suspend for Charger Manager. The alarm interrupt (AIE) of the rtc
+	should be able to wake up the system from suspend. Charger Manager
+	saves and restores the alarm value and use the previously-defined
+	alarm if it is going to go off earlier than Charger Manager so that
+	Charger Manager does not interfere with previously-defined alarms.
+
+bool (*is_rtc_only_wakeup_reason)(void);
+	: This callback should let CM know whether
+	the wakeup-from-suspend is caused only by the alarm of "rtc" in the
+	same struct. If there is any other wakeup source triggered the
+	wakeup, it should return false. If the "rtc" is the only wakeup
+	reason, it should return true.
+};
+
+3. How to setup suspend_again
+=============================
+Charger Manager provides a function "extern bool cm_suspend_again(void)".
+When cm_suspend_again is called, it monitors every battery. The suspend_ops
+callback of the system's platform_suspend_ops can call cm_suspend_again
+function to know whether Charger Manager wants to suspend again or not.
+If there are no other devices or tasks that want to use suspend_again
+feature, the platform_suspend_ops may directly refer to cm_suspend_again
+for its suspend_again callback.
+
+The cm_suspend_again() returns true (meaning "I want to suspend again")
+if the system was woken up by Charger Manager and the polling
+(in-suspend monitoring) results in "normal".
+
+4. Charger-Manager Data (struct charger_desc)
+=============================================
+For each battery charged independently from other batteries (if a series of
+batteries are charged by a single charger, they are counted as one independent
+battery), an instance of Charger Manager is attached to it.
+
+struct charger_desc {
+
+enum polling_modes polling_mode;
+	: CM_POLL_DISABLE: do not poll this battery.
+	  CM_POLL_ALWAYS: always poll this battery.
+	  CM_POLL_EXTERNAL_POWER_ONLY: poll this battery if and only if
+				       an external power source is attached.
+	  CM_POLL_CHARGING_ONLY: poll this battery if and only if the
+				 battery is being charged.
+
+unsigned int polling_interval_ms;
+	: Required polling interval in ms. Charger Manager will poll
+	this battery every polling_interval_ms or more frequently.
+
+enum data_source battery_present;
+	CM_FUEL_GAUGE: get battery presence information from fuel gauge.
+	CM_CHARGER_STAT: get battery presence from chargers.
+
+char **psy_charger_stat;
+	: An array ending with NULL that has power-supply-class names of
+	chargers. Each power-supply-class should provide "PRESENT" (if
+	battery_present is "CM_CHARGER_STAT"), "ONLINE" (shows whether an
+	external power source is attached or not), and "STATUS" (shows whether
+	the battery is {"FULL" or not FULL} or {"FULL", "Charging",
+	"Discharging", "NotCharging"}).
+
+int num_charger_regulators;
+struct regulator_bulk_data *charger_regulators;
+	: Regulators representing the chargers in the form for
+	regulator framework's bulk functions.
+
+char *psy_fuel_gauge;
+	: Power-supply-class name of the fuel gauge.
+
+int (*is_temperature_error)(int *mC);
+	: This callback returns 0 if the temperature is safe for charging,
+	a positive number if it is too hot to charge, and a negative number
+	if it is too cold to charge. With the variable mC, the callback returns
+	the temperature in 1/1000 of centigrade.
+};
+
+5. Other Considerations
+=======================
+
+At the charger/battery-related events such as battery-pulled-out,
+charger-pulled-out, charger-inserted, DCIN-over/under-voltage, charger-stopped,
+and others critical to chargers, the system should be configured to wake up.
+At least the following should wake up the system from a suspend:
+a) charger-on/off b) external-power-in/out c) battery-in/out (while charging)
+
+It is usually accomplished by configuring the PMIC as a wakeup source.
+
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 9f88641..92683b5 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -236,6 +236,15 @@ config CHARGER_GPIO
 	  This driver can be build as a module. If so, the module will be
 	  called gpio-charger.
 
+config CHARGER_MANAGER
+        bool "Battery charger manager for multiple chargers"
+        help
+          Say Y to enable charger-manager support, which allows multiple
+          chargers attached to a battery and multiple batteries attached to a
+          system. The charger-manager also can monitor charging status in
+          runtime and in suspend-to-RAM by waking up the system periodically
+          with help of suspend_again support.
+
 config CHARGER_MAX8997
 	tristate "Maxim MAX8997/MAX8966 PMIC battery charger driver"
 	depends on MFD_MAX8997 && REGULATOR_MAX8997
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index b4af13d..d3b24e9 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -36,5 +36,6 @@ obj-$(CONFIG_CHARGER_ISP1704)	+= isp1704_charger.o
 obj-$(CONFIG_CHARGER_MAX8903)	+= max8903_charger.o
 obj-$(CONFIG_CHARGER_TWL4030)	+= twl4030_charger.o
 obj-$(CONFIG_CHARGER_GPIO)	+= gpio-charger.o
+obj-$(CONFIG_CHARGER_MANAGER)	+= charger-manager.o
 obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
 obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
new file mode 100644
index 0000000..5006756
--- /dev/null
+++ b/drivers/power/charger-manager.c
@@ -0,0 +1,771 @@
+/* linux/drivers/power/charger-manager.c
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ * MyungJoo Ham <myungjoo.ham@samsung.com>
+ *
+ * This driver enables to monitor battery health and control charger
+ * during suspend-to-mem.
+ * Charger manager depends on other devices. register this later than
+ * the depending devices.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+**/
+
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/rtc.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include <linux/platform_device.h>
+#include <linux/power/charger-manager.h>
+#include <linux/regulator/consumer.h>
+
+/*
+ * Regard CM_JIFFIES_SMALL jiffies is small enough to ignore for
+ * delayed works so that we can run delayed works with CM_JIFFIES_SMALL
+ * without any delays.
+ */
+#define	CM_JIFFIES_SMALL	(2)
+
+/* If y is valid (> 0) and smaller than x, do x = y */
+#define CM_MIN_VALID(x, y)	x = (((y > 0) && ((x) > (y))) ? (y) : (x))
+
+/*
+ * Regard CM_RTC_SMALL (sec) is small enough to ignore error in invoking
+ * rtc alarm. It should be 2 or larger
+ */
+#define CM_RTC_SMALL		(2)
+
+#define UEVENT_BUF_SIZE		32
+
+static LIST_HEAD(cm_list);
+static DEFINE_MUTEX(cm_list_mtx);
+
+/* About in-suspend (suspend-again) monitoring */
+static struct rtc_device *rtc_dev;
+static struct rtc_wkalrm rtc_wkalarm_save; /* Backup RTC alarm */
+static unsigned long rtc_wkalarm_save_; /* 0 if not available */
+static bool cm_suspended;
+static bool cm_rtc_set;
+static unsigned long cm_suspend_duration_ms;
+
+/* Global charger-manager description */
+static struct charger_global_desc *g_desc; /* init with setup_charger_manager */
+
+/**
+ * is_batt_present - See if the battery presents in place.
+ * @cm: the Charger Manager representing the battery.
+ */
+static bool is_batt_present(struct charger_manager *cm)
+{
+	union power_supply_propval val;
+	bool present = false;
+	int i, ret;
+
+	switch (cm->desc->battery_present) {
+	case CM_FUEL_GAUGE:
+		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
+				POWER_SUPPLY_PROP_PRESENT, &val);
+		if (ret == 0 && val.intval)
+			present = true;
+		break;
+	case CM_CHARGER_STAT:
+		for (i = 0; cm->charger_stat[i]; i++) {
+			ret = cm->charger_stat[i]->get_property(
+					cm->charger_stat[i],
+					POWER_SUPPLY_PROP_PRESENT, &val);
+			if (ret == 0 && val.intval) {
+				present = true;
+				break;
+			}
+		}
+		break;
+	}
+
+	return present;
+}
+
+/**
+ * is_ext_pwr_online - See if an external power source is attached to charge
+ * @cm: the Charger Manager representing the battery.
+ *
+ * Returns true if at least one of the chargers of the battery has an external
+ * power source attached to charge the battery regardless of whether it is
+ * actually charging or not.
+ */
+static bool is_ext_pwr_online(struct charger_manager *cm)
+{
+	union power_supply_propval val;
+	bool online = false;
+	int i, ret;
+
+	/* If at least one of them has one, it's yes. */
+	for (i = 0; cm->charger_stat[i]; i++) {
+		ret = cm->charger_stat[i]->get_property(
+				cm->charger_stat[i],
+				POWER_SUPPLY_PROP_ONLINE, &val);
+		if (ret == 0 && val.intval) {
+			online = true;
+			break;
+		}
+	}
+
+	return online;
+}
+
+/**
+ * is_charging - Returns true if the battery is being charged.
+ * @cm: the Charger Manager representing the battery.
+ */
+static bool is_charging(struct charger_manager *cm)
+{
+	int i, ret;
+	bool charging = false;
+	union power_supply_propval val;
+
+	/* If there is no battery, it cannot be charged */
+	if (!is_batt_present(cm))
+		return false;
+
+	/* If at least one of the charger is charging, return yes */
+	for (i = 0; cm->charger_stat[i]; i++) {
+		/* 1. The charger sholuld not be DISABLED */
+		if (cm->emergency_stop)
+			continue;
+		if (!cm->charger_enabled)
+			continue;
+
+		/* 2. The charger should be online (ext-power) */
+		ret = cm->charger_stat[i]->get_property(
+				cm->charger_stat[i],
+				POWER_SUPPLY_PROP_ONLINE, &val);
+		if (ret) {
+			dev_warn(cm->dev, "Cannot read ONLINE value from %s.\n",
+					cm->desc->psy_charger_stat[i]);
+			continue;
+		}
+		if (val.intval == 0)
+			continue;
+
+		/*
+		 * 3. The charger should not be FULL, DISCHARGING,
+		 * or NOT_CHARGING.
+		 */
+		ret = cm->charger_stat[i]->get_property(
+				cm->charger_stat[i],
+				POWER_SUPPLY_PROP_STATUS, &val);
+		if (ret) {
+			dev_warn(cm->dev, "Cannot read STATUS value from %s.\n",
+					cm->desc->psy_charger_stat[i]);
+			continue;
+		}
+		if (val.intval == POWER_SUPPLY_STATUS_FULL ||
+				val.intval == POWER_SUPPLY_STATUS_DISCHARGING ||
+				val.intval == POWER_SUPPLY_STATUS_NOT_CHARGING)
+			continue;
+
+		/* Then, this is charging. */
+		charging = true;
+		break;
+	}
+
+	return charging;
+}
+
+/**
+ * is_polling_required - Return true if need to continue polling for this CM.
+ * @cm: the Charger Manager representing the battery.
+ */
+static bool is_polling_required(struct charger_manager *cm)
+{
+	switch (cm->desc->polling_mode) {
+	case CM_POLL_DISABLE:
+		return false;
+	case CM_POLL_ALWAYS:
+		return true;
+	case CM_POLL_EXTERNAL_POWER_ONLY:
+		return is_ext_pwr_online(cm);
+	case CM_POLL_CHARGING_ONLY:
+		return is_charging(cm);
+	default:
+		dev_warn(cm->dev, "Incorrect polling_mode (%d)\n",
+			cm->desc->polling_mode);
+	}
+
+	return false;
+}
+
+/**
+ * try_charger_enable - Enable/Disable chargers altogether
+ * @cm: the Charger Manager representing the battery.
+ * @enable: true: enable / false: disable
+ *
+ * Note that Charger Manager keeps the charger enabled regardless whether
+ * the charger is charging or not (because battery is full or no external
+ * power source exists) except when CM needs to disable chargers forcibly
+ * bacause of emergency causes; when the battery is overheated or too cold.
+ */
+static int try_charger_enable(struct charger_manager *cm, bool enable)
+{
+	int err = 0, i;
+	struct charger_desc *desc = cm->desc;
+
+	/* Ignore if it's redundent command */
+	if (enable && cm->charger_enabled)
+		return 0;
+	if (!enable && !cm->charger_enabled)
+		return 0;
+
+	if (enable) {
+		if (cm->emergency_stop)
+			return -EAGAIN;
+		err = regulator_bulk_enable(desc->num_charger_regulators,
+					desc->charger_regulators);
+	} else {
+		/*
+		 * Abnormal battery state - Stop charging forcibly,
+		 * even if charger was enabled at the other places
+		 */
+		err = regulator_bulk_disable(desc->num_charger_regulators,
+					desc->charger_regulators);
+
+		for (i = 0; i < desc->num_charger_regulators; i++) {
+			if (regulator_is_enabled(
+				    desc->charger_regulators[i].consumer)) {
+				regulator_force_disable(
+					desc->charger_regulators[i].consumer);
+				dev_warn(cm->dev,
+					"Disable regulator(%s) forcibly.\n",
+					desc->charger_regulators[i].supply);
+			}
+		}
+	}
+
+	if (!err)
+		cm->charger_enabled = enable;
+
+	return err;
+}
+
+/**
+ * uevent_notify - Let users know something has changed.
+ * @cm: the Charger Manager representing the battery.
+ * @event: the event string.
+ *
+ * If @event is null, it implies that uevent_notify is called
+ * by resume function. When called in the resume function, cm_suspended
+ * should be already reset to false in order to let uevent_notify
+ * notify the recent event during the suspend to users. While
+ * suspended, uevent_notify does not notify users, but tracks
+ * events so that uevent_notify can notify users later after resumed.
+ */
+static void uevent_notify(struct charger_manager *cm, const char *event)
+{
+	static char env_str[UEVENT_BUF_SIZE + 1] = "";
+	static char env_str_save[UEVENT_BUF_SIZE + 1] = "";
+
+	if (cm_suspended) {
+		/* Nothing in suspended-event buffer */
+		if (env_str_save[0] == 0) {
+			if (!strncmp(env_str, event, UEVENT_BUF_SIZE))
+				return; /* status not changed */
+			strncpy(env_str_save, event, UEVENT_BUF_SIZE);
+			return;
+		}
+
+		if (!strncmp(env_str_save, event, UEVENT_BUF_SIZE))
+			return; /* Duplicated. */
+		else
+			strncpy(env_str_save, event, UEVENT_BUF_SIZE);
+
+		return;
+	}
+
+	if (event == NULL) {
+		/* No messages pending */
+		if (!env_str_save[0])
+			return;
+
+		strncpy(env_str, env_str_save, UEVENT_BUF_SIZE);
+		kobject_uevent(&cm->dev->kobj, KOBJ_CHANGE);
+		env_str_save[0] = 0;
+
+		return;
+	}
+
+	/* status not changed */
+	if (!strncmp(env_str, event, UEVENT_BUF_SIZE))
+		return;
+
+	/* save the status and notify the update */
+	strncpy(env_str, event, UEVENT_BUF_SIZE);
+	kobject_uevent(&cm->dev->kobj, KOBJ_CHANGE);
+
+	dev_info(cm->dev, event);
+}
+
+/**
+ * _cm_monitor - Monitor the temperature and return true for exceptions.
+ * @cm: the Charger Manager representing the battery.
+ *
+ * Returns true if there is an event to notify for the battery.
+ * (True if the status of "emergency_stop" changes)
+ */
+static bool _cm_monitor(struct charger_manager *cm)
+{
+	struct charger_desc *desc = cm->desc;
+	int temp = desc->is_temperature_error(&cm->last_temp_mC);
+
+	dev_dbg(cm->dev, "monitoring (%2.2d.%3.3dC)\n",
+		cm->last_temp_mC / 1000, cm->last_temp_mC % 1000);
+
+	/* It has been stopped already */
+	if (temp && cm->emergency_stop)
+		return false;
+
+	/* It has been charging already */
+	if (!temp && !cm->emergency_stop)
+		return false;
+
+	if (temp) {
+		cm->emergency_stop = temp;
+		if (!try_charger_enable(cm, false)) {
+			if (temp > 0)
+				uevent_notify(cm, "OVERHEAT");
+			else
+				uevent_notify(cm, "COLD");
+		}
+	} else {
+		cm->emergency_stop = 0;
+		if (!try_charger_enable(cm, true))
+			uevent_notify(cm, "CHARGING");
+	}
+
+	return true;
+}
+
+/**
+ * cm_monitor - Monitor every battery.
+ *
+ * Returns true if there is an event to notify from any of the batteries.
+ * (True if the status of "emergency_stop" changes)
+ */
+static bool cm_monitor(void)
+{
+	bool stop = false;
+	struct charger_manager *cm;
+
+	mutex_lock(&cm_list_mtx);
+
+	list_for_each_entry(cm, &cm_list, entry)
+		stop |= _cm_monitor(cm);
+
+	mutex_unlock(&cm_list_mtx);
+
+	return stop;
+}
+
+/**
+ * cm_setup_timer - For in-suspend monitoring setup wakeup alarm
+ *		    for suspend_again.
+ *
+ * Returns true if the alarm is set for Charger Manager to use.
+ * Returns false if
+ *	cm_setup_timer fails to set an alarm,
+ *	cm_setup_timer does not need to set an alarm for Charger Manager,
+ *	or an alarm previously configured is to be used.
+ */
+static bool cm_setup_timer(void)
+{
+	struct charger_manager *cm;
+	unsigned int wakeup_ms = UINT_MAX;
+	bool ret = false;
+
+	mutex_lock(&cm_list_mtx);
+
+	list_for_each_entry(cm, &cm_list, entry) {
+		/* Skip if polling is not required for this CM */
+		if (!is_polling_required(cm) && !cm->emergency_stop)
+			continue;
+		if (cm->desc->polling_interval_ms == 0)
+			continue;
+		CM_MIN_VALID(wakeup_ms, cm->desc->polling_interval_ms);
+	}
+
+	mutex_unlock(&cm_list_mtx);
+
+	if (wakeup_ms < UINT_MAX && wakeup_ms > 0) {
+		pr_info("Charger Manager wakeup timer: %u ms.\n", wakeup_ms);
+		if (rtc_dev) {
+			struct rtc_wkalrm tmp;
+			unsigned long time, now;
+			unsigned long add = DIV_ROUND_UP(wakeup_ms, 1000);
+
+			/*
+			 * Set alarm with the polling interval (wakeup_ms)
+			 * except when rtc_wkalarm_save comes first.
+			 * However, the alarm time should be NOW +
+			 * CM_RTC_SMALL or later.
+			 */
+			tmp.enabled = 1;
+			rtc_read_time(rtc_dev, &tmp.time);
+			rtc_tm_to_time(&tmp.time, &now);
+			if (add < CM_RTC_SMALL)
+				add = CM_RTC_SMALL;
+			time = now + add;
+
+			ret = true;
+
+			if (rtc_wkalarm_save.enabled && rtc_wkalarm_save_ &&
+			    rtc_wkalarm_save_ < time) {
+				if (rtc_wkalarm_save_ < now + CM_RTC_SMALL)
+					time = now + CM_RTC_SMALL;
+				else
+					time = rtc_wkalarm_save_;
+
+				/* The timer is not appointed by CM */
+				ret = false;
+			}
+
+			pr_info("Waking up after %lu secs.\n",
+					time - now);
+
+			rtc_time_to_tm(time, &tmp.time);
+			rtc_set_alarm(rtc_dev, &tmp);
+			cm_suspend_duration_ms += wakeup_ms;
+			return ret;
+		}
+	}
+
+	if (rtc_dev)
+		rtc_set_alarm(rtc_dev, &rtc_wkalarm_save);
+	return false;
+}
+
+/**
+ * cm_suspend_again - Determine whether suspend again or not
+ *
+ * Returns true if the system should be suspended again
+ * Returns false if the system should be woken up
+ */
+bool cm_suspend_again(void)
+{
+	struct charger_manager *cm;
+	bool ret = false;
+
+	if (!g_desc)
+		return false;
+	if (!g_desc->is_rtc_only_wakeup_reason)
+		return false;
+	if (!g_desc->is_rtc_only_wakeup_reason())
+		return false;
+	if (!cm_rtc_set)
+		return false;
+
+	if (cm_monitor())
+		goto out;
+
+	ret = true;
+	mutex_lock(&cm_list_mtx);
+	list_for_each_entry(cm, &cm_list, entry) {
+		if (cm->status_save_ext_pwr_inserted != is_ext_pwr_online(cm) ||
+		    cm->status_save_batt != is_batt_present(cm))
+			ret = false;
+	}
+	mutex_unlock(&cm_list_mtx);
+
+	cm_rtc_set = cm_setup_timer();
+out:
+	/* It's about the time when the non-CM appointed timer goes off */
+	if (rtc_wkalarm_save.enabled) {
+		unsigned long now;
+		struct rtc_time tmp;
+
+		rtc_read_time(rtc_dev, &tmp);
+		rtc_tm_to_time(&tmp, &now);
+
+		if (rtc_wkalarm_save_ &&
+		    now + CM_RTC_SMALL >= rtc_wkalarm_save_)
+			return false;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cm_suspend_again);
+
+/**
+ * setup_charger_manager - initialize charger_global_desc data
+ * @gd: pointer to instance of charger_global_desc
+ */
+int setup_charger_manager(struct charger_global_desc *gd)
+{
+	if (!gd)
+		return -EINVAL;
+
+	if (rtc_dev)
+		rtc_class_close(rtc_dev);
+	rtc_dev = NULL;
+	g_desc = NULL;
+
+	if (!gd->is_rtc_only_wakeup_reason) {
+		pr_err("The callback is_wktimer_only_wkreason is not given.\n");
+		return -EINVAL;
+	}
+
+	if (gd->rtc) {
+		rtc_dev = rtc_class_open(gd->rtc);
+		if (IS_ERR_OR_NULL(rtc_dev)) {
+			rtc_dev = NULL;
+			/* Retry at probe. RTC may be not registered yet */
+		}
+	} else {
+		pr_warn("No wktimer is given for charger manager."
+			"In-suspend monitoring won't work.\n");
+	}
+
+	g_desc = gd;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(setup_charger_manager);
+
+static int charger_manager_probe(struct platform_device *pdev)
+{
+	struct charger_desc *desc = dev_get_platdata(&pdev->dev);
+	struct charger_manager *cm;
+	int ret = 0, i;
+
+	if (g_desc && !rtc_dev && g_desc->rtc) {
+		rtc_dev = rtc_class_open(g_desc->rtc);
+		if (IS_ERR_OR_NULL(rtc_dev)) {
+			rtc_dev = NULL;
+			dev_err(&pdev->dev, "Cannot get RTC %s.\n",
+				g_desc->rtc);
+			ret = -ENODEV;
+			goto err_alloc;
+		}
+	}
+
+	if (!desc) {
+		dev_err(&pdev->dev, "No platform data (desc) found.\n");
+		ret = -ENODEV;
+		goto err_alloc;
+	}
+
+	cm = kzalloc(sizeof(struct charger_manager), GFP_KERNEL);
+	if (!cm) {
+		dev_err(&pdev->dev, "Cannot allocate memory.\n");
+		ret = -ENOMEM;
+		goto err_alloc;
+	}
+
+	/* Basic Values. Unspecified are Null or 0 */
+	cm->dev = &pdev->dev;
+	cm->desc = desc;
+	cm->last_temp_mC = INT_MIN; /* denotes "unmeasured, yet" */
+
+	if (!desc->charger_regulators || desc->num_charger_regulators < 1) {
+		ret = -EINVAL;
+		dev_err(&pdev->dev, "charger_regulators undefined.\n");
+		goto err_no_charger;
+	}
+
+	ret = regulator_bulk_get(&pdev->dev, desc->num_charger_regulators,
+				 desc->charger_regulators);
+	if (ret) {
+		dev_err(&pdev->dev, "Cannot get charger regulators.\n");
+		goto err_no_charger;
+	}
+
+	if (!desc->psy_charger_stat || !desc->psy_charger_stat[0]) {
+		dev_err(&pdev->dev, "No power supply defined.\n");
+		ret = -EINVAL;
+		goto err_no_charger_stat;
+	}
+
+	for (i = 0; desc->psy_charger_stat[i]; i++)
+		/* Counting index only */ ;
+
+	cm->charger_stat = kzalloc(sizeof(struct power_supply *) * (i + 1),
+				   GFP_KERNEL);
+	if (!cm->charger_stat) {
+		ret = -ENOMEM;
+		goto err_no_charger_stat;
+	}
+
+	for (i = 0; desc->psy_charger_stat[i]; i++) {
+		cm->charger_stat[i] = power_supply_get_by_name(
+					desc->psy_charger_stat[i]);
+		if (!cm->charger_stat[i]) {
+			dev_err(&pdev->dev, "Cannot find power supply "
+					"\"%s\"\n",
+					desc->psy_charger_stat[i]);
+			ret = -ENODEV;
+			goto err_chg_stat;
+		}
+	}
+
+	cm->fuel_gauge = power_supply_get_by_name(desc->psy_fuel_gauge);
+	if (!cm->fuel_gauge) {
+		dev_err(&pdev->dev, "Cannot find power supply \"%s\"\n",
+				desc->psy_fuel_gauge);
+		ret = -ENODEV;
+		goto err_chg_stat;
+	}
+
+	if (desc->polling_interval_ms == 0 ||
+	    msecs_to_jiffies(desc->polling_interval_ms) <= CM_JIFFIES_SMALL) {
+		dev_err(&pdev->dev, "polling_interval_ms is too small\n");
+		ret = -EINVAL;
+		goto err_chg_stat;
+	}
+
+	if (!desc->is_temperature_error) {
+		dev_err(&pdev->dev, "there is no is_temperature_error\n");
+		ret = -EINVAL;
+		goto err_chg_stat;
+	}
+
+	platform_set_drvdata(pdev, cm);
+
+	ret = try_charger_enable(cm, true);
+	if (ret) {
+		dev_err(&pdev->dev, "Cannot enable charger regulators\n");
+		goto err_chg_stat;
+	}
+
+	/* Add to the list */
+	mutex_lock(&cm_list_mtx);
+	list_add(&cm->entry, &cm_list);
+	mutex_unlock(&cm_list_mtx);
+
+	return 0;
+
+err_chg_stat:
+	kfree(cm->charger_stat);
+err_no_charger_stat:
+	if (desc->charger_regulators)
+		regulator_bulk_free(desc->num_charger_regulators,
+					desc->charger_regulators);
+err_no_charger:
+	kfree(cm);
+err_alloc:
+	return ret;
+}
+
+static int __devexit charger_manager_remove(struct platform_device *pdev)
+{
+	struct charger_manager *cm = platform_get_drvdata(pdev);
+	struct charger_desc *desc = cm->desc;
+
+	/* Remove from the list */
+	mutex_lock(&cm_list_mtx);
+	list_del(&cm->entry);
+	mutex_unlock(&cm_list_mtx);
+
+	kfree(cm->charger_stat);
+	if (desc->charger_regulators)
+		regulator_bulk_free(desc->num_charger_regulators,
+					desc->charger_regulators);
+	kfree(cm);
+	return 0;
+}
+
+const struct platform_device_id charger_manager_id[] = {
+	{ "charger-manager", 0 },
+	{ },
+};
+
+static int cm_suspend_prepare(struct device *dev)
+{
+	struct platform_device *pdev = container_of(dev, struct platform_device,
+						    dev);
+	struct charger_manager *cm = platform_get_drvdata(pdev);
+
+	if (!cm_suspended) {
+		if (rtc_dev) {
+			struct rtc_time tmp;
+			unsigned long now;
+
+			rtc_read_alarm(rtc_dev, &rtc_wkalarm_save);
+			rtc_read_time(rtc_dev, &tmp);
+
+			if (rtc_wkalarm_save.enabled) {
+				rtc_tm_to_time(&rtc_wkalarm_save.time,
+					       &rtc_wkalarm_save_);
+				rtc_tm_to_time(&tmp, &now);
+				if (now > rtc_wkalarm_save_)
+					rtc_wkalarm_save_ = 0;
+			} else {
+				rtc_wkalarm_save_ = 0;
+			}
+		}
+		cm_suspended = true;
+	}
+
+	cm->status_save_ext_pwr_inserted = is_ext_pwr_online(cm);
+	cm->status_save_batt = is_batt_present(cm);
+
+	if (!cm_rtc_set) {
+		cm_suspend_duration_ms = 0;
+		cm_rtc_set = cm_setup_timer();
+	}
+
+	return 0;
+}
+
+static void cm_suspend_complete(struct device *dev)
+{
+	struct platform_device *pdev = container_of(dev, struct platform_device,
+						    dev);
+	struct charger_manager *cm = platform_get_drvdata(pdev);
+
+	if (cm_suspended) {
+		if (rtc_dev) {
+			struct rtc_wkalrm tmp;
+
+			rtc_read_alarm(rtc_dev, &tmp);
+			rtc_wkalarm_save.pending = tmp.pending;
+			rtc_set_alarm(rtc_dev, &rtc_wkalarm_save);
+		}
+		cm_suspended = false;
+		cm_rtc_set = false;
+	}
+
+	uevent_notify(cm, NULL);
+}
+
+static const struct dev_pm_ops charger_manager_pm = {
+	.prepare	= cm_suspend_prepare,
+	.complete	= cm_suspend_complete,
+};
+
+static struct platform_driver charger_manager_driver = {
+	.driver = {
+		.name = "charger-manager",
+		.owner = THIS_MODULE,
+		.pm = &charger_manager_pm,
+	},
+	.probe = charger_manager_probe,
+	.remove = __devexit_p(charger_manager_remove),
+	.id_table = charger_manager_id,
+};
+
+static int __init charger_manager_init(void)
+{
+	return platform_driver_register(&charger_manager_driver);
+}
+late_initcall(charger_manager_init);
+
+static void __exit charger_manager_cleanup(void)
+{
+	platform_driver_unregister(&charger_manager_driver);
+}
+module_exit(charger_manager_cleanup);
+
+MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
+MODULE_DESCRIPTION("Charger Manager");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("charger-manager");
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
new file mode 100644
index 0000000..c91e208
--- /dev/null
+++ b/include/linux/power/charger-manager.h
@@ -0,0 +1,131 @@
+/* linux/include/linux/power/charger-manager.h
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ * MyungJoo.Ham <myungjoo.ham@samsung.com>
+ *
+ * Charger Manager.
+ * This framework enables to control and multiple chargers and to
+ * monitor charging even in the context of suspend-to-RAM with
+ * an interface combining the chargers.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+**/
+
+#ifndef _CHARGER_MANAGER_H
+#define _CHARGER_MANAGER_H
+
+#include <linux/power_supply.h>
+
+enum data_source {
+	CM_FUEL_GAUGE,
+	CM_CHARGER_STAT,
+};
+
+enum polling_modes {
+	CM_POLL_DISABLE = 0,
+	CM_POLL_ALWAYS,
+	CM_POLL_EXTERNAL_POWER_ONLY,
+	CM_POLL_CHARGING_ONLY,
+};
+
+/**
+ * struct charger_global_desc
+ * @rtc: the name of RTC used to wake up the system from suspend.
+ * @is_rtc_only_wakeup_reason:
+ *	If the system is woken up by waekup-sources other than the RTC or
+ *	callbacks, Charger Manager should recognize with
+ *	is_rtc_only_wakeup_reason() returning false.
+ *	If the RTC given to CM is the only wakeup reason,
+ *	is_rtc_only_wakeup_reason should return true.
+ */
+struct charger_global_desc {
+	char *rtc;
+
+	bool (*is_rtc_only_wakeup_reason)(void);
+};
+
+/**
+ * struct charger_desc
+ * @polling_mode:
+ *	Determine which polling mode will be used
+ * @polling_interval_ms: interval in millisecond at which
+ *	charger manager will monitor battery health
+ * @battery_present:
+ *	Specify where information for existance of battery can be obtained
+ * @psy_charger_stat: the names of power-supply for chargers
+ * @num_charger_regulator: the number of entries in charger_regulators
+ * @charger_regulators: array of regulator_bulk_data for chargers
+ * @psy_fuel_gauge: the name of power-supply for fuel gauge
+ * @is_temperature_error:
+ *	Determine whether the status is overheat or cold or normal.
+ *	return_value > 0: overheat
+ *	return_value == 0: normal
+ *	return_value < 0: cold
+ */
+struct charger_desc {
+	enum polling_modes polling_mode;
+	unsigned int polling_interval_ms;
+
+	enum data_source battery_present;
+
+	char **psy_charger_stat;
+
+	int num_charger_regulators;
+	struct regulator_bulk_data *charger_regulators;
+
+	char *psy_fuel_gauge;
+
+	int (*is_temperature_error)(int *mC);
+};
+
+#define PSY_NAME_MAX	30
+
+/**
+ * struct charger_manager
+ * @entry: entry for list
+ * @dev: device pointer
+ * @desc: instance of charger_desc
+ * @fuel_gauge: power_supply for fuel gauge
+ * @charger_stat: array of power_supply for chargers
+ * @charger_enabled: the state of charger
+ * @emergency_stop:
+ *	When setting true, stop charging
+ * @last_temp_mC: the measured temperature in milli-Celsius
+ * @status_save_ext_pwr_inserted:
+ *	saved status of external power before entering suspend-to-RAM
+ * @status_save_batt:
+ *	saved status of battery before entering suspend-to-RAM
+ */
+struct charger_manager {
+	struct list_head entry;
+	struct device *dev;
+	struct charger_desc *desc;
+
+	struct power_supply *fuel_gauge;
+	struct power_supply **charger_stat;
+
+	bool charger_enabled;
+
+	int emergency_stop;
+	int last_temp_mC;
+
+	bool status_save_ext_pwr_inserted;
+	bool status_save_batt;
+};
+
+#ifdef CONFIG_CHARGER_MANAGER
+extern int setup_charger_manager(struct charger_global_desc *gd);
+extern bool cm_suspend_again(void);
+#else
+static void __maybe_unused setup_charger_manager(struct charger_global_desc *gd)
+{ }
+
+static bool __maybe_unused cm_suspend_again(void)
+{
+	return false;
+}
+#endif
+
+#endif /* _CHARGER_MANAGER_H */
-- 
1.7.4.1

