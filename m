Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab2JAXBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:01:45 -0400
Received: from 1wt.eu ([62.212.114.60]:35404 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932976Ab2JAXBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:39 -0400
Message-Id: <20121001225202.139698914@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:44 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Lan Tianyu <tianyu.lan@intel.com>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 107/180] ACPI/AC: prevent OOPS on some boxes due to missing check power_supply_register() return value check
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/acpi/ac.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index b6ed60b..bc3f918 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -287,7 +287,9 @@ static int acpi_ac_add(struct acpi_device *device)
 	ac->charger.properties = ac_props;
 	ac->charger.num_properties = ARRAY_SIZE(ac_props);
 	ac->charger.get_property = get_ac_property;
-	power_supply_register(&ac->device->dev, &ac->charger);
+	result = power_supply_register(&ac->device->dev, &ac->charger);
+	if (result)
+		goto end;
 #endif
 
 	printk(KERN_INFO PREFIX "%s [%s] (%s)\n",
-- 
1.7.2.1.45.g54fbc



