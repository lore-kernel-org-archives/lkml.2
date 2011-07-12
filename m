Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab1GLNjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 09:39:03 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:48108 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab1GLNjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 09:39:00 -0400
Message-ID: <4E1C4E70.8030302@monstr.eu>
Date: Tue, 12 Jul 2011 15:38:56 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, Rob Herring <robherring2@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, nico@fluxnic.net
Subject: Re: [PATCH v2 0/6] ARM: make mach/hardware.h optional
References: <1309366019-24379-1-git-send-email-robherring2@gmail.com> <201107021124.46953.arnd@arndb.de> <4E1B176E.3030503@gmail.com> <201107121502.41570.arnd@arndb.de>
In-Reply-To: <201107121502.41570.arnd@arndb.de>
Content-Type: multipart/mixed;
 boundary="------------040100050403000405020907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040100050403000405020907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Arnd Bergmann wrote:
> On Monday 11 July 2011, Rob Herring wrote:
>>> This is very good work, I really like it. I've mentioned one idea for
>>> an improvement in patch 5, which you can still integrate, but otherwise
>>>
>>> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>>>
>>> for the whole series.
>>>
>> I have an updated version ready to send out. Will you take this in your
>> tree including the 1st patch for pci flags functions? Also, what about
>> the powerpc conversion to generic pci flags?
> 
> I can take it all in the arm-soc tree, yes. However for anything outside
> of arch/arm/{mach,plat}-*, please get an Ack from the respective maintainer
> (Russell, Michal, BenH, ...).

Definitely not ACK for [PATH 1/6] because it breaks Microblaze PCI compilation.
Rob removed some parts from microblaze pci-bridge.h and didn't move them to 
generic location or keep them in it. Also didn't remove PCI 
bits(PCI_REASSIGN..., etc) from microblaze header. I have attached changed patch 
with Microblaze part.

I would also prefer to add to this patch fixes for PPC too. Microblaze pci code 
comes from PPC that's why will be the best to fix PPC in the same patch.
There should be one more patch for ppc which rename ppc_pci_flags to pci_flags + 
functions and bits

 From my point of view make sense do these patches.
1. (s/ppc_pci_flags/pci_flags/g) + (s/ppc_pci_/pci_/g) + (s/PPC_PCI_/PCI_/g)
2. introduce new asm-generic/pci-bridge.h with changes for microblaze and ppc
3. all others patches

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian

--------------040100050403000405020907
Content-Type: text/x-patch;
 name="0001-microblaze-move-pci-flag-functions-into-asm-generic.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-microblaze-move-pci-flag-functions-into-asm-generic.pat";
 filename*1="ch"

>From df817b1016d418ed2abff0e1ec175c4e8cb30115 Mon Sep 17 00:00:00 2001
From: Rob Herring <rob.herring@calxeda.com>
Date: Wed, 29 Jun 2011 11:46:54 -0500
Subject: [PATCH] microblaze: move pci flag functions into asm-generic

Move pci_set_flags, pci_add_flags, and pci_has_flag into
asm-generic/pci-bridge.h so other archs can use them.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Michal Simek <monstr@monstr.eu>

---
v2: Fix microblaze compilation problems
---
 arch/microblaze/include/asm/pci-bridge.h |   67 ++++-------------------------
 include/asm-generic/pci-bridge.h         |   62 +++++++++++++++++++++++++++
 2 files changed, 72 insertions(+), 57 deletions(-)
 create mode 100644 include/asm-generic/pci-bridge.h

diff --git a/arch/microblaze/include/asm/pci-bridge.h b/arch/microblaze/include/asm/pci-bridge.h
index 746df91..4cae1d5 100644
--- a/arch/microblaze/include/asm/pci-bridge.h
+++ b/arch/microblaze/include/asm/pci-bridge.h
@@ -10,31 +10,19 @@
 #include <linux/pci.h>
 #include <linux/list.h>
 #include <linux/ioport.h>
+#include <asm-generic/pci-bridge.h>
 
 struct device_node;
 
-enum {
-	/* Force re-assigning all resources (ignore firmware
-	 * setup completely)
-	 */
-	PCI_REASSIGN_ALL_RSRC	= 0x00000001,
-
-	/* Re-assign all bus numbers */
-	PCI_REASSIGN_ALL_BUS	= 0x00000002,
-
-	/* Do not try to assign, just use existing setup */
-	PCI_PROBE_ONLY		= 0x00000004,
-
-	/* Don't bother with ISA alignment unless the bridge has
-	 * ISA forwarding enabled
-	 */
-	PCI_CAN_SKIP_ISA_ALIGN	= 0x00000008,
-
-	/* Enable domain numbers in /proc */
-	PCI_ENABLE_PROC_DOMAINS	= 0x00000010,
-	/* ... except for domain 0 */
-	PCI_COMPAT_DOMAIN_0		= 0x00000020,
-};
+#ifdef CONFIG_PCI
+extern struct list_head hose_list;
+extern int pcibios_vaddr_is_ioport(void __iomem *address);
+#else
+static inline int pcibios_vaddr_is_ioport(void __iomem *address)
+{
+	return 0;
+}
+#endif
 
 /*
  * Structure of a PCI controller (host bridge)
@@ -164,40 +152,5 @@ extern struct pci_controller *pcibios_alloc_controller(struct device_node *dev);
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
1.5.5.6


--------------040100050403000405020907--
