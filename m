Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab2LTB4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:56:23 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38320 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab2LTBzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:55:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 6/16] ACPI: Change the ordering of acpi_bus_check_add()
Date: Thu, 20 Dec 2012 02:51:39 +0100
Message-ID: <2653336.2sGpJboDsC@vostro.rjw.lan>
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


If acpi_bus_check_add() is called for a handle already having an
existing struct acpi_device object attached, it is not necessary to
check the type and status of the device correspondig to it, so
change the ordering of acpi_bus_check_add() to avoid that.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
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
@@ -1598,18 +1602,14 @@ static acpi_status acpi_bus_check_add(ac
 		return AE_CTRL_DEPTH;
 	}
 
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
-		acpi_hot_add_bind(device);
-	}
+	device->add_type = context ? ACPI_BUS_ADD_START : ACPI_BUS_ADD_MATCH;
+	acpi_hot_add_bind(device);
 
+ out:
 	if (!*return_value)
 		*return_value = device;
 

