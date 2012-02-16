Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab2BPJLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:11:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51837 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab2BPJJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:09:43 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v5 13/27] of/address: add empty static inlines for !CONFIG_OF
Date: Thu, 16 Feb 2012 02:09:14 -0700
Message-Id: <1329383368-12122-14-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the title says, this patch adds empty implementations for the address
translation functions so that they can be used when CONFIG_OF is disabled.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 include/linux/of_address.h |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 3118623..01b925a 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -4,6 +4,7 @@
 #include <linux/errno.h>
 #include <linux/of.h>
 
+#ifdef CONFIG_OF_ADDRESS
 extern u64 of_translate_address(struct device_node *np, const __be32 *addr);
 extern int of_address_to_resource(struct device_node *dev, int index,
 				  struct resource *r);
@@ -25,12 +26,37 @@ static inline unsigned long pci_address_to_pio(phys_addr_t addr) { return -1; }
 #define pci_address_to_pio pci_address_to_pio
 #endif
 
-#ifdef CONFIG_PCI
+#else /* CONFIG_OF_ADDRESS */
+static inline int of_address_to_resource(struct device_node *dev, int index,
+					 struct resource *r)
+{
+	return -EINVAL;
+}
+static inline struct device_node *of_find_matching_node_by_address(
+					struct device_node *from,
+					const struct of_device_id *matches,
+					u64 base_address)
+{
+	return NULL;
+}
+static inline void __iomem *of_iomap(struct device_node *device, int index)
+{
+	return NULL;
+}
+static inline const u32 *of_get_address(struct device_node *dev, int index,
+					u64 *size, unsigned int *flags)
+{
+	return NULL;
+}
+#endif /* CONFIG_OF_ADDRESS */
+
+
+#if defined(CONFIG_OF_ADDRESS) && defined(CONFIG_PCI)
 extern const __be32 *of_get_pci_address(struct device_node *dev, int bar_no,
 			       u64 *size, unsigned int *flags);
 extern int of_pci_address_to_resource(struct device_node *dev, int bar,
 				      struct resource *r);
-#else /* CONFIG_PCI */
+#else /* CONFIG_OF_ADDRESS && CONFIG_PCI */
 static inline int of_pci_address_to_resource(struct device_node *dev, int bar,
 				             struct resource *r)
 {
@@ -42,8 +68,7 @@ static inline const __be32 *of_get_pci_address(struct device_node *dev,
 {
 	return NULL;
 }
-#endif /* CONFIG_PCI */
-
+#endif /* CONFIG_OF_ADDRESS && CONFIG_PCI */
 
 #endif /* __OF_ADDRESS_H */
 
-- 
1.7.9

