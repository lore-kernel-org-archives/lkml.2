Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0GXPnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 11:43:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49521 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab0GXPne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 11:43:34 -0400
Subject: [PATCH] of: Provide default of_node_to_nid() when CONFIG_NUMA is not
	set
To: sfr@canb.auug.org.au, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 24 Jul 2010 09:43:31 -0600
Message-ID: <20100724154331.22701.3409.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_node_to_nid() is only relevant for NUMA.  Don't force architectures to
implement it if CONFIG_NUMA is not set.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/microblaze/include/asm/topology.h |   10 ----------
 arch/powerpc/include/asm/topology.h    |    7 -------
 arch/sparc/include/asm/prom.h          |    5 -----
 include/linux/of.h                     |    8 ++++++++
 4 files changed, 8 insertions(+), 22 deletions(-)

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
index c82a7da..b47d2a7 100644
--- a/arch/sparc/include/asm/prom.h
+++ b/arch/sparc/include/asm/prom.h
@@ -41,11 +41,6 @@ extern int of_getintprop_default(struct device_node *np,
 				 const char *name,
 				 int def);
 extern int of_find_in_proplist(const char *list, const char *match, int len);
-#ifdef CONFIG_NUMA
-extern int of_node_to_nid(struct device_node *dp);
-#else
-#define of_node_to_nid(dp)	(-1)
-#endif
 
 extern void prom_build_devicetree(void);
 extern void of_populate_present_mask(void);
diff --git a/include/linux/of.h b/include/linux/of.h
index b0756f3..ec25482 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -205,6 +205,14 @@ extern int of_parse_phandles_with_args(struct device_node *np,
 
 extern int of_machine_is_compatible(const char *compat);
 
+#if defined(CONFIG_NUMA)
+extern int of_node_to_nid(struct device_node *device);
+#elif defined(CONFIG_SPARC)
+static inline int of_node_to_nid(struct device_node *device) { return -1; }
+#else
+static inline int of_node_to_nid(struct device_node *device) { return 0; }
+#endif
+
 extern int prom_add_property(struct device_node* np, struct property* prop);
 extern int prom_remove_property(struct device_node *np, struct property *prop);
 extern int prom_update_property(struct device_node *np,

