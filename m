Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab2JIIkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 04:40:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18711 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab2JIIkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 04:40:41 -0400
X-IronPort-AV: E=Sophos;i="4.80,560,1344182400"; 
   d="scan'208";a="5968200"
Message-ID: <5073E2BF.9050306@cn.fujitsu.com>
Date: Tue, 09 Oct 2012 16:39:27 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>, David Rientjes <rientjes@google.com>
CC: mingo@redhat.com, peterz@infradead.org, miaox@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org
Subject: Re: [PATCH] Do not use cpu_to_node() to find an offlined cpu's node.
References: <1349665183-11718-1-git-send-email-tangchen@cn.fujitsu.com> <alpine.DEB.2.00.1210082308230.360@chino.kir.corp.google.com> <5073E18A.2090203@cn.fujitsu.com>
In-Reply-To: <5073E18A.2090203@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/09 16:40:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/09 16:40:29,
	Serialize complete at 2012/10/09 16:40:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thanks for reviewing this patch. :)

On 10/09/2012 04:34 PM, Wen Congyang wrote:
> At 10/09/2012 02:21 PM, David Rientjes Wrote:
>> On Mon, 8 Oct 2012, Tang Chen wrote:
>>> +	/* If the cpu has been offlined, its nid was set to -1. */
>>> +	if (nid != -1) {
>>
>> NUMA_NO_NODE.

Yes, NUMA_NO_NODE is better. I'll improve it, thanks. :)

>>
>> Eek, the nid shouldn't be -1 yet, though, for cpu hotplug since this
>> should be called at CPU_DYING level and migrate_tasks() still sees a valid
>> cpu.

As Wen said below, nid is now set to -1 when cpu is hotremoved.
I reproduce this problem in this situation:

all cpus are online, and hot remove a system board directorily, without
offlining any cpu.

As a result, the removed cpu's nid is set to -1, and this causes
problems.

>
> the cpu's node is set when the cpu is hotpluged(not online), and it will
> be cleared when the cpu is hotremoved(This patch is in akpm tree):
> https://lkml.org/lkml/2012/9/3/39
>
> I guess the task is in sleep state when the cpu is offlined, and it doesn't
> be migrated to another cpu.
>
> Thanks
> Wen Congyang
>
>>
>> On x86, cpumask_of_node() is always guaranteed to return a valid cpumask
>> after boot so presumably this is a problem in some non-x86 arch code and
>> isn't actually a sched problem.

BTW, my box is x86. I think for the reason I said above,
cpumask_of_node() will no longer guaranteed anything even if on x86.

Thanks. :)

>>
>>> +		nodemask = cpumask_of_node(nid);
>>> +
>>> +		/* Look for allowed, online CPU in same node. */
>>> +		for_each_cpu(dest_cpu, nodemask) {
>>> +			if (!cpu_online(dest_cpu))
>>> +				continue;
>>> +			if (!cpu_active(dest_cpu))
>>> +				continue;
>>> +			if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
>>> +				return dest_cpu;
>>> +		}
>>>   	}
>>>
>>>   	for (;;) {
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

