Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab1DGWxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:53:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50626
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756442Ab1DGWxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:53:23 -0400
Date: Thu, 07 Apr 2011 15:52:47 -0700 (PDT)
Message-Id: <20110407.155247.260074665.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, bheglaas@google.com, monstr@monstr.eu,
        tglx@linuxtronix.de, bigeasy@linuxtronix.de
Subject: Re: [PATCH 1/5] pci/of: Match PCI devices to OF nodes dynamically
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110407.153121.115952367.davem@davemloft.net>
References: <20110407.152707.39195948.davem@davemloft.net>
	<20110407.152937.59699180.davem@davemloft.net>
	<20110407.153121.115952367.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 07 Apr 2011 15:31:21 -0700 (PDT)

> I don't think it's a good idea to mix the things you're trying to do
> with all of the existing stuff in of_pci.c, why not create a new file
> for the stuff you're trying to consolidate?

Something like the following could be done to your first patch.

My sparc64 machine boots up properly with this change added to your
patch series:

diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index f7861ed..ceb340e 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_OF_NET)	+= of_net.o
 obj-$(CONFIG_OF_SPI)	+= of_spi.o
 obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
 obj-$(CONFIG_OF_PCI)	+= of_pci.o
+obj-$(CONFIG_PCI)	+= of_pci_base.o
diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 9d179c4..ac1ec54 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -90,39 +90,3 @@ int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq)
 	return of_irq_map_raw(ppnode, &lspec_be, 1, laddr, out_irq);
 }
 EXPORT_SYMBOL_GPL(of_irq_map_pci);
-
-
-static inline int __of_pci_pci_compare(struct device_node *node, unsigned int devfn)
-{
-	unsigned int size;
-	const __be32 *reg = of_get_property(node, "reg", &size);
-
-	if (!reg || size < 5 * sizeof(__be32))
-		return 0;
-	return ((be32_to_cpup(&reg[0]) >> 8) & 0xff) == devfn;
-}
-
-struct device_node *of_pci_find_child_device(struct device_node *parent,
-					     unsigned int devfn)
-{
-	struct device_node *node, *node2;
-	
-	for_each_child_of_node(parent, node) {
-		if (__of_pci_pci_compare(node, devfn))
-			return node;
-		/*
-		 * Some OFs create a parent node "multifunc-device" as
-		 * a fake root for all functions of a multi-function
-		 * device we go down them as well.
-		 */
-                if (!strcmp(node->name, "multifunc-device")) {
-			for_each_child_of_node(node, node2) {
-				if (__of_pci_pci_compare(node2, devfn)) {
-					of_node_put(node);
-					return node2;
-				}
-			}
-                }
-	}
-	return NULL;
-}
diff --git a/drivers/of/of_pci_base.c b/drivers/of/of_pci_base.c
new file mode 100644
index 0000000..c5a2d96
--- /dev/null
+++ b/drivers/of/of_pci_base.c
@@ -0,0 +1,39 @@
+#include <linux/kernel.h>
+#include <linux/of_pci.h>
+#include <linux/of_irq.h>
+#include <asm/prom.h>
+
+static inline int __of_pci_pci_compare(struct device_node *node, unsigned int devfn)
+{
+	unsigned int size;
+	const __be32 *reg = of_get_property(node, "reg", &size);
+
+	if (!reg || size < 5 * sizeof(__be32))
+		return 0;
+	return ((be32_to_cpup(&reg[0]) >> 8) & 0xff) == devfn;
+}
+
+struct device_node *of_pci_find_child_device(struct device_node *parent,
+					     unsigned int devfn)
+{
+	struct device_node *node, *node2;
+	
+	for_each_child_of_node(parent, node) {
+		if (__of_pci_pci_compare(node, devfn))
+			return node;
+		/*
+		 * Some OFs create a parent node "multifunc-device" as
+		 * a fake root for all functions of a multi-function
+		 * device we go down them as well.
+		 */
+                if (!strcmp(node->name, "multifunc-device")) {
+			for_each_child_of_node(node, node2) {
+				if (__of_pci_pci_compare(node2, devfn)) {
+					of_node_put(node);
+					return node2;
+				}
+			}
+                }
+	}
+	return NULL;
+}
-- 
1.7.4.3

