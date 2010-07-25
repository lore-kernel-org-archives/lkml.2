Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab0GYVOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 17:14:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47032 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab0GYVOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 17:14:16 -0400
Date: Sun, 25 Jul 2010 15:14:12 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>
Cc: monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] of: Provide default of_node_to_nid() when CONFIG_NUMA
 is not set
Message-ID: <20100725211412.GA19435@angua.secretlab.ca>
References: <20100724154331.22701.3409.stgit@angua>
 <20100725130723.a5192793.sfr@canb.auug.org.au>
 <AANLkTinE4X0iAJAiatc7Qtj2QP6dhyBKo9fqxqUt40Y6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinE4X0iAJAiatc7Qtj2QP6dhyBKo9fqxqUt40Y6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing Arnd]

On Sun, Jul 25, 2010 at 02:37:38PM -0600, Grant Likely wrote:
> On Sat, Jul 24, 2010 at 9:07 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Grant,
> >
> > On Sat, 24 Jul 2010 09:43:31 -0600 Grant Likely <grant.likely@secretlab.ca> wrote:
> >>
> >> of_node_to_nid() is only relevant for NUMA.  Don't force architectures to
> >> implement it if CONFIG_NUMA is not set.
> >
> > Why not just do:
> >
> > #ifndef of_node_to_nid
> > static inline int of_node_to_nid(struct device_node *device) { return 0; }
> > #define of_node_to_nid  of_node_to_nid
> > #endif
> >
> > in include/linux/of.h
> >
> > and then add:
> >
> > #define of_node_to_nid  of_node_to_nid
> >
> > Where it is declared/defined for each arch ...
> > (it would be nice if all the archs were consistent in where it was
> > declared).
> 
> Two reasons; I had started doing that in topology.h, but it caused a
> bunch of collateral damage with files missing the include, so I punted
> and took the easy way out.  Also, I didn't know if that was an
> acceptable or safe pattern for override symbols.
> 
> I'll spin it again with this pattern and see what it looks.
> 
> g.

Should I use asm-generic for this and other similar symbols?  How does the following look?

---

>From 1ac16ad91d4752b49ff0644854dd2cbe593bbfa8 Mon Sep 17 00:00:00 2001
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 23 Jul 2010 20:11:18 -0600
Subject: [PATCH] of: Create asm-generic/of.h and provide default of_node_to_nid()

of_node_to_nid() is only relevant in a few architectures.  Don't force
everyone to implement it anyway.  This patch also adds asm-generic/of.h
which will be used to contain other overrideable symbols.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/microblaze/include/asm/prom.h     |    3 +++
 arch/microblaze/include/asm/topology.h |   10 ----------
 arch/powerpc/include/asm/prom.h        |    6 ++++++
 arch/powerpc/include/asm/topology.h    |    7 -------
 arch/sparc/include/asm/prom.h          |    4 ++++
 include/asm-generic/of.h               |   19 +++++++++++++++++++
 6 files changed, 32 insertions(+), 17 deletions(-)
 create mode 100644 include/asm-generic/of.h

diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
index cb9c3dd..ff99d7d 100644
--- a/arch/microblaze/include/asm/prom.h
+++ b/arch/microblaze/include/asm/prom.h
@@ -103,4 +103,7 @@ extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
 
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
+
+#include <asm-generic/of.h>
+
 #endif /* _ASM_MICROBLAZE_PROM_H */
diff --git a/arch/microblaze/include/asm/topology.h b/arch/microblaze/include/asm/topology.h
index 96bcea5..5428f33 100644
--- a/arch/microblaze/include/asm/topology.h
+++ b/arch/microblaze/include/asm/topology.h
@@ -1,11 +1 @@
 #include <asm-generic/topology.h>
-
-#ifndef _ASM_MICROBLAZE_TOPOLOGY_H
-#define _ASM_MICROBLAZE_TOPOLOGY_H
-
-struct device_node;
-static inline int of_node_to_nid(struct device_node *device)
-{
-	return 0;
-}
-#endif /* _ASM_MICROBLAZE_TOPOLOGY_H */
diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index da7dd63..52457dc 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -103,6 +103,9 @@ struct device_node *of_find_next_cache_node(struct device_node *np);
 /* Get the MAC address */
 extern const void *of_get_mac_address(struct device_node *np);
 
+extern int of_node_to_nid(struct device_node *device);
+#define of_node_to_nid of_node_to_nid
+
 /**
  * of_irq_map_pci - Resolve the interrupt for a PCI device
  * @pdev:	the device whose interrupt is to be resolved
@@ -120,4 +123,7 @@ extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
 extern void of_instantiate_rtc(void);
 
 #endif /* __KERNEL__ */
+
+#include <asm-generic/of.h>
+
 #endif /* _POWERPC_PROM_H */
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index 32adf72..09dd38c 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -41,8 +41,6 @@ static inline int cpu_to_node(int cpu)
 			       cpu_all_mask :				\
 			       node_to_cpumask_map[node])
 
-int of_node_to_nid(struct device_node *device);
-
 struct pci_bus;
 #ifdef CONFIG_PCI
 extern int pcibus_to_node(struct pci_bus *bus);
@@ -94,11 +92,6 @@ extern void sysfs_remove_device_from_node(struct sys_device *dev, int nid);
 
 #else
 
-static inline int of_node_to_nid(struct device_node *device)
-{
-	return 0;
-}
-
 static inline void dump_numa_cpu_topology(void) {}
 
 static inline int sysfs_add_device_to_node(struct sys_device *dev, int nid)
diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
index c82a7da..09f0e07 100644
--- a/arch/sparc/include/asm/prom.h
+++ b/arch/sparc/include/asm/prom.h
@@ -43,6 +43,7 @@ extern int of_getintprop_default(struct device_node *np,
 extern int of_find_in_proplist(const char *list, const char *match, int len);
 #ifdef CONFIG_NUMA
 extern int of_node_to_nid(struct device_node *dp);
+#define of_node_to_nid of_node_to_nid
 #else
 #define of_node_to_nid(dp)	(-1)
 #endif
@@ -72,4 +73,7 @@ extern void (*prom_build_more)(struct device_node *dp, struct device_node ***nex
 extern char *build_full_name(struct device_node *dp);
 
 #endif /* __KERNEL__ */
+
+#include <asm-generic/of.h>
+
 #endif /* _SPARC_PROM_H */
diff --git a/include/asm-generic/of.h b/include/asm-generic/of.h
new file mode 100644
index 0000000..8d8d147
--- /dev/null
+++ b/include/asm-generic/of.h
@@ -0,0 +1,19 @@
+/*
+ * Generic OpenFirmware/Flattened Device Tree definitions
+ *
+ * Copyright (C) 2010, Secret Lab Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ */
+#ifndef __ASM_GENERIC_OF_H
+#define __ASM_GENERIC_OF_H
+
+#ifndef of_node_to_nid
+static inline int of_node_to_nid(struct device_node *np) { return 0; }
+#define of_node_to_nid of_node_to_nid
+#endif
+
+#endif /* __ASM_GENERIC_OF_H */
-- 
1.7.0.4

