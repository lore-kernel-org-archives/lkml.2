Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176Ab3AIUn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:43:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50659 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934110Ab3AIUnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:43:24 -0500
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
Subject: [PATCH 02/14] of/pci: Add of_pci_get_devfn() function
Date: Wed,  9 Jan 2013 21:43:02 +0100
Message-Id: <1357764194-12677-3-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:kSnrPVGIArMVLyWs2q0arebTlipX3hwt63btPabA7Rv
 83izFYJTDwCUlUB2gbQRMtFLcprpX/wDR/UF9hj0/VzJgo/zxF
 JgXHoYsXtS5tNljtEpxEp4vcsdQAUQsfJXEWv6gtCSewuFW7OV
 PgqQGW2JHTrNOP3JpNlgV1KoroX4iXRFhV1jH/HW5fr834b8CV
 zynVA7Yy8JC00uIS/FD5ZaKybeyHoDDER6C+Sah/Lkbz8UIqWk
 jdI5XugF5MAGkz0xn2IN3lmggSBAXtUvF7RwmWdCkYw9om2CQK
 KCUUanNJ8X3Ark+ueX/cbT3ScFtmSToqnSTZqI4Z/VCknSbgDr
 oApwKjKpS0xLDvPhhYdCaT5r21MUjSuK4XWlKj8IUumszQ0E0K
 Z96wfigPCnAjitzmERQzH9LqIl5JFoeuPKP7vKacmOsQ0B8Oqg
 E64W5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function can be used to parse the device and function number from a
standard 5-cell PCI resource. PCI_SLOT() and PCI_FUNC() can be used on
the returned value obtain the device and function numbers respectively.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/of/of_pci.c    | 32 ++++++++++++++++++++++++++++----
 include/linux/of_pci.h |  1 +
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 13e37e2..0dd52df 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -7,12 +7,13 @@
 static inline int __of_pci_pci_compare(struct device_node *node,
 				       unsigned int devfn)
 {
-	unsigned int size;
-	const __be32 *reg = of_get_property(node, "reg", &size);
+	int err;
 
-	if (!reg || size < 5 * sizeof(__be32))
+	err = of_pci_get_devfn(node);
+	if (err < 0)
 		return 0;
-	return ((be32_to_cpup(&reg[0]) >> 8) & 0xff) == devfn;
+
+	return devfn == err;
 }
 
 struct device_node *of_pci_find_child_device(struct device_node *parent,
@@ -40,3 +41,26 @@ struct device_node *of_pci_find_child_device(struct device_node *parent,
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(of_pci_find_child_device);
+
+/**
+ * of_pci_get_devfn() - Get device and function numbers for a device node
+ * @np: device node
+ *
+ * Parses a standard 5-cell PCI resource and returns an 8-bit value that can
+ * be passed to the PCI_SLOT() and PCI_FUNC() macros to extract the device
+ * and function numbers respectively. On error a negative error code is
+ * returned.
+ */
+int of_pci_get_devfn(struct device_node *np)
+{
+	unsigned int size;
+	const __be32 *reg;
+
+	reg = of_get_property(np, "reg", &size);
+
+	if (!reg || size < 5 * sizeof(__be32))
+		return -EINVAL;
+
+	return (be32_to_cpup(reg) >> 8) & 0xff;
+}
+EXPORT_SYMBOL_GPL(of_pci_get_devfn);
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index bb115de..91ec484 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -10,5 +10,6 @@ int of_irq_map_pci(const struct pci_dev *pdev, struct of_irq *out_irq);
 struct device_node;
 struct device_node *of_pci_find_child_device(struct device_node *parent,
 					     unsigned int devfn);
+int of_pci_get_devfn(struct device_node *np);
 
 #endif
-- 
1.8.1

