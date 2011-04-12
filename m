Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab1DLEi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 00:38:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48548 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab1DLEi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 00:38:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] x86-64, NUMA: reimplement cpu node map initialization for fake numa
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Brian Gerst <brgerst@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>
In-Reply-To: <20110412040037.GK9673@mtj.dyndns.org>
References: <20110411105837.0065.A69D9226@jp.fujitsu.com> <20110412040037.GK9673@mtj.dyndns.org>
Message-Id: <20110412133842.6A37.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 12 Apr 2011 13:38:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Hey,
> 
> On Mon, Apr 11, 2011 at 10:58:21AM +0900, KOSAKI Motohiro wrote:
> > 	1) revert all of your x86-64/mm chagesets
> > 	2) undo only numa_emulation change (my proposal)
> > 	3) make a radical improvement now and apply it without linux-next
> > 	   testing phase.
> > 
> > I dislike 1) and 3) beucase, 1) we know the breakage is where come from.
> > then we have no reason to revert all. 3) I hate untested patch simply.
> 
> Yeah, sure, we need to fix it but let's at least try to understand
> what's broken and assess which is the best approach before rushing
> with a quick fix.  It's not like it breaks common boot scenarios or
> we're in late -rc cycles.
> 
> So, before the change, if the machine had neither ACPI nor AMD NUMA
> configuration, fake_physnodes() would have assigned node 0 to all
> CPUs, while new code would RR assign availabile nodes.  For !emulation
> case, both behave the same because, well, there can be only one node.
> With emulation, it becomes different.  CPUs are RR'd across the
> emulated nodes and this breaks the siblings belong to the same node
> assumption.

Yes, I think so.

> 
> > A few addional explanation is here: scheduler group for MC is created based
> > on cpu_llc_shared_mask(). And it was created set_cpu_sibling_map().
> > Unfortunatelly, it is constructed very later against numa_init_array().
> > Thus, numa_init_array() changing is no simple work and no low risk work.
> > 
> > In the other word, I didn't talk about which is correct (or proper) 
> > algorithm, I did only talk about logic undo has least regression risk. 
> > So, I still think making new RR numa assignment should be deferred 
> > .40 or .41 and apply my bandaid patch now. However if you have an 
> > alternative fixing patch, I can review and discuss it, of cource.
> 
> Would something like the following work?
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index c2871d3..bad8a10 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -320,6 +320,18 @@ static void __cpuinit link_thread_siblings(int cpu1, int cpu2)
>  	cpumask_set_cpu(cpu2, cpu_core_mask(cpu1));
>  	cpumask_set_cpu(cpu1, cpu_llc_shared_mask(cpu2));
>  	cpumask_set_cpu(cpu2, cpu_llc_shared_mask(cpu1));
> +
> +	/*
> +	 * It's assumed that sibling CPUs live on the same NUMA node, which
> +	 * might not hold if NUMA configuration is broken or emulated.
> +	 * Enforce it.
> +	 */
> +	if (early_cpu_to_node(cpu1) != early_cpu_to_node(cpu2)) {
> +		pr_warning("CPU %d in node %d and CPU %d in node %d are siblings, forcing same node\n",
> +			   cpu1, early_cpu_to_node(cpu1),
> +			   cpu2, early_cpu_to_node(cpu2));
> +		numa_set_node(cpu2, early_cpu_to_node(cpu1));
> +	}
>  }

ok, I'll test this. please wait half days.


