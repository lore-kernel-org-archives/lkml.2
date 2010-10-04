Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab0JDU0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:26:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:39779 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322Ab0JDU0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:26:32 -0400
Date: Mon, 4 Oct 2010 20:26:11 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100930123628.GD20545@loge.amd.com>
References: <20100930123628.GD20545@loge.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/amd-nb] x86, amd: Add support for CPUID topology extension of AMD CPUs
Message-ID: <tip-23588c38a84c9175c6668789b64ffba4651e5c6a@git.kernel.org>
Git-Commit-ID: 23588c38a84c9175c6668789b64ffba4651e5c6a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:26:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23588c38a84c9175c6668789b64ffba4651e5c6a
Gitweb:     http://git.kernel.org/tip/23588c38a84c9175c6668789b64ffba4651e5c6a
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Thu, 30 Sep 2010 14:36:28 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 1 Oct 2010 16:18:32 -0700

x86, amd: Add support for CPUID topology extension of AMD CPUs

Node information (ID, number of internal nodes) is provided via
CPUID Fn8000_001e_ECX.

See AMD CPUID Specification (Publication # 25481, Revision 2.34,
September 2010).

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20100930123628.GD20545@loge.amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/amd.c |   50 +++++++++++++++++++++++---------------------
 1 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 0f0ace5..7e6a37d 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -253,37 +253,41 @@ static int __cpuinit nearby_node(int apicid)
 #endif
 
 /*
- * Fixup core topology information for AMD multi-node processors.
- * Assumption: Number of cores in each internal node is the same.
+ * Fixup core topology information for
+ * (1) AMD multi-node processors
+ *     Assumption: Number of cores in each internal node is the same.
  */
 #ifdef CONFIG_X86_HT
-static void __cpuinit amd_fixup_dcm(struct cpuinfo_x86 *c)
+static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 {
-	unsigned long long value;
 	u32 nodes, cores_per_node;
+	u8 node_id;
+	unsigned long long value;
 	int cpu = smp_processor_id();
 
-	if (!cpu_has(c, X86_FEATURE_NODEID_MSR))
-		return;
-
-	/* fixup topology information only once for a core */
-	if (cpu_has(c, X86_FEATURE_AMD_DCM))
+	/* get information required for multi-node processors */
+	if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
+		value = cpuid_ecx(0x8000001e);
+		nodes = ((value >> 8) & 7) + 1;
+		node_id = value & 7;
+	} else if (cpu_has(c, X86_FEATURE_NODEID_MSR)) {
+		rdmsrl(MSR_FAM10H_NODE_ID, value);
+		nodes = ((value >> 3) & 7) + 1;
+		node_id = value & 7;
+	} else
 		return;
 
-	rdmsrl(MSR_FAM10H_NODE_ID, value);
+	/* fixup multi-node processor information */
+	if (nodes > 1) {
+		set_cpu_cap(c, X86_FEATURE_AMD_DCM);
+		cores_per_node = c->x86_max_cores / nodes;
 
-	nodes = ((value >> 3) & 7) + 1;
-	if (nodes == 1)
-		return;
-
-	set_cpu_cap(c, X86_FEATURE_AMD_DCM);
-	cores_per_node = c->x86_max_cores / nodes;
+		/* store NodeID, use llc_shared_map to store sibling info */
+		per_cpu(cpu_llc_id, cpu) = node_id;
 
-	/* store NodeID, use llc_shared_map to store sibling info */
-	per_cpu(cpu_llc_id, cpu) = value & 7;
-
-	/* fixup core id to be in range from 0 to (cores_per_node - 1) */
-	c->cpu_core_id = c->cpu_core_id % cores_per_node;
+		/* core id to be in range from 0 to (cores_per_node - 1) */
+		c->cpu_core_id = c->cpu_core_id % cores_per_node;
+	}
 }
 #endif
 
@@ -304,9 +308,7 @@ static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 	c->phys_proc_id = c->initial_apicid >> bits;
 	/* use socket ID also for last level cache */
 	per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
-	/* fixup topology information on multi-node processors */
-	if ((c->x86 == 0x10) && (c->x86_model == 9))
-		amd_fixup_dcm(c);
+	amd_get_topology(c);
 #endif
 }
 
