Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab2EAS26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:28:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:37668 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab2EAS2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:28:40 -0400
Message-Id: <20120501182610.925408985@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 01 May 2012 20:14:34 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, pjt@google.com, vatsa@in.ibm.com,
        suresh.b.siddha@intel.com, efault@gmx.de
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 4/5] x86: Hard partition cpu topology masks on node boundaries
References: <20120501181430.007891123@chello.nl>
Content-Disposition: inline; filename=x86-numa-emulation-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using numa=fake= you can get weird topologies where LLCs can span
nodes and other such nonsense. Cure this by hard partitioning these
masks on node boundaries.

Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/smpboot.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -337,6 +337,11 @@ void __cpuinit set_cpu_sibling_map(int c
 		for_each_cpu(i, cpu_sibling_setup_mask) {
 			struct cpuinfo_x86 *o = &cpu_data(i);
 
+#ifdef CONFIG_NUMA_EMU
+			if (cpu_to_node(cpu) != cpu_to_node(i))
+				continue;
+#endif
+
 			if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
 				if (c->phys_proc_id == o->phys_proc_id &&
 				    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i) &&
@@ -360,11 +365,17 @@ void __cpuinit set_cpu_sibling_map(int c
 	}
 
 	for_each_cpu(i, cpu_sibling_setup_mask) {
+#ifdef CONFIG_NUMA_EMU
+		if (cpu_to_node(cpu) != cpu_to_node(i))
+			continue;
+#endif
+
 		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
 		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
 			cpumask_set_cpu(i, cpu_llc_shared_mask(cpu));
 			cpumask_set_cpu(cpu, cpu_llc_shared_mask(i));
 		}
+
 		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
 			cpumask_set_cpu(i, cpu_core_mask(cpu));
 			cpumask_set_cpu(cpu, cpu_core_mask(i));


