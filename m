Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab1DUMKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 08:10:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:37088 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab1DUMKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 08:10:40 -0400
Date: Thu, 21 Apr 2011 12:09:51 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Message-ID: <tip-37f8527dbfd05af0f670aa02370d0c4cca7fbda6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, herrmann.der.user@googlemail.com,
        tj@kernel.org, tglx@linutronix.de, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, herrmann.der.user@googlemail.com,
        tj@kernel.org, tglx@linutronix.de, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.1104201918110.12634@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104201918110.12634@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] Revert "x86, NUMA: Fix fakenuma boot failure"
Git-Commit-ID: 37f8527dbfd05af0f670aa02370d0c4cca7fbda6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Apr 2011 12:09:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37f8527dbfd05af0f670aa02370d0c4cca7fbda6
Gitweb:     http://git.kernel.org/tip/37f8527dbfd05af0f670aa02370d0c4cca7fbda6
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Wed, 20 Apr 2011 19:19:10 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Apr 2011 11:30:59 +0200

Revert "x86, NUMA: Fix fakenuma boot failure"

Andreas Herrmann reported that 7d6b46707f24 ("x86, NUMA: Fix fakenuma
boot failure") causes certain physical NUMA topologies (for example
AMD Magny-Cours) to move sibling cpus to a single node when in reality
they are in separate domains.

This may result in some nodes being completely void of cpus, which
doesn't accurately represent the correct topology. The system will
boot, but will have suboptimal NUMA performance.

This commit was intended as a fix for NUMA emulation, but should
not cause a regression for real NUMA machines as a side effect.

( There will be a separate fix for the numa-debug code, which
  will not affect physical topologies. )

Reported-by: Andreas Herrmann <herrmann.der.user@googlemail.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.00.1104201918110.12634@chino.kir.corp.google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/smpboot.c |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 8ed8908..c2871d3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -312,26 +312,6 @@ void __cpuinit smp_store_cpu_info(int id)
 		identify_secondary_cpu(c);
 }
 
-static void __cpuinit check_cpu_siblings_on_same_node(int cpu1, int cpu2)
-{
-	int node1 = early_cpu_to_node(cpu1);
-	int node2 = early_cpu_to_node(cpu2);
-
-	/*
-	 * Our CPU scheduler assumes all logical cpus in the same physical cpu
-	 * share the same node. But, buggy ACPI or NUMA emulation might assign
-	 * them to different node. Fix it.
-	 */
-	if (node1 != node2) {
-		pr_warning("CPU %d in node %d and CPU %d in node %d are in the same physical CPU. forcing same node %d\n",
-			   cpu1, node1, cpu2, node2, node2);
-
-		numa_remove_cpu(cpu1);
-		numa_set_node(cpu1, node2);
-		numa_add_cpu(cpu1);
-	}
-}
-
 static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
 {
 	cpumask_set_cpu(cpu1, cpu_sibling_mask(cpu2));
@@ -340,7 +320,6 @@ static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
 	cpumask_set_cpu(cpu2, cpu_core_mask(cpu1));
 	cpumask_set_cpu(cpu1, cpu_llc_shared_mask(cpu2));
 	cpumask_set_cpu(cpu2, cpu_llc_shared_mask(cpu1));
-	check_cpu_siblings_on_same_node(cpu1, cpu2);
 }
 
 
@@ -382,12 +361,10 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
 			cpumask_set_cpu(i, cpu_llc_shared_mask(cpu));
 			cpumask_set_cpu(cpu, cpu_llc_shared_mask(i));
-			check_cpu_siblings_on_same_node(cpu, i);
 		}
 		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
 			cpumask_set_cpu(i, cpu_core_mask(cpu));
 			cpumask_set_cpu(cpu, cpu_core_mask(i));
-			check_cpu_siblings_on_same_node(cpu, i);
 			/*
 			 *  Does this new cpu bringup a new core?
 			 */
