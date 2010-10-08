Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab0JHFuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 01:50:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:37614 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab0JHFug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 01:50:36 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Assign CPUs to nodes in round-robin manner on Fake NUMA.
Date: Fri, 8 Oct 2010 11:23:32 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-default; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
References: <201009301734.10787.knikanth@suse.de> <20101007004252.599b6888.akpm@linux-foundation.org>
In-Reply-To: <20101007004252.599b6888.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201010081123.32920.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 October 2010 13:12:52 Andrew Morton wrote:
> On Thu, 30 Sep 2010 17:34:10 +0530 Nikanth Karthikesan <knikanth@suse.de> 
wrote:
> > Assign CPUs to nodes in round-robin manner on Fake NUMA.
> >
> > commit d9c2d5ac6af87b4491bff107113aaf16f6c2b2d9
> > "x86, numa: Use near(er) online node instead of roundrobin for NUMA"
> > changed NUMA initialization on Intel to choose the nearest online node or
> > first node. Fake NUMA would be better of with round-robin initialization,
> > instead of the all CPUS on first node. Change the choice of first node,
> > back to round-robin.
> 
> Why would fake NUMA "be better off with round-robin initialization"?
> 

For testing NUMA kernel behaviour without cpusets and NUMA aware applications, 
it would be better to have cpus in different nodes, rather than all in a 
single node. With cpusets migration of tasks scenarios cannot not be tested.

I guess having it round-robin shouldn't affect the use cases for all cpus on 
the first node.

>From the code comments in arch/x86/mm/numa_64.c:759 looks like this used to be 
the case, which was changed by commit d9c2d5ac6. It changed from roundrobin to 
nearer or first node. And I couldn't find any reason for this change in its 
changelog.

Thanks
Nikanth

> > ---
> >
> > diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> > index 85f69cd..47dd171 100644
> > --- a/arch/x86/kernel/cpu/intel.c
> > +++ b/arch/x86/kernel/cpu/intel.c
> > @@ -283,9 +283,7 @@ static void __cpuinit srat_detect_node(struct
> > cpuinfo_x86 *c) /* Don't do the funky fallback heuristics the AMD version
> > employs for now. */
> >  	node = apicid_to_node[apicid];
> > -	if (node == NUMA_NO_NODE)
> > -		node = first_node(node_online_map);
> > -	else if (!node_online(node)) {
> > +	if (node == NUMA_NO_NODE || !node_online(node)) {
> >  		/* reuse the value from init_cpu_to_node() */
> >  		node = cpu_to_node(cpu);
> >  	}
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
