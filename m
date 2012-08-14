Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab2HNQBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 12:01:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:41399 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540Ab2HNQBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 12:01:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,766,1336374000"; 
   d="scan'208";a="180961824"
From: Feng Tang <feng.tang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Feng Tang <feng.tang@intel.com>, Aaron Sierra <asierra@xes-inc.com>,
        Wim Van Sebroeck <wim@iguana.be>, Len Brown <len.brown@intel.com>,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH] lpc_ich: Fix a 3.5 kernel regression for iTCO_wdt driver
Date: Tue, 14 Aug 2012 23:56:12 +0800
Message-Id: <1344959772-23018-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many reports (including 2 of my machines) that iTCO_wdt watchdog
driver fails to be initialized in 3.5 kernel with error message like:

[    5.265175] ACPI Warning: 0x00001060-0x0000107f SystemIO conflicts with Region \_SB_.PCI0.LPCB.TCOI 1 (20120320/utaddress-251)
[    5.265192] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.265206] lpc_ich: Resource conflict(s) found affecting iTCO_wdt

The root cause the iTCO_wdt driver in 3.4 probes the HW IO resource from
LPC's PCI config space, while in 3.5 kernel it relies on lpc_ich driver
for the probe, which adds a new acpi_check_resource_conflict() check, and
give up the probe if there is any conflict with ACPI.

Fix it by removing all the checks for iTCO_wdt to keep the same behavior as
3.4 kernel.
https://bugzilla.kernel.org/show_bug.cgi?id=44991

Actually the same check could be removed for the gpio-ich in lpc_ich.c,
but I'm not sure if it will cause problems.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Aaron Sierra <asierra@xes-inc.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Len Brown <len.brown@intel.com>
Cc: Bob Moore <robert.moore@intel.com>
---
 drivers/mfd/lpc_ich.c |   20 +-------------------
 1 files changed, 1 insertions(+), 19 deletions(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 027cc8f..a05fdfc 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -765,7 +765,6 @@ static int __devinit lpc_ich_init_wdt(struct pci_dev *dev,
 	u32 base_addr_cfg;
 	u32 base_addr;
 	int ret;
-	bool acpi_conflict = false;
 	struct resource *res;
 
 	/* Setup power management base register */
@@ -780,20 +779,11 @@ static int __devinit lpc_ich_init_wdt(struct pci_dev *dev,
 	res = wdt_io_res(ICH_RES_IO_TCO);
 	res->start = base_addr + ACPIBASE_TCO_OFF;
 	res->end = base_addr + ACPIBASE_TCO_END;
-	ret = acpi_check_resource_conflict(res);
-	if (ret) {
-		acpi_conflict = true;
-		goto wdt_done;
-	}
 
 	res = wdt_io_res(ICH_RES_IO_SMI);
 	res->start = base_addr + ACPIBASE_SMI_OFF;
 	res->end = base_addr + ACPIBASE_SMI_END;
-	ret = acpi_check_resource_conflict(res);
-	if (ret) {
-		acpi_conflict = true;
-		goto wdt_done;
-	}
+
 	lpc_ich_enable_acpi_space(dev);
 
 	/*
@@ -813,11 +803,6 @@ static int __devinit lpc_ich_init_wdt(struct pci_dev *dev,
 		res = wdt_mem_res(ICH_RES_MEM_GCS);
 		res->start = base_addr + ACPIBASE_GCS_OFF;
 		res->end = base_addr + ACPIBASE_GCS_END;
-		ret = acpi_check_resource_conflict(res);
-		if (ret) {
-			acpi_conflict = true;
-			goto wdt_done;
-		}
 	}
 
 	lpc_ich_finalize_cell(&lpc_ich_cells[LPC_WDT], id);
@@ -825,9 +810,6 @@ static int __devinit lpc_ich_init_wdt(struct pci_dev *dev,
 				1, NULL, 0);
 
 wdt_done:
-	if (acpi_conflict)
-		pr_warn("Resource conflict(s) found affecting %s\n",
-				lpc_ich_cells[LPC_WDT].name);
 	return ret;
 }
 
-- 
1.7.1

