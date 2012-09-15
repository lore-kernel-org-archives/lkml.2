Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab2IODNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 23:13:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64718 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2IODNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 23:13:05 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tony Luck <tony.luck@intel.com>, Yijing Wang <wangyijing@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <jiang.liu@huawei.com>
Subject: [PATCH v2 3/9] PCI: preserve dev->subordinate until pci_stop_dev() has been called
Date: Sat, 15 Sep 2012 11:05:06 +0800
Message-Id: <1347678312-11124-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347678312-11124-1-git-send-email-jiang.liu@huawei.com>
References: <1347678312-11124-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>

Changeset 2ed168eeb3edec029aa0eca5cb981d6376f931f9 "PCI: Fold stop and
remove helpers into their callers" has changed the behavior when
removing a PCI device.

Previously, for a PCI bridge device with secondary bus, dev->subordinate
is valid when calling PCI bus notification callbacks for
BUS_NOTIFY_ADD_DEVICE/BUS_NOTIFY_DEL_DEVICE events. Now dev->subordinate
has been reset to NULL when calling callbacks for BUS_NOTIFY_DEL_DEVICE
events, which may break some PCI bus notification callbacks.

So revert to the original behavior to keep dev->subordinate valid for
both BUS_NOTIFY_ADD_DEVICE events and BUS_NOTIFY_DEL_DEVICE events.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/pci/remove.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 86a4636..6244956 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -79,16 +79,16 @@ void pci_stop_and_remove_bus_device(struct pci_dev *dev)
 	 * iterator.  Therefore, iterate in reverse so we remove the VFs
 	 * first, then the PF.
 	 */
-	if (bus) {
+	if (bus)
 		list_for_each_entry_safe_reverse(child, tmp,
 						 &bus->devices, bus_list)
 			pci_stop_and_remove_bus_device(child);
+	pci_stop_dev(dev);
 
+	if (bus) {
 		pci_remove_bus(bus);
 		dev->subordinate = NULL;
 	}
-
-	pci_stop_dev(dev);
 	pci_destroy_dev(dev);
 }
 EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
-- 
1.7.9.5

