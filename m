Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1AXPF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:05:58 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:5929 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752998Ab1AXPF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:05:56 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LFJ8LO-02-KZH-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <andreas.herrmann3@amd.com>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>
Subject: [PATCH 1/4] x86, amd: Normalize compute unit IDs on multi-node processors
Date: Mon, 24 Jan 2011 16:05:40 +0100
Message-ID: <1295881543-572552-2-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1295881543-572552-1-git-send-email-hans.rosenfeld@amd.com>
References: <1295881543-572552-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

On multi-node CPUs we don't need the socket wide compute unit ID but
the node-wide compute unit ID. Thus we need to normalize the value.
This is similar to what we do with cpu_core_id.

A compute unit is then identified by physical_package_id, node_id, and
compute_unit_id.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/amd.c |    8 ++++++--
 arch/x86/kernel/smpboot.c |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7c7bedb..990cc48 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -261,7 +261,7 @@ static int __cpuinit nearby_node(int apicid)
 #ifdef CONFIG_X86_HT
 static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 {
-	u32 nodes;
+	u32 nodes, cores_per_cu;
 	u8 node_id;
 	int cpu = smp_processor_id();
 
@@ -276,6 +276,7 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 		/* get compute unit information */
 		smp_num_siblings = ((ebx >> 8) & 3) + 1;
 		c->compute_unit_id = ebx & 0xff;
+		cores_per_cu = ((ebx >> 8) & 3) + 1;
 	} else if (cpu_has(c, X86_FEATURE_NODEID_MSR)) {
 		u64 value;
 
@@ -288,15 +289,18 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 	/* fixup multi-node processor information */
 	if (nodes > 1) {
 		u32 cores_per_node;
+		u32 cus_per_node;
 
 		set_cpu_cap(c, X86_FEATURE_AMD_DCM);
 		cores_per_node = c->x86_max_cores / nodes;
+		cus_per_node = cores_per_node / cores_per_cu;
 
 		/* store NodeID, use llc_shared_map to store sibling info */
 		per_cpu(cpu_llc_id, cpu) = node_id;
 
 		/* core id to be in range from 0 to (cores_per_node - 1) */
-		c->cpu_core_id = c->cpu_core_id % cores_per_node;
+		c->cpu_core_id %= cores_per_node;
+		c->compute_unit_id %= cus_per_node;
 	}
 }
 #endif
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 0cbe8c0..fbaa222 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -414,6 +414,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 
 			if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
 				if (c->phys_proc_id == o->phys_proc_id &&
+				    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i) &&
 				    c->compute_unit_id == o->compute_unit_id)
 					link_thread_siblings(cpu, i);
 			} else if (c->phys_proc_id == o->phys_proc_id &&
-- 
1.5.6.5


