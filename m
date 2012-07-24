Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab2GXQet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:34:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40539 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab2GXQer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:34:47 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 09/32] PCI/PME: use PCIe capabilities access functions to simplify implementation
Date: Wed, 25 Jul 2012 00:31:21 +0800
Message-Id: <1343147504-25891-10-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use PCIe capabilities access functions to simplify PCIe PME implementation.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/pcie/pme.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/pcie/pme.c b/drivers/pci/pcie/pme.c
index 30897bf..6cd6ab7 100644
--- a/drivers/pci/pcie/pme.c
+++ b/drivers/pci/pcie/pme.c
@@ -57,17 +57,14 @@ struct pcie_pme_service_data {
  */
 void pcie_pme_interrupt_enable(struct pci_dev *dev, bool enable)
 {
-	int rtctl_pos;
 	u16 rtctl;
 
-	rtctl_pos = pci_pcie_cap(dev) + PCI_EXP_RTCTL;
-
-	pci_read_config_word(dev, rtctl_pos, &rtctl);
+	pci_pcie_capability_read_word(dev, PCI_EXP_RTCTL, &rtctl);
 	if (enable)
 		rtctl |= PCI_EXP_RTCTL_PMEIE;
 	else
 		rtctl &= ~PCI_EXP_RTCTL_PMEIE;
-	pci_write_config_word(dev, rtctl_pos, rtctl);
+	pci_pcie_capability_write_word(dev, PCI_EXP_RTCTL, rtctl);
 }
 
 /**
@@ -226,18 +223,15 @@ static void pcie_pme_work_fn(struct work_struct *work)
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
@@ -276,17 +270,14 @@ static irqreturn_t pcie_pme_irq(int irq, void *context)
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

