Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab2JJDmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 23:42:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50147 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab2JJDmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 23:42:40 -0400
X-IronPort-AV: E=Sophos;i="4.80,564,1344182400"; 
   d="scan'208";a="5972830"
Message-ID: <5074EFFD.4050906@cn.fujitsu.com>
Date: Wed, 10 Oct 2012 11:48:13 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Tang Chen <tangchen@cn.fujitsu.com>,
        mingo@redhat.com, miaox@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-numa@vger.kernel.org
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's node.
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com> <1349780256.7880.12.camel@twins> <alpine.DEB.2.00.1210091328030.32588@chino.kir.corp.google.com> <1349815676.7880.85.camel@twins> <alpine.DEB.2.00.1210091617260.10143@chino.kir.corp.google.com> <5074D824.6020204@cn.fujitsu.com>
In-Reply-To: <5074D824.6020204@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/10 11:42:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/10 11:42:29,
	Serialize complete at 2012/10/10 11:42:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/10/2012 10:06 AM, Wen Congyang Wrote:
> At 10/10/2012 07:27 AM, David Rientjes Wrote:
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
>>
>> But if you only need cpu_to_node() when waking up to find a runnable cpu 
>> for this NUMA information, then I think you can just change the 
>> kzalloc_node() in alloc_{fair,rt}_sched_group() to do 
>> kzalloc(..., cpu_online(cpu) ? cpu_to_node(cpu) : NUMA_NO_NODE).
>>
>>  [ The changelog here is confusing because it's fixing a problem in 
>>    linux-next without saying so. ]
>>
> 
> I don't agree with this way. Because it only fix the code which causes a
> problem, and we can't say there is no any similar problem. So it is
> why I clear the cpu-to-node mapping.
> 
> What about the following solution:
> 1. clear the cpu-to-node mapping when the node is offlined

There is no interface to online/offline a node. We online a node only
when the cpu/memory is node, and offline it when all cpu/memory in
this node is offlined(TODO).

So we may need to map cpu-to-node when the cpu is onlined if clear
it when the node is offlined. But we don't know the cpu's node.

Thanks
Wen Congyang

> 2. tang's patch is still necessary because we leave !runnable tasks on
>    whatever cpu they ran on last. If cpu's node is NUMA_NO_NODE, it means
>    the entire node is offlined, and we must migrate the task to the other
>    node.
> 
> Thanks
> Wen Congyang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-numa" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

