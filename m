Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab1LHBll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 20:41:41 -0500
Received: from claw.goop.org ([74.207.240.146]:58536 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757069Ab1LHBlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 20:41:40 -0500
Message-ID: <4EE015D1.5070005@goop.org>
Date: Wed, 07 Dec 2011 17:41:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Richard Hughes <hughsient@gmail.com>,
        Daniel Nicoletti <dantti12@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, vojtech@ucw.cz,
        Przemo Firszt <przemo@firszt.eu>, Richard Hughes <richard@hughsie.com>
Subject: [GIT PULL] power_supply: add power supply scope
References: <4EC75224.7070207@goop.org> <alpine.LNX.2.00.1111191212140.15187@pobox.suse.cz> <4EC820F8.4070900@goop.org> <alpine.LNX.2.00.1111201110480.15187@pobox.suse.cz> <4ECA7E7D.80207@goop.org> <alpine.LNX.2.00.1111220028130.28728@pobox.suse.cz> <4ECAE019.4000409@goop.org> <alpine.LNX.2.00.1111220049470.28728@pobox.suse.cz> <4ECCB38A.8000503@goop.org> <alpine.LNX.2.00.1111281111510.15446@pobox.suse.cz> <CACo8zOd45i3EnCVMyJoDPP4bx2AnD9mEjDiC=bJKvmX=TWfXGg@mail.gmail.com> <4ED90E6D.8090402@goop.org> <CACo8zOcvKwr0wDkytvJfqyx4kV0ceYyCt+qnDqiSgxNywpzeHg@mail.gmail.com> <4ED9BDF8.3010600@goop.org> <CAD2FfiE-rg-1bMmVpYzBhnQcBMKKKO4WPnu0bvx+pvdFnpARrQ@mail.gmail.com> <4EDE4C7A.1010802@goop.org> <CAD2FfiHWuEmVTa54YqfJDk5zHpSQuM_nwPT=mR6NoWpajpydpg@mail.gmail.com> <4EDFA192.7000602@goop.org> <CAD2FfiF+fVoLPWpPyGGKdnoGhx1f=Loh2Ju-vdU58Y=2kf6C3g@mail.gmail.com>
In-Reply-To: <CAD2FfiF+fVoLPWpPyGGKdnoGhx1f=Loh2Ju-vdU58Y=2kf6C3g@mail.gmail.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series adds a "scope" property to power supplies, so that a power
supply can indicate whether it powers the whole system, or just a
device.  This allows upowerd to distinguish between actual system power
supplies, and self-powered devices such as wireless mice.

Thanks,
    J

  Linux 3.2-rc2 (2011-11-15 15:02:59 -0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git power-supply-scope

Jeremy Fitzhardinge (3):
      power_supply: add SCOPE property to power supplies
      power_supply: allow powered device to be registered with supply
      power_supply: add scope properties to some common power_supplies

 drivers/acpi/ac.c                  |    4 ++++
 drivers/acpi/battery.c             |    5 +++++
 drivers/acpi/sbs.c                 |    9 +++++++++
 drivers/hid/hid-wacom.c            |   12 ++++++++++--
 drivers/hid/hid-wiimote.c          |    8 +++++++-
 drivers/power/power_supply_core.c  |    7 +++++++
 drivers/power/power_supply_sysfs.c |    6 ++++++
 include/linux/power_supply.h       |    8 ++++++++
 8 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 6512b20..ec36c82 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -142,6 +142,9 @@ static int get_ac_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_ONLINE:
 		val->intval = ac->state;
 		break;
+	case POWER_SUPPLY_PROP_SCOPE:
+		val->intval = POWER_SUPPLY_SCOPE_SYSTEM;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -150,6 +153,7 @@ static int get_ac_property(struct power_supply *psy,
 
 static enum power_supply_property ac_props[] = {
 	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_SCOPE,
 };
 
 #ifdef CONFIG_ACPI_PROCFS_POWER
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 7711d94..1f68bb6 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -250,6 +250,9 @@ static int acpi_battery_get_property(struct power_supply *psy,
 		else
 			val->intval = battery->capacity_now * 1000;
 		break;
+	case POWER_SUPPLY_PROP_SCOPE:
+		val->intval = POWER_SUPPLY_SCOPE_SYSTEM;
+		break;
 	case POWER_SUPPLY_PROP_MODEL_NAME:
 		val->strval = battery->model_number;
 		break;
@@ -276,6 +279,7 @@ static enum power_supply_property charge_battery_props[] = {
 	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
 	POWER_SUPPLY_PROP_CHARGE_FULL,
 	POWER_SUPPLY_PROP_CHARGE_NOW,
+	POWER_SUPPLY_PROP_SCOPE,
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
 	POWER_SUPPLY_PROP_SERIAL_NUMBER,
@@ -292,6 +296,7 @@ static enum power_supply_property energy_battery_props[] = {
 	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_FULL,
 	POWER_SUPPLY_PROP_ENERGY_NOW,
+	POWER_SUPPLY_PROP_SCOPE,
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
 	POWER_SUPPLY_PROP_SERIAL_NUMBER,
diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 6e36d0c..fc35e42 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -171,6 +171,9 @@ static int sbs_get_ac_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_ONLINE:
 		val->intval = sbs->charger_present;
 		break;
+	case POWER_SUPPLY_PROP_SCOPE:
+		val->intval = POWER_SUPPLY_SCOPE_SYSTEM;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -263,6 +266,9 @@ static int acpi_sbs_battery_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_TEMP:
 		val->intval = battery->temp_now - 2730;	// dK -> dC
 		break;
+	case POWER_SUPPLY_PROP_SCOPE:
+		val->intval = POWER_SUPPLY_SCOPE_SYSTEM;
+		break;
 	case POWER_SUPPLY_PROP_MODEL_NAME:
 		val->strval = battery->device_name;
 		break;
@@ -277,6 +283,7 @@ static int acpi_sbs_battery_get_property(struct power_supply *psy,
 
 static enum power_supply_property sbs_ac_props[] = {
 	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_SCOPE,
 };
 
 static enum power_supply_property sbs_charge_battery_props[] = {
@@ -292,6 +299,7 @@ static enum power_supply_property sbs_charge_battery_props[] = {
 	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
 	POWER_SUPPLY_PROP_CHARGE_FULL,
 	POWER_SUPPLY_PROP_CHARGE_NOW,
+	POWER_SUPPLY_PROP_SCOPE,
 	POWER_SUPPLY_PROP_TEMP,
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
@@ -311,6 +319,7 @@ static enum power_supply_property sbs_energy_battery_props[] = {
 	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_FULL,
 	POWER_SUPPLY_PROP_ENERGY_NOW,
+	POWER_SUPPLY_PROP_SCOPE,
 	POWER_SUPPLY_PROP_TEMP,
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 17bb88f..ad39777 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -47,12 +47,14 @@ static unsigned short batcap[8] = { 1, 15, 25, 35, 50, 70, 100, 0 };
 
 static enum power_supply_property wacom_battery_props[] = {
 	POWER_SUPPLY_PROP_PRESENT,
-	POWER_SUPPLY_PROP_CAPACITY
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_SCOPE,
 };
 
 static enum power_supply_property wacom_ac_props[] = {
 	POWER_SUPPLY_PROP_PRESENT,
-	POWER_SUPPLY_PROP_ONLINE
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_SCOPE,
 };
 
 static int wacom_battery_get_property(struct power_supply *psy,
@@ -68,6 +70,9 @@ static int wacom_battery_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_PRESENT:
 		val->intval = 1;
 		break;
+	case POWER_SUPPLY_PROP_SCOPE:
+		val->intval = POWER_SUPPLY_SCOPE_DEVICE;
+		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
 		/* show 100% battery capacity when charging */
 		if (power_state == 0)
@@ -99,6 +104,9 @@ static int wacom_ac_get_property(struct power_supply *psy,
 		else
 			val->intval = 0;
 		break;
+	case POWER_SUPPLY_PROP_SCOPE:
+		val->intval = POWER_SUPPLY_SCOPE_DEVICE;
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/drivers/hid/hid-wiimote.c b/drivers/hid/hid-wiimote.c
index 76739c0..98e4828 100644
--- a/drivers/hid/hid-wiimote.c
+++ b/drivers/hid/hid-wiimote.c
@@ -136,7 +136,8 @@ static __u16 wiiproto_keymap[] = {
 };
 
 static enum power_supply_property wiimote_battery_props[] = {
-	POWER_SUPPLY_PROP_CAPACITY
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_SCOPE,
 };
 
 /* requires the state.lock spinlock to be held */
@@ -468,6 +469,11 @@ static int wiimote_battery_get_property(struct power_supply *psy,
 	int ret = 0, state;
 	unsigned long flags;
 
+	if (psp == POWER_SUPPLY_PROP_SCOPE) {
+		val->intval = POWER_SUPPLY_SCOPE_DEVICE;
+		return 0;
+	}
+
 	ret = wiimote_cmd_acquire(wdata);
 	if (ret)
 		return ret;
diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 329b46b..bacf327 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -147,6 +147,12 @@ struct power_supply *power_supply_get_by_name(char *name)
 }
 EXPORT_SYMBOL_GPL(power_supply_get_by_name);
 
+
+int power_supply_powers(struct power_supply *psy, struct device *dev)
+{
+	return sysfs_create_link_nowarn(&psy->dev->kobj, &dev->kobj, "powers");
+}
+
 static void power_supply_dev_release(struct device *dev)
 {
 	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
@@ -202,6 +208,7 @@ EXPORT_SYMBOL_GPL(power_supply_register);
 void power_supply_unregister(struct power_supply *psy)
 {
 	cancel_work_sync(&psy->changed_work);
+	sysfs_remove_link(&psy->dev->kobj, "powers");
 	power_supply_remove_triggers(psy);
 	device_unregister(psy->dev);
 }
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index e15d4c9..21178eb 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -63,6 +63,9 @@ static ssize_t power_supply_show_property(struct device *dev,
 	static char *capacity_level_text[] = {
 		"Unknown", "Critical", "Low", "Normal", "High", "Full"
 	};
+	static char *scope_text[] = {
+		"Unknown", "System", "Device"
+	};
 	ssize_t ret = 0;
 	struct power_supply *psy = dev_get_drvdata(dev);
 	const ptrdiff_t off = attr - power_supply_attrs;
@@ -95,6 +98,8 @@ static ssize_t power_supply_show_property(struct device *dev,
 		return sprintf(buf, "%s\n", capacity_level_text[value.intval]);
 	else if (off == POWER_SUPPLY_PROP_TYPE)
 		return sprintf(buf, "%s\n", type_text[value.intval]);
+	else if (off == POWER_SUPPLY_PROP_SCOPE)
+		return sprintf(buf, "%s\n", scope_text[value.intval]);
 	else if (off >= POWER_SUPPLY_PROP_MODEL_NAME)
 		return sprintf(buf, "%s\n", value.strval);
 
@@ -167,6 +172,7 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(time_to_full_now),
 	POWER_SUPPLY_ATTR(time_to_full_avg),
 	POWER_SUPPLY_ATTR(type),
+	POWER_SUPPLY_ATTR(scope),
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_ATTR(model_name),
 	POWER_SUPPLY_ATTR(manufacturer),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 204c18d..2e3c827 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -74,6 +74,12 @@ enum {
 	POWER_SUPPLY_CAPACITY_LEVEL_FULL,
 };
 
+enum {
+	POWER_SUPPLY_SCOPE_UNKNOWN = 0,
+	POWER_SUPPLY_SCOPE_SYSTEM,
+	POWER_SUPPLY_SCOPE_DEVICE,
+};
+
 enum power_supply_property {
 	/* Properties of type `int' */
 	POWER_SUPPLY_PROP_STATUS = 0,
@@ -116,6 +122,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
 	POWER_SUPPLY_PROP_TYPE, /* use power_supply.type instead */
+	POWER_SUPPLY_PROP_SCOPE,
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
@@ -211,6 +218,7 @@ static inline int power_supply_is_system_supplied(void) { return -ENOSYS; }
 extern int power_supply_register(struct device *parent,
 				 struct power_supply *psy);
 extern void power_supply_unregister(struct power_supply *psy);
+extern int power_supply_powers(struct power_supply *psy, struct device *dev);
 
 /* For APM emulation, think legacy userspace. */
 extern struct class *power_supply_class;


