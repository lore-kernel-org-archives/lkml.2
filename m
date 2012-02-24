Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab2BXQyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:54:21 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49062 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab2BXQyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:54:19 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.68.239.229 as permitted sender) smtp.mail=glikely@secretlab.ca
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonas Bonn <jonas@southpole.se>, sparclinux@vger.kernel.org,
        linux@openrisc.net
Subject: [PATCH 1/2] irq_domain: Centralize definition of irq_dispose_mapping()
Date: Fri, 24 Feb 2012 09:54:07 -0700
Message-Id: <1330102448-19172-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several architectures define their own empty irq_dispose_mapping().  Since
the irq_domain code is centralized now, there is little need to do so.  This
patch removes them and creates a new empty copy when !CONFIG_IRQ_DOMAIN is
selected.

The patch also means that IRQ_DOMAIN becomes selectable on all architectures.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: sparclinux@vger.kernel.org
Cc: linux@lists.openrisc.net
---
 arch/openrisc/include/asm/prom.h |   10 +---------
 arch/sparc/include/asm/prom.h    |   10 +---------
 include/linux/irqdomain.h        |    5 ++++-
 include/linux/of_irq.h           |    4 +---
 4 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/arch/openrisc/include/asm/prom.h b/arch/openrisc/include/asm/prom.h
index e1f3fe2..bbb34e5 100644
--- a/arch/openrisc/include/asm/prom.h
+++ b/arch/openrisc/include/asm/prom.h
@@ -24,6 +24,7 @@
 
 #include <linux/types.h>
 #include <asm/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/atomic.h>
 #include <linux/of_irq.h>
 #include <linux/of_fdt.h>
@@ -63,15 +64,6 @@ extern const void *of_get_mac_address(struct device_node *np);
 struct pci_dev;
 extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
 
-/* This routine is here to provide compatibility with how powerpc
- * handles IRQ mapping for OF device nodes.  We precompute and permanently
- * register them in the platform_device objects, whereas powerpc computes them
- * on request.
- */
-static inline void irq_dispose_mapping(unsigned int virq)
-{
-}
-
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
 #endif /* _ASM_OPENRISC_PROM_H */
diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
index edd3d3cde..c287651 100644
--- a/arch/sparc/include/asm/prom.h
+++ b/arch/sparc/include/asm/prom.h
@@ -22,6 +22,7 @@
 #include <linux/proc_fs.h>
 #include <linux/mutex.h>
 #include <linux/atomic.h>
+#include <linux/irqdomain.h>
 
 #define OF_ROOT_NODE_ADDR_CELLS_DEFAULT	2
 #define OF_ROOT_NODE_SIZE_CELLS_DEFAULT	1
@@ -55,15 +56,6 @@ struct resource;
 extern void __iomem *of_ioremap(struct resource *res, unsigned long offset, unsigned long size, char *name);
 extern void of_iounmap(struct resource *res, void __iomem *base, unsigned long size);
 
-/* These routines are here to provide compatibility with how powerpc
- * handles IRQ mapping for OF device nodes.  We precompute and permanently
- * register them in the platform_device objects, whereas powerpc computes them
- * on request.
- */
-static inline void irq_dispose_mapping(unsigned int virq)
-{
-}
-
 extern struct device_node *of_console_device;
 extern char *of_console_path;
 extern char *of_console_options;
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 5245488..ead4a42 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -182,6 +182,9 @@ extern void irq_domain_generate_simple(const struct of_device_id *match,
 static inline void irq_domain_generate_simple(const struct of_device_id *match,
 					u64 phys_base, unsigned int irq_start) { }
 #endif /* !CONFIG_OF_IRQ */
-#endif /* CONFIG_IRQ_DOMAIN */
+
+#else /* CONFIG_IRQ_DOMAIN */
+static inline void irq_dispose_mapping(unsigned int virq) { }
+#endif /* !CONFIG_IRQ_DOMAIN */
 
 #endif /* _LINUX_IRQDOMAIN_H */
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index d0307ee..d229ad3 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -6,6 +6,7 @@ struct of_irq;
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/ioport.h>
 #include <linux/of.h>
 
@@ -65,9 +66,6 @@ extern int of_irq_map_one(struct device_node *device, int index,
 extern unsigned int irq_create_of_mapping(struct device_node *controller,
 					  const u32 *intspec,
 					  unsigned int intsize);
-#ifdef CONFIG_IRQ_DOMAIN
-extern void irq_dispose_mapping(unsigned int irq);
-#endif
 extern int of_irq_to_resource(struct device_node *dev, int index,
 			      struct resource *r);
 extern int of_irq_count(struct device_node *dev);
-- 
1.7.9

