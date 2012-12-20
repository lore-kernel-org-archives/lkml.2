Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab2LTB5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:57:13 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38313 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab2LTBzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:55:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 3/16] ACPI: Make acpi_bus_add() and acpi_bus_start() visibly different
Date: Thu, 20 Dec 2012 02:49:23 +0100
Message-ID: <2142403.Kbj784bOTj@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1855256.SyhOJGYMIh@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <4082842.31rfDviYHK@vostro.rjw.lan> <1855256.SyhOJGYMIh@vostro.rjw.lan>
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
Acked-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/scan.c |   63 ++++++++++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 28 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -1623,10 +1623,9 @@ static acpi_status acpi_bus_check_add(ac
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
@@ -1642,16 +1641,11 @@ static acpi_status acpi_bus_probe_start(
 	if (acpi_bus_get_device(handle, &device))
 		return AE_CTRL_DEPTH;
 
-	if (ops->acpi_op_add) {
-		if (!acpi_match_device_ids(device, acpi_platform_device_ids)) {
-			/* This is a known good platform device. */
-			acpi_create_platform_device(device);
-		} else if (device_attach(&device->dev)) {
-			status = AE_CTRL_DEPTH;
-		}
-	} else if (ops->acpi_op_start) {
-		if (ACPI_FAILURE(acpi_start_single_object(device)))
-			status = AE_CTRL_DEPTH;
+	if (!acpi_match_device_ids(device, acpi_platform_device_ids)) {
+		/* This is a known good platform device. */
+		acpi_create_platform_device(device);
+	} else if (device_attach(&device->dev)) {
+		status = AE_CTRL_DEPTH;
 	}
 	return status;
 }
@@ -1672,10 +1666,10 @@ static int acpi_bus_scan(acpi_handle han
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
@@ -1700,31 +1694,44 @@ int
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
 
+	/*
+	 * Ignore errors ignored by acpi_bus_check_add() to avoid terminating
+	 * namespace walks prematurely.
+	 */
+	if (acpi_bus_type_and_status(handle, &type_not_used, &sta_not_used))
+		return AE_OK;
+
+	if (acpi_bus_get_device(handle, &device))
+		return AE_CTRL_DEPTH;
+
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
 

