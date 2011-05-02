Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1EBFHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 01:07:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61801 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1EBFHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 01:07:52 -0400
Subject: [RFC PATCH 2/4] of/address: Add of_find_matching_node_by_address
 helper
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        John Linn <john.linn@xilinx.com>
Date: Sun, 01 May 2011 23:07:50 -0600
Message-ID: <20110502050750.24800.98133.stgit@ponder>
In-Reply-To: <20110502045207.24800.91172.stgit@ponder>
References: <20110502045207.24800.91172.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_find_matching_node_by_address() can be used to find a device tree
node for a device at a specific address.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/address.c       |   18 ++++++++++++++++++
 include/linux/of_address.h |    4 ++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index b43ff66..deefc0c 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -591,6 +591,24 @@ int of_address_to_resource(struct device_node *dev, int index,
 }
 EXPORT_SYMBOL_GPL(of_address_to_resource);
 
+struct device_node *of_find_matching_node_by_address(struct device_node *from,
+					const struct of_device_id *matches,
+					u64 base_address)
+{
+	struct device_node *dn = of_find_matching_node(from, matches);
+	struct resource res;
+
+	while (dn) {
+		if (of_address_to_resource(dn, 0, &res))
+			continue;
+		if (res.start == base_address)
+			return dn;
+		dn = of_find_matching_node(dn, matches);
+	}
+
+	return NULL;
+}
+
 
 /**
  * of_iomap - Maps the memory mapped IO for a given device_node
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 6711d5f..4fbea28 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -7,6 +7,10 @@ extern int of_address_count(struct device_node *np);
 extern u64 of_translate_address(struct device_node *np, const __be32 *addr);
 extern int of_address_to_resource(struct device_node *dev, int index,
 				  struct resource *r);
+extern struct device_node *of_find_matching_node_by_address(
+					struct device_node *from,
+					const struct of_device_id *matches,
+					u64 base_address);
 extern void __iomem *of_iomap(struct device_node *device, int index);
 
 /* Extract an address from a device, returns the region size and

