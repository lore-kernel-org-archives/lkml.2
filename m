Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab1DKB62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 21:58:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54212 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab1DKB60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 21:58:26 -0400
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
In-Reply-To: <20110408164337.GC3871@mtj.dyndns.org>
References: <20110408235739.A6B0.A69D9226@jp.fujitsu.com> <20110408164337.GC3871@mtj.dyndns.org>
Message-Id: <20110411105837.0065.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 11 Apr 2011 10:58:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

> Hello, KOSAKI.
> 
> On Fri, Apr 08, 2011 at 11:56:20PM +0900, KOSAKI Motohiro wrote:
> > This is regression since commit e23bba6044 (x86-64, NUMA: Unify
> > emulated distance mapping). Because It drop fake_physnodes() and
> > then cpu-node mapping was changed.
> > 
> > 	old) all cpus are assinged node 0
> > 	now) cpus are assigned round robin
> > 	     (the logic is implemented by numa_init_array())
> 
> I think it's slightly more complex than that.  If apicid -> NUMA node
> mapping exists, the mapping (remapped during emulation) is always
> used.  The RR assignment is only used for CPUs which didn't have node
> assigned to it, most likely due to missing processor affinity entry.

Right. But, if my understanding is correct, we don't need worry it.
Because

2.6.38
---------------------------------------------------------
static void __init fake_physnodes(int acpi, int amd, int nr_nodes)
{
        int i;

        BUG_ON(acpi && amd);
#ifdef CONFIG_ACPI_NUMA
        if (acpi) {
                acpi_fake_nodes(nodes, nr_nodes);
        }
#endif
#ifdef CONFIG_AMD_NUMA
        if (amd) {
                amd_fake_nodes(nodes, nr_nodes);
        }
#endif
        if (!acpi && !amd) {
                for (i = 0; i < nr_cpu_ids; i++)
                        numa_set_node(i, 0);
        }
}
---------------------------------------------------------

if acpi entry is appeared, acpi variable is 1. then, numa_se_node(i, 0)
aren't called.


my patch
-------------------------------------------------------------
+	/* Setup cpu node map. */
+	for (i = 0; i < nr_cpu_ids; i++) {
+		if (early_cpu_to_node(i) != NUMA_NO_NODE)
+			continue;
+		numa_set_node(i, 0);
+	}
+
-------------------------------------------------------------

If acpi entry is appeared, init_func() of numa_init() have already
changed cpu_to_node[] entry to !NUMA_NO_NODE. Then, this logic behave
no-op.

Then, I didn't describe this case. no change has no matter. :)

> I think, with or without the recent changes, numa_init_array() would
> have assigned RR nodes to those uninitialized CPUs.  What changed is
> that the same RR fallback is now used even when emulation is used now.

Right.

So, I _guess_ numa_init_array() was only used very old machine and
they have no multi core in practical world. thus, they didn't hit
this issue.

But, I'm not sure which machine really need (and use) numa_init_array().
then, my patch choose most conservative way. (ie back old logic)


> > Why round robin assignment doesn't work? Because init_numa_sched_groups_power()
> > assume all logical cpus in a same physical cpu are assigned a same node.
> > (Then it only account group_first_cpu()). But the simple round robin broke
> > the assumption. Thus, this patch reimplement cpu node map initialization
> > for fake numa.
> 
> Maybe I'm confused but I don't think this is the correct fix.  What
> prevents RR assignment triggering the same problem when emulation is
> not used?  If we're falling back every uninitialized cpu to node 0
> after emulation, we should be doing that for !emulation path too and I
> don't think that's what we want.  It seems like the emulation is just
> triggering an underlying condition simplify because it's ending up
> with different assignment and the same condition might as well trigger
> without emulation.  Am I missing something?

No, you are completely correct.
I think this breakage is existing from long past. And I _guess_
no such machine is existing in a real world. If any machine don't
hit the incorrect code, it's no matter even though the logic is buggy.

For 2.6.39 timeframe, we have a few option. I mean I personaly think
we have no option that 2.6.39 will be released that it remain to have
a boot failure bug.

	1) revert all of your x86-64/mm chagesets
	2) undo only numa_emulation change (my proposal)
	3) make a radical improvement now and apply it without linux-next
	   testing phase.

I dislike 1) and 3) beucase, 1) we know the breakage is where come from.
then we have no reason to revert all. 3) I hate untested patch simply.

A few addional explanation is here: scheduler group for MC is created based
on cpu_llc_shared_mask(). And it was created set_cpu_sibling_map().
Unfortunatelly, it is constructed very later against numa_init_array().
Thus, numa_init_array() changing is no simple work and no low risk work.

In the other word, I didn't talk about which is correct (or proper) 
algorithm, I did only talk about logic undo has least regression risk. 
So, I still think making new RR numa assignment should be deferred 
.40 or .41 and apply my bandaid patch now. However if you have an 
alternative fixing patch, I can review and discuss it, of cource.

Thanks.



