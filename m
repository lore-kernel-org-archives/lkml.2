Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946126Ab2LGG0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 01:26:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946003Ab2LGG0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 01:26:02 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 11/15] PCI/ACPI: Fix latent refcount issue in
	acpi_pci_root_start()
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yinghai@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 23:25:59 -0700
Message-ID: <20121207062559.11051.18764.stgit@amt.stowe>
In-Reply-To: <20121207062454.11051.12739.stgit@amt.stowe>
References: <20121207062454.11051.12739.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During early boot, the kernel performs ACPI enumeration in which host
bridges are discovered (subsys_initcall(acpi_pci_root_init)).  Later
drivers, both built-in and modules such as the "ACPI PCI Slot Detection
Driver ("pci_slot")", are loaded (module_init(acpi_pci_slot_init)) thus we
end up with the following call chain:
  acpi_pci_root_start
    list_for_each_entry(..., acpi_pci_drivers, ...)
      driver->add(root)		# always no-op; list empty
    pci_bus_add_devices
  acpi_pci_slot_init		# module_init
    acpi_pci_register_driver(acpi_pci_slot_driver)
      list_for_each_entry(..., &acpi_pci_roots, ...)
        driver->add(root)	# acpi_pci_slot_add()

Note that for host bridges present at boot time the 'acpi_pci_drivers'
list is always empty when acpi_pci_root_start() runs.

However, during a Host Bridge hot-add event, the "pci_slot" sub-driver is
already on the 'acpi_pci_drivers' list and we end up calling
acpi_pci_slot_add() before pci_bus_add_devices() and encounter the
following refcount WARNING:
  calling acpi_pci_slot_add():
  pci_bus 0000:03: dev 00, created physical slot 1
  ------------[ cut here ]------------
  WARNING: at include/linux/kref.h:42 kobject_get+0x32/0x40()
  Call Trace:
   [<ffffffff812541d2>] kobject_get+0x32/0x40
   [<ffffffff8133f0f9>] get_device+0x19/0x20
   [<ffffffff812d9f11>] register_slot+0x216/0x26d
   [<ffffffff812ce92f>] acpi_walk_namespace+0x8a/0xc4
   [<ffffffff812d9cb9>] walk_p2p_bridge+0xf1/0x133
   [<ffffffff812ce92f>] acpi_walk_namespace+0x8a/0xc4
   [<ffffffff812d9b71>] acpi_pci_slot_add+0xe0/0x137
   [<ffffffff812b8705>] acpi_pci_root_start+0x3e/0x59

This patch fixes this latent issue by moving up pci_bus_add_devices() so
that the refcount will be initialized before subsequent references, via
driver additions from the 'acpi_pci_drivers' list, occur.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/acpi/pci_root.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index d890322..f9be8fb 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -644,6 +644,8 @@ static int acpi_pci_root_start(struct acpi_device *device)
 	struct acpi_pci_root *root = acpi_driver_data(device);
 	struct acpi_pci_driver *driver;
 
+	pci_bus_add_devices(root->bus);
+
 	mutex_lock(&acpi_pci_root_lock);
 	list_for_each_entry(driver, &acpi_pci_drivers, node)
 		if (driver->add)
@@ -651,8 +653,6 @@ static int acpi_pci_root_start(struct acpi_device *device)
 	acpiphp_add_bridge(root);
 	mutex_unlock(&acpi_pci_root_lock);
 
-	pci_bus_add_devices(root->bus);
-
 	return 0;
 }
 

