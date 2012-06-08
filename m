Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933093Ab2FHFQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:16:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43320 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761367Ab2FHFH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:26 -0400
Message-Id: <20120608041850.955853766@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andy Whitcroft <apw@canonical.com>,
        Ralf Jung <post@ralfj.de>, Len Brown <len.brown@intel.com>
Subject: [ 75/82] ACPI battery: only refresh the sysfs files when pertinent
 information changes
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Whitcroft <apw@canonical.com>

commit c5971456964290da7e98222892797b71ef793e62 upstream.

We only need to regenerate the sysfs files when the capacity units
change, avoid the update otherwise.

The origin of this issue is dates way back to 2.6.38:
da8aeb92d4853f37e281f11fddf61f9c7d84c3cd
(ACPI / Battery: Update information on info notification and resume)

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Tested-by: Ralf Jung <post@ralfj.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/battery.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 86933ca..7dd3f9f 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -643,11 +643,19 @@ static int acpi_battery_update(struct acpi_battery *battery)
 
 static void acpi_battery_refresh(struct acpi_battery *battery)
 {
+	int power_unit;
+
 	if (!battery->bat.dev)
 		return;
 
+	power_unit = battery->power_unit;
+
 	acpi_battery_get_info(battery);
-	/* The battery may have changed its reporting units. */
+
+	if (power_unit == battery->power_unit)
+		return;
+
+	/* The battery has changed its reporting units. */
 	sysfs_remove_battery(battery);
 	sysfs_add_battery(battery);
 }


