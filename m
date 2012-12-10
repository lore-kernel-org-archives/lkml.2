Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2LJVvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:51:24 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:49021 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab2LJVvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:51:22 -0500
Date: Mon, 10 Dec 2012 14:51:19 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH] of: Support a PCI device that is compatible with 'simple-bus'
Message-ID: <20121210215119.GA32011@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intended use for this feature is to let a PCI device declare
itself a 'simple-bus' and then describe additional devices
(such as GPIOs, I2C, etc) nested below itself.

The devices nested below the PCI device will use 'reg' addressing
with the 5 dw format used by PCI.

This is for embedded cases where the PCI device may be a complex
SOC with no PCI based partitioning of sub-functionality.

Tested on an ARM kirkwood system

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/of/address.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

Grant:

> If the soc_devices are getting triggered on that and they shouldn't be,
> then we need a mechanism in the soc_bridge node to kick out of that
> behavoir for its children.

Is this what you were thinking?

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 0125524..cf9dac5 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -110,6 +110,25 @@ static int of_bus_pci_match(struct device_node *np)
 	return !strcmp(np->type, "pci") || !strcmp(np->type, "vci");
 }
 
+/*
+ * When simple-bus is nested below a PCI bus then we treat the simple-bus
+ * as having the same 3 address/2 size semantics as the PCI bus, but create
+ * platform devices like normal.
+ */
+static int of_bus_platform_pci_match(struct device_node *np)
+{
+	struct device_node *parent;
+	int parent_is_pci;
+
+	parent = of_get_parent(np);
+	if (parent == NULL)
+		return 0;
+	parent_is_pci = of_bus_pci_match(parent);
+	of_node_put(parent);
+
+	return parent_is_pci && of_device_is_compatible(np, "simple-bus");
+}
+
 static void of_bus_pci_count_cells(struct device_node *np,
 				   int *addrc, int *sizec)
 {
@@ -293,6 +312,16 @@ static unsigned int of_bus_isa_get_flags(const __be32 *addr)
 
 static struct of_bus of_busses[] = {
 #ifdef CONFIG_PCI
+	/* Platform devices beneath a PCI device */
+	{
+		.name = "platform_pci",
+		.addresses = "reg",
+		.match = of_bus_platform_pci_match,
+		.count_cells = of_bus_pci_count_cells,
+		.map = of_bus_pci_map,
+		.translate = of_bus_pci_translate,
+		.get_flags = of_bus_pci_get_flags,
+	},
 	/* PCI */
 	{
 		.name = "pci",
-- 
1.7.5.4

