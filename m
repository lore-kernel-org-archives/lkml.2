Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab2H1Poy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 11:44:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56281 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab2H1Pou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 11:44:50 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 4/5] PCI/IOV: simplify code by hotplug safe pci_get_domain_bus_and_slot()
Date: Tue, 28 Aug 2012 23:43:57 +0800
Message-Id: <1346168638-32724-5-git-send-email-jiang.liu@huawei.com>
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
 drivers/pci/iov.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index aeccc91..b0fe771 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -152,15 +152,11 @@ failed1:
 static void virtfn_remove(struct pci_dev *dev, int id, int reset)
 {
 	char buf[VIRTFN_ID_LEN];
-	struct pci_bus *bus;
 	struct pci_dev *virtfn;
 	struct pci_sriov *iov = dev->sriov;
 
-	bus = pci_find_bus(pci_domain_nr(dev->bus), virtfn_bus(dev, id));
-	if (!bus)
-		return;
-
-	virtfn = pci_get_slot(bus, virtfn_devfn(dev, id));
+	virtfn = pci_get_domain_bus_and_slot(pci_domain_nr(dev->bus),
+			virtfn_bus(dev, id), virtfn_devfn(dev, id));
 	if (!virtfn)
 		return;
 
-- 
1.7.9.5

