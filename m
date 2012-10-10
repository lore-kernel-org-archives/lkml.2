Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2JJJKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:10:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:39063 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2JJJKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:10:33 -0400
Message-ID: <1349860216.7880.105.camel@twins>
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's node.
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, mingo@redhat.com,
        miaox@cn.fujitsu.com, wency@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org
Date: Wed, 10 Oct 2012 11:10:16 +0200
In-Reply-To: <alpine.DEB.2.00.1210091617260.10143@chino.kir.corp.google.com>
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1349780256.7880.12.camel@twins>
	 <alpine.DEB.2.00.1210091328030.32588@chino.kir.corp.google.com>
	 <1349815676.7880.85.camel@twins>
	 <alpine.DEB.2.00.1210091617260.10143@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 16:27 -0700, David Rientjes wrote:
> On Tue, 9 Oct 2012, Peter Zijlstra wrote:
> 
> > Well the code they were patching is in the wakeup path. As I think Tang
> > said, we leave !runnable tasks on whatever cpu they ran on last, even if
> > that cpu is offlined, we try and fix up state when we get a wakeup.
> > 
> > On wakeup, it tries to find a cpu to run on and will try a cpu of the
> > same node first.
> > 
> > Now if that node's entirely gone away, it appears the cpu_to_node() map
> > will not return a valid node number.
> > 
> > I think that's a change in behaviour, it didn't used to do that afaik.
> > Certainly this code hasn't change in a while.
> > 
> 
> If cpu_to_node() always returns a valid node id even if all cpus on the 
> node are offline, then the cpumask_of_node() implementation, which the 
> sched code is using, should either return an empty cpumask (if 
> node_to_cpumask_map[nid] isn't freed) or cpu_online_mask.  The change in 
> behavior here occurred because 
> cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch in -mm doesn't 
> return a valid node id and forces it to return -1 so a kzalloc_node(..., 
> -1) fallsback to allocate anywhere.

I think that's broken semantics.. so far the entire cpu<->node mapping
was invariant during hotplug. Changing that is going to be _very_
interesting and cannot be done lightly.

Because as I said, per-cpu memory is preserved over hotplug, and that
has numa affinity.

So for now, let me NACK that patch. You cannot go change stuff like
that.

> 
> But if you only need cpu_to_node() when waking up to find a runnable cpu 
> for this NUMA information, then I think you can just change the 
> kzalloc_node() in alloc_{fair,rt}_sched_group() to do 
> kzalloc(..., cpu_online(cpu) ? cpu_to_node(cpu) : NUMA_NO_NODE).

That's a confusing statement, the wakeup stuff and the
alloc_{fair,rt}_sched_group() stuff are unrelated, although both sites
might need fixing if we're going to go ahead with this.
