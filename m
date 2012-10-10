Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab2JJJ2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:28:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63073 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753822Ab2JJJ2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:28:08 -0400
X-IronPort-AV: E=Sophos;i="4.80,565,1344182400"; 
   d="scan'208";a="5976416"
Message-ID: <507540F5.7040501@cn.fujitsu.com>
Date: Wed, 10 Oct 2012 17:33:41 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: David Rientjes <rientjes@google.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        mingo@redhat.com, miaox@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-numa@vger.kernel.org
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's node.
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com>	 <1349780256.7880.12.camel@twins>	 <alpine.DEB.2.00.1210091328030.32588@chino.kir.corp.google.com>	 <1349815676.7880.85.camel@twins>	 <alpine.DEB.2.00.1210091617260.10143@chino.kir.corp.google.com> <1349860216.7880.105.camel@twins>
In-Reply-To: <1349860216.7880.105.camel@twins>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/10 17:27:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/10 17:27:56,
	Serialize complete at 2012/10/10 17:27:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/10/2012 05:10 PM, Peter Zijlstra Wrote:
> On Tue, 2012-10-09 at 16:27 -0700, David Rientjes wrote:
>> On Tue, 9 Oct 2012, Peter Zijlstra wrote:
>>
>>> Well the code they were patching is in the wakeup path. As I think Tang
>>> said, we leave !runnable tasks on whatever cpu they ran on last, even if
>>> that cpu is offlined, we try and fix up state when we get a wakeup.
>>>
>>> On wakeup, it tries to find a cpu to run on and will try a cpu of the
>>> same node first.
>>>
>>> Now if that node's entirely gone away, it appears the cpu_to_node() map
>>> will not return a valid node number.
>>>
>>> I think that's a change in behaviour, it didn't used to do that afaik.
>>> Certainly this code hasn't change in a while.
>>>
>>
>> If cpu_to_node() always returns a valid node id even if all cpus on the 
>> node are offline, then the cpumask_of_node() implementation, which the 
>> sched code is using, should either return an empty cpumask (if 
>> node_to_cpumask_map[nid] isn't freed) or cpu_online_mask.  The change in 
>> behavior here occurred because 
>> cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved.patch in -mm doesn't 
>> return a valid node id and forces it to return -1 so a kzalloc_node(..., 
>> -1) fallsback to allocate anywhere.
> 
> I think that's broken semantics.. so far the entire cpu<->node mapping
> was invariant during hotplug. Changing that is going to be _very_
> interesting and cannot be done lightly.
> 
> Because as I said, per-cpu memory is preserved over hotplug, and that
> has numa affinity.

Hmm, if per-cpu memory is preserved, and we can't offline and remove
this memory. So we can't offline the node.

But, if the node is hot added, and per-cpu memory doesn't use the
memory on this node. We can hotremove cpu/memory on this node, and then
offline this node.

Before the cpu is hotadded, cpu's node is -1. We set cpu<->node mapping
when it is hotadded. So the entire cpu<->node mapping was not invariant
during hotplug.

So it is why I try to clear it when the cpu is hot-removed.

As we need the mapping to migrate a task to the cpu on the same node first,
I think we can clear the mapping when the node is offlined.

Thanks
Wen Congyang

> 
> So for now, let me NACK that patch. You cannot go change stuff like
> that.
> 
>>
>> But if you only need cpu_to_node() when waking up to find a runnable cpu 
>> for this NUMA information, then I think you can just change the 
>> kzalloc_node() in alloc_{fair,rt}_sched_group() to do 
>> kzalloc(..., cpu_online(cpu) ? cpu_to_node(cpu) : NUMA_NO_NODE).
> 
> That's a confusing statement, the wakeup stuff and the
> alloc_{fair,rt}_sched_group() stuff are unrelated, although both sites
> might need fixing if we're going to go ahead with this.
> 

