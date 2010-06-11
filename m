Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884Ab0FKSZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 14:25:48 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:4960 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab0FKSZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 14:25:47 -0400
Subject: [PATCH] Alternate fix for ia64 tiger_defconfig build breakage
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Tony Luck <tony.luck@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinSRHyxGFKRnIlfUGbnLqIpZWLtq7ipYFH25wGW@mail.gmail.com>
References: <20100528105719.a356ba4f.sfr@canb.auug.org.au>
	 <alpine.LFD.2.00.1005271807470.11382@i5.linux-foundation.org>
	 <20100530104303.15864d35.sfr@canb.auug.org.au>
	 <AANLkTinSRHyxGFKRnIlfUGbnLqIpZWLtq7ipYFH25wGW@mail.gmail.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Fri, 11 Jun 2010 14:25:44 -0400
Message-Id: <1276280744.5581.13.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Offered as an alternative to Tony's in-line #ifdefs to address the ia64
non-numa build breakage.  

Lee
-----------------------------------

Define stubs for the numa_*_id() generic percpu related functions
for non-NUMA configurations in <asm-generic/topology.h> where the
other non-numa stubs live.

Fixes ia64 !NUMA build breakage -- e.g., tiger_defconfig

Back out now unneeded '#ifndef CONFIG_NUMA' guards from ia64
smpboot.c

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

 arch/ia64/Kconfig              |    3 +--
 arch/ia64/kernel/smpboot.c     |    4 ----
 include/asm-generic/topology.h |   20 +++++++++++++++++++-
 include/linux/topology.h       |    4 ----
 4 files changed, 20 insertions(+), 11 deletions(-)

Index: linux-2.6.35-rc2/include/asm-generic/topology.h
===================================================================
--- linux-2.6.35-rc2.orig/include/asm-generic/topology.h
+++ linux-2.6.35-rc2/include/asm-generic/topology.h
@@ -5,7 +5,7 @@
  *
  * Copyright (C) 2002, IBM Corp.
  *
- * All rights reserved.          
+ * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -34,9 +34,16 @@
 #ifndef cpu_to_node
 #define cpu_to_node(cpu)	((void)(cpu),0)
 #endif
+#ifndef set_numa_node
+#define set_numa_node(node)
+#endif
+#ifndef set_cpu_numa_node
+#define set_cpu_numa_node(cpu, node)
+#endif
 #ifndef cpu_to_mem
 #define cpu_to_mem(cpu)		((void)(cpu),0)
 #endif
+
 #ifndef parent_node
 #define parent_node(node)	((void)(node),0)
 #endif
@@ -55,4 +62,15 @@
 
 #endif	/* CONFIG_NUMA */
 
+#if !defined(CONFIG_NUMA) || !defined(CONFIG_HAVE_MEMORYLESS_NODES)
+
+#ifndef set_numa_mem
+#define set_numa_mem(node)
+#endif
+#ifndef set_cpu_numa_mem
+#define set_cpu_numa_mem(cpu, node)
+#endif
+
+#endif	/* !CONFIG_NUMA || !CONFIG_HAVE_MEMORYLESS_NODES */
+
 #endif /* _ASM_GENERIC_TOPOLOGY_H */
Index: linux-2.6.35-rc2/arch/ia64/Kconfig
===================================================================
--- linux-2.6.35-rc2.orig/arch/ia64/Kconfig
+++ linux-2.6.35-rc2/arch/ia64/Kconfig
@@ -503,8 +503,7 @@ config USE_PERCPU_NUMA_NODE_ID
 	depends on NUMA
 
 config HAVE_MEMORYLESS_NODES
-	def_bool y
-	depends on NUMA
+	def_bool NUMA
 
 config ARCH_PROC_KCORE_TEXT
 	def_bool y
Index: linux-2.6.35-rc2/include/linux/topology.h
===================================================================
--- linux-2.6.35-rc2.orig/include/linux/topology.h
+++ linux-2.6.35-rc2/include/linux/topology.h
@@ -291,10 +291,6 @@ static inline void set_cpu_numa_mem(int
 
 #else	/* !CONFIG_HAVE_MEMORYLESS_NODES */
 
-static inline void set_numa_mem(int node) {}
-
-static inline void set_cpu_numa_mem(int cpu, int node) {}
-
 #ifndef numa_mem_id
 /* Returns the number of the nearest Node with memory */
 static inline int numa_mem_id(void)
Index: linux-2.6.35-rc2/arch/ia64/kernel/smpboot.c
===================================================================
--- linux-2.6.35-rc2.orig/arch/ia64/kernel/smpboot.c
+++ linux-2.6.35-rc2/arch/ia64/kernel/smpboot.c
@@ -390,13 +390,11 @@ smp_callin (void)
 
 	fix_b0_for_bsp();
 
-#ifdef CONFIG_NUMA
 	/*
 	 * numa_node_id() works after this.
 	 */
 	set_numa_node(cpu_to_node_map[cpuid]);
 	set_numa_mem(local_memory_node(cpu_to_node_map[cpuid]));
-#endif
 
 	ipi_call_lock_irq();
 	spin_lock(&vector_lock);
@@ -640,9 +638,7 @@ void __devinit smp_prepare_boot_cpu(void
 {
 	cpu_set(smp_processor_id(), cpu_online_map);
 	cpu_set(smp_processor_id(), cpu_callin_map);
-#ifdef CONFIG_NUMA
 	set_numa_node(cpu_to_node_map[smp_processor_id()]);
-#endif
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 	paravirt_post_smp_prepare_boot_cpu();
 }


