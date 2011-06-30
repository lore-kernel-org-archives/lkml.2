Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab1F3Iym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:54:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25797 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1F3Iyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:54:32 -0400
X-AuditID: cbfee61a-b7c53ae000002dc1-3f-4e0c39c6fe77
Date: Thu, 30 Jun 2011 17:54:29 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] power: introduce Charger-Manager
To: linux-pm@lists.linux-foundation.org
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <rdunlap@xenotime.net>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dg77.kim@samsung.com,
        myungjoo.ham@gmail.com, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Message-id: <1309424069-15965-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 30 Jun 2011 08:54:44.0759 (UTC)
 FILETIME=[5B917270:01CC3703]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Charger Manager provides in-kernel battery charger management that
requires temperature monitoring during both normal and suspend-to-RAM states
and where each battery may have multiple chargers attached and the userland
wants to look at the aggregated information of the multiple chargers.

For the discussions about the need for in-suspend monitoring, please
refer to the discussions of suspend-again in PM:
v1 https://lists.linux-foundation.org/pipermail/linux-pm/2011-April/031052.html
v2 https://lists.linux-foundation.org/pipermail/linux-pm/2011-April/031111.html
v3 https://lists.linux-foundation.org/pipermail/linux-pm/2011-May/031267.html
v4 https://lists.linux-foundation.org/pipermail/linux-pm/2011-May/031357.html
v5 (last, applied) https://lists.linux-foundation.org/pipermail/linux-pm/2011-June/031561.html

To see the usage example, please refer to:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/charger-manager
In this git branch, a test code for Exynos4-NURI is shown.

Charger Manager is a platform_driver with power-supply-class entries.
An instance of Charger Manager (a platform-device created with
Charger-Manager) represents a battery with chargers. If there are multiple
batteries with their own chargers acting independently in a system,
the system may need multiple instances of Charger Manager.

Charger Manager glues multiple charger-related frameworks (regulators of
chargers, power-supply-class from chargers and fuel-gauge, RTC,
suspend-again, ...) together to provide aggregated information and
transparent battery monitoring to userspace.

Because battery health monitoring should be done even when suspended,
it needs to wake up and suspend periodically. Thus, userspace battery
monitoring may incur too much overhead; every device and task is waked
up periodically. Charger Manager uses suspend-again (in next PM) to provide
in-suspend monitoring. Multiple chargers (e.g., USB, wireless, and solar
panels) may be included as pairs of a regulator and a power-supply-class
per charger. Charger Manager provides power-supply-class aggregating
information from multiple chargers and a fuel-gauge and UEVENT notifying
status changes.  Multiple instances of Charger Manager enable multiple
batteries.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/power/charger-manager.txt |  210 +++++
 drivers/power/Kconfig                   |    9 +
 drivers/power/Makefile                  |    1 +
 drivers/power/charger-manager.c         | 1548 +++++++++++++++++++++++++++++++
 include/linux/power/charger-manager.h   |  220 +++++
 5 files changed, 1988 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/power/charger-manager.txt
 create mode 100644 drivers/power/charger-manager.c
 create mode 100644 include/linux/power/charger-manager.h

diff --git a/Documentation/power/charger-manager.txt b/Documentation/power/charger-manager.txt
new file mode 100644
index 0000000..dcdee43
--- /dev/null
+++ b/Documentation/power/charger-manager.txt
@@ -0,0 +1,210 @@
+Charger Manager
+	(C) 2011 MyungJoo Ham <myungjoo.ham@samsung.com>, GPL
+
+Charger Manager provides in-kernel battery charger management that
+requires temperature monitoring during both normal and suspend-to-RAM states
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
+	shows combined information as a single power-supply-clas.
+
+* Support for in suspend-to-RAM polling (w/ suspend_again callback)
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
+* Support for premature full-battery event handling
+	If the battery voltage drops by "fullbatt_vchkdrop_uV" after
+	"fullbatt_vchkdrop_ms" from the full-battery event, the framework
+	restarts charging. This check is also performed while suspended by
+	setting wakeup time accordingly and using suspend_again.
+
+* Support for uevent-notify
+	With the charger-related events (and user defined IRQs), the device
+	sends notification to users with UEVENT.
+
+2. Global Chager-Manager Data related with suspend_again
+========================================================
+In order to setup Charger Manager with suspend-again feature
+(in-suspend monitoring), the user should provide charger_global_desc
+with setup_charger_manager(struct charger_global_desc *);.
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
+
+bool assume_timer_stops_in_suspend;
+	: if true, Charger Manager assumes that
+	the timer (CM uses jiffies as timer) stops during suspend. Then, CM
+	assumes that the suspend-duration is same as the alarm length.
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
+if the system was waken up by Charger Manager and the polling
+(in-suspend monitoring) results in "normal".
+
+4. Charger-Manager Data (struct charger_desc)
+=============================================
+For each battery charged independently from other batteries (if a series of
+batteries are chaged by a single charger, they are counted as one independent
+battery), an instance of Charger Manager is attached to it.
+
+struct charger_desc {
+
+char *psy_name;
+	: The power-supply-class name of the battery. Default is
+	"battery" if psy_name is NULL. Users can access the psy entries
+	at "/sys/class/power_supply/[psy_name]/".
+
+enum polling_modes polling_mode;
+	: CM_POLL_DISABLE: do not poll this battery.
+	  CM_POLL_ALWAYS: always poll this battery.
+	  CM_POLL_EXTERNAL_POWER_ONLY: poll this battery if and only if
+	an external power source is attached.
+	  CM_POLL_CHARGING_ONLY: poll this battery if and only if the
+	battery is being charged.
+
+unsigned int polling_interval_ms;
+	: Required polling interval in ms. Charger Manager will poll
+	this battery every polling_interval_ms or more frequently.
+
+unsigned int fullbatt_vchkdrop_ms;
+unsigned int fullbatt_vchkdrop_uV;
+	: If both have non-zero values, Charger Manager will check the
+	battery voltage drop fullbatt_vchkdrop_ms after the battery is fully
+	charged. If the voltage drop is over fullbatt_vchkdrop_uV, Charger
+	Manager will try to recharge the battery by disabling and enabling
+	chargers. Recharge with voltage drop condition only (without delay
+	condition) is needed to be implemented with hardware interrupts from
+	fuel gauges or charger devices/chips.
+
+unsigned int fullbatt_uV;
+	: If specified with a non-zero value, Charger Manager assumes
+	that the battery is full (capacity = 100) if the battery is not being
+	charged and the battery voltage is equal to or greater than
+	fullbatt_uV.
+
+enum data_source battery_present;
+	: CM_ASSUME_ALWAYS_TRUE: assume that the battery exists.
+	CM_ASSUME_ALWAYS_FALSE: assume that the battery does not exists.
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
+struct regulator_bulk_dta *charger_regulators;
+	: Regulators representing the chargers in the form for
+	regulator framework's bulk functions.
+
+char *psy_fuel_gauge;
+	: Power-supply-class name of the fuel gauge.
+
+struct charger_irq *irqs;
+	: An array ending with NULL that has battery/charger-related interrupt
+	information for Charger Manager. An IRQ of CM_IRQ_BATT_FULL should be
+	included in the array. Although other battery/charger-related
+	interrupts are not mandatory, it is recommended to include them all
+	in order to let userspace be notified of battery/charger-related
+	events.
+
+int (*is_temperature_error)(int *mC);
+bool measure_ambient_temp;
+bool measure_battery_temp;
+	: This callback returns 0 if the temperature is safe for charging,
+	a positive number if it is too hot to charge, and a negative number
+	if it is too cold to charge. With the variable mC, the callback returns
+	the temperature in 1/1000 of centigrade. measure_[ambient/battery]_temp
+	shows the temperature is whether ambient temperature or battery
+	temperature.
+};
+
+5. Notify events that do not have IRQs: cm_notify_event()
+=========================================================
+If there is an event that cannot generate interrupt but is required to notify
+Charger Manager, a device driver that triggers the event can call
+cm_notify_event(cm, type, msg) to notify the corresponding Charger Manager.
+In the function, cm_notify_event, cm is the Charger Manager pointer, which
+can be looked up with get_charger_manager(psy_name). The parameter "type"
+is the same as irq's type (enum cm_irq_types). The event message "msg" is
+optional and is effective only if the event type is "UNDESCRIBED" or "OTHERS".
+
+6. Other Considerations
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
index 2d1d0c1..4d3d9c8 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -235,6 +235,15 @@ config CHARGER_GPIO
 	  This driver can be build as a module. If so, the module will be
 	  called gpio-charger.
 
+config CHARGER_MANAGER
+        tristate "Battery charger manager for multiple chargers"
+        help
+          Say Y to enable charger-manager support, which allows multiple
+          chargers attached to a battery and multiple batteries attached to a
+          system. The charger-manager also can monitor charging status in
+          runtime and in suspend-to-RAM by waking up the system periodically
+          with help of pm-loop support.
+
 config CHARGER_MAX8997
 	tristate "Maxim MAX8997/MAX8966 PMIC battery charger driver"
 	depends on MFD_MAX8997 && REGULATOR_MAX8997
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index a98ffaa..7e31ea3 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -36,4 +36,5 @@ obj-$(CONFIG_CHARGER_ISP1704)	+= isp1704_charger.o
 obj-$(CONFIG_CHARGER_MAX8903)	+= max8903_charger.o
 obj-$(CONFIG_CHARGER_TWL4030)	+= twl4030_charger.o
 obj-$(CONFIG_CHARGER_GPIO)	+= gpio-charger.o
+obj-$(CONFIG_CHARGER_MANAGER)   += charger-manager.o
 obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
new file mode 100644
index 0000000..894c2a4
--- /dev/null
+++ b/drivers/power/charger-manager.c
@@ -0,0 +1,1548 @@
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
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/rtc.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include <linux/platform_device.h>
+#include <linux/power/charger-manager.h>
+#include <linux/regulator/consumer.h>
+
+static const char * const default_irq_names[] = {
+	[CM_IRQ_UNDESCRIBED] = "Undescribed",
+	[CM_IRQ_BATT_FULL] = "Battery Full",
+	[CM_IRQ_BATT_IN] = "Battery Inserted",
+	[CM_IRQ_BATT_OUT] = "Battery Pulled Out",
+	[CM_IRQ_EXT_PWR_IN_OUT] = "External Power Attach/Detach",
+	[CM_IRQ_CHG_START_STOP] = "Charging Start/Stop",
+	[CM_IRQ_OTHERS] = "Other battery events"
+};
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
+LIST_HEAD(cm_list);
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
+/* About normal (not suspended) monitoring */
+static unsigned long polling_jiffy = ULONG_MAX; /* ULONG_MAX: no polling */
+static unsigned long next_polling; /* Next appointed polling time */
+static struct workqueue_struct *cm_wq; /* init at driver add */
+static struct delayed_work cm_monitor_work; /* init at driver add */
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
+	case CM_ASSUME_ALWAYS_TRUE:
+		present = true;
+		break;
+	case CM_ASSUME_ALWAYS_FALSE:
+		present = false;
+		break;
+	case CM_FUEL_GAUGE:
+		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
+				POWER_SUPPLY_PROP_PRESENT, &val);
+		if (ret == 0 && val.intval)
+			present = true;
+		break;
+	case CM_CHARGER_STAT:
+		/* If one of them thinks it exists, it exists. */
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
+ * get_batt_uV - Get the voltage level of the battery
+ * @cm: the Charger Manager representing the battery.
+ * @uV: the voltage level returned.
+ *
+ * Returns 0 if there is no error.
+ * Returns a negative value on error.
+ */
+static int get_batt_uV(struct charger_manager *cm, int *uV)
+{
+	union power_supply_propval val;
+	int ret;
+
+	if (cm->fuel_gauge)
+		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
+				POWER_SUPPLY_PROP_VOLTAGE_NOW, &val);
+	else
+		return -ENODEV;
+
+	if (ret)
+		return ret;
+
+	*uV = val.intval;
+	return 0;
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
+		if (cm->user_prohibit)
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
+ * try_charger_enable - Enable/Disable chargers altogether
+ * @cm: the Charger Manager representing the battery.
+ * @enable: true: enable / false: force_disable
+ *
+ * Note that Charger Manager keeps the charger enabled regardless whether
+ * the charger is charging or not (because battery is full or no external
+ * power source exists) except when CM needs to disable chargers forcibly
+ * bacause of emergency causes; when the battery is overheated of too cold.
+ */
+static int try_charger_enable(struct charger_manager *cm, bool enable)
+{
+	int i;
+	int err = 0;
+	struct charger_desc *desc = cm->desc;
+
+	/* Ignore if it's redundent command */
+	if (enable && cm->charger_enabled)
+		return 0;
+	if (!enable && !cm->charger_enabled)
+		return 0;
+
+	if (enable) {
+		if (cm->emergency_stop || cm->user_prohibit)
+			return -EAGAIN; /* Do it again later */
+		err = regulator_bulk_enable(desc->num_charger_regulators,
+					desc->charger_regulators);
+	} else {
+		for (i = 0; i < desc->num_charger_regulators; i++)
+			regulator_force_disable(desc->charger_regulators[i].
+						consumer);
+	}
+
+	if (!err)
+		cm->charger_enabled = enable;
+
+	return err;
+}
+
+/**
+ * try_charger_restart - Restart charging.
+ * @cm: the Charger Manager representing the battery.
+ *
+ * Restart charging by turning off and on the charger.
+ */
+static int try_charger_restart(struct charger_manager *cm)
+{
+	int err;
+
+	if (cm->emergency_stop)
+		return -EAGAIN;
+	if (cm->user_prohibit)
+		return -EAGAIN;
+
+	err = try_charger_enable(cm, false);
+	if (err)
+		return err;
+
+	return try_charger_enable(cm, true);
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
+	/* It's called at RESUME */
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
+	/* The system is running and it's not in resume */
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
+ * fullbatt_vchk - Check voltage drop some times after "FULL" event.
+ * @work: the work_struct appointing the function
+ *
+ * If a user has designated "fullbatt_vchkdrop_ms/uV" values with
+ * charger_desc, Charger Manager checks voltage drop after the battery
+ * "FULL" event. It checks whether the voltage has dropped more than
+ * fullbatt_vchkdrop_uV by calling this function after fullbatt_vchkrop_ms.
+ */
+static void fullbatt_vchk(struct work_struct *work)
+{
+	struct delayed_work *dwork =
+		container_of(work, struct delayed_work, work);
+	struct charger_manager *cm = container_of(dwork,
+			struct charger_manager, fullbatt_vchk_work);
+	struct charger_desc *desc = cm->desc;
+	int batt_uV, err;
+
+	/* remove the appointment for fullbatt_vchk */
+	cm->fullbatt_vchk_jiffies_at = 0;
+
+	if (!desc->fullbatt_vchkdrop_uV || !desc->fullbatt_vchkdrop_ms)
+		return;
+
+	err = get_batt_uV(cm, &batt_uV);
+	if (err) {
+		dev_err(cm->dev, "%s: get_batt_uV error(%d).\n", __func__, err);
+		return;
+	}
+
+	dev_dbg(cm->dev, "VBATT dropped %uuV after full-batt.\n",
+		 cm->fullbatt_vchk_uV - batt_uV);
+
+	if ((cm->fullbatt_vchk_uV - batt_uV) > desc->fullbatt_vchkdrop_uV) {
+		try_charger_restart(cm);
+		uevent_notify(cm, "Recharge");
+	}
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
+		try_charger_enable(cm, false);
+		if (temp > 0)
+			uevent_notify(cm, "OVERHEAT");
+		else
+			uevent_notify(cm, "COLD");
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
+ * _setup_polling - Setup the next instance of polling.
+ * @work: work_struct of the function _setup_polling.
+ */
+static void _setup_polling(struct work_struct *work)
+{
+	unsigned long min = ULONG_MAX;
+	struct charger_manager *cm;
+	bool keep_polling = false;
+	unsigned long _next_polling;
+
+	mutex_lock(&cm_list_mtx);
+
+	list_for_each_entry(cm, &cm_list, entry) {
+		if (is_polling_required(cm) && cm->desc->polling_interval_ms) {
+			keep_polling = true;
+
+			if (min > cm->desc->polling_interval_ms)
+				min = cm->desc->polling_interval_ms;
+		}
+	}
+
+	polling_jiffy = msecs_to_jiffies(min);
+	if (polling_jiffy <= CM_JIFFIES_SMALL)
+		polling_jiffy = CM_JIFFIES_SMALL + 1;
+
+	if (!keep_polling)
+		polling_jiffy = ULONG_MAX;
+	if (polling_jiffy == ULONG_MAX)
+		goto out;
+
+	WARN(cm_wq == NULL, "charger-manager: workqueue not initialized"
+			    ". try it later. %s\n", __func__);
+
+	_next_polling = jiffies + polling_jiffy;
+
+	if (!delayed_work_pending(&cm_monitor_work) ||
+	    (delayed_work_pending(&cm_monitor_work) &&
+	     time_after(next_polling, _next_polling))) {
+		cancel_delayed_work(&cm_monitor_work);
+		next_polling = jiffies + polling_jiffy;
+		queue_delayed_work(cm_wq, &cm_monitor_work, polling_jiffy);
+	}
+
+out:
+	mutex_unlock(&cm_list_mtx);
+}
+static DECLARE_WORK(setup_polling, _setup_polling);
+
+/**
+ * cm_monitor_poller - The Monitor / Poller.
+ * @work: work_struct of the function cm_monitor_poller
+ *
+ * During non-suspended state, cm_monitor_poller is used to poll and monitor
+ * the batteries.
+ */
+static void cm_monitor_poller(struct work_struct *work)
+{
+	cm_monitor();
+	schedule_work(&setup_polling);
+}
+
+/**
+ * fullbatt_handler - Interrupt handler for CM_IRQ_BATT_FULL
+ * @irq: irq number
+ * @data: the Charger Manager representing the battery.
+ */
+static irqreturn_t fullbatt_handler(int irq, void *data)
+{
+	struct charger_manager *cm = data;
+	struct charger_desc *desc = cm->desc;
+
+	if (!desc->fullbatt_vchkdrop_uV || !desc->fullbatt_vchkdrop_ms)
+		goto out;
+
+	if (cm_suspended)
+		cm->cancel_suspend = true;
+
+	cancel_delayed_work(&cm->fullbatt_vchk_work);
+	queue_delayed_work(cm_wq, &cm->fullbatt_vchk_work,
+			   msecs_to_jiffies(desc->fullbatt_vchkdrop_ms));
+	cm->fullbatt_vchk_jiffies_at = jiffies + msecs_to_jiffies(
+				       desc->fullbatt_vchkdrop_ms);
+
+	if (cm->fullbatt_vchk_jiffies_at == 0)
+		cm->fullbatt_vchk_jiffies_at = 1;
+
+out:
+	dev_info(cm->dev, "IRQHANDLE: Battery Fully Charged.\n");
+	uevent_notify(cm, default_irq_names[CM_IRQ_BATT_FULL]);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * battout_handler - Interrupt handler for CM_BATT_OUT
+ * @irq: irq number
+ * @data: the Charger Manager representing the battery.
+ */
+static irqreturn_t battout_handler(int irq, void *data)
+{
+	struct charger_manager *cm = data;
+
+	if (cm_suspended)
+		cm->cancel_suspend = true;
+
+	if (!is_batt_present(cm)) {
+		dev_emerg(cm->dev, "Battery Pulled Out!\n");
+		uevent_notify(cm, default_irq_names[CM_IRQ_BATT_OUT]);
+	} else {
+		uevent_notify(cm, "Battery Reinserted?");
+	}
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * misc_event_handler - Handler for other interrupts w/ wakeup=false
+ * @irq: irq number
+ * @data: the Charger Manager representing the battery.
+ */
+static irqreturn_t misc_event_handler(int irq, void *data)
+{
+	struct charger_manager *cm = data;
+	char buf[UEVENT_BUF_SIZE + 1];
+
+	sprintf(buf, "IRQ %d", irq);
+	uevent_notify(cm, buf);
+
+	if (!delayed_work_pending(&cm_monitor_work) &&
+	    is_polling_required(cm) && cm->desc->polling_interval_ms)
+		schedule_work(&setup_polling);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * misc_event_handler_force_wk - Handler for other interrupts w/ wakeup=true
+ * @irq: irq number
+ * @data: the Charger Manager representing the battery.
+ */
+static irqreturn_t misc_event_handler_force_wk(int irq, void *data)
+{
+	struct charger_manager *cm = data;
+	char buf[UEVENT_BUF_SIZE + 1];
+
+	if (cm_suspended)
+		cm->cancel_suspend = true;
+
+	sprintf(buf, "IRQ %d", irq);
+	uevent_notify(cm, buf);
+
+	if (!delayed_work_pending(&cm_monitor_work) &&
+	    is_polling_required(cm) && cm->desc->polling_interval_ms)
+		schedule_work(&setup_polling);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * cm_setup_timer - For in-suspend monitoring setup wakeup alarm for suspend_again.
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
+		unsigned int fbchk_ms = 0;
+
+		/* fullbatt_vchk is required. setup timer for that */
+		if (cm->fullbatt_vchk_jiffies_at) {
+			fbchk_ms = jiffies_to_msecs(cm->fullbatt_vchk_jiffies_at
+						    - jiffies);
+			if (cm->fullbatt_vchk_jiffies_at <= jiffies ||
+				msecs_to_jiffies(fbchk_ms) < CM_JIFFIES_SMALL) {
+				fullbatt_vchk(&cm->fullbatt_vchk_work.work);
+				fbchk_ms = 0;
+			}
+		}
+		CM_MIN_VALID(wakeup_ms, fbchk_ms);
+
+		/* Skip if polling is not required for this CM */
+		if (!is_charging(cm) && !cm->emergency_stop)
+			continue;
+		if (cm->desc->polling_interval_ms == 0)
+			continue;
+		CM_MIN_VALID(wakeup_ms, cm->desc->polling_interval_ms);
+	}
+
+	/* TODO: Reviewing Here */
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
+static int charger_get_property(struct power_supply *psy,
+		enum power_supply_property psp,
+		union power_supply_propval *val)
+{
+	struct charger_manager *cm = container_of(psy,
+			struct charger_manager, charger_psy);
+	struct charger_desc *desc = cm->desc;
+	int i, ret = 0, uV;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		if (is_charging(cm))
+			val->intval = POWER_SUPPLY_STATUS_CHARGING;
+		else if (is_ext_pwr_online(cm))
+			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
+		else
+			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+		break;
+	case POWER_SUPPLY_PROP_HEALTH:
+		if (cm->emergency_stop > 0)
+			val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
+		else if (cm->emergency_stop < 0)
+			val->intval = POWER_SUPPLY_HEALTH_COLD;
+		else
+			val->intval = POWER_SUPPLY_HEALTH_GOOD;
+		break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		if (is_batt_present(cm))
+			val->intval = 1;
+		else
+			val->intval = 0;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		ret = get_batt_uV(cm, &i);
+		val->intval = i;
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
+				POWER_SUPPLY_PROP_CURRENT_NOW, val);
+		break;
+	case POWER_SUPPLY_PROP_TEMP:
+		/* in thenth of centigrade */
+		if (cm->last_temp_mC == INT_MIN)
+			desc->is_temperature_error(&cm->last_temp_mC);
+		val->intval = cm->last_temp_mC / 100;
+		if (!desc->measure_battery_temp)
+			ret = -ENODEV;
+		break;
+	case POWER_SUPPLY_PROP_TEMP_AMBIENT:
+		/* in thenth of centigrade */
+		if (cm->last_temp_mC == INT_MIN)
+			desc->is_temperature_error(&cm->last_temp_mC);
+		val->intval = cm->last_temp_mC / 100;
+		if (!desc->measure_ambient_temp)
+			ret = -ENODEV;
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		if (!cm->fuel_gauge) {
+			ret = -ENODEV;
+			break;
+		}
+
+		if (!is_batt_present(cm)) {
+			/* There is no battery. Assume 100% */
+			val->intval = 100;
+			break;
+		}
+
+		ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
+					POWER_SUPPLY_PROP_CAPACITY, val);
+		if (ret)
+			break;
+
+		if (val->intval > 100) {
+			/* More than 100%? */
+			val->intval = 100;
+			break;
+		}
+		if (val->intval < 0) {
+			/* Lower than 0%? */
+			val->intval = 0;
+		}
+
+		/* Do not adjust SOC when charging: voltage is overrated */
+		if (is_charging(cm))
+			break;
+
+		/*
+		 * If the capacity value is inconsistent, calibrate it base on
+		 * the battery voltage values and the thresholds given as desc
+		 */
+		ret = get_batt_uV(cm, &uV);
+		if (ret) {
+			/* Voltage information not available. No calibration */
+			ret = 0;
+			break;
+		}
+
+		if (desc->fullbatt_uV > 0 && uV >= desc->fullbatt_uV &&
+		    !is_charging(cm)) {
+			val->intval = 100;
+			break;
+		}
+
+		break;
+	case POWER_SUPPLY_PROP_ONLINE:
+		if (is_ext_pwr_online(cm))
+			val->intval = 1;
+		else
+			val->intval = 0;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_FULL:
+		if (is_ext_pwr_online(cm)) {
+			/* Not full if it's charging. */
+			if (is_charging(cm)) {
+				val->intval = 0;
+				break;
+			}
+			/*
+			 * Full if it's powered but not charging andi
+			 * not forced stop by emergency
+			 */
+			if (!cm->emergency_stop) {
+				val->intval = 1;
+				break;
+			}
+		}
+
+		/* FIXME: use STATUS information */
+
+		/* Full if it's over the fullbatt voltage */
+		ret = get_batt_uV(cm, &uV);
+		if (!ret && desc->fullbatt_uV > 0 && uV >= desc->fullbatt_uV &&
+		    !is_charging(cm)) {
+			val->intval = 1;
+			break;
+		}
+
+		/* Full if the cap is 100 */
+		if (cm->fuel_gauge) {
+			ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
+					POWER_SUPPLY_PROP_CAPACITY, val);
+			if (!ret && val->intval >= 100 && !is_charging(cm)) {
+				val->intval = 1;
+				break;
+			}
+		}
+
+		val->intval = 0;
+		ret = 0;
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_NOW:
+		if (is_charging(cm)) {
+			ret = cm->fuel_gauge->get_property(cm->fuel_gauge,
+						POWER_SUPPLY_PROP_CHARGE_NOW,
+						val);
+			if (ret) {
+				val->intval = 1;
+				ret = 0;
+			} else {
+				/* If CHARGE_NOW is supplied, use it */
+				val->intval = (val->intval > 0) ?
+						val->intval : 1;
+			}
+		} else {
+			val->intval = 0;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+	return ret;
+}
+
+#define NUM_CHARGER_PSY_OPTIONAL	(4)
+static enum power_supply_property default_charger_props[] = {
+	/* Guaranteed to provide */
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_CHARGE_FULL,
+	/*
+	 * Optional properties are:
+	 * POWER_SUPPLY_PROP_CHARGE_NOW,
+	 * POWER_SUPPLY_PROP_CURRENT_NOW,
+	 * POWER_SUPPLY_PROP_TEMP, and
+	 * POWER_SUPPLY_PROP_TEMP_AMBIENT,
+	 */
+};
+
+static struct power_supply psy_default = {
+	.name = "battery",
+	.type = POWER_SUPPLY_TYPE_BATTERY, /* Need to reconsider */
+	/* .supplied_to = {"battery"}, */
+	/* .num_supplicants = 1, */
+	.properties = default_charger_props,
+	.num_properties = ARRAY_SIZE(default_charger_props),
+	.get_property = charger_get_property,
+};
+
+static bool _cm_fbchk_in_suspend(struct charger_manager *cm)
+{
+	unsigned long jiffy_now = jiffies;
+
+	if (!cm->fullbatt_vchk_jiffies_at)
+		return false;
+
+	if (g_desc && g_desc->assume_timer_stops_in_suspend)
+		jiffy_now += msecs_to_jiffies(cm_suspend_duration_ms);
+
+	/* Execute now if it's going to be executed not too long after */
+	jiffy_now += CM_JIFFIES_SMALL;
+
+	if (time_after_eq(jiffy_now, cm->fullbatt_vchk_jiffies_at)) {
+		fullbatt_vchk(&cm->fullbatt_vchk_work.work);
+		return true;
+	}
+
+	return false;
+}
+
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
+	if (cm_wq == NULL) /* CM not initialized */
+		return false;
+
+	if (cm_monitor())
+		goto out;
+
+	ret = true;
+	mutex_lock(&cm_list_mtx);
+	list_for_each_entry(cm, &cm_list, entry) {
+		_cm_fbchk_in_suspend(cm);
+
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
+		/* TODO: Test rtc aie handlers' reaction to this */
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cm_suspend_again);
+
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
+bool is_charger_manager_active(void)
+{
+	/* Should have called setup_charger_manager */
+	if (!g_desc)
+		return false;
+
+	/* Should have at least one instance of charger_manager */
+	if (list_empty(&cm_list))
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(is_charger_manager_active);
+
+static int charger_manager_probe(struct platform_device *pdev)
+{
+	struct charger_desc *desc = dev_get_platdata(&pdev->dev);
+	struct charger_manager *cm;
+	int ret = 0, i;
+	union power_supply_propval val;
+	bool batt_full_registered = false;
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
+
+	/*
+	 * The following two do not need to be errors.
+	 * Users may intentionally ignore those two features.
+	 */
+	if (desc->fullbatt_uV == 0) {
+		dev_info(&pdev->dev, "Ignoring full-battery voltage threshold"
+					" as it is not supplied.");
+	}
+	if (!desc->fullbatt_vchkdrop_ms || !desc->fullbatt_vchkdrop_uV) {
+		dev_info(&pdev->dev, "Disabling full-battery voltage drop "
+				"checking mechanism as it is not supplied.");
+		desc->fullbatt_vchkdrop_ms = 0;
+		desc->fullbatt_vchkdrop_uV = 0;
+	}
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
+	memcpy(&cm->charger_psy, &psy_default,
+				sizeof(psy_default));
+	if (!desc->psy_name) {
+		strncpy(cm->psy_name_buf, psy_default.name,
+				PSY_NAME_MAX);
+	} else {
+		strncpy(cm->psy_name_buf, desc->psy_name, PSY_NAME_MAX);
+	}
+	cm->charger_psy.name = cm->psy_name_buf;
+
+	/* Allocate for psy properties because they may vary */
+	cm->charger_psy.properties = kzalloc(sizeof(enum power_supply_property)
+				* (ARRAY_SIZE(default_charger_props) +
+				NUM_CHARGER_PSY_OPTIONAL),
+				GFP_KERNEL);
+	if (!cm->charger_psy.properties) {
+		dev_err(&pdev->dev, "Cannot allocate for psy properties.\n");
+		ret = -ENOMEM;
+		goto err_chg_stat;
+	}
+	memcpy(cm->charger_psy.properties, default_charger_props,
+		sizeof(enum power_supply_property) *
+		ARRAY_SIZE(default_charger_props));
+	cm->charger_psy.num_properties = psy_default.num_properties;
+
+	/* Find which optional psy-properties are available */
+	if (!cm->fuel_gauge->get_property(cm->fuel_gauge,
+					  POWER_SUPPLY_PROP_CHARGE_NOW, &val)) {
+		cm->charger_psy.properties[cm->charger_psy.num_properties] =
+				POWER_SUPPLY_PROP_CHARGE_NOW;
+		cm->charger_psy.num_properties++;
+	}
+	if (!cm->fuel_gauge->get_property(cm->fuel_gauge,
+					  POWER_SUPPLY_PROP_CURRENT_NOW,
+					  &val)) {
+		cm->charger_psy.properties[cm->charger_psy.num_properties] =
+				POWER_SUPPLY_PROP_CURRENT_NOW;
+		cm->charger_psy.num_properties++;
+	}
+	if (desc->measure_ambient_temp) {
+		cm->charger_psy.properties[cm->charger_psy.num_properties] =
+				POWER_SUPPLY_PROP_TEMP_AMBIENT;
+		cm->charger_psy.num_properties++;
+	}
+	if (desc->measure_battery_temp) {
+		cm->charger_psy.properties[cm->charger_psy.num_properties] =
+				POWER_SUPPLY_PROP_TEMP;
+		cm->charger_psy.num_properties++;
+	}
+
+	if (!desc->irqs || !desc->irqs[0].irq) {
+		dev_err(&pdev->dev, "No IRQs specified");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* Fullbat vchk should be ready before registering irq handlers */
+	INIT_DELAYED_WORK(&cm->fullbatt_vchk_work, fullbatt_vchk);
+
+	try_charger_enable(cm, true);
+
+	for (i = 0; desc->irqs[i].irq; i++) {
+		struct charger_irq *irq = &desc->irqs[i];
+
+		ret = 0;
+		switch (irq->cm_irq_type) {
+		case CM_IRQ_BATT_FULL:
+			ret = request_threaded_irq(irq->irq, NULL,
+					fullbatt_handler, irq->flags,
+					irq->name ? irq->name :
+					default_irq_names[CM_IRQ_BATT_FULL],
+					cm);
+			batt_full_registered = true;
+			break;
+		case CM_IRQ_BATT_OUT:
+			ret = request_threaded_irq(irq->irq, NULL,
+					battout_handler, irq->flags,
+					irq->name ? irq->name :
+					default_irq_names[CM_IRQ_BATT_OUT],
+					cm);
+			break;
+		default:
+			ret = request_threaded_irq(irq->irq, NULL,
+				irq->wakeup ? misc_event_handler_force_wk :
+					      misc_event_handler,
+				irq->flags, irq->name ? irq->name :
+				default_irq_names[irq->cm_irq_type], cm);
+			break;
+		}
+
+		if (ret) {
+			dev_err(&pdev->dev,
+				"IRQ %d (%s/%s) has an error(%d).\n",
+				irq->irq, default_irq_names[irq->cm_irq_type],
+				irq->name, ret);
+			for (i = i - 1; i >= 0; i--)
+				free_irq(desc->irqs[i].irq, cm);
+			goto err;
+		}
+
+		dev_dbg(&pdev->dev, "Interupt handler for %s(%s) @ IRQ %d"
+				    " is registered.\n",
+				    default_irq_names[irq->cm_irq_type],
+				    irq->name, irq->irq);
+	}
+
+	if (!batt_full_registered) {
+		dev_err(&pdev->dev, "Interrupt handler for %s is required.\n",
+				default_irq_names[CM_IRQ_BATT_FULL]);
+		ret = EINVAL;
+		goto err_irq;
+	}
+
+	if (power_supply_register(NULL, &cm->charger_psy)) {
+		dev_err(&pdev->dev, "Cannot register charger-manager with"
+				" name \"%s\".\n", cm->charger_psy.name);
+		ret = -EINVAL;
+		goto err_irq;
+	}
+
+	/* Add to the list */
+	mutex_lock(&cm_list_mtx);
+	list_add(&cm->entry, &cm_list);
+	mutex_unlock(&cm_list_mtx);
+
+	schedule_work(&setup_polling);
+
+	return 0;
+
+err_irq:
+	for (i = 0; desc->irqs[i].irq; i++)
+		free_irq(desc->irqs[i].irq, cm);
+err:
+	kfree(cm->charger_psy.properties);
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
+	int i;
+
+	/* Remove from the list */
+	mutex_lock(&cm_list_mtx);
+	list_del(&cm->entry);
+	mutex_unlock(&cm_list_mtx);
+
+	schedule_work(&setup_polling);
+
+	for (i = 0; desc->irqs[i].irq; i++)
+		free_irq(desc->irqs[i].irq, cm);
+
+	power_supply_unregister(&cm->charger_psy);
+
+	kfree(cm->charger_psy.properties);
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
+static int cm_suspend_noirq(struct device *dev)
+{
+	struct platform_device *pdev = container_of(dev, struct platform_device,
+						    dev);
+	struct charger_manager *cm = platform_get_drvdata(pdev);
+
+	if (cm->cancel_suspend) {
+		cm->cancel_suspend = false;
+		return -EAGAIN;
+	}
+
+	return 0;
+}
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
+	cancel_delayed_work(&cm->fullbatt_vchk_work);
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
+	/* Re-enqueue delayed work (fullbatt_vchk_work) */
+	if (cm->fullbatt_vchk_jiffies_at) {
+		unsigned long delay = 0;
+		unsigned long now = jiffies;
+
+		if (time_after_eq(now + CM_JIFFIES_SMALL,
+				  cm->fullbatt_vchk_jiffies_at)) {
+			delay = (unsigned long)((long)(now + CM_JIFFIES_SMALL)
+				- (long)(cm->fullbatt_vchk_jiffies_at));
+			delay = jiffies_to_msecs(delay);
+		} else {
+			delay = 0;
+		}
+
+		/*
+		 * Account for cm_suspend_duration_ms if
+		 * assume_timer_stops_in_suspend is active
+		 */
+		if (g_desc && g_desc->assume_timer_stops_in_suspend) {
+			if (delay > cm_suspend_duration_ms)
+				delay -= cm_suspend_duration_ms;
+			else
+				delay = 0;
+		}
+
+		queue_delayed_work(cm_wq, &cm->fullbatt_vchk_work,
+				   msecs_to_jiffies(delay));
+	}
+	cm->cancel_suspend = false;
+	uevent_notify(cm, NULL);
+}
+
+static const struct dev_pm_ops charger_manager_pm = {
+	.prepare	= cm_suspend_prepare,
+	.suspend_noirq	= cm_suspend_noirq,
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
+	cm_wq = create_freezable_workqueue("charger_manager");
+	INIT_DELAYED_WORK(&cm_monitor_work, cm_monitor_poller);
+
+	return platform_driver_register(&charger_manager_driver);
+}
+/*
+ * The probe function should be called after every related driver has been
+ * probed and ready.
+ */
+late_initcall(charger_manager_init);
+
+static void __exit charger_manager_cleanup(void)
+{
+	destroy_workqueue(cm_wq);
+	cm_wq = NULL;
+
+	platform_driver_unregister(&charger_manager_driver);
+}
+module_exit(charger_manager_cleanup);
+
+void cm_notify_event(struct charger_manager *cm, enum cm_irq_types type,
+		     char *msg)
+{
+	switch (type) {
+	case CM_IRQ_BATT_FULL:
+		dev_info(cm->dev, "NOTIFY: Battery Fully Charged.\n");
+		uevent_notify(cm, "Battery Fully Charged.");
+
+		if (!cm->desc->fullbatt_vchkdrop_uV ||
+		    !cm->desc->fullbatt_vchkdrop_ms)
+			break;
+
+		cancel_delayed_work(&cm->fullbatt_vchk_work);
+		schedule_delayed_work(&cm->fullbatt_vchk_work, msecs_to_jiffies(
+					cm->desc->fullbatt_vchkdrop_ms));
+		cm->fullbatt_vchk_jiffies_at = jiffies + msecs_to_jiffies(
+					       cm->desc->fullbatt_vchkdrop_ms);
+
+		if (cm->fullbatt_vchk_jiffies_at == 0)
+			cm->fullbatt_vchk_jiffies_at = 1;
+
+		break;
+	case CM_IRQ_BATT_OUT:
+		if (!is_batt_present(cm)) {
+			dev_emerg(cm->dev, "Battery Pulled Out!\n");
+			uevent_notify(cm, default_irq_names[CM_IRQ_BATT_OUT]);
+		} else {
+			uevent_notify(cm, "Battery Reinserted?");
+		}
+		break;
+	case CM_IRQ_BATT_IN:
+	case CM_IRQ_EXT_PWR_IN_OUT ... CM_IRQ_CHG_START_STOP:
+		uevent_notify(cm, default_irq_names[type]);
+		break;
+	case CM_IRQ_UNDESCRIBED:
+	case CM_IRQ_OTHERS:
+		uevent_notify(cm, msg ? msg : default_irq_names[type]);
+		break;
+	default:
+		dev_err(cm->dev, "%s type not specified.\n", __func__);
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(cm_notify_event);
+
+struct charger_manager *get_charger_manager(char *psy_name)
+{
+	struct power_supply *psy = power_supply_get_by_name(psy_name);
+
+	return container_of(psy, struct charger_manager, charger_psy);
+}
+EXPORT_SYMBOL_GPL(get_charger_manager);
+
+void cm_prohibit_charging(struct charger_manager *cm)
+{
+	cm->user_prohibit = true;
+	try_charger_enable(cm, false);
+}
+EXPORT_SYMBOL_GPL(cm_prohibit_charging);
+
+void cm_allow_charging(struct charger_manager *cm)
+{
+	cm->user_prohibit = false;
+	try_charger_enable(cm, true);
+}
+EXPORT_SYMBOL_GPL(cm_allow_charging);
+
+MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
+MODULE_DESCRIPTION("Charger Manager");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("charger-manager");
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
new file mode 100644
index 0000000..ddd63cc
--- /dev/null
+++ b/include/linux/power/charger-manager.h
@@ -0,0 +1,220 @@
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
+#ifndef __SAMSUNG_DEV_CHARGER_H
+#define __SAMSUNG_DEV_CHARGER_H
+
+#include <linux/power_supply.h>
+
+enum data_source {
+	CM_ASSUME_ALWAYS_TRUE,
+	CM_ASSUME_ALWAYS_FALSE,
+	CM_FUEL_GAUGE,
+	CM_CHARGER_STAT,
+};
+
+enum cm_irq_types {
+	CM_IRQ_UNDESCRIBED = 0,
+	CM_IRQ_BATT_FULL,
+	CM_IRQ_BATT_IN,
+	CM_IRQ_BATT_OUT,
+	CM_IRQ_EXT_PWR_IN_OUT,
+	CM_IRQ_CHG_START_STOP,
+	CM_IRQ_OTHERS,
+};
+
+struct charger_irq {
+	unsigned int irq;
+	unsigned long flags;
+	enum cm_irq_types cm_irq_type;
+
+	/*
+	 * wakeup is effective except for FULL and OUT.
+	 * It is always regarded as true for FULL and OUT.
+	 * If true, the irq wakes up the system from suspend.
+	 */
+	bool wakeup;
+
+	/* Optional. If null, default_irq_names is used */
+	const char *name;
+};
+
+enum polling_modes {
+	CM_POLL_DISABLE = 0,
+	CM_POLL_ALWAYS,
+	/* To use PWR-ONLY option, EXT_PWR_IN_OUT type irqs should exist */
+	CM_POLL_EXTERNAL_POWER_ONLY,
+	/* To use CHG-ONLY option, CHG_START_STOP type irqs should exist */
+	CM_POLL_CHARGING_ONLY,
+};
+
+struct charger_global_desc {
+	/*
+	 * For in-suspend monitoring, suspend-again related data is
+	 * required. These are used as global for Charger-Manager.
+	 * They should work with no_irq with dpm_suspend()'ed environment.
+	 *
+	 * rtc is the name of RTC used to wakeup the system from
+	 * suspend. Previously appointed alarm is saved and restored if
+	 * enabled and the alarm time is later than now.
+	 */
+	char *rtc;
+
+	/*
+	 * If the system is waked up by waekup-sources other than the RTC or
+	 * callbacks.setup provided with charger_global_desc, Charger Manager
+	 * should recognize with is_rtc_only_wakeup_reason() returning false.
+	 * If the RTC given to CM is the only wakeup reason,
+	 * is_rtc_only_wakeup_reason should return true.
+	 */
+	bool (*is_rtc_only_wakeup_reason)(void);
+
+	/*
+	 * Assume that the jiffy timer stops in suspend-to-RAM.
+	 * When enabled, CM does not rely on jiffies value in
+	 * suspend_again and assumes that jiffies value does not
+	 * change during suspend.
+	 */
+	bool assume_timer_stops_in_suspend;
+};
+
+struct charger_desc {
+	/*
+	 * The name of psy (power-supply-class) entry.
+	 * If psy_name is NULL, "battery" is used.
+	 */
+	char *psy_name;
+
+	/* The manager may poll with shorter interval, but not longer. */
+	enum polling_modes polling_mode;
+	unsigned int polling_interval_ms;
+
+	/*
+	 * Check voltage drop after the battery is fully charged.
+	 * If it has dropped more than fullbatt_vchkdrop_uV after
+	 * fullbatt_vchkdrop_ms, CM will restart charging.
+	 */
+	unsigned int fullbatt_vchkdrop_ms;
+	unsigned int fullbatt_vchkdrop_uV;
+
+	/*
+	 * If it is not being charged and VBATT >= fullbatt_uV,
+	 * it is assumed to be full. In order not to use this, set
+	 * fullbatt_uV 0.
+	 */
+	unsigned int fullbatt_uV;
+
+	/*
+	 * How the data is picked up for "PRESENT"?
+	 * Are we reading the value from chargers or fuel gauges?
+	 */
+	enum data_source battery_present;
+
+	/*
+	 * The power-supply entries of psy_charger_stat[i] shows "PRESENT",
+	 * "ONLINE", "STATUS (Should notify at least FULL or NOT)" of the
+	 * charger-i. "Charging/Discharging/NotCharging" of "STATUS" are
+	 * optional and recommended.
+	 */
+	char **psy_charger_stat;
+
+	int num_charger_regulators;
+	struct regulator_bulk_data *charger_regulators;
+
+	/*
+	 * The power-supply entries with VOLTAGE_NOW, CAPACITY,
+	 * and "PRESENT".
+	 */
+	char *psy_fuel_gauge;
+
+	/*
+	 * The irqs array should end with { .irq=0 } entry
+	 * At least one of irqs should be CM_IRQ_BATT_FULL.
+	 */
+	struct charger_irq *irqs;
+
+	int (*is_temperature_error)(int *mC);
+	bool measure_ambient_temp;
+	bool measure_battery_temp;
+};
+
+#define PSY_NAME_MAX	30
+struct charger_manager {
+	struct list_head entry;
+	struct device *dev;
+	struct charger_desc *desc;
+
+	struct power_supply *fuel_gauge;
+	struct power_supply **charger_stat;
+
+	bool cancel_suspend; /* if there is a pending charger event. */
+	bool charger_enabled;
+
+	unsigned long fullbatt_vchk_jiffies_at; /* 0 for N/A */
+	unsigned int fullbatt_vchk_uV;
+	struct delayed_work fullbatt_vchk_work;
+
+	bool user_prohibit;
+	int emergency_stop; /* Do not charge */
+	int last_temp_mC;
+
+	char psy_name_buf[PSY_NAME_MAX + 1]; /* Output to user */
+	struct power_supply charger_psy;
+
+	/*
+	 * status saved entering a suspend and if the saved status is
+	 * changed at suspend_again, suspend_again STOPs
+	 */
+	bool status_save_ext_pwr_inserted;
+	bool status_save_batt;
+};
+
+/* In case IRQs cannot be given and notifications will be given. */
+#ifdef CONFIG_CHARGER_MANAGER
+extern void cm_notify_event(struct charger_manager *cm, enum cm_irq_types type,
+			    char *msg); /* msg: optional */
+extern struct charger_manager *get_charger_manager(char *psy_name);
+extern int setup_charger_manager(struct charger_global_desc *gd);
+extern bool is_charger_manager_active(void);
+extern bool cm_suspend_again(void);
+extern void cm_prohibit_charging(struct charger_manager *cm);
+extern void cm_allow_charging(struct charger_manager *cm);
+#else
+static void __maybe_unused cm_notify_event(struct charger_manager *cm,
+					   enum cm_irq_types type, char *msg)
+{ }
+
+static struct charger_manager __maybe_unused *get_charger_manager(char *psy_name)
+{
+	return NULL;
+}
+
+static void __maybe_unused setup_charger_manager(struct charger_global_desc *gd)
+{ }
+
+static bool is_charger_manager_active(void)
+{
+	return false;
+}
+
+static bool __maybe_unused cm_suspend_again(void)
+{
+	return false;
+}
+static void __maybe_unused cm_prohibit_charging(struct charger_manager *cm) { }
+static void __maybe_unused cm_allow_charging(struct charger_manager *cm) { }
+#endif
+
+#endif /* __SAMSUNG_DEV_CHARGER_H */
-- 
1.7.4.1

