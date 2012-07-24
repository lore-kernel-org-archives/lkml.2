Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab2GXQfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:35:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39412 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab2GXQfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:35:39 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 14/32] PCI/tile: use PCIe capabilities access functions to simplify implementation
Date: Wed, 25 Jul 2012 00:31:26 +0800
Message-Id: <1343147504-25891-15-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify PCIe tile implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 arch/tile/kernel/pci.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index 0fdd99d..bf296cf 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -246,16 +246,13 @@ static void __devinit fixup_read_and_payload_sizes(void)
 
 	/* Scan for the smallest maximum payload size. */
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-		int pcie_caps_offset;
 		u32 devcap;
 		int max_payload;
 
-		pcie_caps_offset = pci_find_capability(dev, PCI_CAP_ID_EXP);
-		if (pcie_caps_offset == 0)
+		if (!pci_is_pcie(dev))
 			continue;
 
-		pci_read_config_dword(dev, pcie_caps_offset + PCI_EXP_DEVCAP,
-				      &devcap);
+		pci_pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &devcap);
 		max_payload = devcap & PCI_EXP_DEVCAP_PAYLOAD;
 		if (max_payload < smallest_max_payload)
 			smallest_max_payload = max_payload;
@@ -264,19 +261,15 @@ static void __devinit fixup_read_and_payload_sizes(void)
 	/* Now, set the max_payload_size for all devices to that value. */
 	new_values = (max_read_size << 12) | (smallest_max_payload << 5);
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-		int pcie_caps_offset;
 		u16 devctl;
 
-		pcie_caps_offset = pci_find_capability(dev, PCI_CAP_ID_EXP);
-		if (pcie_caps_offset == 0)
+		if (!pci_is_pcie(dev))
 			continue;
 
-		pci_read_config_word(dev, pcie_caps_offset + PCI_EXP_DEVCTL,
-				     &devctl);
+		pci_pcie_capability_read_word(dev, PCI_EXP_DEVCTL, &devctl);
 		devctl &= ~(PCI_EXP_DEVCTL_PAYLOAD | PCI_EXP_DEVCTL_READRQ);
 		devctl |= new_values;
-		pci_write_config_word(dev, pcie_caps_offset + PCI_EXP_DEVCTL,
-				      devctl);
+		pci_pcie_capability_write_word(dev, PCI_EXP_DEVCTL, devctl);
 	}
 }
 
-- 
1.7.9.5

