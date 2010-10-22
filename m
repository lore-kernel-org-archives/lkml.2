Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab0JVWUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 18:20:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45545 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab0JVWUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 18:20:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [PATCH] ACPI / Battery: Return -ENODATA for unknown values in get_property()
Date: Sat, 23 Oct 2010 00:19:13 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, David Zeuthen <davidz@redhat.com>,
        Richard Hughes <richard@hughsie.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20101016141321.GA11054@sucs.org> <201010212157.47952.rjw@sisk.pl> <20101021204620.GB3318@sucs.org>
In-Reply-To: <20101021204620.GB3318@sucs.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010230019.14100.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 21, 2010, Sitsofe Wheeler wrote:
> On Thu, Oct 21, 2010 at 09:57:47PM +0200, Rafael J. Wysocki wrote:
> > On Thursday, October 21, 2010, Sitsofe Wheeler wrote:
> > > 
> > > It's a shame the previous changes didn't work as they stopped a buggy
> > > upower using the -1 value (and producing a nonsense rate like 8.4e-06)
> > 
> > Hmm.  So upower _doesn't_ handle -1?  What does it do with -1000, then?
> 
> It can't handle that either and outputs a nonsense rate like 0.0084.
> Looking at the code, it would take a very strange value for it to realise
> it is handling a special value as it does arithmetic on the sysfs value
> before doing its check:
> 
> 	/* get rate; it seems odd as it's either in uVh or uWh */
> 	energy_rate = fabs (sysfs_get_double (native_path, "current_now") / 1000000.0);
> 
> 	/* convert charge to energy */
> 	if (energy == 0) {
> 		energy = sysfs_get_double (native_path, "charge_now") / 1000000.0;
> 		if (energy == 0)
> 			energy = sysfs_get_double (native_path, "charge_avg") / 1000000.0;
> 		energy *= voltage_design;
> 		energy_rate *= voltage_design;
> 	}
> 
> 	/* some batteries don't update last_full attribute */
> 	if (energy > energy_full) {
> 		egg_warning ("energy %f bigger than full %f", energy, energy_full);
> 		energy_full = energy;
> 	}
> 
> 	/* present voltage */
> 	voltage = sysfs_get_double (native_path, "voltage_now") / 1000000.0;
> 	if (voltage == 0)
> 		voltage = sysfs_get_double (native_path, "voltage_avg") / 1000000.0;
> 
> 	/* ACPI gives out the special 'Ones' value for rate when it's unable
> 	 * to calculate the true rate. We should set the rate zero, and wait
> 	 * for the BIOS to stabilise. */
> 	if (energy_rate == 0xffff)
> 		energy_rate = 0;
> 
> By the time the comparison against energy_rate is done the original
> sysfs value has at _least_ divided by 1000000.0 and made positive. Hence
> the test program in my first mail where I mention that 0xfffff produced
> 65535.000000, fabs(-1000 / 1000000.0) produced 0.001000 and fabs(-1 /
> 1000000.0) produces 0.000001. That's also assuming it doesn't wind up
> multiplying the previous value by voltage_design...
> 
> > > but it's not clear which part of the stack can't handle -ENODATA
> > > perhaps it is another part of the kernel?
> > 
> > I don't really think it's a part of the kernel.
> 
> How do I find out which part is not producing those sysfs nodes?
> 
> > > Richard, any chance of upower being changed to test for -1 before doing
> > > doing anything with current_now (
> > > http://cgit.freedesktop.org/DeviceKit/upower/tree/src/linux/up-device-supply.c?id=5387183d53c16a987a0737c1bdec1b62edf3daa6#n561)?
> > > I guess there are a whole bunch of other attributes that could
> > > theoretically be -1 and shouldn't be used if they return it...
> > 
> > If user space doesn't handle -1 correctly too, I think the right approach for
> > us should be to use the previous version of the patch and return error code
> > for unknown values.
> 
> So long as sysfs can be made to work properly I am in agreement.

OK, so can you test the patch below, please?

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ACPI / Battery: Return -ENODEV for unknown values in get_property()

The function acpi_battery_get_property() is called by the
power supply framework's function power_supply_show_property()
implementing the sysfs interface for power supply devices as the
ACPI battery driver's ->get_property() callback.  Thus it is supposed
to return error code if the value of the given property is unknown.
Unfortunately, however, it returns 0 in those cases and puts a
wrong (negative) value into the intval field of the
union power_supply_propval object provided by
power_supply_show_property().  In consequence, wron negative
values are read by user space from the battery's sysfs files.

Fix this by making acpi_battery_get_property() return -ENODEV
for properties with unknown values (-ENODEV is returned, because
power_supply_uevent() returns with error for any other error code
returned by power_supply_show_property()).

Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/battery.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/acpi/battery.c
===================================================================
--- linux-2.6.orig/drivers/acpi/battery.c
+++ linux-2.6/drivers/acpi/battery.c
@@ -186,6 +186,7 @@ static int acpi_battery_get_property(str
 				     enum power_supply_property psp,
 				     union power_supply_propval *val)
 {
+	int ret = 0;
 	struct acpi_battery *battery = to_acpi_battery(psy);
 
 	if (acpi_battery_present(battery)) {
@@ -214,26 +215,44 @@ static int acpi_battery_get_property(str
 		val->intval = battery->cycle_count;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
-		val->intval = battery->design_voltage * 1000;
+		if (battery->design_voltage == ACPI_BATTERY_VALUE_UNKNOWN)
+			ret = -ENODEV;
+		else
+			val->intval = battery->design_voltage * 1000;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		val->intval = battery->voltage_now * 1000;
+		if (battery->voltage_now == ACPI_BATTERY_VALUE_UNKNOWN)
+			ret = -ENODEV;
+		else
+			val->intval = battery->voltage_now * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 	case POWER_SUPPLY_PROP_POWER_NOW:
-		val->intval = battery->rate_now * 1000;
+		if (battery->rate_now == ACPI_BATTERY_VALUE_UNKNOWN)
+			ret = -ENODEV;
+		else
+			val->intval = battery->rate_now * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
 	case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:
-		val->intval = battery->design_capacity * 1000;
+		if (battery->design_capacity == ACPI_BATTERY_VALUE_UNKNOWN)
+			ret = -ENODEV;
+		else
+			val->intval = battery->design_capacity * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL:
 	case POWER_SUPPLY_PROP_ENERGY_FULL:
-		val->intval = battery->full_charge_capacity * 1000;
+		if (battery->full_charge_capacity == ACPI_BATTERY_VALUE_UNKNOWN)
+			ret = -ENODEV;
+		else
+			val->intval = battery->full_charge_capacity * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_NOW:
 	case POWER_SUPPLY_PROP_ENERGY_NOW:
-		val->intval = battery->capacity_now * 1000;
+		if (battery->capacity_now == ACPI_BATTERY_VALUE_UNKNOWN)
+			ret = -ENODEV;
+		else
+			val->intval = battery->capacity_now * 1000;
 		break;
 	case POWER_SUPPLY_PROP_MODEL_NAME:
 		val->strval = battery->model_number;
@@ -245,9 +264,9 @@ static int acpi_battery_get_property(str
 		val->strval = battery->serial_number;
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
 	}
-	return 0;
+	return ret;
 }
 
 static enum power_supply_property charge_battery_props[] = {
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

