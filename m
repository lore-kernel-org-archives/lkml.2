Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab1DUCTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:19:16 -0400
Received: from smtp-out.google.com ([74.125.121.67]:34903 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab1DUCTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:19:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=SGE1NDFcN5NI1/QbM0f94WoWg7MQYkJh6LDWmaNnEwNfPFL3n+5DJKujaNO0IdPPRA
         U9au+KxO09f9d/96o9ng==
Date: Wed, 20 Apr 2011 19:19:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
cc: Andreas Herrmann <herrmann.der.user@googlemail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        x86@kernel.org
Subject: [patch 1/2] x86, numa: Revert "Fix fakenuma boot failure"
In-Reply-To: <alpine.DEB.2.00.1104201722540.15906@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1104201918110.12634@chino.kir.corp.google.com>
References: <BANLkTin1=uPcyBgy9S_2TJASk8qTkeueEA@mail.gmail.com> <20110420153907.GA9000@alberich.amd.com> <alpine.DEB.2.00.1104201722540.15906@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

7d6b46707f24 (x86, NUMA: Fix fakenuma boot failure) could cause physical 
NUMA topologies to move sibling cpus to a single node when in reality 
they are in separate domains.  This may result in some nodes being 
completely void of cpus, which doesn't accurately represent the correct 
topology.

This commit was intended as a fix for NUMA emulation, but should not 
cause a regression for real NUMA machines as a side effect.

Reported-by: Andreas Herrmann <herrmann.der.user@googlemail.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/kernel/smpboot.c |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
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
