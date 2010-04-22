Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab0DVT23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:28:29 -0400
Received: from kroah.org ([198.145.64.141]:40741 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281Ab0DVT2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:22 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:13 2010
Message-Id: <20100422190913.649759542@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
Subject: [070/197] thinkpad-acpi: log temperatures on termal alarm (v2)
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

commit 9ebd9e833648745fa5ac6998b9e0153ccd3ba839 upstream.

Log temperatures on any of the EC thermal alarms.  It could be
useful to help tracking down what is happening...

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |   57 +++++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 12 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3548,49 +3548,57 @@ static bool hotkey_notify_usrevent(const
 	}
 }
 
+static void thermal_dump_all_sensors(void);
+
 static bool hotkey_notify_thermal(const u32 hkey,
 				 bool *send_acpi_ev,
 				 bool *ignore_acpi_ev)
 {
+	bool known = true;
+
 	/* 0x6000-0x6FFF: thermal alarms */
 	*send_acpi_ev = true;
 	*ignore_acpi_ev = false;
 
 	switch (hkey) {
+	case TP_HKEY_EV_THM_TABLE_CHANGED:
+		printk(TPACPI_INFO
+			"EC reports that Thermal Table has changed\n");
+		/* recommended action: do nothing, we don't have
+		 * Lenovo ATM information */
+		return true;
 	case TP_HKEY_EV_ALARM_BAT_HOT:
 		printk(TPACPI_CRIT
 			"THERMAL ALARM: battery is too hot!\n");
 		/* recommended action: warn user through gui */
-		return true;
+		break;
 	case TP_HKEY_EV_ALARM_BAT_XHOT:
 		printk(TPACPI_ALERT
 			"THERMAL EMERGENCY: battery is extremely hot!\n");
 		/* recommended action: immediate sleep/hibernate */
-		return true;
+		break;
 	case TP_HKEY_EV_ALARM_SENSOR_HOT:
 		printk(TPACPI_CRIT
 			"THERMAL ALARM: "
 			"a sensor reports something is too hot!\n");
 		/* recommended action: warn user through gui, that */
 		/* some internal component is too hot */
-		return true;
+		break;
 	case TP_HKEY_EV_ALARM_SENSOR_XHOT:
 		printk(TPACPI_ALERT
 			"THERMAL EMERGENCY: "
 			"a sensor reports something is extremely hot!\n");
 		/* recommended action: immediate sleep/hibernate */
-		return true;
-	case TP_HKEY_EV_THM_TABLE_CHANGED:
-		printk(TPACPI_INFO
-			"EC reports that Thermal Table has changed\n");
-		/* recommended action: do nothing, we don't have
-		 * Lenovo ATM information */
-		return true;
+		break;
 	default:
 		printk(TPACPI_ALERT
 			 "THERMAL ALERT: unknown thermal alarm received\n");
-		return false;
+		known = false;
 	}
+
+	thermal_dump_all_sensors();
+
+	return known;
 }
 
 static void hotkey_notify(struct ibm_struct *ibm, u32 event)
@@ -5472,8 +5480,11 @@ enum { /* TPACPI_THERMAL_TPEC_* */
 	TP_EC_THERMAL_TMP0 = 0x78,	/* ACPI EC regs TMP 0..7 */
 	TP_EC_THERMAL_TMP8 = 0xC0,	/* ACPI EC regs TMP 8..15 */
 	TP_EC_THERMAL_TMP_NA = -128,	/* ACPI EC sensor not available */
+
+	TPACPI_THERMAL_SENSOR_NA = -128000, /* Sensor not available */
 };
 
+
 #define TPACPI_MAX_THERMAL_SENSORS 16	/* Max thermal sensors supported */
 struct ibm_thermal_sensors_struct {
 	s32 temp[TPACPI_MAX_THERMAL_SENSORS];
@@ -5563,6 +5574,28 @@ static int thermal_get_sensors(struct ib
 	return n;
 }
 
+static void thermal_dump_all_sensors(void)
+{
+	int n, i;
+	struct ibm_thermal_sensors_struct t;
+
+	n = thermal_get_sensors(&t);
+	if (n <= 0)
+		return;
+
+	printk(TPACPI_NOTICE
+		"temperatures (Celsius):");
+
+	for (i = 0; i < n; i++) {
+		if (t.temp[i] != TPACPI_THERMAL_SENSOR_NA)
+			printk(KERN_CONT " %d", (int)(t.temp[i] / 1000));
+		else
+			printk(KERN_CONT " N/A");
+	}
+
+	printk(KERN_CONT "\n");
+}
+
 /* sysfs temp##_input -------------------------------------------------- */
 
 static ssize_t thermal_temp_input_show(struct device *dev,
@@ -5578,7 +5611,7 @@ static ssize_t thermal_temp_input_show(s
 	res = thermal_get_sensor(idx, &value);
 	if (res)
 		return res;
-	if (value == TP_EC_THERMAL_TMP_NA * 1000)
+	if (value == TPACPI_THERMAL_SENSOR_NA)
 		return -ENXIO;
 
 	return snprintf(buf, PAGE_SIZE, "%d\n", value);


