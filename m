Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1KFWIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 17:08:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53552 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252Ab1KFWIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 17:08:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI / ACPI: Make acpiphp ignore root bridges using SHPC native hotplug
Date: Sun, 6 Nov 2011 23:11:28 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <201110220043.38635.rjw@sisk.pl> <201110261342.51843.rjw@sisk.pl> <4EAA1762.1060207@jp.fujitsu.com>
In-Reply-To: <4EAA1762.1060207@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <201111062311.28913.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If the kernel has requested control of the SHPC native hotplug
feature for a given root bridge, the acpiphp driver should not try
to handle that root bridge and it should leave it to shpchp.
Failing to do so causes problems to happen if shpchp is loaded
and unloaded before loading acpiphp (ACPI-based hotplug won't work
in that case anyway).

To address this issue make find_root_bridges() ignore PCI root
bridges with SHPC native hotplug enabled and make add_bridge()
return error code if SHPC native hotplug is enabled for the given
root bridge.  This causes acpiphp to refuse to load if SHPC native
hotplug is enabled for all root bridges and to refuse binding to
the root bridges with SHPC native hotplug enabled.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Jesse,

This should apply to your linux-next branch.

Thanks,
Rafael

---
 drivers/pci/hotplug/acpiphp_glue.c |    4 ++--
 include/linux/acpi.h               |    4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

Index: linux/include/linux/acpi.h
===================================================================
--- linux.orig/include/linux/acpi.h
+++ linux/include/linux/acpi.h
@@ -302,6 +302,10 @@ extern bool osc_sb_apei_support_acked;
 				OSC_PCI_EXPRESS_PME_CONTROL |		\
 				OSC_PCI_EXPRESS_AER_CONTROL |		\
 				OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL)
+
+#define OSC_PCI_NATIVE_HOTPLUG	(OSC_PCI_EXPRESS_NATIVE_HP_CONTROL |	\
+				OSC_SHPC_NATIVE_HP_CONTROL)
+
 extern acpi_status acpi_pci_osc_control_set(acpi_handle handle,
 					     u32 *mask, u32 req);
 extern void acpi_early_init(void);
Index: linux/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux/drivers/pci/hotplug/acpiphp_glue.c
@@ -467,7 +467,7 @@ static int add_bridge(acpi_handle handle
 	 * granted by the BIOS for it.
 	 */
 	root = acpi_pci_find_root(handle);
-	if (root && (root->osc_control_set & OSC_PCI_EXPRESS_NATIVE_HP_CONTROL))
+	if (root && (root->osc_control_set & OSC_PCI_NATIVE_HOTPLUG))
 		return -ENODEV;
 
 	/* if the bridge doesn't have _STA, we assume it is always there */
@@ -1395,7 +1395,7 @@ find_root_bridges(acpi_handle handle, u3
 	if (!root)
 		return AE_OK;
 
-	if (root->osc_control_set & OSC_PCI_EXPRESS_NATIVE_HP_CONTROL)
+	if (root->osc_control_set & OSC_PCI_NATIVE_HOTPLUG)
 		return AE_OK;
 
 	(*count)++;
