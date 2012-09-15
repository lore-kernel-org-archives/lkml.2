Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab2IOAtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 20:49:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23458 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab2IOAs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 20:48:57 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] PCI: Use correct type when freeing bus resource list
Date: Fri, 14 Sep 2012 17:48:41 -0700
Message-Id: <1347670122-25824-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1347670122-25824-1-git-send-email-yinghai@kernel.org>
References: <1347670122-25824-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should use struct pci_bus_resource instead of struct pci_host_bridge_window

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/bus.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/bus.c
+++ linux-2.6/drivers/pci/bus.c
@@ -87,11 +87,15 @@ EXPORT_SYMBOL_GPL(pci_bus_resource_n);
 void pci_bus_remove_resources(struct pci_bus *bus)
 {
 	int i;
+	struct pci_bus_resource *bus_res, *tmp;
 
 	for (i = 0; i < PCI_BRIDGE_RESOURCE_NUM; i++)
 		bus->resource[i] = NULL;
 
-	pci_free_resource_list(&bus->resources);
+	list_for_each_entry_safe(bus_res, tmp, &bus->resources, list) {
+		list_del(&bus_res->list);
+		kfree(bus_res);
+	}
 }
 
 /**
