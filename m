Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab2HYKBc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 06:01:32 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:63528 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2HYKBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 06:01:24 -0400
Message-ID: <5038A217.5050007@huawei.com>
Date: Sat, 25 Aug 2012 17:59:51 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
CC: PCI <linux-pci@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Huang Ying <ying.huang@intel.com>, Hanjun Guo <guohanjun@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [RESEND BUGFIX PATCH 2/3] PCI/AER: clean pci_bus_ops when related
 pci bus was removed
References: <1344685946-8172-2-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1344685946-8172-2-git-send-email-wangyijing@huawei.com>
X-Forwarded-Message-Id: <1344685946-8172-2-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.84]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When Inject aer errors to the target pci device, a pci_bus_ops will
be allocated for the pci device's pci bus.When the pci bus was removed,
we should also release the pci_bus_ops.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/pcie/aer/aer_inject.c |   43 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
index fc28785..8ca744f 100644
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -526,10 +526,50 @@ static struct miscdevice aer_inject_device = {
 	.fops = &aer_inject_fops,
 };

+static void aer_clean_pci_bus_ops(struct pci_dev *dev)
+{
+	unsigned long flags;
+	struct pci_bus_ops *bus_ops, *tmp_ops;
+	struct pci_bus *bus;
+	bus = dev->subordinate;
+	if (!bus)
+		return;
+
+	spin_lock_irqsave(&inject_lock, flags);
+	list_for_each_entry_safe(bus_ops, tmp_ops, &pci_bus_ops_list, list)
+		if (bus_ops->bus == bus) {
+			list_del(&bus_ops->list);
+			kfree(bus_ops);
+			break;
+		}
+	spin_unlock_irqrestore(&inject_lock, flags);
+}
+
+static int aer_hp_notify_fn(struct notifier_block *nb,
+		unsigned long event, void *data)
+{
+	switch (event) {
+	case BUS_NOTIFY_DEL_DEVICE:
+		aer_clean_pci_bus_ops(to_pci_dev(data));
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block aerinj_hp_notifier = {
+	.notifier_call = &aer_hp_notify_fn,
+};

 static int __init aer_inject_init(void)
 {
-	return misc_register(&aer_inject_device);
+	int ret;
+	ret = misc_register(&aer_inject_device);
+	if (!ret)
+		bus_register_notifier(&pci_bus_type, &aerinj_hp_notifier);
+	return ret;
 }

 static void __exit aer_inject_exit(void)
@@ -538,6 +578,7 @@ static void __exit aer_inject_exit(void)
 	unsigned long flags;
 	struct pci_bus_ops *bus_ops;

+	bus_unregister_notifier(&pci_bus_type, &aerinj_hp_notifier);
 	misc_deregister(&aer_inject_device);

 	while ((bus_ops = pci_bus_ops_pop())) {
-- 
1.7.1



.




