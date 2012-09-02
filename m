Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2IBV7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:59:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19998 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab2IBVyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:54:32 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part4 02/11] PCI: Correctly clean up pci root buses in function pci_remove_bus()
Date: Sun,  2 Sep 2012 14:54:12 -0700
Message-Id: <1346622861-30865-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1346622861-30865-1-git-send-email-yinghai@kernel.org>
References: <1346622861-30865-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

The function pci_create_root_bus() allocates the pci bus structure,
registers the bus device and creates the legacy files for a pci root
bus, but returns without setting the is_added flag. The is_added flag
for a pci root bus will be set by function pci_scan_child_bus().
If a pci root bus is destroyed before calling pci_scan_child_bus(),
the is_added flag will not be set.  So teach function pci_remove_bus()
to detect such a case and correctly clean up pci root buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/remove.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index aaae16e..b9f553b 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -48,11 +48,10 @@ void pci_remove_bus(struct pci_bus *bus)
 	list_del(&bus->node);
 	pci_bus_release_busn_res(bus);
 	up_write(&pci_bus_sem);
-	if (!bus->is_added)
-		return;
-
-	pci_remove_legacy_files(bus);
-	device_unregister(&bus->dev);
+	if (bus->is_added || pci_is_root_bus(bus)) {
+		pci_remove_legacy_files(bus);
+		device_unregister(&bus->dev);
+	}
 }
 EXPORT_SYMBOL(pci_remove_bus);
 
-- 
1.7.7

