Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055Ab2HIXnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 19:43:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:46927 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759875Ab2HIXnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 19:43:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,743,1336374000"; 
   d="scan'208";a="183847482"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Betty Dall <betty.dall@hp.com>
Subject: [PATCH] x86, pci: Fix all early PCI scans to check the vendor ID first v2
Date: Thu,  9 Aug 2012 16:43:33 -0700
Message-Id: <1344555813-15218-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

According to the Intel PCI experts it's not safe to check any
other field than vendor ID for 0xffff when doing PCI scans
to see if the device exists.

Several of the early PCI scans violated this. I changed
them all to always check the vendor ID first.

v2: Change some continues to breaks and cleanup Calgary (Betty Dall)
Cc: Betty Dall <betty.dall@hp.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/aperture_64.c        |    5 +++++
 arch/x86/kernel/early-quirks.c       |    3 +++
 arch/x86/kernel/pci-calgary_64.c     |   13 +++++++------
 arch/x86/pci/early.c                 |    3 +++
 drivers/firewire/init_ohci1394_dma.c |    3 +++
 5 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index d5fd66f..cec65fd 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -206,6 +206,11 @@ static u32 __init search_agp_bridge(u32 *order, int *valid_agp)
 			for (func = 0; func < 8; func++) {
 				u32 class, cap;
 				u8 type;
+
+				if (read_pci_config_16(bus, slot, func, PCI_VENDOR_ID) 
+				    == 0xffff)
+					break;
+
 				class = read_pci_config(bus, slot, func,
 							PCI_CLASS_REVISION);
 				if (class == 0xffffffff)
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 3755ef4..f76b930 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -250,6 +250,9 @@ static int __init check_dev_quirk(int num, int slot, int func)
 
 	vendor = read_pci_config_16(num, slot, func, PCI_VENDOR_ID);
 
+	if (vendor == 0xffff)
+		return -1;
+
 	device = read_pci_config_16(num, slot, func, PCI_DEVICE_ID);
 
 	for (i = 0; early_qrk[i].f != NULL; i++) {
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 299d493..74947f8 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1322,10 +1322,10 @@ static void __init get_tce_space_from_tar(void)
 	for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
 		struct calgary_bus_info *info = &bus_info[bus];
 		unsigned short pci_device;
-		u32 val;
 
-		val = read_pci_config(bus, 0, 0, 0);
-		pci_device = (val & 0xFFFF0000) >> 16;
+		if (read_pci_config_16(bus, 0, 0, PCI_VENDOR_ID) == 0xffff)
+			continue;
+		pci_device = read_pci_config_16(bus, 0, 0, PCI_DEVICE_ID);
 
 		if (!is_cal_pci_dev(pci_device))
 			continue;
@@ -1424,10 +1424,11 @@ int __init detect_calgary(void)
 	for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
 		struct calgary_bus_info *info = &bus_info[bus];
 		unsigned short pci_device;
-		u32 val;
 
-		val = read_pci_config(bus, 0, 0, 0);
-		pci_device = (val & 0xFFFF0000) >> 16;
+		if (read_pci_config_16(bus, 0, 0, PCI_VENDOR_ID) == 0xffff)
+			continue;
+
+		pci_device = read_pci_config_16(bus, 0, 0, PCI_DEVICE_ID);
 
 		if (!is_cal_pci_dev(pci_device))
 			continue;
diff --git a/arch/x86/pci/early.c b/arch/x86/pci/early.c
index d1067d5..129809d 100644
--- a/arch/x86/pci/early.c
+++ b/arch/x86/pci/early.c
@@ -91,6 +91,9 @@ void early_dump_pci_devices(void)
 				u32 class;
 				u8 type;
 
+				if (read_pci_config_16(bus, slot, func, PCI_VENDOR_ID) == 0xffff)
+					break;
+
 				class = read_pci_config(bus, slot, func,
 							PCI_CLASS_REVISION);
 				if (class == 0xffffffff)
diff --git a/drivers/firewire/init_ohci1394_dma.c b/drivers/firewire/init_ohci1394_dma.c
index a9a347a..c56bbd2 100644
--- a/drivers/firewire/init_ohci1394_dma.c
+++ b/drivers/firewire/init_ohci1394_dma.c
@@ -279,6 +279,9 @@ void __init init_ohci1394_dma_on_all_controllers(void)
 	for (num = 0; num < 32; num++) {
 		for (slot = 0; slot < 32; slot++) {
 			for (func = 0; func < 8; func++) {
+				if (read_pci_config_16(num, slot, func, PCI_VENDOR_ID) == 0xffff)
+					break;
+
 				class = read_pci_config(num, slot, func,
 							PCI_CLASS_REVISION);
 				if (class == 0xffffffff)
-- 
1.7.7.6

