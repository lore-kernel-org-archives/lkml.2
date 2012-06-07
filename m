Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933964Ab2FGE0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:26:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933735Ab2FGE0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:26:12 -0400
Message-Id: <20120607041404.746379056@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:14:44 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andy Whitcroft <apw@canonical.com>,
        Ralf Jung <post@ralfj.de>, Len Brown <len.brown@intel.com>
Subject: [ 46/47] ACPI battery: only refresh the sysfs files when pertinent information changes
In-Reply-To: <20120607041504.GA13819@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/battery.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -635,11 +635,19 @@ static int acpi_battery_update(struct ac
 
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


