Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab0I3MkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 08:40:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62667 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab0I3MkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 08:40:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bBg5E1W2CWcuZIK+hS5WmmTSPcDOK7P/o5A5KnRjvHgXecPeHoYDSOkZF+WMSrcxJh
         4eADOnD/Q3dHIIg43lfZMKOSsVLkBv77yMEaAKQJhq89dZuaR3tL4Kaa8OVTzvb97qbE
         KbszfOW0PmteRklHu+9uVnQecFcnpVyCgmgHk=
Date: Thu, 30 Sep 2010 14:36:28 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] x86, amd: Add support for CPUID topology extension of
 AMD CPUs
Message-ID: <20100930123628.GD20545@loge.amd.com>
References: <20100930121839.GA20545@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930121839.GA20545@loge.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

Node information (ID, number of internal nodes) is provided via
CPUID Fn8000_001e_ECX.

See AMD CPUID Specification (Publication # 25481, Revision 2.34,
September 2010).

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/amd.c |   50 +++++++++++++++++++++++---------------------
 1 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7b875fd..c10c2cc 100644
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
 
-- 
1.6.4.4

