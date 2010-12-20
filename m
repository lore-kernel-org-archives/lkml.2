Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab0LTR3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 12:29:11 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:52910
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491Ab0LTR3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 12:29:09 -0500
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Dec 2010 12:29:09 EST
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LDQL70-02-3MX-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, <andreas.herrmann3@amd.com>
Subject: [PATCH 1/4] x86, amd: Normalize compute unit IDs on multi-node processors
Date: Mon, 20 Dec 2010 18:13:44 +0100
Message-ID: <1292865227-647466-2-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292865227-647466-1-git-send-email-hans.rosenfeld@amd.com>
References: <1292865227-647466-1-git-send-email-hans.rosenfeld@amd.com>
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
index 9e093f8..9645604 100644
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
index 083e99d..3bc0435 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -417,6 +417,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 
 			if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
 				if (c->phys_proc_id == o->phys_proc_id &&
+				    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i) &&
 				    c->compute_unit_id == o->compute_unit_id)
 					link_thread_siblings(cpu, i);
 			} else if (c->phys_proc_id == o->phys_proc_id &&
-- 
1.5.6.5


