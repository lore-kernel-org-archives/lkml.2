Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2H1Pod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 11:44:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56281 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2H1Poa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 11:44:30 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Jes Sorensen <jes@sgi.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 1/5] PCI/IA64: simplify code by hotplug safe pci_get_domain_bus_and_slot()
Date: Tue, 28 Aug 2012 23:43:54 +0800
Message-Id: <1346168638-32724-2-git-send-email-jiang.liu@huawei.com>
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
 arch/ia64/sn/kernel/io_common.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/ia64/sn/kernel/io_common.c b/arch/ia64/sn/kernel/io_common.c
index fbb5f2f..8630875 100644
--- a/arch/ia64/sn/kernel/io_common.c
+++ b/arch/ia64/sn/kernel/io_common.c
@@ -229,7 +229,6 @@ void sn_pci_fixup_slot(struct pci_dev *dev, struct pcidev_info *pcidev_info,
 {
 	int segment = pci_domain_nr(dev->bus);
 	struct pcibus_bussoft *bs;
-	struct pci_bus *host_pci_bus;
 	struct pci_dev *host_pci_dev;
 	unsigned int bus_no, devfn;
 
@@ -245,8 +244,7 @@ void sn_pci_fixup_slot(struct pci_dev *dev, struct pcidev_info *pcidev_info,
 
 	bus_no = (pcidev_info->pdi_slot_host_handle >> 32) & 0xff;
 	devfn = pcidev_info->pdi_slot_host_handle & 0xffffffff;
- 	host_pci_bus = pci_find_bus(segment, bus_no);
- 	host_pci_dev = pci_get_slot(host_pci_bus, devfn);
+	host_pci_dev = pci_get_domain_bus_and_slot(segment, bus_no, devfn);
 
 	pcidev_info->host_pci_dev = host_pci_dev;
 	pcidev_info->pdi_linux_pcidev = dev;
-- 
1.7.9.5

