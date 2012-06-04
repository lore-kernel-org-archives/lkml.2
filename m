Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab2FDHtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 03:49:16 -0400
Received: from szxga01-in.huawei.com ([58.251.152.64]:58110 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2FDHtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 03:49:14 -0400
Date: Mon, 04 Jun 2012 15:44:54 +0800
From: Jiang Liu <jiang.liu@huawei.com>
Subject: [Resend with Ack][PATCH v1] PCI: allow acpiphp to handle PCIe ports
 without native PCIe hotplug capability
X-Originating-IP: [10.107.208.49]
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Don Dutile <ddutile@redhat.com>, Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Message-id: <1338795894-6292-1-git-send-email-jiang.liu@huawei.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.8.msysgit.0
Content-type: text/plain
Content-transfer-encoding: 7BIT
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Jiang Liu <liuj97@gmail.com>

---
 drivers/pci/hotplug/acpiphp_glue.c |   49 ++++++++++++++++++++++++++++-------
 1 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 806c44f..4889448 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -115,6 +115,43 @@ static const struct acpi_dock_ops acpiphp_dock_ops = {
 	.handler = handle_hotplug_event_func,
 };
 
+/* Check whether device is managed by native PCIe hotplug driver */
+static bool device_is_managed_by_native_pciehp(struct pci_dev *pdev)
+{
+	int pos;
+	u16 reg16;
+	u32 reg32;
+	acpi_handle tmp;
+	struct acpi_pci_root *root;
+
+	if (!pci_is_pcie(pdev))
+		return false;
+
+	/* Check whether PCIe port supports native PCIe hotplug */
+	pos = pci_pcie_cap(pdev);
+	pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &reg16);
+	if (!(reg16 & PCI_EXP_FLAGS_SLOT))
+		return false;
+	pci_read_config_dword(pdev, pos + PCI_EXP_SLTCAP, &reg32);
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
@@ -133,16 +170,8 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 		return AE_OK;
 
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
 
 	acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
 	device = (adr >> 16) & 0xffff;
-- 
1.7.1


