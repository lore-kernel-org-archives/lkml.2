Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751002Ab1DLEAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 00:00:47 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54897 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab1DLEAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 00:00:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Jr0vzLk1lRBTFD8I/d+AcGpLPX14rStSlWkqn/KmZFiQCSOnlalt55ZdTLSBJRLpvU
         FQS8exwvJx7yZkSKBCz71Qd8ceSt6OndqvkybolbC4Vkg7/E77lAJ8qY0MjVZVmFwSWP
         vj6Dvyist4VXGJRyAOdDmFsSOPd/cZ27vOrOk=
Date: Tue, 12 Apr 2011 13:00:37 +0900
From: Tejun Heo <tj@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Brian Gerst <brgerst@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] x86-64, NUMA: reimplement cpu node map initialization
 for fake numa
Message-ID: <20110412040037.GK9673@mtj.dyndns.org>
References: <20110408235739.A6B0.A69D9226@jp.fujitsu.com>
 <20110408164337.GC3871@mtj.dyndns.org>
 <20110411105837.0065.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110411105837.0065.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Apr 11, 2011 at 10:58:21AM +0900, KOSAKI Motohiro wrote:
> 	1) revert all of your x86-64/mm chagesets
> 	2) undo only numa_emulation change (my proposal)
> 	3) make a radical improvement now and apply it without linux-next
> 	   testing phase.
> 
> I dislike 1) and 3) beucase, 1) we know the breakage is where come from.
> then we have no reason to revert all. 3) I hate untested patch simply.

Yeah, sure, we need to fix it but let's at least try to understand
what's broken and assess which is the best approach before rushing
with a quick fix.  It's not like it breaks common boot scenarios or
we're in late -rc cycles.

So, before the change, if the machine had neither ACPI nor AMD NUMA
configuration, fake_physnodes() would have assigned node 0 to all
CPUs, while new code would RR assign availabile nodes.  For !emulation
case, both behave the same because, well, there can be only one node.
With emulation, it becomes different.  CPUs are RR'd across the
emulated nodes and this breaks the siblings belong to the same node
assumption.

> A few addional explanation is here: scheduler group for MC is created based
> on cpu_llc_shared_mask(). And it was created set_cpu_sibling_map().
> Unfortunatelly, it is constructed very later against numa_init_array().
> Thus, numa_init_array() changing is no simple work and no low risk work.
> 
> In the other word, I didn't talk about which is correct (or proper) 
> algorithm, I did only talk about logic undo has least regression risk. 
> So, I still think making new RR numa assignment should be deferred 
> .40 or .41 and apply my bandaid patch now. However if you have an 
> alternative fixing patch, I can review and discuss it, of cource.

Would something like the following work?

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c2871d3..bad8a10 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -320,6 +320,18 @@ static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
 	cpumask_set_cpu(cpu2, cpu_core_mask(cpu1));
 	cpumask_set_cpu(cpu1, cpu_llc_shared_mask(cpu2));
 	cpumask_set_cpu(cpu2, cpu_llc_shared_mask(cpu1));
+
+	/*
+	 * It's assumed that sibling CPUs live on the same NUMA node, which
+	 * might not hold if NUMA configuration is broken or emulated.
+	 * Enforce it.
+	 */
+	if (early_cpu_to_node(cpu1) != early_cpu_to_node(cpu2)) {
+		pr_warning("CPU %d in node %d and CPU %d in node %d are siblings, forcing same node\n",
+			   cpu1, early_cpu_to_node(cpu1),
+			   cpu2, early_cpu_to_node(cpu2));
+		numa_set_node(cpu2, early_cpu_to_node(cpu1));
+	}
 }
 
 
