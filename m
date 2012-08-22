Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921Ab2HVPSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:18:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61410 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab2HVPSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:18:25 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v2] PCI: allow acpiphp to handle PCIe ports w/o native PCIe hotplug capability
Date: Wed, 22 Aug 2012 23:16:45 +0800
Message-Id: <1345648605-7636-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <CAErSpo7ZtHDQNBnreZXsqDqKbqc=O+BKHDM8H0w+QkFep9ydFg@mail.gmail.com>
References: <CAErSpo7ZtHDQNBnreZXsqDqKbqc=O+BKHDM8H0w+QkFep9ydFg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Commit 0d52f54e2ef64c189dedc332e680b2eb4a34590a (PCI / ACPI: Make acpiphp
ignore root bridges using PCIe native hotplug) added code that made the
acpiphp driver completely ignore PCIe root complexes for which the kernel
had been granted control of the native PCIe hotplug feature by the BIOS
through _OSC. Later commit 619a5182d1f38a3d629ee48e04fa182ef9170052
"PCI hotplug: Always allow acpiphp to handle non-PCIe bridges" relaxed
the constraints to allow acpiphp driver handle non-PCIe bridges under
such a complex. The constraint needs to be relaxed further to allow
acpiphp driver to hanlde PCIe ports without native PCIe hotplug capability.

Some MR-IOV switch chipsets, such PLX8696, support multiple virtual PCIe
switches and may migrate downstream ports among virtual switches.
To migrate a downstream port from the source virtual switch to the target,
the port needs to be hot-removed from the source and hot-added into the
target. pciehp driver can't be used here because there's no slots within
the virtual PCIe switch. So acpiphp driver is used to support downstream
port migration. A typical configuration is as below:
[Root w/o native PCIe HP]
	[Upstream port of vswitch w/o native PCIe HP]
		[Downstream port of vswitch w/ native PCIe HP]
			[PCIe enpoint]

Here acpiphp driver will be used to handle root ports and upstream port
in the virtual switch, and pciehp driver will be used to handle downstream
ports in the virtual switch.

v1->v2: use PCIe capability accessors to read PCI_EXP_SLTCAP register

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   41 +++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index ad6fd66..e6da392 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -115,6 +115,35 @@ static const struct acpi_dock_ops acpiphp_dock_ops = {
 	.handler = handle_hotplug_event_func,
 };
 
+/* Check whether the PCI device is managed by native PCIe hotplug driver */
+static bool device_is_managed_by_native_pciehp(struct pci_dev *pdev)
+{
+	u32 reg32;
+	acpi_handle tmp;
+	struct acpi_pci_root *root;
+
+	/* Check whether the PCIe port supports native PCIe hotplug */
+	if (pcie_capability_read_dword(pdev, PCI_EXP_SLTCAP, &reg32))
+		return false;
+	if (!(reg32 & PCI_EXP_SLTCAP_HPC))
+		return false;
+
+	/*
+	 * Check whether native PCIe hotplug has been enabled for
+	 * this PCIe hierarchy.
+	 */
+	tmp = acpi_find_root_bridge_handle(pdev);
+	if (!tmp)
+		return false;
+	root = acpi_pci_find_root(tmp);
+	if (!root)
+		return false;
+	if (!(root->osc_control_set & OSC_PCI_EXPRESS_NATIVE_HP_CONTROL))
+		return false;
+
+	return true;
+}
+
 /* callback routine to register each ACPI PCI slot object */
 static acpi_status
 register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
@@ -142,16 +171,8 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	function = adr & 0xffff;
 
 	pdev = pbus->self;
-	if (pdev && pci_is_pcie(pdev)) {
-		tmp = acpi_find_root_bridge_handle(pdev);
-		if (tmp) {
-			struct acpi_pci_root *root = acpi_pci_find_root(tmp);
-
-			if (root && (root->osc_control_set &
-					OSC_PCI_EXPRESS_NATIVE_HP_CONTROL))
-				return AE_OK;
-		}
-	}
+	if (pdev && device_is_managed_by_native_pciehp(pdev))
+		return AE_OK;
 
 	newfunc = kzalloc(sizeof(struct acpiphp_func), GFP_KERNEL);
 	if (!newfunc)
-- 
1.7.9.5

