Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab2HGQVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:21:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51364 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab2HGQVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:21:14 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <liuj97@gmail.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [RFC PATCH v1 18/22] PCI/acpiphp: use PCI bus lock to avoid race conditions
Date: Wed,  8 Aug 2012 00:10:58 +0800
Message-Id: <1344355862-2726-19-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <liuj97@gmail.com>

This patch uses PCI bus lock mechanism to avoid race conditions when doing
PCI device/host bridge hotplug by acpiphp driver.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 73af337..0ea7ab1 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -800,11 +800,14 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 	if (slot->flags & SLOT_ENABLED)
 		goto err_exit;
 
+	if (pci_bus_lock_states(bus, PCI_BUS_STATE_WORKING) < 0)
+		return -EINVAL;
+
 	num = pci_scan_slot(bus, PCI_DEVFN(slot->device, 0));
 	if (num == 0) {
 		/* Maybe only part of funcs are added. */
 		dbg("No new device found\n");
-		goto err_exit;
+		goto out_unlock;
 	}
 
 	max = acpiphp_max_busnr(bus);
@@ -862,8 +865,10 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 		pci_dev_put(dev);
 	}
 
+out_unlock:
+	pci_bus_unlock(bus);
 
- err_exit:
+err_exit:
 	return retval;
 }
 
@@ -906,6 +911,9 @@ static int disable_device(struct acpiphp_slot *slot)
 	struct pci_dev *pdev;
 	struct pci_bus *bus = slot->bridge->pci_bus;
 
+	if (pci_bus_lock_states(bus, PCI_BUS_STATE_WORKING) < 0)
+		goto err_exit;
+
 	/* The slot will be enabled when func 0 is added, so check
 	   func 0 before disable the slot. */
 	pdev = pci_get_slot(bus, PCI_DEVFN(slot->device, 0));
@@ -943,6 +951,7 @@ static int disable_device(struct acpiphp_slot *slot)
 	}
 
 	slot->flags &= (~SLOT_ENABLED);
+	pci_bus_unlock(bus);
 
 err_exit:
 	return 0;
-- 
1.7.9.5

