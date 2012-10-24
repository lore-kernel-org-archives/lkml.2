Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934443Ab2JXIw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 04:52:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:64966 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933591Ab2JXIwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 04:52:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,639,1344236400"; 
   d="scan'208";a="237501505"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH] perf/x86/uncore: Handle pci_read_config_dword() error.
Date: Wed, 24 Oct 2012 16:42:20 +0800
Message-Id: <1351068140-13456-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 43 +++++++++++++++++----------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 99d96a4..344e0e9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -118,22 +118,24 @@ static void snbep_uncore_pci_disable_box(struct intel_uncore_box *box)
 {
 	struct pci_dev *pdev = box->pci_dev;
 	int box_ctl = uncore_pci_box_ctl(box);
-	u32 config;
+	u32 config = 0;
 
-	pci_read_config_dword(pdev, box_ctl, &config);
-	config |= SNBEP_PMON_BOX_CTL_FRZ;
-	pci_write_config_dword(pdev, box_ctl, config);
+	if (!pci_read_config_dword(pdev, box_ctl, &config)) {
+		config |= SNBEP_PMON_BOX_CTL_FRZ;
+		pci_write_config_dword(pdev, box_ctl, config);
+	}
 }
 
 static void snbep_uncore_pci_enable_box(struct intel_uncore_box *box)
 {
 	struct pci_dev *pdev = box->pci_dev;
 	int box_ctl = uncore_pci_box_ctl(box);
-	u32 config;
+	u32 config = 0;
 
-	pci_read_config_dword(pdev, box_ctl, &config);
-	config &= ~SNBEP_PMON_BOX_CTL_FRZ;
-	pci_write_config_dword(pdev, box_ctl, config);
+	if (!pci_read_config_dword(pdev, box_ctl, &config)) {
+		config &= ~SNBEP_PMON_BOX_CTL_FRZ;
+		pci_write_config_dword(pdev, box_ctl, config);
+	}
 }
 
 static void snbep_uncore_pci_enable_event(struct intel_uncore_box *box, struct perf_event *event)
@@ -156,7 +158,7 @@ static u64 snbep_uncore_pci_read_counter(struct intel_uncore_box *box, struct pe
 {
 	struct pci_dev *pdev = box->pci_dev;
 	struct hw_perf_event *hwc = &event->hw;
-	u64 count;
+	u64 count = 0;
 
 	pci_read_config_dword(pdev, hwc->event_base, (u32 *)&count);
 	pci_read_config_dword(pdev, hwc->event_base + 4, (u32 *)&count + 1);
@@ -603,11 +605,12 @@ static struct pci_driver snbep_uncore_pci_driver = {
 /*
  * build pci bus to socket mapping
  */
-static void snbep_pci2phy_map_init(void)
+static int snbep_pci2phy_map_init(void)
 {
 	struct pci_dev *ubox_dev = NULL;
 	int i, bus, nodeid;
-	u32 config;
+	int err = 0;
+	u32 config = 0;
 
 	while (1) {
 		/* find the UBOX device */
@@ -618,10 +621,14 @@ static void snbep_pci2phy_map_init(void)
 			break;
 		bus = ubox_dev->bus->number;
 		/* get the Node ID of the local register */
-		pci_read_config_dword(ubox_dev, 0x40, &config);
+		err = pci_read_config_dword(ubox_dev, 0x40, &config);
+		if (err)
+			break;
 		nodeid = config;
 		/* get the Node ID mapping */
-		pci_read_config_dword(ubox_dev, 0x54, &config);
+		err = pci_read_config_dword(ubox_dev, 0x54, &config);
+		if (err)
+			break;
 		/*
 		 * every three bits in the Node ID mapping register maps
 		 * to a particular node.
@@ -633,7 +640,11 @@ static void snbep_pci2phy_map_init(void)
 			}
 		}
 	};
-	return;
+
+	if (ubox_dev)
+		pci_dev_put(ubox_dev);
+
+	return err ? pcibios_err_to_errno(err) : 0;
 }
 /* end of Sandy Bridge-EP uncore support */
 
@@ -2578,9 +2589,11 @@ static int __init uncore_pci_init(void)
 
 	switch (boot_cpu_data.x86_model) {
 	case 45: /* Sandy Bridge-EP */
+		ret = snbep_pci2phy_map_init();
+		if (ret)
+			return ret;
 		pci_uncores = snbep_pci_uncores;
 		uncore_pci_driver = &snbep_uncore_pci_driver;
-		snbep_pci2phy_map_init();
 		break;
 	default:
 		return 0;
-- 
1.7.11.7

