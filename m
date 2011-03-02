Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab1CBWeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:34:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46205 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757886Ab1CBWeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:34:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [PATCH 2/2] PCI/ACPI: Report MSI support to BIOS if not disabled from command line
Date: Wed, 2 Mar 2011 23:33:23 +0100
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
Message-Id: <201103022333.23919.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

We need to distinguish the situation in which MSI support is disabled
from the command line or through .config from the situation in which
it is disabled, because the hardware or BIOS can't handle it.  In the
former case we should not report MSI support to the BIOS through ACPI
_OSC, but in the latter case we should do that.

Introduce pci_msi_support_enabled() that can be used by
acpi_pci_root_add() to determine whether or not it should report MSI
support to the BIOS through _OSC.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/pci_root.c |    2 +-
 drivers/pci/msi.c       |   12 ++++++++++++
 drivers/pci/pci.c       |    2 +-
 drivers/pci/pci.h       |    2 ++
 include/linux/pci.h     |    3 +++
 5 files changed, 19 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/msi.c
===================================================================
--- linux-2.6.orig/drivers/pci/msi.c
+++ linux-2.6/drivers/pci/msi.c
@@ -24,6 +24,7 @@
 #include "msi.h"
 
 static int pci_msi_enable = 1;
+static bool msi_support_enabled = true;
 
 /* Arch hooks */
 
@@ -855,6 +856,17 @@ void pci_no_msi(void)
 	pci_msi_enable = 0;
 }
 
+void pci_no_msi_support(void)
+{
+	msi_support_enabled = false;
+	pci_no_msi();
+}
+
+bool pci_msi_support_enabled(void)
+{
+	return msi_support_enabled;
+}
+
 /**
  * pci_msi_enabled - is MSI enabled?
  *
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -3062,7 +3062,7 @@ static int __init pci_setup(char *str)
 			*k++ = 0;
 		if (*str && (str = pcibios_setup(str)) && *str) {
 			if (!strcmp(str, "nomsi")) {
-				pci_no_msi();
+				pci_no_msi_support();
 			} else if (!strcmp(str, "noaer")) {
 				pci_no_aer();
 			} else if (!strcmp(str, "nodomains")) {
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -446,11 +446,14 @@ static inline bool pci_is_root_bus(struc
 }
 
 #ifdef CONFIG_PCI_MSI
+extern bool pci_msi_support_enabled(void);
+
 static inline bool pci_dev_msi_enabled(struct pci_dev *pci_dev)
 {
 	return pci_dev->msi_enabled || pci_dev->msix_enabled;
 }
 #else
+static inline bool pci_msi_support_enabled(void) { return false; }
 static inline bool pci_dev_msi_enabled(struct pci_dev *pci_dev) { return false; }
 #endif
 
Index: linux-2.6/drivers/acpi/pci_root.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_root.c
+++ linux-2.6/drivers/acpi/pci_root.c
@@ -567,7 +567,7 @@ static int __devinit acpi_pci_root_add(s
 	if (pcie_aspm_support_enabled())
 		flags |= OSC_ACTIVE_STATE_PWR_SUPPORT |
 			OSC_CLOCK_PWR_CAPABILITY_SUPPORT;
-	if (pci_msi_enabled())
+	if (pci_msi_support_enabled())
 		flags |= OSC_MSI_SUPPORT;
 	if (flags != base_flags)
 		acpi_pci_osc_support(root, flags);
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -140,9 +140,11 @@ extern unsigned int pci_pm_d3_delay;
 
 #ifdef CONFIG_PCI_MSI
 void pci_no_msi(void);
+extern void pci_no_msi_support(void);
 extern void pci_msi_init_pci_dev(struct pci_dev *dev);
 #else
 static inline void pci_no_msi(void) { }
+static inline void pci_no_msi_support(void) { }
 static inline void pci_msi_init_pci_dev(struct pci_dev *dev) { }
 #endif
 

