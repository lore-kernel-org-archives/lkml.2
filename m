Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab1CBWeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:34:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46204 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757873Ab1CBWeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:34:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [PATCH 1/2] PCI/ACPI: Report ASPM support to BIOS if not disabled from command line
Date: Wed, 2 Mar 2011 23:32:46 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.4.4; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ozan Caglayan <ozan@pardus.org.tr>
References: <20110228014218.GA11083@xanatos> <201103021221.06312.rjw@sisk.pl> <201103022330.49297.rjw@sisk.pl>
In-Reply-To: <201103022330.49297.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201103022332.46791.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

We need to distinguish the situation in which ASPM support is
disabled from the command line or through .config from the situation
in which it is disabled, because the hardware or BIOS can't handle
it.  In the former case we should not report ASPM support to the BIOS
through ACPI _OSC, but in the latter case we should do that.

Introduce pcie_aspm_support_enabled() that can be used by
acpi_pci_root_add() to determine whether or not it should report ASPM
support to the BIOS through _OSC.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/pci_root.c |    2 +-
 drivers/pci/pcie/aspm.c |    7 +++++++
 include/linux/pci.h     |    7 +++----
 3 files changed, 11 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/pci/pcie/aspm.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/aspm.c
+++ linux-2.6/drivers/pci/pcie/aspm.c
@@ -69,6 +69,7 @@ struct pcie_link_state {
 };
 
 static int aspm_disabled, aspm_force, aspm_clear_state;
+static bool aspm_support_enabled = true;
 static DEFINE_MUTEX(aspm_lock);
 static LIST_HEAD(link_list);
 
@@ -896,6 +897,7 @@ static int __init pcie_aspm_disable(char
 {
 	if (!strcmp(str, "off")) {
 		aspm_disabled = 1;
+		aspm_support_enabled = false;
 		printk(KERN_INFO "PCIe ASPM is disabled\n");
 	} else if (!strcmp(str, "force")) {
 		aspm_force = 1;
@@ -930,3 +932,8 @@ int pcie_aspm_enabled(void)
 }
 EXPORT_SYMBOL(pcie_aspm_enabled);
 
+bool pcie_aspm_support_enabled(void)
+{
+	return aspm_support_enabled;
+}
+EXPORT_SYMBOL(pcie_aspm_support_enabled);
Index: linux-2.6/drivers/acpi/pci_root.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_root.c
+++ linux-2.6/drivers/acpi/pci_root.c
@@ -564,7 +564,7 @@ static int __devinit acpi_pci_root_add(s
 	/* Indicate support for various _OSC capabilities. */
 	if (pci_ext_cfg_avail(root->bus->self))
 		flags |= OSC_EXT_PCI_CONFIG_SUPPORT;
-	if (pcie_aspm_enabled())
+	if (pcie_aspm_support_enabled())
 		flags |= OSC_ACTIVE_STATE_PWR_SUPPORT |
 			OSC_CLOCK_PWR_CAPABILITY_SUPPORT;
 	if (pci_msi_enabled())
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -1002,12 +1002,11 @@ extern bool pcie_ports_auto;
 #endif
 
 #ifndef CONFIG_PCIEASPM
-static inline int pcie_aspm_enabled(void)
-{
-	return 0;
-}
+static inline int pcie_aspm_enabled(void) { return 0; }
+static inline bool pcie_aspm_support_enabled(void) { return false; }
 #else
 extern int pcie_aspm_enabled(void);
+extern bool pcie_aspm_support_enabled(void);
 #endif
 
 #ifdef CONFIG_PCIEAER

