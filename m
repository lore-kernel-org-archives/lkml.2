Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934236Ab3AIUno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:43:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57538 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933967Ab3AIUnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:43:39 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-tegra@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH 04/14] of/pci: Add of_pci_parse_bus_range() function
Date: Wed,  9 Jan 2013 21:43:04 +0100
Message-Id: <1357764194-12677-5-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:XS/VmoTbj2DxOgAWE10p9seqyytR4mQi7deBWRAZMd7
 S9FgFKjARJ2Rv+4TfgiFPVXAJPn+4vu42pT32qfdIPwXrQ6Tss
 lq0gmq2z4nk2jHceszXXbhHWZdOi7Py9qDc87hSw5Hwgqiw7d/
 fZ04nM0qiMgPDlPl305W74LMLPr0/D/vDufh9u+PgiC+EfblUV
 Cfh96+YS5c3PQHS6Rt/x7iKDDjQUeBMGuyG8LozFJe87NWUmMo
 WSXcG/jXoZnYZYiaPvD0L0VsDGpcJrwMoDowvGUCF1sWch1Ve0
 S8CZ5/YuVCYP2s3/2hPJpbXlCP9GS7ThnjKDUAvIU1eWnQI122
 6Bsl7SM3gHmtoHKwaG26kZFGMRs7E9KUF4/vNkfZ9i+cysgKsI
 ZV6YwEJAvo2xevuncMYG/GMsC6exFyk11PlfeF3o8bx3pLoxBq
 y9+Kd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function can be used to parse a bus-range property as specified by
device nodes representing PCI bridges.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/of/of_pci.c    | 25 +++++++++++++++++++++++++
 include/linux/of_pci.h |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 7d5d2c3..c311166 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -85,3 +85,28 @@ int of_pci_get_devfn(struct device_node *np)
 	return (be32_to_cpup(reg) >> 8) & 0xff;
 }
 EXPORT_SYMBOL_GPL(of_pci_get_devfn);
+
+/**
+ * of_pci_parse_bus_range() - parse the bus-range property of a PCI device
+ * @node: device node
+ * @res: address to a struct resource to return the bus-range
+ *
+ * Returns 0 on success or a negative error-code on failure.
+ */
+int of_pci_parse_bus_range(struct device_node *node, struct resource *res)
+{
+	const __be32 *values;
+	int len;
+
+	values = of_get_property(node, "bus-range", &len);
+	if (!values || len < sizeof(*values) * 2)
+		return -EINVAL;
+
+	res->name = node->name;
+	res->start = be32_to_cpup(values++);
+	res->end = be32_to_cpup(values);
+	res->flags = IORESOURCE_BUS;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_pci_parse_bus_range);
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index 9118321..fb6e95e 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -12,5 +12,6 @@ struct device_node *of_pci_find_child_device(struct device_node *parent,
 					     unsigned int devfn);
 int of_pci_get_bus(struct device_node *np);
 int of_pci_get_devfn(struct device_node *np);
+int of_pci_parse_bus_range(struct device_node *node, struct resource *res);
 
 #endif
-- 
1.8.1

