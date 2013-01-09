Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934256Ab3AIUrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:47:00 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55329 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934193Ab3AIUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:43:35 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-tegra@vger.kernel.org
Cc: Andrew Murray <andrew.murray@arm.com>,
        Andrew Murray <Andrew.Murray@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH 01/14] of/pci: Provide support for parsing PCI DT ranges property
Date: Wed,  9 Jan 2013 21:43:01 +0100
Message-Id: <1357764194-12677-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:jWOjdQrL4/57JaSPKrRTwsBTFpk28bOSoQerFfatATR
 t4n9EtaoMDxk62dygnTpqZuJyDlxK0UiRvOe2nAOJKETB3gzY6
 BOVAJg+KGeQlH1yrwDWeHsJoG41OZSOE46+G+Ypxt/l+p4ltx6
 xS4/k5f41yq7HBVhozbwG3ggli5ra2wvRJQfBGmiSiGiYu5ydy
 lKwfUwx5jSpYFKgoDAroLSBpejG2jFGNKqo6l7nG62oaQiy/5L
 VMAB3b12odWkJiROsG88rqBX2dqcb3axVqnBcVgZf7CubZkJ3V
 k+mHkozlKRZSgsA+UBvEIiqGdEFvaDZV2EqyF4YyQ/gxXZhYg2
 RP3SdlpyeievHv2pTiiZn6aMjDhluYZWgK8378wT19e1sNfJOv
 V4zhDWlJhk4+K44lHr6nDVbxu4zEx36gnd6kNwO8UUb7dHTH3s
 dMa1P
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Murray <andrew.murray@arm.com>

DT bindings for PCI host bridges often use the ranges property to describe
memory and IO ranges - this binding tends to be the same across architectures
yet several parsing implementations exist, e.g. arch/mips/pci/pci.c,
arch/powerpc/kernel/pci-common.c, arch/sparc/kernel/pci.c and
arch/microblaze/pci/pci-common.c (clone of PPC). Some of these duplicate
functionality provided by drivers/of/address.c.

This patch provides a common iterator-based parser for the ranges property, it
is hoped this will reduce DT representation differences between architectures
and that architectures will migrate in part to this new parser.

It is also hoped (and the motativation for the patch) that this patch will
reduce duplication of code when writing host bridge drivers that are supported
by multiple architectures.

This patch provides struct resources from a device tree node, e.g.:

	u32 *last = NULL;
	struct resource res;
	while ((last = of_pci_process_ranges(np, res, last))) {
		//do something with res
	}

Platforms with quirks can then do what they like with the resource or migrate
common quirk handling to the parser. In an ideal world drivers can just request
the obtained resources and pass them on (e.g. pci_add_resource_offset).

Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/of/address.c       | 63 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_address.h |  9 +++++++
 2 files changed, 72 insertions(+)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 0125524..d659527 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -13,6 +13,7 @@
 #define OF_CHECK_COUNTS(na, ns)	(OF_CHECK_ADDR_COUNT(na) && (ns) > 0)
 
 static struct of_bus *of_match_bus(struct device_node *np);
+static struct of_bus *of_find_bus(const char *name);
 static int __of_address_to_resource(struct device_node *dev,
 		const __be32 *addrp, u64 size, unsigned int flags,
 		const char *name, struct resource *r);
@@ -227,6 +228,57 @@ int of_pci_address_to_resource(struct device_node *dev, int bar,
 	return __of_address_to_resource(dev, addrp, size, flags, NULL, r);
 }
 EXPORT_SYMBOL_GPL(of_pci_address_to_resource);
+
+const __be32 *of_pci_process_ranges(struct device_node *node,
+				    struct resource *res, const __be32 *from)
+{
+	const __be32 *start, *end;
+	int na, ns, np, pna;
+	int rlen;
+	struct of_bus *bus;
+
+	WARN_ON(!res);
+
+	bus = of_find_bus("pci");
+	bus->count_cells(node, &na, &ns);
+	if (!OF_CHECK_COUNTS(na, ns)) {
+		pr_err("Bad cell count for %s\n", node->full_name);
+		return NULL;
+	}
+
+	pna = of_n_addr_cells(node);
+	np = pna + na + ns;
+
+	start = of_get_property(node, "ranges", &rlen);
+	if (start == NULL)
+		return NULL;
+
+	end = start + rlen / sizeof(__be32);
+
+	if (!from)
+		from = start;
+
+	while (from + np <= end) {
+		u64 cpu_addr, size;
+
+		cpu_addr = of_translate_address(node, from + na);
+		size = of_read_number(from + na + pna, ns);
+		res->flags = bus->get_flags(from);
+		from += np;
+
+		if (cpu_addr == OF_BAD_ADDR || size == 0)
+			continue;
+
+		res->name = node->full_name;
+		res->start = cpu_addr;
+		res->end = res->start + size - 1;
+		res->parent = res->child = res->sibling = NULL;
+		return from;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(of_pci_process_ranges);
 #endif /* CONFIG_PCI */
 
 /*
@@ -337,6 +389,17 @@ static struct of_bus *of_match_bus(struct device_node *np)
 	return NULL;
 }
 
+static struct of_bus *of_find_bus(const char *name)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(of_busses); i++)
+		if (strcmp(name, of_busses[i].name) == 0)
+			return &of_busses[i];
+
+	return NULL;
+}
+
 static int of_translate_one(struct device_node *parent, struct of_bus *bus,
 			    struct of_bus *pbus, __be32 *addr,
 			    int na, int ns, int pna, const char *rprop)
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 0506eb5..751e889 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -27,6 +27,8 @@ static inline unsigned long pci_address_to_pio(phys_addr_t addr) { return -1; }
 #define pci_address_to_pio pci_address_to_pio
 #endif
 
+const __be32 *of_pci_process_ranges(struct device_node *node,
+				    struct resource *res, const __be32 *from);
 #else /* CONFIG_OF_ADDRESS */
 #ifndef of_address_to_resource
 static inline int of_address_to_resource(struct device_node *dev, int index,
@@ -53,6 +55,13 @@ static inline const __be32 *of_get_address(struct device_node *dev, int index,
 {
 	return NULL;
 }
+
+static inline const __be32 *of_pci_process_ranges(struct device_node *node,
+						  struct resource *res,
+						  const __be32 *from)
+{
+	return NULL;
+}
 #endif /* CONFIG_OF_ADDRESS */
 
 
-- 
1.8.1

