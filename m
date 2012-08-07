Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab2HGQVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:21:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51364 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab2HGQVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:21:05 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v1 17/22] PCI/pciehp: use PCI bus lock to avoid race conditions
Date: Wed,  8 Aug 2012 00:10:57 +0800
Message-Id: <1344355862-2726-18-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses PCI bus lock mechanism to avoid race conditions when doing
PCI device hotplug by pciehp driver.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/hotplug/pciehp_pci.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
index 09cecaf..9536a9e 100644
--- a/drivers/pci/hotplug/pciehp_pci.c
+++ b/drivers/pci/hotplug/pciehp_pci.c
@@ -42,18 +42,25 @@ int pciehp_configure_device(struct slot *p_slot)
 	int num, fn;
 	struct controller *ctrl = p_slot->ctrl;
 
+	if (pci_bus_lock_states(parent, PCI_BUS_STATE_WORKING) < 0) {
+		ctrl_dbg(ctrl, "Port has been removed\n");
+		return -EINVAL;
+	}
+
 	dev = pci_get_slot(parent, PCI_DEVFN(0, 0));
 	if (dev) {
 		ctrl_err(ctrl, "Device %s already exists "
 			 "at %04x:%02x:00, cannot hot-add\n", pci_name(dev),
 			 pci_domain_nr(parent), parent->number);
 		pci_dev_put(dev);
+		pci_bus_unlock(parent);
 		return -EINVAL;
 	}
 
 	num = pci_scan_slot(parent, PCI_DEVFN(0, 0));
 	if (num == 0) {
 		ctrl_err(ctrl, "No new device found\n");
+		pci_bus_unlock(parent);
 		return -ENODEV;
 	}
 
@@ -82,6 +89,7 @@ int pciehp_configure_device(struct slot *p_slot)
 	}
 
 	pci_bus_add_devices(parent);
+	pci_bus_unlock(parent);
 
 	return 0;
 }
@@ -96,6 +104,11 @@ int pciehp_unconfigure_device(struct slot *p_slot)
 	u16 command;
 	struct controller *ctrl = p_slot->ctrl;
 
+	if (pci_bus_lock_states(parent, PCI_BUS_STATE_WORKING) < 0) {
+		ctrl_dbg(ctrl, "Port has been removed\n");
+		return -EINVAL;
+	}
+
 	ctrl_dbg(ctrl, "%s: domain:bus:dev = %04x:%02x:00\n",
 		 __func__, pci_domain_nr(parent), parent->number);
 	ret = pciehp_get_adapter_status(p_slot, &presence);
@@ -131,5 +144,7 @@ int pciehp_unconfigure_device(struct slot *p_slot)
 		pci_dev_put(temp);
 	}
 
+	pci_bus_unlock(parent);
+
 	return rc;
 }
-- 
1.7.9.5

