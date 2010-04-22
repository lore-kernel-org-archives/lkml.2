Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab0DVUjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:39:06 -0400
Received: from kroah.org ([198.145.64.141]:37423 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201Ab0DVT2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:05 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:11 2010
Message-Id: <20100422190911.735233389@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [049/197] x86, amd: Get multi-node CPU info from NodeId MSR instead of PCI config space
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andreas Herrmann <herrmann.der.user@googlemail.com>

commit 9d260ebc09a0ad6b5c73e17676df42c7bc75ff64 upstream.

Use NodeId MSR to get NodeId and number of nodes per processor.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20091216144355.GB28798@alberich.amd.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/cpufeature.h |    1 
 arch/x86/include/asm/msr-index.h  |    1 
 arch/x86/kernel/cpu/amd.c         |   53 ++++++++++----------------------------
 3 files changed, 17 insertions(+), 38 deletions(-)

--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -153,6 +153,7 @@
 #define X86_FEATURE_SSE5	(6*32+11) /* SSE-5 */
 #define X86_FEATURE_SKINIT	(6*32+12) /* SKINIT/STGI instructions */
 #define X86_FEATURE_WDT		(6*32+13) /* Watchdog timer */
+#define X86_FEATURE_NODEID_MSR	(6*32+19) /* NodeId MSR */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -125,6 +125,7 @@
 #define FAM10H_MMIO_CONF_BUSRANGE_SHIFT 2
 #define FAM10H_MMIO_CONF_BASE_MASK	0xfffffff
 #define FAM10H_MMIO_CONF_BASE_SHIFT	20
+#define MSR_FAM10H_NODE_ID		0xc001100c
 
 /* K8 MSRs */
 #define MSR_K8_TOP_MEM1			0xc001001a
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -254,59 +254,36 @@ static int __cpuinit nearby_node(int api
 
 /*
  * Fixup core topology information for AMD multi-node processors.
- * Assumption 1: Number of cores in each internal node is the same.
- * Assumption 2: Mixed systems with both single-node and dual-node
- *               processors are not supported.
+ * Assumption: Number of cores in each internal node is the same.
  */
 #ifdef CONFIG_X86_HT
 static void __cpuinit amd_fixup_dcm(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_PCI
-	u32 t, cpn;
-	u8 n, n_id;
+	unsigned long long value;
+	u32 nodes, cores_per_node;
 	int cpu = smp_processor_id();
 
+	if (!cpu_has(c, X86_FEATURE_NODEID_MSR))
+		return;
+
 	/* fixup topology information only once for a core */
 	if (cpu_has(c, X86_FEATURE_AMD_DCM))
 		return;
 
-	/* check for multi-node processor on boot cpu */
-	t = read_pci_config(0, 24, 3, 0xe8);
-	if (!(t & (1 << 29)))
+	rdmsrl(MSR_FAM10H_NODE_ID, value);
+
+	nodes = ((value >> 3) & 7) + 1;
+	if (nodes == 1)
 		return;
 
 	set_cpu_cap(c, X86_FEATURE_AMD_DCM);
+	cores_per_node = c->x86_max_cores / nodes;
 
-	/* cores per node: each internal node has half the number of cores */
-	cpn = c->x86_max_cores >> 1;
-
-	/* even-numbered NB_id of this dual-node processor */
-	n = c->phys_proc_id << 1;
+	/* store NodeID, use llc_shared_map to store sibling info */
+	per_cpu(cpu_llc_id, cpu) = value & 7;
 
-	/*
-	 * determine internal node id and assign cores fifty-fifty to
-	 * each node of the dual-node processor
-	 */
-	t = read_pci_config(0, 24 + n, 3, 0xe8);
-	n = (t>>30) & 0x3;
-	if (n == 0) {
-		if (c->cpu_core_id < cpn)
-			n_id = 0;
-		else
-			n_id = 1;
-	} else {
-		if (c->cpu_core_id < cpn)
-			n_id = 1;
-		else
-			n_id = 0;
-	}
-
-	/* compute entire NodeID, use llc_shared_map to store sibling info */
-	per_cpu(cpu_llc_id, cpu) = (c->phys_proc_id << 1) + n_id;
-
-	/* fixup core id to be in range from 0 to cpn */
-	c->cpu_core_id = c->cpu_core_id % cpn;
-#endif
+	/* fixup core id to be in range from 0 to (cores_per_node - 1) */
+	c->cpu_core_id = c->cpu_core_id % cores_per_node;
 }
 #endif
 


