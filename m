Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1AZK6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:58:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:37512 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab1AZK6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:58:20 -0500
Date: Wed, 26 Jan 2011 10:57:53 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1295881543-572552-2-git-send-email-hans.rosenfeld@amd.com>
References: <1295881543-572552-2-git-send-email-hans.rosenfeld@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/amd-nb] x86, amd: Normalize compute unit IDs on multi-node processors
Message-ID: <tip-d518573de63fb119e5e9a3137386544671387681@git.kernel.org>
Git-Commit-ID: d518573de63fb119e5e9a3137386544671387681
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 10:57:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d518573de63fb119e5e9a3137386544671387681
Gitweb:     http://git.kernel.org/tip/d518573de63fb119e5e9a3137386544671387681
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Mon, 24 Jan 2011 16:05:40 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 08:28:22 +0100

x86, amd: Normalize compute unit IDs on multi-node processors

On multi-node CPUs we don't need the socket wide compute unit ID
but the node-wide compute unit ID. Thus we need to normalize the
value. This is similar to what we do with cpu_core_id.

A compute unit is then identified by physical_package_id,
node_id, and compute_unit_id.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <1295881543-572552-2-git-send-email-hans.rosenfeld@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
