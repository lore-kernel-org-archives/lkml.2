Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab2LPNwP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 08:52:15 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35409 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab2LPNwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 08:52:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH 4/6] ACPI: Drop the second argument of acpi_bus_scan()
Date: Sun, 16 Dec 2012 14:52:35 +0100
Message-ID: <1678273.jPdHqatAlf@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <4532917.9APhB4xTvi@vostro.rjw.lan>
References: <4532917.9APhB4xTvi@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After the removal of acpi_start_single_object() and acpi_bus_start()
the second argument of acpi_bus_scan() is not necessary any more,
so drop it and update acpi_bus_check_add() accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -1592,8 +1592,8 @@ static int acpi_bus_type_and_status(acpi
 	return 0;
 }
 
-static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl,
-				      void *context, void **return_value)
+static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
+				      void *not_used, void **return_value)
 {
 	struct acpi_device *device = NULL;
 	int type;
@@ -1625,7 +1625,7 @@ static acpi_status acpi_bus_check_add(ac
 	if (!device)
 		return AE_CTRL_DEPTH;
 
-	device->add_type = context ? ACPI_BUS_ADD_START : ACPI_BUS_ADD_MATCH;
+	device->add_type = ACPI_BUS_ADD_START;
 
  out:
 	if (!*return_value)
@@ -1664,18 +1664,16 @@ static acpi_status acpi_bus_device_attac
 	return status;
 }
 
-static int acpi_bus_scan(acpi_handle handle, bool start,
-			 struct acpi_device **child)
+static int acpi_bus_scan(acpi_handle handle, struct acpi_device **child)
 {
 	void *device = NULL;
 	acpi_status status;
 	int ret = -ENODEV;
 
-	status = acpi_bus_check_add(handle, 0, (void *)start, &device);
+	status = acpi_bus_check_add(handle, 0, NULL, &device);
 	if (ACPI_SUCCESS(status))
 		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
-				    acpi_bus_check_add, NULL, (void *)start,
-				    &device);
+				    acpi_bus_check_add, NULL, NULL, &device);
 
 	if (!device)
 		goto out;
@@ -1719,7 +1717,7 @@ int acpi_bus_add(acpi_handle handle, str
 {
 	int err;
 
-	err = acpi_bus_scan(handle, false, ret);
+	err = acpi_bus_scan(handle, ret);
 	if (err)
 		return err;
 
@@ -1825,7 +1823,7 @@ int __init acpi_scan_init(void)
 	/*
 	 * Enumerate devices in the ACPI namespace.
 	 */
-	result = acpi_bus_scan(ACPI_ROOT_OBJECT, true, &acpi_root);
+	result = acpi_bus_scan(ACPI_ROOT_OBJECT, &acpi_root);
 
 	if (!result)
 		result = acpi_bus_scan_fixed();

