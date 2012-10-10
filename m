Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab2JJUad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 16:30:33 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35540 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215Ab2JJUab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 16:30:31 -0400
Date: Wed, 10 Oct 2012 13:30:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
cc: Tang Chen <tangchen@cn.fujitsu.com>, mingo@redhat.com,
        miaox@cn.fujitsu.com, wency@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's
 node.
In-Reply-To: <1349860216.7880.105.camel@twins>
Message-ID: <alpine.DEB.2.00.1210101324000.28583@chino.kir.corp.google.com>
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com> <1349780256.7880.12.camel@twins> <alpine.DEB.2.00.1210091328030.32588@chino.kir.corp.google.com> <1349815676.7880.85.camel@twins> <alpine.DEB.2.00.1210091617260.10143@chino.kir.corp.google.com>
 <1349860216.7880.105.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2012, Peter Zijlstra wrote:

> > If cpu_to_node() always returns a valid node id even if all cpus on the 
> > node are offline, then the cpumask_of_node() implementation, which the 
> > sched code is using, should either return an empty cpumask (if 
> > node_to_cpumask_map[nid] isn't freed) or cpu_online_mask.  The change in 
> > behavior here occurred because 
> > cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch in -mm doesn't 
> > return a valid node id and forces it to return -1 so a kzalloc_node(..., 
> > -1) fallsback to allocate anywhere.
> 
> I think that's broken semantics.. so far the entire cpu<->node mapping
> was invariant during hotplug. Changing that is going to be _very_
> interesting and cannot be done lightly.
> 
> Because as I said, per-cpu memory is preserved over hotplug, and that
> has numa affinity.
> 
> So for now, let me NACK that patch. You cannot go change stuff like
> that.
> 

Agreed, that makes the nack-count up to 2 now.  Andrew, please remove 
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
from -mm.

> > But if you only need cpu_to_node() when waking up to find a runnable cpu 
> > for this NUMA information, then I think you can just change the 
> > kzalloc_node() in alloc_{fair,rt}_sched_group() to do 
> > kzalloc(..., cpu_online(cpu) ? cpu_to_node(cpu) : NUMA_NO_NODE).
> 
> That's a confusing statement, the wakeup stuff and the
> alloc_{fair,rt}_sched_group() stuff are unrelated, although both sites
> might need fixing if we're going to go ahead with this.
> 

The alternative is for node hot-remove to do an iteration of all possible 
cpus and set cpu-to-node to be NUMA_NO_NODE for all offlined cpus that map 
to that node.  If cpu_online() is true for any of those cpus, then 
obviously it can't be offlined.  We want to do this so that 
kzalloc_node(..., cpu_to_node()) fallsback to allocating from any node, 
which it should, and because a subsequent node hot-add event that reuses 
the same node id may not be the same node.
