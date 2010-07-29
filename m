Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab0G2TE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 15:04:28 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48722 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab0G2TE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 15:04:27 -0400
Subject: [PATCH] of: Provide default of_node_to_nid() implementation.
To: sfr@canb.auug.org.au, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 29 Jul 2010 13:04:23 -0600
Message-ID: <20100729190324.28739.1749.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_node_to_nid() is only relevant in a few architectures.  Don't force
everyone to implement it anyway.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

v3: make -1 the default return value and let powerpc override it to 0 when
CONFIG_NUMA not set.

 arch/microblaze/include/asm/topology.h |   10 ----------
 arch/powerpc/include/asm/prom.h        |    7 +++++++
 arch/powerpc/include/asm/topology.h    |    7 -------
 arch/sparc/include/asm/prom.h          |    3 +--
 include/linux/of.h                     |    5 +++++
 5 files changed, 13 insertions(+), 19 deletions(-)

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
index da7dd63..55bccc0 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -103,6 +103,13 @@ struct device_node *of_find_next_cache_node(struct device_node *np);
 /* Get the MAC address */
 extern const void *of_get_mac_address(struct device_node *np);
 
+#ifdef CONFIG_NUMA
+extern int of_node_to_nid(struct device_node *device);
+#else
+static inline int of_node_to_nid(struct device_node *device) { return 0; }
+#endif
+#define of_node_to_nid of_node_to_nid
+
 /**
  * of_irq_map_pci - Resolve the interrupt for a PCI device
  * @pdev:	the device whose interrupt is to be resolved
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
index c82a7da..291f125 100644
--- a/arch/sparc/include/asm/prom.h
+++ b/arch/sparc/include/asm/prom.h
@@ -43,8 +43,7 @@ extern int of_getintprop_default(struct device_node *np,
 extern int of_find_in_proplist(const char *list, const char *match, int len);
 #ifdef CONFIG_NUMA
 extern int of_node_to_nid(struct device_node *dp);
-#else
-#define of_node_to_nid(dp)	(-1)
+#define of_node_to_nid of_node_to_nid
 #endif
 
 extern void prom_build_devicetree(void);
diff --git a/include/linux/of.h b/include/linux/of.h
index b0756f3..cad7cf0 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -146,6 +146,11 @@ static inline unsigned long of_read_ulong(const __be32 *cell, int size)
 
 #define OF_BAD_ADDR	((u64)-1)
 
+#ifndef of_node_to_nid
+static inline int of_node_to_nid(struct device_node *np) { return -1; }
+#define of_node_to_nid of_node_to_nid
+#endif
+
 extern struct device_node *of_find_node_by_name(struct device_node *from,
 	const char *name);
 #define for_each_node_by_name(dn, name) \

