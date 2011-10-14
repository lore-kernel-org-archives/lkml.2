Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab1JNE1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:27:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20719 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1JNE1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:27:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=H0tR3YfHf2cl1Cwv8cgCpRpsqeBCXLvSAyCDnNF9NsE8MTu6v0Z3k7bZw9PaG7rqm
	2wou8AzTvMrSJnUf1yAew==
Subject: [PATCH v2 01/29] PCI: add helpers for building PCI bus resource lists
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:27:11 -0600
Message-ID: <20111014042711.23504.13042.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
References: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'd like to supply a list of resources when we create a new PCI bus,
e.g., the root bus under a PCI host bridge.  These are helpers for
constructing that list.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/bus.c   |   30 +++++++++++++++++++++++++-----
 include/linux/pci.h |    2 ++
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 1e2ad92..79fc31a 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -18,6 +18,30 @@
 
 #include "pci.h"
 
+void pci_add_resource(struct list_head *resources, struct resource *res)
+{
+	struct pci_bus_resource *bus_res;
+
+	bus_res = kzalloc(sizeof(struct pci_bus_resource), GFP_KERNEL);
+	if (!bus_res) {
+		printk(KERN_ERR "PCI: can't add bus resource %pR\n", res);
+		return;
+	}
+
+	bus_res->res = res;
+	list_add_tail(&bus_res->list, resources);
+}
+
+void pci_free_resource_list(struct list_head *resources)
+{
+	struct pci_bus_resource *bus_res, *tmp;
+
+	list_for_each_entry_safe(bus_res, tmp, resources, list) {
+		list_del(&bus_res->list);
+		kfree(bus_res);
+	}
+}
+
 void pci_bus_add_resource(struct pci_bus *bus, struct resource *res,
 			  unsigned int flags)
 {
@@ -52,16 +76,12 @@ EXPORT_SYMBOL_GPL(pci_bus_resource_n);
 
 void pci_bus_remove_resources(struct pci_bus *bus)
 {
-	struct pci_bus_resource *bus_res, *tmp;
 	int i;
 
 	for (i = 0; i < PCI_BRIDGE_RESOURCE_NUM; i++)
 		bus->resource[i] = NULL;
 
-	list_for_each_entry_safe(bus_res, tmp, &bus->resources, list) {
-		list_del(&bus_res->list);
-		kfree(bus_res);
-	}
+	pci_free_resource_list(&bus->resources);
 }
 
 /**
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 9fc0122..6841e7f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -907,6 +907,8 @@ int pci_request_selected_regions_exclusive(struct pci_dev *, int, const char *);
 void pci_release_selected_regions(struct pci_dev *, int);
 
 /* drivers/pci/bus.c */
+void pci_add_resource(struct list_head *resources, struct resource *res);
+void pci_free_resource_list(struct list_head *resources);
 void pci_bus_add_resource(struct pci_bus *bus, struct resource *res, unsigned int flags);
 struct resource *pci_bus_resource_n(const struct pci_bus *bus, int n);
 void pci_bus_remove_resources(struct pci_bus *bus);

