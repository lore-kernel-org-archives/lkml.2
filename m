Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab0I3Mmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 08:42:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55270 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab0I3Mmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 08:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gsm9pswvEZ1e1tpDeWLz1CmmRoKpiTOkagtaBEQLk8+7y+eon+oJtLWiqgeUmonTC4
         L/Dr4hIDt0r36nKVz74Et5gD5l08tjFzZ/ZwHprwCaDHt1DYC2JYfiEg81qGNSKxtXZB
         78oZrWua7Qxsqw6TZCEa9UNSCs0TnzIxtm0OQ=
Date: Thu, 30 Sep 2010 14:38:57 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] x86, amd: Extract compute unit information for AMD CPUs
Message-ID: <20100930123857.GE20545@loge.amd.com>
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

Get compute unit information from CPUID Fn8000_001E_EBX.
(See AMD CPUID Specification - publication # 25481, revision 2.34,
September 2010.)

Note that each core on a compute unit still has a core_id of its own.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/cpu/amd.c        |   20 +++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b871129..cae9c3c 100644
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
index c10c2cc..9e093f8 100644
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
 
-- 
1.6.4.4

