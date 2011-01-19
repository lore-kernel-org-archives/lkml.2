Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1ASJet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 04:34:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:36888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab1ASJer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 04:34:47 -0500
Date: Wed, 19 Jan 2011 09:34:21 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, JBeulich@novell.com, tj@kernel.org,
        tglx@linutronix.de, trenn@suse.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, tj@kernel.org,
        tglx@linutronix.de, trenn@suse.de, mingo@elte.hu
In-Reply-To: <4D36B581020000780002D0FF@vpn.id2.novell.com>
References: <4D36B581020000780002D0FF@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Unify "numa=" command line option handling
Message-ID: <tip-9032160275ba018003ff390835ff8ed2b5b788b8@git.kernel.org>
Git-Commit-ID: 9032160275ba018003ff390835ff8ed2b5b788b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 Jan 2011 09:34:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9032160275ba018003ff390835ff8ed2b5b788b8
Gitweb:     http://git.kernel.org/tip/9032160275ba018003ff390835ff8ed2b5b788b8
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Wed, 19 Jan 2011 08:57:21 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 Jan 2011 10:25:18 +0100

x86: Unify "numa=" command line option handling

In order to be able to suppress the use of SRAT tables that
32-bit Linux can't deal with (in one case known to lead to a
non-bootable system, unless disabling ACPI altogether), move the
"numa=" option handling to common code.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Reviewed-by: Thomas Renninger <trenn@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>
LKML-Reference: <4D36B581020000780002D0FF@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/numa_32.h |    2 ++
 arch/x86/include/asm/numa_64.h |    1 +
 arch/x86/mm/numa.c             |   22 ++++++++++++++++++++++
 arch/x86/mm/numa_64.c          |   24 +++++-------------------
 arch/x86/mm/srat_32.c          |    1 -
 5 files changed, 30 insertions(+), 20 deletions(-)

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
