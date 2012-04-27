Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab2D0PVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:21:43 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:50093 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760581Ab2D0PVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:21:40 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v2 11/19] PCI: release IO resource in error handling path in cpcihp_generic_init()
Date: Fri, 27 Apr 2012 23:16:52 +0800
Message-Id: <1335539820-11232-12-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
References: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Release IO resource in error handling path in function cpcihp_generic_init().

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/hotplug/cpcihp_generic.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/hotplug/cpcihp_generic.c b/drivers/pci/hotplug/cpcihp_generic.c
index 81af764..518f387 100644
--- a/drivers/pci/hotplug/cpcihp_generic.c
+++ b/drivers/pci/hotplug/cpcihp_generic.c
@@ -157,16 +157,19 @@ static int __init cpcihp_generic_init(void)
 	bus = pci_find_bus(0, bridge_busnr);
 	if (!bus) {
 		err("Invalid bus number %d", bridge_busnr);
-		return -EINVAL;
-	}
-	dev = pci_get_slot(bus, PCI_DEVFN(bridge_slot, 0));
-	if(!dev || dev->hdr_type != PCI_HEADER_TYPE_BRIDGE) {
-		err("Invalid bridge device %s", bridge);
+	} else {
+		dev = pci_get_slot(bus, PCI_DEVFN(bridge_slot, 0));
+		if (!dev || dev->hdr_type != PCI_HEADER_TYPE_BRIDGE) {
+			err("Invalid bridge device %s", bridge);
+			bus = NULL;
+		} else
+			bus = dev->subordinate;
 		pci_dev_put(dev);
-		return -EINVAL;
 	}
-	bus = dev->subordinate;
-	pci_dev_put(dev);
+	if (!bus) {
+		status = -EINVAL;
+		goto init_find_bus_error;
+	}
 
 	memset(&generic_hpc, 0, sizeof (struct cpci_hp_controller));
 	generic_hpc_ops.query_enum = query_enum;
@@ -175,7 +178,8 @@ static int __init cpcihp_generic_init(void)
 	status = cpci_hp_register_controller(&generic_hpc);
 	if(status != 0) {
 		err("Could not register cPCI hotplug controller");
-		return -ENODEV;
+		status = -ENODEV;
+		goto init_find_bus_error;
 	}
 	dbg("registered controller");
 
@@ -193,10 +197,13 @@ static int __init cpcihp_generic_init(void)
 	}
 	dbg("started cpci hp system");
 	return 0;
+
 init_start_error:
 	cpci_hp_unregister_bus(bus);
 init_bus_register_error:
 	cpci_hp_unregister_controller(&generic_hpc);
+init_find_bus_error:
+	release_region(port, 1);
 	err("status = %d", status);
 	return status;
 
-- 
1.7.5.4

