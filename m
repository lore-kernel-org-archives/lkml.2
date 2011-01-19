Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1ASTBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 14:01:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52740 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab1ASTBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 14:01:49 -0500
Date: Wed, 19 Jan 2011 20:01:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110119190133.GA13222@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      Revert "x86: Make relocatable kernel work with new binutils"

Jan Beulich (1):
      x86: Unify "numa=" command line option handling


 arch/x86/include/asm/numa_32.h |    2 ++
 arch/x86/include/asm/numa_64.h |    1 +
 arch/x86/kernel/vmlinux.lds.S  |   11 ++---------
 arch/x86/mm/numa.c             |   22 ++++++++++++++++++++++
 arch/x86/mm/numa_64.c          |   24 +++++-------------------
 arch/x86/mm/srat_32.c          |    1 -
 6 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/numa_32.h b/arch/x86/include/asm/numa_32.h
index a372290..b0ef2b4 100644
--- a/arch/x86/include/asm/numa_32.h
+++ b/arch/x86/include/asm/numa_32.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_NUMA_32_H
 #define _ASM_X86_NUMA_32_H
 
+extern int numa_off;
+
 extern int pxm_to_nid(int pxm);
 extern void numa_remove_cpu(int cpu);
 
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 5ae8728..0493be3 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -40,6 +40,7 @@ extern void __cpuinit numa_remove_cpu(int cpu);
 #ifdef CONFIG_NUMA_EMU
 #define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
 #define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
+void numa_emu_cmdline(char *);
 #endif /* CONFIG_NUMA_EMU */
 #else
 static inline void init_cpu_to_node(void)		{ }
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index b34ab80..bf47007 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -34,9 +34,11 @@ OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)
 #ifdef CONFIG_X86_32
 OUTPUT_ARCH(i386)
 ENTRY(phys_startup_32)
+jiffies = jiffies_64;
 #else
 OUTPUT_ARCH(i386:x86-64)
 ENTRY(phys_startup_64)
+jiffies_64 = jiffies;
 #endif
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
@@ -140,15 +142,6 @@ SECTIONS
 		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 
 		DATA_DATA
-		/*
-		 * Workaround a binutils (2.20.51.0.12 to 2.21.51.0.3) bug.
-		 * This makes jiffies relocatable in such binutils
-		 */
-#ifdef CONFIG_X86_32
-		jiffies = jiffies_64;
-#else
-		jiffies_64 = jiffies;
-#endif
 		CONSTRUCTORS
 
 		/* rarely changed data like cpu maps */
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 787c52c..ebf6d78 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
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
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 1e72102..95ea155 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -30,7 +30,6 @@ s16 apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
 
-int numa_off __initdata;
 static unsigned long __initdata nodemap_addr;
 static unsigned long __initdata nodemap_size;
 
@@ -263,6 +262,11 @@ static struct bootnode nodes[MAX_NUMNODES] __initdata;
 static struct bootnode physnodes[MAX_NUMNODES] __cpuinitdata;
 static char *cmdline __initdata;
 
+void __init numa_emu_cmdline(char *str)
+{
+	cmdline = str;
+}
+
 static int __init setup_physnodes(unsigned long start, unsigned long end,
 					int acpi, int amd)
 {
@@ -670,24 +674,6 @@ unsigned long __init numa_free_all_bootmem(void)
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
diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index f164345..ae96e7b 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -59,7 +59,6 @@ static struct node_memory_chunk_s __initdata node_memory_chunk[MAXCHUNKS];
 static int __initdata num_memory_chunks; /* total number of memory chunks */
 static u8 __initdata apicid_to_pxm[MAX_APICID];
 
-int numa_off __initdata;
 int acpi_numa __initdata;
 
 static __init void bad_srat(void)
