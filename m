Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab2CADBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 22:01:16 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:31640 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab2CADBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 22:01:11 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/36] PCI: rename pci_host_bridge() to find_pci_root_bridge()
Date: Wed, 29 Feb 2012 19:00:04 -0800
Message-Id: <1330570837-26638-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330570837-26638-1-git-send-email-yinghai@kernel.org>
References: <1330570837-26638-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090209.4F4EE66F.0083,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate find_pci_root_bus out.

-v2: according to Bjorn, remove extra null checking.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/host-bridge.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index 5ca4220..78adcc0 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -16,15 +16,22 @@ void add_to_pci_host_bridges(struct pci_host_bridge *bridge)
 	list_add_tail(&bridge->list, &pci_host_bridges);
 }
 
-static struct pci_host_bridge *pci_host_bridge(struct pci_dev *dev)
+static struct pci_bus *find_pci_root_bus(struct pci_dev *dev)
 {
 	struct pci_bus *bus;
-	struct pci_host_bridge *bridge;
 
 	bus = dev->bus;
 	while (bus->parent)
 		bus = bus->parent;
 
+	return bus;
+}
+
+static struct pci_host_bridge *find_pci_host_bridge(struct pci_dev *dev)
+{
+	struct pci_bus *bus = find_pci_root_bus(dev);
+	struct pci_host_bridge *bridge;
+
 	list_for_each_entry(bridge, &pci_host_bridges, list) {
 		if (bridge->bus == bus)
 			return bridge;
@@ -41,7 +48,7 @@ static bool resource_contains(struct resource *res1, struct resource *res2)
 void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
 			     struct resource *res)
 {
-	struct pci_host_bridge *bridge = pci_host_bridge(dev);
+	struct pci_host_bridge *bridge = find_pci_host_bridge(dev);
 	struct pci_host_bridge_window *window;
 	resource_size_t offset = 0;
 
@@ -69,12 +76,13 @@ static bool region_contains(struct pci_bus_region *region1,
 void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
 			     struct pci_bus_region *region)
 {
-	struct pci_host_bridge *bridge = pci_host_bridge(dev);
+	struct pci_host_bridge *bridge = find_pci_host_bridge(dev);
 	struct pci_host_bridge_window *window;
-	struct pci_bus_region bus_region;
 	resource_size_t offset = 0;
 
 	list_for_each_entry(window, &bridge->windows, list) {
+		struct pci_bus_region bus_region;
+
 		if (resource_type(res) != resource_type(window->res))
 			continue;
 
-- 
1.7.7

