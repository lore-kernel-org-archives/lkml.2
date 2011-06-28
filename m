Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab1F1W6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:58:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63424 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1F1W6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:58:12 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, nico@fluxnic.net,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 1/4] microblaze: move pci flag functions into asm-generic
Date: Tue, 28 Jun 2011 17:57:36 -0500
Message-Id: <1309301859-17651-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309301859-17651-1-git-send-email-robherring2@gmail.com>
References: <1309301859-17651-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Move pci_set_flags, pci_add_flags, and pci_has_flag into
asm-generic/pci-bridge.h so other archs can use them.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 arch/microblaze/include/asm/pci-bridge.h |   36 +-----------------
 include/asm-generic/pci-bridge.h         |   62 ++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 35 deletions(-)
 create mode 100644 include/asm-generic/pci-bridge.h

diff --git a/arch/microblaze/include/asm/pci-bridge.h b/arch/microblaze/include/asm/pci-bridge.h
index 746df91..ad1480f 100644
--- a/arch/microblaze/include/asm/pci-bridge.h
+++ b/arch/microblaze/include/asm/pci-bridge.h
@@ -10,6 +10,7 @@
 #include <linux/pci.h>
 #include <linux/list.h>
 #include <linux/ioport.h>
+#include <asm-generic/pci-bridge.h>
 
 struct device_node;
 
@@ -164,40 +165,5 @@ extern struct pci_controller *pcibios_alloc_controller(struct device_node *dev);
 extern void pcibios_free_controller(struct pci_controller *phb);
 extern void pcibios_setup_phb_resources(struct pci_controller *hose);
 
-#ifdef CONFIG_PCI
-extern unsigned int pci_flags;
-
-static inline void pci_set_flags(int flags)
-{
-	pci_flags = flags;
-}
-
-static inline void pci_add_flags(int flags)
-{
-	pci_flags |= flags;
-}
-
-static inline int pci_has_flag(int flag)
-{
-	return pci_flags & flag;
-}
-
-extern struct list_head hose_list;
-
-extern int pcibios_vaddr_is_ioport(void __iomem *address);
-#else
-static inline int pcibios_vaddr_is_ioport(void __iomem *address)
-{
-	return 0;
-}
-
-static inline void pci_set_flags(int flags) { }
-static inline void pci_add_flags(int flags) { }
-static inline int pci_has_flag(int flag)
-{
-	return 0;
-}
-#endif	/* CONFIG_PCI */
-
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_MICROBLAZE_PCI_BRIDGE_H */
diff --git a/include/asm-generic/pci-bridge.h b/include/asm-generic/pci-bridge.h
new file mode 100644
index 0000000..4a5aca2
--- /dev/null
+++ b/include/asm-generic/pci-bridge.h
@@ -0,0 +1,62 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _ASM_GENERIC_PCI_BRIDGE_H
+#define _ASM_GENERIC_PCI_BRIDGE_H
+
+#ifdef __KERNEL__
+
+enum {
+	/* Force re-assigning all resources (ignore firmware
+	 * setup completely)
+	 */
+	PCI_REASSIGN_ALL_RSRC	= 0x00000001,
+
+	/* Re-assign all bus numbers */
+	PCI_REASSIGN_ALL_BUS	= 0x00000002,
+
+	/* Do not try to assign, just use existing setup */
+	PCI_PROBE_ONLY		= 0x00000004,
+
+	/* Don't bother with ISA alignment unless the bridge has
+	 * ISA forwarding enabled
+	 */
+	PCI_CAN_SKIP_ISA_ALIGN	= 0x00000008,
+
+	/* Enable domain numbers in /proc */
+	PCI_ENABLE_PROC_DOMAINS	= 0x00000010,
+	/* ... except for domain 0 */
+	PCI_COMPAT_DOMAIN_0	= 0x00000020,
+};
+
+#ifdef CONFIG_PCI
+extern unsigned int pci_flags;
+
+static inline void pci_set_flags(int flags)
+{
+	pci_flags = flags;
+}
+
+static inline void pci_add_flags(int flags)
+{
+	pci_flags |= flags;
+}
+
+static inline int pci_has_flag(int flag)
+{
+	return pci_flags & flag;
+}
+#else
+static inline void pci_set_flags(int flags) { }
+static inline void pci_add_flags(int flags) { }
+static inline int pci_has_flag(int flag)
+{
+	return 0;
+}
+#endif	/* CONFIG_PCI */
+
+#endif	/* __KERNEL__ */
+#endif	/* _ASM_GENERIC_PCI_BRIDGE_H */
-- 
1.7.4.1

