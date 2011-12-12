Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1LLW7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:59:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54437 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab1LLW7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:59:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH][Regression fix] PCI / Hotplug: Always allow acpiphp to handle non-PCIe bridges
Date: Tue, 13 Dec 2011 00:02:28 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112130002.28907.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit 0d52f54e2ef64c189dedc332e680b2eb4a34590a (PCI / ACPI: Make
acpiphp ignore root bridges using PCIe native hotplug) added code
that made the acpiphp driver completely ignore PCIe root complexes
for which the kernel had been granted control of the native PCIe
hotplug feature by the BIOS through _OSC.  Unfortunately, however,
this was a mistake, because on some systems there were PCI bridges
supporting PCI (non-PCIe) hotplug under such root complexes and
those bridges should have been handled by acpiphp.

For this reason, revert the changes made by the commit mentioned
above and make register_slot() in drivers/pci/hotplug/acpiphp_glue.c
avoid registering hotplug slots for PCIe ports that belong to
root complexes with native PCIe hotplug enabled (which means that
the BIOS has granted the kernel control of this feature for the
given root complex).  This is reported to address the original
issue fixed by commit 0d52f54e2ef64c189dedc332e680b2eb4a34590a and
to work on the system where that commit broke things.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/hotplug/acpiphp_glue.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

Index: linux/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux/drivers/pci/hotplug/acpiphp_glue.c
@@ -132,6 +132,18 @@ register_slot(acpi_handle handle, u32 lv
 	if (!acpi_pci_check_ejectable(pbus, handle) && !is_dock_device(handle))
 		return AE_OK;
 
+	pdev = pbus->self;
+	if (pdev && pci_is_pcie(pdev)) {
+		tmp = acpi_find_root_bridge_handle(pdev);
+		if (tmp) {
+			struct acpi_pci_root *root = acpi_pci_find_root(tmp);
+
+			if (root && (root->osc_control_set &
+					OSC_PCI_EXPRESS_NATIVE_HP_CONTROL))
+				return AE_OK;
+		}
+	}
+
 	acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
 	device = (adr >> 16) & 0xffff;
 	function = adr & 0xffff;
@@ -459,17 +471,8 @@ static int add_bridge(acpi_handle handle
 {
 	acpi_status status;
 	unsigned long long tmp;
-	struct acpi_pci_root *root;
 	acpi_handle dummy_handle;
 
-	/*
-	 * We shouldn't use this bridge if PCIe native hotplug control has been
-	 * granted by the BIOS for it.
-	 */
-	root = acpi_pci_find_root(handle);
-	if (root && (root->osc_control_set & OSC_PCI_EXPRESS_NATIVE_HP_CONTROL))
-		return -ENODEV;
-
 	/* if the bridge doesn't have _STA, we assume it is always there */
 	status = acpi_get_handle(handle, "_STA", &dummy_handle);
 	if (ACPI_SUCCESS(status)) {
@@ -1385,19 +1388,11 @@ static void handle_hotplug_event_func(ac
 static acpi_status
 find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
-	struct acpi_pci_root *root;
 	int *count = (int *)context;
 
 	if (!acpi_is_root_bridge(handle))
 		return AE_OK;
 
-	root = acpi_pci_find_root(handle);
-	if (!root)
-		return AE_OK;
-
-	if (root->osc_control_set & OSC_PCI_EXPRESS_NATIVE_HP_CONTROL)
-		return AE_OK;
-
 	(*count)++;
 	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 				    handle_hotplug_event_bridge, NULL);
