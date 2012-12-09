Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab2LIXBM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 18:01:12 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:50206 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934595Ab2LIW77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 17:59:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 2/6] ACPI: Change the ordering of PCI root bridge driver registrarion
Date: Mon, 10 Dec 2012 00:00:47 +0100
Message-ID: <1772854.QSySvgjB3i@vostro.rjw.lan>
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

Devices created by acpi_create_platform_device() sometimes may need
to be added to the device hierarchy as children of PCI bridges.  For
this purpose, however, the struct pci_dev objects representing those
bridges need to exist before the platform devices in question are
added, but this is only possible if the PCI root bridge driver is
registered before the initial scanning of the ACPI namespace
(that driver's .add() routine creates the required struct pci_dev
objects).

For this reason, call acpi_pci_root_init() from acpi_scan_init()
before scanning the ACPI namespace for the first time instead of
running it from a separate subsys initcall.  Since the previous patch
has changed the ACPI namespace scanning algorithm, this change does
not affect the PCI root bridge driver's functionality during boot.
It also makes the situation during boot more similar to the situation
during hot-plug (in which the PCI root bridge driver is always
present) and so it helps to reduce arbitary differences between
the hot-plug and boot PCI root bridge code.

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
@@ -1828,6 +1828,7 @@ int __init acpi_scan_init(void)
 	}
 
 	acpi_power_init();
+	acpi_pci_root_init();
 
 	/*
 	 * Enumerate devices in the ACPI namespace.

