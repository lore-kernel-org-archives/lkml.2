Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab0KXXRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:17:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52751 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163Ab0KXXRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:17:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 9/13] ACPI / PM: Register acpi_power_driver early
Date: Thu, 25 Nov 2010 00:10:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc3+; KDE/4.4.4; x86_64; ; )
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <201011250001.11297.rjw@sisk.pl>
In-Reply-To: <201011250001.11297.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011250010.02778.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The ACPI device driver used for handling power resources,
acpi_power_driver, creates a struct acpi_power_resource object for
each ACPI device representing a power resource.  These objects are
then used when setting and reading the power states of devices using
the corresponding power resources.  Unfortunately, acpi_power_driver
is registered after acpi_scan_init() that may add devices using the
power resources before acpi_power_driver has a chance to create
struct acpi_power_resource objects for them (specifically, the power
resources may be referred to during the scanning process through
acpi_bus_get_power() before they have been initialized).

As the first step towards fixing this issue, move the registration
of acpi_power_driver into acpi_scan_init() so that power resource
devices can be initialized by it as soon as they have been found in
the namespace.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/bus.c  |    1 -
 drivers/acpi/scan.c |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/bus.c
===================================================================
--- linux-2.6.orig/drivers/acpi/bus.c
+++ linux-2.6/drivers/acpi/bus.c
@@ -1099,7 +1099,6 @@ static int __init acpi_init(void)
 
 	acpi_scan_init();
 	acpi_ec_init();
-	acpi_power_init();
 	acpi_debugfs_init();
 	acpi_sleep_proc_init();
 	acpi_wakeup_device_init();
Index: linux-2.6/drivers/acpi/scan.c
===================================================================
--- linux-2.6.orig/drivers/acpi/scan.c
+++ linux-2.6/drivers/acpi/scan.c
@@ -1547,6 +1547,8 @@ int __init acpi_scan_init(void)
 		printk(KERN_ERR PREFIX "Could not register bus type\n");
 	}
 
+	acpi_power_init();
+
 	/*
 	 * Enumerate devices in the ACPI namespace.
 	 */

