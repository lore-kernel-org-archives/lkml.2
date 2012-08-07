Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab2HGQTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:19:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51364 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab2HGQTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:19:22 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v1 05/22] PCI: introduce pci_bus_{get|put}() to manage PCI bus reference count
Date: Wed,  8 Aug 2012 00:10:45 +0800
Message-Id: <1344355862-2726-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes PCI hotplug drivers need to hold a reference count on a PCI bus,
so introduce pci_bus_{get|put}() to manage PCI bus reference count.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 drivers/pci/bus.c   |   15 +++++++++++++++
 include/linux/pci.h |    2 ++
 2 files changed, 17 insertions(+)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index e2a0c52..0e18270 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -325,6 +325,21 @@ void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
 }
 EXPORT_SYMBOL_GPL(pci_walk_bus);
 
+struct pci_bus *pci_bus_get(struct pci_bus *bus)
+{
+	if (bus)
+		get_device(&bus->dev);
+	return bus;
+}
+EXPORT_SYMBOL(pci_bus_get);
+
+void pci_bus_put(struct pci_bus *bus)
+{
+	if (bus)
+		put_device(&bus->dev);
+}
+EXPORT_SYMBOL(pci_bus_put);
+
 EXPORT_SYMBOL(pci_bus_alloc_resource);
 EXPORT_SYMBOL_GPL(pci_bus_add_device);
 EXPORT_SYMBOL(pci_bus_add_devices);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 95479cd..21fa79e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -955,6 +955,8 @@ int pci_request_selected_regions_exclusive(struct pci_dev *, int, const char *);
 void pci_release_selected_regions(struct pci_dev *, int);
 
 /* drivers/pci/bus.c */
+struct pci_bus *pci_bus_get(struct pci_bus *bus);
+void pci_bus_put(struct pci_bus *bus);
 void pci_add_resource(struct list_head *resources, struct resource *res);
 void pci_add_resource_offset(struct list_head *resources, struct resource *res,
 			     resource_size_t offset);
-- 
1.7.9.5

