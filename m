Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab2HAP4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:56:41 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57673 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab2HAP4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:56:37 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH v3 09/32] PCI/PME: use PCIe capabilities access functions to simplify implementation
Date: Wed,  1 Aug 2012 23:54:14 +0800
Message-Id: <1343836477-7287-10-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
References: <1343836477-7287-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify PCIe PME implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/pcie/pme.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/pcie/pme.c b/drivers/pci/pcie/pme.c
index 30897bf..74a3d4d 100644
--- a/drivers/pci/pcie/pme.c
+++ b/drivers/pci/pcie/pme.c
@@ -57,17 +57,13 @@ struct pcie_pme_service_data {
  */
 void pcie_pme_interrupt_enable(struct pci_dev *dev, bool enable)
 {
-	int rtctl_pos;
-	u16 rtctl;
+	u16 set = 0, clr = 0;
 
-	rtctl_pos = pci_pcie_cap(dev) + PCI_EXP_RTCTL;
-
-	pci_read_config_word(dev, rtctl_pos, &rtctl);
 	if (enable)
-		rtctl |= PCI_EXP_RTCTL_PMEIE;
+		set = PCI_EXP_RTCTL_PMEIE;
 	else
-		rtctl &= ~PCI_EXP_RTCTL_PMEIE;
-	pci_write_config_word(dev, rtctl_pos, rtctl);
+		clr = PCI_EXP_RTCTL_PMEIE;
+	pci_pcie_capability_change_word(dev, PCI_EXP_RTCTL, set, clr);
 }
 
 /**
@@ -226,18 +222,15 @@ static void pcie_pme_work_fn(struct work_struct *work)
 	struct pcie_pme_service_data *data =
 			container_of(work, struct pcie_pme_service_data, work);
 	struct pci_dev *port = data->srv->port;
-	int rtsta_pos;
 	u32 rtsta;
 
-	rtsta_pos = pci_pcie_cap(port) + PCI_EXP_RTSTA;
-
 	spin_lock_irq(&data->lock);
 
 	for (;;) {
 		if (data->noirq)
 			break;
 
-		pci_read_config_dword(port, rtsta_pos, &rtsta);
+		pci_pcie_capability_read_dword(port, PCI_EXP_RTSTA, &rtsta);
 		if (rtsta & PCI_EXP_RTSTA_PME) {
 			/*
 			 * Clear PME status of the port.  If there are other
@@ -276,17 +269,14 @@ static irqreturn_t pcie_pme_irq(int irq, void *context)
 {
 	struct pci_dev *port;
 	struct pcie_pme_service_data *data;
-	int rtsta_pos;
 	u32 rtsta;
 	unsigned long flags;
 
 	port = ((struct pcie_device *)context)->port;
 	data = get_service_data((struct pcie_device *)context);
 
-	rtsta_pos = pci_pcie_cap(port) + PCI_EXP_RTSTA;
-
 	spin_lock_irqsave(&data->lock, flags);
-	pci_read_config_dword(port, rtsta_pos, &rtsta);
+	pci_pcie_capability_read_dword(port, PCI_EXP_RTSTA, &rtsta);
 
 	if (!(rtsta & PCI_EXP_RTSTA_PME)) {
 		spin_unlock_irqrestore(&data->lock, flags);
-- 
1.7.9.5

