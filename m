Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031157Ab2HGWqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:46:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36543 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031033Ab2HGWqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:46:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lan Tianyu <tianyu.lan@intel.com>, Len Brown <len.brown@intel.com>
Subject: [ 18/49] ACPI/AC: prevent OOPS on some boxes due to missing check power_supply_register() return value check
Date: Tue,  7 Aug 2012 15:44:36 -0700
Message-Id: <20120807222028.519296642@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit f197ac13f6eeb351b31250b9ab7d0da17434ea36 upstream.

In the ac.c, power_supply_register()'s return value is not checked.

As a result, the driver's add() ops may return success
even though the device failed to initialize.

For example, some BIOS may describe two ACADs in the same DSDT.
The second ACAD device will fail to register,
but ACPI driver's add() ops returns sucessfully.
The ACPI device will receive ACPI notification and cause OOPS.

https://bugzilla.redhat.com/show_bug.cgi?id=772730

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/ac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -292,7 +292,9 @@ static int acpi_ac_add(struct acpi_devic
 	ac->charger.properties = ac_props;
 	ac->charger.num_properties = ARRAY_SIZE(ac_props);
 	ac->charger.get_property = get_ac_property;
-	power_supply_register(&ac->device->dev, &ac->charger);
+	result = power_supply_register(&ac->device->dev, &ac->charger);
+	if (result)
+		goto end;
 
 	printk(KERN_INFO PREFIX "%s [%s] (%s)\n",
 	       acpi_device_name(device), acpi_device_bid(device),


