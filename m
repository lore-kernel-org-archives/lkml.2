Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2LMWSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:18:44 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:32834 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab2LMWSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:18:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH rev.2 2/6] ACPI: Change the ordering of PCI root bridge driver registrarion
Date: Thu, 13 Dec 2012 23:18:58 +0100
Message-ID: <9432446.AtiBizH0Mr@vostro.rjw.lan>
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

Instead of running acpi_pci_root_init() from a separate subsys
initcall, call it directly from acpi_scan_init() before scanning the
ACPI namespace for the first time, so that the PCI root bridge
driver's .add() routine, acpi_pci_root_start(), is always run
before binding ACPI drivers or attaching "companion" device objects
to struct acpi_device objects below the root bridge's device node in
the ACPI namespace.

The first, simpler reason for doing this is that it makes the
situation during boot more similar to the situation during hotplug,
in which the ACPI PCI root bridge driver is always present.

The second reason is that acpi_pci_root_init() causes struct pci_dev
objects to be created for all PCI devices below the bridge and
these objects may be necessary for whatever is done with the other
ACPI device nodes in that namespace scope.  For example, devices
created by acpi_create_platform_device() sometimes may need to be
added to the device hierarchy as children of PCI bridges.  For this
purpose, however, the struct pci_dev objects representing those
bridges need to exist before the platform devices in question are
registered.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/internal.h |    1 +
 drivers/acpi/pci_root.c |    4 +---
 drivers/acpi/scan.c     |    1 +
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/drivers/acpi/internal.h
===================================================================
--- linux.orig/drivers/acpi/internal.h
+++ linux/drivers/acpi/internal.h
@@ -67,6 +67,7 @@ struct acpi_ec {
 
 extern struct acpi_ec *first_ec;
 
+int acpi_pci_root_init(void);
 int acpi_ec_init(void);
 int acpi_ec_ecdt_probe(void);
 int acpi_boot_ec_enable(void);
Index: linux/drivers/acpi/pci_root.c
===================================================================
--- linux.orig/drivers/acpi/pci_root.c
+++ linux/drivers/acpi/pci_root.c
@@ -674,7 +674,7 @@ static int acpi_pci_root_remove(struct a
 	return 0;
 }
 
-static int __init acpi_pci_root_init(void)
+int __init acpi_pci_root_init(void)
 {
 	acpi_hest_init();
 
@@ -687,5 +687,3 @@ static int __init acpi_pci_root_init(voi
 
 	return 0;
 }
-
-subsys_initcall(acpi_pci_root_init);
Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -1833,6 +1833,7 @@ int __init acpi_scan_init(void)
 	}
 
 	acpi_power_init();
+	acpi_pci_root_init();
 
 	/*
 	 * Enumerate devices in the ACPI namespace.

