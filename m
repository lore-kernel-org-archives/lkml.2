Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953Ab0EZKbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:31:19 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.40]:56809 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab0EZKbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:31:18 -0400
Message-ID: <4BFCF616.6060608@ladisch.de>
Date: Wed, 26 May 2010 12:21:10 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] PCI quirk: AMD 780: work around wrong vendor ID on APC bridge
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In all AMD 780 family northbridges, the vendor ID of the internal
graphics PCI/PCI bridge reads not as AMD but as that of the mainboard
vendor, because the hardware actually returns the value of the subsystem
vendor ID (erratum 18).

We currently have additional quirk entries for Asus and Acer, but it is
likely that we will encounter more systems with other vendor IDs.

Since we do not know in advance all possible vendor IDs, a better way to
find the device is to declare the quirk on the host bridge, whose ID is
always correct, and use that device as a stepping stone to find the PCI/
PCI bridge, if present.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2123,12 +2123,29 @@ static void __devinit quirk_disable_msi(
 	}
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, quirk_disable_msi);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x9602, quirk_disable_msi);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ASUSTEK, 0x9602, quirk_disable_msi);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AI, 0x9602, quirk_disable_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, 0xa238, quirk_disable_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x5a3f, quirk_disable_msi);
 
+/*
+ * The APC bridge device in AMD 780 family northbridges has some random
+ * OEM subsystem ID in its vendor ID register (erratum 18), so instead
+ * we use the possible vendor/device IDs of the host bridge for the
+ * declared quirk, and search for the APC bridge by slot number.
+ */
+static void __devinit quirk_amd_780_apc_msi(struct pci_dev *host_bridge)
+{
+	struct pci_dev *apc_bridge;
+
+	apc_bridge = pci_get_slot(host_bridge->bus, PCI_DEVFN(1, 0));
+	if (apc_bridge) {
+		if (apc_bridge->device == 0x9602)
+			quirk_disable_msi(apc_bridge);
+		pci_dev_put(apc_bridge);
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x9600, quirk_amd_780_apc_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x9601, quirk_amd_780_apc_msi);
+
 /* Go through the list of Hypertransport capabilities and
  * return 1 if a HT MSI capability is found and enabled */
 static int __devinit msi_ht_cap_enabled(struct pci_dev *dev)
