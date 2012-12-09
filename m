Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934658Ab2LIXBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 18:01:33 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:50202 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934589Ab2LIW76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 17:59:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 3/6] ACPI: Make acpi_bus_add() and acpi_bus_start() visibly different
Date: Mon, 10 Dec 2012 00:01:41 +0100
Message-ID: <1693581.lT8eSoGRfL@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc8; KDE/4.9.3; x86_64; ; )
In-Reply-To: <8498184.VilrUmatxI@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The current ACPI namespace scanning code suggests that acpi_bus_add()
and acpi_bus_start() share some code.  In fact, however, they are
completely different code paths, so refactor the code to make that
distinction visibly clear.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   57 ++++++++++++++++++++++++----------------------------
 1 file changed, 27 insertions(+), 30 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -1626,28 +1626,22 @@ static acpi_status acpi_bus_check_add(ac
 	return AE_OK;
 }
 
-static acpi_status acpi_bus_probe_start(acpi_handle handle, u32 lvl,
-					void *context, void **not_used)
+static acpi_status acpi_bus_match_device(acpi_handle handle, u32 lvl,
+					 void *not_used, void **ret_not_used)
 {
-	struct acpi_bus_ops *ops = context;
 	struct acpi_device *device;
 	acpi_status status = AE_OK;
 
 	if (acpi_bus_get_device(handle, &device))
 		return AE_CTRL_DEPTH;
 
-	if (ops->acpi_op_add) {
-		if (!acpi_match_device_ids(device, acpi_platform_device_ids)) {
-			/* This is a known good platform device. */
-			acpi_create_platform_device(device);
-		} else {
-			int ret = device_attach(&device->dev);
-			acpi_hot_add_bind(device);
-			if (ret)
-				status = AE_CTRL_DEPTH;
-		}
-	} else if (ops->acpi_op_start) {
-		if (ACPI_FAILURE(acpi_start_single_object(device)))
+	if (!acpi_match_device_ids(device, acpi_platform_device_ids)) {
+		/* This is a known good platform device. */
+		acpi_create_platform_device(device);
+	} else {
+		int ret = device_attach(&device->dev);
+		acpi_hot_add_bind(device);
+		if (ret)
 			status = AE_CTRL_DEPTH;
 	}
 	return status;
@@ -1670,7 +1664,7 @@ static int acpi_bus_scan(acpi_handle han
 			    acpi_bus_check_add, NULL, ops, &device);
 	if (device)
 		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
-				    acpi_bus_probe_start, NULL, ops, NULL);
+				    acpi_bus_match_device, NULL, NULL, NULL);
 	else
 		ret = -ENODEV;
 
@@ -1697,31 +1691,34 @@ int
 acpi_bus_add(struct acpi_device **child,
 	     struct acpi_device *parent, acpi_handle handle, int type)
 {
-	struct acpi_bus_ops ops;
-
-	memset(&ops, 0, sizeof(ops));
-	ops.acpi_op_add = 1;
+	struct acpi_bus_ops ops = { .acpi_op_add = 1, };
 
 	return acpi_bus_scan(handle, &ops, child);
 }
 EXPORT_SYMBOL(acpi_bus_add);
 
-int acpi_bus_start(struct acpi_device *device)
+static acpi_status acpi_bus_start_device(acpi_handle handle, u32 lvl,
+					 void *not_used, void **ret_not_used)
 {
-	struct acpi_bus_ops ops;
-	int result;
+	struct acpi_device *device;
+	acpi_status status;
 
-	if (!device)
-		return -EINVAL;
+	if (acpi_bus_get_device(handle, &device))
+		return AE_CTRL_DEPTH;
 
-	memset(&ops, 0, sizeof(ops));
-	ops.acpi_op_start = 1;
+	status = acpi_start_single_object(device);
+	return ACPI_SUCCESS(status) ? status : AE_CTRL_DEPTH;
+}
 
-	result = acpi_bus_scan(device->handle, &ops, NULL);
+int acpi_bus_start(struct acpi_device *device)
+{
+	if (!device)
+		return -EINVAL;
 
+	acpi_walk_namespace(ACPI_TYPE_ANY, device->handle, ACPI_UINT32_MAX,
+			    acpi_bus_start_device, NULL, NULL, NULL);
 	acpi_update_all_gpes();
-
-	return result;
+	return 0;
 }
 EXPORT_SYMBOL(acpi_bus_start);
 

