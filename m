Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934207Ab3AIUnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:43:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64923 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933967Ab3AIUnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:43:32 -0500
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
Subject: [PATCH 03/14] of/pci: Add of_pci_get_bus() function
Date: Wed,  9 Jan 2013 21:43:03 +0100
Message-Id: <1357764194-12677-4-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:nlD7iuq5xpPzGGStVlWnLT87jw4qDZr/JsT/G8Es246
 wSg85jlzZ/Pzvx8T/ke0TU2G1ps3kYuKxqNw/ae8nPjV9b+VgV
 kCAptRcEPzuAVbegh6qpASeHlnU8Rt1sum/JEGgoKonpTEcPYM
 bToHYTHuGgZPrvqbVBevRzUWExms/dARRLd8wE0L7q/qqpk7Vn
 GTv7YJVloDppbQxGirkPESkaFLuFv6o1MRNn+07pdYD8/4VzcW
 N1UXdLCC3jBEU3uefsttHKV7bJpv1ozwia8JVG7+JJBbPEh/h0
 rOb93dtDb6KZG4nyqhm1XJ+tHVfnFclVsNxeB39mEE0Z7jGXv5
 IUw1jeUR9/BpJoE5S7+yeC7fW9Sz91pNpweeKLJd/B/F4Lv+wu
 FlR5bMZ9SIyMeCxJC9DM7m2o5NzfDeeq082em9pW1pXaxqmESV
 vbWNl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function can be used to parse the number of a device's parent PCI
bus from a standard 5-cell PCI resource.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/of/of_pci.c    | 21 +++++++++++++++++++++
 include/linux/of_pci.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 0dd52df..7d5d2c3 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -43,6 +43,27 @@ struct device_node *of_pci_find_child_device(struct device_node *parent,
 EXPORT_SYMBOL_GPL(of_pci_find_child_device);
 
 /**
+ * of_pci_get_bus() - Get bus number for a device node
+ * @np: device node
+ *
+ * Parses a standard 5-cell PCI resource and returns the 8-bit bus number of
+ * the device's parent PCI bus. On error a negative error code is returned.
+ */
+int of_pci_get_bus(struct device_node *np)
+{
+	unsigned int size;
+	const __be32 *reg;
+
+	reg = of_get_property(np, "reg", &size);
+
+	if (!reg || size < 5 * sizeof(__be32))
+		return -EINVAL;
+
+	return (be32_to_cpup(reg) >> 16) & 0xff;
+}
+EXPORT_SYMBOL_GPL(of_pci_get_bus);
+
+/**
  * of_pci_get_devfn() - Get device and function numbers for a device node
  * @np: device node
  *
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index 91ec484..9118321 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -10,6 +10,7 @@ int of_irq_map_pci(const struct pci_dev *pdev, struct of_irq *out_irq);
 struct device_node;
 struct device_node *of_pci_find_child_device(struct device_node *parent,
 					     unsigned int devfn);
+int of_pci_get_bus(struct device_node *np);
 int of_pci_get_devfn(struct device_node *np);
 
 #endif
-- 
1.8.1

