Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2ILUh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 16:37:27 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:24051 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab2ILUhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 16:37:25 -0400
From: Toshi Kani <toshi.kani@hp.com>
To: linux-acpi@vger.kernel.org, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, shli@fusionio.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI: dock: Remove redundant ACPI NS walk
Date: Wed, 12 Sep 2012 14:30:49 -0600
Message-Id: <1347481849-17973-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combined two ACPI namespace walks, which look for dock stations
and then bays separately, into a single walk.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/dock.c |   26 +++++++-------------------
 1 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 88eb143..ae4ebf2 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -1016,44 +1016,32 @@ static int dock_remove(struct dock_station *ds)
 }
 
 /**
- * find_dock - look for a dock station
+ * find_dock_and_bay - look for dock stations and bays
  * @handle: acpi handle of a device
  * @lvl: unused
- * @context: counter of dock stations found
+ * @context: unused
  * @rv: unused
  *
- * This is called by acpi_walk_namespace to look for dock stations.
+ * This is called by acpi_walk_namespace to look for dock stations and bays.
  */
 static __init acpi_status
-find_dock(acpi_handle handle, u32 lvl, void *context, void **rv)
+find_dock_and_bay(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
-	if (is_dock(handle))
+	if (is_dock(handle) || is_ejectable_bay(handle))
 		dock_add(handle);
 
 	return AE_OK;
 }
 
-static __init acpi_status
-find_bay(acpi_handle handle, u32 lvl, void *context, void **rv)
-{
-	/* If bay is a dock, it's already handled */
-	if (is_ejectable_bay(handle) && !is_dock(handle))
-		dock_add(handle);
-	return AE_OK;
-}
-
 static int __init dock_init(void)
 {
 	if (acpi_disabled)
 		return 0;
 
-	/* look for a dock station */
+	/* look for dock stations and bays */
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
-			    ACPI_UINT32_MAX, find_dock, NULL, NULL, NULL);
+		ACPI_UINT32_MAX, find_dock_and_bay, NULL, NULL, NULL);
 
-	/* look for bay */
-	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
-			ACPI_UINT32_MAX, find_bay, NULL, NULL, NULL);
 	if (!dock_station_count) {
 		printk(KERN_INFO PREFIX "No dock devices found.\n");
 		return 0;
-- 
1.7.7.6

