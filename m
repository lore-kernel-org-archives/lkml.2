Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2DFPb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 11:31:57 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:56404 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab2DFPbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 11:31:55 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: Fix a device reference count leakage issue in pci_dev_present()
Date: Fri,  6 Apr 2012 23:31:36 +0800
Message-Id: <1333726296-3817-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function pci_get_dev_by_id() will hold a reference count on the pci device
returned, so pci_dev_present() should release the corresponding reference
count to avoid memory leakage.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/pci/search.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 9d75dc8..b572730 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -338,13 +338,13 @@ int pci_dev_present(const struct pci_device_id *ids)
 	WARN_ON(in_interrupt());
 	while (ids->vendor || ids->subvendor || ids->class_mask) {
 		found = pci_get_dev_by_id(ids, NULL);
-		if (found)
-			goto exit;
+		if (found) {
+			pci_dev_put(found);
+			return 1;
+		}
 		ids++;
 	}
-exit:
-	if (found)
-		return 1;
+
 	return 0;
 }
 EXPORT_SYMBOL(pci_dev_present);
-- 
1.7.5.4

