Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab2LMWTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:19:44 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:32828 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab2LMWSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:18:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH rev.2 3/6] ACPI: Make acpi_bus_add() and acpi_bus_start() visibly different
Date: Thu, 13 Dec 2012 23:21:09 +0100
Message-ID: <6125262.Gkj20UX9S9@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1499423.ez5cZl2uAf@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <1499423.ez5cZl2uAf@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The current ACPI namespace scanning code suggests that acpi_bus_add()
and acpi_bus_start() share some code.  In fact, however, they are
completely different code paths (except for the initial checks), so
refactor the code to make that distinction visibly clear.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   68 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -1622,10 +1622,9 @@ static acpi_status acpi_bus_check_add(ac
 	return AE_OK;
 }
 
-static acpi_status acpi_bus_probe_start(acpi_handle handle, u32 lvl,
-					void *context, void **not_used)
+static acpi_status acpi_bus_device_attach(acpi_handle handle, u32 lvl_not_used,
+					  void *not_used, void **ret_not_used)
 {
-	struct acpi_bus_ops *ops = context;
 	acpi_status status = AE_OK;
 	struct acpi_device *device;
 	unsigned long long sta_not_used;
@@ -1641,18 +1640,13 @@ static acpi_status acpi_bus_probe_start(
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
@@ -1674,10 +1668,10 @@ static int acpi_bus_scan(acpi_handle han
 		goto out;
 
 	ret = 0;
-	status = acpi_bus_probe_start(handle, 0, ops, NULL);
+	status = acpi_bus_device_attach(handle, 0, NULL, NULL);
 	if (ACPI_SUCCESS(status))
 		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
-				    acpi_bus_probe_start, NULL, ops, NULL);
+				    acpi_bus_device_attach, NULL, NULL, NULL);
 
  out:
 	if (child)
@@ -1702,31 +1696,45 @@ int
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
+	unsigned long long sta_not_used;
+	int type_not_used;
+	acpi_status status;
+
+	/*
+	 * Ignore errors ignored by acpi_bus_check_add() to avoid terminating
+	 * namespace walks prematurely.
+	 */
+	if (acpi_bus_type_and_status(handle, &type_not_used, &sta_not_used))
+		return AE_OK;
+
+	if (acpi_bus_get_device(handle, &device))
+		return AE_CTRL_DEPTH;
 
+	return acpi_start_single_object(device);
+}
+
+int acpi_bus_start(struct acpi_device *device)
+{
 	if (!device)
 		return -EINVAL;
 
-	memset(&ops, 0, sizeof(ops));
-	ops.acpi_op_start = 1;
-
-	result = acpi_bus_scan(device->handle, &ops, NULL);
+	if (ACPI_SUCCESS(acpi_start_single_object(device)))
+		acpi_walk_namespace(ACPI_TYPE_ANY, device->handle,
+				    ACPI_UINT32_MAX, acpi_bus_start_device,
+				    NULL, NULL, NULL);
 
 	acpi_update_all_gpes();
-
-	return result;
+	return 0;
 }
 EXPORT_SYMBOL(acpi_bus_start);
 

