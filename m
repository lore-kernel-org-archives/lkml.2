Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab2H1Pok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 11:44:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56281 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2H1Poh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 11:44:37 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Dave Airlie <airlied@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 2/5] PCI/vga: simplify code by hotplug safe pci_get_domain_bus_and_slot()
Date: Tue, 28 Aug 2012 23:43:55 +0800
Message-Id: <1346168638-32724-3-git-send-email-jiang.liu@huawei.com>
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
 drivers/gpu/vga/vgaarb.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 3df8fc0..b6852b7 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -1066,7 +1066,6 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		}
 
 	} else if (strncmp(curr_pos, "target ", 7) == 0) {
-		struct pci_bus *pbus;
 		unsigned int domain, bus, devfn;
 		struct vga_device *vgadev;
 
@@ -1085,19 +1084,11 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 			pr_debug("vgaarb: %s ==> %x:%x:%x.%x\n", curr_pos,
 				domain, bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
 
-			pbus = pci_find_bus(domain, bus);
-			pr_debug("vgaarb: pbus %p\n", pbus);
-			if (pbus == NULL) {
-				pr_err("vgaarb: invalid PCI domain and/or bus address %x:%x\n",
-					domain, bus);
-				ret_val = -ENODEV;
-				goto done;
-			}
-			pdev = pci_get_slot(pbus, devfn);
+			pdev = pci_get_domain_bus_and_slot(domain, bus, devfn);
 			pr_debug("vgaarb: pdev %p\n", pdev);
 			if (!pdev) {
-				pr_err("vgaarb: invalid PCI address %x:%x\n",
-					bus, devfn);
+				pr_err("vgaarb: invalid PCI address %x:%x:%x\n",
+					domain, bus, devfn);
 				ret_val = -ENODEV;
 				goto done;
 			}
-- 
1.7.9.5

