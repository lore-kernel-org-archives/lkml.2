Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab0JQSdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 14:33:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54207 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab0JQSdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 14:33:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [PATCH] ACPI / Battery: Return -ENODATA for unknown values in get_property()
Date: Sun, 17 Oct 2010 20:32:42 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc8-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, David Zeuthen <davidz@redhat.com>,
        Richard Hughes <richard@hughsie.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20101016141321.GA11054@sucs.org> <20101017131016.GB13015@khazad-dum.debian.net> <20101017145025.GA32599@sucs.org>
In-Reply-To: <20101017145025.GA32599@sucs.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010172032.43206.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 17, 2010, Sitsofe Wheeler wrote:
> On Sun, Oct 17, 2010 at 11:10:16AM -0200, Henrique de Moraes Holschuh wrote:
> > On Sun, 17 Oct 2010, Sitsofe Wheeler wrote:
> > > 
> > > Using ENODATA and ENXIO appears to solve the problem (upower reports a
> > > rate of 0.0). However when plugging the battery in after previously only
> > > being on AC power none of the /sys/class/power_supply/BAT0/uevent:*
> > > files are created so upower never realises a battery has been plugged
> > 
> > You might have broken firmware that does not issue a notify when a battery
> > is plugged.  But it has been a long time, I don't recall if the battery
> > driver handles hotplugging without the help of the dock/bay driver (it
> > should, AFAIK).
> 
> Battery hotplug works fine without these patches. I should have said -
> the uevent devices are there with a vanilla kernel no matter how many
> times the battery is plugged in or unplugged (that's how I knew they
> were missing with the patches added :) I am guessing some part of the
> kernel/udev cannot handle being told ENODATA or ENXIO and bails out
> before those nodes would be made.
> 
> > > in. A further issue with ENXIO is is the following repeatedly appears in
> > > dmesg:
> > > power_supply BAT0: driver failed to report `current_now' property
> > 
> > And it keeps silent if it gets ENODATA?
> 
> Yes.

That's why I suggested to use -ENODATA. :-)

Still, if user space has problems with failing reads from the sysfs attributes,
it may be better to simply put -1 in there.  Patch is appended, please test.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ACPI / Battery: Return -ENODATA for unknown values in get_property()

The function acpi_battery_get_property() is called by the
power supply framework's function power_supply_show_property()
implementing the sysfs interface for power supply devices as the
ACPI battery driver's ->get_property() callback.  Thus it should
return error code if the value of the given property is unknown.
However, it returns 0 in those cases and puts a wrong (negative)
value into the intval field of the union power_supply_propval object
provided by power_supply_show_property().  In consequence, wrong
negative values (typically -1000) are read by user space from the
battery's sysfs files.

Unfortunately, this problem cannot be fixed by simply making the
driver return error code for unknown property values, because that
breaks the existing user space.  Thus make the battery driver put
all ones (-1) into val->intval if the value of the property being
read is unknown.

Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/battery.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/acpi/battery.c
===================================================================
--- linux-2.6.orig/drivers/acpi/battery.c
+++ linux-2.6/drivers/acpi/battery.c
@@ -193,6 +193,8 @@ static int acpi_battery_get_property(str
 		acpi_battery_get_state(battery);
 	} else if (psp != POWER_SUPPLY_PROP_PRESENT)
 		return -ENODEV;
+	if (psp < POWER_SUPPLY_PROP_MODEL_NAME)
+		val->intval = -1;
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
 		if (battery->state & 0x01)
@@ -214,26 +216,32 @@ static int acpi_battery_get_property(str
 		val->intval = battery->cycle_count;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
-		val->intval = battery->design_voltage * 1000;
+		if (battery->design_voltage != ACPI_BATTERY_VALUE_UNKNOWN)
+			val->intval = battery->design_voltage * 1000;
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		val->intval = battery->voltage_now * 1000;
+		if (battery->voltage_now != ACPI_BATTERY_VALUE_UNKNOWN)
+			val->intval = battery->voltage_now * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
 	case POWER_SUPPLY_PROP_POWER_NOW:
-		val->intval = battery->rate_now * 1000;
+		if (battery->rate_now != ACPI_BATTERY_VALUE_UNKNOWN)
+			val->intval = battery->rate_now * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
 	case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:
-		val->intval = battery->design_capacity * 1000;
+		if (battery->design_capacity != ACPI_BATTERY_VALUE_UNKNOWN)
+			val->intval = battery->design_capacity * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL:
 	case POWER_SUPPLY_PROP_ENERGY_FULL:
-		val->intval = battery->full_charge_capacity * 1000;
+		if (battery->full_charge_capacity != ACPI_BATTERY_VALUE_UNKNOWN)
+			val->intval = battery->full_charge_capacity * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_NOW:
 	case POWER_SUPPLY_PROP_ENERGY_NOW:
-		val->intval = battery->capacity_now * 1000;
+		if (battery->capacity_now != ACPI_BATTERY_VALUE_UNKNOWN)
+			val->intval = battery->capacity_now * 1000;
 		break;
 	case POWER_SUPPLY_PROP_MODEL_NAME:
 		val->strval = battery->model_number;
