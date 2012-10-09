Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab2JIX1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 19:27:08 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36573 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756946Ab2JIX1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 19:27:03 -0400
Date: Tue, 9 Oct 2012 16:27:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Tang Chen <tangchen@cn.fujitsu.com>, mingo@redhat.com,
        miaox@cn.fujitsu.com, wency@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's
 node.
In-Reply-To: <1349815676.7880.85.camel@twins>
Message-ID: <alpine.DEB.2.00.1210091617260.10143@chino.kir.corp.google.com>
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com> <1349780256.7880.12.camel@twins> <alpine.DEB.2.00.1210091328030.32588@chino.kir.corp.google.com> <1349815676.7880.85.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012, Peter Zijlstra wrote:

> Well the code they were patching is in the wakeup path. As I think Tang
> said, we leave !runnable tasks on whatever cpu they ran on last, even if
> that cpu is offlined, we try and fix up state when we get a wakeup.
> 
> On wakeup, it tries to find a cpu to run on and will try a cpu of the
> same node first.
> 
> Now if that node's entirely gone away, it appears the cpu_to_node() map
> will not return a valid node number.
> 
> I think that's a change in behaviour, it didn't used to do that afaik.
> Certainly this code hasn't change in a while.
> 

If cpu_to_node() always returns a valid node id even if all cpus on the 
node are offline, then the cpumask_of_node() implementation, which the 
sched code is using, should either return an empty cpumask (if 
node_to_cpumask_map[nid] isn't freed) or cpu_online_mask.  The change in 
behavior here occurred because 
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch in -mm doesn't 
return a valid node id and forces it to return -1 so a kzalloc_node(..., 
-1) fallsback to allocate anywhere.

But if you only need cpu_to_node() when waking up to find a runnable cpu 
for this NUMA information, then I think you can just change the 
kzalloc_node() in alloc_{fair,rt}_sched_group() to do 
kzalloc(..., cpu_online(cpu) ? cpu_to_node(cpu) : NUMA_NO_NODE).

 [ The changelog here is confusing because it's fixing a problem in 
   linux-next without saying so. ]
