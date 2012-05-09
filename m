Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249Ab2EIM7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 08:59:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40187 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab2EIM7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 08:59:12 -0400
Date: Wed, 9 May 2012 05:59:00 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-di5vwjm96q5vrb76opwuflwx@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, a.p.zijlstra@chello.nl, tj@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, a.p.zijlstra@chello.nl, tj@kernel.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] x86/numa:
  Hard partition cpu topology masks on node boundaries
Git-Commit-ID: 0acbb440f06302058e1515861dd534594521e892
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 05:59:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0acbb440f06302058e1515861dd534594521e892
Gitweb:     http://git.kernel.org/tip/0acbb440f06302058e1515861dd534594521e892
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 18 Apr 2012 19:04:09 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 13:28:59 +0200

x86/numa: Hard partition cpu topology masks on node boundaries

When using numa=fake= you can get weird topologies where LLCs can span
nodes and other such nonsense. Cure this by hard partitioning these
masks on node boundaries.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/n/tip-di5vwjm96q5vrb76opwuflwx@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smpboot.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6e1e406..edfd03a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -337,6 +337,11 @@ void __cpuinit set_cpu_sibling_map(int cpu)
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
@@ -360,11 +365,17 @@ void __cpuinit set_cpu_sibling_map(int cpu)
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
