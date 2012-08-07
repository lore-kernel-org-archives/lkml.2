Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab2HGQXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:23:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51364 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab2HGQUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:20:32 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v1 13/22] PCI: make each PCI device hold a reference to its parent PCI bus
Date: Wed,  8 Aug 2012 00:10:53 +0800
Message-Id: <1344355862-2726-14-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make each PCI device hold a reference to its parent PCI bus, so it won't
cause invalid memory access when doing:
pci_bus_lock_states(dev->bus, PCI_BUS_STATE_xxxx);

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/iov.c    |    3 ++-
 drivers/pci/probe.c  |    2 +-
 drivers/pci/remove.c |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index c7d2969..40f5f52 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -92,7 +92,8 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
 		kfree(virtfn);
 		mutex_unlock(&iov->dev->sriov->lock);
 		return -ENOMEM;
-	}
+	} else
+		pci_bus_get(virtfn->bus);
 	virtfn->devfn = virtfn_devfn(dev, id);
 	virtfn->vendor = dev->vendor;
 	pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_DID, &virtfn->device);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index e6b40d0..47bf071 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1272,7 +1272,7 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 	if (!dev)
 		return NULL;
 
-	dev->bus = bus;
+	dev->bus = pci_bus_get(bus);
 	dev->devfn = devfn;
 	dev->vendor = l & 0xffff;
 	dev->device = (l >> 16) & 0xffff;
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index a26a841..0d947c0 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -43,6 +43,7 @@ static void pci_destroy_dev(struct pci_dev *dev)
 		dev->bus_list.next = dev->bus_list.prev = NULL;
 		up_write(&pci_bus_sem);
 		pci_free_resources(dev);
+		pci_bus_put(dev->bus);
 		put_device(&dev->dev);
 	}
 }
-- 
1.7.9.5

