Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1AFRCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 12:02:43 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:51996 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab1AFRCm convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Thu, 6 Jan 2011 12:02:42 -0500
Message-Id: <4D2603BF020000780002ACA7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 06 Jan 2011 17:02:39 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: unify "numa=" command line option handling
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to be able to suppress the use of SRAT tables that 32-bit
Linux can't deal with (possibly leading to a non-bootable system,
without disabling ACPI altogether), move the "numa=" option handling
to common code.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/numa_32.h |    2 ++
 arch/x86/include/asm/numa_64.h |    1 +
 arch/x86/mm/numa.c             |   22 ++++++++++++++++++++++
 arch/x86/mm/numa_64.c          |   24 +++++-------------------
 arch/x86/mm/srat_32.c          |    1 -
 5 files changed, 30 insertions(+), 20 deletions(-)

--- 2.6.37/arch/x86/include/asm/numa_32.h
+++ 2.6.37-x86-numa-option/arch/x86/include/asm/numa_32.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_NUMA_32_H
 #define _ASM_X86_NUMA_32_H
 
+extern int numa_off;
+
 extern int pxm_to_nid(int pxm);
 extern void numa_remove_cpu(int cpu);
 
--- 2.6.37/arch/x86/include/asm/numa_64.h
+++ 2.6.37-x86-numa-option/arch/x86/include/asm/numa_64.h
@@ -40,6 +40,7 @@ extern void __cpuinit numa_remove_cpu(in
 #ifdef CONFIG_NUMA_EMU
 #define FAKE_NODE_MIN_SIZE	((u64)64 << 20)
 #define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
+void numa_emu_cmdline(char *);
 #endif /* CONFIG_NUMA_EMU */
 #else
 static inline void init_cpu_to_node(void)		{ }
--- 2.6.37/arch/x86/mm/numa.c
+++ 2.6.37-x86-numa-option/arch/x86/mm/numa.c
@@ -2,6 +2,28 @@
 #include <linux/topology.h>
 #include <linux/module.h>
 #include <linux/bootmem.h>
+#include <asm/numa.h>
+#include <asm/acpi.h>
+
+int __initdata numa_off;
+
+static __init int numa_setup(char *opt)
+{
+	if (!opt)
+		return -EINVAL;
+	if (!strncmp(opt, "off", 3))
+		numa_off = 1;
+#ifdef CONFIG_NUMA_EMU
+	if (!strncmp(opt, "fake=", 5))
+		numa_emu_cmdline(opt + 5);
+#endif
+#ifdef CONFIG_ACPI_NUMA
+	if (!strncmp(opt, "noacpi", 6))
+		acpi_numa = -1;
+#endif
+	return 0;
+}
+early_param("numa", numa_setup);
 
 /*
  * Which logical CPUs are on which nodes
--- 2.6.37/arch/x86/mm/numa_64.c
+++ 2.6.37-x86-numa-option/arch/x86/mm/numa_64.c
@@ -30,7 +30,6 @@ s16 apicid_to_node[MAX_LOCAL_APIC] __cpu
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
 
-int numa_off __initdata;
 static unsigned long __initdata nodemap_addr;
 static unsigned long __initdata nodemap_size;
 
@@ -263,6 +262,11 @@ static struct bootnode nodes[MAX_NUMNODE
 static struct bootnode physnodes[MAX_NUMNODES] __initdata;
 static char *cmdline __initdata;
 
+void __init numa_emu_cmdline(char *str)
+{
+	cmdline = str;
+}
+
 static int __init setup_physnodes(unsigned long start, unsigned long end,
 					int acpi, int k8)
 {
@@ -661,24 +665,6 @@ unsigned long __init numa_free_all_bootm
 	return pages;
 }
 
-static __init int numa_setup(char *opt)
-{
-	if (!opt)
-		return -EINVAL;
-	if (!strncmp(opt, "off", 3))
-		numa_off = 1;
-#ifdef CONFIG_NUMA_EMU
-	if (!strncmp(opt, "fake=", 5))
-		cmdline = opt + 5;
-#endif
-#ifdef CONFIG_ACPI_NUMA
-	if (!strncmp(opt, "noacpi", 6))
-		acpi_numa = -1;
-#endif
-	return 0;
-}
-early_param("numa", numa_setup);
-
 #ifdef CONFIG_NUMA
 
 static __init int find_near_online_node(int node)
--- 2.6.37/arch/x86/mm/srat_32.c
+++ 2.6.37-x86-numa-option/arch/x86/mm/srat_32.c
@@ -59,7 +59,6 @@ static struct node_memory_chunk_s __init
 static int __initdata num_memory_chunks; /* total number of memory chunks */
 static u8 __initdata apicid_to_pxm[MAX_APICID];
 
-int numa_off __initdata;
 int acpi_numa __initdata;
 
 static __init void bad_srat(void)



