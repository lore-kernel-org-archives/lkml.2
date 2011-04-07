Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab1DGD10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 23:27:26 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:43795 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab1DGD0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 23:26:53 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-pci@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, bheglaas@google.com, monstr@monstr.eu,
        tglx@linuxtronix.de, bigeasy@linuxtronix.de,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 5/5] pci/of: Consolidate pci_device_to_OF_node()
Date: Thu,  7 Apr 2011 13:26:36 +1000
Message-Id: <1302146796-26825-6-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
References: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All archs do more or less the same thing now, move it into
a single generic place.

I chose pci.h rather than of_pci.h to avoid having to change
all call-sites to include the later.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/microblaze/include/asm/pci-bridge.h |    5 -----
 arch/powerpc/include/asm/pci-bridge.h    |    5 -----
 arch/sparc/include/asm/pci_32.h          |    3 ---
 arch/sparc/include/asm/pci_64.h          |    3 ---
 arch/sparc/kernel/pci.c                  |    6 ------
 arch/sparc/kernel/pcic.c                 |    8 --------
 arch/x86/include/asm/prom.h              |    5 -----
 include/linux/pci.h                      |    5 +++++
 8 files changed, 5 insertions(+), 35 deletions(-)

diff --git a/arch/microblaze/include/asm/pci-bridge.h b/arch/microblaze/include/asm/pci-bridge.h
index da1e287..eefc152 100644
--- a/arch/microblaze/include/asm/pci-bridge.h
+++ b/arch/microblaze/include/asm/pci-bridge.h
@@ -102,11 +102,6 @@ struct pci_controller {
 };
 
 #ifdef CONFIG_PCI
-static inline struct device_node *pci_device_to_OF_node(struct pci_dev *dev)
-{
-	return dev->dev.of_node;
-}
-
 static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
 {
 	return bus->dev.of_node;
diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
index 6912c45..381f1ad 100644
--- a/arch/powerpc/include/asm/pci-bridge.h
+++ b/arch/powerpc/include/asm/pci-bridge.h
@@ -169,11 +169,6 @@ static inline struct pci_controller *pci_bus_to_host(const struct pci_bus *bus)
 	return bus->sysdata;
 }
 
-static inline struct device_node *pci_device_to_OF_node(struct pci_dev *dev)
-{
-	return dev->dev.of_node;
-}
-
 static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
 {
 	return bus->dev.of_node;
diff --git a/arch/sparc/include/asm/pci_32.h b/arch/sparc/include/asm/pci_32.h
index 332ac9a..4d0c39a 100644
--- a/arch/sparc/include/asm/pci_32.h
+++ b/arch/sparc/include/asm/pci_32.h
@@ -42,9 +42,6 @@ static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 }
 #endif
 
-struct device_node;
-extern struct device_node *pci_device_to_OF_node(struct pci_dev *pdev);
-
 #endif /* __KERNEL__ */
 
 /* generic pci stuff */
diff --git a/arch/sparc/include/asm/pci_64.h b/arch/sparc/include/asm/pci_64.h
index 948b686..2614d96 100644
--- a/arch/sparc/include/asm/pci_64.h
+++ b/arch/sparc/include/asm/pci_64.h
@@ -91,9 +91,6 @@ static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 	return PCI_IRQ_NONE;
 }
 
-struct device_node;
-extern struct device_node *pci_device_to_OF_node(struct pci_dev *pdev);
-
 #define HAVE_ARCH_PCI_RESOURCE_TO_USER
 extern void pci_resource_to_user(const struct pci_dev *dev, int bar,
 				 const struct resource *rsrc,
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index e539d23..80a87e2 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -1021,12 +1021,6 @@ void arch_teardown_msi_irq(unsigned int irq)
 }
 #endif /* !(CONFIG_PCI_MSI) */
 
-struct device_node *pci_device_to_OF_node(struct pci_dev *pdev)
-{
-	return pdev->dev.of_node;
-}
-EXPORT_SYMBOL(pci_device_to_OF_node);
-
 static void ali_sound_dma_hack(struct pci_dev *pdev, int set_bit)
 {
 	struct pci_dev *ali_isa_bridge;
diff --git a/arch/sparc/kernel/pcic.c b/arch/sparc/kernel/pcic.c
index 2cdc131..7558b6e 100644
--- a/arch/sparc/kernel/pcic.c
+++ b/arch/sparc/kernel/pcic.c
@@ -856,14 +856,6 @@ int pcibios_assign_resource(struct pci_dev *pdev, int resource)
 	return -ENXIO;
 }
 
-struct device_node *pci_device_to_OF_node(struct pci_dev *pdev)
-{
-	struct pcidev_cookie *pc = pdev->sysdata;
-
-	return pc->prom_node;
-}
-EXPORT_SYMBOL(pci_device_to_OF_node);
-
 /*
  * This probably belongs here rather than ioport.c because
  * we do not want this crud linked into SBus kernels.
diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index 971e0b4..dd6066a 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -31,11 +31,6 @@ extern void x86_add_irq_domains(void);
 void __cpuinit x86_of_pci_init(void);
 void x86_dtb_init(void);
 
-static inline struct device_node *pci_device_to_OF_node(struct pci_dev *pdev)
-{
-	return pdev ? pdev->dev.of_node : NULL;
-}
-
 static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
 {
 	return pci_device_to_OF_node(bus->self);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a1f90f0..44809d3 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1554,6 +1554,11 @@ extern void pci_release_bus_of_node(struct pci_bus *bus);
 /* Arch may override this (weak) */
 extern struct device_node * __weak pcibios_get_phb_of_node(struct pci_bus *bus);
 
+static inline struct device_node *pci_device_to_OF_node(struct pci_dev *pdev)
+{
+	return pdev ? pdev->dev.of_node : NULL;
+}
+
 #else /* CONFIG_OF */
 static inline void pci_set_of_node(struct pci_dev *dev) { }
 static inline void pci_release_of_node(struct pci_dev *dev) { }
-- 
1.7.1

