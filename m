Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab0JPON4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 10:13:56 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:60963 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab0JPONy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 10:13:54 -0400
Date: Sat, 16 Oct 2010 15:13:22 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Alexey Starikovskiy <astarikovskiy@suse.de>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>, David Zeuthen <davidz@redhat.com>,
        Richard Hughes <richard@hughsie.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Returning ACPI_BATTERY_VALUE_UNKNOWN to userspace
Message-ID: <20101016141321.GA11054@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have an EeePC 900 with a battery/BIOS that does not report the rate at
which it charges/discharges. When I look at
/proc/acpi/battery/BAT0/state this is what is reported:

present:                 yes
capacity state:          ok
charging state:          charging
present rate:            unknown
remaining capacity:      3120 mAh
present voltage:         7889 mV

However looking at /sys/class/power_supply/BAT0/current_now reports:

-1000

Why -1000? I think it's because it's -1 * 1000 == -1000! In
drivers/acpi/battery.c, ACPI_BATTERY_VALUE_UNKNOWN is defined as being
0xFFFFFFFF. As rate_now is a signed int variable when it is assigned
ACPI_BATTERY_VALUE_UNKNOWN its value is -1. However, before the value is
returned via sysfs it is multiplied by 1000:
http://lxr.linux.no/linux+v2.6.35.7/drivers/acpi/battery.c#L222
(http://lxr.linux.no/linux+v2.6.35.7/drivers/acpi/battery.c#L524 shows
that acpi_battery_get_property will be called via sysfs).

If the above is a correct interpretation, this behaviour was introduced
when sysfs battery support was added in commit
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d7380965752505951668e85de59c128d1d6fd21f
so it has effectively been always been this way.

However, looking at the code for the userspace power reporting tool
upower shows that it is not expecting to test against -1000 - it is
trying to test against 0xffff:
http://cgit.freedesktop.org/DeviceKit/upower/tree/src/linux/up-device-supply.c?id=UPOWER_0_9_6#n583
. Unfortunately, it's not clear that testing 0xffff is ever the right
thing to do. I wrote the following test program:

#include <stdio.h>
#include <math.h>
int main(void) {
	double minusone = -1;
	double sysfs = -1000;
	double hex_kernel = (int) 0xffffffff;
	double hex_tested = 0xffff;
	double energy_rate = fabs(sysfs / 1000000.0);
	double energy_rate_minusone = fabs(minusone / 1000000.0);
	printf("%f %f %f %f %f %f\n", minusone, sysfs, hex_kernel, hex_tested, energy_rate, energy_rate_minusone);
	return 0;
}

Which output the following:

-1.000000 -1000.000000 -1.000000 65535.000000 0.001000 0.000001

Given that at least upower (which is already deployed) will need to be
changed, I'm unsure as to where fixes for this should go. Was it really
the intent for userspace to test for -1000 instead of -1 to determine
an unknown rate?

-- 
Sitsofe | http://sucs.org/~sits/
