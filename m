Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab2EKTPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:15:37 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62594 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760463Ab2EKTPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:15:34 -0400
From: =?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?= <jeff.dagenais@gmail.com>
To: sameo@linux.intel.com
Cc: alexander.stein@systec-electronic.com, denis@compulab.co.il,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?= <jeff.dagenais@gmail.com>
Subject: [PATCH] mfd: lpc_sch - tolerate f/w disabled WDT
Date: Fri, 11 May 2012 15:15:22 -0400
Message-Id: <1336763722-11535-1-git-send-email-jeff.dagenais@gmail.com>
X-Mailer: git-send-email 1.7.9
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Observed while running on Kontron nano-TT module.)

Certain BIOS/boot firmware may disable the tunnelcreek watchdog. Perhaps
because the mainboard or module provides it's own watchdog mechanism. In these
cases, lpc_sch should just go on and still provide the rest of the cells
it declares (GPIO and SMBus). The same logic could be applied to the other
resources, but I'll leave it to others to decide that.

This change makes the probe function tolerate the I/O range being disabled,
but not if the base address inside the register is not configured.

Cc: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Denis Turischev <denis@compulab.co.il>
Signed-off-by: Jean-François Dagenais <jeff.dagenais@gmail.com>
---
 drivers/mfd/lpc_sch.c |   39 ++++++++++++++++++++-------------------
 1 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
index ea1169b..6621cd3 100644
--- a/drivers/mfd/lpc_sch.c
+++ b/drivers/mfd/lpc_sch.c
@@ -127,26 +127,27 @@ static int __devinit lpc_sch_probe(struct pci_dev *dev,
 
 	if (id->device == PCI_DEVICE_ID_INTEL_ITC_LPC) {
 		pci_read_config_dword(dev, WDTBASE, &base_addr_cfg);
-		if (!(base_addr_cfg & (1 << 31))) {
-			dev_err(&dev->dev, "Decode of the WDT I/O range disabled\n");
-			ret = -ENODEV;
-			goto out_dev;
+		if (base_addr_cfg & (1 << 31)) {
+			base_addr = (unsigned short)base_addr_cfg;
+			if (base_addr == 0) {
+				dev_err(&dev->dev,
+					"I/O space for WDT uninitialized\n");
+				ret = -ENODEV;
+				goto out_dev;
+			}
+
+			wdt_sch_resource.start = base_addr;
+			wdt_sch_resource.end = base_addr + WDT_IO_SIZE - 1;
+
+			for (i = 0; i < ARRAY_SIZE(tunnelcreek_cells); i++)
+				tunnelcreek_cells[i].id = id->device;
+
+			ret = mfd_add_devices(&dev->dev, 0, tunnelcreek_cells,
+				ARRAY_SIZE(tunnelcreek_cells), NULL, 0);
+		} else {
+			dev_warn(&dev->dev, "Decode of the WDT I/O range disabled, tunnelcreek watchdog timer maybe disabled by firmware or BIOS");
+			return 0;
 		}
-		base_addr = (unsigned short)base_addr_cfg;
-		if (base_addr == 0) {
-			dev_err(&dev->dev, "I/O space for WDT uninitialized\n");
-			ret = -ENODEV;
-			goto out_dev;
-		}
-
-		wdt_sch_resource.start = base_addr;
-		wdt_sch_resource.end = base_addr + WDT_IO_SIZE - 1;
-
-		for (i = 0; i < ARRAY_SIZE(tunnelcreek_cells); i++)
-			tunnelcreek_cells[i].id = id->device;
-
-		ret = mfd_add_devices(&dev->dev, 0, tunnelcreek_cells,
-			ARRAY_SIZE(tunnelcreek_cells), NULL, 0);
 	}
 
 	return ret;
-- 
1.7.9

