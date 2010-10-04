Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab0JDU0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:26:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:39809 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932575Ab0JDU0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:26:51 -0400
Date: Mon, 4 Oct 2010 20:26:33 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100930123857.GE20545@loge.amd.com>
References: <20100930123857.GE20545@loge.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/amd-nb] x86, amd: Extract compute unit information for AMD CPUs
Message-ID: <tip-6057b4d331f19a3ea51aec463ea7839c128b3227@git.kernel.org>
Git-Commit-ID: 6057b4d331f19a3ea51aec463ea7839c128b3227
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:26:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6057b4d331f19a3ea51aec463ea7839c128b3227
Gitweb:     http://git.kernel.org/tip/6057b4d331f19a3ea51aec463ea7839c128b3227
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Thu, 30 Sep 2010 14:38:57 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 1 Oct 2010 16:18:32 -0700

x86, amd: Extract compute unit information for AMD CPUs

Get compute unit information from CPUID Fn8000_001E_EBX.
(See AMD CPUID Specification - publication # 25481, revision 2.34,
September 2010.)

Note that each core on a compute unit still has a core_id of its own.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20100930123857.GE20545@loge.amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/cpu/amd.c        |   20 +++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 325b7bd..69e80c2 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -110,6 +110,8 @@ struct cpuinfo_x86 {
 	u16			phys_proc_id;
 	/* Core id: */
 	u16			cpu_core_id;
+	/* Compute unit id */
+	u8			compute_unit_id;
 	/* Index into per_cpu list: */
 	u16			cpu_index;
 #endif
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7e6a37d..70168ab 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -256,21 +256,29 @@ static int __cpuinit nearby_node(int apicid)
  * Fixup core topology information for
  * (1) AMD multi-node processors
  *     Assumption: Number of cores in each internal node is the same.
+ * (2) AMD processors supporting compute units
  */
 #ifdef CONFIG_X86_HT
 static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 {
-	u32 nodes, cores_per_node;
+	u32 nodes;
 	u8 node_id;
-	unsigned long long value;
 	int cpu = smp_processor_id();
 
 	/* get information required for multi-node processors */
 	if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
-		value = cpuid_ecx(0x8000001e);
-		nodes = ((value >> 8) & 7) + 1;
-		node_id = value & 7;
+		u32 eax, ebx, ecx, edx;
+
+		cpuid(0x8000001e, &eax, &ebx, &ecx, &edx);
+		nodes = ((ecx >> 8) & 7) + 1;
+		node_id = ecx & 7;
+
+		/* get compute unit information */
+		smp_num_siblings = ((ebx >> 8) & 3) + 1;
+		c->compute_unit_id = ebx & 0xff;
 	} else if (cpu_has(c, X86_FEATURE_NODEID_MSR)) {
+		u64 value;
+
 		rdmsrl(MSR_FAM10H_NODE_ID, value);
 		nodes = ((value >> 3) & 7) + 1;
 		node_id = value & 7;
@@ -279,6 +287,8 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 
 	/* fixup multi-node processor information */
 	if (nodes > 1) {
+		u32 cores_per_node;
+
 		set_cpu_cap(c, X86_FEATURE_AMD_DCM);
 		cores_per_node = c->x86_max_cores / nodes;
 
