Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255Ab2EINAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:00:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40215 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab2EINAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:00:03 -0400
Date: Wed, 9 May 2012 05:59:50 -0700
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-re15l0jqjtpz709oxozt2zoh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, a.p.zijlstra@chello.nl, tj@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, a.p.zijlstra@chello.nl, tj@kernel.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] x86/numa:
  Check for nonsensical topologies on real hw as well
Git-Commit-ID: ad7687dde8780a0d618a3e3b5a62bb383696fc22
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 05:59:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad7687dde8780a0d618a3e3b5a62bb383696fc22
Gitweb:     http://git.kernel.org/tip/ad7687dde8780a0d618a3e3b5a62bb383696fc22
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 9 May 2012 13:31:47 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 13:32:35 +0200

x86/numa: Check for nonsensical topologies on real hw as well

Instead of only checking nonsensical topologies on numa-emu, do it
on real hardware as well, and print a warning.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/n/tip-re15l0jqjtpz709oxozt2zoh@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smpboot.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index edfd03a..7c53d96 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -337,10 +337,10 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		for_each_cpu(i, cpu_sibling_setup_mask) {
 			struct cpuinfo_x86 *o = &cpu_data(i);
 
-#ifdef CONFIG_NUMA_EMU
-			if (cpu_to_node(cpu) != cpu_to_node(i))
+			if (cpu_to_node(cpu) != cpu_to_node(i)) {
+				WARN_ONCE(1, "sched: CPU #%d's thread-sibling CPU #%d not on the same node! [node %d != %d]. Ignoring sibling dependency.\n", cpu, i, cpu_to_node(cpu), cpu_to_node(i));
 				continue;
-#endif
+			}
 
 			if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
 				if (c->phys_proc_id == o->phys_proc_id &&
@@ -365,10 +365,10 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 	}
 
 	for_each_cpu(i, cpu_sibling_setup_mask) {
-#ifdef CONFIG_NUMA_EMU
-		if (cpu_to_node(cpu) != cpu_to_node(i))
+		if (cpu_to_node(cpu) != cpu_to_node(i)) {
+			WARN_ONCE(1, "sched: CPU #%d's core-sibling CPU #%d not on the same node! [node %d != %d]. Ignoring sibling dependency.\n", cpu, i, cpu_to_node(cpu), cpu_to_node(i));
 			continue;
-#endif
+		}
 
 		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
 		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
