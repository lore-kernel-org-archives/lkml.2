Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab0JPXHM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 19:07:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52918 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980Ab0JPXHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 19:07:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sitsofe Wheeler <sitsofe@yahoo.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH] ACPI / Battery: Return -ENODATA for unknown values in get_property() (was: Re: Returning ACPI_BATTERY ...)
Date: Sun, 17 Oct 2010 01:05:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc8-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        David Zeuthen <davidz@redhat.com>,
        Richard Hughes <richard@hughsie.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20101016141321.GA11054@sucs.org>
In-Reply-To: <20101016141321.GA11054@sucs.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010170105.33274.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 16, 2010, Sitsofe Wheeler wrote:
> Hi,

Hi,

> I have an EeePC 900 with a battery/BIOS that does not report the rate at
> which it charges/discharges. When I look at
> /proc/acpi/battery/BAT0/state this is what is reported:
> 
> present:                 yes
> capacity state:          ok
> charging state:          charging
> present rate:            unknown
> remaining capacity:      3120 mAh
> present voltage:         7889 mV
> 
> However looking at /sys/class/power_supply/BAT0/current_now reports:
> 
> -1000
> 
> Why -1000? I think it's because it's -1 * 1000 == -1000! In
> drivers/acpi/battery.c, ACPI_BATTERY_VALUE_UNKNOWN is defined as being
> 0xFFFFFFFF. As rate_now is a signed int variable when it is assigned
> ACPI_BATTERY_VALUE_UNKNOWN its value is -1.

That's because val->intval is used to return the value rather than because
rate_now is int.

I think this is a bug in the battery driver, that should return -1 in that case.

Matthew, what do you think?

> However, before the value is
> returned via sysfs it is multiplied by 1000:
> http://lxr.linux.no/linux+v2.6.35.7/drivers/acpi/battery.c#L222
> (http://lxr.linux.no/linux+v2.6.35.7/drivers/acpi/battery.c#L524 shows
> that acpi_battery_get_property will be called via sysfs).
> 
> If the above is a correct interpretation, this behaviour was introduced
> when sysfs battery support was added in commit
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d7380965752505951668e85de59c128d1d6fd21f
> so it has effectively been always been this way.
> 
> However, looking at the code for the userspace power reporting tool
> upower shows that it is not expecting to test against -1000 - it is
> trying to test against 0xffff:

In fact, it should be written to test against -1 or an unsigned representation
of it (which is all ones in whatever unsigned data type used by it).

> http://cgit.freedesktop.org/DeviceKit/upower/tree/src/linux/up-device-supply.c?id=UPOWER_0_9_6#n583
> . Unfortunately, it's not clear that testing 0xffff is ever the right
> thing to do. I wrote the following test program:
> 
> #include <stdio.h>
> #include <math.h>
> int main(void) {
> 	double minusone = -1;
> 	double sysfs = -1000;
> 	double hex_kernel = (int) 0xffffffff;
> 	double hex_tested = 0xffff;
> 	double energy_rate = fabs(sysfs / 1000000.0);
> 	double energy_rate_minusone = fabs(minusone / 1000000.0);
> 	printf("%f %f %f %f %f %f\n", minusone, sysfs, hex_kernel, hex_tested, energy_rate, energy_rate_minusone);
> 	return 0;
> }
> 
> Which output the following:
> 
> -1.000000 -1000.000000 -1.000000 65535.000000 0.001000 0.000001
> 
> Given that at least upower (which is already deployed) will need to be
> changed, I'm unsure as to where fixes for this should go. Was it really
> the intent for userspace to test for -1000 instead of -1 to determine
> an unknown rate?

No, it isn't.

In fact, the driver is supposed to return -ENODATA in that case, which will
result in the read from /sys/class/power_supply/BAT0/current_now fail (I guess
upower should be able to cope with that).

So, I'd suggest applying the appended patch.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ACPI / Battery: Return -ENODATA for unknown values in get_property()

The function acpi_battery_get_property() is called by the
power supply framework's function power_supply_show_property()
implementing the sysfs interface for power supply devices as the
ACPI battery driver's ->get_property() callback.  Thus it is supposed
to return -ENODATA if the value of the given property is unknown.
Unfortunately, however, it returns 0 in those cases and puts a
wrong (negative) value into the intval field of the
union power_supply_propval object provided by
power_supply_show_property().  In consequence, wron negative
values are read by user space from the battery's sysfs files.
Fix this by making acpi_battery_get_property() behave as
expected.

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
+			ret = -ENODATA;
+		else
+			val->intval = battery->design_voltage * 1000;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		val->intval = battery->voltage_now * 1000;
+		if (battery->voltage_now == ACPI_BATTERY_VALUE_UNKNOWN)
+			ret = -ENODATA;
+		else
+			val->intval = battery->voltage_now * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 	case POWER_SUPPLY_PROP_POWER_NOW:
-		val->intval = battery->rate_now * 1000;
+		if (battery->rate_now == ACPI_BATTERY_VALUE_UNKNOWN)
+			ret = -ENODATA;
+		else
+			val->intval = battery->rate_now * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
 	case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:
-		val->intval = battery->design_capacity * 1000;
+		if (battery->design_capacity == ACPI_BATTERY_VALUE_UNKNOWN)
+			ret = -ENODATA;
+		else
+			val->intval = battery->design_capacity * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL:
 	case POWER_SUPPLY_PROP_ENERGY_FULL:
-		val->intval = battery->full_charge_capacity * 1000;
+		if (battery->full_charge_capacity == ACPI_BATTERY_VALUE_UNKNOWN)
+			ret = -ENODATA;
+		else
+			val->intval = battery->full_charge_capacity * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_NOW:
 	case POWER_SUPPLY_PROP_ENERGY_NOW:
-		val->intval = battery->capacity_now * 1000;
+		if (battery->capacity_now == ACPI_BATTERY_VALUE_UNKNOWN)
+			ret = -ENODATA;
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
