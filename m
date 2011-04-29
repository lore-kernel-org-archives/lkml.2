Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977Ab1D2WVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:21:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37396 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451Ab1D2WVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:21:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI / ACPI: Report _OSC control mask returned on failure to get control
Date: Sat, 30 Apr 2011 00:21:38 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-pci@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104300021.38386.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If an attempt to get _OSC control of the PCIe native features from
the BIOS fails, report the resulting mask of control flags the BIOS
was willing to grant in the error message.  Moreover, if the _OSC
support mask is insufficient for requesting control of the PCIe
native features or pcie_ports_disabled is set, print a diagnostic
message containing the _OSC support mask.  This helps to diagnose
obscure _OSC-related problems on a number machines.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/pci_root.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/acpi/pci_root.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_root.c
+++ linux-2.6/drivers/acpi/pci_root.c
@@ -596,12 +596,18 @@ static int __devinit acpi_pci_root_add(s
 			dev_info(root->bus->bridge,
 				"ACPI _OSC control (0x%02x) granted\n", flags);
 		} else {
-			dev_dbg(root->bus->bridge,
-				"ACPI _OSC request failed (code %d)\n", status);
-			printk(KERN_INFO "Unable to assume _OSC PCIe control. "
-				"Disabling ASPM\n");
+			dev_info(root->bus->bridge,
+				"ACPI _OSC request failed (%s), "
+				"returned control mask: 0x%02x\n",
+				acpi_format_exception(status), flags);
+			pr_info("ACPI _OSC control for PCIe not granted, "
+				"disabling ASPM\n");
 			pcie_no_aspm();
 		}
+	} else {
+		dev_info(root->bus->bridge,
+			 "Unable to request _OSC control "
+			 "(_OSC support mask: 0x%02x)\n", flags);
 	}
 
 	pci_acpi_add_bus_pm_notifier(device, root->bus);
