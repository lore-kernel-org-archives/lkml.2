Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934672Ab2LIXBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 18:01:49 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:50197 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934585Ab2LIW76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 17:59:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 4/6] ACPI: Reduce the usage of struct acpi_bus_ops
Date: Mon, 10 Dec 2012 00:02:41 +0100
Message-ID: <1661490.lfKgYmIiUQ@vostro.rjw.lan>
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

Objects of type struct acpi_bus_ops are currently used to pass
information between different parts of the ACPI namespace scanning
code, sometimes in quite convoluted ways.  It turns out that that
is not necessary in some cases, so simplify the code by reducing
the utilization of struct acpi_bus_ops objects where clearly
possible.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -1527,7 +1527,6 @@ end:
 static void acpi_bus_add_power_resource(acpi_handle handle)
 {
 	struct acpi_bus_ops ops = {
-		.acpi_op_add = 1,
 		.acpi_op_start = 1,
 		.acpi_op_match = 1,
 	};
@@ -1581,7 +1580,6 @@ static int acpi_bus_type_and_status(acpi
 static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl,
 				      void *context, void **return_value)
 {
-	struct acpi_bus_ops *ops = context;
 	struct acpi_device *device = NULL;
 	int type;
 	unsigned long long sta;
@@ -1609,11 +1607,13 @@ static acpi_status acpi_bus_check_add(ac
 	 * so, we needn't add it again, but we may still have to start it.
 	 */
 	acpi_bus_get_device(handle, &device);
-	if (ops->acpi_op_add && !device) {
-		struct acpi_bus_ops add_ops = *ops;
+	if (!device) {
+		struct acpi_bus_ops ops = {
+			.acpi_op_start = !!context,
+			.acpi_op_match = 0,
+		};
 
-		add_ops.acpi_op_match = 0;
-		acpi_add_single_object(&device, handle, type, sta, &add_ops);
+		acpi_add_single_object(&device, handle, type, sta, &ops);
 		if (!device)
 			return AE_CTRL_DEPTH;
 
@@ -1647,21 +1647,21 @@ static acpi_status acpi_bus_match_device
 	return status;
 }
 
-static int acpi_bus_scan(acpi_handle handle, struct acpi_bus_ops *ops,
+static int acpi_bus_scan(acpi_handle handle, bool start,
 			 struct acpi_device **child)
 {
 	void *device = NULL;
 	acpi_status status;
 	int ret = 0;
 
-	status = acpi_bus_check_add(handle, 0, ops, &device);
+	status = acpi_bus_check_add(handle, 0, (void *)start, &device);
 	if (ACPI_FAILURE(status)) {
 		ret = -ENODEV;
 		goto out;
 	}
 
 	acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
-			    acpi_bus_check_add, NULL, ops, &device);
+			    acpi_bus_check_add, NULL, (void *)start, &device);
 	if (device)
 		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
 				    acpi_bus_match_device, NULL, NULL, NULL);
@@ -1691,9 +1691,7 @@ int
 acpi_bus_add(struct acpi_device **child,
 	     struct acpi_device *parent, acpi_handle handle, int type)
 {
-	struct acpi_bus_ops ops = { .acpi_op_add = 1, };
-
-	return acpi_bus_scan(handle, &ops, child);
+	return acpi_bus_scan(handle, false, child);
 }
 EXPORT_SYMBOL(acpi_bus_add);
 
@@ -1781,12 +1779,10 @@ static int acpi_bus_scan_fixed(void)
 {
 	int result = 0;
 	struct acpi_device *device = NULL;
-	struct acpi_bus_ops ops;
-
-	memset(&ops, 0, sizeof(ops));
-	ops.acpi_op_add = 1;
-	ops.acpi_op_start = 1;
-	ops.acpi_op_match = 1;
+	struct acpi_bus_ops ops = {
+		.acpi_op_start = 1,
+		.acpi_op_match = 1,
+	};
 
 	/*
 	 * Enumerate all fixed-feature devices.
@@ -1812,11 +1808,6 @@ static int acpi_bus_scan_fixed(void)
 int __init acpi_scan_init(void)
 {
 	int result;
-	struct acpi_bus_ops ops;
-
-	memset(&ops, 0, sizeof(ops));
-	ops.acpi_op_add = 1;
-	ops.acpi_op_start = 1;
 
 	result = bus_register(&acpi_bus_type);
 	if (result) {
@@ -1830,7 +1821,7 @@ int __init acpi_scan_init(void)
 	/*
 	 * Enumerate devices in the ACPI namespace.
 	 */
-	result = acpi_bus_scan(ACPI_ROOT_OBJECT, &ops, &acpi_root);
+	result = acpi_bus_scan(ACPI_ROOT_OBJECT, true, &acpi_root);
 
 	if (!result)
 		result = acpi_bus_scan_fixed();

