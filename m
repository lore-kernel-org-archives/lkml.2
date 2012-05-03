Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2ECIzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 04:55:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54115 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab2ECIzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 04:55:04 -0400
Date: Thu, 3 May 2012 09:54:58 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Adrian Fita <adrian.fita@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Ralf Jung <ralfjung-e@gmx.de>, Paolo Scarabelli <paolo@msw.it>
Subject: Re: [bug?] Battery notifications produce flashing battery icon,
 syslog spam (Re: [PATCH 11/11] ACPI / Battery: Update information on info
 notification and resume)
Message-ID: <20120503085458.GG3364@shadowen.org>
References: <201101062331.17079.rjw@sisk.pl>
 <201101062342.28168.rjw@sisk.pl>
 <20120501184534.GA31731@burratino>
 <4FA032EA.1090608@gmail.com>
 <20120501191408.GD19143@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120501191408.GD19143@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 02:14:08PM -0500, Jonathan Nieder wrote:
> (cc-ing Andy)
> Adrian Fita wrote:
> 
> > Also, searching on Google after "upowerd device
> > removed:/org/freedesktop/UPower/devices/battery_BAT0", reveals much
> > more bug reports with the exact issue.
> 
> Thanks.  That confirms the high CPU consumption in upowerd ---
> see [1], for example.
> 
> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/987807

It does seem somewhat heavyweight to be removing and reinstalling all of
the sysfs files every time we get one of these events.  I am assuming
here that some BIOSs are using this interface to tell us the batery
capacity has changed and triggering the constant add/remove of the
devices and associated flickering.

>From the description of the change this is necessary because the
capacity units may change over time?  Can we not use those to avoid this
update?  I presume it is these two we are referring to?

        int capacity_granularity_1;
        int capacity_granularity_2;

If those are unchanged perhaps we can just skip the update?  Something
like the below (completly untested, for discussion).

Thoughts?

-apw

commit d558d0c38e26e2c7eae68d19f4d2fa3ecd8e31f2
Author: Andy Whitcroft <apw@canonical.com>
Date:   Thu May 3 09:52:28 2012 +0100

    battery: only refresh the sysfs files when pertinant information changes
    
    We only need to regenerate the sysfs files when the capacity units
    change, avoid the update otherwise.
    
    Signed-off-by: Andy Whitcroft <apw@canonical.com>

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index eb18c44..f8d37b4 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -643,10 +643,20 @@ static int acpi_battery_update(struct acpi_battery *battery)
 
 static void acpi_battery_refresh(struct acpi_battery *battery)
 {
+	int cg1, cg2;
+
 	if (!battery->bat.dev)
 		return;
 
+	cg1 = battery->capacity_granularity_1;
+	cg2 = battery->capacity_granularity_2;
+
 	acpi_battery_get_info(battery);
+
+	if (cg1 == battery->capacity_granularity_1 &&
+					cg2 == capacity_granularity_2)
+		return;
+
 	/* The battery may have changed its reporting units. */
 	sysfs_remove_battery(battery);
 	sysfs_add_battery(battery);
