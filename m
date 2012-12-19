Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab2LSLWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 06:22:13 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:37602 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab2LSLWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 06:22:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI: Rework acpi_get_child() to be more efficient
Date: Wed, 19 Dec 2012 12:27:18 +0100
Message-ID: <1644954.gUaZqebo61@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Observe that acpi_get_child() doesn't need to use the helper
struct acpi_find_child structure and change it to work without it.

Moreover, acpi_get_child() doesn't need to loop any more once it has
found a matching handle, so make it stop in that case.  To prevent
the results from changing, make it use do_acpi_find_child() as a
post-order callback.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c |   36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

Index: linux/drivers/acpi/glue.c
===================================================================
--- linux.orig/drivers/acpi/glue.c
+++ linux/drivers/acpi/glue.c
@@ -90,38 +90,34 @@ static int acpi_find_bridge_device(struc
 	return ret;
 }
 
-/* Get device's handler per its address under its parent */
-struct acpi_find_child {
-	acpi_handle handle;
-	u64 address;
-};
-
-static acpi_status
-do_acpi_find_child(acpi_handle handle, u32 lvl, void *context, void **rv)
+static acpi_status do_acpi_find_child(acpi_handle handle, u32 lvl_not_used,
+				      void *addr_p, void **ret_p)
 {
-	acpi_status status;
 	struct acpi_device_info *info;
-	struct acpi_find_child *find = context;
 
-	status = acpi_get_object_info(handle, &info);
-	if (ACPI_SUCCESS(status)) {
-		if ((info->address == find->address)
-			&& (info->valid & ACPI_VALID_ADR))
-			find->handle = handle;
-		kfree(info);
+	if (ACPI_SUCCESS(acpi_get_object_info(handle, &info))) {
+		bool found = info->address == *((u64 *)addr_p)
+				&& (info->valid & ACPI_VALID_ADR);
+
+		ACPI_FREE(info);
+		if (found) {
+			*ret_p = handle;
+			return AE_CTRL_TERMINATE;
+		}
 	}
 	return AE_OK;
 }
 
 acpi_handle acpi_get_child(acpi_handle parent, u64 address)
 {
-	struct acpi_find_child find = { NULL, address };
+	void *ret = NULL;
 
 	if (!parent)
 		return NULL;
-	acpi_walk_namespace(ACPI_TYPE_DEVICE, parent,
-			    1, do_acpi_find_child, NULL, &find, NULL);
-	return find.handle;
+
+	acpi_walk_namespace(ACPI_TYPE_DEVICE, parent, 1, NULL,
+			    do_acpi_find_child, &address, &ret);
+	return (acpi_handle)ret;
 }
 
 EXPORT_SYMBOL(acpi_get_child);

