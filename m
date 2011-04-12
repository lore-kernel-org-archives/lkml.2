Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab1DLO67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:58:59 -0400
Received: from kroah.org ([198.145.64.141]:57397 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785Ab1DLOhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:49 2011
Message-Id: <20110412143549.320842109@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [013/105] PCI/ACPI: Report ASPM support to BIOS if not disabled from command line
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit 8b8bae901ce23addbdcdb54fa1696fb2d049feb5 upstream.

We need to distinguish the situation in which ASPM support is
disabled from the command line or through .config from the situation
in which it is disabled, because the hardware or BIOS can't handle
it.  In the former case we should not report ASPM support to the BIOS
through ACPI _OSC, but in the latter case we should do that.

Introduce pcie_aspm_support_enabled() that can be used by
acpi_pci_root_add() to determine whether or not it should report ASPM
support to the BIOS through _OSC.

References: https://bugzilla.kernel.org/show_bug.cgi?id=29722
References: https://bugzilla.kernel.org/show_bug.cgi?id=20232
Reported-and-tested-by: Ortwin Glück <odi@odi.ch>
Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Tested-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/pci_root.c |    2 +-
 drivers/pci/pcie/aspm.c |    7 +++++++
 include/linux/pci.h     |    7 +++----
 3 files changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -564,7 +564,7 @@ static int __devinit acpi_pci_root_add(s
 	/* Indicate support for various _OSC capabilities. */
 	if (pci_ext_cfg_avail(root->bus->self))
 		flags |= OSC_EXT_PCI_CONFIG_SUPPORT;
-	if (pcie_aspm_enabled())
+	if (pcie_aspm_support_enabled())
 		flags |= OSC_ACTIVE_STATE_PWR_SUPPORT |
 			OSC_CLOCK_PWR_CAPABILITY_SUPPORT;
 	if (pci_msi_enabled())
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
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
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
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


