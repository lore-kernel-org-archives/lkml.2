Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab1DUFqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 01:46:00 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56522 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab1DUFps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 01:45:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch 2/2] x86, numa: Fix cpu nodemasks for NUMA emulation and CONFIG_DEBUG_PER_CPU_MAPS
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        x86@kernel.org
In-Reply-To: <alpine.DEB.2.00.1104201918470.12634@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104201918110.12634@chino.kir.corp.google.com> <alpine.DEB.2.00.1104201918470.12634@chino.kir.corp.google.com>
Message-Id: <20110421144621.7339.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 21 Apr 2011 14:45:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> cpu nodemasks under CONFIG_DEBUG_PER_CPU_MAPS when NUMA emulation is 
> enabled is currently broken because it does not iterate through every 
> emulated node and bind cpus that have affinity to it.  NUMA emulation 
> should bind each cpu to every local node to accurately represent the true 
> NUMA topology of the underlying machine.
> 
> debug_cpumask_set_cpu() needs to be fixed at the same time so that the 
> debugging information that it emits shows the new cpumask of the node 
> being assigned when the cpu is being added or removed.  It can now take 
> responsibility of setting or clearing the cpu itself to remove the need 
> for duplicate code.
> 
> Also changes its last formal, "enable", to have the correct bool type 
> since it can only be true or false.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Ok, this is better. I haven't realized node_to_cpumask_map[] don't
need exclusive cpu map. 

Thank you!


Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



However

> -struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable)
> +void debug_cpumask_set_cpu(int cpu, int node, bool enable)
>  {
> -	int node = early_cpu_to_node(cpu);
>  	struct cpumask *mask;
>  	char buf[64];
>  
> @@ -227,9 +226,14 @@ struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable)
>  	if (!mask) {
>  		pr_err("node_to_cpumask_map[%i] NULL\n", node);
>  		dump_stack();
> -		return NULL;
> +		return;
>  	}
>  
> +	if (enable)
> +		cpumask_set_cpu(cpu, mask);
> +	else
> +		cpumask_clear_cpu(cpu, mask);
> +

Following patch also shold be apply?


(BFrom aaca24826696f7911bd66380baa18cfbe4f4b18e Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 21 Apr 2011 14:01:42 +0900
Subject: [PATCH] Fix

debug_cpumask_set_cpu() has tree return statement. we have change
rest two return statement.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 arch/x86/mm/numa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 0471b1d6..745258d 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -220,7 +220,7 @@ void debug_cpumask_set_cpu(int cpu, int node, bool enable)
 
 	if (node == NUMA_NO_NODE) {
 		/* early_cpu_to_node() already emits a warning and trace */
-		return NULL;
+		return;
 	}
 	mask = node_to_cpumask_map[node];
 	if (!mask) {
@@ -238,7 +238,7 @@ void debug_cpumask_set_cpu(int cpu, int node, bool enable)
 	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
 		enable ? "numa_add_cpu" : "numa_remove_cpu",
 		cpu, node, buf);
-	return mask;
+	return;
 }
 
 # ifndef CONFIG_NUMA_EMU
-- 
1.7.3.1




