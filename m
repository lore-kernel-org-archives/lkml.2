Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab0KLGTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 01:19:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab0KLGTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 01:19:07 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Myron Stowe <myron.stowe@hp.com>
Subject: Re: divide error in select_task_rq_fair()
Date: Fri, 12 Nov 2010 11:52:29 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-default; KDE/4.3.5; x86_64; ; )
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        linux-kernel@vger.kernel.org, rjenties@google.com
References: <20101104041236.GA9389@helgaas.com> <1288937844.3234.1.camel@edumazet-laptop> <1289500084.2698.12.camel@zim>
In-Reply-To: <1289500084.2698.12.camel@zim>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011121152.30204.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 November 2010 23:58:04 Myron Stowe wrote:
> On Fri, 2010-11-05 at 07:17 +0100, Eric Dumazet wrote:
> > Le jeudi 04 novembre 2010 à 20:00 -0600, Bjorn Helgaas a écrit :
> > > Is that going to help you debug the problem?  The solution is not going
> > > to be something like "set NR_CPUS=x".  If NR_CPUS is too small, the
> > > machine should still *boot*, even if we can't use all the CPUs in the
> > > box.
> >
> > Yes, it will help to understand the layout of cpu / domains and make
> > appropriate changes.
> >
> > Alternative is you send me such a machine :=)
> 
> I opened a BZ on this issue as it seems to be a regression -
> https://bugzilla.kernel.org/show_bug.cgi?id=22662
> 
> I also, as indicated in the BZ, bisected the kernel which gave the
> following results and reverting 50f2d7f682f9c0ed58191d0982fe77888d59d162
> did re-enable booting on the box in question (an HP dl980g7).  Let me
> know what further info you need or patches to test for debugging this.
> 
> Thanks,
> 
> commit 50f2d7f682f9c0ed58191d0982fe77888d59d162
> Author: Nikanth Karthikesan <knikanth@suse.de>
> Date:   Thu Sep 30 17:34:10 2010 +0530
> 
>     x86, numa: Assign CPUs to nodes in round-robin manner on fake NUMA
> 
>     commit d9c2d5ac6af87b4491bff107113aaf16f6c2b2d9 "x86, numa: Use
>  near(er) online node instead of roundrobin for NUMA" changed NUMA
>  initialization on Intel to choose the nearest online node or first node. 
>  Fake NUMA would be better of with round-robin initialization, instead of
>  the all CPUS on first node.  Change the choice of first node, back to
>  round-robin.
> 
>     For testing NUMA kernel behaviour without cpusets and NUMA aware
>     applications, it would be better to have cpus in different nodes,
>  rather than all in a single node.  With cpusets migration of tasks
>  scenarios cannot not be tested.
> 
>     I guess having it round-robin shouldn't affect the use cases for all
>  cpus on the first node.
> 
>     The code comments in arch/x86/mm/numa_64.c:759 indicate that this used
>  to be the case, which was changed by commit d9c2d5ac6.  It changed from
>  roundrobin to nearer or first node.  And I couldn't find any reason for
>  this change in its changelog.
> 
>     Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
>     Cc: David Rientjes <rientjes@google.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> > Thanks
> 

Can you try with this patch?

Thanks
Nikanth

Fallback to first node, if the node is not online.

Fixes regression of commit 50f2d7f682f9c0ed58191d0982fe77888d59d162
x86, numa: Assign CPUs to nodes in round-robin manner on fake NUMA

When some of the NUMA nodes are disabled, and the CPUs are assigned
in round-robin fashion, CPUs might be assigned to disabled nodes
resulting in the crash. While using round-robin assignment, check if the
node is online. If the node is not online, use the first online node.

Reported-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index d16c2c5..f31237c 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -287,6 +287,8 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 	if (node == NUMA_NO_NODE || !node_online(node)) {
 		/* reuse the value from init_cpu_to_node() */
 		node = cpu_to_node(cpu);
+		if (!node_online(node))
+			node = first_node(node_online_map);
 	}
 	numa_set_node(cpu, node);
 #endif
