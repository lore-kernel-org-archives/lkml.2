Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab2IBV7e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:59:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23755 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab2IBVyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:54:31 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH part4 01/11] PCI: Fix a device reference count leakage issue in pci_dev_present()
Date: Sun,  2 Sep 2012 14:54:11 -0700
Message-Id: <1346622861-30865-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622861-30865-1-git-send-email-yinghai@kernel.org>
References: <1346622861-30865-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Function pci_get_dev_by_id() will hold a reference count on the pci device
returned, so pci_dev_present() should release the corresponding reference
count to avoid memory leakage.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/pci/search.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index d84cdcf..cd11bd8 100644
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
1.7.7

