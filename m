Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2H1Por (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 11:44:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56281 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2H1Poo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 11:44:44 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Scott Murray <scott@spiteful.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 3/5] PCI/cpcihp: simplify code by hotplug safe pci_get_domain_bus_and_slot()
Date: Tue, 28 Aug 2012 23:43:56 +0800
Message-Id: <1346168638-32724-4-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1346168638-32724-1-git-send-email-jiang.liu@huawei.com>
References: <1346168638-32724-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following code has a race window between pci_find_bus() and pci_get_slot()
if PCI hotplug operation happens between them which removes the pci_bus.
So use PCI hotplug safe interface pci_get_domain_bus_and_slot() instead,
which also reduces code complexity.

struct pci_bus *pci_bus = pci_find_bus(domain, busno);
struct pci_dev *pci_dev = pci_get_slot(pci_bus, devfn);

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/pci/hotplug/cpcihp_generic.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/hotplug/cpcihp_generic.c b/drivers/pci/hotplug/cpcihp_generic.c
index 81af764..a6a71c4 100644
--- a/drivers/pci/hotplug/cpcihp_generic.c
+++ b/drivers/pci/hotplug/cpcihp_generic.c
@@ -154,12 +154,8 @@ static int __init cpcihp_generic_init(void)
 	if(!r)
 		return -EBUSY;
 
-	bus = pci_find_bus(0, bridge_busnr);
-	if (!bus) {
-		err("Invalid bus number %d", bridge_busnr);
-		return -EINVAL;
-	}
-	dev = pci_get_slot(bus, PCI_DEVFN(bridge_slot, 0));
+	dev = pci_get_domain_bus_and_slot(0, bridge_busnr,
+					  PCI_DEVFN(bridge_slot, 0));
 	if(!dev || dev->hdr_type != PCI_HEADER_TYPE_BRIDGE) {
 		err("Invalid bridge device %s", bridge);
 		pci_dev_put(dev);
-- 
1.7.9.5

