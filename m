Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2BZXei (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 18:34:38 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:21165 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab2BZXdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 18:33:52 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 6/8] PCI: add host bridge release support
Date: Sun, 26 Feb 2012 15:33:20 -0800
Message-Id: <1330299202-3838-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330299202-3838-1-git-send-email-yinghai@kernel.org>
References: <1330299202-3838-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4F4AC15D.009A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need one hook to release host bridge resource that are created for host
bridge.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/host-bridge.c |    8 ++++++++
 drivers/pci/probe.c       |    3 ++-
 include/linux/pci.h       |    5 +++++
 3 files changed, 15 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/host-bridge.c
===================================================================
--- linux-2.6.orig/drivers/pci/host-bridge.c
+++ linux-2.6/drivers/pci/host-bridge.c
@@ -33,6 +33,14 @@ static struct pci_host_bridge *find_pci_
 	return to_pci_host_bridge(bus->bridge);
 }
 
+void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
+				 void (*release_fn)(struct pci_host_bridge *),
+				 void *release_data)
+{
+	bridge->release_fn = release_fn;
+	bridge->release_data = release_data;
+}
+
 static bool resource_contains(struct resource *res1, struct resource *res2)
 {
 	return res1->start <= res2->start && res1->end >= res2->end;
Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -1136,7 +1136,8 @@ static void pci_release_bus_bridge_dev(s
 {
 	struct pci_host_bridge *bridge = to_pci_host_bridge(dev);
 
-	/* TODO: need to free window->res */
+	if (bridge->release_fn)
+		bridge->release_fn(bridge);
 
 	pci_free_resource_list(&bridge->windows);
 
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -378,9 +378,14 @@ struct pci_host_bridge {
 	struct device dev;
 	struct pci_bus *bus;		/* root bus */
 	struct list_head windows;	/* pci_host_bridge_windows */
+	void (*release_fn)(struct pci_host_bridge *);
+	void *release_data;
 };
 
 #define	to_pci_host_bridge(n) container_of(n, struct pci_host_bridge, dev)
+void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
+		     void (*release_fn)(struct pci_host_bridge *),
+		     void *release_data);
 
 /*
  * The first PCI_BRIDGE_RESOURCE_NUM PCI bus resources (those that correspond
