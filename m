Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2CKRx3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 13:53:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55385 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab2CKRxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 13:53:19 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Ashok Raj <ashok.raj@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Youquan Song <youquan.song@intel.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, chenkeping@huawei.com
Subject: [PATCH 2/5] Correctly clean up pci root buses in function pci_remove_bus()
Date: Mon, 12 Mar 2012 01:48:26 +0800
Message-Id: <1331488109-13466-3-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1331488109-13466-1-git-send-email-jiang.liu@huawei.com>
References: <1331488109-13466-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function pci_create_root_bus() allocates the pci bus structure,
registers the bus device and creates the legacy files for a pci root
bus, but returns without setting the is_added flag. The is_added flag
for a pci root bus will be set by function pci_scan_child_bus().
If a pci root bus is destroyed before calling pci_scan_child_bus(),
the is_added flag will not be set.  So teach function pci_remove_bus()
to detect such a case and correctly clean up pci root buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/pci/remove.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 9ffc071..75b0092 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -70,11 +70,10 @@ void pci_remove_bus(struct pci_bus *pci_bus)
 	list_del(&pci_bus->node);
 	pci_bus_release_busn_res(pci_bus);
 	up_write(&pci_bus_sem);
-	if (!pci_bus->is_added)
-		return;
-
-	pci_remove_legacy_files(pci_bus);
-	device_unregister(&pci_bus->dev);
+	if (pci_bus->is_added || pci_is_root_bus(pci_bus)) {
+		pci_remove_legacy_files(pci_bus);
+		device_unregister(&pci_bus->dev);
+	}
 }
 EXPORT_SYMBOL(pci_remove_bus);
 
-- 
1.7.5.4

