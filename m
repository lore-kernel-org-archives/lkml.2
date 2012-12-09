Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934605Ab2LIXAA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 18:00:00 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:50185 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934578Ab2LIW75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 17:59:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 6/6] ACPI: Change the ordering of acpi_bus_check_add()
Date: Mon, 10 Dec 2012 00:04:36 +0100
Message-ID: <2268672.Pe9OEEVsRc@vostro.rjw.lan>
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

If acpi_bus_check_add() is called for a handle already having an
existing struct acpi_device object attached, it is not necessary to
check the type and status of the device correspondig to it, so
change the ordering of acpi_bus_check_add() to avoid that.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -1582,6 +1582,10 @@ static acpi_status acpi_bus_check_add(ac
 	acpi_status status;
 	int result;
 
+	acpi_bus_get_device(handle, &device);
+	if (device)
+		goto out;
+
 	result = acpi_bus_type_and_status(handle, &type, &sta);
 	if (result)
 		return AE_OK;
@@ -1602,17 +1606,13 @@ static acpi_status acpi_bus_check_add(ac
 	 * We may already have an acpi_device from a previous enumeration.  If
 	 * so, we needn't add it again, but we may still have to start it.
 	 */
-	acpi_bus_get_device(handle, &device);
-	if (!device) {
-		acpi_add_single_object(&device, handle, type, sta,
-				       ACPI_BUS_ADD_BASIC);
-		if (!device)
-			return AE_CTRL_DEPTH;
+	acpi_add_single_object(&device, handle, type, sta, ACPI_BUS_ADD_BASIC);
+	if (!device)
+		return AE_CTRL_DEPTH;
 
-		device->add_type = context ?
-					ACPI_BUS_ADD_START : ACPI_BUS_ADD_MATCH;
-	}
+	device->add_type = context ? ACPI_BUS_ADD_START : ACPI_BUS_ADD_MATCH;
 
+ out:
 	if (!*return_value)
 		*return_value = device;
 

