Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab2LTBzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 20:55:52 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38293 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab2LTBzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 20:55:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 16/16] ACPI: Drop ACPI device .bind() and .unbind() callbacks
Date: Thu, 20 Dec 2012 03:00 +0100
Message-ID: <2326457.ZgAhayTgyl@vostro.rjw.lan>
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

Drop the .bind() and .unbind() that have no more users from
struct acpi_device_ops and remove all of the code referring to
them from drivers/acpi/scan.c.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c     |   22 ----------------------
 include/acpi/acpi_bus.h |    2 --
 2 files changed, 24 deletions(-)

Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -1426,29 +1426,11 @@ static int acpi_bus_remove(struct acpi_d
 	if (!rmdevice)
 		return 0;
 
-	/*
-	 * unbind _ADR-Based Devices when hot removal
-	 */
-	if (dev->flags.bus_address) {
-		if ((dev->parent) && (dev->parent->ops.unbind))
-			dev->parent->ops.unbind(dev);
-	}
 	acpi_device_unregister(dev, ACPI_BUS_REMOVAL_EJECT);
 
 	return 0;
 }
 
-/*
- * acpi_hot_add_bind - Bind _ADR-based devices on hot-add.
- * @device: ACPI device node to bind.
- */
-static void acpi_hot_add_bind(struct acpi_device *device)
-{
-	if (device->flags.bus_address
-	    && device->parent && device->parent->ops.bind)
-		device->parent->ops.bind(device);
-}
-
 static int acpi_add_single_object(struct acpi_device **child,
 				  acpi_handle handle, int type,
 				  unsigned long long sta, bool match_driver)
@@ -1520,9 +1502,6 @@ static int acpi_add_single_object(struct
 	device->flags.match_driver = match_driver;
 	result = acpi_device_register(device);
 
-	if (device->flags.match_driver)
-		acpi_hot_add_bind(device);
-
 end:
 	if (!result) {
 		acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
@@ -1625,7 +1604,6 @@ static acpi_status acpi_bus_check_add(ac
 		return AE_CTRL_DEPTH;
 
 	device->flags.match_driver = true;
-	acpi_hot_add_bind(device);
 
  out:
 	if (!*return_value)
Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -99,8 +99,6 @@ struct acpi_device_ops {
 	acpi_op_add add;
 	acpi_op_remove remove;
 	acpi_op_start start;
-	acpi_op_bind bind;
-	acpi_op_unbind unbind;
 	acpi_op_notify notify;
 };
 

